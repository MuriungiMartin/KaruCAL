#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 14 "Gen. Jnl.-Show Entries"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        case "Account Type" of
          "account type"::"G/L Account":
            begin
              GLEntry.SetCurrentkey("G/L Account No.","Posting Date");
              GLEntry.SetRange("G/L Account No.","Account No.");
              if GLEntry.FindLast then;
              Page.Run(Page::"General Ledger Entries",GLEntry);
            end;
          "account type"::Customer:
            begin
              CustLedgEntry.SetCurrentkey("Customer No.","Posting Date");
              CustLedgEntry.SetRange("Customer No.","Account No.");
              if CustLedgEntry.FindLast then;
              Page.Run(Page::"Customer Ledger Entries",CustLedgEntry);
            end;
          "account type"::Vendor:
            begin
              VendLedgEntry.SetCurrentkey("Vendor No.","Posting Date");
              VendLedgEntry.SetRange("Vendor No.","Account No.");
              if VendLedgEntry.FindLast then;
              Page.Run(Page::"Vendor Ledger Entries",VendLedgEntry);
            end;
          "account type"::"Bank Account":
            begin
              BankAccLedgEntry.SetCurrentkey("Bank Account No.","Posting Date");
              BankAccLedgEntry.SetRange("Bank Account No.","Account No.");
              if BankAccLedgEntry.FindLast then;
              Page.Run(Page::"Bank Account Ledger Entries",BankAccLedgEntry);
            end;
          "account type"::"Fixed Asset":
            if "FA Posting Type" <> "fa posting type"::Maintenance then begin
              FALedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","FA Posting Date");
              FALedgEntry.SetRange("FA No.","Account No.");
              if "Depreciation Book Code" <> '' then
                FALedgEntry.SetRange("Depreciation Book Code","Depreciation Book Code");
              if FALedgEntry.FindLast then;
              Page.Run(Page::"FA Ledger Entries",FALedgEntry);
            end else begin
              MaintenanceLedgEntry.SetCurrentkey("FA No.","Depreciation Book Code","FA Posting Date");
              MaintenanceLedgEntry.SetRange("FA No.","Account No.");
              if "Depreciation Book Code" <> '' then
                MaintenanceLedgEntry.SetRange("Depreciation Book Code","Depreciation Book Code");
              if MaintenanceLedgEntry.FindLast then;
              Page.Run(Page::"Maintenance Ledger Entries",MaintenanceLedgEntry);
            end;
          "account type"::"IC Partner":
            Error(Text001);
        end;
    end;

    var
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        Text001: label 'Intercompany partners do not have ledger entries.';
}

