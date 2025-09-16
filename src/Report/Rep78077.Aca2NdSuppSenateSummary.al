#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78077 "Aca-2NdSupp. Senate Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Aca-2NdSupp. Senate Summary.rdlc';

    dataset
    {
        dataitem(ExamCoregcs;UnknownTable66682)
        {
            DataItemTableView = where("Supp Exists"=filter(Yes));
            RequestFilterFields = Programme,"Academic Year","Year of Study";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(ProgDesc;ACAProgrammeOptions.Desription)
            {
            }
            column(RubricDesc;ACAResultsStatus.Description)
            {
            }
            column(RegNo;RegNo)
            {
            }
            column(Names;Names)
            {
            }
            column(Compname;UpperCase(CompInf.Name))
            {
            }
            column(Pics;CompInf.Picture)
            {
            }
            column(StatusCode;ExamCoregcs.Classification)
            {
            }
            column(StatusDesc;ExamCoregcs.Classification)
            {
            }
            column(SummaryPageCaption;ACAResultsStatus."Summary Page Caption")
            {
            }
            column(StatusOrder;ACAResultsStatus."Order No")
            {
            }
            column(StatCodes;ExamCoregcs.Classification)
            {
            }
            column(ApprovalsClaimer;'Approved by the board of the Examiners of the  '+ExamCoregcs."School Name"+' at a meeting held on:')
            {
            }
            column(StudNo;ExamCoregcs."Student Number")
            {
            }
            column(Progs;ExamCoregcs.Programme)
            {
            }
            column(ProgName;progName)
            {
            }
            column(facCode;facCode)
            {
            }
            column(FacDesc;FacDesc)
            {
            }
            column(YoS;ExamCoregcs."Year of Study")
            {
            }
            column(AcadYear;ExamCoregcs."Academic Year")
            {
            }
            column(YearOfStudyText;YearOfStudyText)
            {
            }
            column(NextYear;NextYear)
            {
            }
            column(SaltedExamStatusDesc;SaltedExamStatusDesc)
            {
            }
            column(SaltedExamStatus;SaltedExamStatus)
            {
            }
            column(counts;CurrNo)
            {
            }
            column(YoSTexed;YoS)
            {
            }
            column(UnitCodeLabel;UnitCodeLabel)
            {
            }
            column(UnitDescriptionLabel;UnitDescriptionLabel)
            {
            }
            column(PercentageFailedCaption;PercentageFailedCaption)
            {
            }
            column(NumberOfCoursesFailedCaption;NumberOfCoursesFailedCaption)
            {
            }
            column(PercentageFailedValue;PercentageFailedValue)
            {
            }
            column(NoOfCausesFailedValue;NoOfCausesFailedValue)
            {
            }
            column(YoA;ExamCoregcs."Admission Academic Year")
            {
            }
            column(SpecialUnitReg;SpecialUnitReg1)
            {
            }
            column(IsSpecialAndSupp;IsSpecialAndSupp)
            {
            }
            column(IsSpecialOnly;isSpecialOnly)
            {
            }
            column(NotSpecialNotSuppSpecial;NotSpecialNotSuppSpecial)
            {
            }
            column(FinalTexts;FinalTexts)
            {
            }
            column(Messages1;Msg1)
            {
            }
            column(Messages2;Msg2)
            {
            }
            column(Messages3;Msg3)
            {
            }
            column(Messages4;Msg4)
            {
            }
            column(Messages5;Msg5)
            {
            }
            column(Messages6;Msg6)
            {
            }
            column(IncVar1;IncVar1)
            {
            }
            column(IncVar2;IncVar2)
            {
            }
            column(IncVar3;IncVar3)
            {
            }
            column(IncVar4;IncVar4)
            {
            }
            column(IncVar5;IncVar5)
            {
            }
            column(IncVar6;IncVar6)
            {
            }
            column(RubNumberText;RubNumberText)
            {
            }
            column(YearText2;YearText2)
            {
            }
            column(ProgClassCount;ACASenateReportsHeader.Prog_AcadYear_Status_Count)
            {
            }
            dataitem(ExamStudUnits;UnknownTable66681)
            {
                CalcFields = "Is Supp. Unit","Special Unit Reason",Pass;
                DataItemLink = "Student No."=field("Student Number"),Programme=field(Programme),"Year of Study"=field("Year of Study"),"Academic Year"=field("Academic Year");
                DataItemTableView = where(Pass=filter(No));
                column(ReportForNavId_1000000014; 1000000014)
                {
                }
                column(UnitCode;ExamStudUnits."Unit Code")
                {
                }
                column(UnitDesc;ExamStudUnits."Unit Description")
                {
                }
                column(IsSpecialUnit;ExamStudUnits."Is Supp. Unit")
                {
                }
                column(SpecialReason;ExamStudUnits."Special Unit Reason")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // CLEAR(IsSpecialUnit);//IsSpecialUnit:=TRUE;
                    // IF ((isSpecialOnly) OR (IsSpecialAndSupp)) THEN BEGIN
                    // IF "ACA-Student Units"."Special Exam"<>"ACA-Student Units"."Special Exam"::" " THEN  IsSpecialUnit:=TRUE;
                    // IF "ACA-Student Units".Grade IN ['E','X','F',''] THEN  IsSpecialUnit:=TRUE;
                    //  END;
                    if UnitCodeLabel='' then CurrReport.Skip;
                    //IF "ACA-Student Units".Grade<>'E' THEN CurrReport.SKIP;
                    if ((ExamStudUnits.Pass=true) and (ExamStudUnits."Is Supp. Unit"=false)) then
                      CurrReport.Skip;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                
                Clear(SpecialUnitReg);
                Clear(NextYear);
                Clear(YearOfStudyText);
                Clear(YoS);
                // // IF ExamCoregcs."Year Of Study"<>0 THEN BEGIN
                // //  IF ExamCoregcs."Year Of Study"=1 THEN BEGIN
                // //    YearOfStudyText:='First Year (1)';
                // //    YoS:='FIRST';
                // //    IF ExamCoregcs."Yearly Failed Units"=0 THEN NextYear:='SECOND'
                // //     ELSE NextYear:='FIRST';
                // //  END ELSE IF ExamCoregcs."Year Of Study"=2 THEN BEGIN
                // //    YearOfStudyText:='Second Year (2)';
                // //    YoS:='SECOND';
                // //    IF ExamCoregcs."Yearly Failed Units"=0 THEN NextYear:='THIRD'
                // //     ELSE NextYear:='THIRD';
                // //  END ELSE IF ExamCoregcs."Year Of Study"=3 THEN BEGIN
                // //    YearOfStudyText:='Third Year (3)';
                // //    YoS:='THIRD';
                // //    IF ExamCoregcs."Yearly Failed Units"=0 THEN NextYear:='FOURTH'
                // //     ELSE NextYear:='THIRD';
                // //  END ELSE IF ExamCoregcs."Year Of Study"=4 THEN BEGIN
                // //    YearOfStudyText:='Fourth Year (4)';
                // //    YoS:='FOURTH';
                // //   NextYear:='FOUR';
                // //    END;
                // //  END;
                
                    Clear(YoSText);
                    if ExamCoregcs."Year of Study"=1 then YoSText:='FIRST';
                    if ExamCoregcs."Year of Study"=2 then YoSText:='SECOND';
                    if ExamCoregcs."Year of Study"=3 then YoSText:='THIRD';
                    if ExamCoregcs."Year of Study"=4 then YoSText:='FOURTH';
                    if ExamCoregcs."Year of Study"=5 then YoSText:='FIFTH';
                    if ExamCoregcs."Year of Study"=6 then YoSText:='SIXTH';
                    if ExamCoregcs."Year of Study"=7 then YoSText:='SEVENTH';
                YearText2:=YoSText;
                  Clear(IsaForthYear);
                    IsaForthYear:=ExamCoregcs.Finalist;
                ACASenateReportsHeader.Reset;
                ACASenateReportsHeader.SetRange("Academic Year",ExamCoregcs."Academic Year");
                ACASenateReportsHeader.SetRange("Programme Code",ExamCoregcs.Programme);
                ACASenateReportsHeader.SetRange("Classification Code",ExamCoregcs.Classification);
                ACASenateReportsHeader.SetRange("Year of Study",ExamCoregcs."Year of Study");
                
                if ACASenateReportsHeader.Find('-') then begin
                  ACASenateReportsHeader.CalcFields(Prog_AcadYear_Status_Count);
                  RubNumberText:=ConvertDecimalToText.InitiateConvertion(ACASenateReportsHeader.Prog_AcadYear_Status_Count);
                  end;
                
                Clear(progName);
                Prog.Reset;
                Prog.SetRange(Code,ExamCoregcs.Programme);
                if Prog.Find('-') then begin
                  progName:=Prog.Description;
                  end;
                  Clear(Msg1);
                  Clear(Msg2);
                  Clear(Msg3);
                  Clear(Msg4);
                  Clear(Msg5);
                  Clear(Msg6);
                
                //Get the Department
                Clear(FacDesc);
                Clear(facCode);
                FacDesc:='';
                Prog.Reset;
                Prog.SetRange(Code,ExamCoregcs.Programme);
                Prog.SetFilter("School Code",'<>%1','');
                if Prog.Find('-') then begin
                Dimensions2.Reset;
                Dimensions2.SetRange("Dimension Code",'SCHOOL');
                Dimensions2.SetRange(Code,Prog."School Code");
                if Dimensions2.Find('-') then begin
                  FacDesc:=Dimensions2.Name;
                  facCode:=Dimensions2.Code;
                  end;
                end;
                
                
                  if Cust.Get(ExamCoregcs."Student Number") then;
                  Names:=Cust.Name;
                  RegNo:=ExamCoregcs."Student Number";
                  Clear(UnitCodeLabel);
                  Clear(UnitDescriptionLabel);
                  Clear(PercentageFailedCaption);
                  Clear(NumberOfCoursesFailedCaption);
                  Clear(PercentageFailedValue);
                  Clear(NoOfCausesFailedValue);
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetRange(Code,ExamCoregcs.Classification);
                ACAResultsStatus.SetRange("Academic Year",ExamCoregcs."Academic Year");
                ACAResultsStatus.SetRange(ACAResultsStatus."Special Programme Class",Prog."Special Programme Class");
                if ACAResultsStatus.Find('-') then begin
                  if ACAResultsStatus."Include Failed Units Headers" then begin
                    UnitCodeLabel:='Course Code';
                    UnitDescriptionLabel:='Course Title';
                      ExamCoregcs.CalcFields("Failed Units","Total Units");
                    if ExamCoregcs."Failed Units">0 then begin
                      if ACAResultsStatus."Include CF% Fail" then
                       PercentageFailedCaption:='% Failed';
                      //NumberOfCoursesFailedCaption:='Courses Failed';
                      //NoOfCausesFailedValue:=ExamCoregcs."Yearly Failed Units";
                
                      if ACAResultsStatus."Include CF% Fail" then
                      if ((ExamCoregcs."Failed Units">0) and (ExamCoregcs."Total Units">0)) then
                      PercentageFailedValue:=ROUND((((ExamCoregcs."Failed Units")/(ExamCoregcs."Total Units"))*100),0.01,'=');
                
                      end;
                    end;
                    end;
                // //    ExamCoregcs.CALCFIELDS(ExamCoregcs."Special Exam Exists");
                // //    IF ExamCoregcs."Special Exam Exists"<>ExamCoregcs."Special Exam Exists"::" " THEN BEGIN
                // //      NumberOfCoursesFailedCaption:='Reason';
                // //      PercentageFailedCaption:='';
                // //      END;
                  Msg1:=ACAResultsStatus."Status Msg1";
                  Msg2:=ACAResultsStatus."Status Msg2";
                  Msg3:=ACAResultsStatus."Status Msg3";
                //  IF (ACASenateReportsHeader.Prog_AcadYear_Status_Count>1) THEN Msg3:='in their'
                //  ELSE Msg3:='in His/Her';
                  Msg4:=ACAResultsStatus."Status Msg4";
                  if  IsaForthYear then
                    if ACAResultsStatus."Final Year Comment"='' then IsaForthYear:=false;
                  Msg5:=ACAResultsStatus."Status Msg5";
                Clear(SaltedExamStatus);
                Clear(SaltedExamStatusDesc);
                SaltedExamStatus:=ACAResultsStatus.Code+facCode+Prog.Code+
                Format(ExamCoregcs."Year of Study")+
                ExamCoregcs."Academic Year";
                Clear(NoOfStudents);
                Clear(NoOfStudentsDecimal);
                CReg.Reset;
                CReg.SetRange(Classification,ExamCoregcs.Classification);
                CReg.SetRange("Academic Year",ExamCoregcs."Academic Year");
                CReg.SetRange(Programme,ExamCoregcs.Programme);
                CReg.SetRange("Year of Study",ExamCoregcs."Year of Study");
                CReg.SetFilter("Total Units",'>%1',0);
                if CReg.Find('-') then begin
                // // // // //  NoOfStudentsDecimal:=FORMAT(ROUND(((CReg.COUNT)),1,'>'));
                // // // // //  IF EVALUATE(NoOfStudents,NoOfStudentsDecimal) THEN BEGIN
                // // // // //    END;
                // // // // //  //NoOfStudents:=CReg.COUNT;
                // // // // //  END;
                  //---------------------------------------------------------
                  ACASenateReportCounts.Reset;
                ACASenateReportCounts.SetRange("Prog. Code",ExamCoregcs.Programme);
                ACASenateReportCounts.SetRange(StatusCode,ExamCoregcs.Classification);
                ACASenateReportCounts.SetRange("Academic Year",ExamCoregcs."Academic Year");
                ACASenateReportCounts.SetRange(YoS,ExamCoregcs."Year of Study");
                if  ACASenateReportCounts.Find('-') then begin
                  NoOfStudentsDecimal:=Format(ROUND(((ACASenateReportCounts.Count)),1,'>'));
                  if Evaluate(NoOfStudents,NoOfStudentsDecimal) then;
                  end;
                  //---------------------------------------------------------
                
                // // SaltedExamStatusDesc:=Msg1;
                // // CLEAR(NoOfStudentInText);
                // // IF NoOfStudents<>0 THEN NoOfStudentInText:=ConvertDecimalToText.InitiateConvertion(NoOfStudents);
                // // IF ACAResultsStatus."IncludeVariable 1" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+NoOfStudentInText+' ('+FORMAT(NoOfStudents)+') '+Msg2;
                // // IF  ACAResultsStatus."IncludeVariable 2" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc +' '+FacDesc+' '+Msg3;
                // // IF ACAResultsStatus."IncludeVariable 3" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+YearOfStudyText+' '+Msg4+' '+progName;
                // // IF IsaForthYear=FALSE THEN BEGIN
                // // IF ACAResultsStatus."IncludeVariable 4" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+Msg5;
                // // IF ACAResultsStatus."IncludeVariable 5" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+NextYear;
                // // IF ACAResultsStatus."IncludeVariable 6" THEN SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+Msg6;
                // // END ELSE SaltedExamStatusDesc:= SaltedExamStatusDesc+' '+ACAResultsStatus."Final Year Comment";
                  end;
                  Clear(CurrNo);
                ACASenateReportStatusBuff.Reset;
                ACASenateReportStatusBuff.SetRange("Prog. Code",ExamCoregcs.Programme);
                ACASenateReportStatusBuff.SetRange(StatusCode,ExamCoregcs.Classification);
                ACASenateReportStatusBuff.SetRange("Academic Year",ExamCoregcs."Academic Year");
                ACASenateReportStatusBuff.SetRange(YoS,ExamCoregcs."Year of Study");
                ACASenateReportStatusBuff.SetRange("Student No.",ExamCoregcs."Student Number");
                if not ACASenateReportStatusBuff.Find('-') then begin
                    ACASenateReportStatusBuff.Init;
                    ACASenateReportStatusBuff."Prog. Code":=ExamCoregcs.Programme;
                    ACASenateReportStatusBuff."Student No.":=ExamCoregcs."Student Number";
                    ACASenateReportStatusBuff.Counts:=1;
                    ACASenateReportStatusBuff.StatusCode:=ExamCoregcs.Classification;
                    ACASenateReportStatusBuff.YoS:=ExamCoregcs."Year of Study";
                    ACASenateReportStatusBuff."Academic Year":=ExamCoregcs."Academic Year";
                    ACASenateReportStatusBuff.Insert;
                    end;
                ACASenateReportStatusBuff.Reset;
                ACASenateReportStatusBuff.SetRange("Prog. Code",ExamCoregcs.Programme);
                ACASenateReportStatusBuff.SetRange(StatusCode,ExamCoregcs.Classification);
                ACASenateReportStatusBuff.SetRange("Academic Year",ExamCoregcs."Academic Year");
                ACASenateReportStatusBuff.SetRange(YoS,ExamCoregcs."Year of Study");
                if  ACASenateReportStatusBuff.Find('-') then   CurrNo:=ACASenateReportStatusBuff.Count;
                 // CurrNo:=CurrNo+1;
                 /* END ELSE BEGIN
                    CurrNo:=1;
                    ACASenateReportStatusBuff.INIT;
                    ACASenateReportStatusBuff."Prog. Code":=ExamCoregcs.Programme;
                    ACASenateReportStatusBuff.Counts:=CurrNo;
                    ACASenateReportStatusBuff.StatusCode:=ExamCoregcs."Exam Status";
                    ACASenateReportStatusBuff.YoS:=ExamCoregcs."Year Of Study";
                    ACASenateReportStatusBuff."Academic Year":=ExamCoregcs."Academic Year";
                    ACASenateReportStatusBuff.INSERT;
                    END;*/
                
                ResultsStatus3.Reset;
                ResultsStatus3.SetRange(Code,ExamCoregcs.Classification);
                Clear(SpecialUnitReg1);
                //SpecialUnitReg1:=TRUE;
                
                // // // // // IF ExamCoregcs."Special Exam Exists"<>ExamCoregcs."Special Exam Exists"::" " THEN
                // // // // // SpecialUnitReg1:=TRUE;
                
                 Clear(isSpecialOnly);
                 Clear(IsSpecialAndSupp);
                 if (ExamCoregcs.Classification='SPECIAL') then begin isSpecialOnly:=true;
                 SpecialUnitReg1:=isSpecialOnly;
                 end;
                //      PercentageFailedCaption:='';
                //      PercentageFailedValue:=0;
                //      NumberOfCoursesFailedCaption:='Reason';
                // END;
                // IF (ExamCoregcs."Yearly Remarks"='SUPP/SPECIAL') THEN BEGIN IsSpecialAndSupp:=TRUE;
                //      PercentageFailedCaption:='% Failed';
                //      NumberOfCoursesFailedCaption:='Reason';
                // END;
                // NotSpecialNotSuppSpecial:=FALSE;
                // IF ((isSpecialOnly) OR (IsSpecialAndSupp)) THEN BEGIN
                // NotSpecialNotSuppSpecial:=TRUE;
                // END;
                
                ACAResultsStatusez.Reset;
                ACAResultsStatusez.SetRange(Code,ExamCoregcs.Classification);
                ACAResultsStatusez.SetRange(ACAResultsStatusez."Special Programme Class",Prog."Special Programme Class");
                ACAResultsStatusez.SetRange(ACAResultsStatusez."Academic Year",ExamCoregcs."Academic Year");
                if ACAResultsStatusez.Find('-') then begin
                
                //      IF ((ACAResultsStatusez."Grad. Status Msg 4"='') OR (ACAResultsStatusez."Grad. Status Msg 5"='') OR
                //         (ACAResultsStatusez."Grad. Status Msg 5"='')) THEN YearText2:='';
                  if ExamCoregcs."Year of Study"=1 then begin
                FinalTexts:=ACAResultsStatusez."1st Year Grad. Comments";
                end else  if ExamCoregcs."Year of Study"=2 then begin
                FinalTexts:=ACAResultsStatusez."2nd Year Grad. Comments";
                end else if ExamCoregcs."Year of Study"=3 then begin
                FinalTexts:=ACAResultsStatusez."3rd Year Grad. Comments";
                end else if ExamCoregcs."Year of Study"=4 then begin
                FinalTexts:=ACAResultsStatusez."4th Year Grad. Comments";
                end else if ExamCoregcs."Year of Study"=5 then begin
                FinalTexts:=ACAResultsStatusez."5th Year Grad. Comments";
                end else if ExamCoregcs."Year of Study"=6 then begin
                FinalTexts:=ACAResultsStatusez."6th Year Grad. Comments";
                end else if ExamCoregcs."Year of Study"=7 then begin
                FinalTexts:=ACAResultsStatusez."7th Year Grad. Comments";
                end;
                // // // //
                // // // // IF ((ExamCoregcs."Final Year of Study") = (ExamCoregcs."Year of Study")) THEN BEGIN
                // // // //  IF ((Prog.Category=Prog.Category::"Certificate ") OR
                // // // //    (Prog.Category=Prog.Category::"Course List") OR
                // // // //    (Prog.Category=Prog.Category::Professional)) THEN BEGIN
                // // // // FinalTexts:=ACAResultsStatusez."Finalists Grad. Comm. Cert.";
                // // // //  END ELSE   IF ((Prog.Category=Prog.Category::Diploma)) THEN BEGIN
                // // // // FinalTexts:=ACAResultsStatusez."Finalists Grad. Comm. Dip";
                // // // //  END ELSE   IF ((Prog.Category=Prog.Category::Undergraduate) OR
                // // // //    (Prog.Category=Prog.Category::Postgraduate)) THEN BEGIN
                // // // // FinalTexts:=ACAResultsStatusez."Finalists Grad. Comm. Degree";
                // // // //  END;
                // // // //  //ShowRate:=TRUE;
                // // // // END;
                /*
                IF ACAResultsStatusez."Grad. Status Msg 6"='' THEN BEGIN
                   FinalTexts:='';
                  END;
                IF ACAResultsStatusez."Grad. Status Msg 4"='' THEN BEGIN
                   FinalTexts:='';
                  END;
                IF ACAResultsStatusez."Grad. Status Msg 5"='' THEN BEGIN
                   FinalTexts:='';
                  END;*/
                  end;
                // //  AcaFinalConsMksCount.RESET;
                // // AcaFinalConsMksCount.SETRANGE("Student No.",ExamCoregcs."Student Number");
                // // AcaFinalConsMksCount.SETRANGE("User Names",USERID);
                // // AcaFinalConsMksCount.SETRANGE("Graduation Academic Year",ExamCoregcs."Graduation Academic Year");
                // // AcaFinalConsMksCount.SETRANGE("Academic Year",ExamCoregcs."Academic Year");
                // // AcaFinalConsMksCount.SETRANGE("Program Option",ExamCoregcs."Programme Option");
                // // AcaFinalConsMksCount.SETRANGE(Programme,ExamCoregcs.Programme);
                // // AcaFinalConsMksCount.SETRANGE("Year of Study",ExamCoregcs."Year of Study");
                // // IF AcaFinalConsMksCount.FIND('-') THEN;
                
                 Clear(IncVar1);
                  Clear(IncVar2);
                  Clear(IncVar3);
                  Clear(IncVar4);
                  Clear(IncVar5);
                  Clear(IncVar6);
                if ACAResultsStatusez."IncludeVariable 1" then IncVar1:=RubNumberText;
                if ACAResultsStatusez."IncludeVariable 2" then IncVar2:=Format(ACASenateReportsHeader.Prog_AcadYear_Status_Count);
                if ACAResultsStatusez."IncludeVariable 3" then IncVar3:=FacDesc;
                if ACAResultsStatusez."IncludeVariable 4" then IncVar4:=YearText2;
                if ACAResultsStatusez."IncludeVariable 5" then IncVar5:=progName;
                if ACAResultsStatusez."IncludeVariable 6" then IncVar6:=FinalTexts;

            end;

            trigger OnPreDataItem()
            begin
                Clear(yosInt);
                if Evaluate(yosInt,ExamCoregcs.GetFilter("Year of Study")) then;
                CReg.Reset;
                //CReg.SETRANGE("Yearly Remarks",ExamCoregcs."Yearly Remarks");
                CReg.SetRange("Academic Year",ExamCoregcs.GetFilter("Academic Year"));
                CReg.SetRange(Programme,ExamCoregcs.GetFilter(Programme));
                CReg.SetRange("Year of Study",yosInt);
                //CReg.SETRANGE(Options,ExamCoregcs.GETFILTER(Options));
                ACAProgrammeOptions.Reset;
                ACAProgrammeOptions.SetRange(Code,ExamCoregcs.GetFilter("Programme Option"));
                ACAProgrammeOptions.SetRange("Programme Code",ExamCoregcs.GetFilter(Programme));
                if ACAProgrammeOptions.Find('-') then;
                CReg.SetFilter("Total Units",'>%1',0);
                CReg.SetFilter(Classification,'<>%1','');
                if CReg.Find('-') then begin
                  ACASenateReportCounts.Reset;
                ACASenateReportCounts.SetRange("Prog. Code",CReg.Programme);
                //ACASenateReportCounts.SETRANGE(StatusCode,CReg."Yearly Remarks");
                ACASenateReportCounts.SetRange("Academic Year",CReg."Academic Year");
                ACASenateReportCounts.SetRange(YoS,CReg."Year of Study");
                if ACASenateReportCounts.Find('-') then ACASenateReportCounts.DeleteAll;
                  repeat
                    begin
                ACASenateReportCounts.Reset;
                ACASenateReportCounts.SetRange("Prog. Code",CReg.Programme);
                ACASenateReportCounts.SetRange(StatusCode,CReg.Classification);
                ACASenateReportCounts.SetRange("Academic Year",CReg."Academic Year");
                ACASenateReportCounts.SetRange(YoS,CReg."Year of Study");
                ACASenateReportCounts.SetRange("Student No.",CReg."Student Number");
                if not ACASenateReportCounts.Find('-') then begin
                    ACASenateReportCounts.Init;
                    ACASenateReportCounts."Prog. Code":=CReg.Programme;
                    ACASenateReportCounts."Student No.":=CReg."Student Number";
                    ACASenateReportCounts.StatusCode:=CReg.Classification;
                    ACASenateReportCounts.YoS:=CReg."Year of Study";
                    ACASenateReportCounts."Academic Year":=CReg."Academic Year";
                    ACASenateReportCounts.Insert;
                    end;
                // // //  NoOfStudentsDecimal:=FORMAT(ROUND(((CReg.COUNT)),1,'>'));
                // // //  IF EVALUATE(NoOfStudents,NoOfStudentsDecimal) THEN BEGIN
                // // //    END;
                  //NoOfStudents:=CReg.COUNT;
                  end;
                  until CReg.Next=0;
                  end;
                // //
                // // ExamCoregcsForNumber.COPYFILTERS(ExamCoregcs);
                // // ExamCoregcsForNumber.SETCURRENTKEY("Student Number");
                // // IF ExamCoregcsForNumber.FIND('-') THEN BEGIN
                // //    REPEAT
                // //      BEGIN
                // //      //
                // //      AcaFinalConsMksCount.INIT;
                // //      AcaFinalConsMksCount."User Names":=USERID;
                // //      AcaFinalConsMksCount."Program Option":=ExamCoregcsForNumber."Programme Option";
                // //      AcaFinalConsMksCount.Programme:=ExamCoregcsForNumber.Programme;
                // //      AcaFinalConsMksCount."Graduation Academic Year":=ExamCoregcsForNumber."Graduation Academic Year";
                // //      AcaFinalConsMksCount."Academic Year":=ExamCoregcsForNumber."Academic Year";
                // //      AcaFinalConsMksCount."Student No.":=ExamCoregcsForNumber."Student Number";
                // //      AcaFinalConsMksCount."Year of Study":=ExamCoregcsForNumber."Year of Study";
                // //      IF  AcaFinalConsMksCount.INSERT THEN;
                // //      END;
                // //      UNTIL ExamCoregcsForNumber.NEXT=0;
                // //  END;
                // //  AcaFinalConsMksCount.RESET;
                // //  AcaFinalConsMksCount.SETCURRENTKEY("Student No.");
                // //  IF AcaFinalConsMksCount.FIND('-') THEN BEGIN
                // //    CLEAR(seqs);
                // //    REPEAT
                // //      BEGIN
                // //        seqs:=seqs+1;
                // //        AcaFinalConsMksCount.Serial:=seqs;
                // //        AcaFinalConsMksCount.MODIFY;
                // //      END;
                // //        UNTIL AcaFinalConsMksCount.NEXT=0;
                // //    END;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

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

    trigger OnInitReport()
    begin
        CompInf.Get();
        ///CompInf.CALCFIELDS(CompInf.Picture);
    end;

    var
        seqs: Integer;
        ExamCoregcsForNumber: Record UnknownRecord66682;
        AcaFinalConsMksCount: Record UnknownRecord66686;
        ACAProgrammeOptions: Record UnknownRecord61554;
        ACAResultsStatusez: Record UnknownRecord69267;
        YoSText: Text[1024];
        ACASenateReportsHeader: Record "ACA-2ndSuppSenate Repo. Header";
        FinalTexts: Text[1024];
        YearText2: Text[1024];
        RubNumberText: Text[1024];
        NotSpecialNotSuppSpecial: Boolean;
        isSpecialOnly: Boolean;
        IsSpecialAndSupp: Boolean;
        IsaForthYear: Boolean;
        IsSpecialUnit: Boolean;
        SpecialUnitReg1: Boolean;
        SpecialUnitReg: Boolean;
        ACASenateReportCounts: Record UnknownRecord66686;
        NoOfStudentInText: Text[250];
        ConvertDecimalToText: Codeunit "Convert Decimal To Text";
        PercentageFailedCaption: Text[100];
        NumberOfCoursesFailedCaption: Text[100];
        PercentageFailedValue: Decimal;
        NoOfCausesFailedValue: Integer;
        NoOfStudentsDecimal: Text;
        ACAStudentUnits: Record UnknownRecord66681;
        CountedRecs: Integer;
        UnitCodes: array [30] of Text[50];
        UnitDescs: array [30] of Text[150];
        UnitCodeLabel: Text;
        UnitDescriptionLabel: Text;
        NoOfStudents: Integer;
        StudUnits: Record UnknownRecord66681;
        ExamsDone: Integer;
        FailCount: Integer;
        Cust: Record Customer;
        Semesters: Record UnknownRecord61692;
        Dimensions: Record "Dimension Value";
        Prog: Record UnknownRecord61511;
        FacDesc: Code[100];
        Depts: Record "Dimension Value";
        Stages: Record UnknownRecord61516;
        StudentsL: Text[250];
        N: Integer;
        Grd: Code[20];
        Marks: Decimal;
        Dimensions2: Record "Dimension Value";
        ResultsStatus: Record UnknownRecord69267;
        ResultsStatus3: Record UnknownRecord69267;
        UnitsRec: Record UnknownRecord61517;
        UnitsDesc: Text[100];
        UnitsHeader: Text[50];
        FailsDesc: Text[200];
        Nx: Integer;
        RegNo: Code[20];
        Names: Text[100];
        Ucount: Integer;
        RegNox: Code[20];
        Namesx: Text[100];
        Nxx: Text[30];
        SemYear: Code[20];
        ShowSem: Boolean;
        SemDesc: Code[100];
        CREG2: Record UnknownRecord66682;
        ExamsProcessing: Codeunit "Exams Processing1";
        CompInf: Record "Company Information";
        YearDesc: Text[30];
        MaxYear: Code[20];
        MaxSem: Code[20];
        CummScore: Decimal;
        CurrScore: Decimal;
        mDate: Date;
        IntakeRec: Record UnknownRecord61383;
        IntakeDesc: Text[100];
        SemFilter: Text[100];
        StageFilter: Text[100];
        MinYear: Code[20];
        MinSem: Code[20];
        StatusNarrations: Text[1000];
        NextYear: Code[20];
        facCode: Code[20];
        progName: Code[150];
        ACAResultsStatus: Record UnknownRecord69267;
        Msg1: Text[250];
        Msg2: Text[250];
        Msg3: Text[250];
        Msg4: Text[250];
        Msg5: Text[250];
        Msg6: Text[250];
        YearOfStudyText: Text[30];
        SaltedExamStatus: Code[1024];
        SaltedExamStatusDesc: Text;
        ACASenateReportStatusBuff: Record UnknownRecord77718 temporary;
        CurrNo: Integer;
        YoS: Code[20];
        CReg33: Record UnknownRecord66682;
        CReg: Record UnknownRecord66682;
        yosInt: Integer;
        IncVar1: Text[250];
        IncVar2: Text[250];
        IncVar3: Text[250];
        IncVar4: Text[250];
        IncVar5: Text[250];
        IncVar6: Text[250];
}

