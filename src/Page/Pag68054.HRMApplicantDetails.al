#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68054 "HRM-Applicant Details"
{
    AutoSplitKey = false;
    PageType = Document;
    SourceTable = UnknownTable61063;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Applicant First Name";"Applicant First Name")
                {
                    ApplicationArea = Basic;
                }
                field("Applicant Last Name";"Applicant Last Name")
                {
                    ApplicationArea = Basic;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field(Sex;Sex)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("Posistion Applied for";"Posistion Applied for")
                {
                    ApplicationArea = Basic;
                }
                field("Birth Date";"Birth Date")
                {
                    ApplicationArea = Basic;
                }
                field("Recruitment Stage";"Recruitment Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Actual Score";"Actual Score")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000028;"HRM-Applicant Qualif. lines")
            {
                SubPageLink = "Applicant ID"=field("Entry No"),
                              "Job ID"=field("Posistion Applied for"),
                              "Recruitment Stage"=field("Recruitment Stage");
            }
            group("Contact information")
            {
                Caption = 'Contact information';
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Post Code/City";"Post Code/City")
                {
                    ApplicationArea = Basic;
                }
                field("Country Code";"Country Code")
                {
                    ApplicationArea = Basic;
                }
                field("Phone No";"Phone No")
                {
                    ApplicationArea = Basic;
                }
                field("Mobile No.";"Mobile No.")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        ApplicantLine: Record UnknownRecord61064;
        JobReq: Record UnknownRecord61059;
        i: Integer;
}

