#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9103 "Pending Approval FactBox"
{
    Caption = 'Pending Approval';
    PageType = CardPart;
    SourceTable = "Approval Entry";

    layout
    {
        area(content)
        {
            field("Sender ID";"Sender ID")
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies the ID of the user who sent the approval request for the document to be approved.';
            }
            field("Due Date";"Due Date")
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies when the record must be approved, by one or more approvers.';
            }
            field(Comment;ApprovalCommentLine.Comment)
            {
                ApplicationArea = Suite;
                Caption = 'Comment';
                ToolTip = 'Specifies a comment that applies to the approval entry.';

                trigger OnDrillDown()
                begin
                    Page.RunModal(Page::"Approval Comments",ApprovalCommentLine);
                    CurrPage.Update;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ApprovalCommentLine.SetRange("Table ID","Table ID");
        ApprovalCommentLine.SetRange("Document Type","Document Type");
        ApprovalCommentLine.SetRange("Document No.","Document No.");
        //ApprovalCommentLine.SETRANGE("Workflow Step Instance ID","Workflow Step Instance ID");
        if ApprovalCommentLine.FindFirst then;
    end;

    var
        ApprovalCommentLine: Record "Approval Comment Line";
}

