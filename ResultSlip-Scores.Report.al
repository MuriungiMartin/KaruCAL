#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51567 "Result Slip - Scores"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Result Slip - Scores.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
            RequestFilterFields = "Student No.",Programme,Stage,Semester;
            column(ReportForNavId_2901; 2901)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration__Registration_Date_;"Registration Date")
            {
            }
            column(Course_Registration__Student_Type_;"Student Type")
            {
            }
            column(Stages_Description;Stages.Description)
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(Course_Registration__Course_Registration__Semester;"ACA-Course Registration".Semester)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration__Registration_Date_Caption;FieldCaption("Registration Date"))
            {
            }
            column(Mode_of_StudyCaption;Mode_of_StudyCaptionLbl)
            {
            }
            column(ACADEMIC_RESULT_SLIPCaption;ACADEMIC_RESULT_SLIPCaptionLbl)
            {
            }
            column(Units_CodeCaption;Units_CodeCaptionLbl)
            {
            }
            column(LevelCaption;LevelCaptionLbl)
            {
            }
            column(ProgrammeCaption;ProgrammeCaptionLbl)
            {
            }
            column(Student_Name_Caption;Student_Name_CaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(ResultCaption;ResultCaptionLbl)
            {
            }
            column(GradeCaption;GradeCaptionLbl)
            {
            }
            column(RemarkCaption;RemarkCaptionLbl)
            {
            }
            column(SemesterCaption;SemesterCaptionLbl)
            {
            }
            column(KARATINA_UNIVERSITYCaption;KARATINA_UNIVERSITYCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
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
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Reg. Transacton ID"=field("Reg. Transacton ID"),"Student No."=field("Student No.");
                DataItemTableView = where(Taken=const(Yes));
                RequestFilterFields = "Reg. Transacton ID",Programme,Stage,Semester;
                column(ReportForNavId_2992; 2992)
                {
                }
                column(Student_Units_Unit;Unit)
                {
                }
                column(UDesc;UDesc)
                {
                }
                column(Student_Units__Student_Units___Total_Score_;"ACA-Student Units"."Total Score")
                {
                    DecimalPlaces = 0:0;
                }
                column(Student_Units_Grade;Grade)
                {
                }
                column(Student_Units_Remarks;Remarks)
                {
                }
                column(MeanGrade;MeanGrade)
                {
                }
                column(MeanScore;MeanScore)
                {
                }
                column(Mean_Score_Caption;Mean_Score_CaptionLbl)
                {
                }
                column(Mean_Grade_Caption;Mean_Grade_CaptionLbl)
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
                    UDesc:='';
                    Units.Reset;
                    Units.SetRange(Units."Programme Code","ACA-Student Units".Programme);
                    Units.SetRange(Units.Code,Unit);
                    if Units.Find('-') then
                    UDesc:=Units.Desription;


                    if "ACA-Student Units"."Total Score" > 0 then begin
                    Gradings.Reset;
                    Gradings.SetRange(Gradings.Category,'DEFAULT');
                    LastGrade:='';
                    LastRemark:='';
                    LastScore:=0;
                    if Gradings.Find('-') then begin
                    ExitDo:=false;
                    repeat
                    if "ACA-Student Units"."Total Score" < LastScore then begin
                    if ExitDo = false then begin
                    Grade:=LastGrade;
                    Remarks:=LastRemark;
                    ExitDo:=true;
                    end;
                    end;
                    LastGrade:=Gradings.Grade;
                    LastScore:=Gradings."Up to";
                    if Gradings.Failed = true then
                    LastRemark:='Supplementary'
                    else
                    LastRemark:=Gradings.Remarks;

                    until Gradings.Next = 0;

                    if ExitDo = false then begin
                    Gradings2.Reset;
                    Gradings2.SetRange(Gradings2.Category,'DEFAULT');
                    if Gradings2.Find('+') then begin
                    Grade:=Gradings2.Grade;
                    Remarks:=Gradings2.Remarks;
                    end;

                    end;
                    end;

                    end else begin
                    Grade:='';
                    Remarks:='Not Done';
                    end;


                    OUnits:=OUnits + 1;
                    OScore:=OScore + "ACA-Student Units"."Total Score";
                end;
            }
            dataitem(UnknownTable61569;UnknownTable61569)
            {
                column(ReportForNavId_6400; 6400)
                {
                }
                column(Grading_System_Setup1_Description;Description)
                {
                }
                column(Grading_System_Setup1_Remarks;Remarks)
                {
                }
                column(Grading_System_Setup1__Grading_System_Setup1__Grade;"ACA-Grading System Setup1".Grade)
                {
                }
                column(Grading_System_Setup1_RemarksCaption;FieldCaption(Remarks))
                {
                }
                column(MarksCaption;MarksCaptionLbl)
                {
                }
                column(Key_to_Grading_System_Caption;Key_to_Grading_System_CaptionLbl)
                {
                }
                column(GradeCaption_Control1102760044;GradeCaption_Control1102760044Lbl)
                {
                }
                column(Date_________________________________________________________________________________________________Caption;Date_________________________________________________________________________________________________CaptionLbl)
                {
                }
                column(Date__________________________________________________________________________________________________________Caption;Date__________________________________________________________________________________________________________CaptionLbl)
                {
                }
                column(DataItem1102760023;HOD______________________________________________________________________________________________________________________CaptLbl)
                {
                }
                column(Register_________________________________________________________________________________________________Caption;Register_________________________________________________________________________________________________CaptionLbl)
                {
                }
                column(Signed_Caption;Signed_CaptionLbl)
                {
                }
                column(Grading_System_Setup1_Category;Category)
                {
                }
                column(Grading_System_Setup1_Up_to;"Up to")
                {
                }
            }

            trigger OnAfterGetRecord()
            begin
                if Cust.Get("ACA-Course Registration"."Student No.") then
                RFound:=true;
                if Prog.Get("ACA-Course Registration".Programme) then
                RFound:=true;
                if Stages.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage) then
                RFound:=true;

                OUnits:=0;
                OScore:=0;
                MeanScore:=0;
                MeanGrade:='';
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
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61569;
        Gradings2: Record UnknownRecord61569;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        LastRemark: Text[200];
        Mode_of_StudyCaptionLbl: label 'Mode of Study';
        ACADEMIC_RESULT_SLIPCaptionLbl: label 'ACADEMIC RESULT SLIP';
        Units_CodeCaptionLbl: label 'Units Code';
        LevelCaptionLbl: label 'Level';
        ProgrammeCaptionLbl: label 'Programme';
        Student_Name_CaptionLbl: label 'Student Name:';
        DescriptionCaptionLbl: label 'Description';
        ResultCaptionLbl: label 'Result';
        GradeCaptionLbl: label 'Grade';
        RemarkCaptionLbl: label 'Remark';
        SemesterCaptionLbl: label 'Semester';
        KARATINA_UNIVERSITYCaptionLbl: label 'KARATINA UNIVERSITY';
        Mean_Score_CaptionLbl: label 'Mean Score:';
        Mean_Grade_CaptionLbl: label 'Mean Grade:';
        MarksCaptionLbl: label 'Marks';
        Key_to_Grading_System_CaptionLbl: label 'Key to Grading System:';
        GradeCaption_Control1102760044Lbl: label 'Grade';
        Date_________________________________________________________________________________________________CaptionLbl: label 'Date:  ..............................................................................................';
        Date__________________________________________________________________________________________________________CaptionLbl: label 'Date:  .......................................................................................................';
        HOD______________________________________________________________________________________________________________________CaptLbl: label 'HOD:  ...................................................................................................................';
        Register_________________________________________________________________________________________________CaptionLbl: label 'Register:  ..............................................................................................';
        Signed_CaptionLbl: label 'Signed:';
}

