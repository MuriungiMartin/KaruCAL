#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 953 "Move Time Sheets to Archive"
{
    Caption = 'Move Time Sheets to Archive';
    ProcessingOnly = true;
    UsageCategory = Administration;

    dataset
    {
        dataitem("Time Sheet Header";"Time Sheet Header")
        {
            RequestFilterFields = "No.","Starting Date";
            column(ReportForNavId_5125; 5125)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Counter := Counter + 1;
                Window.Update(1,"No.");
                Window.Update(2,ROUND(Counter / CounterTotal * 10000,1));
                TimeSheetMgt.MoveTimeSheetToArchive("Time Sheet Header");
            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(Text002,Counter);
            end;

            trigger OnPreDataItem()
            begin
                CounterTotal := Count;
                Window.Open(Text001);
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
        TimeSheetMgt: Codeunit "Time Sheet Management";
        Window: Dialog;
        Counter: Integer;
        Text001: label 'Moving time sheets to archive  #1########## @2@@@@@@@@@@@@@';
        Text002: label '%1 time sheets have been moved to the archive.';
        CounterTotal: Integer;
}

