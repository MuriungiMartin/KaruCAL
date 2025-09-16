#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51027 "Update Leave Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Leave Entries.rdlc';

    dataset
    {
        dataitem(UnknownTable61624;UnknownTable61624)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                          Delete;
            end;

            trigger OnPostDataItem()
            begin
                Message('All Deleted!!');
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

    trigger OnPreReport()
    begin
         Clear(seq);
    end;

    var
        seq: Integer;
}

