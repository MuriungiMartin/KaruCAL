#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5073 "Sales Cycle Stages List"
{
    Caption = 'Sales Cycle Stages List';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Cycle Stage";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Stage;Stage)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the stage within the sales cycle.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the sales cycle stage.';
                }
                field("Completed %";"Completed %")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the percentage of the sales cycle that has been completed when the opportunity reaches this stage.';
                }
                field("Activity Code";"Activity Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code of the activity linked to this sales cycle stage (if there is one).';
                }
                field("Quote Required";"Quote Required")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that a quote is required at this stage before the opportunity can move to the next stage in the sales cycle.';
                }
                field("Allow Skip";"Allow Skip")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that it is possible to skip this stage and move the opportunity to the next stage.';
                }
                field("Date Formula";"Date Formula")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies dates for planned activities when you run the Opportunity - Details report.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that comments exist for this sales cycle stage.';
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
            group("&Sales Cycle Stage")
            {
                Caption = '&Sales Cycle Stage';
                Image = Stages;
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Cycle Stage Statistics";
                    RunPageLink = "Sales Cycle Code"=field("Sales Cycle Code"),
                                  Stage=field(Stage);
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name"=const("Sales Cycle Stage"),
                                  "No."=field("Sales Cycle Code"),
                                  "Sub No."=field(Stage);
                    ToolTip = 'View or add comments.';
                }
            }
        }
    }
}

