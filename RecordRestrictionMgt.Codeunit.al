#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1550 "Record Restriction Mgt."
{
    Permissions = TableData "Restricted Record"=rimd;

    trigger OnRun()
    begin
    end;

    var
        RecordRestrictedTxt: label 'You cannot use %1 for this action.', Comment='You cannot use Customer 10000 for this action.';
        RestrictLineUsageDetailsTxt: label 'The restriction was imposed because the line requires approval.';
        RestrictBatchUsageDetailsTxt: label 'The restriction was imposed because the journal batch requires approval.';


    procedure RestrictRecordUsage(RecID: RecordID;RestrictionDetails: Text)
    var
        RestrictedRecord: Record "Restricted Record";
        RecRef: RecordRef;
    begin
        if not RecRef.Get(RecID) then
          exit;

        RestrictedRecord.SetRange("Record ID",RecID);
        if RestrictedRecord.FindFirst then begin
          RestrictedRecord.Details := CopyStr(RestrictionDetails,1,MaxStrLen(RestrictedRecord.Details));
          RestrictedRecord.Modify(true);
        end else begin
          RestrictedRecord.Init;
          RestrictedRecord."Record ID" := RecID;
          RestrictedRecord.Details := CopyStr(RestrictionDetails,1,MaxStrLen(RestrictedRecord.Details));
          RestrictedRecord.Insert(true);
        end;
    end;


    procedure AllowGenJournalBatchUsage(GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        AllowRecordUsage(GenJournalBatch.RecordId);

        GenJournalLine.SetRange("Journal Template Name",GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name",GenJournalBatch.Name);
        if GenJournalLine.FindSet then
          repeat
            AllowRecordUsage(GenJournalLine.RecordId);
          until GenJournalLine.Next = 0;
    end;


    procedure AllowRecordUsage(RecID: RecordID)
    var
        RestrictedRecord: Record "Restricted Record";
    begin
        RestrictedRecord.SetRange("Record ID",RecID);
        RestrictedRecord.DeleteAll(true);
    end;

    local procedure UpdateRestriction(RecID: RecordID;xRecID: RecordID)
    var
        RestrictedRecord: Record "Restricted Record";
    begin
        RestrictedRecord.SetRange("Record ID",xRecID);
        RestrictedRecord.ModifyAll("Record ID",RecID);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterInsertEvent', '', false, false)]

    procedure RestrictGenJournalLineAfterInsert(var Rec: Record "Gen. Journal Line";RunTrigger: Boolean)
    begin
        RestrictGenJournalLine(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterModifyEvent', '', false, false)]

    procedure RestrictGenJournalLineAfterModify(var Rec: Record "Gen. Journal Line";var xRec: Record "Gen. Journal Line";RunTrigger: Boolean)
    begin
        if Format(Rec) = Format(xRec) then
          exit;
        RestrictGenJournalLine(Rec);
    end;

    local procedure RestrictGenJournalLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        if GenJournalLine."System-Created Entry" or GenJournalLine.IsTemporary then
          exit;

        if ApprovalsMgmt.IsGeneralJournalLineApprovalsWorkflowEnabled(GenJournalLine) then
          RestrictRecordUsage(GenJournalLine.RecordId,RestrictLineUsageDetailsTxt);

        if GenJournalBatch.Get(GenJournalLine."Journal Template Name",GenJournalLine."Journal Batch Name") then
          if ApprovalsMgmt.IsGeneralJournalBatchApprovalsWorkflowEnabled(GenJournalBatch) then
            RestrictRecordUsage(GenJournalLine.RecordId,RestrictBatchUsageDetailsTxt);
    end;

    local procedure CheckGenJournalBatchHasUsageRestrictions(GenJournalBatch: Record "Gen. Journal Batch")
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        CheckRecordHasUsageRestrictions(GenJournalBatch.RecordId);

        GenJournalLine.SetRange("Journal Template Name",GenJournalBatch."Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name",GenJournalBatch.Name);
        if GenJournalLine.FindSet then
          repeat
            CheckRecordHasUsageRestrictions(GenJournalLine.RecordId);
          until GenJournalLine.Next = 0;
    end;

    [TryFunction]

    procedure CheckRecordHasUsageRestrictions(RecID: RecordID)
    var
        RestrictedRecord: Record "Restricted Record";
        ErrorMessage: Text;
    begin
        RestrictedRecord.SetRange("Record ID",RecID);
        if not RestrictedRecord.FindFirst then
          exit;

        ErrorMessage := StrSubstNo(RecordRestrictedTxt,
            Format(Format(RestrictedRecord."Record ID",0,1))) + '\\' + RestrictedRecord.Details;
        //ERROR(ErrorMessage);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckSalesPostRestrictions', '', false, false)]

    procedure CustomerCheckSalesPostRestrictions(var Sender: Record "Sales Header")
    var
        Customer: Record Customer;
    begin
        Customer.Get(Sender."Sell-to Customer No.");
        CheckRecordHasUsageRestrictions(Customer.RecordId);
        if Sender."Sell-to Customer No." = Sender."Bill-to Customer No." then
          exit;
        Customer.Get(Sender."Bill-to Customer No.");
        CheckRecordHasUsageRestrictions(Customer.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCheckPurchasePostRestrictions', '', false, false)]

    procedure VendorCheckPurchasePostRestrictions(var Sender: Record "Purchase Header")
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(Sender."Buy-from Vendor No.");
        CheckRecordHasUsageRestrictions(Vendor.RecordId);
        if Sender."Buy-from Vendor No." = Sender."Pay-to Vendor No." then
          exit;
        Vendor.Get(Sender."Pay-to Vendor No.");
        CheckRecordHasUsageRestrictions(Vendor.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]

    procedure CustomerCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    var
        Customer: Record Customer;
    begin
        if (Sender."Account Type" = Sender."account type"::Customer) and (Sender."Account No." <> '') then begin
          Customer.Get(Sender."Account No.");
          CheckRecordHasUsageRestrictions(Customer.RecordId);
        end;

        if (Sender."Bal. Account Type" = Sender."bal. account type"::Customer) and (Sender."Bal. Account No." <> '') then begin
          Customer.Get(Sender."Bal. Account No.");
          CheckRecordHasUsageRestrictions(Customer.RecordId);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]

    procedure VendorCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
    begin
        if (Sender."Account Type" = Sender."account type"::Vendor) and (Sender."Account No." <> '') then begin
          Vendor.Get(Sender."Account No.");
          CheckRecordHasUsageRestrictions(Vendor.RecordId);
        end;

        if (Sender."Bal. Account Type" = Sender."bal. account type"::Vendor) and (Sender."Bal. Account No." <> '') then begin
          Vendor.Get(Sender."Bal. Account No.");
          CheckRecordHasUsageRestrictions(Vendor.RecordId);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]

    procedure GenJournalLineCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePrintCheckRestrictions', '', false, false)]

    procedure GenJournalLineCheckGenJournalLinePrintCheckRestrictions(var Sender: Record "Gen. Journal Line")
    begin
        if Sender."Bank Payment Type" = Sender."bank payment type"::"Computer Check" then
          CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Check Ledger Entry", 'OnBeforeInsertEvent', '', false, false)]

    procedure CheckPrintRestrictionsBeforeInsertCheckLedgerEntry(var Rec: Record "Check Ledger Entry";RunTrigger: Boolean)
    var
        RecordIdToPrint: RecordID;
    begin
        RecordIdToPrint := Rec."Record ID to Print";
        CheckRecordHasUsageRestrictions(RecordIdToPrint);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Check Ledger Entry", 'OnBeforeModifyEvent', '', false, false)]

    procedure CheckPrintRestrictionsBeforeModifyCheckLedgerEntry(var Rec: Record "Check Ledger Entry";var xRec: Record "Check Ledger Entry";RunTrigger: Boolean)
    var
        RecordIdToPrint: RecordID;
    begin
        RecordIdToPrint := Rec."Record ID to Print";
        CheckRecordHasUsageRestrictions(RecordIdToPrint);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnCheckGenJournalLinePostRestrictions', '', false, false)]

    procedure GenJournalBatchCheckGenJournalLinePostRestrictions(var Sender: Record "Gen. Journal Line")
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        if GenJournalBatch.Get(Sender."Journal Template Name",Sender."Journal Batch Name") then
          CheckRecordHasUsageRestrictions(GenJournalBatch.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnCheckGenJournalLineExportRestrictions', '', false, false)]

    procedure GenJournalBatchCheckGenJournalLineExportRestrictions(var Sender: Record "Gen. Journal Batch")
    begin
        if not Sender."Allow Payment Export" then
          exit;

        CheckGenJournalBatchHasUsageRestrictions(Sender);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckSalesPostRestrictions', '', false, false)]

    procedure SalesHeaderCheckSalesPostRestrictions(var Sender: Record "Sales Header")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCheckSalesReleaseRestrictions', '', false, false)]

    procedure SalesHeaderCheckSalesReleaseRestrictions(var Sender: Record "Sales Header")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCheckPurchasePostRestrictions', '', false, false)]

    procedure PurchaseHeaderCheckPurchasePostRestrictions(var Sender: Record "Purchase Header")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnCheckPurchaseReleaseRestrictions', '', false, false)]

    procedure PurchaseHeaderCheckPurchaseReleaseRestrictions(var Sender: Record "Purchase Header")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', false, false)]

    procedure RemoveCustomerRestrictionsBeforeDelete(var Rec: Record Customer;RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnBeforeDeleteEvent', '', false, false)]

    procedure RemoveVendorRestrictionsBeforeDelete(var Rec: Record Vendor;RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnBeforeDeleteEvent', '', false, false)]

    procedure RemoveItemRestrictionsBeforeDelete(var Rec: Record Item;RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnBeforeDeleteEvent', '', false, false)]

    procedure RemoveGenJournalLineRestrictionsBeforeDelete(var Rec: Record "Gen. Journal Line";RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnBeforeDeleteEvent', '', false, false)]

    procedure RemoveGenJournalBatchRestrictionsBeforeDelete(var Rec: Record "Gen. Journal Batch";RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeDeleteEvent', '', false, false)]

    procedure RemoveSalesHeaderRestrictionsBeforeDelete(var Rec: Record "Sales Header";RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeDeleteEvent', '', false, false)]

    procedure RemovePurchaseHeaderRestrictionsBeforeDelete(var Rec: Record "Purchase Header";RunTrigger: Boolean)
    begin
        AllowRecordUsage(Rec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterRenameEvent', '', false, false)]

    procedure UpdateGenJournalLineRestrictionsAfterRename(var Rec: Record "Gen. Journal Line";var xRec: Record "Gen. Journal Line";RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec.RecordId,xRec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnCheckIncomingDocSetForOCRRestrictions', '', false, false)]

    procedure IncomingDocCheckSetForOCRRestrictions(var Sender: Record "Incoming Document")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnCheckIncomingDocReleaseRestrictions', '', false, false)]

    procedure IncomingDocCheckReleaseRestrictions(var Sender: Record "Incoming Document")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Batch", 'OnAfterRenameEvent', '', false, false)]

    procedure UpdateGenJournalBatchRestrictionsAfterRename(var Rec: Record "Gen. Journal Batch";var xRec: Record "Gen. Journal Batch";RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec.RecordId,xRec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterRenameEvent', '', false, false)]

    procedure UpdateSalesHeaderRestrictionsAfterRename(var Rec: Record "Sales Header";var xRec: Record "Sales Header";RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec.RecordId,xRec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterRenameEvent', '', false, false)]

    procedure UpdatePurchaseHeaderRestrictionsAfterRename(var Rec: Record "Purchase Header";var xRec: Record "Purchase Header";RunTrigger: Boolean)
    begin
        UpdateRestriction(Rec.RecordId,xRec.RecordId);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Incoming Document", 'OnCheckIncomingDocCreateDocRestrictions', '', false, false)]

    procedure IncomingDocCheckCreateDocRestrictions(var Sender: Record "Incoming Document")
    begin
        CheckRecordHasUsageRestrictions(Sender.RecordId);
    end;
}

