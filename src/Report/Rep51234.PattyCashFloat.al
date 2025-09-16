#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51234 "Patty Cash Float"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Patty Cash Float.rdlc';

    dataset
    {
        dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_4920; 4920)
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
            column(Bank_Account_Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Bank_Account_Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(Bank_Account_Ledger_Entry_Description;Description)
            {
            }
            column(Bank_Account_Ledger_Entry_Amount;Amount)
            {
            }
            column(Bank_Account_Ledger_Entry_Amount_Control1000000024;Amount)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(CASH_BOOKCaption;CASH_BOOKCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(Bank_Account_Ledger_Entry_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Bank_Account_Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Total_AmountCaption;Total_AmountCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                   SetRange("Bank Account Ledger Entry"."Bank Account No.",'PETTY');
                   SetRange("Bank Account Ledger Entry"."Document Type",0);
            end;
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
        Total: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        CASH_BOOKCaptionLbl: label 'CASH BOOK';
        DateCaptionLbl: label 'Date';
        Total_AmountCaptionLbl: label 'Total Amount';
}

