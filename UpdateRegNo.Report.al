#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51686 "Update Reg No"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Reg No.rdlc';

    dataset
    {
        dataitem(UnknownTable61538;UnknownTable61538)
        {
            DataItemTableView = sorting("Receipt No.");
            RequestFilterFields = "Receipt No.";
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
            dataitem(UnknownTable61539;UnknownTable61539)
            {
                DataItemLink = "Receipt No"=field("Receipt No.");
                column(ReportForNavId_9528; 9528)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    /*
                    IF StudCharges.GET("Receipt Items"."Transaction ID",Receipt."Student No.") THEN BEGIN
                    "Receipt Items"."Reg. No":=StudCharges."Reg. Transacton ID";
                    "Receipt Items".Code:=StudCharges.Code;
                    "Receipt Items".MODIFY;
                    END;
                    */
                    "ACA-Receipt Items"."Student No.":="ACA-Receipt"."Student No.";
                    "ACA-Receipt Items".Modify;

                end;
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
        StudCharges: Record UnknownRecord61535;
        ReceiptCaptionLbl: label 'Receipt';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

