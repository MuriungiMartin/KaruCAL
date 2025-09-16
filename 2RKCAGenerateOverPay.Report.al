#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51641 "2R KCA Generate Over Pay"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/2R KCA Generate Over Pay.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Receipt No.",Date;
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
            column(Receipt__Amount_Applied_Caption;FieldCaption("Amount Applied"))
            {
            }
            column(Receipt_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt__Student_Name_Caption;FieldCaption("Student Name"))
            {
            }
            column(Receipt__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Control1000000031Caption;Control1000000031CaptionLbl)
            {
            }
            column(Control1000000033Caption;Control1000000033CaptionLbl)
            {
            }
            column(Control1000000035Caption;Control1000000035CaptionLbl)
            {
            }
            column(Control1000000037Caption;Control1000000037CaptionLbl)
            {
            }
            column(Control1000000039Caption;Control1000000039CaptionLbl)
            {
            }
            column(Control1000000029Caption;Control1000000029CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Receipt".CalcFields("ACA-Receipt"."Amount Applied");
                AmApply:="ACA-Receipt".Amount - "ACA-Receipt"."Amount Applied";
                if AmApply > 0 then begin
                UniqNo:=UniqNo+1;
                ReceiptItems.Init;
                ReceiptItems."Receipt No":="ACA-Receipt"."Receipt No.";
                ReceiptItems.Code:='OP';
                ReceiptItems.Description:='Over Payment';
                ReceiptItems.Amount:=AmApply;
                ReceiptItems.Date:="ACA-Receipt".Date;
                ReceiptItems."Transaction ID":='';
                ReceiptItems."Student No.":="ACA-Receipt"."Student No.";
                ReceiptItems."Uniq No 2":=UniqNo;
                ReceiptItems.Insert;

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
        StudCharges: Record UnknownRecord61535;
        AmApply: Decimal;
        ReceiptItems: Record UnknownRecord61539;
        AppliedAmount: Decimal;
        RItem: Record UnknownRecord61539;
        UniqNo: Integer;
        ChargeDesc: Text[200];
        TotalPaid: Decimal;
        CustLe: Integer;
        ReqAmount: Decimal;
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Control1000000031CaptionLbl: label 'Label1000000031';
        Control1000000033CaptionLbl: label 'Label1000000033';
        Control1000000035CaptionLbl: label 'Label1000000035';
        Control1000000037CaptionLbl: label 'Label1000000037';
        Control1000000039CaptionLbl: label 'Label1000000039';
        Control1000000029CaptionLbl: label 'Label1000000029';
}

