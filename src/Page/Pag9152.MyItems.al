#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9152 "My Items"
{
    Caption = 'My Items';
    PageType = ListPart;
    SourceTable = "My Item";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the item numbers that are displayed in the My Item Cue on the Role Center.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies a description of the item.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Unit Price';
                    DrillDown = false;
                    Lookup = false;
                    ToolTip = 'Specifies the item''s unit price.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Open)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Open';
                Image = ViewDetails;
                RunObject = Page "Item Card";
                RunPageLink = "No."=field("Item No.");
                RunPageMode = View;
                ShortCutKey = 'Return';
                ToolTip = 'Open the card for the selected record.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRange("User ID",UserId);
    end;
}

