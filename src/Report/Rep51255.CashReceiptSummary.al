#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51255 "Cash Receipt Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cash Receipt Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61158;UnknownTable61158)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_7967; 7967)
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
            column(Cash_Sale_Line_Description;Description)
            {
            }
            column(Cash_Sale_Line_Code;Code)
            {
            }
            column(Cash_Sale_Line_Description_Control1000000014;Description)
            {
            }
            column(Cash_Sale_Line__Total_Amount_;"Total Amount")
            {
            }
            column(Cash_Sale_Line__Total_Amount__Control1000000020;"Total Amount")
            {
            }
            column(Cash_Sale_Line__Total_Amount__Control1000000008;"Total Amount")
            {
            }
            column(Cash_Receipt_SummaryCaption;Cash_Receipt_SummaryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cash_Sale_Line_CodeCaption;FieldCaption(Code))
            {
            }
            column(Cash_Sale_Line_Description_Control1000000014Caption;FieldCaption(Description))
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(Total_AmountCaption;Total_AmountCaptionLbl)
            {
            }
            column(Cash_Sale_Line_Line_No;"Line No")
            {
            }
            column(Cash_Sale_Line_No;No)
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        TotalFor: label 'Total for ';
        Cash_Receipt_SummaryCaptionLbl: label 'Cash Receipt Summary';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        AmountCaptionLbl: label 'Amount';
        TotalCaptionLbl: label 'Total';
        Total_AmountCaptionLbl: label 'Total Amount';
}

