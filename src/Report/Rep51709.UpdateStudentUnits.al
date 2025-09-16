#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51709 "Update Student Units"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Update Student Units.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = "Student No.",Programme,Stage,Semester;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Student_No_;"Student No.")
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
                DataItemLink = "Reg. Transacton ID"=field("Reg. Transacton ID"),"Student No."=field("Student No.");
                RequestFilterFields = "Student No.",Semester,Programme,Stage;
                column(ReportForNavId_2992; 2992)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
                {
                }
                column(COMPANYNAME;COMPANYNAME)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(USERID;UserId)
                {
                }
                column(Student_Units__Reg__Transacton_ID_;"Reg. Transacton ID")
                {
                }
                column(Student_Units__Student_No__;"Student No.")
                {
                }
                column(Student_Units_Semester;Semester)
                {
                }
                column(Student_Units_Programme;Programme)
                {
                }
                column(Student_Units__Register_for_;"Register for")
                {
                }
                column(Student_Units_Stage;Stage)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(Student_UnitsCaption;Student_UnitsCaptionLbl)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Student_Units__Reg__Transacton_ID_Caption;FieldCaption("Reg. Transacton ID"))
                {
                }
                column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
                {
                }
                column(Student_Units_SemesterCaption;FieldCaption(Semester))
                {
                }
                column(Student_Units_ProgrammeCaption;FieldCaption(Programme))
                {
                }
                column(Student_Units__Register_for_Caption;FieldCaption("Register for"))
                {
                }
                column(Student_Units_StageCaption;FieldCaption(Stage))
                {
                }
                column(Student_Units_UnitCaption;FieldCaption(Unit))
                {
                }
                column(Student_Units_ENo;ENo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CourseReg.Reset;
                    CourseReg.SetRange(CourseReg."Student No.","ACA-Student Units"."Student No.");
                    CourseReg.SetRange(CourseReg."Reg. Transacton ID","ACA-Student Units"."Reg. Transacton ID");
                    //CourseReg.setrange(CourseReg.Semester,)
                    if CourseReg.Find('-') then begin
                    if "ACA-Student Units".Semester <> CourseReg.Semester then begin
                    "ACA-Student Units".Semester:=CourseReg.Semester;
                    "ACA-Student Units".Modify;
                    end;
                    end;
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
        CourseReg: Record UnknownRecord61532;
        Student_UnitsCaptionLbl: label 'Student Units';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

