#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6006 "Delete Service Email Queue"
{
    Caption = 'Delete Service Email Queue';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Email Queue";"Service Email Queue")
        {
            DataItemTableView = sorting(Status,"Sending Date");
            RequestFilterFields = Status,"Sending Date";
            column(ReportForNavId_2218; 2218)
            {
            }

            trigger OnAfterGetRecord()
            begin
                i := i + 1;
                Delete;
            end;

            trigger OnPostDataItem()
            begin
                if i > 1 then
                  Message(Text000,i)
                else
                  Message(Text001,i);
            end;

            trigger OnPreDataItem()
            begin
                i := 0;
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
        Text000: label '%1 entries were deleted.';
        Text001: label '%1 entry was deleted.';
        i: Integer;
}

