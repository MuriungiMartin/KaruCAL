#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51814 "CAT-Daily Sales Summary (All)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/CAT-Daily Sales Summary (All).rdlc';

    dataset
    {
        dataitem(UnknownTable61783;UnknownTable61783)
        {
            DataItemTableView = where(Status=filter(Posted));
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Receipt No.","Receipt Date";
            column(ReportForNavId_1; 1)
            {
            }
            column(ReceiptNo;"CAT-Cafeteria Receipts"."Receipt No.")
            {
            }
            column(Date;"CAT-Cafeteria Receipts"."Receipt Date")
            {
            }
            column(Amount;"CAT-Cafeteria Receipts".Amount)
            {
            }
            column(CashierName;"CAT-Cafeteria Receipts".User)
            {
            }

            trigger OnAfterGetRecord()
            begin

                //"Cafeteria Item Inventory".CALCFIELDS("Cafeteria Item Inventory"."Quantity Sold")
                // "Menu Sale Header".CALCFIELDS("Menu Sale Header".Amount);
            end;

            trigger OnPreDataItem()
            begin
                 "CAT-Cafeteria Receipts".SetFilter("CAT-Cafeteria Receipts"."Receipt Date",'=%1',datefilter);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(datefilter;datefilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sale Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        //  datefilter:=TODAY;
    end;

    trigger OnPreReport()
    begin
         if datefilter=0D then Error('Please specify the sale date.')
    end;

    var
        info: Record "Company Information";
        Address: Text[250];
        Tel: Code[100];
        Fax: Code[20];
        PIN: Code[20];
        Email: Text[50];
        VAT: Code[20];
        DetTotal: Decimal;
        totals: Decimal;
        change: Decimal;
        Amounts: Decimal;
        creditEmp: Code[150];
        datefilter: Date;
}

