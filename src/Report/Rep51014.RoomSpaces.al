#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51014 "Room Spaces"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Room Spaces.rdlc';

    dataset
    {
        dataitem(UnknownTable61824;UnknownTable61824)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(host;"ACA-Room Spaces"."Hostel Code")
            {
            }
            column(room;"ACA-Room Spaces"."Room Code")
            {
            }
            column(spc;"ACA-Room Spaces"."Space Code")
            {
            }
            column(cost;"ACA-Room Spaces"."Room Cost")
            {
            }

            trigger OnAfterGetRecord()
            begin
                      "ACA-Room Spaces"."Room Cost":=5500;
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

