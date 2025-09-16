#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5721 "Item Cross Reference Entries"
{
    Caption = 'Item Cross Reference Entries';
    DataCaptionFields = "Item No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Item Cross Reference";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Cross-Reference Type";"Cross-Reference Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the cross-reference entry.';
                }
                field("Cross-Reference Type No.";"Cross-Reference Type No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a customer number, a vendor number, or a bar code, depending on what you have selected in the Type field.';
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the cross-referenced item number. If you enter a cross reference between yours and your vendor''s or customer''s item number, then this number will override the standard item number when you enter the cross-reference number on a sales or purchase document.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the variant code for the item.';
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure for this cross-reference entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the item linked to this cross reference. It will override the standard description when entered on an order.';
                }
                field("Discontinue Bar Code";"Discontinue Bar Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you want the program to discontinue a bar code cross reference.';
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
}

