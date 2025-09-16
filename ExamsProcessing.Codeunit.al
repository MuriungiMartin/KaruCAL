#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60276 "Exams Processing"
{

    trigger OnRun()
    begin
    end;

    var
        NoofCourses: Integer;
        dials: Dialog;


    procedure UpdateStudentUnits(StudNo: Code[20];Prog: Code[20];Sem: Code[20];Stag: Code[20])
    var
        ProgrammeRec: Record UnknownRecord61511;
        StudUnits: Record UnknownRecord61549;
        StudUnits2: Record UnknownRecord61549;
        EResults: Record UnknownRecord61548;
        "Units/Subj": Record UnknownRecord61517;
    begin
          StudUnits.Reset;
          StudUnits.SetRange(StudUnits."Student No.",StudNo);
          StudUnits.SetRange(StudUnits.Programme,Prog);
          StudUnits.SetRange(StudUnits.Stage,Stag);
          StudUnits.SetRange(StudUnits.Semester,Sem);
          if StudUnits.Find('-') then begin
          repeat
          "Units/Subj".Reset;
          "Units/Subj".SetRange("Units/Subj"."Programme Code",StudUnits.Programme);
          "Units/Subj".SetRange("Units/Subj".Code,StudUnits.Unit);
         // "Units/Subj".SETRANGE("Units/Subj"."Stage Code",StudUnits.Stage);
          if "Units/Subj".Find('-') then begin
          StudUnits.Description:="Units/Subj".Desription;
          StudUnits."No. Of Units":="Units/Subj"."No. Units";
        // StudUnits."No. Of Units":=3;
          end;
          StudUnits.CalcFields(StudUnits."Total Score");
          StudUnits.CalcFields(StudUnits."Ignore in Final Average");
          StudUnits."Final Score":=StudUnits."Total Score";
          StudUnits."Ignore in Cumm  Average":=StudUnits."Ignore in Final Average";

          StudUnits."Final Score":=StudUnits."Total Score";
          StudUnits."CF Score":=StudUnits."Total Score"*StudUnits."No. Of Units";
          StudUnits.Grade:=GetGrade(StudUnits."Total Score",StudUnits.Unit,StudUnits.Programme,StudUnits.Stage);
          if GetGradeStatus(StudUnits."Total Score",StudUnits.Programme,StudUnits.Unit,StudUnits.Stage)=true then
          StudUnits."Result Status":='FAIL'
          else
          StudUnits."Result Status":='PASS';

          StudUnits.Modify;

        // Update Supplimentary
         if StudUnits."Register for"=StudUnits."register for"::Supplimentary then begin
         StudUnits2.Reset;
         StudUnits2.SetRange(StudUnits2."Student No.",StudUnits."Student No.");
         StudUnits2.SetRange(StudUnits2.Unit,StudUnits.Unit);
         StudUnits2.SetRange(StudUnits2."Re-Take",false);
         StudUnits2.SetRange(StudUnits2."Supp Taken",false);
         if StudUnits2.Find('-') then begin
         repeat
         StudUnits2."Supp Taken":=true;
         StudUnits2.Modify;
         until StudUnits2.Next=0;
         end;
         end;

         EResults.Reset;
         EResults.SetRange(EResults."Student No.",StudUnits."Student No.");
         EResults.SetRange(EResults.Unit,StudUnits.Unit);
         EResults.SetRange(EResults.Programme,StudUnits.Programme);
         EResults.SetRange(EResults.Stage,StudUnits.Stage);
         EResults.SetRange(EResults.Semester,StudUnits.Semester);
         EResults.SetRange(EResults."Re-Take",false);
         if EResults.Find('-') then begin
         repeat
         EResults.CalcFields(EResults."Re-Sit");
         EResults."Re-Sited":=EResults."Re-Sit";
         EResults.Modify;
         until EResults.Next=0;
         end;

         until StudUnits.Next=0;
         end;
    end;


    procedure UpdateCourseReg(StudNo: Code[20];Prog: Code[20];Stag: Code[20];Sem: Code[20])
    var
        Creg: Record UnknownRecord61532;
        StudUnits: Record UnknownRecord61549;
        XC: Code[20];
    begin
          Creg.Reset;
          Creg.SetRange(Creg."Student No.",StudNo);
          Creg.SetRange(Creg.Programme,Prog);
          Creg.SetRange(Creg.Semester,Sem);
          Creg.SetRange(Creg.Stage,Stag);
          Creg.SetFilter(Creg."Stage Filter",Stag);
          Creg.SetFilter(Creg."Semester Filter",Sem);
          if Creg.Find('-') then begin
          repeat
          Creg.CalcFields(Creg."CF Count");
          Creg.CalcFields(Creg."CF Total Score");
          if (Creg."CF Count"<>0) and (Creg."CF Total Score"<>0) then begin
          Creg."Cumm Score":=Creg."CF Total Score"/Creg."CF Count";
          Creg."Cumm Grade":=GetGrade((Creg."CF Total Score"/Creg."CF Count"),XC,Prog,XC);
          end;
          Creg.Modify;
          until Creg.Next=0;
          end;


          Creg.Reset;
          Creg.SetRange(Creg."Student No.",StudNo);
          Creg.SetRange(Creg.Programme,Prog);
          Creg.SetFilter(Creg."Stage Filter",Stag);
          Creg.SetFilter(Creg."Semester Filter",Sem);
          if Creg.Find('-') then begin
          repeat
          Creg.CalcFields(Creg."CF Count");
          Creg.CalcFields(Creg."CF Total Score");
          Creg.CalcFields(Creg."Cum Units Done");
          Creg.CalcFields(Creg."Cum Units Passed");
          Creg.CalcFields(Creg."Cum Units Failed");
          Creg."Exam Status":='FAIL';
          if (Creg."CF Total Score">0) and (Creg."CF Count">0) then begin
          Creg."Current Cumm Score":=Creg."CF Total Score"/Creg."CF Count";
          Creg."Current Cumm Grade":=GetGrade((Creg."CF Total Score"/Creg."CF Count"),XC,Prog,XC);
          end;
          if GetGradeStatus(Creg."Current Cumm Score",Prog,XC,XC)=true then begin
          Creg."Exam Status":='FAIL'
          end else begin
          if (Creg."Cum Units Done"=Creg."Cum Units Passed") and (Creg."Cum Units Failed"=0)  then
          Creg."Exam Status":='PASS';
          end;
          Creg.Modify;
          until Creg.Next=0;
          end;
    end;


    procedure GetGrade(Marks: Decimal;UnitG: Code[20];Studprog: Code[20];StudStage: Code[20]) xGrade: Text[100]
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
        UnitsRR.SetRange(UnitsRR."Programme Code",Studprog);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code",StudStage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end;
        end;
        if GradeCategory='' then begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(Studprog) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');
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
    end;


    procedure GetGradeStatus(var AvMarks: Decimal;var ProgCode: Code[20];var Unit: Code[20];StudStage: Code[20]) F: Boolean
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
        UnitsRR.SetRange(UnitsRR."Stage Code",StudStage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(ProgCode) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;
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


    procedure UpdateGradingSystem(acadYears: Code[20];ExamCategory: Code[20])
    var
        ACAExamGraddingSetup: Record UnknownRecord61599;
        ACAExamGradingSource: Record UnknownRecord66659;
        LowerLimit: Decimal;
        UpperLimit: Decimal;
        LimitDif: Decimal;
    begin
        if Confirm('Update grades?',true)=false then Error('Cancelled!');
        Clear(ACAExamGradingSource);
        ACAExamGradingSource.Reset;
        ACAExamGradingSource.SetRange("Academic Year",acadYears);
        if ExamCategory <> '' then
        ACAExamGradingSource.SetRange("Exam Catregory",ExamCategory);
        if ACAExamGradingSource.Find('-') then ACAExamGradingSource.DeleteAll;
        Clear(NoofCourses);
          dials.Open('#1###################################################\'+
          '#2###################################################\'+
          '#3###################################################');
                  Clear(ACAExamGraddingSetup);
                  ACAExamGraddingSetup.Reset;
                    if ExamCategory <> '' then
                      ACAExamGraddingSetup.SetRange(Category,ExamCategory);
                  if ACAExamGraddingSetup.Find('-') then begin

          NoofCourses:=ACAExamGraddingSetup.Count;
                dials.Update(1,'Total Records: '+ Format(NoofCourses));
                    repeat
                        begin
                NoofCourses:=NoofCourses-1;
                 dials.Update(2,'Processing: '+ ACAExamGraddingSetup.Category+': '+ACAExamGraddingSetup.Grade);
                 dials.Update(3,'Remaining: '+ Format( Format(NoofCourses)));
                        Clear(LowerLimit);
                        Clear(UpperLimit);
                        LowerLimit:=ACAExamGraddingSetup."Lower Limit";
                        UpperLimit:=ACAExamGraddingSetup."Upper Limit"+0.01;

                       repeat
                          begin
                           if ((ACAExamGraddingSetup."Results Exists Status"=ACAExamGraddingSetup."results exists status"::"CAT Only")) then begin
                          ACAExamGradingSource.Init;
                          ACAExamGradingSource."Academic Year":=acadYears;
                          ACAExamGradingSource."Exam Catregory":=ACAExamGraddingSetup.Category;
                          ACAExamGradingSource."Total Score":=LowerLimit;
                          ACAExamGradingSource.Grade:=ACAExamGraddingSetup.Grade;
                          ACAExamGradingSource."Consolidated Prefix":=ACAExamGraddingSetup."Consolidated Prefix";
                          ACAExamGradingSource.Remarks:=ACAExamGraddingSetup.Remarks;
                          if ACAExamGraddingSetup.Failed then
                          ACAExamGradingSource.Pass:=false else ACAExamGradingSource.Pass:=true;
                          ACAExamGradingSource.Remarks:=ACAExamGraddingSetup.Remarks;
                          ACAExamGradingSource."Results Exists Status":=ACAExamGradingSource."results exists status"::"CAT Only";
                          if ACAExamGradingSource.Insert then;
                          end  else if ((ACAExamGraddingSetup."Results Exists Status"=ACAExamGraddingSetup."results exists status"::"Exam Only")) then begin
                          ACAExamGradingSource.Init;
                          ACAExamGradingSource."Academic Year":=acadYears;
                          ACAExamGradingSource."Exam Catregory":=ACAExamGraddingSetup.Category;
                          ACAExamGradingSource."Total Score":=LowerLimit;
                          ACAExamGradingSource.Grade:=ACAExamGraddingSetup.Grade;
                          ACAExamGradingSource."Consolidated Prefix":=ACAExamGraddingSetup."Consolidated Prefix";
                          ACAExamGradingSource.Remarks:=ACAExamGraddingSetup.Remarks;
                          if ACAExamGraddingSetup.Failed then
                          ACAExamGradingSource.Pass:=false else ACAExamGradingSource.Pass:=true;
                          ACAExamGradingSource.Remarks:=ACAExamGraddingSetup.Remarks;
                          ACAExamGradingSource."Results Exists Status":=ACAExamGradingSource."results exists status"::"Exam Only";
                          if ACAExamGradingSource.Insert then;
                          end else if ((ACAExamGraddingSetup."Results Exists Status"=ACAExamGraddingSetup."results exists status"::"Both Exists") or
                             (ACAExamGraddingSetup."Results Exists Status"=ACAExamGraddingSetup."results exists status"::"None Exists")) then begin
                          ACAExamGradingSource.Init;
                          ACAExamGradingSource."Academic Year":=acadYears;
                          ACAExamGradingSource."Exam Catregory":=ACAExamGraddingSetup.Category;
                          ACAExamGradingSource."Total Score":=LowerLimit;
                          ACAExamGradingSource.Grade:=ACAExamGraddingSetup.Grade;
                          ACAExamGradingSource."Consolidated Prefix":=ACAExamGraddingSetup."Consolidated Prefix";
                          ACAExamGradingSource.Remarks:=ACAExamGraddingSetup.Remarks;
                          if ACAExamGraddingSetup.Failed then
                          ACAExamGradingSource.Pass:=false else ACAExamGradingSource.Pass:=true;
                          ACAExamGradingSource.Remarks:=ACAExamGraddingSetup.Remarks;
                          ACAExamGradingSource."Results Exists Status":=ACAExamGraddingSetup."Results Exists Status";
                          if ACAExamGradingSource.Insert then;
                          end;

                       // IF ((UpperLimit-LowerLimit)>0.01) THEN BEGIN
                          LowerLimit:=LowerLimit+0.01;
                       // END;
                          end;
                            until ((LowerLimit=UpperLimit) or (LowerLimit>UpperLimit));
                        end;
                      until ACAExamGraddingSetup.Next=0;
                    end;
                dials.Close;
    end;


    procedure MarksPermissions(UserNames: Code[20])
    var
        UserSetup: Record "User Setup";
    begin
         UserSetup.Reset;
         UserSetup.SetRange("User ID",UserNames);
         if UserSetup.Find('-') then begin
         if not (UserSetup."Process Results") then Error('ACCESS DENIED!');
         end else Error('ACCESS DENIED!');
    end;
}

