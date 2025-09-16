#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1278 "Exp. User Feedback Gen. Jnl."
{
    Permissions = TableData "Payment Export Data"=rimd;
    TableNo = "Data Exch.";

    trigger OnRun()
    var
        CreditTransferRegister: Record "Credit Transfer Register";
        GenJnlLine: Record "Gen. Journal Line";
        PaymentExportData: Record "Payment Export Data";
    begin
        GenJnlLine.SetRange("Data Exch. Entry No.","Entry No.");
        GenJnlLine.FindFirst;

        CreditTransferRegister.SetRange("From Bank Account No.",GenJnlLine."Bal. Account No.");
        CreditTransferRegister.FindLast;
        SetFileOnCreditTransferRegister(Rec,CreditTransferRegister);
        SetExportFlagOnGenJnlLine(GenJnlLine);

        PaymentExportData.SetRange("Data Exch Entry No.","Entry No.");
        PaymentExportData.DeleteAll(true);
    end;

    local procedure SetFileOnCreditTransferRegister(DataExch: Record "Data Exch.";var CreditTransferRegister: Record "Credit Transfer Register")
    begin
        CreditTransferRegister.SetStatus(CreditTransferRegister.Status::"File Created");
        CreditTransferRegister.SetFileContent(DataExch);
    end;


    procedure SetExportFlagOnGenJnlLine(var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        GenJnlLine2.CopyFilters(GenJnlLine);
        if GenJnlLine2.FindSet then
          repeat
            case GenJnlLine2."Account Type" of
              GenJnlLine2."account type"::Vendor:
                SetExportFlagOnAppliedVendorLedgerEntry(GenJnlLine2);
              GenJnlLine2."account type"::Customer:
                SetExportFlagOnAppliedCustLedgerEntry(GenJnlLine2);
            end;
            GenJnlLine2.Validate("Exported to Payment File",true);
            GenJnlLine2.Modify(true);
          until GenJnlLine2.Next = 0;
    end;

    local procedure SetExportFlagOnAppliedVendorLedgerEntry(GenJnlLine: Record "Gen. Journal Line")
    var
        VendLedgerEntry: Record "Vendor Ledger Entry";
    begin
        if GenJnlLine.IsApplied then begin
          VendLedgerEntry.SetRange("Vendor No.",GenJnlLine."Account No.");

          if GenJnlLine."Applies-to Doc. No." <> '' then begin
            VendLedgerEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
            VendLedgerEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
          end;

          if GenJnlLine."Applies-to ID" <> '' then
            VendLedgerEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");

          if VendLedgerEntry.FindSet then
            repeat
              VendLedgerEntry.Validate("Exported to Payment File",true);
              Codeunit.Run(Codeunit::"Vend. Entry-Edit",VendLedgerEntry);
            until VendLedgerEntry.Next = 0;
        end;

        VendLedgerEntry.Reset;
        VendLedgerEntry.SetRange("Vendor No.",GenJnlLine."Account No.");
        VendLedgerEntry.SetRange("Applies-to Doc. Type",GenJnlLine."Document Type");
        VendLedgerEntry.SetRange("Applies-to Doc. No.",GenJnlLine."Document No.");
        if VendLedgerEntry.FindSet then
          repeat
            VendLedgerEntry.Validate("Exported to Payment File",true);
            Codeunit.Run(Codeunit::"Vend. Entry-Edit",VendLedgerEntry);
          until VendLedgerEntry.Next = 0;
    end;

    local procedure SetExportFlagOnAppliedCustLedgerEntry(GenJnlLine: Record "Gen. Journal Line")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        if GenJnlLine.IsApplied then begin
          CustLedgerEntry.SetRange("Customer No.",GenJnlLine."Account No.");

          if GenJnlLine."Applies-to Doc. No." <> '' then begin
            CustLedgerEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
            CustLedgerEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
          end;

          if GenJnlLine."Applies-to ID" <> '' then
            CustLedgerEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");

          if CustLedgerEntry.FindSet then
            repeat
              CustLedgerEntry.Validate("Exported to Payment File",true);
              Codeunit.Run(Codeunit::"Cust. Entry-Edit",CustLedgerEntry);
            until CustLedgerEntry.Next = 0;
        end;

        CustLedgerEntry.Reset;
        CustLedgerEntry.SetRange("Customer No.",GenJnlLine."Account No.");
        CustLedgerEntry.SetRange("Applies-to Doc. Type",GenJnlLine."Document Type");
        CustLedgerEntry.SetRange("Applies-to Doc. No.",GenJnlLine."Document No.");

        if CustLedgerEntry.FindSet then
          repeat
            CustLedgerEntry.Validate("Exported to Payment File",true);
            Codeunit.Run(Codeunit::"Cust. Entry-Edit",CustLedgerEntry);
          until CustLedgerEntry.Next = 0;
    end;
}

