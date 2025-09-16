#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51722 "Exams Award List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Exams Award List.rdlc';

    dataset
    {
        dataitem(UnknownTable61739;UnknownTable61739)
        {
            DataItemTableView = where(Code=const(PASS));
            RequestFilterFields = "Programme Filter","Stage Filter","Semester Filter";
            column(ReportForNavId_3772; 3772)
            {
            }
            column(Logo;CompInf.Picture)
            {
            }
            column(CompanyName;CompInf.Name)
            {
            }
            column(University_EXAMINATIONS;'University EXAMINATIONS  ' )
            {
            }
            column(FORMAT_UPPERCASE_Depts_Description__; Format(UpperCase(Depts.Description)))
            {
            }
            column(FORMAT_UPPERCASE_Dimensions_Name_______DEPARTMENT_; Format(UpperCase(DeptDesc)) + ' DEPARTMENT')
            {
            }
            column(Semesters_Description_____ORDINARY_EXAMS_;Semesters.Description + ' ORDINARY EXAMS')
            {
            }
            column(USERID;UserId)
            {
            }
            column(Prog_Description;Prog.Description)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(Status_Msg1______FORMAT__Students_Count________Status_Msg2______FacDesc_____msg_____ProgDesc_____msg2_____Awrd__msg3;"Status Msg1"+' '+Format("Students Count")+' '+"Status Msg2"+' '+FacDesc+' '+msg+' '+ProgDesc+' '+msg2+' '+Awrd +msg3)
            {
            }
            column(AWARD_LIST_;'AWARD LIST')
            {
            }
            column(Dean____FacDesc;'Dean, '+FacDesc)
            {
            }
            column(Chairman_of_Senate_;'Chairman of Senate')
            {
            }
            column(ProgDesc;ProgDesc)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(EmptyStringCaption;EmptyStringCaptionLbl)
            {
            }
            column(EmptyStringCaption_Control1102755022;EmptyStringCaption_Control1102755022Lbl)
            {
            }
            column(Results_Status_Code;Code)
            {
            }
            column(Results_Status_Programme_Filter;"Programme Filter")
            {
            }
            column(Results_Status_Stage_Filter;"Stage Filter")
            {
            }
            column(Results_Status_Semester_Filter;"Semester Filter")
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field("Programme Filter"),Stage=field("Stage Filter"),"Exam Status"=field(Code),Semester=field("Semester Filter");
                DataItemTableView = sorting("Exam Grade") order(ascending);
                RequestFilterFields = "Exam Grade";
                column(ReportForNavId_2901; 2901)
                {
                }
                column(S_N_;'S/N')
                {
                }
                column(REG__NO_;'REG. NO')
                {
                }
                column(NAME_;'NAME')
                {
                }
                column(Course_Registration__Exam_Grade_;"Exam Grade")
                {
                }
                column(Course_Registration__Student_No__;"Student No.")
                {
                }
                column(Cust_Name;Cust.Name)
                {
                }
                column(N;N)
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
                column(Course_Registration_Exam_Status;"Exam Status")
                {
                }

                trigger OnAfterGetRecord()
                begin
                      if Cust.Get("ACA-Course Registration"."Student No.") then

                      StudentsL:='';
                      if ("ACA-Results Status".Code='FAIL') then begin
                      StudUnits.Reset;
                     // StudUnits.SETRANGE(StudUnits.Programme,"Course Registration".Programme);
                      StudUnits.SetRange(StudUnits.Stage,"ACA-Course Registration".Stage);
                      StudUnits.SetRange(StudUnits.Semester,"ACA-Course Registration".Semester);
                      StudUnits.SetRange(StudUnits."Result Status","ACA-Course Registration"."Exam Status");
                      StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                      StudUnits.SetFilter(StudUnits."Supp Taken",'%1',false);
                      if StudUnits.Find('-') then begin
                      repeat
                      StudentsL:=StudUnits.Unit+','+StudentsL
                      until StudUnits.Next=0;
                      end;
                      end;

                      if("ACA-Results Status".Code='SPECIAL') then begin
                      StudUnits.Reset;
                    //  StudUnits.SETRANGE(StudUnits.Programme,"Course Registration".Programme);
                      StudUnits.SetRange(StudUnits.Stage,"ACA-Course Registration".Stage);
                      StudUnits.SetRange(StudUnits.Semester,"ACA-Course Registration".Semester);
                      StudUnits.SetRange(StudUnits."Result Status","ACA-Course Registration"."Exam Status");
                      StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                      StudUnits.SetFilter(StudUnits."Supp Taken",'%1',false);
                      if StudUnits.Find('-') then begin
                      repeat
                     // StudUnits.CALCFIELDS(StudUnits."Exam Marks");
                     // IF StudUnits."Exam Marks"=0 THEN
                        StudentsL:=StudUnits.Unit+','+StudentsL
                      until StudUnits.Next=0;
                      end;
                      end;

                      if ("ACA-Results Status".Code='ACADEMIC LEAVE') then
                      StudentsL:="ACA-Course Registration".Remarks;


                      N:=N+1;
                end;

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Exam Grade");

                      CReg.Reset;
                      CReg.SetFilter(CReg.Programme,"ACA-Results Status".GetFilter("ACA-Results Status"."Programme Filter"));
                      CReg.SetFilter(CReg.Stage,"ACA-Results Status".GetFilter("ACA-Results Status"."Stage Filter"));
                      CReg.SetFilter(CReg.Semester,"ACA-Results Status".GetFilter("ACA-Results Status"."Semester Filter"));
                      AverageMarks:=0;
                      if CReg.Find('-') then begin
                      repeat
                      StudUnits.Reset;
                      StudUnits.SetRange(StudUnits.Stage,CReg.Stage);
                      StudUnits.SetRange(StudUnits.Semester,CReg.Semester);
                      StudUnits.SetRange(StudUnits."Result Status",'PASS');
                      StudUnits.SetRange(StudUnits."Student No.",CReg."Student No.");
                      StudUnits.SetFilter(StudUnits."Supp Taken",'%1',false);
                      if StudUnits.Find('-') then begin
                      repeat
                      StudUnits.CalcFields(StudUnits."Total Score");
                      AverageMarks:=AverageMarks+StudUnits."Total Score";
                      until StudUnits.Next=0;
                      end;

                     CReg.CalcFields(CReg."Units Taken");
                     if (AverageMarks<>0) and (CReg."Units Taken"<>0) then begin
                     AverageMarks:=AverageMarks/CReg."Units Taken";
                     CReg."Exam Grade":=GetGradeClassification(AverageMarks,CReg.Programme);
                     CReg.Modify;
                     end;
                     until CReg.Next=0;
                     end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                "ACA-Results Status".CalcFields("ACA-Results Status"."Students Count");
                 N:=0;
            end;

            trigger OnPreDataItem()
            begin
                  if CompInf.Get() then
                  CompInf.CalcFields(CompInf.Picture);

                // Labels
                //GET YEAR OF STUDY
                   Semesters.Reset;
                   Semesters.SetRange(Semesters.Code,"ACA-Results Status".GetFilter("Semester Filter"));
                   if Semesters.Find('-') then
                //YEAR

                // Prog.GET("Results Status".GETFILTER("Results Status"."Programme Filter"));
                 Prog.SetFilter(Prog.Code,"ACA-Results Status".GetFilter("ACA-Results Status"."Programme Filter"));
                 if Prog.Find('-') then begin
                 ProgDesc:=Prog.Description;
                //GET DEPT
                 Dimensions.Reset;
                 Dimensions.SetRange(Dimensions."Dimension Code",'DEPARTMENT');
                 Dimensions.SetRange(Dimensions.Code,Prog."Department Code");
                 if Dimensions.Find('-') then
                 DeptDesc:=Dimensions.Name;
                //DEPT

                //GET FACULTY
                 FacDesc := '';
                 Dimensions.Reset;
                 Dimensions.SetRange(Dimensions."Dimension Code",'SCHOOL');
                 Dimensions.SetRange(Dimensions.Code,Prog.Faculty);
                 if Dimensions.Find('-') then
                 FacDesc :=Dimensions.Name;
                //END FACULTY

                end;
                //End Labels

                AverageMarks:=0;
                // Update Students units results
                StudUnits.Reset;
                StudUnits.SetFilter(StudUnits.Programme,"ACA-Results Status".GetFilter("Programme Filter"));
                StudUnits.SetFilter(StudUnits.Stage,"ACA-Results Status".GetFilter("Stage Filter"));
                StudUnits.SetFilter(StudUnits.Semester,"ACA-Results Status".GetFilter("Semester Filter"));
                if StudUnits.Find('-') then begin
                repeat
                StudUnits.CalcFields(StudUnits."Total Score");
                StudUnits.CalcFields(StudUnits."Registration Status");
                StudUnits."Final Score":=StudUnits."Total Score";
                AverageMarks:=AverageMarks+StudUnits."Total Score";
                Grd:='';
                StudUnits.Failed:=false;
                if GetGradeStatus(StudUnits."Total Score",StudUnits.Programme)=false then begin
                StudUnits."Result Status":='PASS';
                end else begin
                StudUnits."Result Status":='FAIL';
                StudUnits.Failed:=true;
                end;
                if StudUnits."Total Score"=0 then
                StudUnits."Result Status":='FAIL';

                StudUnits.Grade:=Grd;

                CReg.Reset;
                CReg.SetRange(CReg."Student No.",StudUnits."Student No.");
                CReg.SetRange(CReg.Programme,StudUnits.Programme);
                CReg.SetRange(CReg.Semester,StudUnits.Semester);
                CReg.SetRange(CReg.Stage,StudUnits.Stage);
                if CReg.Find('-') then begin
                CReg.CalcFields(CReg."Units Taken");
                CReg.CalcFields(CReg."Units Failed");
                CReg.CalcFields(CReg."Units Passed");

                ExamsDone:=CReg."Units Taken";
                FailCount:=CReg."Units Failed";


                if CopyStr(Format(ExamsDone/2),2,2)='.' then begin
                if (ExamsDone<>0) and (FailCount<>0) then
                if (ExamsDone/(FailCount+1)) <=2 then
                StudUnits."Result Status":='REPEAT';
                end else begin
                if (ExamsDone<>0) and (FailCount<>0) then
                if (ExamsDone/FailCount) <=2 then
                StudUnits."Result Status":='REPEAT';;
                end;
                CReg.CalcFields(CReg."Units Passed");
                CReg.CalcFields(CReg."Units Failed");
                CReg.CalcFields(CReg."Units Repeat");

                CReg."Exam Status":='';
                if (CReg."Units Failed"=0) and (CReg."Units Repeat"=0) and (CReg."Units Passed"<>0) then
                CReg."Exam Status":='PASS';
                if (CReg."Units Failed"<>0)  then
                CReg."Exam Status":='FAIL';
                if  (CReg."Units Repeat"<>0)  then
                CReg."Exam Status":='REPEAT';

                if CReg."Registration Status"<>0 then
                CReg."Exam Status":=Format(CReg."Registration Status");


                CReg."Exam Grade":=GetGradeClassification(AverageMarks,CReg.Programme);
                CReg.Modify;
                end;
                if StudUnits."Registration Status"<>0 then
                StudUnits."Result Status":=Format(StudUnits."Registration Status");
                StudUnits.Modify;
                until StudUnits.Next=0;
                end;
                //GetGrade(StudUnits."Total Score",StudUnits.Programme);
                 msg:='having successfully completed the course requirments for award of ';
                 msg2:=' and it is there fore recommended that they be awarded';
                 msg3:=' in the classification indicated ';
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        StudUnits: Record UnknownRecord61549;
        CReg: Record UnknownRecord61532;
        ExamsDone: Integer;
        FailCount: Integer;
        Cust: Record Customer;
        Semesters: Record UnknownRecord61518;
        Dimensions: Record "Dimension Value";
        Prog: Record UnknownRecord61511;
        FacDesc: Code[100];
        Depts: Record UnknownRecord61587;
        Stages: Record UnknownRecord61516;
        StudentsL: Text[250];
        N: Integer;
        Grd: Code[50];
        Marks: Decimal;
        AverageMarks: Decimal;
        Awrd: Text[50];
        ProgDesc: Text[100];
        msg: Text[250];
        msg2: Text[250];
        msg3: Text[250];
        KIMATHI_UNIVERISTYCaptionLbl: label 'KIMATHI UNIVERISTY';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        EmptyStringCaptionLbl: label '_______________________________________';
        EmptyStringCaption_Control1102755022Lbl: label '_______________________________________';
        CompInf: Record "Company Information";
        DeptDesc: Text[100];


    procedure GetGradeStatus(var AvMarks: Decimal;var ProgCode: Code[20]) F: Boolean
    var
        LastGrade: Code[50];
        LastRemark: Code[50];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[50];
        GLabel: array [6] of Code[50];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        ProgrammeRec: Record UnknownRecord61511;
    begin
        F:=false;

        GradeCategory:='';
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(ProgCode) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');

        if AvMarks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if AvMarks < LastScore then begin
        if ExitDo = false then begin
        Grd:=Gradings.Grade;
        F:=Gradings.Failed;
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin


        end;
    end;


    procedure GetGradeClassification(var AvMarks2: Decimal;var ProgCode2: Code[20]) CS: Code[50]
    var
        LastGrade2: Code[50];
        LastRemark2: Code[50];
        ExitDo2: Boolean;
        LastScore2: Decimal;
        Gradings2: Record UnknownRecord61599;
        Gradings3: Record UnknownRecord61599;
        GradeCategory2: Code[50];
        ProgrammeRec2: Record UnknownRecord61511;
    begin
        CS:='';

        GradeCategory2:='';
        ProgrammeRec2.Reset;
        if ProgrammeRec2.Get(ProgCode2) then
        GradeCategory2:=ProgrammeRec2."Exam Category";
        if GradeCategory2='' then Error('Please note that you must specify Exam Category in Programme Setup');

        if AvMarks2 > 0 then begin
        Gradings2.Reset;
        Gradings2.SetRange(Gradings2.Category,GradeCategory2);
        LastGrade2:='';
        LastRemark2:='';
        LastScore2:=0;
        if Gradings2.Find('-') then begin
        ExitDo2:=false;
        repeat
        LastScore2:=Gradings2."Up to";
        if AvMarks2 < LastScore2 then begin
        if ExitDo2 = false then begin
        Grd:=Gradings2.Grade;
        CS:=Gradings2.Remarks;
        ExitDo2:=true;
        end;
        end;

        until Gradings2.Next = 0;


        end;

        end else begin


        end;
    end;
}

