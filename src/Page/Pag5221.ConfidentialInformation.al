#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5221 "Confidential Information"
{
    AutoSplitKey = true;
    Caption = 'Confidential Information';
    DataCaptionFields = "Employee No.";
    PageType = List;
    SourceTable = "Confidential Information";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Confidential Code";"Confidential Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code to define the type of confidential information.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the confidential information.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if a comment is associated with the entry.';
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
            group("Con&fidential")
            {
                Caption = 'Con&fidential';
                Image = ConfidentialOverview;
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    var
                        HRConfidentialCommentLine: Record "HR Confidential Comment Line";
                    begin
                        HRConfidentialCommentLine.SetRange("Table Name",HRConfidentialCommentLine."table name"::"Confidential Information");
                        HRConfidentialCommentLine.SetRange("No.","Employee No.");
                        HRConfidentialCommentLine.SetRange(Code,"Confidential Code");
                        HRConfidentialCommentLine.SetRange("Table Line No.","Line No.");
                        Page.RunModal(Page::"HR Confidential Comment Sheet",HRConfidentialCommentLine);
                    end;
                }
            }
        }
    }
}

