#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 16 "Gen. Jnl.-Show CT Entries"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        if not ("Document Type" in ["document type"::Payment,"document type"::Refund]) then
          exit;
        if not ("Account Type" in ["account type"::Customer,"account type"::Vendor]) then
          exit;

        SetFiltersOnCreditTransferEntry(Rec,CreditTransferEntry);

        Page.Run(Page::"Credit Transfer Reg. Entries",CreditTransferEntry);
    end;

    var
        CreditTransferEntry: Record "Credit Transfer Entry";


    procedure SetFiltersOnCreditTransferEntry(var GenJournalLine: Record "Gen. Journal Line";var CreditTransferEntry: Record "Credit Transfer Entry")
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        FoundCorrespondingLedgerEntry: Boolean;
    begin
        with GenJournalLine do begin
          CreditTransferEntry.Reset;
          FoundCorrespondingLedgerEntry := false;
          case "Account Type" of
            "account type"::Vendor:
              begin
                CreditTransferEntry.SetRange("Account Type",CreditTransferEntry."account type"::Vendor);
                if "Applies-to Doc. No." <> '' then begin
                  VendorLedgerEntry.SetRange("Document Type","Applies-to Doc. Type");
                  VendorLedgerEntry.SetRange("Document No.","Applies-to Doc. No.");
                  if VendorLedgerEntry.FindFirst then begin
                    CreditTransferEntry.SetRange("Applies-to Entry No.",VendorLedgerEntry."Entry No.");
                    FoundCorrespondingLedgerEntry := true;
                  end;
                end;
              end;
            "account type"::Customer:
              begin
                CreditTransferEntry.SetRange("Account Type",CreditTransferEntry."account type"::Customer);
                if "Applies-to Doc. No." <> '' then begin
                  CustLedgerEntry.SetRange("Document Type","Applies-to Doc. Type");
                  CustLedgerEntry.SetRange("Document No.","Applies-to Doc. No.");
                  if CustLedgerEntry.FindFirst then begin
                    CreditTransferEntry.SetRange("Applies-to Entry No.",CustLedgerEntry."Entry No.");
                    FoundCorrespondingLedgerEntry := true;
                  end;
                end;
              end;
          end;
          CreditTransferEntry.SetRange("Account No.","Account No.");
          if not FoundCorrespondingLedgerEntry then
            CreditTransferEntry.SetRange("Applies-to Entry No.",0);
          GeneralLedgerSetup.Get;
          CreditTransferEntry.SetFilter(
            "Currency Code",'''%1''|''%2''',"Currency Code",GeneralLedgerSetup.GetCurrencyCode("Currency Code"));
          CreditTransferEntry.SetRange(Canceled,false);
        end;
    end;
}

