#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51726 "Check Ledger"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Ledger.rdlc';

    dataset
    {
        dataitem("Check Ledger Entry";"Check Ledger Entry")
        {
            RequestFilterFields = "Entry No.";
            column(ReportForNavId_5439; 5439)
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
            column(Check_Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Check_Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Check_Ledger_Entry_Description;Description)
            {
            }
            column(Check_Ledger_Entry_Amount;Amount)
            {
            }
            column(Check_Ledger_Entry__Check_Date_;"Check Date")
            {
            }
            column(Check_Ledger_Entry__Check_No__;"Check No.")
            {
            }
            column(Check_Ledger_Entry__User_ID_;"User ID")
            {
            }
            column(Check_Ledger_Entry__Entry_Status_;"Entry Status")
            {
            }
            column(Check_Ledger_EntryCaption;Check_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Check_Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
            {
            }
            column(Check_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Check_Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Check_Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Check_Ledger_Entry__Check_Date_Caption;FieldCaption("Check Date"))
            {
            }
            column(Check_Ledger_Entry__Check_No__Caption;FieldCaption("Check No."))
            {
            }
            column(Check_Ledger_Entry__User_ID_Caption;FieldCaption("User ID"))
            {
            }
            column(Check_Ledger_Entry__Entry_Status_Caption;FieldCaption("Entry Status"))
            {
            }
            column(Check_Ledger_Entry_Entry_No_;"Entry No.")
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
        Check_Ledger_EntryCaptionLbl: label 'Check Ledger Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

