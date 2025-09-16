#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 62841 "Update GL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update GL.rdlc';

    dataset
    {
        dataitem(UnknownTable61092;UnknownTable61092)
        {
            RequestFilterFields = "Period Year";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "PRL-Period Transactions"."Transaction Code"='NPAY' then  begin
                "PRL-Period Transactions"."Journal Account Code":='31290';
                Modify;
                end;
            end;

            trigger OnPostDataItem()
            begin
                Message('wewe');
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
}

