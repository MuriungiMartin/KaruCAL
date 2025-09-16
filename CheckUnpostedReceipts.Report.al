#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51630 "Check Unposted Receipts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check Unposted Receipts.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Un Posted";
            column(ReportForNavId_5672; 5672)
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
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt_Date;Date)
            {
            }
            column(Receipt__Payment_Mode_;"Payment Mode")
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Receipt__KCA_Rcpt_No_;"KCA Rcpt No")
            {
            }
            column(Receipt__Un_Posted_;"Un Posted")
            {
            }
            column(ReceiptCaption;ReceiptCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt__Payment_Mode_Caption;FieldCaption("Payment Mode"))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt__KCA_Rcpt_No_Caption;FieldCaption("KCA Rcpt No"))
            {
            }
            column(Receipt__Un_Posted_Caption;FieldCaption("Un Posted"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                BankLedg.Reset;
                BankLedg.SetCurrentkey(BankLedg."Document No.");
                BankLedg.SetRange(BankLedg."Document No.","ACA-Receipt"."Receipt No.");
                if BankLedg.Find('-') = false then begin
                "ACA-Receipt"."Un Posted":=true;
                "ACA-Receipt".Modify;
                end;
            end;

            trigger OnPreDataItem()
            begin
                "ACA-Receipt".ModifyAll("ACA-Receipt"."Un Posted",false);
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
        BankLedg: Record "Bank Account Ledger Entry";
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

