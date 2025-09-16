#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 667 "Additional Approvers"
{
    AutoSplitKey = true;
    Caption = 'Additional Approvers';
    PageType = List;
    SourceTable = UnknownTable465;
    SourceTableView = sorting("Sequence No.");

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Approver ID";"Approver ID")
                {
                    ApplicationArea = Basic;
                }
                field("Limit Type";"Limit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Code";"Approval Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Approval Type";"Approval Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Sequence No.";"Sequence No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Minimum Amount";"Minimum Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Maximum Amount";"Maximum Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Title Header";"Title Header")
                {
                    ApplicationArea = Basic;
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
        area(creation)
        {
            action(GroupApp)
            {
                ApplicationArea = Basic;
                Caption = 'Group Approvers';
                Image = ApprovalSetup;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    AddApprovers.Init;
                    AddApprovers.SetRange("Approval Code","Approval Code");
                    AddApprovers.SetRange("Approval Type","Approval Type");
                    AddApprovers.SetRange("Document Type","Document Type");
                    AddApprovers.SetRange(AddApprovers."Sequence No.","Sequence No.");
                    AddApproverForm.SetTableview(AddApprovers);
                    AddApproverForm.Run;
                end;
            }
        }
    }

    var
        AddApprovers: Record UnknownRecord61240;
        AddApproverForm: Page "GEN-Additional Group Approvers";
}

