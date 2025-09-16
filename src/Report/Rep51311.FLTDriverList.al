#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51311 "FLT Driver List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/FLT Driver List.rdlc';

    dataset
    {
        dataitem(UnknownTable61798;UnknownTable61798)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(driver;"FLT-Driver".Driver)
            {
            }
            column(DriveName;"FLT-Driver"."Driver Name")
            {
            }
            column(License;"FLT-Driver"."Driver License Number")
            {
            }
            column(Grade;"FLT-Driver".Grade)
            {
            }
            column(RenDate;"FLT-Driver"."Last License Renewal")
            {
            }
            column(RenInterval;"FLT-Driver"."Renewal Interval")
            {
            }
            column(Ren_Value;"FLT-Driver"."Renewal Interval Value")
            {
            }
            column(Status;"FLT-Driver".Active)
            {
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

