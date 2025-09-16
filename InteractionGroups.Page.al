#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5074 "Interaction Groups"
{
    ApplicationArea = Basic;
    Caption = 'Interaction Groups';
    PageType = List;
    SourceTable = "Interaction Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the interaction group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the interaction group.';
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
            group("&Interaction Group")
            {
                Caption = '&Interaction Group';
                Image = Group;
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Interaction Group Code"=field(Code);
                    RunPageView = sorting("Interaction Group Code");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Interaction Group Statistics";
                    RunPageLink = Code=field(Code);
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Interaction &Templates")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction &Templates';
                    Image = InteractionTemplate;
                    RunObject = Page "Interaction Templates";
                    RunPageLink = "Interaction Group Code"=field(Code);
                    RunPageView = sorting("Interaction Group Code");
                    ToolTip = 'View the different templates that you can use when creating interactions.';
                }
            }
        }
    }
}

