#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68721 "HRM-Jobs List"
{
    CardPageID = "HRM-Jobs Card";
    DelayedInsert = false;
    DeleteAllowed = true;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions,Job';
    RefreshOnActivate = true;
    SourceTable = UnknownTable61193;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field("No of Posts";"No of Posts")
                {
                    ApplicationArea = Basic;
                }
                field("Shortlisting Criteria";"Shortlisting Criteria")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Job Specializations";"Job Specializations")
                {
                    ApplicationArea = Basic;
                    Description = 'Job Specifications';
                    Editable = false;
                    ToolTip = 'Specifies Job Specifications';
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
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field("Occupied Positions";"Occupied Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Vacant Positions";"Vacant Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Date Created";"Date Created")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Style = StandardAccent;
                    StyleExpr = true;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755002;"HRM-Jobs Factbox")
            {
                SubPageLink = "Job ID"=field("Job ID");
            }
            systempart(Control1102755004;Outlook)
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
                action("Job Card")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Jobs Card";
                    RunPageLink = "Job ID"=field("Job ID");
                }
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
                    RunPageLink = "Job ID"=field("Job ID");
                    Visible = true;
                }
                group(ActionGroup1000000019)
                {
                    action("HR Job Requirements")
                    {
                        ApplicationArea = Basic;
                        Image = Travel;
                        Promoted = true;

                        trigger OnAction()
                        begin
                             jobs.Reset;
                             jobs.SetRange("Job ID",Rec."Job ID");
                             Report.Run(Report::"HR Job Requirements", true,false,jobs);
                        end;
                    }
                }
            }
        }
    }

    var
        AppMgmt: Codeunit "Export F/O Consolidation";
        jobs: Record UnknownRecord61193;
}

