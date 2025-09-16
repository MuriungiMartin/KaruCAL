#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51282 "Items Receipt Ledger"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Items Receipt Ledger.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry";"Item Ledger Entry")
        {
            DataItemTableView = where("Entry Type"=const(Purchase));
            RequestFilterFields = "Item No.","Posting Date";
            column(ReportForNavId_7209; 7209)
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
            column(Item_Ledger_Entry__Posting_Date_;"Posting Date")
            {
            }
            column(Item_Ledger_Entry__Document_No__;"Document No.")
            {
            }
            column(SuppName;SuppName)
            {
            }
            column(Item_Ledger_Entry_Quantity;Quantity)
            {
            }
            column(UnitCost;UnitCost)
            {
            }
            column(Item_Ledger_Entry__Purchase_Amount__Actual__;"Purchase Amount (Actual)")
            {
            }
            column(Item_Ledger_Entry__Item_No__;"Item No.")
            {
            }
            column(Stock_Receipt_LedgerCaption;Stock_Receipt_LedgerCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Document_No__Caption;FieldCaption("Document No."))
            {
            }
            column(SupplierCaption;SupplierCaptionLbl)
            {
            }
            column(Item_Ledger_Entry_QuantityCaption;FieldCaption(Quantity))
            {
            }
            column(Invoice_Unit_PriceCaption;Invoice_Unit_PriceCaptionLbl)
            {
            }
            column(ValueCaption;ValueCaptionLbl)
            {
            }
            column(Item_Ledger_Entry__Item_No__Caption;FieldCaption("Item No."))
            {
            }
            column(Item_Ledger_Entry_Entry_No_;"Entry No.")
            {
            }
            column(ItemName;itemName)
            {
            }

            trigger OnAfterGetRecord()
            begin
                item.Reset;
                item.SetRange(item."No.","Item Ledger Entry"."Item No.");
                if item.Find('-') then
                itemName:=item.Description;

                Supplier.Reset;
                Supplier.SetRange(Supplier."No.","Item Ledger Entry"."Source No.");
                if Supplier.Find('-') then
                SuppName:=Supplier.Name;

                UnitCost:="Item Ledger Entry"."Purchase Amount (Actual)"/"Item Ledger Entry".Quantity;
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
        Supplier: Record Vendor;
        UnitCost: Decimal;
        SuppName: Text[60];
        Stock_Receipt_LedgerCaptionLbl: label 'Stock Receipt Ledger';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DateCaptionLbl: label 'Date';
        SupplierCaptionLbl: label 'Supplier';
        Invoice_Unit_PriceCaptionLbl: label 'Invoice Unit Price';
        ValueCaptionLbl: label 'Value';
        item: Record Item;
        itemName: Text[150];
}

