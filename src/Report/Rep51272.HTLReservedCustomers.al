#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51272 "HTL Reserved Customers"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HTL Reserved Customers.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = where("HTL Status"=const(Reserved));
            RequestFilterFields = "No.";
            column(ReportForNavId_6836; 6836)
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
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer_Address;Address)
            {
            }
            column(Customer__Address_2_;"Address 2")
            {
            }
            column(Customer_Balance;Balance)
            {
            }
            column(Customer__Arrival_Date_;"Arrival Date")
            {
            }
            column(CustomerCaption;CustomerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Customer__No__Caption;FieldCaption("No."))
            {
            }
            column(Customer_NameCaption;FieldCaption(Name))
            {
            }
            column(Customer_AddressCaption;FieldCaption(Address))
            {
            }
            column(Customer__Address_2_Caption;FieldCaption("Address 2"))
            {
            }
            column(Customer_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(Customer__Arrival_Date_Caption;FieldCaption("Arrival Date"))
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
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

