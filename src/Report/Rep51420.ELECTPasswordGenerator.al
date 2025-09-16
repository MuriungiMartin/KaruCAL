#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51420 "ELECT Password Generator"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ELECT Password Generator.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
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
            column(Customer_Password;Password)
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
            column(Customer_PasswordCaption;FieldCaption(Password))
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
        noseriesmgt: Codeunit NoSeriesManagement;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

