#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78003 "Special Exams Details Lists"
{
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable78002;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Unit Code";"Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Description";"Unit Description")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("CAT Marks";"CAT Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Exam Marks";"Exam Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Marks";"Total Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Grade;Grade)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Cost Per Exam";"Cost Per Exam")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Current Academic Year";"Current Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Academic Year';
                    Editable = false;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Semester';
                    Editable = false;
                }
                field(Programme;Programme)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Programme';
                    Editable = false;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Stage';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

