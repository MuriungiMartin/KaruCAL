#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7313 "Put-away Template Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Put-away Template Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Find Fixed Bin";"Find Fixed Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a bin must be used in the put-away process, if the Fixed field is selected on the line for the item in the bin contents window.';
                }
                field("Find Floating Bin";"Find Floating Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a floating bin must be used in the put-away process.';
                }
                field("Find Same Item";"Find Same Item")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a bin, which Specifies the same item that is being put away, is used in the put-away process.';
                }
                field("Find Unit of Measure Match";"Find Unit of Measure Match")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a bin, which Specifies the item in the same unit of measure as the item that is being put away, must be used.';
                }
                field("Find Bin w. Less than Min. Qty";"Find Bin w. Less than Min. Qty")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a fixed bin, with a quantity of item below the specified minimum quantity, must be used.';
                }
                field("Find Empty Bin";"Find Empty Bin")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that an empty bin must be used in the put-away process.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the set of criteria that is on the put-away template line.';
                }
            }
        }
    }

    actions
    {
    }
}

