#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51625 "Remaining Amount"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Remaining Amount.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Remaining Amount";
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
            column(Cust__Ledger_Entry__Entry_No__;"Entry No.")
            {
            }
            column(Cust__Ledger_Entry__Customer_No__;"Customer No.")
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Cust__Ledger_Entry__Document_Type_;"Document Type")
            {
            }
            column(Cust__Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Cust__Ledger_Entry_Description;Description)
            {
            }
            column(Cust__Ledger_Entry_Amount;Amount)
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_;"Remaining Amount")
            {
            }
            column(Cust__Ledger_EntryCaption;Cust__Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Entry_No__Caption;FieldCaption("Entry No."))
            {
            }
            column(Cust__Ledger_Entry__Customer_No__Caption;FieldCaption("Customer No."))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption;FieldCaption("Document Type"))
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_Caption;FieldCaption("Remaining Amount"))
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
        Cust__Ledger_EntryCaptionLbl: label 'Cust. Ledger Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

