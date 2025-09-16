#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5331 "CRM Coupling Management"
{

    trigger OnRun()
    begin
    end;

    var
        RemoveCoupledContactsUnderCustomerQst: label 'The Customer and Microsoft Dynamics CRM Account have %1 child Contact records coupled to one another. Do you want to delete their couplings as well?', Comment='%1 is a number';


    procedure IsRecordCoupledToCRM(RecordID: RecordID): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        exit(CRMIntegrationRecord.IsRecordCoupled(RecordID));
    end;


    procedure IsRecordCoupledToNAV(CRMID: Guid;NAVTableID: Integer): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        NAVRecordID: RecordID;
    begin
        exit(CRMIntegrationRecord.FindRecordIDFromID(CRMID,NAVTableID,NAVRecordID));
    end;

    local procedure AssertTableIsMapped(TableID: Integer)
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
    begin
        IntegrationTableMapping.SetRange("Table ID",TableID);
        IntegrationTableMapping.FindFirst;
    end;


    procedure DefineCoupling(RecordID: RecordID;var CRMID: Guid;var CreateNew: Boolean;var Synchronize: Boolean;var Direction: Option): Boolean
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
        CouplingRecordBuffer: Record "Coupling Record Buffer";
        CRMCouplingRecord: Page "CRM Coupling Record";
    begin
        AssertTableIsMapped(RecordID.TableNo);
        CRMCouplingRecord.SetSourceRecordID(RecordID);
        if CRMCouplingRecord.RunModal = Action::OK then begin
          CRMCouplingRecord.GetRecord(CouplingRecordBuffer);
          if CouplingRecordBuffer."Create New" then
            CreateNew := true
          else
            if not IsNullGuid(CouplingRecordBuffer."CRM ID") then begin
              CRMID := CouplingRecordBuffer."CRM ID";
              CRMIntegrationRecord.CoupleRecordIdToCRMID(RecordID,CouplingRecordBuffer."CRM ID");
              if CouplingRecordBuffer.GetPerformInitialSynchronization then begin
                Synchronize := true;
                Direction := CouplingRecordBuffer.GetInitialSynchronizationDirection;
              end;
            end else
              exit(false);
          exit(true);
        end;
        exit(false);
    end;


    procedure RemoveCoupling(RecordID: RecordID)
    begin
        case RecordID.TableNo of
          Database::Customer:
            RemoveCoupledContactsForCustomer(RecordID);
        end;
        RemoveSingleCoupling(RecordID);
    end;

    local procedure RemoveSingleCoupling(RecordID: RecordID)
    var
        CRMIntegrationRecord: Record "CRM Integration Record";
    begin
        CRMIntegrationRecord.RemoveCouplingToRecord(RecordID);
    end;

    local procedure RemoveCoupledContactsForCustomer(RecordID: RecordID)
    var
        Contact: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        Customer: Record Customer;
        CRMAccount: Record "CRM Account";
        CRMContact: Record "CRM Contact";
        CRMIntegrationRecord: Record "CRM Integration Record";
        TempContact: Record Contact temporary;
        CRMID: Guid;
    begin
        // Convert the RecordID into a Customer
        Customer.Get(RecordID);

        // Get the Company Contact for this Customer
        ContBusRel.SetCurrentkey("Link to Table","No.");
        ContBusRel.SetRange("Link to Table",ContBusRel."link to table"::Customer);
        ContBusRel.SetRange("No.",Customer."No.");
        if ContBusRel.FindFirst then begin
          // Get all Person Contacts under it
          Contact.SetCurrentkey("Company Name","Company No.",Type,Name);
          Contact.SetRange("Company No.",ContBusRel."Contact No.");
          Contact.SetRange(Type,Contact.Type::Person);
          if Contact.FindSet then begin
            // Count the number of Contacts coupled to CRM Contacts under the CRM Account the Customer is coupled to
            CRMIntegrationRecord.FindIDFromRecordID(RecordID,CRMID);
            if CRMAccount.Get(CRMID) then begin
              repeat
                if CRMIntegrationRecord.FindIDFromRecordID(Contact.RecordId,CRMID) then begin
                  CRMContact.Get(CRMID);
                  if CRMContact.ParentCustomerId = CRMAccount.AccountId then begin
                    TempContact.Copy(Contact);
                    TempContact.Insert;
                  end;
                end;
              until Contact.Next = 0;

              // If any, query for breaking their couplings
              if TempContact.Count > 0 then
                if Confirm(StrSubstNo(RemoveCoupledContactsUnderCustomerQst,TempContact.Count)) then begin
                  TempContact.FindSet;
                  repeat
                    RemoveSingleCoupling(TempContact.RecordId);
                  until TempContact.Next = 0;
                end;
            end;
          end;
        end;
    end;
}

