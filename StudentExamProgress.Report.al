#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51670 "Student Exam Progress"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Exam Progress.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Course_Registration__Course_Registration___Student_No__;"ACA-Course Registration"."Student No.")
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Programme=field(Programme),Stage=field(Stage),Semester=field(Semester);
                DataItemTableView = sorting(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.");
                RequestFilterFields = Programme,Stage;
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units_Programme;Programme)
                {
                }
                column(Student_Units_Stage;Stage)
                {
                }
                column(Student_Units_Programme_Control1000000017;Programme)
                {
                }
                column(Student_Units_Stage_Control1000000020;Stage)
                {
                }
                column(Student_Units_Semester;Semester)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(Student_Units_Programme_Control1000000017Caption;FieldCaption(Programme))
                {
                }
                column(Student_Units_Stage_Control1000000020Caption;FieldCaption(Stage))
                {
                }
                column(Student_Units_SemesterCaption;FieldCaption(Semester))
                {
                }
                column(Student_Units_UnitCaption;FieldCaption(Unit))
                {
                }
                column(Student_Units_ProgrammeCaption;FieldCaption(Programme))
                {
                }
                column(Student_Units_StageCaption;FieldCaption(Stage))
                {
                }
                column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
                {
                }
                column(Student_Units_Student_No_;"Student No.")
                {
                }
                column(Student_Units_ENo;ENo)
                {
                }

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo(Stage);
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
}

