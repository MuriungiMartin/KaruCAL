#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78052 "ACA-Results Buffer Header List"
{
    CardPageID = "ACA-Results Buffer Header Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable78053;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Lecturer;Lecturer)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Number of Students";"Number of Students")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Users)
            {
                ApplicationArea = Basic;
                Caption = 'Users';
                Image = Permission;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "ACA-Results Buffer Users";
            }
        }
    }
}

