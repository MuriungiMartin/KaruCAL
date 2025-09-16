#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69004 "HRM-Job Applicants Unqualified"
{
    CardPageID = "HRM-Job Apps. Qualified";
    PageType = List;
    SourceTable = UnknownTable61225;
    SourceTableView = where("Not Qualified (System)"=filter(Yes));

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
                action("Send Regret Alert")
                {
                    ApplicationArea = Basic;
                    Caption = 'Send Regret Alert';
                    Image = SendMail;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin

                        //IF CONFIRM('Send this Requisition for Approval?',TRUE)=FALSE THEN EXIT;
                        if not Confirm(Text002,false) then exit;

                        TestField(Qualified,Qualified::"0");
                        HRJobApplications.SetRange(HRJobApplications."Application No","Application No");
                        CurrPage.SetSelectionFilter(HRJobApplications);
                        if HRJobApplications.Find('-') then
                        //GET E-MAIL PARAMETERS FOR JOB APPLICATIONS
                        HREmailParameters.Reset;
                        HREmailParameters.SetRange(HREmailParameters."Associate With",HREmailParameters."associate with"::"Regret Notification");
                        if HREmailParameters.Find('-') then
                        begin
                             repeat
                             HRJobApplications.TestField(HRJobApplications."E-Mail");
                             SMTP.CreateMessage(HREmailParameters."Sender Name",HREmailParameters."Sender Address",HRJobApplications."E-Mail",
                             HREmailParameters.Subject,'Dear'+' '+HRJobApplications."First Name"+' '+HREmailParameters.Body+' '+HRJobApplications."Job Applied for Description"+' '+'applied on'+' '+Format("Date Applied")+' '+HREmailParameters."Body 2",true);
                             //HREmailParameters."Body 2"+' '+ FORMAT("Date Applied")+'. '+
                            // HREmailParameters.Body,TRUE);
                             SMTP.Send();
                             until HRJobApplications.Next=0;

                        Message('All Unqualified  candidates have been sent regret alerts');
                        end;
                    end;
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
;
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
}

