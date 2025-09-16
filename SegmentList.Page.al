#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5093 "Segment List"
{
    ApplicationArea = Basic;
    Caption = 'Segment List';
    CardPageID = Segment;
    DataCaptionFields = "Campaign No.","Salesperson Code";
    Editable = false;
    PageType = List;
    SourceTable = "Segment Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the segment.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the segment.';
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the campaign for which the segment has been created.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson responsible for this segment and/or interaction.';
                }
                field(Date;Date)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date that the segment was created.';
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
            group("&Segment")
            {
                Caption = '&Segment';
                Image = Segment;
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Segment No."=field("No.");
                    RunPageView = sorting("Segment No.");
                    ToolTip = 'View the to-dos that have been assigned to salespeople or teams. To-dos can be linked to contacts and/or campaigns.';
                }
            }
        }
    }
}

