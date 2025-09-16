#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78008 "ACA-Compute Supp. Averages"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=filter(No));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                SuppExists: Boolean;
            begin
                 // "ACA-Course Registration"."Supp. Yearly Remarks":='';
                
                
                  progress.Update(1,"ACA-Course Registration"."Student No.");
                  progress.Update(2,"ACA-Course Registration".Programme);
                  progress.Update(3,"ACA-Course Registration".Semester);
                  progress.Update(4,"ACA-Course Registration".Stage);
                  Clear(YearlyReMarks);
                  Clear(TotalYearlyMarks);
                  Clear(YearlyAverage);
                  Clear(YearlyGrade);
                  Clear(YearlyFailedUnits);
                  Clear(YearlyTotalUnits);
                    Clear(SemesterReMarks);
                  Clear(TotalSemesterMarks);
                  Clear(SemesterAverage);
                  Clear(SemesterGrade);
                  Clear(SemesterFailedUnits);
                  Clear(SemesterTotalUnits);
                    Clear(CummulativeReMarks);
                  Clear(TotalCummulativeMarks);
                  Clear(CummulativeAverage);
                  Clear(CummulativeGrade);
                  Clear(CummulativeFailedUnits);
                  Clear(CummulativeTotalUnits);
                  Clear(FailedUnits);
                  Clear(StatusRemarks);
                
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Supp. Total Yearly Marks",
                "ACA-Course Registration"."Supp. Yearly Failed Units","ACA-Course Registration"."Supp. Yearly Total Units Taken",
                "ACA-Course Registration"."Supp. Total Semester Marks",
                "ACA-Course Registration"."Supp. Semester Failed Units","ACA-Course Registration"."Supp. Semester Tot Units Taken",
                "ACA-Course Registration"."Cummulative Marks","ACA-Course Registration"."Cummulative Units","ACA-Course Registration"."Supp. Yearly Weighted Total",
                "ACA-Course Registration"."Semester Weighted Total","ACA-Course Registration"."Special Exam Exists","ACA-Course Registration"."Supp. Registered","ACA-Course Registration"."Supp. Yearly Failed Courses",
                "ACA-Course Registration"."Supp. Yearly Passed Units","ACA-Course Registration"."Supp. Cummulative Units",
                "ACA-Course Registration"."Supp. Cummulative Marks","ACA-Course Registration"."Supp. Total Number of courses",
                "ACA-Course Registration"."Supp. Yearly Total Courses");
                
                //Year Computations
                YearlyFailedUnits:="ACA-Course Registration"."Supp. Yearly Failed Units";
                YearlyTotalUnits:="ACA-Course Registration"."Supp. Yearly Total Units Taken";
                Clear(YearlyCfFail);
                Clear(SemesterCfFail);
                Clear(CummCFFauil);
                if YearlyTotalUnits<>0 then begin
                YearlyCfFail:=(YearlyFailedUnits/YearlyTotalUnits)*100;
                //YearlyFailedUnits:=(YearlyFailedUnits/YearlyTotalUnits)*100;
                  end;// ELSE YearlyFailedUnits:=0;
                //YearlyCfFail:=ROUND(YearlyCfFail,0.01,'=');
                Clear(SuppCummAverage);
                SuppCummAverage:="ACA-Course Registration"."Supp. Cummulative Units"*"ACA-Course Registration"."Supp. Cummulative Marks";
                "ACA-Course Registration"."Supp. Cummulative Average":=0;
                //"ACA-Course Registration"."Supp. Cummulative Grade":=g
                if SuppCummAverage<>0 then begin
                  if "ACA-Course Registration"."Supp. Total Number of courses"<>0 then SuppCummAverage:=SuppCummAverage/"ACA-Course Registration"."Supp. Total Number of courses";
                  "ACA-Course Registration"."Supp. Cummulative Average":=SuppCummAverage;
                  end;
                
                
                "ACA-Course Registration"."Supp. Yearly CF% Failed":=YearlyCfFail;
                if "ACA-Course Registration"."Supp. Yearly Total Courses"<>0 then
                "ACA-Course Registration"."Supp. Yearly Curr. Average":=("ACA-Course Registration"."Supp. Total Yearly Marks"/"ACA-Course Registration"."Supp. Yearly Total Courses");
                if YearlyTotalUnits=0 then CurrReport.Skip;
                TotalYearlyMarks:="ACA-Course Registration"."Supp. Total Yearly Marks";
                
                if ((TotalYearlyMarks>0) and (YearlyTotalUnits>0)) then begin
                  YearlyAverage:=ROUND(TotalYearlyMarks/YearlyTotalUnits,0.01,'=');
                  end;
                  ACAProgramme.Reset;
                  ACAProgramme.SetRange(Code,"ACA-Course Registration".Programme);
                  if ACAProgramme.Find('-') then begin
                      ACAGradingSystemSetup.Reset;
                    if ACAProgramme."Exam Category"='' then
                      ACAGradingSystemSetup.SetRange(Category,'DEFAULT')
                    else ACAGradingSystemSetup.SetRange(Category,ACAProgramme."Exam Category");
                    ACAGradingSystemSetup.SetFilter("Lower Limit",'=%1|<%2',YearlyAverage,YearlyAverage);
                    ACAGradingSystemSetup.SetFilter("Upper Limit",'=%1|>%2',YearlyAverage,YearlyAverage);
                    if ACAGradingSystemSetup.Find('-') then begin
                      YearlyGrade:=ACAGradingSystemSetup.Grade;
                      end;
                    end;
                    if YearlyGrade='' then YearlyReMarks:='No marks captured';
                      Clear(LubricIdentified);
                      Clear(YearlyReMarks);
                      Customer.Reset;
                      Customer.SetRange("No.","ACA-Course Registration"."Student No.");
                      if Customer.Find('-') then begin
                        if ((Customer.Status=Customer.Status::Registration) or (Customer.Status=Customer.Status::Current)) then begin
                  Clear(LubricIdentified);
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetFilter("Manual Status Processing",'%1',false);
                if ACAResultsStatus.Find('-') then begin
                  repeat
                  begin
                  if (((YearlyCfFail>ACAResultsStatus."Minimum Units Failed") or (YearlyCfFail=ACAResultsStatus."Minimum Units Failed")) and
                    (YearlyCfFail<ACAResultsStatus."Maximum Units Failed") or (YearlyCfFail=ACAResultsStatus."Maximum Units Failed")) then begin
                      StatusRemarks:=ACAResultsStatus.Code;
                      YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
                      LubricIdentified:=true;
                    end;
                  end;
                  until ((ACAResultsStatus.Next=0) or (LubricIdentified=true))
                end;
                          end else begin
                
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetRange(Status,Customer.Status);
                if ACAResultsStatus.Find('-') then begin
                  if ((Customer.Status<>Customer.Status::Current) and (Customer.Status<>Customer.Status::Registration)) then
                  StatusRemarks:=ACAResultsStatus.Code;
                  YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
                end;
                            end;
                        end;
                //    IF YearlyGrade='E' THEN YearlyReMarks:='NOT TO PROCEED TO THE NEXT YEAR OF STUDY UNTIL (S)HE CLEARS FAILED UNITS';
                
                "ACA-Course Registration"."Supp. Transcript Remarks":=YearlyReMarks;
                "ACA-Course Registration"."Supp. Yearly Average":=YearlyAverage;
                "ACA-Course Registration"."Supp. Yearly Grade":=YearlyGrade;
                "ACA-Course Registration"."Supp. Yearly Remarks":=StatusRemarks;
                "ACA-Course Registration"."Exam Status":=StatusRemarks;
                "ACA-Course Registration"."Supp. Year Of Study":="ACA-Course Registration"."Year Of Study";
                
                /*ACAStudentUnits2.RESET;
                ACAStudentUnits2.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits2.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits2.SETRANGE(Grade,'E');
                IF ACAStudentUnits2.FIND('-') THEN BEGIN
                  REPEAT
                    BEGIN
                      IF FailedUnits='' THEN FailedUnits:=ACAStudentUnits2.Unit
                      ELSE FailedUnits:=FailedUnits+';'+ACAStudentUnits2.Unit;
                    END;
                    UNTIL ACAStudentUnits2.NEXT=0;
                  END;*/
                
                //"ACA-Course Registration"."Failed Unit":=FailedUnits;
                
                //Semester Computations
                SemesterFailedUnits:="ACA-Course Registration"."Supp. Semester Failed Units";
                SemesterTotalUnits:="ACA-Course Registration"."Supp. Semester Tot Units Taken";
                TotalSemesterMarks:="ACA-Course Registration"."Supp. Total Semester Marks";
                if SemesterTotalUnits<>0 then
                SemesterCfFail:=(SemesterFailedUnits/SemesterTotalUnits)*100;
                "ACA-Course Registration"."Supp. Semester CF% Failed":=SemesterCfFail;
                if SemesterTotalUnits<>0 then
                "ACA-Course Registration"."Supp. Semester Curr. Average":=("ACA-Course Registration"."Supp. Semester Weighted Total"/SemesterTotalUnits);
                if ((TotalSemesterMarks>0) and (SemesterTotalUnits>0)) then begin
                  SemesterAverage:=ROUND(TotalSemesterMarks/SemesterTotalUnits,0.01,'=');
                  end;
                  ACAProgramme.Reset;
                  ACAProgramme.SetRange(Code,"ACA-Course Registration".Programme);
                  if ACAProgramme.Find('-') then begin
                      ACAGradingSystemSetup.Reset;
                    if ACAProgramme."Exam Category"='' then
                      ACAGradingSystemSetup.SetRange(Category,'DEFAULT')
                    else ACAGradingSystemSetup.SetRange(Category,ACAProgramme."Exam Category");
                    ACAGradingSystemSetup.SetFilter("Lower Limit",'=%1|<%2',SemesterAverage,SemesterAverage);
                    ACAGradingSystemSetup.SetFilter("Upper Limit",'=%1|>%2',SemesterAverage,SemesterAverage);
                    if ACAGradingSystemSetup.Find('-') then begin
                      SemesterGrade:=ACAGradingSystemSetup.Grade;
                      end;
                    end;
                    if SemesterGrade='' then SemesterReMarks:='No marks captured';
                    if ((SemesterFailedUnits>0) and (SemesterFailedUnits<5)) then SemesterReMarks:='TO  PROCEED  TO NEXT YEAR OF STUDY  BUT RESIT COURSE(S) FAILED WHEN NEXT OFFERED';
                    if ((SemesterFailedUnits>0) and (SemesterFailedUnits>5)) then SemesterReMarks:='REPEAT '+Format("ACA-Course Registration"."Year Of Study");
                    if (SemesterFailedUnits=0) then SemesterReMarks:='TO  PROCEED TO NEXT YEAR OF STUDY';
                    if SemesterGrade='E' then SemesterReMarks:='FAIL'
                else  SemesterReMarks:='PASS';
                
                LubricIdentified:=false;
                    ACAResultsStatus.Reset;
                ACAResultsStatus.SetFilter("Manual Status Processing",'%1',false);
                if ACAResultsStatus.Find('-') then begin
                  repeat
                  begin
                  if (((SemesterFailedUnits>ACAResultsStatus."Minimum Units Failed") or (SemesterFailedUnits=ACAResultsStatus."Minimum Units Failed")) and
                    (SemesterFailedUnits<ACAResultsStatus."Maximum Units Failed") or (SemesterFailedUnits=ACAResultsStatus."Maximum Units Failed")) then begin
                      StatusRemarks:=ACAResultsStatus.Code;
                      LubricIdentified:=true;
                    end;
                  end;
                  until ((ACAResultsStatus.Next=0) or (LubricIdentified=true))
                end;
                
                "ACA-Course Registration"."Supp. Yearly Average":=SemesterAverage;
                "ACA-Course Registration"."Supp. Yearly Grade":=SemesterGrade;
                "ACA-Course Registration"."Supp. Semester Remarks":=StatusRemarks;
                
                
                //Cummulative Computations
                CummulativeTotalUnits:="ACA-Course Registration"."Cummulative Units";
                TotalCummulativeMarks:="ACA-Course Registration"."Cummulative Marks";
                
                if ((TotalCummulativeMarks>0) and (CummulativeTotalUnits>0)) then begin
                  CummulativeAverage:=ROUND(TotalCummulativeMarks/CummulativeTotalUnits,0.01,'=');
                  end;
                  ACAProgramme.Reset;
                  ACAProgramme.SetRange(Code,"ACA-Course Registration".Programme);
                  if ACAProgramme.Find('-') then begin
                      ACAGradingSystemSetup.Reset;
                    if ACAProgramme."Exam Category"='' then
                      ACAGradingSystemSetup.SetRange(Category,'DEFAULT')
                    else ACAGradingSystemSetup.SetRange(Category,ACAProgramme."Exam Category");
                    ACAGradingSystemSetup.SetFilter("Lower Limit",'=%1|<%2',CummulativeAverage,CummulativeAverage);
                    ACAGradingSystemSetup.SetFilter("Upper Limit",'=%1|>%2',CummulativeAverage,CummulativeAverage);
                    if ACAGradingSystemSetup.Find('-') then begin
                      CummulativeGrade:=ACAGradingSystemSetup.Grade;
                      CummulativeReMarks:=ACAGradingSystemSetup.Award;
                      end;
                    end;
                
                Clear(incompleteExists);
                  Clear(SuppExists);
                
                ACAStudentUnits2.Reset;
                ACAStudentUnits2.SetRange("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits2.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits2.SetRange(Reversed,false);
                ACAStudentUnits2.SetFilter("Supp. Cons. Mark Pref.",'%1','^');
                if ACAStudentUnits2.Find('-') then begin
                SuppExists:=true;
                  end;
                  ACAStudentUnits2.Reset;
                ACAStudentUnits2.SetRange("Student No.","ACA-Course Registration"."Student No.");
                //CAStudentUnits2.SETRANGE(Semester,"ACA-Course Registration".Semester);
                ACAStudentUnits2.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits2.SetRange(Reversed,false);
                ACAStudentUnits2.SetRange("CATs Marks Exists",false);
                ACAStudentUnits2.SetRange("EXAMs Marks Exists",false);
                if ACAStudentUnits2.Find('-') then begin
                "ACA-Course Registration"."Semester Remarks"  :='SUPP';
                  end;
                /*
                ACAStudentUnits2.RESET;
                ACAStudentUnits2.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                //CAStudentUnits2.SETRANGE(Semester,"ACA-Course Registration".Semester);
                ACAStudentUnits2.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits2.SETRANGE(Reversed,FALSE);
                ACAStudentUnits2.SETRANGE("CATs Marks Exists",FALSE);
                ACAStudentUnits2.SETRANGE("EXAMs Marks Exists",FALSE);
                IF ACAStudentUnits2.FIND('-') THEN BEGIN
                "ACA-Course Registration"."Semester Remarks"  :='SUPP';
                  END;
                
                //IF NOT "ACA-Course Registration".Reversed THEN BEGIN
                ACAStudentUnitsz.RESET;
                ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                ACAStudentUnitsz.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                //ACAStudentUnitsz.SETRANGE(Programme,"ACA-Course Registration".Programme);
                ACAStudentUnitsz.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                //ACAStudentUnitsz.SETRANGE("Academic Year","ACA-Course Registration"."Academic Year");
                ACAStudentUnitsz.SETFILTER("Supp. Cons. Mark Pref.",'%1|%2|%3','e','c','x');
                IF ACAStudentUnitsz.FIND('-') THEN BEGIN
                  "ACA-Course Registration"."Supp. Yearly Remarks":='DTSC';
                  END;
                
                
                ACAStudentUnits2.RESET;
                ACAStudentUnits2.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits2.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits2.SETRANGE(Reversed,FALSE);
                ACAStudentUnits2.SETRANGE("CATs Marks Exists",FALSE);
                //ACAStudentUnits2.SETRANGE("EXAMs Marks Exists",FALSE);
                IF ACAStudentUnits2.FIND('-') THEN BEGIN
                "ACA-Course Registration"."Supp. Yearly Remarks"  :='DTSC';
                  END;
                
                ACAStudentUnits2.RESET;
                ACAStudentUnits2.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits2.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits2.SETRANGE(Reversed,FALSE);
                //ACAStudentUnits2.SETRANGE("CATs Marks Exists",FALSE);
                ACAStudentUnits2.SETRANGE("EXAMs Marks Exists",FALSE);
                IF ACAStudentUnits2.FIND('-') THEN BEGIN
                "ACA-Course Registration"."Supp. Yearly Remarks"  :='DTSC';
                  END;
                  */
                // // // // // // ACAStudentUnitsz.RESET;
                // // // // // // ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                // // // // // // ACAStudentUnitsz.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                // // // // // // ACAStudentUnitsz.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                // // // // // // ACAStudentUnitsz.SETFILTER("Supp. Cons. Mark Pref.",'%1','x');
                // // // // // // IF NOT ACAStudentUnitsz.FIND('-') THEN BEGIN
                // // // // // // ACAStudentUnitsz.RESET;
                // // // // // // ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                // // // // // // ACAStudentUnitsz.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                // // // // // // ACAStudentUnitsz.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                // // // // // // ACAStudentUnitsz.SETFILTER("Supp. Cons. Mark Pref.",'%1','c');
                // // // // // // ACAStudentUnitsz.SETFILTER("Special Exam",'<>%1',ACAStudentUnitsz."Special Exam"::" ");
                // // // // // // IF ACAStudentUnitsz.FIND('-') THEN BEGIN
                // // // // // //  IF ACAStudentUnitsz."Special Exam"=ACAStudentUnitsz."Special Exam"::Special THEN
                // // // // // //  "ACA-Course Registration"."Supp. Yearly Remarks":='SPECIAL';
                // // // // // //  IF ACAStudentUnitsz."Special Exam"=ACAStudentUnitsz."Special Exam"::Suspension THEN
                // // // // // //  "ACA-Course Registration"."Supp. Yearly Remarks":='SUSPENDED';
                // // // // // //  END;
                // // // // // //  END;
                
                
                //END;
                
                //IF ("ACA-Course Registration"."Supp. Yearly Remarks" IN ['PASS','SUPP']) THEN BEGIN
                // // IF "ACA-Course Registration"."Special Exam Exists"=TRUE THEN BEGIN
                // //  IF (("ACA-Course Registration"."Supp. Yearly Remarks"='SUPP')) THEN
                // //    "ACA-Course Registration"."Supp. Yearly Remarks":="ACA-Course Registration"."Supp. Yearly Remarks"+'/SPECIAL'
                // //  ELSE IF NOT (("ACA-Course Registration"."Supp. Yearly Remarks"='DTSC')) THEN  "ACA-Course Registration"."Supp. Yearly Remarks":='SPECIAL';
                // //  END;
                  //END;
                
                // // // // // IF "ACA-Course Registration"."Supp. Yearly Remarks"='SPECIAL' THEN BEGIN
                // // // // //  IF SuppExists THEN
                // // // // //    "ACA-Course Registration"."Supp. Yearly Remarks":='SUPP/SPECIAL';
                // // // // // // ELSE IF NOT (("ACA-Course Registration"."Supp. Yearly Remarks"='DTSC')) THEN  "ACA-Course Registration"."Supp. Yearly Remarks":='SPECIAL';
                // // // // //  END;
                
                // // // // // //  ACAStudentUnitsz.RESET;
                // // // // // // ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                // // // // // // ACAStudentUnitsz.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                // // // // // // ACAStudentUnitsz.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                // // // // // // ACAStudentUnitsz.SETFILTER("Supp. Cons. Mark Pref.",'%1|%2','e','x');
                // // // // // // IF ACAStudentUnitsz.FIND('-') THEN BEGIN
                // // // // // // // // ACAStudentUnitsz.RESET;
                // // // // // // // // ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                // // // // // // // // ACAStudentUnitsz.SETRANGE("Student No.","ACA-Course Registration"."Student No.");
                // // // // // // // // ACAStudentUnitsz.SETRANGE("Year Of Study","ACA-Course Registration"."Year Of Study");
                // // // // // // // // ACAStudentUnitsz.SETFILTER("Supp. Cons. Mark Pref.",'%1','e');
                // // // // // // // // IF ACAStudentUnitsz.FIND('-') THEN BEGIN
                // // // // // //  "ACA-Course Registration"."Supp. Yearly Remarks":='DTSC';
                // // // // // // // END;
                // // // // // //  END;
                
                   ACAStudentUnitsz.Reset;
                   ACAStudentUnitsz.SetRange(Reversed,false);
                   ACAStudentUnitsz.SetRange("Student No.","ACA-Course Registration"."Student No.");
                   ACAStudentUnitsz.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                   ACAStudentUnitsz.SetFilter("Supp. Cons. Mark Pref.",'%1','x');
                   if ACAStudentUnitsz.Find('-') then begin
                    "ACA-Course Registration"."Supp. Yearly Remarks":='DTSC';
                    end;
                       ACAStudentUnitsz.Reset;
                   ACAStudentUnitsz.SetRange(Reversed,false);
                   ACAStudentUnitsz.SetRange("Student No.","ACA-Course Registration"."Student No.");
                   ACAStudentUnitsz.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                   ACAStudentUnitsz.SetFilter("Supp. Cons. Mark Pref.",'%1','e');
                   if ACAStudentUnitsz.Find('-') then begin
                    "ACA-Course Registration"."Supp. Yearly Remarks":='DTSC';
                    end;
                    ACAStudentUnitsz.Reset;
                   ACAStudentUnitsz.SetRange(Reversed,false);
                   ACAStudentUnitsz.SetRange("Student No.","ACA-Course Registration"."Student No.");
                   ACAStudentUnitsz.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                   ACAStudentUnitsz.SetFilter("Supp. Cons. Mark Pref.",'%1','c');
                   if ACAStudentUnitsz.Find('-') then begin
                    "ACA-Course Registration"."Supp. Yearly Remarks":='DTSC';
                    end;
                
                
                
                      Customer2.Reset;
                      Customer2.SetRange("No.","ACA-Course Registration"."Student No.");
                      if Customer2.Find('-') then begin
                        if not ((Customer2.Status=Customer2.Status::Registration)) then
                          if not ((Customer2.Status=Customer2.Status::Current)) then begin
                 // IF ((Customer2.Status<>Customer2.Status::Current) AND  (Customer2.Status<>Customer2.Status::Registration)) THEN
                      "ACA-Course Registration"."Supp. Yearly Remarks":=Format(Customer2.Status);
                  end;
                  end;
                
                "ACA-Course Registration"."Cummulative Average":=CummulativeAverage;
                "ACA-Course Registration"."Cummulative Grade":=CummulativeGrade;
                "ACA-Course Registration".Award:=CummulativeReMarks;
                
                
                ACAStudentUnits2.Reset;
                ACAStudentUnits2.SetRange("Student No.","ACA-Course Registration"."Student No.");
                ACAStudentUnits2.SetRange(Reversed,false);
                ACAStudentUnits2.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                ACAStudentUnits2.SetRange("CATs Marks Exists",false);
                ACAStudentUnits2.SetRange("EXAMs Marks Exists",false);
                if ACAStudentUnits2.Find('-') then begin
                //"ACA-Course Registration"."Supp. Yearly Remarks":='SUPP';
                  end;
                
                   "ACA-Course Registration".Modify;
                
                  // "ACA-Course Registration".VALIDATE("ACA-Course Registration".Stage);

            end;

            trigger OnPreDataItem()
            begin
                //"ACA-Exam Results".SETRANGE("ACA-Exam Results"."User Name",UserID);

                //Reset Exam Status
                ACACourseRegistration.Reset;
                ACACourseRegistration.CopyFilters("ACA-Course Registration");
                //IF ("ACA-Course Registration".GETFILTER("ACA-Course Registration"."Academic Year"))<>'' THEN
                //  ACACourseRegistration.SETRANGE("Academic Year",("ACA-Course Registration".GETFILTER("ACA-Course Registration"."Academic Year")));
                if ACACourseRegistration.Find('-') then
                  repeat
                    ACACourseRegistration."Supp. Yearly Remarks":='';
                    ACACourseRegistration.Modify;
                    until ACACourseRegistration.Next=0;
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
         progress.Open('Processing 7 of 7.\Computing Final Averages......\No.: #1########################################\Prog.: #2########################################'+
         '\Sem.: #3########################################\Stage: #4########################################');
    end;

    var
        incompleteExists: Boolean;
        ACAStudentUnitsz: Record UnknownRecord61549;
        progress: Dialog;
        ACAStudentUnits: Record UnknownRecord61549;
        TotalYearlyMarks: Decimal;
        YearlyAverage: Decimal;
        YearlyGrade: Code[2];
        YearlyFailedUnits: Integer;
        YearlyTotalUnits: Integer;
        YearlyReMarks: Code[250];
        ACAGradingSystemSetup: Record UnknownRecord61599;
        ACAProgramme: Record UnknownRecord61511;
        TotalSemesterMarks: Decimal;
        SemesterFailedUnits: Integer;
        SemesterTotalUnits: Integer;
        SemesterAverage: Decimal;
        SemesterGrade: Code[2];
        SemesterReMarks: Code[250];
        TotalCummulativeMarks: Decimal;
        CummulativeFailedUnits: Integer;
        CummulativeTotalUnits: Integer;
        CummulativeAverage: Decimal;
        CummulativeGrade: Code[2];
        CummulativeReMarks: Code[250];
        FailedUnits: Text[250];
        StatusRemarks: Text[20];
        ACAStudentUnits2: Record UnknownRecord61549;
        ACAResultsStatus: Record UnknownRecord61739;
        Customer: Record Customer;
        LubricIdentified: Boolean;
        ACACourseRegistration: Record UnknownRecord61532;
        YearlyCfFail: Decimal;
        SemesterCfFail: Decimal;
        CummCFFauil: Decimal;
        Customer2: Record Customer;
        SuppCummAverage: Decimal;
}

