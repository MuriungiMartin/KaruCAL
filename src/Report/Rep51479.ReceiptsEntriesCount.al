#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51479 "Receipts Entries - Count"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipts Entries - Count.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("User ID");
            RequestFilterFields = "User ID";
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
            column(Receipt__User_ID_;"User ID")
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
            column(Receipt__Transaction_Date_;"Transaction Date")
            {
            }
            column(Receipt__Transaction_Time_;"Transaction Time")
            {
            }
            column(Receipt_Amount_Control1000000000;Amount)
            {
            }
            column(Receipt_EntriesCaption;Receipt_EntriesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt__User_ID_Caption;FieldCaption("User ID"))
            {
            }
            column(Receipt__Transaction_Time_Caption;FieldCaption("Transaction Time"))
            {
            }
            column(Receipt__Transaction_Date_Caption;FieldCaption("Transaction Date"))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt__Payment_Mode_Caption;FieldCaption("Payment Mode"))
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt__Receipt_No__Caption;FieldCaption("Receipt No."))
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("User ID");
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
        RecCount: Integer;
        Receipt_EntriesCaptionLbl: label 'Receipt Entries';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

