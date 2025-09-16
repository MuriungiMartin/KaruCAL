#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9124 "Service Line FactBox"
{
    Caption = 'Service Line Details';
    PageType = CardPart;
    SourceTable = "Service Line";

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Basic;
                Caption = 'Item No.';
                Lookup = false;
                ToolTip = 'Specifies the number of an item, general ledger account, resource code, cost, or standard text.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field("STRSUBSTNO('%1',ServInfoPaneMgt.CalcAvailability(Rec))";StrSubstNo('%1',ServInfoPaneMgt.CalcAvailability(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Availability';
                DecimalPlaces = 2:0;
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ItemAvailFormsMgt.ShowItemAvailFromServLine(Rec,ItemAvailFormsMgt.ByEvent);
                end;
            }
            field("STRSUBSTNO('%1',ServInfoPaneMgt.CalcNoOfSubstitutions(Rec))";StrSubstNo('%1',ServInfoPaneMgt.CalcNoOfSubstitutions(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Substitutions';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ShowItemSub;
                    CurrPage.Update;
                end;
            }
            field("STRSUBSTNO('%1',ServInfoPaneMgt.CalcNoOfSalesPrices(Rec))";StrSubstNo('%1',ServInfoPaneMgt.CalcNoOfSalesPrices(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Prices';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ShowPrices;
                    CurrPage.Update;
                end;
            }
            field("STRSUBSTNO('%1',ServInfoPaneMgt.CalcNoOfSalesLineDisc(Rec))";StrSubstNo('%1',ServInfoPaneMgt.CalcNoOfSalesLineDisc(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Line Discounts';
                DrillDown = true;
                Editable = true;

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
        ServHeader: Record "Service Header";
        ServInfoPaneMgt: Codeunit "Service Info-Pane Management";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt.";
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
        ServHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetServLinePrice(ServHeader,Rec);
    end;

    local procedure ShowLineDisc()
    begin
        ServHeader.Get("Document Type","Document No.");
        Clear(SalesPriceCalcMgt);
        SalesPriceCalcMgt.GetServLineLineDisc(ServHeader,Rec);
    end;
}

