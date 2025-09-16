#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68875 "HRM-Job Applications List"
{
    CardPageID = "HRM-Job Applications Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Applicant,Functions,Print';
    SourceTable = UnknownTable61225;

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
                field("Qualification Criterion";"Qualification Criterion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Passed Areas";"Passed Areas")
                {
                    ApplicationArea = Basic;
                }
                field("Failed Areas";"Failed Areas")
                {
                    ApplicationArea = Basic;
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
                        Clear(HRMJobApplicationsB);
                        HRMJobApplicationsB.Reset;
                        HRMJobApplicationsB.SetRange("Application No",Rec."Application No");
                        if HRMJobApplicationsB.Find('-') then begin
                          HRMJobApplicationsB.Validate("Employee Requisition No");
                          Message('Job Recruitment criteria updated!');
                          end;
                    end;
                }
                action(MarkReadyForShortlist)
                {
                    ApplicationArea = Basic;
                    Caption = 'Set as Ready';
                    Image = Addresses;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ToolTip = 'Mark as ready for shortlisting';

                    trigger OnAction()
                    begin
                        if Confirm('Mark as ready for Shortlisting?',true) =false then Error('Cancelled!');
                        Clear(HRMJobApplicationsB2);
                        HRMJobApplicationsB2.Reset;
                        HRMJobApplicationsB2.SetRange("Application No",Rec."Application No");
                        if HRMJobApplicationsB2.Find('-') then begin
                            HRMJobApplicationsB2."Ready for Shortlisting" := true;
                            HRMJobApplicationsB2.Modify;
                        end;
                        CurrPage.Update;
                    end;
                }
                action("Consolidated Attached Documents")
                {
                    ApplicationArea = Basic;
                    Image = Documents;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = false;

                    trigger OnAction()
                    var
                        FileName: Text;
                        Url: Text;
                    begin
                        FileName:=Rec."Application No"+'_Recruitment_Documents.pdf';
                        Url:='file:///\\KARU-SERVERAS\groupattachments/'+FileName;
                        Message(Url);
                        Hyperlink(Url);
                    end;
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
        HRMJobApplicationsB: Record UnknownRecord61225;
        HRMJobApplicationsB2: Record UnknownRecord61225;
}

