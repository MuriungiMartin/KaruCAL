#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68919 "HRM-Interview Candidates List"
{
    CardPageID = "HRM-Job Applications Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Applicant,Functions,Print';
    SourceTable = UnknownTable61225;
    SourceTableView = where(Qualified=filter(Yes));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                field("Application No";"Application No")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    StyleExpr = true;
                }
                field("Date Applied";"Date Applied")
                {
                    ApplicationArea = Basic;
                    StyleExpr = true;
                }
                field("Job Applied For";"Job Applied For")
                {
                    ApplicationArea = Basic;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Qualified;Qualified)
                {
                    ApplicationArea = Basic;
                }
                field("Interview Invitation Sent";"Interview Invitation Sent")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755009;"HRM-Job Applications Factbox")
            {
                SubPageLink = "Application No"=field("Application No");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Applicant)
            {
                Caption = 'Applicant';
                action("Job Interview details")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Interview details';
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Job Interview";
                    RunPageLink = "Applicant No"=field("Application No");
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "HRM-Job Applications Card";
                    RunPageLink = "Application No"=field("Application No");
                }
                action("&Upload to Employee Card")
                {
                    ApplicationArea = Basic;
                    Caption = '&Upload to Employee Card';
                    Image = Export;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        if not Confirm(Text001,false) then exit;
                          if "Employee No" = '' then begin
                          //IF NOT CONFIRM('Are you sure you want to Upload Applications Information to the Employee Card',FALSE) THEN EXIT;
                          HRJobApplications.SetFilter(HRJobApplications."Application No","Application No");
                          Report.Run(39003937,true,false,HRJobApplications);
                          end else begin
                          Message('This applicants information already exists in the employee card');
                          end;
                    end;
                }
                action("Send Interview Invitation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Interview Invitation';
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        //IF CONFIRM('Send this Requisition for Approval?',TRUE)=FALSE THEN EXIT;
                        if not Confirm(Text002,false) then exit;

                        TestField(Qualified,Qualified::"1");
                        HRJobApplications.SetRange(HRJobApplications."Application No","Application No");
                        if HRJobApplications.Find('-') then
                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.Reset;
                        HREmailParameters.SetRange(HREmailParameters."Associate With",HREmailParameters."associate with"::"Interview Invitations");
                        if HREmailParameters.Find('-') then
                        begin
                             repeat
                             HRJobApplications.TestField(HRJobApplications."E-Mail");
                             SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HRJobApplications."E-Mail",
                             HREmailParameters.Subject,'Dear'+' '+HRJobApplications."First Name"+' '+HREmailParameters.Body+HRJobApplications."Job Applied For"+'applied on'+Format("Date Applied")+' '+HREmailParameters."Body 2",true);
                             //HREmailParameters."Body 2"+' '+ FORMAT("Date Applied")+'. '+
                            // HREmailParameters.Body,TRUE);
                             SMTP.Send();
                             until HRJobApplications.Next=0;

                        Message('All Qualified shortlisted candidates have been invited for the interview ');
                        end;
                    end;
                }
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "ACA-Applicant Qualifications";
                    RunPageLink = "Application No"=field("Application No");
                }
                action(Referees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referees';
                    Image = ContactReference;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Applicant Referees";
                    RunPageLink = "Job Application No"=field("Application No");
                }
                action(Hobbies)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hobbies';
                    Image = Holiday;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "HRM-Applicant Hobbies";
                    RunPageLink = "Job Application No"=field("Application No");
                }
            }
            group(Print)
            {
                Caption = 'Print';
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Category6;

                    trigger OnAction()
                    begin
                        HRJobApplications.Reset;
                        HRJobApplications.SetRange(HRJobApplications."Application No","Application No");
                        if HRJobApplications.Find('-') then
                        Report.Run(39005523,true,true,HRJobApplications);
                    end;
                }
                action("HR Job Interview Results")
                {
                    ApplicationArea = Basic;
                    Caption = 'HR Job Interview Results';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Report "pr Transactions";
                }
            }
        }
    }

    var
        HRJobApplications: Record UnknownRecord61225;
        Text001: label 'Are you sure you want to Upload Applicants Details to the Employee Card?';
        Text002: label 'Are you sure you want to Send this Interview invitation?';
        ApprovalmailMgt: Codeunit "IC Setup Diagnostics";
        SMTP: Codeunit "SMTP Mail";
        CTEXTURL: Text[30];
        HREmailParameters: Record UnknownRecord61656;
}

