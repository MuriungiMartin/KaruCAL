#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 77701 "ACA-Compute Yearly Averages"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Coregs;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=filter(No));
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                SuppExists: Boolean;
            begin
                 // Coregs."Yearly Remarks":='';
                  progress.Update(1,Coregs."Student No.");
                  progress.Update(2,Coregs.Programme);
                  progress.Update(3,Coregs.Semester);
                  progress.Update(4,Coregs.Stage);
                  Clear(YearlyReMarks);
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
                
                Coregs.CalcFields(Coregs."Total Yearly Marks",
                Coregs."Yearly Failed Units",Coregs."Yearly Total Units Taken",
                Coregs."Total Semester Marks",
                Coregs."Semester Failed Units",Coregs."Semester Total Units Taken",
                Coregs."Cummulative Marks",Coregs."Cummulative Units",Coregs."Yearly Weighted Total",
                Coregs."Semester Weighted Total",Coregs."Special Exam Exists");
                
                //Year Computations
                YearlyFailedUnits:=Coregs."Yearly Failed Units";
                YearlyTotalUnits:=Coregs."Yearly Total Units Taken";
                Clear(YearlyCfFail);
                Clear(SemesterCfFail);
                Clear(CummCFFauil);
                if YearlyTotalUnits<>0 then begin
                YearlyCfFail:=ROUND(((YearlyFailedUnits/YearlyTotalUnits)*100),0.01,'=');;
                //YearlyFailedUnits:=(YearlyFailedUnits/YearlyTotalUnits)*100;
                  end;// ELSE YearlyFailedUnits:=0;
                //YearlyCfFail:=ROUND(YearlyCfFail,0.01,'=');
                
                
                
                Coregs."Yearly CF% Failed":=YearlyCfFail;
                if YearlyTotalUnits<>0 then
                Coregs."Yearly Curr. Average":=ROUND((Coregs."Yearly Weighted Total"/Coregs."Yearly Total Units Taken"),0.01,'=');
                if YearlyTotalUnits=0 then CurrReport.Skip;
                TotalYearlyMarks:=Coregs."Total Yearly Marks";
                
                if ((TotalYearlyMarks>0) and (YearlyTotalUnits>0)) then begin
                  YearlyAverage:=ROUND(TotalYearlyMarks/YearlyTotalUnits,0.01,'=');
                  end;
                  ACAProgramme.Reset;
                  ACAProgramme.SetRange(Code,Coregs.Programme);
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
                        if ((Coregs."Semester Student Status"=Coregs."semester student status"::Registration) or (Coregs."Semester Student Status"=Coregs."semester student status"::Current)) then begin
                  Clear(LubricIdentified);
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetFilter("Manual Status Processing",'%1',false);
                ACAResultsStatus.SetFilter("Minimum Units Failed",'<%1|=%2',YearlyCfFail,YearlyCfFail);
                ACAResultsStatus.SetFilter("Maximum Units Failed",'>%1|=%2',YearlyCfFail,YearlyCfFail);
                if ACAResultsStatus.Find('-') then begin
                 // REPEAT
                  begin
                 // IF (((YearlyCfFail>ACAResultsStatus."Minimum Units Failed") OR (YearlyCfFail=ACAResultsStatus."Minimum Units Failed")) AND
                 //   (YearlyCfFail<ACAResultsStatus."Maximum Units Failed") OR (YearlyCfFail=ACAResultsStatus."Maximum Units Failed")) THEN BEGIN
                      StatusRemarks:=ACAResultsStatus.Code;
                      YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
                      LubricIdentified:=true;
                   // END;
                  end;
                 // UNTIL ((ACAResultsStatus.NEXT=0) OR (LubricIdentified=TRUE))
                end;
                          end else begin
                
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetRange(Status,Coregs."Semester Student Status");
                if ACAResultsStatus.Find('-') then begin
                
                  StatusRemarks:=ACAResultsStatus.Code;
                  YearlyReMarks:=ACAResultsStatus."Transcript Remarks";
                end;
                            end;
                //    IF YearlyGrade='E' THEN YearlyReMarks:='NOT TO PROCEED TO THE NEXT YEAR OF STUDY UNTIL (S)HE CLEARS FAILED UNITS';
                
                Coregs."Transcript Remarks":=YearlyReMarks;
                Coregs."Yearly Average":=YearlyAverage;
                Coregs."Yearly Grade":=YearlyGrade;
                Coregs."Yearly Remarks":=StatusRemarks;
                Coregs."Exam Status":=StatusRemarks;
                
                
                ACAStudentUnits2.Reset;
                ACAStudentUnits2.SetRange("Student No.",Coregs."Student No.");
                ACAStudentUnits2.SetRange("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnits2.SetRange(Grade,'E');
                if ACAStudentUnits2.Find('-') then begin
                  repeat
                    begin
                      if FailedUnits='' then FailedUnits:=ACAStudentUnits2.Unit
                      else FailedUnits:=FailedUnits+';'+ACAStudentUnits2.Unit;
                    end;
                    until ACAStudentUnits2.Next=0;
                  end;
                
                Coregs."Failed Unit":=FailedUnits;
                
                //Semester Computations
                SemesterFailedUnits:=Coregs."Semester Failed Units";
                SemesterTotalUnits:=Coregs."Semester Total Units Taken";
                TotalSemesterMarks:=Coregs."Total Semester Marks";
                if SemesterTotalUnits<>0 then
                SemesterCfFail:=ROUND(((SemesterFailedUnits/SemesterTotalUnits)*100),0.01,'=');;
                Coregs."Semester CF% Failed":=SemesterCfFail;
                if SemesterTotalUnits<>0 then
                Coregs."Semester Curr. Average":=ROUND((Coregs."Semester Weighted Total"/SemesterTotalUnits),0.01,'=');;
                if ((TotalSemesterMarks>0) and (SemesterTotalUnits>0)) then begin
                  SemesterAverage:=ROUND(TotalSemesterMarks/SemesterTotalUnits,0.01,'=');
                  end;
                  ACAProgramme.Reset;
                  ACAProgramme.SetRange(Code,Coregs.Programme);
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
                    if ((SemesterFailedUnits>0) and (SemesterFailedUnits>5)) then SemesterReMarks:='REPEAT '+Format(Coregs."Year Of Study");
                    if (SemesterFailedUnits=0) then SemesterReMarks:='TO  PROCEED TO NEXT YEAR OF STUDY';
                    if SemesterGrade='E' then SemesterReMarks:='FAIL'
                else  SemesterReMarks:='PASS';
                
                LubricIdentified:=false;
                    ACAResultsStatus.Reset;
                ACAResultsStatus.SetFilter("Manual Status Processing",'%1',false);
                ACAResultsStatus.SetFilter("Minimum Units Failed",'<%1|=%2',SemesterFailedUnits,SemesterFailedUnits);
                ACAResultsStatus.SetFilter("Maximum Units Failed",'>%1|=%2',SemesterFailedUnits,SemesterFailedUnits);
                if ACAResultsStatus.Find('-') then begin
                 // REPEAT
                  begin
                //  IF (((SemesterFailedUnits>ACAResultsStatus."Minimum Units Failed") OR (SemesterFailedUnits=ACAResultsStatus."Minimum Units Failed")) AND
                //    (SemesterFailedUnits<ACAResultsStatus."Maximum Units Failed") OR (SemesterFailedUnits=ACAResultsStatus."Maximum Units Failed")) THEN BEGIN
                      StatusRemarks:=ACAResultsStatus.Code;
                      LubricIdentified:=true;
                  //  END;
                  end;
                 // UNTIL ((ACAResultsStatus.NEXT=0) OR (LubricIdentified=TRUE))
                end;
                
                Coregs."Semester Average":=SemesterAverage;
                Coregs."Semester Grade":=SemesterGrade;
                Coregs."Semester Remarks":=StatusRemarks;
                
                
                //Cummulative Computations
                CummulativeTotalUnits:=Coregs."Cummulative Units";
                TotalCummulativeMarks:=Coregs."Cummulative Marks";
                
                if ((TotalCummulativeMarks>0) and (CummulativeTotalUnits>0)) then begin
                  CummulativeAverage:=ROUND(TotalCummulativeMarks/CummulativeTotalUnits,0.01,'=');
                  end;
                  ACAProgramme.Reset;
                  ACAProgramme.SetRange(Code,Coregs.Programme);
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
                ACAStudentUnits2.SetRange("Student No.",Coregs."Student No.");
                ACAStudentUnits2.SetRange("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnits2.SetRange(Reversed,false);
                ACAStudentUnits2.SetFilter("Consolidated Mark Pref.",'%1','^');
                ACAStudentUnits2.SetFilter(Unit,'<>%1','');
                if ACAStudentUnits2.Find('-') then begin
                SuppExists:=true;
                  end;
                
                ACAStudentUnits2.Reset;
                ACAStudentUnits2.SetRange("Student No.",Coregs."Student No.");
                //CAStudentUnits2.SETRANGE(Semester,Coregs.Semester);
                ACAStudentUnits2.SetRange("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnits2.SetRange(Reversed,false);
                ACAStudentUnits2.SetRange("CATs Marks Exists",false);
                ACAStudentUnits2.SetRange("EXAMs Marks Exists",false);
                ACAStudentUnits2.SetFilter(Unit,'<>%1','');
                if ACAStudentUnits2.Find('-') then begin
                Coregs."Semester Remarks"  :='SUPP';
                  end;
                
                //IF NOT Coregs.Reversed THEN BEGIN
                ACAStudentUnitsz.Reset;
                ACAStudentUnitsz.SetRange(Reversed,false);
                ACAStudentUnitsz.SetRange("Student No.",Coregs."Student No.");
                //ACAStudentUnitsz.SETRANGE(Programme,Coregs.Programme);
                ACAStudentUnitsz.SetRange("Year Of Study",Coregs."Year Of Study");
                //ACAStudentUnitsz.SETRANGE("Academic Year",Coregs."Academic Year");
                ACAStudentUnitsz.SetFilter("Consolidated Mark Pref.",'%1|%2|%3','e','c','x');
                ACAStudentUnitsz.SetFilter(Unit,'<>%1','');
                if ACAStudentUnitsz.Find('-') then begin
                  Coregs."Yearly Remarks":='DTSC';
                  end;
                
                
                ACAStudentUnits2.Reset;
                ACAStudentUnits2.SetRange("Student No.",Coregs."Student No.");
                ACAStudentUnits2.SetRange("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnits2.SetRange(Reversed,false);
                ACAStudentUnits2.SetRange("CATs Marks Exists",false);
                ACAStudentUnits2.SetFilter(Unit,'<>%1','');
                //ACAStudentUnits2.SETRANGE("EXAMs Marks Exists",FALSE);
                if ACAStudentUnits2.Find('-') then begin
                Coregs."Yearly Remarks"  :='DTSC';
                  end;
                
                ACAStudentUnits2.Reset;
                ACAStudentUnits2.SetRange("Student No.",Coregs."Student No.");
                ACAStudentUnits2.SetRange("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnits2.SetRange(Reversed,false);
                ACAStudentUnits2.SetFilter(Unit,'<>%1','');
                //ACAStudentUnits2.SETRANGE("CATs Marks Exists",FALSE);
                ACAStudentUnits2.SetRange("EXAMs Marks Exists",false);
                if ACAStudentUnits2.Find('-') then begin
                Coregs."Yearly Remarks"  :='DTSC';
                  end;
                
                /*ACAStudentUnitsz.RESET;
                ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                ACAStudentUnitsz.SETRANGE("Student No.",Coregs."Student No.");
                ACAStudentUnitsz.SETRANGE("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnitsz.SETFILTER("Consolidated Mark Pref.",'%1','x');
                ACAStudentUnitsz.SETFILTER(Unit,'<>%1','');
                IF NOT ACAStudentUnitsz.FIND('-') THEN BEGIN
                ACAStudentUnitsz.RESET;
                ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                ACAStudentUnitsz.SETRANGE("Student No.",Coregs."Student No.");
                ACAStudentUnitsz.SETRANGE("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnitsz.SETFILTER("Consolidated Mark Pref.",'%1','c');
                ACAStudentUnitsz.SETFILTER("Special Exam",'<>%1',ACAStudentUnitsz."Special Exam"::" ");
                IF ACAStudentUnitsz.FIND('-') THEN BEGIN
                  IF ACAStudentUnitsz."Special Exam"=ACAStudentUnitsz."Special Exam"::Special THEN
                  Coregs."Yearly Remarks":='SPECIAL';
                  IF ACAStudentUnitsz."Special Exam"=ACAStudentUnitsz."Special Exam"::Suspension THEN
                  Coregs."Yearly Remarks":='SUSPENDED';
                  END;
                  END;*/
                
                
                //END;
                
                //IF (Coregs."Yearly Remarks" IN ['PASS','SUPP']) THEN BEGIN
                // // IF Coregs."Special Exam Exists"=TRUE THEN BEGIN
                // //  IF ((Coregs."Yearly Remarks"='SUPP')) THEN
                // //    Coregs."Yearly Remarks":=Coregs."Yearly Remarks"+'/SPECIAL'
                // //  ELSE IF NOT ((Coregs."Yearly Remarks"='DTSC')) THEN  Coregs."Yearly Remarks":='SPECIAL';
                // //  END;
                  //END;
                
                if Coregs."Yearly Remarks"='SPECIAL' then begin
                  if SuppExists then
                    Coregs."Yearly Remarks":='SUPP/SPECIAL';
                 // ELSE IF NOT ((Coregs."Yearly Remarks"='DTSC')) THEN  Coregs."Yearly Remarks":='SPECIAL';
                  end;
                
                  ACAStudentUnitsz.Reset;
                ACAStudentUnitsz.SetRange(Reversed,false);
                ACAStudentUnitsz.SetRange("Student No.",Coregs."Student No.");
                ACAStudentUnitsz.SetRange("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnitsz.SetFilter("Consolidated Mark Pref.",'%1|%2','e','x');
                ACAStudentUnitsz.SetFilter(Unit,'<>%1','');
                if ACAStudentUnitsz.Find('-') then begin
                // // ACAStudentUnitsz.RESET;
                // // ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                // // ACAStudentUnitsz.SETRANGE("Student No.",Coregs."Student No.");
                // // ACAStudentUnitsz.SETRANGE("Year Of Study",Coregs."Year Of Study");
                // // ACAStudentUnitsz.SETFILTER("Consolidated Mark Pref.",'%1','e');
                // // IF ACAStudentUnitsz.FIND('-') THEN BEGIN
                  Coregs."Yearly Remarks":='DTSC';
                 // END;
                  end;
                
                // // // ACAStudentUnitsz.RESET;
                // // // ACAStudentUnitsz.SETRANGE(Reversed,FALSE);
                // // // ACAStudentUnitsz.SETRANGE("Student No.",Coregs."Student No.");
                // // // ACAStudentUnitsz.SETRANGE("Year Of Study",Coregs."Year Of Study");
                // // // ACAStudentUnitsz.SETFILTER("Consolidated Mark Pref.",'%1','x');
                // // // IF ACAStudentUnitsz.FIND('-') THEN BEGIN
                // // //  Coregs."Yearly Remarks":='DTSC';
                // // //  END;
                
                
                // // //      Customer2.RESET;
                // // //      Customer2.SETRANGE("No.",Coregs."Student No.");
                // // //      IF Customer2.FIND('-') THEN BEGIN
                // // //        IF NOT ((Customer2.Status=Customer2.Status::Registration)) THEN
                // // //          IF NOT ((Customer2.Status=Customer2.Status::Current)) THEN BEGIN
                // // // // IF ((Customer2.Status<>Customer2.Status::Current) AND  (Customer2.Status<>Customer2.Status::Registration)) THEN
                // // //      Coregs."Yearly Remarks":=FORMAT(Customer2.Status);
                // // //  END;
                // // //  END;
                
                Coregs."Cummulative Average":=CummulativeAverage;
                Coregs."Cummulative Grade":=CummulativeGrade;
                Coregs.Award:=CummulativeReMarks;
                
                /*
                ACAStudentUnits2.RESET;
                ACAStudentUnits2.SETRANGE("Student No.",Coregs."Student No.");
                ACAStudentUnits2.SETRANGE(Reversed,FALSE);
                ACAStudentUnits2.SETRANGE("Year Of Study",Coregs."Year Of Study");
                ACAStudentUnits2.SETRANGE("CATs Marks Exists",FALSE);
                ACAStudentUnits2.SETRANGE("EXAMs Marks Exists",FALSE);
                ACAStudentUnits2.SETFILTER(Unit,'<>%1','');
                IF ACAStudentUnits2.FIND('-') THEN BEGIN
                //Coregs."Yearly Remarks":='SUPP';
                  END;*/
                
                   Coregs.Modify;
                
                  // Coregs.VALIDATE(Coregs.Stage);

            end;

            trigger OnPreDataItem()
            begin
                //"ACA-Exam Results".SETRANGE("ACA-Exam Results"."User Name",UserID);

                //Reset Exam Status
                ACACourseRegistration.Reset;
                ACACourseRegistration.CopyFilters(Coregs);
                //IF (Coregs.GETFILTER(Coregs."Academic Year"))<>'' THEN
                //  ACACourseRegistration.SETRANGE("Academic Year",(Coregs.GETFILTER(Coregs."Academic Year")));
                if ACACourseRegistration.Find('-') then
                  repeat
                    ACACourseRegistration."Exam Status":='';
                    ACACourseRegistration."Yearly Remarks":='';
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
         progress.Open('Processing 4 of 7.\Computing Yearly Averages......\No.: #1########################################'+
         '\Prog.: #2########################################\Sem.: #3########################################\Stage: #4########################################');
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
        LubricIdentified: Boolean;
        ACACourseRegistration: Record UnknownRecord61532;
        YearlyCfFail: Decimal;
        SemesterCfFail: Decimal;
        CummCFFauil: Decimal;
        Customer2: Record Customer;
}

