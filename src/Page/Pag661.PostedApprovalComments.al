#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 661 "Posted Approval Comments"
{
    Caption = 'Posted Approval Comments';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Posted Approval Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the entry number for the comment.';
                    Visible = false;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who created this approval comment.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the comment. You can enter a maximum of 250 characters, both numbers and letters.';
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the document number of the quote, order, invoice, credit memo, return order, or blanket order that the comment applies to.';
                }
                field("Date and Time";"Date and Time")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date and time that the comment was made.';
                }
                field(PostedRecordID;PostedRecordID)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approved';
                    ToolTip = 'Specifies that the approval request has been approved.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        PostedRecordID := Format("Posted Record ID",0,1);
    end;

    trigger OnAfterGetRecord()
    begin
        PostedRecordID := Format("Posted Record ID",0,1);
    end;

    var
        PostedRecordID: Text;
}

