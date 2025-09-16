#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5700 "Nonstock Item Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Nonstock Item Sales.rdlc';
    Caption = 'Nonstock Item Sales';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Item Ledger Entry";"Item Ledger Entry")
        {
            DataItemTableView = sorting("Item No.","Entry Type");
            RequestFilterFields = "Item No.","Location Code","Posting Date";
            column(ReportForNavId_7209; 7209)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CaptionLedgFilter;TableCaption + ': ' + ItemLedgerFilter)
            {
            }
            column(ItemLedgerFilter;ItemLedgerFilter)
            {
            }
            column(ValueEntryInvoicedQty;-"Value Entry"."Invoiced Quantity")
            {
                DecimalPlaces = 0:5;
            }
            column(SalesAmtAct_ValueEntry;"Value Entry"."Sales Amount (Actual)")
            {
            }
            column(ItemDescription;Item.Description)
            {
            }
            column(ItemLedgerEntryItemNo;"Item No.")
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(NonstockItemSalesCaption;NonstockItemSalesCaptionLbl)
            {
            }
            column(ItemNoCaption;ItemNoCaptionLbl)
            {
            }
            column(QuantityCaption;QuantityCaptionLbl)
            {
            }
            column(AmountCaption;AmountCaptionLbl)
            {
            }
            column(ValueEntryDocDateCaption;ValueEntryDocDateCaptionLbl)
            {
            }
            column(ValueEntryPostingDateCaption;ValueEntryPostingDateCaptionLbl)
            {
            }
            column(TotalSalesCaption;TotalSalesCaptionLbl)
            {
            }
            dataitem("Value Entry";"Value Entry")
            {
                DataItemLink = "Item Ledger Entry No."=field("Entry No.");
                DataItemTableView = sorting("Item Ledger Entry No.");
                column(ReportForNavId_8894; 8894)
                {
                }
                column(ValueEntryDocumentNo;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(ValueEntryDocDate;Format("Document Date"))
                {
                }
                column(ValueEntryPostingDate;Format("Posting Date"))
                {
                }
                column(LocCode_ValueEntry;"Location Code")
                {
                    IncludeCaption = true;
                }
                column(ItemLedrEntryPurCode;"Item Ledger Entry"."Purchasing Code")
                {
                    IncludeCaption = true;
                }
                column(DropShip_ValueEntry;"Drop Shipment")
                {
                    IncludeCaption = true;
                }
                column(InvoicedQuantity;-"Invoiced Quantity")
                {
                    DecimalPlaces = 0:5;
                }
                column(ValueEntryItemNo;"Item No.")
                {
                }
                column(FormatDropShipment;Format("Drop Shipment"))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Expected Cost" then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Invoiced Quantity","Sales Amount (Actual)");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Entry Type" <> "entry type"::Sale then begin
                  SetRange("Item No.","Item No.");
                  SetRange("Entry Type","Entry Type");
                  Find('+');
                  SetRange("Item No.");
                  SetRange("Entry Type");
                end;

                if not Nonstock then
                  CurrReport.Skip;

                if not Item.Get("Item No.") then
                  Item.Description := '';
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Value Entry"."Invoiced Quantity","Value Entry"."Sales Amount (Actual)");
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
        ItemLedgerFilter := "Item Ledger Entry".GetFilters;
    end;

    var
        Item: Record Item;
        ItemLedgerFilter: Text;
        CurrReportPageNoCaptionLbl: label 'Page';
        NonstockItemSalesCaptionLbl: label 'Nonstock Item - Sales';
        ItemNoCaptionLbl: label 'Item No.';
        QuantityCaptionLbl: label 'Quantity';
        AmountCaptionLbl: label 'Amount';
        ValueEntryDocDateCaptionLbl: label 'Document Date';
        ValueEntryPostingDateCaptionLbl: label 'Posting Date';
        TotalSalesCaptionLbl: label 'Total Sales';
}

