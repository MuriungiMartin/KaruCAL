#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68494 "ACA-Applications List"
{
    CardPageID = "ACA-Application Form Header";
    PageType = List;
    SourceTable = UnknownTable61358;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Application No.";"Application No.")
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Approvals)
            {
                Caption = 'Approvals';
                action("Application Form")
                {
                    ApplicationArea = Basic;
                    Caption = 'Application Form';
                    RunObject = Page "ACA-Application Form Header";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Department Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Department Approval';
                    RunObject = Page "ACA-Applic. Form Department";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("School/Faculty Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'School/Faculty Approval';
                    RunObject = Page "ACA-Application Form Dean";
                    RunPageLink = "Application No."=field("Application No.");
                }
                action("Deans Approval")
                {
                    ApplicationArea = Basic;
                    Caption = 'Deans Approval';
                    RunObject = Page "ACA-Applic. Form Acad Process";
                    RunPageLink = "Application No."=field("Application No.");
                }
            }
        }
    }

    trigger OnInit()
    begin
        //CurrPage.LOOKUPMODE := TRUE;
    end;
}

