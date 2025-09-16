#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68718 "HRM-Employee Requisitions List"
{
    CardPageID = "HRM-Employee Requisition Card";
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Job,Functions,Employee';
    ShowFilter = true;
    SourceTable = UnknownTable61200;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                Editable = false;
                field("Requisition No.";"Requisition No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                }
                field("Requisition Date";"Requisition Date")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field("Recruitment Criterion";"Recruitment Criterion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Requestor;Requestor)
                {
                    ApplicationArea = Basic;
                }
                field("Reason For Request";"Reason For Request")
                {
                    ApplicationArea = Basic;
                }
                field("Required Positions";"Required Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Type of Contract Required";"Type of Contract Required")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract';
                    Editable = false;
                }
                field("Closing Date";"Closing Date")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755006;"HRM-Employee Req. Factbox")
            {
                SubPageLink = "Job ID"=field("Job ID");
            }
            systempart(Control1102755008;Outlook)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Job)
            {
                Caption = 'Job';
                action(Requirements)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requirements';
                    Image = JobListSetup;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Job Requirement Lines";
                    RunPageLink = "Job Id"=field("Job ID");
                }
                action(Responsibilities)
                {
                    ApplicationArea = Basic;
                    Caption = 'Responsibilities';
                    Image = JobResponsibility;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Job Resp. Lines";
                    RunPageLink = "Job ID"=field("Job ID");
                }
            }
            group("Fu&nctions")
            {
                Caption = 'Fu&nctions';
                action(Advertise)
                {
                    ApplicationArea = Basic;
                    Caption = 'Advertise';
                    Image = Salutation;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        /*
                        HREmp.RESET;
                        REPEAT
                        HREmp.TESTFIELD(HREmp."Company E-Mail");
                        SMTP.CreateMessage('Job Advertisement','dgithahu@AppKings.co.ke',HREmp."Company E-Mail",
                        'URAIA Job Vacancy','A vacancy with the job description' +"Job Description"+'is open for applications',TRUE);
                        SMTP.Send();
                        UNTIL HREmp.NEXT=0;
                        */
                        TestField("Requisition Type","requisition type"::Internal);
                        HREmp.SetRange(HREmp.Status,HREmp.Status::Active);
                        if HREmp.Find('-') then
                        
                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.Reset;
                        HREmailParameters.SetRange(HREmailParameters."Associate With",HREmailParameters."associate with"::"Vacancy Advertisements");
                        if HREmailParameters.Find('-') then
                        begin
                             repeat
                             HREmp.TestField(HREmp."Company E-Mail");
                             SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HREmp."Company E-Mail",
                             HREmailParameters.Subject,'Dear'+' '+ HREmp."First Name" +' '+
                             HREmailParameters.Body+' '+ "Job Description" +' '+ HREmailParameters."Body 2"+' '+ Format("Closing Date")+'. '+
                             HREmailParameters."Body 3",true);
                             SMTP.Send();
                             until HREmp.Next=0;
                        
                        Message('All Employees have been notified about this vacancy');
                        end;

                    end;
                }
                action("&Approvals")
                {
                    ApplicationArea = Basic;
                    Caption = '&Approvals';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        DocumentType:=Documenttype::"Employee Requisition";
                        ApprovalEntries.Setfilters(Database::"HRM-Employee Requisitions",DocumentType,"Requisition No.");
                        ApprovalEntries.Run;
                    end;
                }
                action("&Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Send Approval Request';
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        if Confirm('Send this Requisition for Approval?',true)=false then exit;

                        TESTFIELDS;

                        //ApprovalMgt.SendEmpRequisitionAppReq(Rec);
                    end;
                }
                action("&Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = '&Cancel Approval Request';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        if Confirm('Cancel Approval Request?',true)=false then exit;

                        //ApprovalMgt.CancelEmpRequisitionAppRequest(Rec,TRUE,TRUE);
                    end;
                }
                action("Mark as Closed/Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mark as Closed/Open';
                    Image = ReopenCancelled;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    begin
                        if Closed then
                        begin
                          if not Confirm('Are you sure you want to Re-Open this Document',false) then exit;
                          Closed:=false;
                          Modify;
                          Message('Employee Requisition %1 has been Re-Opened',"Requisition No.");

                        end else
                        begin
                          if not Confirm('Are you sure you want to close this Document',false) then exit;
                          Closed:=true;
                          Modify;
                          Message('Employee Requisition %1 has been marked as Closed',"Requisition No.");
                        end;
                    end;
                }
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Visible = false;

                    trigger OnAction()
                    begin
                        HREmpReq.Reset;
                        HREmpReq.SetRange(HREmpReq."Requisition No.","Requisition No.");
                        if HREmpReq.Find('-') then
                        Report.Run(39005559,true,true,HREmpReq);
                    end;
                }
                action("Re-Open")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re-Open';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    Visible = false;

                    trigger OnAction()
                    begin
                                  Status:=Status::New;
                                  Modify;
                    end;
                }
                action(UpdateQualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Update Qualifications';
                    Image = AdjustItemCost;
                    Promoted = true;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if Confirm('Update qualifications?',true)=false then Error('Cancelled by user!');
                        Clear(HRMEmployeeRequisitions);
                        HRMEmployeeRequisitions.Reset;
                        HRMEmployeeRequisitions.SetRange("Requisition No.",Rec."Requisition No.");
                        if HRMEmployeeRequisitions.Find('-') then begin
                          HRMEmployeeRequisitions.Validate("Job ID");
                          Message('Job Recruitment criteria updated!');
                          end;
                    end;
                }
            }
            group(Employee)
            {
                Caption = 'Employee';
                action(Prints)
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PurchaseTaxStatement;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    begin
                        Clear(HRJobApplications);
                        HRJobApplications.Reset;
                        HRJobApplications.SetRange("Job Applied For",Rec."Job ID");
                        if HRJobApplications.Find('-') then
                        Report.Run(51169,true,true,HRJobApplications);
                    end;
                }
            }
        }
    }

    var
        HREmp: Record UnknownRecord61188;
        HREmailParameters: Record UnknownRecord61656;
        SMTP: Codeunit "SMTP Mail";
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition";
        ApprovalEntries: Page "Approval Entries";
        ApprovalMgt: Codeunit "Export F/O Consolidation";
        HREmpReq: Record UnknownRecord61200;
        HRMEmployeeRequisitions: Record UnknownRecord61200;
        HRJobApplications: Record UnknownRecord61225;


    procedure TESTFIELDS()
    begin
        TestField("Job ID");
        TestField("Closing Date");
        TestField("Type of Contract Required");
        TestField("Requisition Type");
        TestField("Required Positions");
        if "Reason For Request"="reason for request"::Other then
        TestField("Reason for Request(Other)");
    end;
}

