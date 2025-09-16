#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51863 Labreport
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Labreport.rdlc';

    dataset
    {
        dataitem(UnknownTable61416;UnknownTable61416)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(LabNo;"HMS-Laboratory Form Header"."Laboratory No.")
            {
            }
            column(PatNO;"HMS-Laboratory Form Header"."Patient No.")
            {
            }
            column(date;"HMS-Laboratory Form Header"."Laboratory Date")
            {
            }
            column(StudNO;"HMS-Laboratory Form Header"."Student No.")
            {
            }
            column(EmpNo;"HMS-Laboratory Form Header"."Employee No.")
            {
            }
            column(ID;"HMS-Laboratory Form Header"."ID Number")
            {
            }
            column(LabNos;"HMS-Laboratory Form Header"."Lab. Reference No.")
            {
            }
            column(Noseries;"HMS-Laboratory Form Header"."No. Series")
            {
            }
            column(Remarks;"HMS-Laboratory Form Header".Remarks)
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

