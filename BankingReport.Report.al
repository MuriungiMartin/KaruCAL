#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51296 "Banking Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Banking Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61157;UnknownTable61157)
        {
            DataItemTableView = sorting("Doc No");
            RequestFilterFields = "Doc No",Date,"Banked Date","Receiving Bank A/C";
            column(ReportForNavId_3303; 3303)
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
            column(Cash_Sale_Header__Doc_No_;"Doc No")
            {
            }
            column(Desc;Desc)
            {
            }
            column(Cash_Sale_Header__Customer_Name_;"Customer Name")
            {
            }
            column(Cash_Sale_Header_Date;Date)
            {
            }
            column(Cash_Sale_Header__Posted_By_;"Posted By")
            {
            }
            column(Cash_Sale_Header__Receiving_Bank_A_C_;"Receiving Bank A/C")
            {
            }
            column(Cash_Sale_Header_Amount;Amount)
            {
            }
            column(Cash_Sale_Header__Banked_Amount_;"Banked Amount")
            {
            }
            column(Cash_Sale_Header__Banked_By_;"Banked By")
            {
            }
            column(Cash_Sale_Header__Banked_Date_;"Banked Date")
            {
            }
            column(Cash_Sale_Header__Banked_Amount__Control1102760000;"Banked Amount")
            {
            }
            column(Cash_Sale_Header_Amount_Control1102760008;Amount)
            {
            }
            column(Receipt_BankingCaption;Receipt_BankingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Cash_Sale_Header__Doc_No_Caption;FieldCaption("Doc No"))
            {
            }
            column(Being_Paid_ForCaption;Being_Paid_ForCaptionLbl)
            {
            }
            column(Cash_Sale_Header__Customer_Name_Caption;FieldCaption("Customer Name"))
            {
            }
            column(Cash_Sale_Header_DateCaption;FieldCaption(Date))
            {
            }
            column(Cash_Sale_Header__Posted_By_Caption;FieldCaption("Posted By"))
            {
            }
            column(Cash_Sale_Header__Receiving_Bank_A_C_Caption;FieldCaption("Receiving Bank A/C"))
            {
            }
            column(Cash_Sale_Header_AmountCaption;FieldCaption(Amount))
            {
            }
            column(Cash_Sale_Header__Banked_Amount_Caption;FieldCaption("Banked Amount"))
            {
            }
            column(Cash_Sale_Header__Banked_By_Caption;FieldCaption("Banked By"))
            {
            }
            column(Cash_Sale_Header__Banked_Date_Caption;FieldCaption("Banked Date"))
            {
            }
            column(TotalsCaption;TotalsCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   Amt:=0;
                   CashLine.Reset;
                   CashLine.SetRange(CashLine.No,"FIN-Cash Sale Header"."Doc No") ;
                   if CashLine.Find('-') then begin
                     repeat
                     Amt:=Amt+CashLine."Total Amount"
                     until CashLine.Next=0;
                   end;
                    "FIN-Cash Sale Header".Amount:=Amt;

                   if Amt=0 then begin
                     CurrReport.Skip
                   end;
            end;

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Doc No");
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
        Amt: Decimal;
        CashLine: Record UnknownRecord61158;
        Desc: Text[30];
        Receipt_BankingCaptionLbl: label 'Receipt Banking';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Being_Paid_ForCaptionLbl: label 'Being Paid For';
        TotalsCaptionLbl: label 'Totals';
}

