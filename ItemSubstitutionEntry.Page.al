#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5716 "Item Substitution Entry"
{
    Caption = 'Item Substitution Entry';
    DataCaptionFields = "No.";
    DelayedInsert = true;
    PageType = List;
    RefreshOnActivate = false;
    SourceTable = "Item Substitution";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the variant that can be used as a substitute.';
                }
                field("Substitute Type";"Substitute Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the type of the item that can be used as a substitute.';
                }
                field("Substitute No.";"Substitute No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the number of the item that can be used as a substitute in case the original item is unavailable.';
                }
                field("Substitute Variant Code";"Substitute Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the variant that can be used as a substitute.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the description of the substitute item.';
                }
                field(Interchangeable;Interchangeable)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies that the item and the substitute item are interchangeable.';
                }
                field(Condition;Condition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a condition exists for this substitution.';
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
        area(processing)
        {
            action("&Condition")
            {
                ApplicationArea = Basic;
                Caption = '&Condition';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Condition Entry";
                RunPageLink = Type=field(Type),
                              "No."=field("No."),
                              "Variant Code"=field("Variant Code"),
                              "Substitute Type"=field("Substitute Type"),
                              "Substitute No."=field("Substitute No."),
                              "Substitute Variant Code"=field("Substitute Variant Code");
            }
        }
    }
}

