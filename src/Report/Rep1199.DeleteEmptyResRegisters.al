#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1199 "Delete Empty Res. Registers"
{
    Caption = 'Delete Empty Res. Registers';
    Permissions = TableData "Resource Register"=rimd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Resource Register";"Resource Register")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Creation Date";
            column(ReportForNavId_4792; 4792)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ResLedgEntry.SetRange("Entry No.","From Entry No.","To Entry No.");
                if ResLedgEntry.FindFirst then
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
        Text001: label 'Deleting empty resource registers...\\';
        Text002: label 'No.                      #1######\';
        Text003: label 'Posted on                #2######\\';
        Text004: label 'No. of registers deleted #3######';
        ResLedgEntry: Record "Res. Ledger Entry";
        Window: Dialog;
        NoOfDeleted: Integer;
        NoOfDeleted2: Integer;
}

