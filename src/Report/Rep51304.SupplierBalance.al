#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51304 "Supplier Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Supplier Balance.rdlc';

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            RequestFilterFields = "No.","Date Filter";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Vendor__No__;"No.")
            {
            }
            column(Vendor_Name;Name)
            {
            }
            column(Vendor__Phone_No__;"Phone No.")
            {
            }
            column(Vendor_Address;Address)
            {
            }
            column(Vendor_Balance;Balance)
            {
            }
            column(Vendor_Balance_Control1102760000;Balance)
            {
            }
            column(Vendors_BalanceCaption;Vendors_BalanceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Vendor__No__Caption;FieldCaption("No."))
            {
            }
            column(Vendor_NameCaption;FieldCaption(Name))
            {
            }
            column(Vendor__Phone_No__Caption;FieldCaption("Phone No."))
            {
            }
            column(Vendor_AddressCaption;FieldCaption(Address))
            {
            }
            column(Vendor_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(TotalCaption;TotalCaptionLbl)
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

    var
        Vendors_BalanceCaptionLbl: label 'Vendors Balance';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TotalCaptionLbl: label 'Total';
}

