#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68465 "ACA-Issued Admissions List"
{
    PageType = List;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=const("Admission Letter"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Application No.";"Application No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                }
                field("Country of Origin";"Country of Origin")
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence1";"Address for Correspondence1")
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence2";"Address for Correspondence2")
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence3";"Address for Correspondence3")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 2";"Telephone No. 2")
                {
                    ApplicationArea = Basic;
                }
                field("First Degree Choice";"First Degree Choice")
                {
                    ApplicationArea = Basic;
                }
                field(School1;School1)
                {
                    ApplicationArea = Basic;
                }
                field("Second Degree Choice";"Second Degree Choice")
                {
                    ApplicationArea = Basic;
                }
                field("School 2";"School 2")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Receipt";"Date of Receipt")
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                }
                field("Former School Code";"Former School Code")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Admission";"Date of Admission")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Completion";"Date of Completion")
                {
                    ApplicationArea = Basic;
                }
                field("Year of Examination";"Year of Examination")
                {
                    ApplicationArea = Basic;
                }
                field("Examination Body";"Examination Body")
                {
                    ApplicationArea = Basic;
                }
                field("Mean Grade Acquired";"Mean Grade Acquired")
                {
                    ApplicationArea = Basic;
                }
                field("Points Acquired";"Points Acquired")
                {
                    ApplicationArea = Basic;
                }
                field("Principal Passes";"Principal Passes")
                {
                    ApplicationArea = Basic;
                }
                field("Subsidiary Passes";"Subsidiary Passes")
                {
                    ApplicationArea = Basic;
                }
                field(Examination;Examination)
                {
                    ApplicationArea = Basic;
                }
                field("Application Form Receipt No.";"Application Form Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Index Number";"Index Number")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("HOD User ID";"HOD User ID")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Date";"HOD Date")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Time";"HOD Time")
                {
                    ApplicationArea = Basic;
                }
                field("HOD Recommendations";"HOD Recommendations")
                {
                    ApplicationArea = Basic;
                }
                field("Dean User ID";"Dean User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Dean Date";"Dean Date")
                {
                    ApplicationArea = Basic;
                }
                field("Dean Time";"Dean Time")
                {
                    ApplicationArea = Basic;
                }
                field("Dean Recommendations";"Dean Recommendations")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field(Select;Select)
                {
                    ApplicationArea = Basic;
                }
                field("Batch No.";"Batch No.")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Date";"Batch Date")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Time";"Batch Time")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Board Recommendation";"Admission Board Recommendation")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Board Date";"Admission Board Date")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Board Time";"Admission Board Time")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Degree";"Admitted Degree")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Department";"Admitted Department")
                {
                    ApplicationArea = Basic;
                }
                field("Deferred Until";"Deferred Until")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Meeting";"Date Of Meeting")
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Receipt Slip";"Date Of Receipt Slip")
                {
                    ApplicationArea = Basic;
                }
                field("Receipt Slip No.";"Receipt Slip No.")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Admission No";"Admission No")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted To Stage";"Admitted To Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Semester";"Admitted Semester")
                {
                    ApplicationArea = Basic;
                }
                field("First Choice Stage";"First Choice Stage")
                {
                    ApplicationArea = Basic;
                }
                field("First Choice Semester";"First Choice Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Second Choice Stage";"Second Choice Stage")
                {
                    ApplicationArea = Basic;
                }
                field("Second Choice Semester";"Second Choice Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Intake Code";"Intake Code")
                {
                    ApplicationArea = Basic;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Date Sent for Approval";"Date Sent for Approval")
                {
                    ApplicationArea = Basic;
                }
                field("Issued Date";"Issued Date")
                {
                    ApplicationArea = Basic;
                }
                field("Post Graduate";"Post Graduate")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(Campus;Campus)
                {
                    ApplicationArea = Basic;
                }
                field("Admissable Status";"Admissable Status")
                {
                    ApplicationArea = Basic;
                }
                field("Mode of Study";"Mode of Study")
                {
                    ApplicationArea = Basic;
                }
                field("Enquiry No";"Enquiry No")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Card)
            {
                ApplicationArea = Basic;
                RunObject = Page "ACA-Applic. Process Adm Letter";
                RunPageLink = "Application No."=field("Application No.");
            }
        }
    }
}

