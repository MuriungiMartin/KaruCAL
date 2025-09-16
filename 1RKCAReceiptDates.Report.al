#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51604 "1R KCA Receipt Dates"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/1R KCA Receipt Dates.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = Date;
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
            column(Receipt__No__Series_;"No. Series")
            {
            }
            column(Receipt__Payment_By_;"Payment By")
            {
            }
            column(Receipt__User_ID_;"User ID")
            {
            }
            column(Receipt__Transaction_Date_;"Transaction Date")
            {
            }
            column(Receipt__Transaction_Time_;"Transaction Time")
            {
            }
            column(Receipt__Student_Name_;"Student Name")
            {
            }
            column(Receipt__KCA_Rcpt_No_;"KCA Rcpt No")
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
            column(Receipt__No__Series_Caption;FieldCaption("No. Series"))
            {
            }
            column(Receipt__Payment_By_Caption;FieldCaption("Payment By"))
            {
            }
            column(Receipt__User_ID_Caption;FieldCaption("User ID"))
            {
            }
            column(Receipt__Transaction_Date_Caption;FieldCaption("Transaction Date"))
            {
            }
            column(Receipt__Transaction_Time_Caption;FieldCaption("Transaction Time"))
            {
            }
            column(Receipt__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(Receipt__KCA_Rcpt_No_Caption;FieldCaption("KCA Rcpt No"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                RcptItems.Reset;
                RcptItems.SetCurrentkey(RcptItems."Receipt No");
                RcptItems.SetRange(RcptItems."Receipt No","ACA-Receipt"."Receipt No.");
                if RcptItems.Find('-') then begin
                //RcptItems.MODIFYALL(RcptItems."Student No.",Receipt."Student No.");
                RcptItems.ModifyAll(RcptItems.Date,"ACA-Receipt".Date);
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
        RcptItems: Record UnknownRecord61539;
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

