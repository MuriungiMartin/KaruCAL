#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68009 "ACA-Cancelled ApplicsList"
{
    CardPageID = "ACA-Applications Card 4";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61358;
    SourceTableView = where(Status=filter("Department Rejected"));

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
                field(Salutation;Salutation)
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
                field("Application Date";"Application Date")
                {
                    ApplicationArea = Basic;
                }
                field(Nationality;Nationality)
                {
                    ApplicationArea = Basic;
                }
                field("Address for Correspondence1";"Address for Correspondence1")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No. 1";"Telephone No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("First Degree Choice";"First Degree Choice")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Receipt";"Date of Receipt")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Admitted Degree";"Admitted Degree")
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
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
                field("Mode of Study";"Mode of Study")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

