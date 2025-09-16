#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69187 "ACA-Course Reg. Listing"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61532;
    SourceTableView = sorting("Student No.");

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Register for";"Register for")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Options;Options)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Class Code";"Class Code")
                {
                    ApplicationArea = Basic;
                }
                field("Final Clasification";"Final Clasification")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Academic Year";"Graduation Academic Year")
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

