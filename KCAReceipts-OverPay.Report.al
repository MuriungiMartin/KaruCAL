#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51512 "KCA Receipts - Over Pay"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Receipts - Over Pay.rdlc';

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
            column(Receipt__Receipt_No__;"Receipt No.")
            {
            }
            column(Receipt__Student_No__;"Student No.")
            {
            }
            column(Receipt__Student_Name_;"Student Name")
            {
            }
            column(Receipt_Amount;Amount)
            {
            }
            column(Receipt_Date;Date)
            {
            }
            column(Receipt__Amount_Applied_;"Amount Applied")
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
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt__Amount_Applied_Caption;FieldCaption("Amount Applied"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                UniqNo:=UniqNo+1;
                "ACA-Receipt".CalcFields("ACA-Receipt"."Amount Applied");
                if "ACA-Receipt".Amount > "ACA-Receipt"."Amount Applied" then begin
                ReceiptItems.Init;
                ReceiptItems."Receipt No":="ACA-Receipt"."Receipt No.";
                ReceiptItems.Code:='OP';
                ReceiptItems.Description:='Over Payment';
                ReceiptItems.Amount:="ACA-Receipt".Amount - "ACA-Receipt"."Amount Applied";
                ReceiptItems.Date:="ACA-Receipt".Date;
                ReceiptItems."Transaction ID":='';
                ReceiptItems."Uniq No.":=UniqNo;
                ReceiptItems."Student No.":="ACA-Receipt"."Student No.";
                ReceiptItems.Insert;

                end;
            end;

            trigger OnPreDataItem()
            begin
                UniqNo:=100000;
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
        ReceiptItems: Record UnknownRecord61539;
        UniqNo: Integer;
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

