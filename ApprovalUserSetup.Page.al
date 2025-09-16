#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 663 "Approval User Setup"
{
    ApplicationArea = Basic;
    Caption = 'Approval User Setup';
    PageType = List;
    SourceTable = "User Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Salespers./Purch. Code";"Salespers./Purch. Code")
                {
                    ApplicationArea = Basic;
                }
                field("Approver ID";"Approver ID")
                {
                    ApplicationArea = Basic;
                }
                field("Sales Amount Approval Limit";"Sales Amount Approval Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Unlimited Sales Approval";"Unlimited Sales Approval")
                {
                    ApplicationArea = Basic;
                }
                field("Purchase Amount Approval Limit";"Purchase Amount Approval Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Unlimited Purchase Approval";"Unlimited Purchase Approval")
                {
                    ApplicationArea = Basic;
                }
                field("Request Amount Approval Limit";"Request Amount Approval Limit")
                {
                    ApplicationArea = Basic;
                }
                field("Unlimited Request Approval";"Unlimited Request Approval")
                {
                    ApplicationArea = Basic;
                }
                field(Substitute;Substitute)
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
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
            action("&Approval User Setup Test")
            {
                ApplicationArea = Basic;
                Caption = '&Approval User Setup Test';
                Image = Evaluate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.Run(Report::"Approval User Setup Test");
                end;
            }
        }
    }
}

