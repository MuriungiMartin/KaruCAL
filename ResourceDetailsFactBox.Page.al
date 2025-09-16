#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9108 "Resource Details FactBox"
{
    Caption = 'Resource Details';
    PageType = CardPart;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource No.';
                ToolTip = 'Specifies a number for the resource.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(NoOfResourcePrices;NoOfResourcePrices)
            {
                ApplicationArea = Jobs;
                Caption = 'Prices';
                DrillDown = true;
                Editable = true;
                ToolTip = 'Specifies the resource prices.';

                trigger OnDrillDown()
                var
                    RescPrice: Record "Resource Price";
                begin
                    RescPrice.SetRange(Type,RescPrice.Type::Resource);
                    RescPrice.SetRange(Code,"No.");

                    Page.Run(Page::"Resource Prices",RescPrice);
                end;
            }
            field(NoOfResourceCosts;NoOfResourceCosts)
            {
                ApplicationArea = Jobs;
                Caption = 'Costs';
                DrillDown = true;
                Editable = true;
                ToolTip = 'Specifies detailed information about costs for the resource.';

                trigger OnDrillDown()
                var
                    RescCost: Record "Resource Cost";
                begin
                    RescCost.SetRange(Type,RescCost.Type::Resource);
                    RescCost.SetRange(Code,"No.");

                    Page.Run(Page::"Resource Costs",RescCost);
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcNoOfRecords;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        NoOfResourcePrices := 0;
        NoOfResourceCosts := 0;

        exit(Find(Which));
    end;

    trigger OnOpenPage()
    begin
        CalcNoOfRecords;
    end;

    var
        NoOfResourcePrices: Integer;
        NoOfResourceCosts: Integer;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Resource Card",Rec);
    end;

    local procedure CalcNoOfRecords()
    var
        ResourcePrice: Record "Resource Price";
        ResourceCost: Record "Resource Cost";
    begin
        ResourcePrice.Reset;
        ResourcePrice.SetRange(Type,ResourcePrice.Type::Resource);
        ResourcePrice.SetRange(Code,"No.");
        NoOfResourcePrices := ResourcePrice.Count;

        ResourceCost.Reset;
        ResourceCost.SetRange(Type,ResourceCost.Type::Resource);
        ResourceCost.SetRange(Code,"No.");
        NoOfResourceCosts := ResourceCost.Count;
    end;
}

