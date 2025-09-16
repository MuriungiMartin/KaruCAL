#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69012 "HRM-Back To Office Form"
{
    PageType = Card;
    SourceTable = UnknownTable61624;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Document No";"Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Course Title";"Course Title")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
                field(Trainer;Trainer)
                {
                    ApplicationArea = Basic;
                }
                field("Training Institution";"Training Institution")
                {
                    ApplicationArea = Basic;
                }
                field("Purpose of Training";"Purpose of Training")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No.";"Employee No.")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Directorate;Directorate)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Station;Station)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Text 1";"Text 1")
                {
                    ApplicationArea = Basic;
                    Caption = '1.Please state how the course has benefited you and the organization';
                    MultiLine = true;
                }
                field("Text 2";"Text 2")
                {
                    ApplicationArea = Basic;
                    Caption = '2.Which specific areas do you think need improvement in your area of operation?';
                    MultiLine = true;
                }
                field("Text 4";"Text 4")
                {
                    ApplicationArea = Basic;
                    Caption = '4.Provide timeline within which you will cascade the skills learned to others in your Department/organization';
                    MultiLine = true;
                }
                field("Text 3";"Text 3")
                {
                    ApplicationArea = Basic;
                    Caption = '3.How will you use the skills acquired to address the problem?';
                    MultiLine = true;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Show")
            {
                Caption = '&Show';
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Application","Transport Requisition";
                    begin
                        /*
                        DocumentType:=DocumentType::"Training Application";
                        
                        ApprovalComments.Setfilters(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        ApprovalComments.SetUpLine(DATABASE::"HR Training Applications",DocumentType,"Application No");
                        ApprovalComments.RUN;
                        */

                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("&Approvals")
                {
                    ApplicationArea = Basic;
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Disciplinary Approvals","Activity Approval","Exit Approval","Medical Claim Approval",Jv,BackToOffice;
                        ApprovalEntries: Page "Approval Entries";
                    begin

                        DocumentType:=Documenttype::BackToOffice;
                        //ApprovalEntries.Setfilters(DATABASE::"HRBack To Office Form",DocumentType,"Document No");
                        ApprovalEntries.Run;
                    end;
                }
                action("&Send Approval &Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Send Approval &Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        if Confirm('Send this Application for Approval?',true)=false then exit;
                        //ApprovalMgt.SendBackOfficeAppApprovalRequest(Rec);
                    end;
                }
                action("&Cancel Approval request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel Approval request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        if Confirm('Are you sure you want to cancel the approval request',true)=false then exit;
                        //ApprovalMgt.CancelBackOfficeAppApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PrintForm;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        /*
                        HRTrainingApplications.SETRANGE(HRTrainingApplications."Application No","Application No");
                        IF HRTrainingApplications.FIND('-') THEN
                        REPORT.RUN(39005484,TRUE,TRUE,HRTrainingApplications);
                        */

                    end;
                }
                separator(Action1)
                {
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark as Back to Office';
                    Image = Undo;

                    trigger OnAction()
                    begin
                         if Confirm('Do you really want to mark the employee as back to office?')  then begin
                         HREmp.Get("Employee No.");
                         HREmp."On Leave":=false;
                         HREmp.Modify;

                         end;
                    end;
                }
            }
        }
    }

    var
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        HREmp: Record UnknownRecord61188;
}

