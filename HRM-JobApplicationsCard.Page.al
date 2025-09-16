#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68908 "HRM-Job Applications Card"
{
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Functions,Other Details';
    SourceTable = UnknownTable61225;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Application No";"Application No")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Date Applied";"Date Applied")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
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
                field("Qualification Criterion";"Qualification Criterion")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Initials;Initials)
                {
                    ApplicationArea = Basic;
                }
                field("First Language (R/W/S)";"First Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                    Caption = '1st Language (R/W/S)';
                    Importance = Promoted;
                }
                field("First Language Read";"First Language Read")
                {
                    ApplicationArea = Basic;
                    Caption = '1st Language Read';
                }
                field("First Language Write";"First Language Write")
                {
                    ApplicationArea = Basic;
                    Caption = '1st Language Write';
                }
                field("First Language Speak";"First Language Speak")
                {
                    ApplicationArea = Basic;
                    Caption = '1st Language Speak';
                }
                field("Second Language (R/W/S)";"Second Language (R/W/S)")
                {
                    ApplicationArea = Basic;
                    Caption = '2nd Language (R/W/S)';
                    Importance = Promoted;
                }
                field("Second Language Read";"Second Language Read")
                {
                    ApplicationArea = Basic;
                }
                field("Second Language Write";"Second Language Write")
                {
                    ApplicationArea = Basic;
                }
                field("Second Language Speak";"Second Language Speak")
                {
                    ApplicationArea = Basic;
                }
                field("Additional Language";"Additional Language")
                {
                    ApplicationArea = Basic;
                }
                field("Applicant Type";"Applicant Type")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Style = Strong;
                    StyleExpr = true;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                    Caption = 'Internal';
                    Editable = true;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(Citizenship;Citizenship)
                {
                    ApplicationArea = Basic;
                }
                field("Country Details";"Citizenship Details")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Job Applied For";"Job Applied For")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Requisition No";"Employee Requisition No")
                {
                    ApplicationArea = Basic;
                }
                field("Job Applied for Description";"Job Applied for Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Job Description';
                }
                label("Shortlisting Summary")
                {
                    ApplicationArea = Basic;
                    CaptionClass = Text19064672;
                    Caption = 'Shortlisting Summary';
                    Style = Strong;
                    StyleExpr = true;
                }
                field(Qualified;Qualified)
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
                field("Interview Invitation Sent";"Interview Invitation Sent")
                {
                    ApplicationArea = Basic;
                    Style = StrongAccent;
                    StyleExpr = true;
                }
            }
            group(Personal)
            {
                Caption = 'Personal';
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Ethnic Origin";"Ethnic Origin")
                {
                    ApplicationArea = Basic;
                }
                field(Disabled;Disabled)
                {
                    ApplicationArea = Basic;
                }
                field("Health Assesment?";"Health Assesment?")
                {
                    ApplicationArea = Basic;
                }
                field("Health Assesment Date";"Health Assesment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Age;Age)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Home Phone Number";"Home Phone Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No.';
                    Importance = Promoted;
                }
                field("Postal Address";"Postal Address")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Postal Address2";"Postal Address2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postal Address 2';
                }
                field("Postal Address3";"Postal Address3")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postal Address 3';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address";"Residential Address")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address2";"Residential Address2")
                {
                    ApplicationArea = Basic;
                }
                field("Residential Address3";"Residential Address3")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code2";"Post Code2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code 2';
                }
                field("Cell Phone Number";"Cell Phone Number")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Work Phone Number";"Work Phone Number")
                {
                    ApplicationArea = Basic;
                }
                field("Ext.";"Ext.")
                {
                    ApplicationArea = Basic;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field("Fax Number";"Fax Number")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fax';
                }
            }
        }
        area(factboxes)
        {
            part(Control1102755009;"HRM-Job Applications Factbox")
            {
                SubPageLink = "Application No"=field("Application No");
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
            group("&Functions")
            {
                Caption = '&Functions';
                action("&Upload to Employee Card")
                {
                    ApplicationArea = Basic;
                    Caption = '&Upload to Employee Card';
                    Image = ImportDatabase;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = false;

                    trigger OnAction()
                    begin
                        if "Employee No" = '' then begin
                        //IF NOT CONFIRM('Are you sure you want to Upload Applicants information to the Employee Card',FALSE) THEN EXIT;
                        HRJobApplications.SetFilter(HRJobApplications."Application No","Application No");
                        Report.Run(39005531,true,false,HRJobApplications);
                        end else begin
                        Message('This applicants information already exists in the employee card');
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
                action("&Print")
                {
                    ApplicationArea = Basic;
                    Caption = '&Print';
                    Image = PrintReport;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    begin
                        HRJobApplications.Reset;
                        HRJobApplications.SetRange(HRJobApplications."Application No","Application No");
                        if HRJobApplications.Find('-') then
                        Report.Run(51169,true,true,HRJobApplications);
                    end;
                }
            }
        }
    }

    var
        HRJobApplications: Record UnknownRecord61225;
        SMTP: Codeunit "SMTP Mail";
        HREmailParameters: Record UnknownRecord61656;
        Employee: Record UnknownRecord61188;
        Text19064672: label 'Shortlisting Summary';
}

