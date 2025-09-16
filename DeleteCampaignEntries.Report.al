#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5189 "Delete Campaign Entries"
{
    Caption = 'Delete Campaign Entries';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Campaign Entry";"Campaign Entry")
        {
            RequestFilterFields = "Entry No.","Campaign No.",Date,"Salesperson Code";
            column(ReportForNavId_1760; 1760)
            {
            }

            trigger OnAfterGetRecord()
            begin
                NoOfToDos := NoOfToDos + 1;
                Delete(true);
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Canceled,true);
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

    trigger OnPostReport()
    begin
        Message(Text000,NoOfToDos,"Campaign Entry".TableCaption);
    end;

    var
        Text000: label '%1 %2 has been deleted.';
        NoOfToDos: Integer;
}

