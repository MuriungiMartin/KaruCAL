#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7380 "Phys. Invt. Item Selection"
{
    Caption = 'Phys. Invt. Item Selection';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Phys. Invt. Item Selection";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item for which the cycle counting can be performed.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the item.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant of the item for which the cycle counting can be performed.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location where the cycle counting is performed.';
                }
                field("Shelf No.";"Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shelf number of the item for informational use.';
                    Visible = false;
                }
                field("Phys Invt Counting Period Code";"Phys Invt Counting Period Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the counting period that indicates how often you want to count the item or stockkeeping unit in a physical inventory.';
                }
                field("Last Counting Date";"Last Counting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last date when the counting period for the item or stockkeeping unit was updated.';
                }
                field("Next Counting Start Date";"Next Counting Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Next Counting End Date";"Next Counting End Date")
                {
                    ApplicationArea = Basic;
                }
                field("Count Frequency per Year";"Count Frequency per Year")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of times you want the item or stockkeeping unit to be counted each year.';
                    Visible = false;
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
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Item Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Card';
                    Image = Item;
                    RunObject = Page "Item Card";
                    RunPageLink = "No."=field("Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("SKU Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'SKU Card';
                    Image = SKU;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Location Code"=field("Location Code");
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction = Action::LookupOK then
          LookupOKOnPush;
    end;

    local procedure LookupOKOnPush()
    begin
        CurrPage.SetSelectionFilter(Rec);
        ModifyAll(Selected,true);
    end;
}

