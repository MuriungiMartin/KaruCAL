#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99 "Delete Empty G/L Registers"
{
    Caption = 'Delete Empty G/L Registers';
    Permissions = TableData "G/L Register"=rimd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("G/L Register";"G/L Register")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Creation Date";
            column(ReportForNavId_9922; 9922)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                if GLEntry.FindFirst then
                  CurrReport.Skip;
                CustLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                if CustLedgEntry.FindFirst then
                  CurrReport.Skip;
                VendLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                if VendLedgEntry.FindFirst then
                  CurrReport.Skip;
                VATEntry.SetRange("Entry No.","From VAT Entry No.","To VAT Entry No.");
                if VATEntry.FindFirst then
                  CurrReport.Skip;
                BankAccLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                if BankAccLedgEntry.FindFirst then
                  CurrReport.Skip;
                FAReg.SetCurrentkey("Creation Date");
                FAReg.SetRange("Creation Date","Creation Date");
                FAReg.SetRange("G/L Register No.","No.");
                if FAReg.FindFirst then begin
                  FALedgEntry.SetRange("Entry No.",FAReg."From Entry No.",FAReg."To Entry No.");
                  if FALedgEntry.FindFirst then
                    CurrReport.Skip;
                  MaintLedgEntry.SetRange("Entry No.",FAReg."From Maintenance Entry No.",FAReg."To Maintenance Entry No.");
                  if MaintLedgEntry.FindFirst then
                    CurrReport.Skip;
                end;

                Window.Update(1,"No.");
                Window.Update(2,"Creation Date");
                Delete;
                NoOfDeleted := NoOfDeleted + 1;
                Window.Update(3,NoOfDeleted);
                if NoOfDeleted >= NoOfDeleted2 + 10 then begin
                  NoOfDeleted2 := NoOfDeleted;
                  Commit;
                end;
            end;

            trigger OnPreDataItem()
            begin
                if not Confirm(Text000,false) then
                  CurrReport.Break;

                Window.Open(
                  Text001 +
                  Text002 +
                  Text003 +
                  Text004);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Text000: label 'Do you want to delete the registers?';
        Text001: label 'Deleting empty G/L registers...\\';
        Text002: label 'No.                      #1######\';
        Text003: label 'Posted on                #2######\\';
        Text004: label 'No. of registers deleted #3######';
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VATEntry: Record "VAT Entry";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        FAReg: Record "FA Register";
        FALedgEntry: Record "FA Ledger Entry";
        MaintLedgEntry: Record "Maintenance Ledger Entry";
        Window: Dialog;
        NoOfDeleted: Integer;
        NoOfDeleted2: Integer;
}

