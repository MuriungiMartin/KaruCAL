#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5119 "Sales Cycles"
{
    ApplicationArea = Basic;
    Caption = 'Sales Cycles';
    PageType = List;
    SourceTable = "Sales Cycle";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the sales cycle.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the sales cycle.';
                }
                field("Probability Calculation";"Probability Calculation")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the method to use to calculate the probability of opportunities completing the sales cycle. There are four options:';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the sales cycle cannot be used to create new opportunities.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that you have assigned comments to the sales cycle.';
                }
            }
        }
        area(factboxes)
        {
            part(Control5;"Sales Cycle Statistics FactBox")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Statistics';
                SubPageLink = Code=field(Code);
            }
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
            group("Sales &Cycle")
            {
                Caption = 'Sales &Cycle';
                Image = Stages;
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Cycle Statistics";
                    RunPageLink = Code=field(Code);
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name"=const("Sales Cycle"),
                                  "No."=field(Code),
                                  "Sub No."=const(0);
                    ToolTip = 'View or add comments.';
                }
                action("S&tages")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'S&tages';
                    Image = Stages;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Cycle Stages";
                    RunPageLink = "Sales Cycle Code"=field(Code);
                    ToolTip = 'View a list of the different stages within the sales cycle.';
                }
            }
        }
    }
}

