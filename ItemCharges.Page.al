#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5800 "Item Charges"
{
    ApplicationArea = Basic;
    Caption = 'Item Charges';
    PageType = List;
    SourceTable = "Item Charge";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number used for identifying a specific kind of item charge.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the item charge number that you are setting up.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the general product posting group to which this item charge belongs.';
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the sales tax group code that this item charge belongs to.';
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the Tax product posting group to which this item charge belongs.';
                }
                field("Search Description";"Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies text to search for when you do not know the number of the item.';
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
            group("&Item Charge")
            {
                Caption = '&Item Charge';
                Image = Add;
                action("Value E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Value E&ntries';
                    Image = ValueLedger;
                    RunObject = Page "Value Entries";
                    RunPageLink = "Entry Type"=const("Direct Cost"),
                                  "Item Charge No."=field("No.");
                    RunPageView = sorting("Item Charge No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(5800),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
            }
        }
    }
}

