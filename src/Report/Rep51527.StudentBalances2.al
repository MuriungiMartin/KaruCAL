#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51527 "Student Balances 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Balances 2.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.") where("Customer Type"=const(Student));
            RequestFilterFields = "No.","Date Filter","Balance (LCY)","Debit Amount (LCY)","Credit Amount (LCY)","Credit Amount";
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
            column(Customer__Balance__LCY__;"Balance (LCY)")
            {
            }
            column(Customer__Balance__LCY___Control1000000015;"Balance (LCY)")
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
            column(Customer__Balance__LCY__Caption;FieldCaption("Balance (LCY)"))
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

