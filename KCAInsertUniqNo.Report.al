#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51613 "KCA Insert Uniq No."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/KCA Insert Uniq No..rdlc';

    dataset
    {
        dataitem(UnknownTable61539;UnknownTable61539)
        {
            RequestFilterFields = "Receipt No","Uniq No.";
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
            column(Receipt_Items__Uniq_No__;"Uniq No.")
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
            column(Receipt_Items__Uniq_No__Caption;FieldCaption("Uniq No."))
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
                UniqNo:=UniqNo+1;
                "ACA-Receipt Items"."Uniq No 2":=UniqNo;
                "ACA-Receipt Items".Modify;
            end;

            trigger OnPreDataItem()
            begin
                UniqNo:=7000;
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
        UniqNo: Integer;
        Receipt_ItemsCaptionLbl: label 'Receipt Items';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

