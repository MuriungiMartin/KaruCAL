#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 191 "Incoming Documents Setup"
{
    ApplicationArea = Basic;
    Caption = 'Incoming Documents Setup';
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = "Incoming Documents Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            field("General Journal Template Name";"General Journal Template Name")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the type of the general journal that new journal lines are created in when you choose the Journal Line button in the Incoming Documents window.';
            }
            field("General Journal Batch Name";"General Journal Batch Name")
            {
                ApplicationArea = Basic,Suite;
                ToolTip = 'Specifies the subtype of the general journal that new journal lines are created in when you choose the Journal Line button in the Incoming Documents window.';
            }
            field("Require Approval To Create";"Require Approval To Create")
            {
                ApplicationArea = Suite;
                ToolTip = 'Specifies whether the incoming document line must be approved before a document or journal line can be created from the Incoming Documents window.';
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Approvers)
            {
                ApplicationArea = Suite;
                Caption = 'Approvers';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Incoming Document Approvers";
                ToolTip = 'View or add incoming document approvers.';
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;
}

