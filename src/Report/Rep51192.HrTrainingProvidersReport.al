#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51192 "Hr Training Providers Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Hr Training Providers Report.rdlc';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            column(ReportForNavId_1102755007; 1102755007)
            {
            }
            column(Address_Vendor;Vendor.Address)
            {
            }
            column(Address2_Vendor;Vendor."Address 2")
            {
            }
            column(City_Vendor;Vendor.City)
            {
            }
            column(Contact_Vendor;Vendor.Contact)
            {
            }
            column(PhoneNo_Vendor;Vendor."Phone No.")
            {
            }
            column(No_Vendor;Vendor."No.")
            {
            }
            column(Name_Vendor;Vendor.Name)
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

