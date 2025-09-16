#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51684 "Insert Rcpt Nos"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Insert Rcpt Nos.rdlc';

    dataset
    {
        dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Entry No.";
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
            column(Bank_Account_Ledger_Entry__Entry_No__;"Entry No.")
            {
            }
            column(Bank_Account_Ledger_Entry__Bank_Account_No__;"Bank Account No.")
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
            column(Bank_Account_Ledger_EntryCaption;Bank_Account_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Entry_No__Caption;FieldCaption("Entry No."))
            {
            }
            column(Bank_Account_Ledger_Entry__Bank_Account_No__Caption;FieldCaption("Bank Account No."))
            {
            }
            column(Bank_Account_Ledger_Entry__Posting_Date_Caption;FieldCaption("Posting Date"))
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

            trigger OnAfterGetRecord()
            begin
                if "Bank Account Ledger Entry"."Document No." <> 'OPENING' then begin
                if Rcpt.Get("Bank Account Ledger Entry"."Document No.") = false then begin
                Rcpt.Init;
                Rcpt."Receipt No.":="Bank Account Ledger Entry"."Document No." + 'N';
                //Rcpt."Student No.":=;
                Rcpt.Date:="Bank Account Ledger Entry"."Posting Date";
                Rcpt.Amount:="Bank Account Ledger Entry".Amount;
                Rcpt.Posted:=true;
                Rcpt.Insert;
                end;

                end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Entry No.");
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        Rcpt: Record UnknownRecord61538;
        Bank_Account_Ledger_EntryCaptionLbl: label 'Bank Account Ledger Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

