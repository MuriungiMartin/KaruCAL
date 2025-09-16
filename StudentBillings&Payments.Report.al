#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51541 "Student Billings & Payments"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Billings & Payments.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Customer No.","Posting Date","Currency Code") where("Customer No."=filter('KSPS/*'));
            RequestFilterFields = "Customer No.","Global Dimension 2 Code",Description,"Date Filter","Debit Amount (LCY)","Credit Amount (LCY)";
            column(ReportForNavId_8503; 8503)
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
            column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Cust__Ledger_Entry__Debit_Amount__LCY__;"Debit Amount (LCY)")
            {
            }
            column(Cust__Ledger_Entry__Credit_Amount__LCY__;"Credit Amount (LCY)")
            {
            }
            column(Cust__Ledger_Entry__Global_Dimension_2_Code_;"Global Dimension 2 Code")
            {
            }
            column(Cust__Ledger_Entry__Debit_Amount__LCY___Control1102760000;"Debit Amount (LCY)")
            {
            }
            column(Cust__Ledger_Entry__Credit_Amount__LCY___Control1102760007;"Credit Amount (LCY)")
            {
            }
            column(Detailed_Student_Billing___ReceiptsCaption;Detailed_Student_Billing___ReceiptsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption;FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry__Debit_Amount__LCY__Caption;FieldCaption("Debit Amount (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Credit_Amount__LCY__Caption;FieldCaption("Credit Amount (LCY)"))
            {
            }
            column(Cust__Ledger_Entry__Global_Dimension_2_Code_Caption;FieldCaption("Global Dimension 2 Code"))
            {
            }
            column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
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
        Detailed_Student_Billing___ReceiptsCaptionLbl: label 'Detailed Student Billing & Receipts';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

