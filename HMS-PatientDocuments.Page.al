#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68192 "HMS-Patient Documents"
{
    Caption = 'Patient Documents View';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61402;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Registered";"Date Registered")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Type";"Patient Type")
                {
                    ApplicationArea = Basic;
                }
                field(Surname;Surname)
                {
                    ApplicationArea = Basic;
                }
                field("Middle Name";"Middle Name")
                {
                    ApplicationArea = Basic;
                }
                field("Last Name";"Last Name")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Date Of Birth";"Date Of Birth")
                {
                    ApplicationArea = Basic;
                }
                field("Marital Status";"Marital Status")
                {
                    ApplicationArea = Basic;
                }
                field("ID Number";"ID Number")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Ref. No.";"Patient Ref. No.")
                {
                    ApplicationArea = Basic;
                }
                field("Depandant Principle Member";"Depandant Principle Member")
                {
                    ApplicationArea = Basic;
                }
                field("Patient Current Location";"Patient Current Location")
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
            group("Documents View")
            {
                Caption = 'Documents View';
                Image = LotInfo;
                action(Appointments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Appointments';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Appointments Listing";
                }
                action("Observation List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Observation List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Observation Listing Report";
                }
                action("Treatment List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Treatment List';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Treatment Listing Report";
                }
                action("Laboratory Test(s) Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Test(s) Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Laboratory Test Summary";
                }
                action("Laboratory Test(s) Detailed")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Test(s) Detailed';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Laboratory Test Detailed";
                }
                action("Laboratory Test(s) Finding")
                {
                    ApplicationArea = Basic;
                    Caption = 'Laboratory Test(s) Finding';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Laboratory Test Finding";
                }
                action("Phamacy Drag Issue(s) Summary")
                {
                    ApplicationArea = Basic;
                    Caption = 'Phamacy Drag Issue(s) Summary';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Pharmacy Issues Report";
                }
                action("Phamacy Drag Ussue")
                {
                    ApplicationArea = Basic;
                    Caption = 'Phamacy Drag Ussue';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Pharmacy Issues Report";
                }
                action("Patient Listing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Patient Listing';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Patient Listing Report";
                }
                action("Admission listing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Admission listing';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Admission Listing Summary";
                }
                action("Referrals listing")
                {
                    ApplicationArea = Basic;
                    Caption = 'Referrals listing';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Referral Listing Report";
                }
                action("Daily Attendance (Outpatient)")
                {
                    ApplicationArea = Basic;
                    Caption = 'Daily Attendance (Outpatient)';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Daily Attendance Report";
                }
                action("Injection Register")
                {
                    ApplicationArea = Basic;
                    Caption = 'Injection Register';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Injection Register Report";
                }
            }
            group("&Periodic Activities")
            {
                Caption = '&Periodic Activities';
                Image = RegisteredDocs;
                action("Process Employee & Detpt")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Employee & Detpt';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "HMS Process Employee & Deps";
                }
                action("Process Student Patients")
                {
                    ApplicationArea = Basic;
                    Caption = 'Process Student Patients';
                    Image = "Report";
                    Promoted = true;
                    RunObject = Report "Process Student Patients";
                }
            }
        }
    }
}

