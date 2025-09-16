#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7500 "Item Attributes"
{
    ApplicationArea = Basic;
    Caption = 'Item Attributes';
    CardPageID = "Item Attribute";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Item Attribute";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the item attribute.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the item attribute.';
                }
                field(Values;GetValues)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Values';
                    ToolTip = 'Specifies the values of the item attribute.';

                    trigger OnDrillDown()
                    begin
                        OpenItemAttributeValues;
                    end;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether it should be possible to assign this item attribute to an item.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Attribute")
            {
                Caption = '&Attribute';
                Image = Attributes;
                action(ItemAttributeValues)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Item Attribute &Values';
                    Enabled = (Type = Type::Option);
                    Image = CalculateInventory;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Item Attribute Values";
                    RunPageLink = "Attribute ID"=field(ID);
                    ToolTip = 'Opens a window in which you can define the values for the selected item attribute.';
                }
                action(ItemAttributeTranslations)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Translations';
                    Image = Translations;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Item Attribute Translations";
                    RunPageLink = "Attribute ID"=field(ID);
                    ToolTip = 'Opens a window in which you can define the translations for the selected item attribute.';
                }
            }
        }
    }
}

