#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5755 "Delete Registered Whse. Docs."
{
    Caption = 'Delete Registered Whse. Docs.';
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Registered Whse. Activity Hdr.";"Registered Whse. Activity Hdr.")
        {
            DataItemTableView = sorting(Type,"No.");
            RequestFilterFields = Type,"No.";
            RequestFilterHeading = 'Registered Whse. Docs.';
            column(ReportForNavId_9972; 9972)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,Type);
                Window.Update(2,"No.");

                Delete(true);
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(
                  Text000 +
                  Text001 +
                  Text002);
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
        Text000: label 'Processing registered documents...\\';
        Text001: label 'Type             #1##########\';
        Text002: label 'No.              #2##########';
        Window: Dialog;
}

