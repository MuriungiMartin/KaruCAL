#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51000 "Flush HMS Patient"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Flush HMS Patient.rdlc';

    dataset
    {
        dataitem(UnknownTable61402;UnknownTable61402)
        {
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                         "HMS-Patient"."Patient Ref. No.":='';
                         Modify;
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

