#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51021 "Posting group"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Posting group.rdlc';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(no;Vendor."No.")
            {
            }
            column(name;Vendor.Name)
            {
            }
            column(group;Vendor."Vendor Posting Group")
            {
            }

            trigger OnAfterGetRecord()
            begin
                 Vendor."Gen. Bus. Posting Group":='LOCAL';
                  Vendor.Modify;
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

