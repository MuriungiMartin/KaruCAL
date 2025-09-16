#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51606 "KCA Inst Rcpt Items Tran"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Inst Rcpt Items Tran.rdlc';

    dataset
    {
        dataitem(UnknownTable61539;UnknownTable61539)
        {
            DataItemTableView = sorting("Receipt No");
            RequestFilterFields = "Transaction ID";
            column(ReportForNavId_9528; 9528)
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
            column(Receipt_Items__Receipt_No_;"Receipt No")
            {
            }
            column(Receipt_Items_Code;Code)
            {
            }
            column(Receipt_Items_Description;Description)
            {
            }
            column(Receipt_Items_Amount;Amount)
            {
            }
            column(Receipt_Items_Balance;Balance)
            {
            }
            column(Receipt_Items_Date;Date)
            {
            }
            column(Receipt_ItemsCaption;Receipt_ItemsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Receipt_Items__Receipt_No_Caption;FieldCaption("Receipt No"))
            {
            }
            column(Receipt_Items_CodeCaption;FieldCaption(Code))
            {
            }
            column(Receipt_Items_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Receipt_Items_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Receipt_Items_BalanceCaption;FieldCaption(Balance))
            {
            }
            column(Receipt_Items_DateCaption;FieldCaption(Date))
            {
            }
            column(Receipt_Items_Uniq_No_2;"Uniq No 2")
            {
            }
            column(Receipt_Items_Transaction_ID;"Transaction ID")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //IF ("Receipt Items"."Transaction ID" = '') OR ("Receipt Items"."Student No." = '') THEN BEGIN
                //IF COPYSTR("Receipt Items"."Transaction ID",1,3) = 'KCA' THEN BEGIN
                if Rcpt.Get("ACA-Receipt Items"."Receipt No") then begin
                "ACA-Receipt Items"."Student No.":=Rcpt."Student No.";
                StudCharges.Reset;
                StudCharges.SetCurrentkey(StudCharges."Student No.",StudCharges.Code);
                StudCharges.SetRange(StudCharges."Student No.",Rcpt."Student No.");
                StudCharges.SetRange(StudCharges.Code,"ACA-Receipt Items".Code);
                if StudCharges.Find('-') then begin
                "ACA-Receipt Items"."Transaction ID":=StudCharges."Transacton ID";
                end;
                "ACA-Receipt Items".Modify;
                end else
                "ACA-Receipt Items".Delete;
                //END;
            end;

            trigger OnPreDataItem()
            begin
                //"Receipt Items".MODIFYALL("Receipt Items"."Transaction ID",'');
                //"Receipt Items".MODIFYALL("Receipt Items"."Student No.",'');
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
        Rcpt: Record UnknownRecord61538;
        StudCharges: Record UnknownRecord61535;
        Receipt_ItemsCaptionLbl: label 'Receipt Items';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

