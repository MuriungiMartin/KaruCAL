#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9104 "Approval Comments FactBox"
{
    Caption = 'Comments';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Approval Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Comment;Comment)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the comment. You can enter a maximum of 250 characters, both numbers and letters.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the ID of the user who created this approval comment.';
                }
                field("Date and Time";"Date and Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date and time when the comment was made.';
                }
            }
        }
    }

    actions
    {
    }


    procedure SetFilterFromApprovalEntry(ApprovalEntry: Record "Approval Entry")
    begin
        //SETRANGE("Workflow Step Instance ID",ApprovalEntry."Record ID to Approve");
        CurrPage.Update(false);
    end;
}

