#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68334 "HRM-Jobs Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Functions,Job';
    SourceTable = UnknownTable61193;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Title';
                    Importance = Promoted;
                }
                field("Shortlisting Criteria";"Shortlisting Criteria")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Job Specializations";"Job Specializations")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Job Descriptions";"Job Descriptions")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No. of Responsibilities";"No. of Responsibilities")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No. of Requirements";"No. of Requirements")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Position Reporting to";"Position Reporting to")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Directorate Code";"Directorate Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Campus Code';
                }
                field("Directorate Name";"Directorate Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Campus Name';
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Department';
                }
                field("Department Name";"Department Name")
                {
                    ApplicationArea = Basic;
                }
                field("Station Code";"Station Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Station';
                    Visible = false;
                }
                field("Station Name";"Station Name")
                {
                    ApplicationArea = Basic;
                    MultiLine = false;
                    Visible = false;
                }
                field("Main Objective";"Main Objective")
                {
                    ApplicationArea = Basic;
                }
                field("Reason for Job creation";"Reason for Job creation")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor/Manager";"Supervisor/Manager")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor Name";"Supervisor Name")
                {
                    ApplicationArea = Basic;
                }
                field("No of Posts";"No of Posts")
                {
                    ApplicationArea = Basic;
                }
                field("Occupied Positions";"Occupied Positions")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Vacant Positions";"Vacant Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Requisitions";"Employee Requisitions")
                {
                    ApplicationArea = Basic;
                }
                field("Key Position";"Key Position")
                {
                    ApplicationArea = Basic;
                }
                field("Memo Ref No.";"Memo Ref No.")
                {
                    ApplicationArea = Basic;
                }
                field("Memo Approval Date";"Memo Approval Date")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Enabled = true;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = true;
                    Importance = Promoted;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Employment Category";"Employment Category")
                {
                    ApplicationArea = Basic;
                }
                field("Employment Grade";"Employment Grade")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755004;"HRM-Jobs Factbox")
            {
                SubPageLink = "Job ID"=field("Job ID");
            }
            systempart(Control1102755006;Outlook)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                Enabled = false;
                Visible = false;
                action(Approvals)
                {
                    ApplicationArea = Basic;
                    Caption = 'Approvals';
                    Enabled = false;
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    var
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","None","Payment Voucher","Petty Cash",Imprest,Requisition,ImprestSurrender,Interbank,Receipt,"Staff Claim","Staff Advance",AdvanceSurrender,"Bank Slip",Grant,"Grant Surrender","Employee Requisition","Leave Application","Training Application","Transport Requisition",Job;
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        DocumentType:=Documenttype::Job;
                        ApprovalEntries.Setfilters(Database::"HRM-Jobs",DocumentType,"Job ID");
                        ApprovalEntries.Run;
                    end;
                }
                action("Send Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Approval Request';
                    Enabled = false;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*
                        IF CONFIRM('Send this job position for Approval?',TRUE)=FALSE THEN EXIT;
                        AppMgmt.SendJobApprovalReq(Rec);
                        */

                    end;
                }
                action("Cancel Approval Request")
                {
                    ApplicationArea = Basic;
                    Caption = 'Cancel Approval Request';
                    Enabled = false;
                    Image = CancelAllLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                        /*
                        IF CONFIRM('Cancel Approval Request?',TRUE)=FALSE THEN EXIT;
                        AppMgmt.CancelJobAppRequest(Rec,TRUE,TRUE);
                         */

                    end;
                }
            }
            group(Job)
            {
                Caption = 'Job';
                action("Raise Requisition")
                {
                    ApplicationArea = Basic;
                    Caption = 'Raise Requisition';
                    Image = Job;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Employee Requisitions List";
                    RunPageLink = "Job ID"=field("Job ID");
                    RunPageOnRec = false;

                    trigger OnAction()
                    begin
                        CurrPage.Close;
                    end;
                }
                action(Requirements)
                {
                    ApplicationArea = Basic;
                    Caption = 'Requirements';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Job Requirement Lines";
                    RunPageLink = "Job Id"=field("Job ID");
                }
                action(Responsibilities)
                {
                    ApplicationArea = Basic;
                    Caption = 'Responsibilities';
                    Image = JobResponsibility;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Job Resp. Lines";
                    RunPageLink = "Job ID"=field("Job ID");
                }
                action(Occupants)
                {
                    ApplicationArea = Basic;
                    Caption = 'Occupants';
                    Image = ContactPerson;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Job Occupants";
                    RunPageLink = "Job ID"=field("Job ID");
                }
                action("ShortListing Criteria")
                {
                    ApplicationArea = Basic;
                    Caption = 'ShortListing Criteria';
                    Image = Category;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Job Shortlist Qualif.";
                    Visible = true;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
                         Validate("Vacant Positions");
    end;

    var
        HREmployees: Record UnknownRecord61188;
        AppMgmt: Codeunit "Export F/O Consolidation";
        Jobreq: Record UnknownRecord61195;
}

