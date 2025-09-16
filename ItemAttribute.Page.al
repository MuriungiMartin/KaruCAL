#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7503 "Item Attribute"
{
    Caption = 'Item Attribute';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "Item Attribute";

    layout
    {
        area(content)
        {
            group(Control9)
            {
                group(Control2)
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

                        trigger OnValidate()
                        begin
                            UpdateControlVisibility;
                        end;
                    }
                    field(Blocked;Blocked)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies if the item attribute can be assigned to items.';
                    }
                }
                group(Control11)
                {
                    Visible = ValuesDrillDownVisible;
                    field(Values;GetValues)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Values';
                        Editable = false;
                        ToolTip = 'Specifies the values of the item attribute.';

                        trigger OnDrillDown()
                        begin
                            OpenItemAttributeValues;
                        end;
                    }
                }
                group(Control13)
                {
                    Visible = UnitOfMeasureVisible;
                    field("Unit of Measure";"Unit of Measure")
                    {
                        ApplicationArea = Basic,Suite;
                        DrillDown = false;
                        ToolTip = 'Specifies the unit of measure for the item attribute.';

                        trigger OnDrillDown()
                        begin
                            OpenItemAttributeValues;
                        end;
                    }
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ItemAttributeValues)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Item Attribute &Values';
                Enabled = ValuesDrillDownVisible;
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

    trigger OnAfterGetCurrRecord()
    begin
        UpdateControlVisibility;
    end;

    trigger OnOpenPage()
    begin
        UpdateControlVisibility;
    end;

    var
        ValuesDrillDownVisible: Boolean;
        UnitOfMeasureVisible: Boolean;

    local procedure UpdateControlVisibility()
    begin
        ValuesDrillDownVisible := (Type = Type::Option);
        UnitOfMeasureVisible := (Type = Type::Decimal) or (Type = Type::Integer);
    end;
}

