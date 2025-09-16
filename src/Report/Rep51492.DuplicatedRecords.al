#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51492 "Duplicated Records"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Duplicated Records.rdlc';

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "Customer Type";
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
            column(Customer__Debit_Amount_;"Debit Amount")
            {
            }
            column(Customer__Credit_Amount_;"Credit Amount")
            {
            }
            column(Customer_Balance;Balance)
            {
            }
            column(TBal;TBal)
            {
            }
            column(TCredits;TCredits)
            {
            }
            column(TDebit;TDebit)
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
            column(Customer__Debit_Amount_Caption;FieldCaption("Debit Amount"))
            {
            }
            column(Customer__Credit_Amount_Caption;FieldCaption("Credit Amount"))
            {
            }
            column(Customer_BalanceCaption;FieldCaption(Balance))
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
        Cust: Record Customer;
        TBal: Decimal;
        TDebit: Decimal;
        TCredits: Decimal;
        CustomerCaptionLbl: label 'Customer';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

