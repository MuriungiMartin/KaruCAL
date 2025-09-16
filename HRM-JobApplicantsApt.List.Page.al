#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69043 "HRM-Job Applicants Apt.List"
{
    CardPageID = "HRM-Job Apps. Qualified";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61225;
    SourceTableView = where(Qualified=filter(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No";"Application No")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("First Name";"First Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Job Applied For";"Job Applied For")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Date of Interview";"Date of Interview")
                {
                    ApplicationArea = Basic;
                }
                field("From Time";"From Time")
                {
                    ApplicationArea = Basic;
                }
                field("To Time";"To Time")
                {
                    ApplicationArea = Basic;
                }
                field(Venue;Venue)
                {
                    ApplicationArea = Basic;
                }
                field("Interview Type";"Interview Type")
                {
                    ApplicationArea = Basic;
                }
                field(Qualified;Qualified)
                {
                    ApplicationArea = Basic;
                }
                field("Interview Invitation Sent";"Interview Invitation Sent")
                {
                    ApplicationArea = Basic;
                }
                field("Selection Count";"Selection Count")
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
            group(Applicant)
            {
                Caption = 'Applicant';
                action("Send Interview Invitation")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Aptitude Test Invitation';
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin

                        //IF CONFIRM('Send this Requisition for Approval?',TRUE)=FALSE THEN EXIT;
                        if not Confirm(Text002,false) then exit;

                        TestField(Qualified,Qualified::"1");
                        HRJobApplications.SetRange(HRJobApplications."Application No","Application No");
                        CurrPage.SetSelectionFilter(HRJobApplications);
                        if HRJobApplications.Find('-') then
                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.Reset;
                        HREmailParameters.SetRange(HREmailParameters."Associate With",HREmailParameters."associate with"::"Interview Invitations");
                        if HREmailParameters.Find('-') then
                        begin
                             repeat
                             HRJobApplications.TestField(HRJobApplications."E-Mail");
                             SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HRJobApplications."E-Mail",
                             HREmailParameters.Subject,'Dear'+' '+HRJobApplications."First Name"+' '+HREmailParameters.Body+' '+HRJobApplications."Job Applied for Description"+' '+'applied on'+Format("Date Applied")+' '+HREmailParameters."Body 2"+//,TRUE);
                             Format(HRJobApplications."Date of Interview")+' '+'Starting '+' '+Format(HRJobApplications."From Time")+' '+'to'+Format(HRJobApplications."To Time")+' '+'at'+HRJobApplications.Venue+'.',true);
                             //HREmailParameters.Body,TRUE);
                             SMTP.Send();
                             until HRJobApplications.Next=0;

                        if Confirm('Do you want to send this invitation alert?',false) = true then begin
                        "Interview Invitation Sent":=true;
                        Modify;
                        Message('All Qualified shortlisted candidates have been invited for the interview ')
                        end;
                        end;
                    end;
                }
                action("Aptitude Test Results")
                {
                    ApplicationArea = Basic;
                    Caption = 'Aptitude Test Results';
                    Image = ApplicationWorksheet;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "HRM-Job Interview";
                    RunPageLink = "Applicant No"=field("Application No");
                }
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = Card;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Page "HRM-Job Applications Card";
                    RunPageLink = "Application No"=field("Application No");
                }
                action(Qualifications)
                {
                    ApplicationArea = Basic;
                    Caption = 'Qualifications';
                    Image = QualificationOverview;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Page "ACA-Applicant Qualifications";
                    RunPageLink = "Application No"=field("Application No");
                }
                action(Referees)
                {
                    ApplicationArea = Basic;
                    Caption = 'Referees';
                    Image = ContactReference;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
                    RunObject = Page "HRM-Applicant Referees";
                    RunPageLink = "Job Application No"=field("Application No");
                }
                action(Hobbies)
                {
                    ApplicationArea = Basic;
                    Caption = 'Hobbies';
                    Image = Holiday;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = "Report";
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
                        Report.Run(39003925,true,true,HRJobApplications);
                    end;
                }
            }
        }
    }

    var
        HRJobApplications: Record UnknownRecord61225;
        ApprovalmailMgt: Codeunit "IC Setup Diagnostics";
        SMTP: Codeunit "SMTP Mail";
        CTEXTURL: Text[30];
        HREmailParameters: Record UnknownRecord61656;
        Text001: label 'Are you sure you want to Upload Applicants Details to the Employee Card?';
        Text002: label 'Are you sure you want to Send this Interview invitation?';
        Interview: Record UnknownRecord61255;


    procedure TESTFIELDS()
    begin
        TestField("Total Score");
    end;
}

