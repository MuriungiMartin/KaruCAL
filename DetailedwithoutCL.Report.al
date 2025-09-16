#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51714 "Detailed without CL"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Detailed without CL.rdlc';

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
            column(Detailed_Cust__Ledg__Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Detailed_Cust__Ledg__Entry__Document_No__;"Document No.")
            {
            }
            column(Detailed_Cust__Ledg__Entry_Amount;Amount)
            {
            }
            column(Detailed_Cust__Ledg__Entry__User_ID_;"User ID")
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
            column(Detailed_Cust__Ledg__Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Detailed_Cust__Ledg__Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Detailed_Cust__Ledg__Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Detailed_Cust__Ledg__Entry__User_ID_Caption;FieldCaption("User ID"))
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
        CustL: Record "Cust. Ledger Entry";
        Detailed_Cust__Ledg__EntryCaptionLbl: label 'Detailed Cust. Ledg. Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

