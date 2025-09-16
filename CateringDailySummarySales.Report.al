#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51710 "Catering Daily Summary Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Catering Daily Summary Sales.rdlc';

    dataset
    {
        dataitem(UnknownTable61170;UnknownTable61170)
        {
            RequestFilterFields = Date,"Sales Type";
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
            column(UserTotalCash;TotalCash)
            {
            }
            column(UserTotalPrep;TotalPrep)
            {
            }

            trigger OnAfterGetRecord()
            begin
                     /*
                    TotalCash:=0;
                    TotalPrep:=0;
                    SaleH.RESET;
                    SaleH.SETRANGE(SaleH."Cashier Name","Menu Sale Header"."Cashier Name");
                    //SaleH.SETFILTER(SaleH.Date,"Menu Sale Header".GETFILTER("Menu Sale Header".Date));
                    SaleH.SETRANGE(SaleH.Date,"Menu Sale Header".Date);
                    IF SaleH.FIND('-') THEN BEGIN
                    REPEAT
                    SaleH.CALCFIELDS(SaleH."Total Cash");
                    SaleH.CALCFIELDS(SaleH."Total Prepayment");
                    TotalCash:=TotalCash+SaleH."Total Cash";
                    TotalPrep:=TotalPrep+SaleH."Total Prepayment";
                    UNTIL SaleH.NEXT=0;
                    END;
                     */

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
        TotalCash: Integer;
        SaleH: Record UnknownRecord61170;
        TotalPrep: Integer;
}

