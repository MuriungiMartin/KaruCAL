#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 668 "Approval Templates"
{
    ApplicationArea = Basic;
    Caption = 'Approval Templates';
    PageType = List;
    SourceTable = UnknownTable464;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Approval Code";"Approval Code")
                {
                    ApplicationArea = Basic;
                }
                field("Approval Type";"Approval Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                }
                field("Limit Type";"Limit Type")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Approvers";"Additional Approvers")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Basic;
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
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
        area(processing)
        {
            action(AdditionalAppr)
            {
                ApplicationArea = Basic;
                Caption = '&Additional Appr.';
                Image = Approval;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    AddApprovers.Init;
                    AddApprovers.SetRange("Approval Code","Approval Code");
                    AddApprovers.SetRange("Approval Type","Approval Type");
                    AddApprovers.SetRange("Document Type","Document Type");
                    AddApprovers.SetRange("Limit Type","Limit Type");
                    AddApproverForm.SetTableview(AddApprovers);
                    AddApproverForm.Run;
                end;
            }
        }
    }

    var
        AddApprovers: Record UnknownRecord465;
        AddApproverForm: Page "IC Mapping Dimension Outgoing";
}

