#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 50010 "Update Vendor Data"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Vendor.Name:=UpperCase(Vendor.Name);
                Vendor."Name 2":=UpperCase(Vendor."Name 2");
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

