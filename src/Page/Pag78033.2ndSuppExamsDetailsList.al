#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78033 "2nd Supp. Exams Details List"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable78031;

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
                    Editable = false;
                }
                field("CAT Marks";"CAT Marks")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }
                field("Exam Marks";"Exam Marks")
                {
                    ApplicationArea = Basic;
                }
                field("Total Marks";"Total Marks")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Cost Per Exam";"Cost Per Exam")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Category;Category)
                {
                    ApplicationArea = Basic;
                }
                field("Current Academic Year";"Current Academic Year")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Academic Year';
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                    Caption = 'Unit Semester';
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
                field("Charge Posted";"Charge Posted")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
            }
        }
    }

    actions
    {
    }
}

