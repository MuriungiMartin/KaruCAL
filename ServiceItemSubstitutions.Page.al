#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5954 "Service Item Substitutions"
{
    Caption = 'Service Item Substitutions';
    DataCaptionFields = Interchangeable;
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Item Substitution";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Substitute Type";"Substitute Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of the item that can be used as a substitute.';
                }
                field("Substitute No.";"Substitute No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item that can be used as a substitute.';
                }
                field("Substitute Variant Code";"Substitute Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the variant that can be used as a substitute.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the substitute item.';
                }
                field("Sub. Item No.";"Sub. Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number of the nonstock substitute item.';
                }
                field(Condition;Condition)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that a condition exists for this substitution.';
                }
                field(Inventory;Inventory)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units (such as pieces, boxes, or cans) of the item are available.';
                }
                field("Relations Level";"Relations Level")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the priority level of this substitute item.';
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
                RunObject = Page "Sub. Conditions";
                RunPageLink = Type=field(Type),
                              "No."=field("No."),
                              "Variant Code"=field("Variant Code"),
                              "Substitute Type"=field("Substitute Type"),
                              "Substitute No."=field("Substitute No."),
                              "Substitute Variant Code"=field("Substitute Variant Code");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if ("Substitute Type" <> "substitute type"::"Nonstock Item") and
           ("Sub. Item No." <> '')
        then
          Clear("Sub. Item No.");
    end;
}

