#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5069 "Web Sources"
{
    ApplicationArea = Basic;
    Caption = 'Web Sources';
    PageType = List;
    SourceTable = "Web Source";
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
                    ToolTip = 'Specifies the code for the Web source.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the Web source.';
                }
                field(URL;URL)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the URL to use to search for information about the contact on the Internet.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies whether a comment has been assigned to this Web source.';
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
            group("&Web Sources")
            {
                Caption = '&Web Sources';
                Image = ViewComments;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name"=const("Web Source"),
                                  "No."=field(Code),
                                  "Sub No."=const(0);
                    ToolTip = 'View or add comments.';
                }
            }
        }
    }
}

