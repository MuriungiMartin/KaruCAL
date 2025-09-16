#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69014 "HRM-Disciplinary Case Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Case Status,Show';
    SourceTable = UnknownTable61223;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Case Number";"Case Number")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date of Complaint";"Date of Complaint")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Accused Employee";"Accused Employee")
                {
                    ApplicationArea = Basic;
                }
                field("Accused Employee Name";"Accused Employee Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Type Complaint";"Type Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Description of Complaint";"Description of Complaint")
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
                field("Severity Of the Complain";"Severity Of the Complain")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Complaint was Reported";"Date of Complaint was Reported")
                {
                    ApplicationArea = Basic;
                }
                field("Accussed By";"Accussed By")
                {
                    ApplicationArea = Basic;
                }
                field(Accuser;Accuser)
                {
                    ApplicationArea = Basic;
                }
                field("Accuser Name";"Accuser Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Non Employee Name";"Non Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field("Witness #1";"Witness #1")
                {
                    ApplicationArea = Basic;
                }
                field("Witness #1 Name";"Witness #1 Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Witness #2";"Witness #2")
                {
                    ApplicationArea = Basic;
                }
                field("Witness #2  Name";"Witness #2  Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Date To Discuss Case";"Date To Discuss Case")
                {
                    ApplicationArea = Basic;
                }
                field("Body Handling The Complaint";"Body Handling The Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Mode of Lodging the Complaint";"Mode of Lodging the Complaint")
                {
                    ApplicationArea = Basic;
                }
                field("Policy Guidlines In Effect";"Policy Guidlines In Effect")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field("Recommended Action";"Recommended Action")
                {
                    ApplicationArea = Basic;
                    Editable = RecommendedActionEditable;
                }
                field("Disciplinary Stage Status";"Disciplinary Stage Status")
                {
                    ApplicationArea = Basic;
                }
                field(Appealed;Appealed)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group("Action Information")
            {
                Caption = 'Action Information';
                field("Action Taken";"Action Taken")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Disciplinary Remarks";"Disciplinary Remarks")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    MultiLine = true;
                }
                field("Investigation Findings";Comments)
                {
                    ApplicationArea = Basic;
                    MultiLine = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755038;"HRM-Disciplinary Cases Factbox")
            {
                Caption = 'HR Disciplinary Cases Factbox';
                SubPageLink = "Case Number"=field("Case Number");
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
                          if "Disciplinary Stage Status" ="disciplinary stage status"::"Investigation " then exit;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::Inprogress then exit;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::Closed then exit;
                         // IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Under review" THEN EXIT;


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


                          //IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"Investigation " THEN EXIT;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::Inprogress then exit;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::Closed then exit;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::"Under review" then exit;


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


                          if "Disciplinary Stage Status" ="disciplinary stage status"::"Investigation " then exit;
                         // IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::"InProgress" THEN EXIT;
                        //  IF "Disciplinary Stage Status" ="Disciplinary Stage Status"::Closed THEN EXIT;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::"Under review" then exit;


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

                        if Appealed = true then begin
                         Error('A case can only be Appealed once');
                        end;

                          if "Disciplinary Stage Status" ="disciplinary stage status"::"Investigation " then exit;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::Inprogress then exit;
                          if "Disciplinary Stage Status" ="disciplinary stage status"::"Under review" then exit;


                          if Confirm('Are you sure you want to mark this case as "Under Review?"')  then begin
                          "Disciplinary Stage Status":="disciplinary stage status"::"Under review";
                          Appealed:=true;
                           Modify;
                           Message('Case Number %1 has been marked as "Under Review"',"Case Number");
                          end;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        RecommendedActionEditable:=true;
        ActionTakenEditable:=true;
        DisciplinaryRemarksEditable:=true;
    end;

    trigger OnOpenPage()
    begin
        UpdateControls;
    end;

    var
        HRDisciplinary: Record UnknownRecord61223;
        AppMgmt: Codeunit "Export F/O Consolidation";
        "Document Type": Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Store Requisition","Employee Requisition","Leave Application","Transport Requisition","Training Requisition","Job Approval","Induction Approval","Leave Journal","Medical Claims","Activity Approval","Disciplinary Approvals";
        RecommendedActionEditable: Boolean;
        ActionTakenEditable: Boolean;
        DisciplinaryRemarksEditable: Boolean;


    procedure UpdateControls()
    begin
        if Status=Status::New then
        begin
          RecommendedActionEditable:=false;
          ActionTakenEditable:=false;
          DisciplinaryRemarksEditable:=false;
        end;

        if Status=Status::Approved  then
        begin
          CurrPage.Editable:=false;
        end;

        if Status=Status::"Pending Approval"  then
        begin
          CurrPage.Editable:=false;
        end;
    end;
}

