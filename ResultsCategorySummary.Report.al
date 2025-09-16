#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51565 "Results Category Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Results Category Summary.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Year of Admission","Student No.") order(ascending) where("Yearly Total Units Taken"=filter(>0),"Yearly Remarks"=filter(<>""),Reversed=filter(No));
            RequestFilterFields = Faculty,"Academic Year",Programme,"Year Of Study";
            column(ReportForNavId_2901; 2901)
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
            column(StatusCode;ResultsStatus3.Description)
            {
            }
            column(StatusDesc;ResultsStatus.Description)
            {
            }
            column(SummaryPageCaption;ACAResultsStatus."Summary Page Caption")
            {
            }
            column(StatusOrder;ACAResultsStatus."Order No")
            {
            }
            column(StatCodes;ACAResultsStatus.Code)
            {
            }
            column(ApprovalsClaimer;'Approved by the board of the Examiners of the  '+FacDesc+' at a meeting held on:')
            {
            }
            column(RegTrans;"ACA-Course Registration"."Reg. Transacton ID")
            {
            }
            column(StudNo;"ACA-Course Registration"."Student No.")
            {
            }
            column(Progs;"ACA-Course Registration".Programme)
            {
            }
            column(ProgName;progName)
            {
            }
            column(Sems;"ACA-Course Registration".Semester)
            {
            }
            column(RegFor;"ACA-Course Registration"."Register for")
            {
            }
            column(CourseStage;"ACA-Course Registration".Stage)
            {
            }
            column(Units;"ACA-Course Registration".Unit)
            {
            }
            column(StudType;"ACA-Course Registration"."Student Type")
            {
            }
            column(EntryNo;"ACA-Course Registration"."Entry No.")
            {
            }
            column(CampusCode;"ACA-Course Registration"."Campus Code")
            {
            }
            column(ExamStatus;"ACA-Course Registration"."Exam Status")
            {
            }
            column(FailedUnits;"ACA-Course Registration"."Failed Unit")
            {
            }
            column(facCode;facCode)
            {
            }
            column(FacDesc;FacDesc)
            {
            }
            column(YoS;"ACA-Course Registration"."Year Of Study")
            {
            }
            column(AcadYear;"ACA-Course Registration"."Academic Year")
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
            column(YoA;"ACA-Course Registration"."Year of Admission")
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
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Programme=field(Programme),"Year Of Study"=field("Year Of Study");
                DataItemTableView = where(Grade=filter(E|X|X|F|""));
                column(ReportForNavId_1000000014; 1000000014)
                {
                }
                column(UnitCode;"ACA-Student Units".Unit)
                {
                }
                column(UnitDesc;"ACA-Student Units".Description)
                {
                }
                column(SpecialReason;"ACA-Student Units"."Reason for Special Exam/Susp.")
                {
                }
                column(IsSpecialUnit;IsSpecialUnit)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(IsSpecialUnit);//IsSpecialUnit:=TRUE;
                    if ((isSpecialOnly) or (IsSpecialAndSupp)) then begin
                    if "ACA-Student Units"."Special Exam"<>"ACA-Student Units"."special exam"::" " then  IsSpecialUnit:=true;
                    if "ACA-Student Units".Grade in ['E','X','F',''] then  IsSpecialUnit:=true;
                      end;
                    if UnitCodeLabel='' then CurrReport.Skip;
                    //IF "ACA-Student Units".Grade<>'E' THEN CurrReport.SKIP;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                
                Clear(SpecialUnitReg);
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Special Exam Exists");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Yearly Passed Units","ACA-Course Registration"."Yearly Failed Units");
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Yearly Total Units Taken");
                Clear(NextYear);
                Clear(YearOfStudyText);
                Clear(YoS);
                if "ACA-Course Registration"."Year Of Study"<>0 then begin
                  if "ACA-Course Registration"."Year Of Study"=1 then begin
                    YearOfStudyText:='First Year (1)';
                    YoS:='FIRST';
                    if "ACA-Course Registration"."Yearly Failed Units"=0 then NextYear:='SECOND'
                     else NextYear:='FIRST';
                  end else if "ACA-Course Registration"."Year Of Study"=2 then begin
                    YearOfStudyText:='Second Year (2)';
                    YoS:='SECOND';
                    if "ACA-Course Registration"."Yearly Failed Units"=0 then NextYear:='THIRD'
                     else NextYear:='THIRD';
                  end else if "ACA-Course Registration"."Year Of Study"=3 then begin
                    YearOfStudyText:='Third Year (3)';
                    YoS:='THIRD';
                    if "ACA-Course Registration"."Yearly Failed Units"=0 then NextYear:='FOURTH'
                     else NextYear:='THIRD';
                  end else if "ACA-Course Registration"."Year Of Study"=4 then begin
                    YearOfStudyText:='Fourth Year (4)';
                    YoS:='FOURTH';
                   NextYear:='FOUR';
                    end;
                  end;
                  Clear(IsaForthYear);
                  if (("ACA-Course Registration".Stage='Y4S1') or ("ACA-Course Registration".Stage='Y4S2')) then
                    IsaForthYear:=true;
                
                
                Clear(progName);
                Prog.Reset;
                Prog.SetRange(Code,"ACA-Course Registration".Programme);
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
                Prog.SetRange(Code,"ACA-Course Registration".Programme);
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
                
                
                  if Cust.Get("ACA-Course Registration"."Student No.") then;
                  Names:=Cust.Name;
                  RegNo:="ACA-Course Registration"."Student No.";
                  Clear(UnitCodeLabel);
                  Clear(UnitDescriptionLabel);
                  Clear(PercentageFailedCaption);
                  Clear(NumberOfCoursesFailedCaption);
                  Clear(PercentageFailedValue);
                  Clear(NoOfCausesFailedValue);
                ACAResultsStatus.Reset;
                ACAResultsStatus.SetRange(Code,"ACA-Course Registration"."Yearly Remarks");
                if ACAResultsStatus.Find('-') then begin
                  if ACAResultsStatus."Include Failed Units Headers" then begin
                    UnitCodeLabel:='Course Code';
                    UnitDescriptionLabel:='Course Title';
                    if "ACA-Course Registration"."Yearly Failed Units">0 then begin
                       PercentageFailedCaption:='% Failed';
                      //NumberOfCoursesFailedCaption:='Courses Failed';
                      //NoOfCausesFailedValue:="ACA-Course Registration"."Yearly Failed Units";
                      if (("ACA-Course Registration"."Yearly Failed Units">0) and ("ACA-Course Registration"."Yearly Total Units Taken">0)) then
                      PercentageFailedValue:=ROUND(((("ACA-Course Registration"."Yearly Failed Units")/("ACA-Course Registration"."Yearly Total Units Taken"))*100),0.01,'=');
                
                      end;
                    end;
                    end;
                    "ACA-Course Registration".CalcFields("ACA-Course Registration"."Special Exam Exists");
                    if "ACA-Course Registration"."Special Exam Exists"<>"ACA-Course Registration"."special exam exists"::" " then begin
                      NumberOfCoursesFailedCaption:='Reason';
                      PercentageFailedCaption:='';
                      end;
                  Msg1:=ACAResultsStatus."Status Msg1";
                  Msg2:=ACAResultsStatus."Status Msg2";
                  Msg3:=ACAResultsStatus."Status Msg3";
                  Msg4:=ACAResultsStatus."Status Msg4";
                  if  IsaForthYear then
                    if ACAResultsStatus."Final Year Comment"='' then IsaForthYear:=false;
                  Msg5:=ACAResultsStatus."Status Msg5";
                  Msg6:=ACAResultsStatus."Status Msg6";
                Clear(SaltedExamStatus);
                Clear(SaltedExamStatusDesc);
                SaltedExamStatus:=ACAResultsStatus.Code+facCode+Prog.Code+
                Format("ACA-Course Registration"."Year Of Study")+
                "ACA-Course Registration"."Academic Year";
                Clear(NoOfStudents);
                Clear(NoOfStudentsDecimal);
                CReg.Reset;
                CReg.SetRange("Yearly Remarks","ACA-Course Registration"."Yearly Remarks");
                CReg.SetRange("Academic Year","ACA-Course Registration"."Academic Year");
                CReg.SetRange(Programme,"ACA-Course Registration".Programme);
                CReg.SetRange("Year Of Study","ACA-Course Registration"."Year Of Study");
                CReg.SetFilter("Yearly Total Units Taken",'>%1',0);
                CReg.SetFilter(Reversed,'%1',false);
                if CReg.Find('-') then begin
                // // // // //  NoOfStudentsDecimal:=FORMAT(ROUND(((CReg.COUNT)),1,'>'));
                // // // // //  IF EVALUATE(NoOfStudents,NoOfStudentsDecimal) THEN BEGIN
                // // // // //    END;
                // // // // //  //NoOfStudents:=CReg.COUNT;
                // // // // //  END;
                  //---------------------------------------------------------
                  ACASenateReportCounts.Reset;
                ACASenateReportCounts.SetRange("Prog. Code","ACA-Course Registration".Programme);
                ACASenateReportCounts.SetRange(StatusCode,"ACA-Course Registration"."Yearly Remarks");
                ACASenateReportCounts.SetRange("Academic Year","ACA-Course Registration"."Academic Year");
                ACASenateReportCounts.SetRange(YoS,"ACA-Course Registration"."Year Of Study");
                if  ACASenateReportCounts.Find('-') then begin
                  NoOfStudentsDecimal:=Format(ROUND(((ACASenateReportCounts.Count)),1,'>'));
                  if Evaluate(NoOfStudents,NoOfStudentsDecimal) then;
                  end;
                  //---------------------------------------------------------
                
                SaltedExamStatusDesc:=Msg1;
                Clear(NoOfStudentInText);
                if NoOfStudents<>0 then NoOfStudentInText:=ConvertDecimalToText.InitiateConvertion(NoOfStudents);
                if ACAResultsStatus."IncludeVariable 1" then SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+NoOfStudentInText+' ('+Format(NoOfStudents)+') '+Msg2;
                if  ACAResultsStatus."IncludeVariable 2" then SaltedExamStatusDesc:=SaltedExamStatusDesc +' '+FacDesc+' '+Msg3;
                if ACAResultsStatus."IncludeVariable 3" then SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+YearOfStudyText+' '+Msg4+' '+progName;
                if IsaForthYear=false then begin
                if ACAResultsStatus."IncludeVariable 4" then SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+Msg5;
                if ACAResultsStatus."IncludeVariable 5" then SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+NextYear;
                if ACAResultsStatus."IncludeVariable 6" then SaltedExamStatusDesc:=SaltedExamStatusDesc+' '+Msg6;
                end else SaltedExamStatusDesc:= SaltedExamStatusDesc+' '+ACAResultsStatus."Final Year Comment";
                  end;
                  Clear(CurrNo);
                ACASenateReportStatusBuff.Reset;
                ACASenateReportStatusBuff.SetRange("Prog. Code","ACA-Course Registration".Programme);
                ACASenateReportStatusBuff.SetRange(StatusCode,"ACA-Course Registration"."Yearly Remarks");
                ACASenateReportStatusBuff.SetRange("Academic Year","ACA-Course Registration"."Academic Year");
                ACASenateReportStatusBuff.SetRange(YoS,"ACA-Course Registration"."Year Of Study");
                ACASenateReportStatusBuff.SetRange("Student No.","ACA-Course Registration"."Student No.");
                if not ACASenateReportStatusBuff.Find('-') then begin
                    ACASenateReportStatusBuff.Init;
                    ACASenateReportStatusBuff."Prog. Code":="ACA-Course Registration".Programme;
                    ACASenateReportStatusBuff."Student No.":="ACA-Course Registration"."Student No.";
                    ACASenateReportStatusBuff.Counts:=1;
                    ACASenateReportStatusBuff.StatusCode:="ACA-Course Registration"."Yearly Remarks";
                    ACASenateReportStatusBuff.YoS:="ACA-Course Registration"."Year Of Study";
                    ACASenateReportStatusBuff."Academic Year":="ACA-Course Registration"."Academic Year";
                    ACASenateReportStatusBuff.Insert;
                    end;
                ACASenateReportStatusBuff.Reset;
                ACASenateReportStatusBuff.SetRange("Prog. Code","ACA-Course Registration".Programme);
                ACASenateReportStatusBuff.SetRange(StatusCode,"ACA-Course Registration"."Yearly Remarks");
                ACASenateReportStatusBuff.SetRange("Academic Year","ACA-Course Registration"."Academic Year");
                ACASenateReportStatusBuff.SetRange(YoS,"ACA-Course Registration"."Year Of Study");
                if  ACASenateReportStatusBuff.Find('-') then   CurrNo:=ACASenateReportStatusBuff.Count;
                 // CurrNo:=CurrNo+1;
                 /* END ELSE BEGIN
                    CurrNo:=1;
                    ACASenateReportStatusBuff.INIT;
                    ACASenateReportStatusBuff."Prog. Code":="ACA-Course Registration".Programme;
                    ACASenateReportStatusBuff.Counts:=CurrNo;
                    ACASenateReportStatusBuff.StatusCode:="ACA-Course Registration"."Exam Status";
                    ACASenateReportStatusBuff.YoS:="ACA-Course Registration"."Year Of Study";
                    ACASenateReportStatusBuff."Academic Year":="ACA-Course Registration"."Academic Year";
                    ACASenateReportStatusBuff.INSERT;
                    END;*/
                
                ResultsStatus3.Reset;
                ResultsStatus3.SetRange(Code,"ACA-Course Registration"."Yearly Remarks");
                if ResultsStatus3.Find('-') then;
                Clear(SpecialUnitReg1);
                //SpecialUnitReg1:=TRUE;
                
                if "ACA-Course Registration"."Special Exam Exists"<>"ACA-Course Registration"."special exam exists"::" " then
                SpecialUnitReg1:=true;
                
                Clear(isSpecialOnly);
                Clear(IsSpecialAndSupp);
                if ("ACA-Course Registration"."Yearly Remarks"='SPECIAL') then begin isSpecialOnly:=true;
                      PercentageFailedCaption:='';
                      PercentageFailedValue:=0;
                      NumberOfCoursesFailedCaption:='Reason';
                end;
                if ("ACA-Course Registration"."Yearly Remarks"='SUPP/SPECIAL') then begin IsSpecialAndSupp:=true;
                      PercentageFailedCaption:='% Failed';
                      NumberOfCoursesFailedCaption:='Reason';
                end;
                NotSpecialNotSuppSpecial:=false;
                if ((isSpecialOnly) or (IsSpecialAndSupp)) then begin
                NotSpecialNotSuppSpecial:=true;
                end;

            end;

            trigger OnPreDataItem()
            begin
                if "ACA-Course Registration".GetFilter("ACA-Course Registration".Semester)<>'' then Error('Semester Filters are not allowed.');
                if "ACA-Course Registration".GetFilter("ACA-Course Registration".Stage)<>'' then Error('Stage Filters are not allowed.');
                Clear(yosInt);
                if Evaluate(yosInt,"ACA-Course Registration".GetFilter("Year Of Study")) then;
                CReg.Reset;
                //CReg.SETRANGE("Yearly Remarks","ACA-Course Registration"."Yearly Remarks");
                CReg.SetRange("Academic Year","ACA-Course Registration".GetFilter("Academic Year"));
                CReg.SetRange(Programme,"ACA-Course Registration".GetFilter(Programme));
                CReg.SetRange("Year Of Study",yosInt);
                //CReg.SETRANGE(Options,"ACA-Course Registration".GETFILTER(Options));
                CReg.SetFilter("Yearly Total Units Taken",'>%1',0);
                CReg.SetFilter(Reversed,'%1',false);
                CReg.SetFilter("Yearly Remarks",'<>%1','');
                if CReg.Find('-') then begin
                  ACASenateReportCounts.Reset;
                ACASenateReportCounts.SetRange("Prog. Code",CReg.Programme);
                //ACASenateReportCounts.SETRANGE(StatusCode,CReg."Yearly Remarks");
                ACASenateReportCounts.SetRange("Academic Year",CReg."Academic Year");
                ACASenateReportCounts.SetRange(YoS,CReg."Year Of Study");
                if ACASenateReportCounts.Find('-') then ACASenateReportCounts.DeleteAll;
                  repeat
                    begin
                ACASenateReportCounts.Reset;
                ACASenateReportCounts.SetRange("Prog. Code",CReg.Programme);
                ACASenateReportCounts.SetRange(StatusCode,CReg."Yearly Remarks");
                ACASenateReportCounts.SetRange("Academic Year",CReg."Academic Year");
                ACASenateReportCounts.SetRange(YoS,CReg."Year Of Study");
                ACASenateReportCounts.SetRange("Student No.",CReg."Student No.");
                if not ACASenateReportCounts.Find('-') then begin
                    ACASenateReportCounts.Init;
                    ACASenateReportCounts."Prog. Code":=CReg.Programme;
                    ACASenateReportCounts."Student No.":=CReg."Student No.";
                    ACASenateReportCounts.StatusCode:=CReg."Yearly Remarks";
                    ACASenateReportCounts.YoS:=CReg."Year Of Study";
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

    trigger OnInitReport()
    begin
        CompInf.Get();
        CompInf.CalcFields(CompInf.Picture);
    end;

    var
        NotSpecialNotSuppSpecial: Boolean;
        isSpecialOnly: Boolean;
        IsSpecialAndSupp: Boolean;
        IsaForthYear: Boolean;
        IsSpecialUnit: Boolean;
        SpecialUnitReg1: Boolean;
        SpecialUnitReg: Boolean;
        ACASenateReportCounts: Record UnknownRecord77720;
        NoOfStudentInText: Text[250];
        ConvertDecimalToText: Codeunit "Convert Decimal To Text";
        PercentageFailedCaption: Text[100];
        NumberOfCoursesFailedCaption: Text[100];
        PercentageFailedValue: Decimal;
        NoOfCausesFailedValue: Integer;
        NoOfStudentsDecimal: Text;
        ACAStudentUnits: Record UnknownRecord61549;
        CountedRecs: Integer;
        UnitCodes: array [30] of Text[50];
        UnitDescs: array [30] of Text[150];
        UnitCodeLabel: Text;
        UnitDescriptionLabel: Text;
        NoOfStudents: Integer;
        StudUnits: Record UnknownRecord61549;
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
        ResultsStatus: Record UnknownRecord61739;
        ResultsStatus3: Record UnknownRecord61739;
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
        CREG2: Record UnknownRecord61532;
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
        ACAResultsStatus: Record UnknownRecord61739;
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
        CReg33: Record UnknownRecord61532;
        CReg: Record UnknownRecord61532;
        yosInt: Integer;
}

