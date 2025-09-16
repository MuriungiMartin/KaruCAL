#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68924 "HRM-Disciplinary Cases List"
{
    Caption = 'Employee Disciplinary Cases ';
    CardPageID = "HRM-Disciplinary Case Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Functions,Case Status,Show';
    SourceTable = UnknownTable61223;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Case Number";"Case Number")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Complaint";"Date of Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Type Complaint";"Type Complaint")
                {
                    ApplicationArea = Basic;
                }
                field(Accuser;Accuser)
                {
                    ApplicationArea = Basic;
                }
                field("Accused Employee";"Accused Employee")
                {
                    ApplicationArea = Basic;
                }
                field("Description of Complaint";"Description of Complaint")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
                field("Disciplinary Stage Status";"Disciplinary Stage Status")
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755006;"HRM-Disciplinary Cases Factbox")
            {
                Caption = 'HR Disciplinary Cases Factbox';
                SubPageLink = "Case Number"=field("Case Number");
            }
            systempart(Control1102755009;Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action("Send Case Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Case Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Send this Case for Approval ?',true)=false then exit;
                        //AppMgmt.SendDisciplinaryApprovalReq(Rec);
                        Rec.Status:=Rec.Status::Approved;
                    end;
                }
                action("Cancel Case Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Case Approval Request';
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if Confirm('Cancel Case Approval Request?',true)=false then exit;
                        //AppMgmt.CancelDiscipplinaryAppApprovalReq(Rec,TRUE,TRUE);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Disciplinary Approvals";
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType:=Documenttype::"Disciplinary Approvals";
                        ApprovalEntries.Setfilters(Database::"HRM-Disciplinary Cases (B)",DocumentType,"Case Number");
                        ApprovalEntries.Run;
                    end;
                }
            }
            group("Case Status")
            {
                action("Under Investigation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Under Investigation';
                    Image = OpenWorksheet;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                          TestField(Status,Status::Approved);
                        
                          /*
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Investigation" THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"In Progress" THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Review" THEN EXIT;
                          */
                        
                          if Confirm('Are you sure you want to mark this case as "Under Investigation"?')  then begin
                          "Disciplinary Stage Status":="disciplinary stage status"::"Investigation ";
                           Modify;
                           Message('Case Number %1 has been marked as under "Investigation"',"Case Number");
                          end;

                    end;
                }
                action("In Progress")
                {
                    ApplicationArea = Basic;
                    Caption = 'In Progress';
                    Image = CarryOutActionMessage;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                          TestField(Status,Status::Approved);
                        
                          /*
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Investigation" THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"In Progress" THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Review" THEN EXIT;
                          */
                        
                          if Confirm('Are you sure you want to open Investigations for these Case?')  then begin
                          "Disciplinary Stage Status":="disciplinary stage status"::Inprogress;
                          Modify;
                          Message('Case Number %1 has been marked as "In Progress"',"Case Number");
                          end;

                    end;
                }
                action(Close)
                {
                    ApplicationArea = Basic;
                    Caption = ' Close';
                    Image = Closed;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                          TestField(Status,Status::Approved);
                        
                          /*
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Investigation" THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"In Progress" THEN EXIT;
                        //  IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                          IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under Review" THEN EXIT;
                          */
                        
                          if Confirm('Are you sure you want to mark this case as "Closed"?')  then begin
                          "Disciplinary Stage Status":="disciplinary stage status"::Closed;
                          Modify;
                          Message('Case Number %1 has been marked as "Closed"',"Case Number");
                          end;

                    end;
                }
                action(Appeal)
                {
                    ApplicationArea = Basic;
                    Caption = ' Appeal';
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                          TestField(Status,Status::Approved);


                          if Confirm('Are you sure you want to mark this case as "Under Review?"')  then begin
                          "Disciplinary Stage Status":="disciplinary stage status"::"Under review";
                          Modify;
                          Message('Case Number %1 has been marked as "Under Review"',"Case Number");
                          end;
                    end;
                }
            }
        }
    }

    var
        AppMgmt: Codeunit "Export F/O Consolidation";
        "Document Type": Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Leave Journal","Medical Claims","Activity Approval","Disciplinary Approvals";
}

