#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51269 "Cash Return Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cash Return Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61723;UnknownTable61723)
        {
            DataItemTableView = where(Posted=filter(Yes));
            PrintOnlyIfDetail = true;
            RequestFilterFields = Date,Cashier,"No.";
            column(ReportForNavId_7967; 7967)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(current;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Cash_Receipt_SummaryCaption;Cash_Receipt_SummaryCaptionLbl)
            {
            }
            column(receipt_no;"FIN-Receipts Header"."No.")
            {
            }
            column(bank_Account;"FIN-Receipts Header"."Bank Name")
            {
            }
            column(Receivedfrom;"FIN-Receipts Header"."Received From")
            {
            }
            column(casheir;"FIN-Receipts Header".Cashier)
            {
            }
            column(Amount_1;"FIN-Receipts Header"."Amount Recieved")
            {
            }
            column(ApplicationNo_ReceiptsHeader;"FIN-Receipts Header"."Application No")
            {
            }
            column(ApplicantName_ReceiptsHeader;"FIN-Receipts Header"."Applicant Name")
            {
            }
            column(Log;companyinfo.Picture)
            {
            }
            column(TotalAmount;"FIN-Receipts Header"."Total Amount")
            {
            }
            column(Dates;"FIN-Receipts Header".Date)
            {
            }
            dataitem(UnknownTable61717;UnknownTable61717)
            {
                column(ReportForNavId_8; 8)
                {
                }
                column(mode;"FIN-Receipt Line q"."Pay Mode")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                 CalcFields("FIN-Receipts Header"."Total Amount");
            end;

            trigger OnPreDataItem()
            begin
                //LastFieldNo := FIELDNO(Code);
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

    trigger OnPreReport()
    begin
         companyinfo.Get;
          companyinfo.CalcFields(Picture);
    end;

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        TotalFor: label 'Total for ';
        Cash_Receipt_SummaryCaptionLbl: label 'Cash Receipt Summary';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        AmountCaptionLbl: label 'Amount';
        TotalCaptionLbl: label 'Total';
        Total_AmountCaptionLbl: label 'Total Amount';
        companyinfo: Record "Company Information";
}

