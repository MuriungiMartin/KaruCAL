#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9100 "Purchase Line FactBox"
{
    Caption = 'Purchase Line Details';
    PageType = CardPart;
    SourceTable = "Purchase Line";

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Item No.';
                Lookup = false;
                ToolTip = 'Specifies the number of a general ledger account, item, resource, additional cost, or fixed asset, depending on the contents of the Type field.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(Availability;StrSubstNo('%1',PurchInfoPaneMgt.CalcAvailability(Rec)))
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Availability';
                DecimalPlaces = 2:0;
                DrillDown = true;
                Editable = true;
                ToolTip = 'Specifies how many units of the item on the line are available.';

                trigger OnDrillDown()
                begin
                    ItemAvailFormsMgt.ShowItemAvailFromPurchLine(Rec,ItemAvailFormsMgt.ByEvent);
                    CurrPage.Update(true);
                end;
            }
            field("STRSUBSTNO('%1',PurchInfoPaneMgt.CalcNoOfPurchasePrices(Rec))";StrSubstNo('%1',PurchInfoPaneMgt.CalcNoOfPurchasePrices(Rec)))
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Purchase Prices';
                DrillDown = true;
                Editable = true;
                ToolTip = 'Specifies how many special prices your vendor grants you for the purchase line. Choose the value to see the special purchase prices.';

                trigger OnDrillDown()
                begin
                    ShowPrices;
                    CurrPage.Update;
                end;
            }
            field("STRSUBSTNO('%1',PurchInfoPaneMgt.CalcNoOfPurchLineDisc(Rec))";StrSubstNo('%1',PurchInfoPaneMgt.CalcNoOfPurchLineDisc(Rec)))
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Purchase Line Discounts';
                DrillDown = true;
                Editable = true;
                ToolTip = 'Specifies how many special discounts your vendor grants you for the purchase line. Choose the value to see the purchase line discounts.';

                trigger OnDrillDown()
                begin
                    ShowLineDisc;
                    CurrPage.Update;
                end;
            }
        }
    }

    actions
    {
    }

    var
        PurchHeader: Record "Purchase Header";
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt.";
        PurchInfoPaneMgt: Codeunit "Purchases Info-Pane Management";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";

    local procedure ShowDetails()
    var
        Item: Record Item;
    begin
        if Type = Type::Item then begin
          Item.Get("No.");
          Page.Run(Page::"Item Card",Item);
        end;
    end;

    local procedure ShowPrices()
    begin
        PurchHeader.Get("Document Type","Document No.");
        Clear(PurchPriceCalcMgt);
        PurchPriceCalcMgt.GetPurchLinePrice(PurchHeader,Rec);
    end;

    local procedure ShowLineDisc()
    begin
        PurchHeader.Get("Document Type","Document No.");
        Clear(PurchPriceCalcMgt);
        PurchPriceCalcMgt.GetPurchLineLineDisc(PurchHeader,Rec);
    end;
}

