#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78065 "Update Reasons"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Reasons.rdlc';

    dataset
    {
        dataitem(sp;UnknownTable66663)
        {
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            dataitem(cr;UnknownTable61532)
            {
                DataItemLink = Remarks=field("Current Reason");
                DataItemTableView = where(Reversed=filter(Yes),"Stoppage Reason"=filter(""));
                column(ReportForNavId_1000000000; 1000000000)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    cr."Stoppage Reason":=sp."Correct Value";
                    cr.Modify;
                end;
            }
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
}

