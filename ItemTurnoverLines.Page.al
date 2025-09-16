#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 354 "Item Turnover Lines"
{
    Caption = 'Lines';
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Date;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("Period Start";"Period Start")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Start';
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Period Name';
                }
                field(PurchasesQty;Item."Purchases (Qty.)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchases (Qty.)';
                    DecimalPlaces = 0:5;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowItemEntries(false);
                    end;
                }
                field(PurchasesLCY;Item."Purchases (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Purchases ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowItemEntries(false);
                    end;
                }
                field(SalesQty;Item."Sales (Qty.)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales (Qty.)';
                    DecimalPlaces = 0:5;
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowItemEntries(true);
                    end;
                }
                field(SalesLCY;Item."Sales (LCY)")
                {
                    ApplicationArea = Basic;
                    AutoFormatType = 1;
                    Caption = 'Sales ($)';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        ShowItemEntries(true);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetDateFilter;
        Item.CalcFields("Purchases (Qty.)","Purchases (LCY)","Sales (Qty.)","Sales (LCY)");
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        exit(PeriodFormMgt.FindDate(Which,Rec,PeriodType));
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(PeriodFormMgt.NextDate(Steps,Rec,PeriodType));
    end;

    trigger OnOpenPage()
    begin
        Reset;
    end;

    var
        Item: Record Item;
        ItemLedgEntry: Record "Item Ledger Entry";
        PeriodFormMgt: Codeunit PeriodFormManagement;
        PeriodType: Option Day,Week,Month,Quarter,Year,"Accounting Period";
        AmountType: Option "Net Change","Balance at Date";


    procedure Set(var NewItem: Record Item;NewPeriodType: Integer;NewAmountType: Option "Net Change","Balance at Date")
    begin
        Item.Copy(NewItem);
        PeriodType := NewPeriodType;
        AmountType := NewAmountType;
        CurrPage.Update(false);
    end;

    local procedure ShowItemEntries(ShowSales: Boolean)
    begin
        SetDateFilter;
        ItemLedgEntry.Reset;
        ItemLedgEntry.SetCurrentkey("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
        ItemLedgEntry.SetRange("Item No.",Item."No.");
        ItemLedgEntry.SetFilter("Variant Code",Item.GetFilter("Variant Filter"));
        ItemLedgEntry.SetFilter("Drop Shipment",Item.GetFilter("Drop Shipment Filter"));
        ItemLedgEntry.SetFilter("Location Code",Item.GetFilter("Location Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 1 Code",Item.GetFilter("Global Dimension 1 Filter"));
        ItemLedgEntry.SetFilter("Global Dimension 2 Code",Item.GetFilter("Global Dimension 2 Filter"));
        ItemLedgEntry.SetFilter("Posting Date",Item.GetFilter("Date Filter"));
        if ShowSales then
          ItemLedgEntry.SetRange("Entry Type",ItemLedgEntry."entry type"::Sale)
        else
          ItemLedgEntry.SetRange("Entry Type",ItemLedgEntry."entry type"::Purchase);
        Page.Run(0,ItemLedgEntry);
    end;

    local procedure SetDateFilter()
    begin
        if AmountType = Amounttype::"Net Change" then
          Item.SetRange("Date Filter","Period Start","Period End")
        else
          Item.SetRange("Date Filter",0D,"Period End");
    end;
}

