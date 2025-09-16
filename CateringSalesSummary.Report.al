#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51706 "Catering Sales Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Catering Sales Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61170;UnknownTable61170)
        {
            RequestFilterFields = "Date Filter","Cashier Name";
            column(ReportForNavId_1; 1)
            {
            }
            column(ReceiptNo_MenuSaleHeader;"CAT-Menu Sale Header"."Receipt No")
            {
            }
            column(Date_MenuSaleHeader;"CAT-Menu Sale Header".Date)
            {
            }
            column(CashierNo_MenuSaleHeader;"CAT-Menu Sale Header"."Cashier No")
            {
            }
            column(CustomerType_MenuSaleHeader;"CAT-Menu Sale Header"."Customer Type")
            {
            }
            column(CustomerNo_MenuSaleHeader;"CAT-Menu Sale Header"."Customer No")
            {
            }
            column(CustomerName_MenuSaleHeader;"CAT-Menu Sale Header"."Customer Name")
            {
            }
            column(ReceivingBank_MenuSaleHeader;"CAT-Menu Sale Header"."Receiving Bank")
            {
            }
            column(Amount_MenuSaleHeader;"CAT-Menu Sale Header".Amount)
            {
            }
            column(Department_MenuSaleHeader;"CAT-Menu Sale Header".Department)
            {
            }
            column(ContactStaff_MenuSaleHeader;"CAT-Menu Sale Header"."Contact Staff")
            {
            }
            column(SalesPoint_MenuSaleHeader;"CAT-Menu Sale Header"."Sales Point")
            {
            }
            column(PaidAmount_MenuSaleHeader;"CAT-Menu Sale Header"."Paid Amount")
            {
            }
            column(Balance_MenuSaleHeader;"CAT-Menu Sale Header".Balance)
            {
            }
            column(Posted_MenuSaleHeader;"CAT-Menu Sale Header".Posted)
            {
            }
            column(CashierName_MenuSaleHeader;"CAT-Menu Sale Header"."Cashier Name")
            {
            }
            column(SalesType_MenuSaleHeader;"CAT-Menu Sale Header"."Sales Type")
            {
            }
            column(PrepaymentBalance_MenuSaleHeader;"CAT-Menu Sale Header"."Prepayment Balance")
            {
            }
            column(LastSc_MenuSaleHeader;"CAT-Menu Sale Header"."Last Sc")
            {
            }
            column(LineAmount_MenuSaleHeader;"CAT-Menu Sale Header"."Line Amount")
            {
            }
            column(DailyTotalPrepayment_MenuSaleHeader;"CAT-Menu Sale Header"."Daily Total Prepayment")
            {
            }
            column(DailyTotalCash_MenuSaleHeader;"CAT-Menu Sale Header"."Daily Total Cash")
            {
            }
            column(Sum2;TotalCash+TotalPrep)
            {
            }
            column(UserTotalCash;TotalCash)
            {
            }
            column(UserTotalPrep;TotalPrep)
            {
            }
            column(TotalAmount;"CAT-Menu Sale Header"."Total Amount")
            {
            }
            column(TotalPrepayment_MenuSaleHeader;"CAT-Menu Sale Header"."Total Prepayment")
            {
            }
            column(TotalCash_MenuSaleHeader;"CAT-Menu Sale Header"."Total Cash")
            {
            }

            trigger OnAfterGetRecord()
            begin

                      TotalCash:=0;
                     TotalPrep:=0;
                     SaleH.Reset;
                    SaleH.SetRange(SaleH."Cashier Name","CAT-Menu Sale Header"."Cashier Name");
                    SaleH.SetFilter(SaleH.Date,"CAT-Menu Sale Header".GetFilter("CAT-Menu Sale Header".Date));
                    if SaleH.Find('-') then begin
                  //  REPEAT
                    SaleH.CalcFields(SaleH."Daily Total Cash");
                    SaleH.CalcFields(SaleH."Daily Total Prepayment");
                    TotalCash:=SaleH."Daily Total Cash";
                    TotalPrep:=SaleH."Daily Total Prepayment";
                   // UNTIL SaleH.NEXT=0;
                    end;
            end;

            trigger OnPreDataItem()
            begin
                   SetFilter("CAT-Menu Sale Header".Date,GetFilter("CAT-Menu Sale Header"."Date Filter"));
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
        TotalCash: Decimal;
        SaleH: Record UnknownRecord61170;
        TotalPrep: Integer;
}

