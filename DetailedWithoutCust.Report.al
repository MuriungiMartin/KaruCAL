#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51699 "Detailed Without Cust"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed Without Cust.rdlc';

    dataset
    {
        dataitem("Detailed Cust. Ledg. Entry";"Detailed Cust. Ledg. Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Customer No.";
            column(ReportForNavId_6942; 6942)
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
            column(Detailed_Cust__Ledg__Entry__Entry_No__;"Entry No.")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Cust__Ledger_Entry_No__;"Cust. Ledger Entry No.")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Entry_Type_;"Entry Type")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Document_Type_;"Document Type")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Document_No__;"Document No.")
            {
            }
            column(Detailed_Cust__Ledg__Entry_Amount;Amount)
            {
            }
            column(Detailed_Cust__Ledg__Entry__Amount__LCY__;"Amount (LCY)")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Customer_No__;"Customer No.")
            {
            }
            column(TAmount;TAmount)
            {
            }
            column(Detailed_Cust__Ledg__EntryCaption;Detailed_Cust__Ledg__EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Detailed_Cust__Ledg__Entry__Entry_No__Caption;FieldCaption("Entry No."))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Cust__Ledger_Entry_No__Caption;FieldCaption("Cust. Ledger Entry No."))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Entry_Type_Caption;FieldCaption("Entry Type"))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Document_Type_Caption;FieldCaption("Document Type"))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Detailed_Cust__Ledg__Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Amount__LCY__Caption;FieldCaption("Amount (LCY)"))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Customer_No__Caption;FieldCaption("Customer No."))
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
        TAmount: Decimal;
        CustL: Record "Cust. Ledger Entry";
        DCustL: Record "Detailed Cust. Ledg. Entry";
        Detailed_Cust__Ledg__EntryCaptionLbl: label 'Detailed Cust. Ledg. Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

