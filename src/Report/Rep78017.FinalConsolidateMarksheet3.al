#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78017 "Final Consolidate Marksheet 3"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Final Consolidate Marksheet 3.rdlc';

    dataset
    {
        dataitem(UnknownTable78007;UnknownTable78007)
        {
            RequestFilterFields = "Grad. Academic Year","Programme Code","Academic Year","Programme Option";
            column(ReportForNavId_1000000061; 1000000061)
            {
            }
            column(GradAcadYear;"Fin. Consolid. Marksheet Cntrl"."Grad. Academic Year")
            {
            }
            column(GradGroup;'')
            {
            }
            column(Prog;"Fin. Consolid. Marksheet Cntrl"."Programme Code")
            {
            }
            column(ProgOption;"Fin. Consolid. Marksheet Cntrl"."Programme Option")
            {
            }
            column(AcademicYears;"Fin. Consolid. Marksheet Cntrl"."Academic Year")
            {
            }
            column(ProgOptionName;"Fin. Consolid. Marksheet Cntrl"."Prog. Option Name")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(pName;pName)
            {
            }
            column(SchoolName;SchoolName)
            {
            }
            column(signedSignature;dimVal.Signature)
            {
            }
            column(TranscriptSignatory;dimVal."HOD Names")
            {
            }
            column(TransCriptTitle;dimVal.Titles)
            {
            }
            column(FacultyName;SchoolName)
            {
            }
            column(codSchool;dimVal.Name)
            {
            }
            column(codDept;dimVal.Code)
            {
            }
            column(DeptName;DeptName)
            {
            }
            dataitem(UnknownTable61532;UnknownTable61532)
            {
                DataItemLink = Programme=field("Programme Code"),"Academic Year"=field("Academic Year"),Options=field("Programme Option"),"Graduation Academic Year"=field("Grad. Academic Year"),"Year Of Study"=field("Year of Study");
                DataItemTableView = sorting("Year of Admission","Student No.") order(ascending) where(Reversed=const(No));
                PrintOnlyIfDetail = true;
                RequestFilterFields = Programme,"Year Of Study","Academic Year","Graduation Academic Year",Options;
                column(ReportForNavId_1000000000; 1000000000)
                {
                }
                column(GroupingConcortion;"ACA-Course Registration"."Academic Year"+"ACA-Course Registration".Programme+DeptName+SchoolName+"ACA-Course Registration".Options+Format("ACA-Course Registration"."Year Of Study"))
                {
                }
                column(StudNo;"ACA-Course Registration"."Student No.")
                {
                }
                column(StudentNoAcademicYear;StudentNoAcademicYear)
                {
                }
                column(CountedDistinct;"ACA-Course Registration"."Student No."+"ACA-Course Registration"."Supp. Yearly Remarks")
                {
                }
                column(Sem;"ACA-Course Registration".Semester)
                {
                }
                column(Stag;"ACA-Course Registration".Stage)
                {
                }
                column(CumSc;"ACA-Course Registration"."Cumm Score")
                {
                }
                column(CurrSem;"ACA-Course Registration"."Current Cumm Score")
                {
                }
                column(Option;ACAProgrammeOptions.Desription)
                {
                }
                column(YoS;"ACA-Course Registration"."Year Of Study")
                {
                }
                column(TotalYearlyMarks;"ACA-Course Registration"."Supp. Total Yearly Marks")
                {
                }
                column(YearlyAverage;"ACA-Course Registration"."Supp. Yearly Average")
                {
                }
                column(YearlyGrade;"ACA-Course Registration"."Supp. Yearly Grade")
                {
                }
                column(YearlyPassed;"ACA-Course Registration"."Supp. Yearly Passed Units")
                {
                }
                column(YearlyFailed;"ACA-Course Registration"."Supp. Yearly Failed Units")
                {
                }
                column(YearlyTotalUnits;"ACA-Course Registration"."Supp. Yearly Total Units Taken")
                {
                }
                column(YearlyRemarks;"ACA-Course Registration"."Supp. Yearly Remarks")
                {
                }
                column(TotalSemMarks;"ACA-Course Registration"."Supp. Total Semester Marks")
                {
                }
                column(YearlyWeightedTotal;"ACA-Course Registration"."Supp. Yearly Weighted Total")
                {
                }
                column(YearlyGradUnitsCount;"ACA-Course Registration"."Yearly Graduating Units Count")
                {
                }
                column(YearlyGradWeigUnits;"ACA-Course Registration"."Yearly Grad. Weighted Units")
                {
                }
                column(YearlyGradWAverage;"ACA-Course Registration"."Yearly Grad. W. Average")
                {
                }
                column(FinClass;"ACA-Course Registration"."Final Clasification")
                {
                }
                column(YearlyCFFailed;"ACA-Course Registration"."Supp. Yearly CF% Failed")
                {
                }
                column(YearlyCurrAverage;ROUND("ACA-Course Registration"."Supp. Yearly Curr. Average",1,'='))
                {
                }
                column(SemAverage;"ACA-Course Registration"."Semester Average")
                {
                }
                column(SemGrade;"ACA-Course Registration"."Semester Grade")
                {
                }
                column(SemFailed;"ACA-Course Registration"."Semester Failed Units")
                {
                }
                column(SemTotalUnits;"ACA-Course Registration"."Semester Total Units Taken")
                {
                }
                column(SemRemarks;"ACA-Course Registration"."Semester Remarks")
                {
                }
                column(SemUnitsPassed;"ACA-Course Registration"."Semester Total Units Taken"-"ACA-Course Registration"."Semester Failed Units")
                {
                }
                column(SemCurrAverage;"ACA-Course Registration"."Semester Curr. Average")
                {
                }
                column(SemCFFailed;"ACA-Course Registration"."Semester CF% Failed")
                {
                }
                column(SemWeifgtedTotal;"ACA-Course Registration"."Semester Weighted Total")
                {
                }
                column(CommAverage;"ACA-Course Registration"."Supp. Cummulative Average")
                {
                }
                column(CummGrade;"ACA-Course Registration"."Supp. Cummulative Grade")
                {
                }
                column(CumScore;"ACA-Course Registration"."Supp. Cummulative Marks")
                {
                }
                column(CumUnits;"ACA-Course Registration"."Supp. Yearly Total Units Taken")
                {
                }
                column(CumUnits2;"ACA-Course Registration"."Supp. Cummulative Units")
                {
                }
                column(CummMarks;"ACA-Course Registration"."Supp. Cummulative Marks")
                {
                }
                column(CoursesFailed;"ACA-Course Registration"."Supp. Yearly Failed Courses")
                {
                }
                column(CummAward;"ACA-Course Registration".Award)
                {
                }
                column(cc;cc)
                {
                }
                column(YOSText;YOSTewxt)
                {
                }
                column(sName;sName)
                {
                }
                column(YearOfStudy;YearOfStudy)
                {
                }
                column(YearOfAdmi;YearOfAdmi)
                {
                }
                column(acadyear;acadyear)
                {
                }
                column(From100Legend;'A (70% - 100%)        - Excellent         B (60% - 69%)      - Good       C (50% - 59%)     -Satisfactory ')
                {
                }
                column(From40Legend;'D (40% - 49%)                - Fair                 E (39% and Below)   - Fail')
                {
                }
                column(PassMarkLegend;'NOTE:   Pass mark is '+Format(Passmark)+'%')
                {
                }
                column(DoubleLine;'===============================================================================')
                {
                }
                column(Recomm;'Recommendation:')
                {
                }
                column(singleLine;'===============================================================================')
                {
                }
                column(dateSigned;'Date:.......................................................')
                {
                }
                column(PassRemark;PassRemark)
                {
                }
                column(Label1;GLabel[1])
                {
                }
                column(Label2;GLabel[2])
                {
                }
                column(Label3;GLabel[3])
                {
                }
                column(Label4;GLabel[4])
                {
                }
                column(Label5;GLabel[5])
                {
                }
                column(BLabel1;GLabel2[1])
                {
                }
                column(BLabel2;GLabel2[2])
                {
                }
                column(BLabel3;GLabel2[3])
                {
                }
                column(BLabel4;GLabel2[4])
                {
                }
                column(BLabel5;GLabel2[5])
                {
                }
                column(RegAcadLabel;'Registrar, Academic Affairs')
                {
                }
                column(OrdersOfSum;ACAResultsStatus."Order No")
                {
                }
                column(GenCourseSuppExists;GenCourseSuppExists)
                {
                }
                dataitem(UnknownTable61549;UnknownTable61549)
                {
                    DataItemLink = "Student No."=field("Student No."),"Year Of Study"=field("Year Of Study");
                    DataItemTableView = where(Taken=filter(Yes),"Old Unit"=filter(No));
                    column(ReportForNavId_1000000005; 1000000005)
                    {
                    }
                    column(Unit;"ACA-Student Units".Unit)
                    {
                    }
                    column(UnitDesc;"ACA-Student Units"."Unit Description")
                    {
                    }
                    column(Score;"ACA-Student Units"."Supp. Total Marks")
                    {
                    }
                    column(Final;"ACA-Student Units"."Supp. Total Marks")
                    {
                    }
                    column(Grade;"ACA-Student Units"."Supp. Grade")
                    {
                    }
                    column(Status;"ACA-Student Units"."Exam Status")
                    {
                    }
                    column(ScoreLabel;ScoreLabel)
                    {
                    }
                    column(Units;"ACA-Student Units".Units)
                    {
                    }
                    column(StageUnit;"ACA-Student Units".Stage)
                    {
                    }
                    column(counts;MksCounts.Serial)
                    {
                    }
                    column(SuppExists;SuppExists)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        //--------------------------------------------------------------------------------------------------------------------------
                        //////////////////////////////////////////////////////////////////////////////////////////////////////////
                        MksCounts.Reset;
                         MksCounts.SetRange(MksCounts."Student No.","ACA-Student Units"."Student No.");
                         MksCounts.SetRange(MksCounts."Year of Study",Format("ACA-Course Registration"."Year Of Study"));
                         MksCounts.SetRange(MksCounts.Programme,"ACA-Student Units".Programme);
                         MksCounts.SetRange(MksCounts.Option,"ACA-Course Registration".Options);
                         MksCounts.SetRange(MksCounts."Academic Year","ACA-Course Registration"."Academic Year");
                         if not MksCounts.Find('-') then begin
                          //REPEAT
                            counts:=counts+1;
                         MksCounts.Init;
                         MksCounts."Student No.":="ACA-Course Registration"."Student No.";
                        MksCounts."Year of Study":=Format("ACA-Course Registration"."Year Of Study");
                        MksCounts.Programme:="ACA-Course Registration".Programme;
                        MksCounts.Option:="ACA-Course Registration".Options;
                        MksCounts."Academic Year":="ACA-Course Registration"."Academic Year";
                         MksCounts.Serial:=counts;
                         MksCounts.Insert;
                         //UNTIL MksCounts.NEXT=0;
                         end;
                        //////////////////////////////////////////////////////////////////////////////////////////////////////////
                        MksCounts.Reset;
                         MksCounts.SetRange(MksCounts."Student No.","ACA-Course Registration"."Student No.");
                         MksCounts.SetRange(MksCounts."Year of Study",Format("ACA-Course Registration"."Year Of Study"));
                         MksCounts.SetRange(MksCounts.Programme,"ACA-Course Registration".Programme);
                         MksCounts.SetRange(MksCounts.Option,"ACA-Course Registration".Options);
                         MksCounts.SetRange(MksCounts."Academic Year","ACA-Course Registration"."Academic Year");
                         if MksCounts.Find('-') then;// counts:=counts+1;
                        //--------------------------------------------------------------------------------------------------------------------------
                        Clear(ScoreLabel);
                        "ACA-Student Units".CalcFields("ACA-Student Units"."CATs Marks Exists","ACA-Student Units"."EXAMs Marks Exists");
                        if (("ACA-Student Units"."CATs Marks Exists"=false) and ("ACA-Student Units"."EXAMs Marks Exists"=false)) then begin
                          ScoreLabel:='X';
                        end else begin
                        ScoreLabel:=Format("ACA-Student Units"."Supp. Total Marks");
                         ScoreLabel:=ScoreLabel+"ACA-Student Units"."Supp. Cons. Mark Pref.";

                          end;
                        //IF ("ACA-Student Units"."Total Marks"<>0)  THEN ScoreLabel:=FORMAT("ACA-Student Units"."Total Marks")
                        //ELSE
                         // "ACA-Student Units".CALCFIELDS("ACA-Student Units"."Supp. Total Score");
                          if (("ACA-Course Registration"."Supp. Yearly Remarks"='EXPELLED') or
                           ("ACA-Course Registration"."Supp. Yearly Remarks"='SUSPENDED') or
                           ("ACA-Course Registration"."Supp. Yearly Remarks"='EXPULSION')) then ScoreLabel:='-';
                           Clear(SuppExists);
                        // //   "ACA-Student Units".CALCFIELDS("ACA-Student Units"."No of Supplementaries");
                        // //   IF "ACA-Student Units"."No of Supplementaries">0 THEN SuppExists:=TRUE;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    
                     if "ACA-Course Registration".Options<>'' then begin
                       ACAProgrammeOptions.Reset;
                       ACAProgrammeOptions.SetRange("Programme Code","ACA-Course Registration".Programme);
                       ACAProgrammeOptions.SetRange(Code,"ACA-Course Registration".Options);
                       if ACAProgrammeOptions.Find('-') then begin
                         end;
                       end;
                    
                     Clear(StudentNoAcademicYear);
                     if StrLen("ACA-Course Registration"."Student No.")>2 then begin
                       StudentNoAcademicYear:=CopyStr("ACA-Course Registration"."Student No.",((StrLen("ACA-Course Registration"."Student No."))-1),2);
                       end;
                    
                      Clear(YOSTewxt);
                      if "ACA-Course Registration"."Year Of Study"=1 then YOSTewxt:='First Year';
                      if "ACA-Course Registration"."Year Of Study"=2 then YOSTewxt:='Second Year';
                      if "ACA-Course Registration"."Year Of Study"=3 then YOSTewxt:='Third Year';
                      if "ACA-Course Registration"."Year Of Study"=4 then YOSTewxt:='Fourth Year';
                      if "ACA-Course Registration"."Year Of Study"=5 then YOSTewxt:='Fifth Year';
                      if "ACA-Course Registration"."Year Of Study"=6 then YOSTewxt:='Sixth Year';
                      if "ACA-Course Registration"."Year Of Study"=7 then YOSTewxt:='Seventh Year';
                      Clear(SchoolName);
                     Clear(pName);
                     prog.Reset;
                     prog.SetRange(Code,"ACA-Course Registration".Programme);
                     if prog.Find('-') then begin
                     pName:=prog.Description;
                      dimVal.Reset;
                      dimVal.SetRange(dimVal."Dimension Code",'SCHOOL');
                      dimVal.SetRange(dimVal.Code,prog."School Code");
                      if dimVal.Find('-') then begin
                       SchoolName:=dimVal.Name;
                      end;
                      end;
                      dimVal.Reset;
                      dimVal.SetRange(dimVal."Dimension Code",'Department');
                      dimVal.SetRange(dimVal.Code,prog."Department Code");
                      if dimVal.Find('-') then begin
                       DeptName:=dimVal.Name;
                     //   dimVal.CALCFIELDS(Signature);
                      end;
                    
                    Clear(YearOfStudy);
                    
                    YearOfStudy:= CopyStr("ACA-Course Registration".Stage,2,1);
                    
                    
                    Clear(sName);
                    Clear(YearOfAdmi);
                    cust.Reset;
                    cust.SetRange(cust."No.","ACA-Course Registration"."Student No.");
                    if cust.Find('-') then begin
                       sName:=cust.Name;
                    end;
                    /*
                    MksCounts.RESET;
                    IF MksCounts.FIND('+') THEN counts:=MksCounts.Serials+1
                    ELSE counts:=1; */
                    
                    Sem.Reset;
                    Sem.SetRange(Sem.Code,"ACA-Course Registration".Semester);
                    if Sem.Find('-') then
                    acadyear:=Sem."Academic Year";
                    
                    ACAResultsStatus.Reset;
                    ACAResultsStatus.SetRange(Code,"ACA-Course Registration"."Supp. Yearly Remarks");
                    if ACAResultsStatus.Find('-') then;
                    
                      if (("ACA-Course Registration"."Yearly Remarks"='EXPELLED') or
                       ("ACA-Course Registration"."Yearly Remarks"='SUSPENDED') or
                       ("ACA-Course Registration"."Yearly Remarks"='EXPULSION')) then begin
                       "ACA-Course Registration"."Supp. Yearly Total Units Taken":=0;
                    "ACA-Course Registration"."Supp. Yearly Weighted Total":=0;
                    "ACA-Course Registration"."Supp. Yearly Passed Units":=0;
                    "ACA-Course Registration"."Supp. Yearly Failed Units":=0;
                    "ACA-Course Registration"."Supp. Yearly CF% Failed":=0;
                    "ACA-Course Registration"."Supp. Yearly Failed Courses":=0;
                    "ACA-Course Registration"."Supp. Yearly Curr. Average":=0;
                       end;
                    
                    Clear(GenCourseSuppExists);
                    // // "ACA-Course Registration".CALCFIELDS("ACA-Course Registration"."Supplementary Exists");
                    // // IF "ACA-Course Registration"."Supplementary Exists" THEN GenCourseSuppExists:=TRUE;

                end;

                trigger OnPostDataItem()
                begin
                     // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
                end;

                trigger OnPreDataItem()
                begin
                     cc:=0;
                      Clear(counts);
                     ACACourseRegistration.CopyFilters("ACA-Course Registration");
                     ACACourseRegistration.SetRange(Reversed,false);
                     ACACourseRegistration.SetCurrentkey(ACACourseRegistration."Year of Admission",ACACourseRegistration."Student No.");
                     if ACACourseRegistration.Find('-') then begin
                        MksCounts.Reset;
                     MksCounts.SetRange(MksCounts."Year of Study",Format(ACACourseRegistration."Year Of Study"));
                     MksCounts.SetRange(MksCounts.Programme,ACACourseRegistration.Programme);
                     MksCounts.SetRange(MksCounts.Option,ACACourseRegistration.Options);
                     MksCounts.SetRange(MksCounts."Academic Year",ACACourseRegistration."Academic Year");
                     if MksCounts.Find('-') then MksCounts.DeleteAll;
                    /*REPEAT
                      BEGIN
                    
                     END;
                     UNTIL ACACourseRegistration.NEXT=0;*/
                     end;
                     /* ELSE BEGIN
                      counts:=MksCounts.Serials;
                      END;*/
                      Clear(counts);
                    "ACA-Course Registration".SetCurrentkey("ACA-Course Registration"."Year of Admission","ACA-Course Registration"."Student No.");

                end;
            }
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          //CompanyInformation.CALCFIELDS(Picture);
          end;
    end;

    trigger OnPreReport()
    begin
          //  IF acadyear='' THEN ERROR('Please specify the academic year.');

    end;

    var
        ACAResultsStatus: Record UnknownRecord61739;
        ACACourseRegistration: Record UnknownRecord61532;
        StudentNoAcademicYear: Code[10];
        counts: Integer;
        MksCounts: Record UnknownRecord69264 temporary;
        pName: Text[250];
        units_Subjects: Record UnknownRecord61517;
        YearOfStudy: Code[10];
        YearOfAdmi: Code[50];
        SchoolName: Text[250];
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
        sName: Text[250];
        cust: Record Customer;
        acadyear: Code[20];
        Sems: Code[20];
        prog: Record UnknownRecord61511;
        dimVal: Record "Dimension Value";
        ProgStages: Record UnknownRecord61516;
        PassRemark: Text[200];
        SemRec: Record UnknownRecord61692;
        Creg: Record UnknownRecord61532;
        IntakeRec: Record UnknownRecord61383;
        DeptName: Text[100];
        i: Integer;
        GLabel: array [10] of Text[200];
        GLabel2: array [10] of Text[200];
        Passmark: Decimal;
        CompanyInformation: Record "Company Information";
        UnitsCount: Integer;
        UnitsFailedCount: Integer;
        TotalMarksCounted: Decimal;
        AverageMarks: Decimal;
        AvrgGrade: Code[1];
        AvrgRemarks: Code[250];
        YearofStudyView: Option " ","1st","2nd","3rd","4th","5th","6th";
        SemesterLoader: Integer;
        ProgramLoader: Integer;
        ScoreLabel: Text[20];
        YOSTewxt: Text[20];
        cc: Integer;
        ACAProgrammeOptions: Record UnknownRecord61554;
        FacDesc: Code[20];
        SuppExists: Boolean;
        GenCourseSuppExists: Boolean;
}

