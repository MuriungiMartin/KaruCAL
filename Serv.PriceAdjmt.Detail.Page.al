#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6083 "Serv. Price Adjmt. Detail"
{
    Caption = 'Serv. Price Adjmt. Detail';
    DataCaptionExpression = FormCaption;
    PageType = List;
    SourceTable = "Serv. Price Adjustment Detail";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Serv. Price Adjmt. Gr. Code";"Serv. Price Adjmt. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service price adjustment group that applies to the posted service line.';
                    Visible = ServPriceAdjmtGrCodeVisible;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type for the service item line to be adjusted.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service item, resource, resource group, or service cost, depending on the value selected in the Type field.';
                }
                field("Work Type";"Work Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the work type of the resource.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the general product posting group associated with the item or resource on the line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service item, resource, resource group, or service cost, of which the price will be adjusted, based on the value selected in the Type field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        ServPriceAdjmtGrCodeVisible := true;
    end;

    trigger OnOpenPage()
    var
        ServPriceAdjmtGroup: Record "Service Price Adjustment Group";
        ShowColumn: Boolean;
    begin
        ShowColumn := true;
        if GetFilter("Serv. Price Adjmt. Gr. Code") <> '' then
          if ServPriceAdjmtGroup.Get("Serv. Price Adjmt. Gr. Code") then
            ShowColumn := false
          else
            Reset;
        ServPriceAdjmtGrCodeVisible := ShowColumn;
    end;

    var
        [InDataSet]
        ServPriceAdjmtGrCodeVisible: Boolean;

    local procedure FormCaption(): Text[180]
    var
        ServPriceAdjmtGrp: Record "Service Price Adjustment Group";
    begin
        if GetFilter("Serv. Price Adjmt. Gr. Code") <> '' then
          if ServPriceAdjmtGrp.Get("Serv. Price Adjmt. Gr. Code") then
            exit(StrSubstNo('%1 %2',"Serv. Price Adjmt. Gr. Code",ServPriceAdjmtGrp.Description));
    end;
}

