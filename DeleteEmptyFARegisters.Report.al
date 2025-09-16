#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5693 "Delete Empty FA Registers"
{
    Caption = 'Delete Empty FA Registers';
    Permissions = TableData "FA Register"=rimd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("FA Register";"FA Register")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Creation Date";
            column(ReportForNavId_1711; 1711)
            {
            }

            trigger OnAfterGetRecord()
            begin
                FALedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                if FALedgEntry.FindFirst then
                  CurrReport.Skip;
                MaintenanceLedgEntry.SetRange("Entry No.","From Maintenance Entry No.","To Maintenance Entry No.");
                if MaintenanceLedgEntry.FindFirst then
                  CurrReport.Skip;
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
        Text001: label 'Deleting empty FA registers...\\';
        Text002: label 'No.                      #1######\';
        Text003: label 'Posted on                #2######\\';
        Text004: label 'No. of registers deleted #3######';
        FALedgEntry: Record "FA Ledger Entry";
        MaintenanceLedgEntry: Record "Maintenance Ledger Entry";
        Window: Dialog;
        NoOfDeleted: Integer;
        NoOfDeleted2: Integer;
}

