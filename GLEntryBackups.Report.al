#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 70071 "GL Entry Backups"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable70071;UnknownTable70071)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                GLEntry.Reset;
                GLEntry.SetRange("Entry No.","GLentry Backup"."Entry No");
                if GLEntry.Find('-') then begin
                GLEntry.Description  :="GLentry Backup".Description;
                GLEntry.Modify;
                  end;
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
        GLEntry: Record "G/L Entry";
}

