#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78074 "ACA-Final Cons. Grad. Fin"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Final Cons. Grad. Fin.rdlc';

    dataset
    {
        dataitem(ExamCoreg;UnknownTable66651)
        {
            RequestFilterFields = Programme,"Academic Year","Year of Study","Programme Option";
            column(ReportForNavId_1; 1)
            {
            }
            column(seq;seq)
            {
            }
            column(COmpName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address+', '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(CompPhone;CompanyInformation."Phone No."+','+CompanyInformation."Phone No. 2")
            {
            }
            column(pic;CompanyInformation.Picture)
            {
            }
            column(mails;CompanyInformation."E-Mail"+'/'+CompanyInformation."Home Page")
            {
            }
            column(StudNumber;ExamCoreg."Student Number")
            {
            }
            column(Progs;ExamCoreg.Programme)
            {
            }
            column(ProgName;Programmes.Description)
            {
            }
            column(YearofStudy;ExamCoreg."Year of Study")
            {
            }
            column(AcadYear;ExamCoreg."Academic Year")
            {
            }
            column(StudentName;FormatNames(ExamCoreg."Student Name"))
            {
            }
            column(Dept;ExamCoreg.Department)
            {
            }
            column(SchCode;ExamCoreg."School Code")
            {
            }
            column(DeptName;ExamCoreg."Department Name")
            {
            }
            column(SchName;ExamCoreg."School Name")
            {
            }
            column(Class;ExamCoreg.Classification)
            {
            }
            column(NAverage;ROUND(ExamCoreg."Weighted Average",0.01,'='))
            {
            }
            column(WAverage;ROUND(ExamCoreg."Weighted Average",0.01,'='))
            {
            }
            column(ProgOption;ExamCoreg."Programme Option")
            {
            }
            column(PercentageFailedCourses;ExamCoreg."% Total Failed Courses")
            {
            }
            column(SuppExists;ExamCoreg."Supp/Special Exists")
            {
            }
            column(PercentageFailedUnits;CfFailed)
            {
            }
            column(TotPassedUnits;ExamCoreg."Total Units"-ExamCoreg."Failed Units")
            {
            }
            column(TotalPassed;ExamCoreg."Total Required Passed"+ExamCoreg."Tota Electives Passed"+ExamCoreg."Total Cores Passed")
            {
            }
            column(TotalCourseDone;ExamCoreg."Total Courses")
            {
            }
            column(TotalUnits;ExamCoreg."Total Units")
            {
            }
            column(TotalMarks;ExamCoreg."Total Marks")
            {
            }
            column(TotFailedCourses;ExamCoreg."Total Failed Courses")
            {
            }
            column(TotFailedUnits;ExamCoreg."Total Failed Units")
            {
            }
            column(FailedCourses;ExamCoreg."Failed Courses")
            {
            }
            column(FailedUnits;ExamCoreg."Failed Units")
            {
            }
            column(TotalCoursesPassed;ExamCoreg."Total Required Passed"+ExamCoreg."Tota Electives Passed"+ExamCoreg."Total Cores Passed")
            {
            }
            column(TotWeightedMarks;ExamCoreg."Total Weighted Marks")
            {
            }
            column(ClassOrder;ExamCoreg."Final Classification Order")
            {
            }
            dataitem(ExamClassUnits;UnknownTable66650)
            {
                CalcFields = "Comsolidated Prefix","Grade Comment",Grade,Pass,"Unit Stage";
                DataItemLink = "Student No."=field("Student Number"),Programme=field(Programme),"Academic Year"=field("Academic Year"),"Year of Study"=field("Year of Study");
                column(ReportForNavId_30; 30)
                {
                }
                column(UnitCode;ExamClassUnits."Unit Code")
                {
                }
                column(UnitDescription;ExamClassUnits."Unit Description")
                {
                }
                column(CreditHours;ExamClassUnits."Credit Hours")
                {
                }
                column(CATScore;ExamClassUnits."CAT Score")
                {
                }
                column(ExamScore;ExamClassUnits."Exam Score")
                {
                }
                column(TotalScore;ExamClassUnits."Total Score")
                {
                }
                column(Pass;ExamClassUnits.Pass)
                {
                }
                column(UnitYearOfStudy;ExamClassUnits."Year of Study")
                {
                }
                column(ExamScoreDecimal;ExamClassUnits."Exam Score Decimal")
                {
                }
                column(CATScoreDecimal;ExamClassUnits."CAT Score Decimal")
                {
                }
                column(TotalScoreDecimal;ExamClassUnits."Total Score Decimal")
                {
                }
                column(UnitGrade;ExamClassUnits.Grade)
                {
                }
                column(UnitSchoolCode;ExamClassUnits."School Code")
                {
                }
                column(UnitDepartmentCode;ExamClassUnits."Department Code")
                {
                }
                column(GradeComment;ExamClassUnits."Grade Comment")
                {
                }
                column(Prefix;ExamClassUnits."Comsolidated Prefix")
                {
                }
                column(isRepeatOrResit;ExamClassUnits."Is a Resit/Repeat")
                {
                }
                column(UnitStage;ExamClassUnits."Unit Stage")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if ((ExamCoreg."Final Classification"='DISCIPLINERY') or (ExamCoreg."Final Classification"='DISCIPLINARY')) then begin
                        ExamClassUnits."Comsolidated Prefix":='';
                        ExamClassUnits."Total Score":='';
                        ExamClassUnits."Total Score Decimal":=0;
                      end;
                    Clear(ACASuppExamClassUnits);
                    ACASuppExamClassUnits.Reset;
                    ACASuppExamClassUnits.SetRange("Student No.",ExamClassUnits."Student No.");
                    ACASuppExamClassUnits.SetRange("Unit Code",ExamClassUnits."Unit Code");
                    ACASuppExamClassUnits.SetRange("Academic Year",ExamClassUnits."Academic Year");
                    if ACASuppExamClassUnits.Find('-') then begin
                      ACASuppExamClassUnits.CalcFields(Pass,"Is a Resit/Repeat","Comsolidated Prefix");
                      ExamClassUnits."Exam Score":=ACASuppExamClassUnits."Exam Score";
                      ExamClassUnits."Total Score":=ACASuppExamClassUnits."Total Score";
                      ExamClassUnits.Pass:=ACASuppExamClassUnits.Pass;
                      ExamClassUnits."Total Score":=ACASuppExamClassUnits."Total Score";
                      ExamClassUnits."Exam Score Decimal":=ACASuppExamClassUnits."Exam Score Decimal";
                      ExamClassUnits."Total Score Decimal":=ACASuppExamClassUnits."Total Score Decimal";
                      ExamClassUnits."Comsolidated Prefix":=ACASuppExamClassUnits."Comsolidated Prefix";
                      ExamClassUnits."Is a Resit/Repeat":=ACASuppExamClassUnits."Is a Resit/Repeat";
                      end else begin
                    Clear(ACASuppExamClassUnits1);
                    ACASuppExamClassUnits1.Reset;
                    ACASuppExamClassUnits1.SetRange("Student No.",ExamClassUnits."Student No.");
                    ACASuppExamClassUnits1.SetRange("Unit Code",ExamClassUnits."Unit Code");
                    ACASuppExamClassUnits1.SetRange("Academic Year",ExamClassUnits."Academic Year");
                    if ACASuppExamClassUnits1.Find('-') then begin
                      ACASuppExamClassUnits1.CalcFields(Pass,"Is a Resit/Repeat","Comsolidated Prefix");
                      ExamClassUnits."Exam Score":=ACASuppExamClassUnits1."Exam Score";
                      ExamClassUnits."Total Score":=ACASuppExamClassUnits1."Total Score";
                      ExamClassUnits.Pass:=ACASuppExamClassUnits1.Pass;
                      ExamClassUnits."Total Score":=ACASuppExamClassUnits1."Total Score";
                      ExamClassUnits."Exam Score Decimal":=ACASuppExamClassUnits1."Exam Score Decimal";
                      ExamClassUnits."Total Score Decimal":=ACASuppExamClassUnits1."Total Score Decimal";
                      ExamClassUnits."Comsolidated Prefix":=ACASuppExamClassUnits1."Comsolidated Prefix";
                      ExamClassUnits."Is a Resit/Repeat":=ACASuppExamClassUnits1."Is a Resit/Repeat";
                      end;
                        end;
                      Clear(ACAUnitsSubjects);
                      ACAUnitsSubjects.Reset;
                      ACAUnitsSubjects.SetRange(Code,ExamClassUnits."Unit Code");
                      ACAUnitsSubjects.SetRange("Programme Code",ExamClassUnits.Programme);
                      if ACAUnitsSubjects.Find('-') then;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Clear(Programmes);
                Programmes.Reset;
                Programmes.SetRange(Code,ExamCoreg.Programme);
                if Programmes.Find('-') then;
                seq:=seq+1;
                Clear(ACASuppExamCoReg);
                ACASuppExamCoReg.Reset;
                ACASuppExamCoReg.SetRange("Student Number",ExamCoreg."Student Number");
                ACASuppExamCoReg.SetRange(Programme,ExamCoreg.Programme);
                ACASuppExamCoReg.SetRange("Year of Study",ExamCoreg."Year of Study");
                ACASuppExamCoReg.SetRange("Academic Year",ExamCoreg."Academic Year");
                ACASuppExamCoReg.SetRange("Reporting Academic Year",ExamCoreg."Reporting Academic Year");
                if ACASuppExamCoReg.Find('-') then begin
                  ACASuppExamCoReg.CalcFields(ACASuppExamCoReg."Total Units",ACASuppExamCoReg."Failed Units",ACASuppExamCoReg."Total Required Passed",
                ACASuppExamCoReg."Tota Electives Passed",ACASuppExamCoReg."Total Cores Passed",ACASuppExamCoReg."Total Courses",
                ACASuppExamCoReg."Total Units",ACASuppExamCoReg."Total Marks",ACASuppExamCoReg."Total Failed Courses",ACASuppExamCoReg."Total Failed Units",
                ACASuppExamCoReg."Failed Courses",ACASuppExamCoReg."Failed Units",ACASuppExamCoReg."Total Required Passed",
                ACASuppExamCoReg."Tota Electives Passed",ACASuppExamCoReg."Total Cores Passed",ACASuppExamCoReg."Total Weighted Marks");
                ExamCoreg.Classification:=ACASuppExamCoReg.Classification;
                ExamCoreg."Normal Average":=ACASuppExamCoReg."Normal Average";
                ExamCoreg."Weighted Average":=ACASuppExamCoReg."Weighted Average";
                ExamCoreg."% Total Failed Courses":=ACASuppExamCoReg."% Total Failed Courses";
                ExamCoreg."Total Units":=ACASuppExamCoReg."Total Units";
                ExamCoreg."Failed Units":=ACASuppExamCoReg."Failed Units";
                ExamCoreg."Total Required Passed":=ACASuppExamCoReg."Total Required Passed";
                ExamCoreg."Tota Electives Passed":=ACASuppExamCoReg."Tota Electives Passed";
                ExamCoreg."Total Cores Passed":=ACASuppExamCoReg."Total Cores Passed";
                ExamCoreg."Total Courses":=ACASuppExamCoReg."Total Courses";
                ExamCoreg."Total Units":=ACASuppExamCoReg."Total Units";
                ExamCoreg."Total Marks":=ACASuppExamCoReg."Total Marks";
                ExamCoreg."Total Failed Courses":=ACASuppExamCoReg."Total Failed Courses";
                ExamCoreg."Total Failed Units":=ACASuppExamCoReg."Total Failed Units";
                ExamCoreg."Failed Courses":=ACASuppExamCoReg."Failed Courses";
                ExamCoreg."Failed Units":=ACASuppExamCoReg."Failed Units";
                ExamCoreg."Total Required Passed":=ACASuppExamCoReg."Total Required Passed";
                ExamCoreg."Tota Electives Passed":=ACASuppExamCoReg."Tota Electives Passed";
                ExamCoreg."Total Cores Passed":=ACASuppExamCoReg."Total Cores Passed";
                ExamCoreg."Total Weighted Marks":=ACASuppExamCoReg."Total Weighted Marks";
                ExamCoreg."Final Classification Order":=ACASuppExamCoReg."Final Classification Order";
                end else begin
                Clear(ACASuppExamCoReg1);
                ACASuppExamCoReg1.Reset;
                ACASuppExamCoReg1.SetRange("Student Number",ExamCoreg."Student Number");
                ACASuppExamCoReg1.SetRange(Programme,ExamCoreg.Programme);
                ACASuppExamCoReg1.SetRange("Year of Study",ExamCoreg."Year of Study");
                ACASuppExamCoReg1.SetRange("Academic Year",ExamCoreg."Academic Year");
                ACASuppExamCoReg1.SetRange("Reporting Academic Year",ExamCoreg."Reporting Academic Year");
                if ACASuppExamCoReg1.Find('-') then begin
                  ACASuppExamCoReg1.CalcFields(ACASuppExamCoReg1."Total Units",ACASuppExamCoReg1."Failed Units",ACASuppExamCoReg1."Total Required Passed",
                ACASuppExamCoReg1."Tota Electives Passed",ACASuppExamCoReg1."Total Cores Passed",ACASuppExamCoReg1."Total Courses",
                ACASuppExamCoReg1."Total Units",ACASuppExamCoReg1."Total Marks",ACASuppExamCoReg1."Total Failed Courses",ACASuppExamCoReg1."Total Failed Units",
                ACASuppExamCoReg1."Failed Courses",ACASuppExamCoReg1."Failed Units",ACASuppExamCoReg1."Total Required Passed",
                ACASuppExamCoReg1."Tota Electives Passed",ACASuppExamCoReg1."Total Cores Passed",ACASuppExamCoReg1."Total Weighted Marks");
                ExamCoreg.Classification:=ACASuppExamCoReg1.Classification;
                ExamCoreg."Normal Average":=ACASuppExamCoReg1."Normal Average";
                ExamCoreg."Weighted Average":=ACASuppExamCoReg1."Weighted Average";
                ExamCoreg."% Total Failed Courses":=ACASuppExamCoReg1."% Total Failed Courses";
                ExamCoreg."Total Units":=ACASuppExamCoReg1."Total Units";
                ExamCoreg."Failed Units":=ACASuppExamCoReg1."Failed Units";
                ExamCoreg."Total Required Passed":=ACASuppExamCoReg1."Total Required Passed";
                ExamCoreg."Tota Electives Passed":=ACASuppExamCoReg1."Tota Electives Passed";
                ExamCoreg."Total Cores Passed":=ACASuppExamCoReg1."Total Cores Passed";
                ExamCoreg."Total Courses":=ACASuppExamCoReg1."Total Courses";
                ExamCoreg."Total Units":=ACASuppExamCoReg1."Total Units";
                ExamCoreg."Total Marks":=ACASuppExamCoReg1."Total Marks";
                ExamCoreg."Total Failed Courses":=ACASuppExamCoReg1."Total Failed Courses";
                ExamCoreg."Total Failed Units":=ACASuppExamCoReg1."Total Failed Units";
                ExamCoreg."Failed Courses":=ACASuppExamCoReg1."Failed Courses";
                ExamCoreg."Failed Units":=ACASuppExamCoReg1."Failed Units";
                ExamCoreg."Total Required Passed":=ACASuppExamCoReg1."Total Required Passed";
                ExamCoreg."Tota Electives Passed":=ACASuppExamCoReg1."Tota Electives Passed";
                ExamCoreg."Total Cores Passed":=ACASuppExamCoReg1."Total Cores Passed";
                ExamCoreg."Total Weighted Marks":=ACASuppExamCoReg1."Total Weighted Marks";
                ExamCoreg."Final Classification Order":=ACASuppExamCoReg1."Final Classification Order";
                end;
                  end;
                ExamCoreg.CalcFields("Weighted Average","Normal Average");
                // ,"Total Courses","Total Units",
                // "Total Marks","Total Failed Courses","Total Failed Units","Failed Courses","Failed Units",
                // "Total Cores Passed","Tota Electives Passed","Total Required Passed",
                // "Total Cores Done","Total Required Done","Total Electives Done","Supp/Special Exists"
                if ExamCoreg."Total Units">0 then begin
                 CfFailed:=ExamCoreg."Total Failed Units"/ExamCoreg."Total Units";
                  CfFailed:=CfFailed*100;
                 // CfFailed:=ROUND(CfFailed,0.01,'=')*100;
                 end;
                 if ExamCoreg."Total Units">0 then begin
                   ExamCoreg."Weighted Average":=ExamCoreg."Total Weighted Marks"/ExamCoreg."Total Units";
                   end;
            end;

            trigger OnPreDataItem()
            begin
                Clear(seq);
                if ExamCoreg.GetFilter(Programme)='' then Error('Specify a programme');
                if ExamCoreg.GetFilter("Academic Year")='' then Error('Specify Academic year');
                if ExamCoreg.GetFilter("Year of Study")='' then Error('Specify Year of Study');
                // ACAProgrammeOptions.RESET;
                // ACAProgrammeOptions.SETRANGE("Programme Code",ExamCoreg.GETFILTER(Programme));
                // ACAProgrammeOptions.SETFILTER(Code,'<>%1','');
                // IF ACAProgrammeOptions.FIND('-') THEN BEGIN
                //  END;
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then CompanyInformation.CalcFields(Picture);
    end;

    trigger OnPreReport()
    begin
        if ExamCoreg.GetFilter(Programme)='' then Error('Specify a programme filter.');
    end;

    var
        CompanyInformation: Record "Company Information";
        DimensionValue: Record "Dimension Value";
        ACAUnitsSubjects: Record UnknownRecord61517;
        seq: Integer;
        ACAProgrammeOptions: Record UnknownRecord61554;
        CfFailed: Decimal;
        ACASuppExamClassUnits: Record UnknownRecord66681;
        ACASuppExamCoReg: Record UnknownRecord66682;
        Programmes: Record UnknownRecord61511;
        ACASuppExamCoReg1: Record UnknownRecord66642;
        ACASuppExamClassUnits1: Record UnknownRecord66641;

    local procedure FormatNames(CommonName: Text[250]) NewName: Text[250]
    var
        NamesSmall: Text[250];
        FirsName: Text[250];
        SpaceCount: Integer;
        SpaceFound: Boolean;
        Counts: Integer;
        Strlegnth: Integer;
        OtherNames: Text[250];
        FormerCommonName: Text[250];
        OneSpaceFound: Boolean;
        Countings: Integer;
    begin
        /*CLEAR(OneSpaceFound);
        CLEAR(Countings);
        CommonName:=CONVERTSTR(CommonName,',',' ');
           FormerCommonName:='';
          REPEAT
           BEGIN
          Countings+=1;
          IF COPYSTR(CommonName,Countings,1)=' ' THEN BEGIN
           IF OneSpaceFound=FALSE THEN FormerCommonName:=FormerCommonName+COPYSTR(CommonName,Countings,1);
            OneSpaceFound:=TRUE
           END ELSE BEGIN
             OneSpaceFound:=FALSE;
             FormerCommonName:=FormerCommonName+COPYSTR(CommonName,Countings,1)
           END;
           END;
             UNTIL Countings=STRLEN(CommonName);
             CommonName:=FormerCommonName;
        CLEAR(NamesSmall);
        CLEAR(FirsName);
        CLEAR(SpaceCount);
        CLEAR(SpaceFound);
        CLEAR(OtherNames);
        IF STRLEN(CommonName)>100 THEN  CommonName:=COPYSTR(CommonName,1,100);
        Strlegnth:=STRLEN(CommonName);
        IF STRLEN(CommonName)>4 THEN BEGIN
          NamesSmall:=LOWERCASE(CommonName);
          REPEAT
            BEGIN
              SpaceCount+=1;
              IF ((COPYSTR(NamesSmall,SpaceCount,1)='') OR (COPYSTR(NamesSmall,SpaceCount,1)=' ') OR (COPYSTR(NamesSmall,SpaceCount,1)=',')) THEN SpaceFound:=TRUE;
              IF NOT SpaceFound THEN BEGIN
                FirsName:=FirsName+UPPERCASE(COPYSTR(NamesSmall,SpaceCount,1));
                END ELSE  BEGIN
                  IF STRLEN(OtherNames)<150 THEN BEGIN
                IF ((COPYSTR(NamesSmall,SpaceCount,1)='') OR (COPYSTR(NamesSmall,SpaceCount,1)=' ') OR (COPYSTR(NamesSmall,SpaceCount,1)=',')) THEN BEGIN
                  OtherNames:=OtherNames+' ';
                SpaceCount+=1;
                  OtherNames:=OtherNames+UPPERCASE(COPYSTR(NamesSmall,SpaceCount,1));
                  END ELSE BEGIN
                  OtherNames:=OtherNames+COPYSTR(NamesSmall,SpaceCount,1);
                    END;
        
                END;
                END;
            END;
              UNTIL ((SpaceCount=Strlegnth))
          END;
          CLEAR(NewName);
        NewName:=FirsName+','+OtherNames;*/
        NewName:=CommonName;

    end;
}

