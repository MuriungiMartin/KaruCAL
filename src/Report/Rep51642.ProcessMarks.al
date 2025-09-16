#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51642 "Process Marks"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Process Marks.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            RequestFilterFields = Programme,Stage,Semester,"Student No.";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(USERID;UserId)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(EXAMS_PROCESSSING_;'EXAMS PROCESSSING')
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration__Cumm_Score_;"Cumm Score")
            {
            }
            column(Course_Registration__Current_Cumm_Score_;"Current Cumm Score")
            {
            }
            column(Course_Registration__Current_Cumm_Grade_;"Current Cumm Grade")
            {
            }
            column(Course_Registration__Cumm_Grade_;"Cumm Grade")
            {
            }
            column(Course_Registration__Exam_Status_;"Exam Status")
            {
            }
            column(Course_Registration__Cumm_Status_;"Cumm Status")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Course_Registration_StageCaption;FieldCaption(Stage))
            {
            }
            column(Course_Registration__Cumm_Score_Caption;FieldCaption("Cumm Score"))
            {
            }
            column(Course_Registration__Current_Cumm_Score_Caption;FieldCaption("Current Cumm Score"))
            {
            }
            column(Course_Registration__Current_Cumm_Grade_Caption;FieldCaption("Current Cumm Grade"))
            {
            }
            column(Course_Registration__Cumm_Grade_Caption;FieldCaption("Cumm Grade"))
            {
            }
            column(Course_Registration__Exam_Status_Caption;FieldCaption("Exam Status"))
            {
            }
            column(Course_Registration__Cumm_Status_Caption;FieldCaption("Cumm Status"))
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
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
                DataItemLink = "Student No."=field("Student No."),Semester=field(Semester),Programme=field(Programme);
                DataItemTableView = sorting(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.",ENo);
                RequestFilterFields = "Student No.",Programme,Stage;
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units__Final_Score_;"Final Score")
                {
                }
                column(Student_Units_Grade;Grade)
                {
                }
                column(Student_Units__Result_Status_;"Result Status")
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(Student_Units_Description;Description)
                {
                }
                column(Student_Units_UnitCaption;FieldCaption(Unit))
                {
                }
                column(Student_Units_DescriptionCaption;FieldCaption(Description))
                {
                }
                column(Student_Units__Final_Score_Caption;FieldCaption("Final Score"))
                {
                }
                column(Student_Units_GradeCaption;FieldCaption(Grade))
                {
                }
                column(Student_Units__Result_Status_Caption;FieldCaption("Result Status"))
                {
                }
                column(Student_Units_Programme;Programme)
                {
                }
                column(Student_Units_Stage;Stage)
                {
                }
                column(Student_Units_Semester;Semester)
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

                trigger OnAfterGetRecord()
                begin
                      ExamsProcessing.UpdateStudentUnits("ACA-Course Registration"."Student No.","ACA-Course Registration".Programme,
                      "ACA-Course Registration".Semester,"ACA-Course Registration".Stage);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 //ExamsProcessing.UpdateCourseReg("ACA-Course Registration"."Student No.","ACA-Course Registration".Programme,"ACA-Course Registration".Stage,
                 //"ACA-Course Registration".Semester);



                  ExamsProcessing.UpdateCourseReg("ACA-Course Registration"."Student No.","ACA-Course Registration".Programme,
                 "ACA-Course Registration".GetFilter("Stage Filter"),"ACA-Course Registration".GetFilter("Semester Filter"));

                  ExamsProcessing.UpdateCummStatus("ACA-Course Registration"."Student No.","ACA-Course Registration".Programme,
                 "ACA-Course Registration".GetFilter("Stage Filter"),"ACA-Course Registration".GetFilter("Semester Filter"));
                // Process
                  //ExamsProcessing.UpdateCummStatus("ACA-Course Registration"."Student No.","ACA-Course Registration".Programme,
                 ///"ACA-Course Registration".GETFILTER("Stage Filter"),"ACA-Course Registration".GETFILTER("Semester Filter"));
            end;
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
        ExamsProcessing: Codeunit "Exams Processing1";
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

