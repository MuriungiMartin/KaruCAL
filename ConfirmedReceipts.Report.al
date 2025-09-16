#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51501 "Confirmed Receipts"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Confirmed Receipts.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Student No.","Receipt No.",Date,"KCA Rcpt No";
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
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Student_Name_;"Student Name")
            {
            }
            column(Receipt__KCA_Rcpt_No_;"KCA Rcpt No")
            {
            }
            column(Receipt_Date;Date)
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Receipt__Payment_By_;"Payment By")
            {
            }
            column(ReceiptCaption;ReceiptCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Receipt__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(Receipt__KCA_Rcpt_No_Caption;FieldCaption("KCA Rcpt No"))
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt__Payment_By_Caption;FieldCaption("Payment By"))
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
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

