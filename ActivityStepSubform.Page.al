#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5102 "Activity Step Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Activity Step";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of the step. There are three options:';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the step.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the priority of the step. There are three options:';
                }
                field("Date Formula";"Date Formula")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date formula that determines how to calculate when the step should be completed.';
                }
            }
        }
    }

    actions
    {
    }
}

