#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51094 "Exams Processing"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Coregz;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=filter(No));
            RequestFilterFields = "Student No.",Programme,Stage,Semester;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudNo;Coregz."Student No.")
            {
            }
            column(Prog;Coregz.Programme)
            {
            }
            column(Sem;Coregz.Semester)
            {
            }
            column(Stag;Coregz.Stage)
            {
            }
            column(CumSc;Coregz."Cumm Score")
            {
            }
            column(CurrSem;Coregz."Current Cumm Score")
            {
            }
            column(sName;sName)
            {
            }
            dataitem(StudUnitsz;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Programme=field(Programme),Semester=field(Semester);
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                column(Unit;StudUnitsz.Unit)
                {
                }
                column(Desc;StudUnitsz.Description)
                {
                }
                column(Score;StudUnitsz."Total Score")
                {
                }
                column(Final;StudUnitsz."Final Score")
                {
                }
                column(Grade;StudUnitsz.Grade)
                {
                }
                column(Status;StudUnitsz."Exam Status")
                {
                }

                trigger OnAfterGetRecord()
                var
                    AcaSpecialExamsDetailss: Record UnknownRecord78002;
                begin
                      //ExamProcess.UpdateStudentUvbnits("Student Units"."Student No.","Student Units".Programme,"Student Units".Semester,"Student Units".Stage);
                    Clear(TotMarks);
                    progress.Update(3,StudUnitsz.Unit);
                     // EResults.RESET;
                     // EResults.SETFILTER(EResults."Student No.","Student Units"."Student No.");
                     // EResults.SETFILTER(EResults.Programme,"Student Units".Programme);
                     // EResults.SETFILTER(EResults.Unit,"Student Units".Unit);
                    //  EResults.SETFILTER(EResults.Semester,"Student Units".Semester);
                    //  EResults.SETFILTER(EResults."Reg. Transaction ID","Student Units"."Reg. Transacton ID");
                     // IF EResults.FIND('-') THEN BEGIN
                     // REPEAT
                     // BEGIN
                     //    EResults.VALIDATE(EResults.Score);
                        // EResults.CALCFIELDS(EResults.Stager);
                        // EResults.SETCURRENTKEY(EResults."Student No.",EResults.Programme,EResults.Stage,EResults.Unit,
                        // EResults.Semester,EResults.Exam,EResults."Reg. Transaction ID",EResults."Re-Sited",
                       //  EResults."Entry No");
                       //  IF EResults.Stage<>EResults.Stager THEN BEGIN
                        // EResults.Stage:=EResults.Stager;
                       //   EResults.RENAME(EResults."Student No.",EResults.Programme,EResults.Stager,EResults.Unit,
                       //  EResults.Semester,EResults.Exam,EResults."Reg. Transaction ID",EResults."Re-Sited",
                       //  EResults."Entry No");

                        // EResults.MODIFY;
                        // END;
                       // TotMarks:=TotMarks+EResults.Contribution;

                     // END;
                     // UNTIL EResults.NEXT=0;
                     // END;
                       // ERROR(FORMAT(TotMarks));
                    StudUnitsz.CalcFields(StudUnitsz."Total Score",StudUnitsz."CATs Marks");

                      StudUnitsz."Final Score":=StudUnitsz."Total Score";
                      StudUnitsz."Total Marks":=StudUnitsz."Total Score";
                      StudUnitsz.Modify;
                      TotMarks:=StudUnitsz."Total Score";

                    //CALCFIELDS("Student Units"."Credited Hours",
                    //"Student Units"."CATs Marks","Student Units"."EXAMs Marks");
                    //IF   "Student Units"."Credited Hours"<>0 THEN
                     // "Student Units"."Credit Hours":="Student Units"."Credited Hours";
                    if UnitsR.Get(StudUnitsz.Programme,StudUnitsz.Stage,StudUnitsz.Unit) then //BEGIN
                    StudUnitsz."No. Of Units":=UnitsR."No. Units";
                    //"Student Units"."Unit Type":=UnitsR."Unit Type";
                    //END;
                      "Units/Subj".Reset;
                      "Units/Subj".SetRange("Units/Subj"."Programme Code",StudUnitsz.Programme);
                      "Units/Subj".SetRange("Units/Subj".Code,StudUnitsz.Unit);
                      "Units/Subj".SetRange("Units/Subj"."Stage Code",StudUnitsz.Stage);
                      if "Units/Subj".Find('-') then
                      StudUnitsz.Description:="Units/Subj".Desription;

                      StudUnitsz.CalcFields(StudUnitsz."Total Score");
                      //"Student Units".CALCFIELDS("Student Units"."Ignore in Final Average");
                      StudUnitsz."Ignore in Cumm  Average":=StudUnitsz."Ignore in Final Average";
                      StudUnitsz.Modify;
                           // CLEAR(TotMarks);
                           // TotMarks:="Student Units"."Total Score";
                      if (GetGradeStatus(TotMarks,StudUnitsz.Programme,StudUnitsz.Unit)) or
                      (StudUnitsz."Final Score"=0)  then begin
                      StudUnitsz."Result Status":='FAIL';
                      StudUnitsz.Failed:=true;
                      end else begin
                      StudUnitsz."Result Status":='PASS';
                      StudUnitsz.Failed:=false;
                      end;
                      if ((GetGradeStatus(TotMarks,StudUnitsz.Programme,StudUnitsz.Unit)) and (StudUnitsz.Unit<>'') and (StudUnitsz.Grade<>'')) then begin
                        // If failed, then update supplementary
                        AcaSpecialExamsDetailss.Reset;
                        AcaSpecialExamsDetailss.SetRange("Student No.",StudUnitsz."Student No.");
                        AcaSpecialExamsDetailss.SetRange("Current Academic Year",Coregz."Academic Year");
                        AcaSpecialExamsDetailss.SetRange("Unit Code",StudUnitsz.Unit);
                        AcaSpecialExamsDetailss.SetRange(Programme,StudUnitsz.Programme);
                          StudUnitsz.CalcFields("CATs Marks","EXAMs Marks");
                        AcaSpecialExamsDetailss.SetRange(Category,AcaSpecialExamsDetailss.Category::Supplementary);
                        if not (AcaSpecialExamsDetailss.Find('-')) then begin
                          AcaSpecialExamsDetailss.Init;
                          AcaSpecialExamsDetailss."Academic Year":=StudUnitsz."Academic Year";
                          AcaSpecialExamsDetailss.Semester:=StudUnitsz.Semester;
                          AcaSpecialExamsDetailss."Exam Session":=StudUnitsz."Session Code";
                          AcaSpecialExamsDetailss."Student No.":=StudUnitsz."Student No.";
                          AcaSpecialExamsDetailss.Stage:=StudUnitsz.Stage;
                          AcaSpecialExamsDetailss."CAT Marks":=StudUnitsz."CATs Marks";
                          AcaSpecialExamsDetailss."Exam Marks":=StudUnitsz."EXAMs Marks";
                          AcaSpecialExamsDetailss.Programme:=StudUnitsz.Programme;
                          AcaSpecialExamsDetailss."Unit Code":=StudUnitsz.Unit;
                          AcaSpecialExamsDetailss.Category:=AcaSpecialExamsDetailss.Category::Supplementary;
                          AcaSpecialExamsDetailss."Current Academic Year":=StudUnitsz."Academic Year";
                          AcaSpecialExamsDetailss.Status:=AcaSpecialExamsDetailss.Status;
                          if AcaSpecialExamsDetailss.Insert then;
                          end else begin
                            if AcaSpecialExamsDetailss."Exam Marks"=0 then
                              AcaSpecialExamsDetailss."Exam Marks":=StudUnitsz."EXAMs Marks";
                            if AcaSpecialExamsDetailss."CAT Marks"=0 then
                              AcaSpecialExamsDetailss."CAT Marks":= StudUnitsz."CATs Marks";
                            AcaSpecialExamsDetailss.Modify;

                            end;
                        end else if not (GetGradeStatus(TotMarks,StudUnitsz.Programme,StudUnitsz.Unit)) then begin
                          // Not Failed.. Remove from Supplementary
                        AcaSpecialExamsDetailss.Reset;
                        AcaSpecialExamsDetailss.SetRange("Student No.",StudUnitsz."Student No.");
                        AcaSpecialExamsDetailss.SetRange("Current Academic Year",Coregz."Academic Year");
                        AcaSpecialExamsDetailss.SetRange("Unit Code",StudUnitsz.Unit);
                        AcaSpecialExamsDetailss.SetRange(Programme,StudUnitsz.Programme);
                        AcaSpecialExamsDetailss.SetRange(Category,AcaSpecialExamsDetailss.Category::Supplementary);
                        if AcaSpecialExamsDetailss.Find('-') then AcaSpecialExamsDetailss.Delete;
                          end;

                      Clear(Gradeaqq2);
                      StudUnitsz.Grade:=GetGrade(
                      TotMarks,StudUnitsz.Programme,StudUnitsz.Unit);
                      StudUnitsz.Grade:=GetGrade(StudUnitsz."Total Score",StudUnitsz.Programme,StudUnitsz.Unit);
                      Gradeaqq2:=GetGrade(StudUnitsz."Final Score",StudUnitsz.Programme,StudUnitsz.Unit);
                      Modify;
                     // "Student Units"."GPA Points":=GetGPAPoints("Student Units"."Final Score","Student Units".Unit);
                      //"Student Units"."Unit Points":=((GetGPAPoints("Student Units"."Final Score","Student Units".Unit))*
                      //  ("Student Units"."Credit Hours"));


                    //"Student Units".SETCURRENTKEY(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.",ENo
                    //);
                    // "Student Units".RENAME(
                    //"Student Units".Programme,"Student Units".Stage,"Student Units".Unit,
                    //"Student Units".Semester,"Student Units"."Reg. Transacton ID","Student Units"."Student No.",
                    //"Student Units".ENo,
                    // GetGrade("Student Units"."Final Score",
                    // "Student Units".Unit),
                    //"Student Units"."Academic Year"
                    // );

                      //"Student Units".MODIFY;

                    // Update Supplimentary
                     if StudUnitsz."Register for"=StudUnitsz."register for"::Supplimentary then begin
                     StudUnits.Reset;
                     StudUnits.SetRange(StudUnits."Student No.",StudUnitsz."Student No.");
                     StudUnits.SetRange(StudUnits.Unit,StudUnitsz.Unit);
                     StudUnits.SetRange(StudUnits."Re-Take",false);
                     StudUnits.SetRange(StudUnits."Supp Taken",false);
                     if StudUnits.Find('-') then begin
                     repeat
                     StudUnits."Supp Taken":=true;
                     StudUnits.Modify;
                     until StudUnits.Next=0;
                     end;
                     end;

                     EResults.Reset;
                     EResults.SetRange(EResults."Student No.",StudUnitsz."Student No.");
                     EResults.SetRange(EResults.Unit,StudUnitsz.Unit);
                     EResults.SetRange(EResults.Programme,StudUnitsz.Programme);
                     EResults.SetRange(EResults.Stage,StudUnitsz.Stage);
                     EResults.SetRange(EResults.Semester,StudUnitsz.Semester);
                     EResults.SetRange(EResults."Re-Take",false);
                     if EResults.Find('-') then begin
                     repeat
                     EResults.CalcFields(EResults."Re-Sit");
                     EResults."Re-Sited":=EResults."Re-Sit";
                     EResults.Modify;
                     until EResults.Next=0;
                     end;
                     StudUnitsz."Consolidated Mark Pref." :='';
                     if StudUnitsz.Grade='E' then
                     StudUnitsz."Consolidated Mark Pref." :='^';
                    StudUnitsz.CalcFields(StudUnitsz."CATs Marks Exists",StudUnitsz."EXAMs Marks Exists");
                    if ((StudUnitsz."CATs Marks Exists"=false) and (StudUnitsz."EXAMs Marks Exists"=false)) then begin
                    StudUnitsz."Consolidated Mark Pref." :='x';
                      end else if ((StudUnitsz."CATs Marks Exists"=true) and (StudUnitsz."EXAMs Marks Exists"=false)) then begin
                    StudUnitsz."Consolidated Mark Pref." :='c';
                      end else if ((StudUnitsz."CATs Marks Exists"=false) and (StudUnitsz."EXAMs Marks Exists"=true)) then begin
                    StudUnitsz."Consolidated Mark Pref." :='e';
                      end;


                    StudUnitsz.Modify;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
                 Clear(sName);
                 cust.Reset;
                 cust.SetRange(cust."No.",Coregz."Student No.");
                 if cust.Find('-') then
                 sName:=cust.Name;
                progress.Update(1,Coregz."Student No.");
                progress.Update(2,Coregz.Programme);
            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
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

    trigger OnPostReport()
    begin
         progress.Close;
    end;

    trigger OnPreReport()
    begin
         progress.Open('Processing 1 of 7.\This may take a minute or two.....                 \Stud: #1#############################################'+
         '\Prog: #2############################################\Unit: #3#################################################');
    end;

    var
        ExamProcess: Codeunit "Exams Processing";
        EResults: Record UnknownRecord61548;
        UnitsR: Record UnknownRecord61517;
        "Units/Subj": Record UnknownRecord61517;
        Sem: Record UnknownRecord61692;
        StudUnits: Record UnknownRecord61549;
        stduntz: Record UnknownRecord61549;
        TotalCatMarks: Decimal;
        TotalCatContributions: Decimal;
        TotalMainExamContributions: Decimal;
        TotalExamMark: Decimal;
        FinalExamMark: Decimal;
        FinalCATMarks: Decimal;
        Gradez: Code[10];
        TotalMarks: Decimal;
        Gradings: Record UnknownRecord61599;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Gradings2: Record UnknownRecord61599;
        Gradeaqq2: Code[10];
        TotMarks: Decimal;
        sName: Code[250];
        cust: Record Customer;
        progress: Dialog;
        UnitsRegister: Record UnknownRecord61517;


    procedure GetGrade(EXAMMark: Decimal;UnitG: Code[20];UnitSubj: Code[20]) xGrade: Text[100]
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
        Marks: Decimal;
    begin
         Clear(Marks);
        Marks:=EXAMMark;
        GradeCategory:='';
        //UnitsRR.RESET;
        //UnitsRR.SETRANGE(UnitsRR."Programme Code","Student Units".Programme);
        //UnitsRR.SETRANGE(UnitsRR.Code,UnitG);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Student Units".Stage);
        //IF UnitsRR.FIND('-') THEN BEGIN
        //IF UnitsRR."Default Exam Category"<>'' THEN BEGIN
        //GradeCategory:=UnitsRR."Default Exam Category";
        //END ELSE BEGIN
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(UnitG) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';//ERROR('Please note that you must specify Exam Category in Programme Setup');
        //END;
        //END;

        UnitsRegister.Reset;
        UnitsRegister.SetRange("Programme Code",UnitG);
        UnitsRegister.SetRange(Code,UnitSubj);
        if UnitsRegister.Find('-') then begin
          if UnitsRegister."Default Exam Category"<>'' then GradeCategory:=UnitsRegister."Default Exam Category";
          end;
        xGrade:='';
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
        xGrade:=Gradings.Grade;
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin
        Grade:='';
        //Remarks:='Not Done';
        end;

        //IF ( (EXAMMark=0)) THEN xGrade:='?' ELSE
        //IF ((EXAMMark>0)) THEN xGrade:='I' ELSE
        //IF ( (EXAMMark=0)) THEN xGrade:='I';
    end;


    procedure GetGradeStatus(var AvMarks: Decimal;var ProgCode: Code[20];var Unit: Code[20]) F: Boolean
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        ProgrammeRec: Record UnknownRecord61511;
        Grd: Code[80];
        GradeCategory: Code[20];
        UnitsRR: Record UnknownRecord61517;
    begin
        F:=false;

        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",ProgCode);
        UnitsRR.SetRange(UnitsRR.Code,Unit);
        UnitsRR.SetRange(UnitsRR."Stage Code",StudUnitsz.Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(ProgCode) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then GradeCategory:='DEFAULT';//ERROR('Please note that you must specify Exam Category in Programme Setup');
        end;
        end;

        UnitsRegister.Reset;
        UnitsRegister.SetRange("Programme Code",ProgCode);
        UnitsRegister.SetRange(Code,Unit);
        if UnitsRegister.Find('-') then begin
          if UnitsRegister."Default Exam Category"<>'' then GradeCategory:=UnitsRegister."Default Exam Category";
          end;


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


    procedure GetGPAPoints(Marks: Decimal;UnitG: Code[20]) xGPA: Decimal
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
    begin
        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",StudUnitsz.Programme);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code",StudUnitsz.Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(StudUnitsz.Programme) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';
        //ERROR('Please note that you must specify Exam Category in Programme Setup');
        end;
        end;

        xGPA:=0;
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
        //xGPA:=Gradings."GPA Points";
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin
        Grade:='';
        //Remarks:='Not Done';
        end;
    end;
}

