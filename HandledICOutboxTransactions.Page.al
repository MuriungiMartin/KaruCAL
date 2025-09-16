#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 613 "Handled IC Outbox Transactions"
{
    ApplicationArea = Basic;
    Caption = 'Handled IC Outbox Transactions';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Handled IC Outbox Trans.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Transaction No.";"Transaction No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("IC Partner Code";"IC Partner Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Source Type";"Source Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transaction Source";"Transaction Source")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
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
            group("&Outbox Transaction")
            {
                Caption = '&Outbox Transaction';
                Image = Export;
                action(Details)
                {
                    ApplicationArea = Basic;
                    Caption = 'Details';
                    Image = View;

                    trigger OnAction()
                    begin
                        ShowDetails;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = ViewComments;
                    RunObject = Page "IC Comment Sheet";
                    RunPageLink = "Table Name"=const("Handled IC Outbox Transaction"),
                                  "Transaction No."=field("Transaction No."),
                                  "IC Partner Code"=field("IC Partner Code"),
                                  "Transaction Source"=field("Transaction Source");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Re-create Outbox Transaction")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-create Outbox Transaction';
                    Image = NewStatusChange;

                    trigger OnAction()
                    var
                        ICInboxOutboxMgt: Codeunit ICInboxOutboxMgt;
                    begin
                        ICInboxOutboxMgt.RecreateOutboxTransaction(Rec);
                    end;
                }
            }
        }
    }
}

