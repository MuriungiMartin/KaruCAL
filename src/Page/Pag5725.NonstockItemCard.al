#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5725 "Nonstock Item Card"
{
    Caption = 'Nonstock Item Card';
    PageType = Card;
    SourceTable = "Nonstock Item";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number assigned to the nonstock item, when you enter an item on a nonstock item card.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit then
                          CurrPage.Update;
                    end;
                }
                field("Manufacturer Code";"Manufacturer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the manufacturer of the nonstock item.';
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the vendor from whom you can purchase the nonstock item.';
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number the vendor uses to identify the nonstock item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the item number that the program has generated for this nonstock item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the nonstock item.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for the unit of measure in which the nonstock item is sold.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the nonstock item card was last modified.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Published Cost";"Published Cost")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the published cost or vendor list price for the nonstock item.';
                }
                field("Negotiated Cost";"Negotiated Cost")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the price you negotiated to pay for the nonstock item.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the unit price of the nonstock item in the local currency ($).';
                }
                field("Gross Weight";"Gross Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the gross weight, including the weight of any packaging, of the nonstock item.';
                }
                field("Net Weight";"Net Weight")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the net weight of the item. The weight of packaging materials is not included.';
                }
                field("Bar Code";"Bar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bar code of the nonstock item.';
                }
                field("Item Template Code";"Item Template Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the item template used for this nonstock item.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Nonstoc&k Item")
            {
                Caption = 'Nonstoc&k Item';
                Image = NonStockItem;
                action("Substituti&ons")
                {
                    ApplicationArea = Suite;
                    Caption = 'Substituti&ons';
                    Image = ItemSubstitution;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type=const("Nonstock Item"),
                                  "No."=field("Entry No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const("Nonstock Item"),
                                  "No."=field("Entry No.");
                }
            }
        }
        area(creation)
        {
            action("New Item")
            {
                ApplicationArea = Basic;
                Caption = 'New Item';
                Image = NewItem;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Item Card";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Create Item")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = '&Create Item';
                    Image = NewItemNonStock;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Convert the nonstock item card to a normal item card, according to an item template that you choose.';

                    trigger OnAction()
                    begin
                        NonstockItemMgt.NonstockAutoItem(Rec);
                    end;
                }
            }
        }
    }

    var
        NonstockItemMgt: Codeunit "Catalog Item Management";
}

