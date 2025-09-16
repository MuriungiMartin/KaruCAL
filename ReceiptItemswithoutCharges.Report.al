#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51503 "Receipt Items without Charges"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Receipt Items without Charges.rdlc';

    dataset
    {
        dataitem(UnknownTable61539;UnknownTable61539)
        {
            DataItemTableView = sorting("Receipt No",Code,"Uniq No 2");
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
            column(Receipt_Items__Transaction_ID_;"Transaction ID")
            {
            }
            column(StudNo;StudNo)
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
            column(Receipt_Items__Transaction_ID_Caption;FieldCaption("Transaction ID"))
            {
            }
            column(Student_No_Caption;Student_No_CaptionLbl)
            {
            }
            column(Receipt_Items_Uniq_No_2;"Uniq No 2")
            {
            }

            trigger OnAfterGetRecord()
            begin
                StudNo:='';
                if Rcpt.Get("ACA-Receipt Items"."Receipt No") then
                StudNo:=Rcpt."Student No.";
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
        StudNo: Code[20];
        Rcpt: Record UnknownRecord61538;
        Receipt_ItemsCaptionLbl: label 'Receipt Items';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Student_No_CaptionLbl: label 'Student No.';
}

