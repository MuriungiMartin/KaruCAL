#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5971 "Service Header Apply"
{
    TableNo = "Service Header";

    trigger OnRun()
    begin
        ServHeader.Copy(Rec);
        with ServHeader do begin
          BilToCustNo := "Bill-to Customer No." ;
          CustLedgEntry.SetCurrentkey("Customer No.",Open);
          CustLedgEntry.SetRange("Customer No.",BilToCustNo);
          CustLedgEntry.SetRange(Open,true);
          if "Applies-to ID" = '' then
            "Applies-to ID" := "No.";
          if "Applies-to ID" = '' then
            Error(
              Text000,
              FieldCaption("No."),FieldCaption("Applies-to ID"));
          ApplyCustEntries.SetService(ServHeader,CustLedgEntry,FieldNo("Applies-to ID"));
          ApplyCustEntries.SetRecord(CustLedgEntry);
          ApplyCustEntries.SetTableview(CustLedgEntry);
          ApplyCustEntries.LookupMode(true);
          OK := ApplyCustEntries.RunModal = Action::LookupOK;
          Clear(ApplyCustEntries);
          if not OK then
            exit;
          CustLedgEntry.Reset;
          CustLedgEntry.SetCurrentkey("Customer No.",Open);
          CustLedgEntry.SetRange("Customer No.",BilToCustNo);
          CustLedgEntry.SetRange(Open,true);
          CustLedgEntry.SetRange("Applies-to ID","Applies-to ID");
          if CustLedgEntry.FindFirst then begin
            "Applies-to Doc. Type" := 0;
            "Applies-to Doc. No." := '';
          end else
            "Applies-to ID" := '';

          Modify;
        end;
    end;

    var
        Text000: label 'You must specify %1 or %2.';
        ServHeader: Record "Service Header";
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyCustEntries: Page "Apply Customer Entries";
        BilToCustNo: Code[20];
        OK: Boolean;
}

