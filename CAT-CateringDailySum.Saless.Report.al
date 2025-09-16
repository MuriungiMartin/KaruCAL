#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51815 "CAT-Catering Daily Sum. Saless"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Catering Daily Sum. Saless.rdlc';

    dataset
    {
        dataitem(UnknownTable61783;UnknownTable61783)
        {
            DataItemTableView = where(Status=filter(Posted));
            column(ReportForNavId_1; 1)
            {
            }
            column(ReceiptNo_MenuSaleHeader;"CAT-Cafeteria Receipts"."Receipt No.")
            {
            }
            column(Date_MenuSaleHeader;"CAT-Cafeteria Receipts"."Receipt Date")
            {
            }
            column(CashierNo_MenuSaleHeader;"CAT-Cafeteria Receipts".User)
            {
            }
            column(CustomerType_MenuSaleHeader;"CAT-Cafeteria Receipts"."Customer No.")
            {
            }
            column(CustomerNo_MenuSaleHeader;"CAT-Cafeteria Receipts"."Cashier Bank")
            {
            }
            column(CustomerName_MenuSaleHeader;"CAT-Cafeteria Receipts".User)
            {
            }
            column(ReceivingBank_MenuSaleHeader;"CAT-Cafeteria Receipts"."Cashier Bank")
            {
            }
            column(Amount_MenuSaleHeader;"CAT-Cafeteria Receipts"."Recept Total")
            {
            }
            column(Department_MenuSaleHeader;"CAT-Cafeteria Receipts"."Department Name")
            {
            }
            column(ContactStaff_MenuSaleHeader;"CAT-Cafeteria Receipts"."Employee Name")
            {
            }
            column(SalesPoint_MenuSaleHeader;"CAT-Cafeteria Receipts".Sections)
            {
            }
            column(PaidAmount_MenuSaleHeader;"CAT-Cafeteria Receipts"."Recept Total")
            {
            }
            column(Balance_MenuSaleHeader;"CAT-Cafeteria Receipts"."Recept Total"-"CAT-Cafeteria Receipts".Amount)
            {
            }
            column(Posted_MenuSaleHeader;"CAT-Cafeteria Receipts".Status)
            {
            }
            column(CashierName_MenuSaleHeader;"CAT-Cafeteria Receipts".User)
            {
            }
            column(SalesType_MenuSaleHeader;"CAT-Cafeteria Receipts"."Transaction Type")
            {
            }
            column(PrepaymentBalance_MenuSaleHeader;0)
            {
            }
            column(LastSc_MenuSaleHeader;'')
            {
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
}

