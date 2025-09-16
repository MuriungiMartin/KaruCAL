#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5346 "CRM Sales Document Posting Mgt"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        CRMSalesOrderId: Guid;
        CRMDocumentHasBeenPostedMsg: label '%1 ''%2'' has been posted.', Comment='%1=Document Type;%2=Document Id';

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]

    procedure SetCRMSalesOrderIdOnSalesHeaderDeletion(var Rec: Record "Sales Header";RunTrigger: Boolean)
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if (Rec."Document Type" <> Rec."document type"::Order) or
           (Rec.Status = Rec.Status::Open) or
           RunTrigger // RunTrigger is expected to be FALSE on removal of Sales Order Header on posting
        then
          exit;
        if not CRMIntegrationManagement.IsCRMIntegrationEnabled then
          exit;

        if not CRMIntegrationRecord.FindIDFromRecordID(Rec.RecordId,CRMSalesOrderId) then
          Clear(CRMSalesOrderId);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]

    procedure PostCRMSalesDocumentOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";SalesShptHdrNo: Code[20];RetRcpHdrNo: Code[20];SalesInvHdrNo: Code[20];SalesCrMemoHdrNo: Code[20])
    begin
        if not CRMIntegrationManagement.IsCRMIntegrationEnabled then
          exit;

        AddPostedSalesDocumentToCRMAccountWall(SalesHeader);

        if not IsNullGuid(CRMSalesOrderId) then // Should be set by SetOrderOnSalesHeaderDeletion
          SetCRMSalesOrderStateAsInvoiced;
    end;

    local procedure AddPostedSalesDocumentToCRMAccountWall(SalesHeader: Record "Sales Header")
    var
        Customer: Record Customer;
        CRMSetupDefaults: Codeunit "CRM Setup Defaults";
    begin
        if not CRMSetupDefaults.GetAddPostedSalesDocumentToCRMAccountWallConfig then
          exit;
        if SalesHeader."Document Type" in [SalesHeader."document type"::Order,SalesHeader."document type"::Invoice] then begin
          Customer.Get(SalesHeader."Sell-to Customer No.");
          AddPostToCRMEntityWall(
            Customer.RecordId,StrSubstNo(CRMDocumentHasBeenPostedMsg,SalesHeader."Document Type",SalesHeader."No."));
        end;
    end;

    local procedure AddPostToCRMEntityWall(TargetRecordID: RecordID;Message: Text)
    var
        CRMPost: Record "CRM Post";
        EntityID: Guid;
        EntityTypeName: Text;
    begin
        if not GetCRMEntityIdAndTypeName(TargetRecordID,EntityID,EntityTypeName) then
          exit;

        Clear(CRMPost);
        Evaluate(CRMPost.RegardingObjectTypeCode,EntityTypeName);
        CRMPost.RegardingObjectId := EntityID;
        CRMPost.Text := CopyStr(Message,1,MaxStrLen(CRMPost.Text));
        CRMPost.Source := CRMPost.Source::AutoPost;
        CRMPost.Type := CRMPost.Type::Status;
        CRMPost.Insert;
    end;

    local procedure GetCRMEntityIdAndTypeName(DestinationRecordID: RecordID;var EntityID: Guid;var EntityTypeName: Text): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        if not CRMIntegrationRecord.FindIDFromRecordID(DestinationRecordID,EntityID) then
          exit(false);

        EntityTypeName := CRMIntegrationManagement.GetCRMEntityTypeName(DestinationRecordID.TableNo);
        exit(true);
    end;

    local procedure SetCRMSalesOrderStateAsInvoiced()
    var
        CRMSalesorder: Record "CRM Salesorder";
    begin
        CRMSalesorder.Get(CRMSalesOrderId);
        CRMSalesorder.StateCode := CRMSalesorder.Statecode::Invoiced;
        CRMSalesorder.StatusCode := CRMSalesorder.Statuscode::Invoiced;
        CRMSalesorder.Modify;

        Clear(CRMSalesOrderId);
    end;
}

