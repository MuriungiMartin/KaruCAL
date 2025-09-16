#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51006 AAA
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/AAA.rdlc';

    dataset
    {
        dataitem(UnknownTable61722;UnknownTable61722)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(A;"FIN-Committment"."Line No.")
            {
            }
            column(B;"FIN-Committment"."Document No.")
            {
            }
            column(C;"FIN-Committment".Amount)
            {
            }
            column(D;"FIN-Committment"."Committed By")
            {
            }
            column(E;"FIN-Committment"."Uploaded Manually")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "FIN-Committment"."Line No.">28
                then begin
                "FIN-Committment".Committed:=true;
                "FIN-Committment"."Uploaded Manually":=true;
                "FIN-Committment".Modify;
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
}

