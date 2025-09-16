#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7501 "Item Attribute Values"
{
    Caption = 'Item Attribute Values';
    DataCaptionFields = "Attribute ID";
    PageType = List;
    SourceTable = "Item Attribute Value";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the value of the item attribute.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether it should be possible to assign this item attribute value to an item.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Process)
            {
                Caption = 'Process';
                action(ItemAttributeValueTranslations)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Item Attr. Value Translations";
                    RunPageLink = "Attribute ID"=field("Attribute ID"),
                                  ID=field(ID);
                    ToolTip = 'Opens a window in which you can specify the translations of the selected item attribute value.';
                }
            }
        }
    }

    trigger OnOpenPage()
    var
        AttributeID: Integer;
    begin
        if GetFilter("Attribute ID") <> '' then
          AttributeID := GetRangeMin("Attribute ID");
        if AttributeID <> 0 then begin
          FilterGroup(2);
          SetRange("Attribute ID",AttributeID);
          FilterGroup(0);
        end;
    end;
}

