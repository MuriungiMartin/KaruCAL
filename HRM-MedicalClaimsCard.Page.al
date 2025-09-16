#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69018 "HRM-Medical Claims Card"
{
    SourceTable = UnknownTable61252;
    SourceTableView = where(Status=filter(<>Posted));

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Claim No";"Claim No")
                {
                    ApplicationArea = Basic;
                }
                field("Member ID";"Member ID")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Member No";"Member No")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Member Names";"Member Names")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Claim Type";"Claim Type")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Date";"Claim Date")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme No";"Scheme No")
                {
                    ApplicationArea = Basic;
                }
                field(Dependants;Dependants)
                {
                    ApplicationArea = Basic;
                }
                field("Patient Name";"Patient Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Document Ref";"Document Ref")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Service";"Date of Service")
                {
                    ApplicationArea = Basic;
                }
                field("Facility Attended";"Facility Attended")
                {
                    ApplicationArea = Basic;
                }
                field("Facility Name";"Facility Name")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Currency Code";"Scheme Currency Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Claim Currency Code";"Claim Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Claim Amount";"Claim Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Scheme Amount Charged";"Scheme Amount Charged")
                {
                    ApplicationArea = Basic;
                }
                field(Comments;Comments)
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ActionGroup1102755020)
            {
            }
            action("&Approvals")
            {
                ApplicationArea = Basic;
                Caption = '&Approvals';
                Image = Approvals;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    ApprovalEntries.Setfilters(Database::"HRM-Medical Claims",DocumentType,HRMedical."Claim No");
                    ApprovalEntries.Run;
                end;
            }
            action("&Send Approval Request")
            {
                ApplicationArea = Basic;
                Caption = '&Send Approval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin

                    if Confirm('Send this Medical Claim for Approval?',true)=false then exit;

                    //ApprovalMgt.SendMedicaClaimlApprovalReq(Rec);
                end;
            }
            action("&Cancel Approval Request")
            {
                ApplicationArea = Basic;
                Caption = '&Cancel Approval Request';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                    //ApprovalMgt.CancelMedicalClaimAppApprovalReq(Rec,TRUE,TRUE);;
                end;
            }
            action("Post Claim")
            {
                ApplicationArea = Basic;
                Caption = '&Post Claim';
                Image = Post;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                begin
                      if Confirm('Are you sure you want to post this medical claim?')  then begin
                      Status:=Status::Posted;
                       Modify;
                       Message('Medical Claim  Number %1 has been Posted',"Claim No");
                      end;
                end;
            }
        }
    }

    var
        "Induction`": Record UnknownRecord61252;
        DepartmentName: Text[40];
        sDate: Date;
        HRMedical: Record UnknownRecord61252;
        Number: Integer;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Budget Transfer","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Medical Claims";
        ApprovalEntries: Page "Approval Entries";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        Department: Record "Dimension Value";
        HREmp: Record UnknownRecord61188;
}

