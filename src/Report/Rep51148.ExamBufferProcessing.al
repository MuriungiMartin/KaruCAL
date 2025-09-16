#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51148 "Exam Buffer Processing"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61746;UnknownTable61746)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(StudNo;"ACA-Exam Results Buffer 2"."Student No.")
            {
            }
            column(AcYear;"ACA-Exam Results Buffer 2"."Academic Year")
            {
            }
            column(sem;"ACA-Exam Results Buffer 2".Semester)
            {
            }
            column(Prog;"ACA-Exam Results Buffer 2".Programme)
            {
            }
            column(unitcode;"ACA-Exam Results Buffer 2"."Unit Code")
            {
            }
            column(studName;"ACA-Exam Results Buffer 2"."Student Name")
            {
            }
            column(UnitName;"ACA-Exam Results Buffer 2"."Unit Name")
            {
            }
            column(Exam;"ACA-Exam Results Buffer 2"."Exam Score")
            {
            }
            column(CAT;"ACA-Exam Results Buffer 2"."CAT Score")
            {
            }
            column(Course_Created;"ACA-Exam Results Buffer 2"."Course Reg. Created")
            {
            }
            column(UnitCreated;"ACA-Exam Results Buffer 2"."Units Reg. Created")
            {
            }
            column(Failure_Reasom;"ACA-Exam Results Buffer 2"."Failure Reason")
            {
            }
            column(noseries;"ACA-Exam Results Buffer 2"."No. Series")
            {
            }

            trigger OnAfterGetRecord()
            var
                yos: Integer;
            begin
                //progress.UPDATE(1,"ACA-Exam Results Buffer 2"."Student No."+': '+"ACA-Exam Results Buffer 2"."Student Name");
                progress.Update(1,"ACA-Exam Results Buffer 2"."Student No.");
                progress.Update(2,"ACA-Exam Results Buffer 2"."Student Name");
                // Attempt to Pick stage & Semester
                Clear(yos);
                Clear(errorReason);
                
                if "ACA-Exam Results Buffer 2".Stage<>'' then begin
                  if Evaluate(yos,CopyStr("ACA-Exam Results Buffer 2".Stage,2,1)) then begin
                    end;
                  end;
                if "ACA-Exam Results Buffer 2".Stage='' then begin
                 // "ACA-Exam Results Buffer 2".Stage:=(GetUnitStage("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme));
                  if "ACA-Exam Results Buffer 2".Rename("ACA-Exam Results Buffer 2"."Student No.",
                    "ACA-Exam Results Buffer 2"."Academic Year","ACA-Exam Results Buffer 2".Semester,
                    "ACA-Exam Results Buffer 2".Programme,"ACA-Exam Results Buffer 2"."Unit Code",
                    (GetUnitStage("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme,"ACA-Exam Results Buffer 2"."Student No.")),
                    "ACA-Exam Results Buffer 2".Intake,"ACA-Exam Results Buffer 2"."Exam Session") then begin end;
                  if (GetUnitStage("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme,"ACA-Exam Results Buffer 2"."Student No."))='' then
                     errorReason:=errorReason+'Unit Missing;' else begin
                
                //"ACA-Exam Results Buffer 2".Stage:=(GetUnitStage("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme));
                     /*  IF "ACA-Exam Results Buffer 2".RENAME(
                "ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Academic Year",
                "ACA-Exam Results Buffer 2".Semester,"ACA-Exam Results Buffer 2".Programme,
                "ACA-Exam Results Buffer 2"."Unit Code",(GetUnitStage("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme)),
                "ACA-Exam Results Buffer 2".Intake,"ACA-Exam Results Buffer 2"."Exam Session") THEN BEGIN
                END;*/
                
                      if Evaluate(yos,CopyStr((GetUnitStage("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme,"ACA-Exam Results Buffer 2"."Student No.")),2,1)) then begin
                        end;
                       end;
                  end;
                
                if "ACA-Exam Results Buffer 2"."Unit Name"='' then begin
                  if (GetUnitName("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme))<>'' then begin
                      "ACA-Exam Results Buffer 2"."Unit Name":=(GetUnitName("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme));
                      "ACA-Exam Results Buffer 2".Modify;
                    end;
                  end;
                
                if "ACA-Exam Results Buffer 2".Semester='' then begin
                  if (GetSemester(yos,"ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Unit Code",
                    "ACA-Exam Results Buffer 2".Programme)) = '' then   errorReason:=errorReason+'Not Registered;' else begin
                //"ACA-Exam Results Buffer 2".Semester:=GetSemester(yos,"ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Unit Code",
                //    "ACA-Exam Results Buffer 2".Programme);
                     if "ACA-Exam Results Buffer 2".Rename(
                "ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Academic Year",
                (GetSemester(yos,"ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Unit Code",
                    "ACA-Exam Results Buffer 2".Programme)),"ACA-Exam Results Buffer 2".Programme,
                "ACA-Exam Results Buffer 2"."Unit Code",(GetUnitStage("ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Programme,
                "ACA-Exam Results Buffer 2"."Student No.")),
                "ACA-Exam Results Buffer 2".Intake,"ACA-Exam Results Buffer 2"."Exam Session") then begin
                end;
                   // "ACA-Exam Results Buffer 2".MODIFY;
                    end;
                  end;
                
                Clear(failed);
                //CLEAR(errorReason);
                // Check if student Exists
                if "ACA-Exam Results Buffer 2"."Academic Year"='' then errorReason:=errorReason+'No Acad. Year;';
                //IF "ACA-Exam Results Buffer 2".Semester='' THEN
                if "ACA-Exam Results Buffer 2".Programme='' then errorReason:=errorReason+'No Prog.;';
                if "ACA-Exam Results Buffer 2"."Unit Code"='' then errorReason:=errorReason+'No Unit;';
                //IF "ACA-Exam Results Buffer 2".Stage='' THEN errorReason:=errorReason+'No Stage;';
                if  errorReason<>'' then failed:=true;
                if errorReason='' then begin
                cust.Reset;
                cust.SetRange(cust."No.","ACA-Exam Results Buffer 2"."Student No.");
                if cust.Find('-') then begin
                progs.Reset;
                progs.SetRange(progs.Code,"ACA-Exam Results Buffer 2".Programme);
                if progs.Find('-') then begin
                 // Check if the stage exists
                 ProgStages.Reset;
                 ProgStages.SetRange(ProgStages."Programme Code","ACA-Exam Results Buffer 2".Programme);
                 ProgStages.SetRange(ProgStages.Code,"ACA-Exam Results Buffer 2".Stage);
                 if ProgStages.Find('-') then begin
                 // check if Unit Exists, If Not so, create one
                 units.Reset;
                 units.SetRange(units."Programme Code","ACA-Exam Results Buffer 2".Programme);
                 units.SetRange(units."Stage Code","ACA-Exam Results Buffer 2".Stage);
                 units.SetRange(units.Code,"ACA-Exam Results Buffer 2"."Unit Code");
                 if units.Find('-') then begin// uNIT eXISTS, iNSERT The Results
                  // Check if Course Reg Exists and Register Unit
                  CourseRegANDUnits("ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2".Programme,
                  "ACA-Exam Results Buffer 2".Semester,"ACA-Exam Results Buffer 2"."Academic Year",
                  "ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Stage);
                  PostExamz(
                 "ACA-Exam Results Buffer 2".Programme,"ACA-Exam Results Buffer 2".Stage,"ACA-Exam Results Buffer 2"."Unit Code",
                 "ACA-Exam Results Buffer 2".Semester,'EXAM',
                 ("ACA-Exam Results Buffer 2"."Exam Score"+"ACA-Exam Results Buffer 2"."CAT Score"),
                  "ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Academic Year"
                 );
                 end else begin // uNIT nOT eXISTS, CREATE ONE
                // Create a Unit
                CreateUnit("ACA-Exam Results Buffer 2".Programme,"ACA-Exam Results Buffer 2"."Unit Code",
                "ACA-Exam Results Buffer 2".Stage,"ACA-Exam Results Buffer 2"."Unit Name");
                // Check if Course Reg Exists and Register Unit
                  CourseRegANDUnits("ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2".Programme,
                  "ACA-Exam Results Buffer 2".Semester,"ACA-Exam Results Buffer 2"."Academic Year",
                  "ACA-Exam Results Buffer 2"."Unit Code","ACA-Exam Results Buffer 2".Stage);
                  PostExamz(
                 "ACA-Exam Results Buffer 2".Programme,"ACA-Exam Results Buffer 2".Stage,"ACA-Exam Results Buffer 2"."Unit Code",
                 "ACA-Exam Results Buffer 2".Semester,'EXAM',
                 ("ACA-Exam Results Buffer 2"."Exam Score"+"ACA-Exam Results Buffer 2"."CAT Score"),
                  "ACA-Exam Results Buffer 2"."Student No.","ACA-Exam Results Buffer 2"."Academic Year"
                 );
                
                 end;
                 end else begin // end for Prog Stages
                failed:=true;
                if errorReason='' then
                errorReason:='Stage '''+"ACA-Exam Results Buffer 2".Stage+'''Missing'
                else errorReason:=errorReason+'Stage '''+"ACA-Exam Results Buffer 2".Stage+'''Missing'
                 end;// end for Prog Stages
                end else begin // end for programme
                failed:=true;
                errorReason:=errorReason+'Programme '''+"ACA-Exam Results Buffer 2".Programme+'''Missing';
                end; // end for programme
                end // end for cust
                else begin
                failed:=true;
                errorReason:=errorReason+'Student No.:  '''+"ACA-Exam Results Buffer 2"."Student No."+': '+"ACA-Exam Results Buffer 2"."Student Name"+'''  Missing';
                end;// end for cust
                end;
                if failed=false then begin
                "ACA-Exam Results Buffer 2"."Course Reg. Created":=true;
                "ACA-Exam Results Buffer 2"."Units Reg. Created":=true;
                "ACA-Exam Results Buffer 2"."Failure Reason":='';
                "ACA-Exam Results Buffer 2".Modify;
                end else begin
                "ACA-Exam Results Buffer 2"."Course Reg. Created":=false;
                "ACA-Exam Results Buffer 2"."Units Reg. Created":=false;
                "ACA-Exam Results Buffer 2"."Failure Reason":=errorReason;
                "ACA-Exam Results Buffer 2".Modify;
                end;

            end;

            trigger OnPreDataItem()
            begin
                //"ACA-Exam Results Buffer 2".SETRANGE("ACA-Exam Results Buffer 2"."User Name",USERID);
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
         progress.Open('Processing 2 of 7.\Please Wait....\No.: #1##########################################\Name: #2#############################################');
        /* IF CONFIRM('Corect the Units?',FALSE)=TRUE THEN  BEGIN
            REPORT.RUN(70094,FALSE,FALSE);
           END;*/

    end;

    var
        failed: Boolean;
        errorReason: Code[250];
        courseReg: Record UnknownRecord61532;
        unitsReg: Record UnknownRecord61549;
        ProgStages: Record UnknownRecord61516;
        units: Record UnknownRecord61517;
        progs: Record UnknownRecord61511;
        examResults: Record UnknownRecord61548;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenSetup: Record UnknownRecord61534;
        cust: Record Customer;
        progress: Dialog;
        ACAUnitsSubjects: Record UnknownRecord61517;
        ACACourseRegistration: Record UnknownRecord61532;


    procedure CourseRegANDUnits(StudNos: Code[50];Progys: Code[50];Semz: Code[50];AcadYear: Code[50];UnitzCode: Code[50];stagez: Code[50])
    var
        RegTransID: Code[10];
    begin
          Clear(RegTransID);
            courseReg.Reset;
            courseReg.SetRange(courseReg."Student No.",StudNos);
            courseReg.SetRange(courseReg.Programme,Progys);
            courseReg.SetRange(courseReg.Semester,Semz);
            courseReg.SetRange(courseReg."Academic Year",AcadYear);
           // courseReg.SETRANGE(Stage,stagez);
            if courseReg.Find('-') then begin
               // Create A Units Registration
               unitsReg.Reset;
               unitsReg.SetRange(unitsReg.Programme,Progys);
             //  unitsReg.SETRANGE(unitsReg.Stage,stagez);
               unitsReg.SetRange(unitsReg.Unit,UnitzCode);
               unitsReg.SetRange(unitsReg."Student No.",StudNos);
               unitsReg.SetRange(unitsReg.Semester,Semz);
              // unitsReg.SETRANGE(unitsReg."Academic Year",courseReg."Academic Year");
               if not unitsReg.Find('-') then begin
              unitsReg.Init;
              unitsReg.Programme:=Progys;
              unitsReg.Stage :=stagez;
              unitsReg.Unit:=UnitzCode;
              unitsReg.Semester:=Semz;
              unitsReg."Reg. Transacton ID":=courseReg."Reg. Transacton ID";
              unitsReg."Student No.":=StudNos;
              unitsReg."Academic Year":=courseReg."Academic Year";
              unitsReg.Taken:=true;
              unitsReg.Insert;
              end;
            end else begin
              // Create A course Registration
            RegTransID:=NoSeriesMgt.GetNextNo('TRANS',0D,true);
            courseReg.Init;
            courseReg."Reg. Transacton ID":=RegTransID;
            courseReg.Programme:=Progys;
            courseReg."Student No.":=StudNos;
            courseReg.Semester:=Semz;
            courseReg."Register for":=courseReg."register for"::Stage;
            courseReg.Stage:=stagez;
            courseReg."Student Type":=courseReg."student type"::"Full Time";
            courseReg."Settlement Type":='SSP';
            courseReg."Registration Date":=Today;
            courseReg."Admission No.":=StudNos;
            courseReg."Academic Year":=AcadYear;
            courseReg.Session:= "ACA-Exam Results Buffer 2".Intake;
            courseReg.Insert;

              //Create A units Registration
               unitsReg.Reset;
               unitsReg.SetRange(unitsReg.Programme,Progys);
              // unitsReg.SETRANGE(unitsReg.Stage,stagez);
               unitsReg.SetRange(unitsReg.Unit,UnitzCode);
               unitsReg.SetRange(unitsReg."Student No.",StudNos);
               unitsReg.SetRange(unitsReg.Semester,Semz);
               //unitsReg.SETRANGE(unitsReg."Academic Year",courseReg."Academic Year");
               if not unitsReg.Find('-') then begin
              unitsReg.Init;
              unitsReg.Programme:=Progys;
              unitsReg.Stage :=stagez;
              unitsReg.Unit:=UnitzCode;
              unitsReg.Semester:=Semz;
              unitsReg."Reg. Transacton ID":=RegTransID;
              unitsReg."Student No.":=StudNos;
              unitsReg."Academic Year":=courseReg."Academic Year";
              unitsReg.Taken:=true;
              unitsReg.Insert;
              end;

            end;
          //
    end;


    procedure CreateUnit(Progys: Code[50];UnitzCode: Code[50];stages: Code[50];UnitName: Text[250])
    var
        unitsLis: Record UnknownRecord61517;
    begin
        unitsLis.Reset;
        unitsLis.SetRange(unitsLis.Code,UnitzCode);
        unitsLis.SetRange(unitsLis."Programme Code",Progys);
        unitsLis.SetRange(unitsLis."Stage Code",stages);
        if not unitsLis.Find('-') then begin
        unitsLis.Init;
        unitsLis.Code:=UnitzCode;
        unitsLis."Programme Code" :=Progys;
        unitsLis."Stage Code":=stages;
        unitsLis.Desription :=UnitName;
        unitsLis."Credit Hours":=3;
        unitsLis."No. Units":=3;
        unitsLis.Insert;
        end;
    end;


    procedure PostExamz(Progy: Code[50];stage: Code[50];unitcode: Code[50];semez: Code[50];examz: Code[50];scorez: Decimal;studNo: Code[50];AcadYear: Code[20])
    var
        examRes: Record UnknownRecord61548;
        coreg: Record UnknownRecord61532;
        ACAExamResults22: Record UnknownRecord61548;
        CatMarkz: Decimal;
    begin
        //Check if CAT Marks Exists first
        Clear(CatMarkz);
        ACAExamResults22.Reset;
        ACAExamResults22.SetRange(ACAExamResults22."Student No.",studNo);
        ACAExamResults22.SetRange(ACAExamResults22.Programme,Progy);
        //examRes.SETRANGE(examRes.Stage,stage);
        ACAExamResults22.SetRange(ACAExamResults22.Unit,unitcode);
        ACAExamResults22.SetRange(ACAExamResults22.Semester,semez);
        ACAExamResults22.SetRange(ACAExamResults22.Exam,'CAT');
        if ACAExamResults22.Find('-') then CatMarkz:=ACAExamResults22.Score;
        scorez:=scorez-CatMarkz;

        coreg.Reset;
        coreg.SetRange(coreg."Student No.",studNo);
        coreg.SetRange(coreg.Programme,Progy);
        coreg.SetRange(coreg.Semester,semez);
        //coreg.SETRANGE(coreg.Stage,stage);
        //coreg.SETRANGE(coreg."Academic Year",AcadYear);
        if coreg.Find('-') then begin
        examRes.Reset;
        examRes.SetRange(examRes."Student No.",studNo);
        examRes.SetRange(examRes.Programme,Progy);
        //examRes.SETRANGE(examRes.Stage,stage);
        examRes.SetRange(examRes.Unit,unitcode);
        examRes.SetRange(examRes.Semester,semez);
        examRes.SetRange(ExamType,'FINAL EXAM');
        //examRes.SETRANGE(examRes."Academic Year",AcadYear);
        if not examRes.Find('-') then begin
        examRes.Init;
        examRes."Student No.":=studNo;
        examRes.Programme:=Progy;
        examRes.Stage:=stage;
        examRes.Unit:=unitcode;
        examRes.Semester:=semez;
        examRes."User Name":=UserId;
        examRes.ExamType:='FINAL EXAM';
        examRes."Reg. Transaction ID":=coreg."Reg. Transacton ID";
        examRes.Score:=scorez;
        examRes.Exam:='FINAL EXAM';
        examRes."Admission No":=studNo;
        examRes."Academic Year":=AcadYear;
        examRes.Insert;
        end else begin
        // // examRes.INIT;
        // // examRes."Student No.":=studNo;
        // // examRes.Programme:=Progy;
        // // examRes.Stage:=stage;
        // // examRes.Unit:=unitcode;
        // // examRes.Semester:=semez;
        // // examRes."User Name":=USERID;
        // // examRes.ExamType:='FINAL EXAM';
        // // examRes."Reg. Transaction ID":=coreg."Reg. Transacton ID";
        examRes.Score:=scorez;
        examRes.Exam:='FINAL EXAM';
        // // examRes."Admission No":=studNo;
        examRes."Academic Year":=AcadYear;
        examRes.Modify;
          end;
        end;
    end;

    local procedure GetSemester(YearOfStudy: Integer;StudNo: Code[20];UnitCode: Code[20];Prog: Code[20]) Semz: Code[20]
    var
        ACAStudentUnits: Record UnknownRecord61549;
    begin
        ACAStudentUnits.Reset;
        ACAStudentUnits.SetRange("Student No.",StudNo);
        ACAStudentUnits.SetRange(Unit,UnitCode);
        ACAStudentUnits.SetRange(Reversed,false);
        if not (ACAStudentUnits.Find('-')) then begin
        ACAUnitsSubjects.Reset;
        ACAUnitsSubjects.SetRange(Code,UnitCode);
        ACAUnitsSubjects.SetRange("Programme Code",Prog);
        if ACAUnitsSubjects.Find('-') then begin
            ACACourseRegistration.Reset;
           ACACourseRegistration.SetRange("Student No.",StudNo);
           ACACourseRegistration.SetRange(Stage,ACAUnitsSubjects."Stage Code");
           ACACourseRegistration.SetRange(Programme,Prog);
           ACACourseRegistration.SetRange("Year Of Study",YearOfStudy);
           ACACourseRegistration.SetFilter(Reversed,'=%1',false);
           if ACACourseRegistration.Find('-') then begin
             if ACACourseRegistration.Semester<>'' then Semz:=ACACourseRegistration.Semester;
             end else begin
                   ACACourseRegistration.Reset;
           ACACourseRegistration.SetRange("Student No.",StudNo);
           ACACourseRegistration.SetRange(Programme,Prog);
           ACACourseRegistration.SetRange("Year Of Study",YearOfStudy);
           ACACourseRegistration.SetFilter(Reversed,'=%1',false);
           if ACACourseRegistration.Find('+') then begin
              if ACACourseRegistration.Semester<>'' then Semz:=ACACourseRegistration.Semester;
             end;
               end;

          end;
          end else begin
            Semz:=ACAStudentUnits.Semester;
            end;
    end;

    local procedure GetUnitStage(UnitCodezz: Code[20];Progzz: Code[20];StudNo: Code[20]) StageCode: Code[20]
    var
        ACAStudentUnits: Record UnknownRecord61549;
    begin
        ACAStudentUnits.Reset;
        ACAStudentUnits.SetRange("Student No.",StudNo);
        ACAStudentUnits.SetRange(Unit,UnitCodezz);
        ACAStudentUnits.SetRange(Reversed,false);
        if not (ACAStudentUnits.Find('-')) then begin
        ACAUnitsSubjects.Reset;
        ACAUnitsSubjects.SetRange(Code,UnitCodezz);
        ACAUnitsSubjects.SetRange("Programme Code",Progzz);
        if ACAUnitsSubjects.Find('-') then begin
          StageCode:=ACAUnitsSubjects."Stage Code";
          end;
          end else begin
            StageCode:=ACAStudentUnits.Stage;
            end;
    end;

    local procedure GetUnitName(UnitCode: Code[20];Prog: Code[20]) UntName: Code[150]
    begin
        ACAUnitsSubjects.Reset;
        ACAUnitsSubjects.SetRange(Code,UnitCode);
        ACAUnitsSubjects.SetRange("Programme Code",Prog);
        if ACAUnitsSubjects.Find('-') then begin
          UntName:=ACAUnitsSubjects.Desription;
          end;
    end;
}

