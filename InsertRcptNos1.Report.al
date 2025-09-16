#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51687 "Insert Rcpt Nos 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Insert Rcpt Nos 1.rdlc';

    dataset
    {
        dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.") where(Amount=filter(<0));
            RequestFilterFields = "Entry No.";
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
            column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
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
            column(Bank_Account_Ledger_EntryCaption;Bank_Account_Ledger_EntryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Entry_No__Caption;FieldCaption("Entry No."))
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
            column(Cust__Ledger_Entry_AmountCaption;FieldCaption(Amount))
            {
            }

            trigger OnAfterGetRecord()
            begin

                if LastRCNo<>"Cust. Ledger Entry"."Document No." then begin
                LastRCNo:="Cust. Ledger Entry"."Document No.";
                if "Cust. Ledger Entry"."Document No." <> 'OPENING' then begin
                Rcpt.Reset;
                //MESSAGE("Cust. Ledger Entry"."Document No.");
                Rcpt.Reset;
                Rcpt.SetRange(Rcpt."Student No.","Cust. Ledger Entry"."Customer No.");
                Rcpt.SetRange(Rcpt."Receipt No.","Cust. Ledger Entry"."Document No.");
                if Rcpt.Find('-') = false then begin
                Bank.Reset;
                Bank.SetRange(Bank."Posting Date","Cust. Ledger Entry"."Posting Date");
                Bank.SetRange(Bank."Document No.","Cust. Ledger Entry"."Document No.");
                if Bank.Find('-') then begin
                Rcpt.Init;
                Rcpt."Receipt No.":="Cust. Ledger Entry"."Document No." + 'N';
                Rcpt."Student No.":="Cust. Ledger Entry"."Customer No.";
                Rcpt.Date:="Cust. Ledger Entry"."Posting Date";
                Rcpt.Amount:=Bank.Amount;
                Rcpt.Posted:=true;
                //Rcpt."KCA Rcpt No":='IN';
                Rcpt.Insert;
                end;
                end;

                end;
                end;
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
        Bank: Record "Bank Account Ledger Entry";
        LastRCNo: Text[50];
        Bank_Account_Ledger_EntryCaptionLbl: label 'Bank Account Ledger Entry';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

