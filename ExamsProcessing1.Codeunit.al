#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60110 "Exams Processing1"
{

    trigger OnRun()
    begin
    end;

    var
        EResults: Record UnknownRecord61548;


    procedure UpdateStudentUnits(StudNo: Code[20];Prog: Code[20];Sem: Code[50];Stag: Code[20])
    var
        ProgrammeRec: Record UnknownRecord61511;
        StudUnits: Record UnknownRecord61549;
        StudUnits2: Record UnknownRecord61549;
        EResults: Record UnknownRecord61548;
        "Units/Subj": Record UnknownRecord61517;
    begin
          EResults.Reset;
          EResults.SetRange(EResults."Student No.",StudNo);
          EResults.SetRange(EResults.Programme,Prog);
          EResults.SetRange(EResults.Stage,Stag);
          EResults.SetRange(EResults.Semester,Sem);
          if EResults.Find('-') then begin
          repeat
          EResults.Contribution:=EResults.Score;
          EResults.Modify;
          until EResults.Next=0;
          end;

          ProgrammeRec.Get(Prog);
          ProgrammeRec.TestField(ProgrammeRec."Exam Category");
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
          "Units/Subj".SetRange("Units/Subj"."Stage Code",StudUnits.Stage);
          "Units/Subj".SetRange("Units/Subj"."Old Unit",StudUnits."Old Unit");
          if "Units/Subj".Find('-') then begin
          StudUnits.Description:="Units/Subj".Desription;
          StudUnits."No. Of Units":="Units/Subj"."No. Units";
          StudUnits."Attachment Unit":="Units/Subj".Attachment;
          if "Units/Subj"."No. Units"=0 then
          StudUnits."No. Of Units":=1;
          end;
          StudUnits.CalcFields(StudUnits."Total Score");
          StudUnits.CalcFields(StudUnits."Exam Marks");
          StudUnits.CalcFields(StudUnits."Ignore in Final Average");
          StudUnits."Final Score":=StudUnits."Total Score";
          StudUnits."Ignore in Cumm  Average":=StudUnits."Ignore in Final Average";

          StudUnits."Final Score":=StudUnits."Total Score";
          StudUnits."CF Score":=StudUnits."Total Score"*StudUnits."No. Of Units";
          StudUnits.Grade:=GetGrade(StudUnits."Total Score",StudUnits.Unit,StudUnits.Programme,StudUnits.Stage);
          if GetGradeStatus(StudUnits."Total Score",StudUnits.Programme,StudUnits.Unit,StudUnits.Stage)=true then begin
          StudUnits."Result Status":='FAIL';
          StudUnits.Failed:=true;
          end else begin
          StudUnits.Failed:=false;
          StudUnits."Result Status":='PASS';
          end;
          if StudUnits."Final Score"=0 then begin
          StudUnits."Result Status":='FAIL';
          StudUnits.Failed:=true;
          end;
          if (StudUnits."Final Score"<>0) and (StudUnits."Exam Marks"=0) then begin
          StudUnits."Result Status":='SPECIAL';
          StudUnits.Failed:=true;
          end;

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


    procedure UpdateCourseReg(StudNo: Code[20];Prog: Code[20];Stag: Code[100];Sem: Code[100])
    var
        Creg: Record UnknownRecord61532;
        StudUnits: Record UnknownRecord61549;
        XC: Code[20];
        SemRec: Record UnknownRecord61692;
        Spec: Boolean;
        CReg2: Record UnknownRecord61532;
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
          if (Creg."CF Total Score">0) and (Creg."CF Count">0) then begin
          Creg."Cumm Score":=Creg."CF Total Score"/Creg."CF Count";
          Creg."Cumm Grade":=GetGrade((Creg."CF Total Score"/Creg."CF Count"),XC,Prog,XC);
          Creg.Modify;
          end;
          until Creg.Next=0;
          end;

          Creg.Reset;
          Creg.SetRange(Creg."Student No.",StudNo);
          Creg.SetRange(Creg.Programme,Prog);
         // Creg.SETRANGE(Creg.Stage,Stag);
         // Creg.SETRANGE(Creg.Semester,Sem);
          //Creg.SETFILTER(Creg."Stage Filter",Stag);
          Creg.SetFilter(Creg."Semester Filter",Sem);
          if Creg.Find('-') then begin
          repeat
          Creg.CalcFields(Creg."CF Count");
          Creg.CalcFields(Creg."CF Total Score");
          Creg.CalcFields(Creg."Cum Units Done");
          Creg.CalcFields(Creg."Cum Units Passed");
          Creg.CalcFields(Creg."Cum Units Failed");
          Creg.CalcFields(Creg."Manual Exam Status");
          Spec:=false;
          if Creg."Manual Exam Status"=false then begin
          Creg."Exam Status":='FAIL';
          Creg."General Remark":='';
          if (Creg."CF Total Score">0) and (Creg."CF Count">0) then begin

          Creg."Current Cumm Score":=Creg."CF Total Score"/Creg."CF Count";
          Creg."Current Cumm Grade":=GetGrade((Creg."CF Total Score"/Creg."CF Count"),XC,Prog,XC);
          Creg.Award:=GetAward((Creg."CF Total Score"/Creg."CF Count"),XC,Prog,XC);
          end;
          if GetGradeStatus(Creg."Current Cumm Score",Prog,XC,XC)=true then begin
          Creg."Exam Status":='SUPP'
          end else begin
          if (Creg."Cum Units Done"=Creg."Cum Units Passed")  then
          Creg."Exam Status":='PASS'

          end;
          if (Creg."Cum Units Done"=Creg."Cum Units Passed")  then begin
          Creg."Exam Status":='PASS'
          end;

          if (Creg."Cum Units Done"<>0) and (Creg."Cum Units Passed"<>0) then begin
          Creg."Yearly Average":= ROUND(((Creg."Cum Units Done"-(Creg."Cum Units Passed"+Creg."Total Yearly Marks"))/Creg."Cum Units Done")*100,1);

          if (ROUND(((Creg."Cum Units Done"-Creg."Cum Units Passed")/Creg."Cum Units Done")*100,1) <25) then begin
            Creg."Exam Status":='SUPP';
            end;

          if (ROUND(((Creg."Cum Units Done"-Creg."Cum Units Passed")/Creg."Cum Units Done")*100,1) >25) and
          (ROUND(((Creg."Cum Units Done"-Creg."Cum Units Passed")/Creg."Cum Units Done")*100,1)<50) then begin
            Creg."Exam Status":='REPEAT';
          end;
          if (ROUND(((Creg."Cum Units Done"-Creg."Cum Units Passed")/Creg."Cum Units Done")*100,1) >50)  then begin
          Creg."Exam Status":='DISCONTINUED';
          end;
          end;
          if Creg."Cum Units Passed"=0 then
          Creg."Exam Status":='DISCONTINUED';

        // Mark Marks with Missing Exam Marks as Special
          StudUnits.Reset;
          StudUnits.SetRange(StudUnits."Student No.",Creg."Student No.");
          StudUnits.SetFilter(StudUnits.Stage,Stag);
          StudUnits.SetFilter(StudUnits.Semester,Sem);
          if StudUnits.Find('-') then begin
          repeat
          StudUnits.CalcFields(StudUnits."Exam Marks");
          StudUnits.CalcFields(StudUnits."CAT Total Marks");
          StudUnits.CalcFields(StudUnits."Total Score");
          if (StudUnits."Total Score")<>0 then begin
          if StudUnits."Exam Marks"=0 then begin
          if SemRec.Get(Creg.Semester) then
          if SemRec."BackLog Marks"=false then begin
          Creg."Exam Status":='SPECIAL';


          if StudUnits."CAT Total Marks"=0 then begin
            Creg."Exam Status":='DTSC';
          Creg."General Remark":='Missing Exam Marks';
          Spec:=true;
          end;
          end;
          end;
          end;
          until StudUnits.Next=0;
          end;
          Creg.Modify;
          end;
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


    procedure GetAward(Marks: Decimal;UnitG: Code[20];Studprog: Code[20];StudStage: Code[20]) xAward: Text[200]
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
        xAward:='';
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
        xAward:=Gradings.Remarks;
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


    procedure UpdateCummStatus(StudNo: Code[20];Prog: Code[20];Stag: Code[50];Sem: Code[50])
    var
        Creg: Record UnknownRecord61532;
        CX: Code[20];
        Sc: Decimal;
        StudUnits: Record UnknownRecord61549;
        ProgRec: Record UnknownRecord61511;
    begin
        
         // ERROR(FORMAT(StudNo+' '+Prog+' '+Stag+' '+Sem));
          if ProgRec.Get(Prog) then;
          Creg.Reset;
          Creg.SetRange(Creg."Student No.",StudNo);
          Creg.SetRange(Creg.Programme,Prog);
          Creg.SetFilter(Creg."Stage Filter",Stag);
          Creg.SetFilter(Creg."Semester Filter",Sem);
          if Creg.Find('-') then begin
          repeat
          Creg.CalcFields(Creg."CF Count");
          Creg.CalcFields(Creg."CF Total Score");
          Creg.CalcFields(Creg."Sem FAIL Count");
          Creg.CalcFields(Creg."Cum Units Done");
          Creg.CalcFields(Creg."Cum Units Passed");
          Creg.CalcFields(Creg."Cum Units Failed");
          Creg.CalcFields(Creg."Manual Exam Status");
          if Creg."Cum Units Done"=Creg."Cum Units Passed" then
             Creg."Cumm Status":='PASS'
          else
            Creg."Cumm Status":='FAIL';
        
          if Creg."Cum Units Done"=0 then
            Creg."Cumm Status":='FAIL';
        
           /*
           IF (Creg."CF Total Score"<>0) AND (Creg."CF Count"<>0) THEN BEGIN
             Sc:=ROUND(Creg."CF Total Score"/Creg."CF Count",0.5);
             Creg."Cumm Score":=ROUND(Creg."CF Total Score"/Creg."CF Count",0.5);
             IF GetGradeStatus(Sc,Prog,CX,CX) =TRUE THEN
              Creg."Cumm Status":='FAIL';
              IF Creg."Cum Units Done">0 THEN BEGIN
               IF Creg."Cum Units Failed"> (Creg."Cum Units Done"/2) THEN
               Creg."Cumm Status":='REPEAT';
        
               IF Creg."Cum Units Failed">(ProgRec."Min Pass Units") THEN
               Creg."Cumm Status":='DISCONTINUE';
               END;
           END;
           IF (Creg."CF Total Score"=0) OR (Creg."Cum Units Done"=0) THEN
             Creg."Cumm Status":='DISCONTINUE';
        */
          if (Creg."Cum Units Done"<>0) and (Creg."Cum Units Passed"<>0) then begin
          if (ROUND(((Creg."Cum Units Done"-Creg."Cum Units Passed")/Creg."Cum Units Done")*100,1) >25) and
          (ROUND(((Creg."Cum Units Done"-Creg."Cum Units Passed")/Creg."Cum Units Done")*100,1)<50) then begin
            Creg."Cumm Status":='REPEAT';
          end;
          if (ROUND(((Creg."Cum Units Done"-Creg."Cum Units Passed")/Creg."Cum Units Done")*100,1) >50)  then begin
          Creg."Cumm Status":='DISCONTINUED';
          end;
          end;
          if Creg."Cum Units Passed"=0 then
          Creg."Cumm Status":='DISCONTINUED';
        
        
           if Creg."Manual Exam Status"=false then  begin// Modify only if Status is Auto
           Creg.Modify;
        
           StudUnits.Reset;
           StudUnits.SetRange(StudUnits."Student No.",StudNo);
           StudUnits.SetRange(StudUnits.Failed,true);
           StudUnits.SetRange(StudUnits."Supp Taken",false);
           StudUnits.SetRange(StudUnits.Programme,Prog);
           StudUnits.SetFilter(StudUnits."Stage Filter",Stag);
           StudUnits.SetFilter(StudUnits."Semester Filter",Sem);
           if StudUnits.Find('-') then begin
           repeat
           StudUnits."Result Status":=Creg."Cumm Status";
           //StudUnits.MODIFY;
           until StudUnits.Next=0;
           end;
           end;
        
          until Creg.Next=0;
          end;
         // Manual Status
          Creg.Reset;
          Creg.SetRange(Creg."Student No.",StudNo);
          Creg.SetRange(Creg.Programme,Prog);
          Creg.SetRange(Creg."Manual Exam Status",true);
          Creg.SetFilter(Creg.Stage,Stag);
          Creg.SetFilter(Creg.Semester,Sem);
          if Creg.Find('-') then begin
          repeat
           Creg."Cumm Status":=Creg."Exam Status";
           Creg.Modify;
          until Creg.Next=0;
          end;

    end;
}

