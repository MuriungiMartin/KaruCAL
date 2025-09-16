#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78040 "ACA-Consolidated Marksheet 1"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Consolidated Marksheet 1.rdlc';

    dataset
    {
        dataitem(ExamCoreg;UnknownTable66651)
        {
            RequestFilterFields = Programme,"Academic Year","Year of Study","Programme Option";
            column(ReportForNavId_1; 1)
            {
            }
            column(exclude;ExamCoreg."Academic Year Exclude Comp.")
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
            column(mails;CompanyInformation."E-Mail")
            {
            }
            column(StudNumber;ExamCoreg."Student Number")
            {
            }
            column(Progs;ExamCoreg.Programme)
            {
            }
            column(progNames;ExamCoreg."Programme Name")
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
            column(OptionNames;ExamCoreg."Prog. Option Name")
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
                DataItemLink = "Student No."=field("Student Number"),Programme=field(Programme),"Year of Study"=field("Year of Study"),"Academic Year"=field("Academic Year");
                DataItemTableView = sorting("Student No.","Unit Code",Programme,"Academic Year") order(ascending) where("Unit Code"=filter(<>""));
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
                end;
            }

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
                Clear(CfFailed);

                if ExamCoreg."Total Units">0 then begin
                 CfFailed:=(ExamCoreg."Total Failed Units"/ExamCoreg."Total Units")*100;
                // CfFailed:=ROUND(ExamCoreg."Total Failed Units"/ExamCoreg."Total Units",0.01,'=')*100;
                 end;
                 ExamCoreg.CalcFields("Weighted Average","Normal Average","Total Courses",
                 "Total Units","Total Marks","Total Failed Courses","Total Failed Units","Failed Courses",
                 "Failed Units","Total Cores Passed","Tota Electives Passed","Total Required Passed",
                 "Total Cores Done","Total Required Done","Total Electives Done","Academic Year Exclude Comp.");

                if (ExamCoreg."Academic Year Exclude Comp.") then begin
                CfFailed :=0;
                ExamCoreg."Total Failed Units" :=0;
                //ExamCoreg."Total Units" :=0;
                ExamCoreg."Failed Units" :=0;
                ExamCoreg."Failed Courses" :=0;
                ExamCoreg."Normal Average" :=0;
                ExamCoreg."Total Weighted Marks" :=0;
                ExamCoreg."Weighted Average":=0;
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
                // // ACAProgrammeOptions.RESET;
                // // ACAProgrammeOptions.SETRANGE("Programme Code",ExamCoreg.GETFILTER(Programme));
                // // ACAProgrammeOptions.SETFILTER(Code,'<>%1','');
                // // IF ACAProgrammeOptions.FIND('-') THEN BEGIN
                // // IF ExamCoreg.GETFILTER("Programme Option")='' THEN ERROR('Specify Programme option');
                // //  END;
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
        if CompanyInformation.Find('-') then;// CompanyInformation.CALCFIELDS(Picture);
        // // ACAExamFilters.RESET;
        // // ACAExamFilters.SETRANGE("UserID/Name",USERID);
        // // IF ACAExamFilters.FIND('-') THEN BEGIN
        // //    ExamCoreg.GETFILTER.SETFILTER(Programme,ACAExamFilters."Program Filter");
        // //    ExamCoreg.SETFILTER("Programme Option",ACAExamFilters."Programme Option Filter");
        // //    ExamCoreg.SETFILTER("Academic Year",ACAExamFilters."Academic Year");
        // //    IF ACAExamFilters."Year of Study"<>0 THEN
        // //    ExamCoreg.SETFILTER("Year of Study",'%1',ACAExamFilters."Year of Study");
        // //  END;
    end;

    trigger OnPostReport()
    begin
        Clear(YosText);
        if Evaluate(YosText,ExamCoreg.GetFilter(ExamCoreg."Year of Study")) then;
        // // ACAExamFilters.RESET;
        // // ACAExamFilters.SETRANGE("UserID/Name",USERID);
        // // IF ACAExamFilters.FIND('-') THEN BEGIN
        // //    ACAExamFilters."Program Filter":=ExamCoreg.GETFILTER(ExamCoreg.Programme);
        // //    ACAExamFilters."Programme Option Filter":=ExamCoreg.GETFILTER(ExamCoreg."Programme Option");
        // //    ACAExamFilters."Year of Study":=YosText;
        // //    ACAExamFilters."Academic Year":=ExamCoreg.GETFILTER(ExamCoreg."Academic Year");
        // //    ACAExamFilters.MODIFY;
        // //  END ELSE BEGIN
        // //    ACAExamFilters.INIT;
        // //    ACAExamFilters."UserID/Name":=USERID;
        // //    ACAExamFilters."Program Filter":=ExamCoreg.GETFILTER(ExamCoreg.Programme);
        // //    ACAExamFilters."Programme Option Filter":=ExamCoreg.GETFILTER(ExamCoreg."Programme Option");
        // //    ACAExamFilters."Year of Study":=YosText;
        // //    ACAExamFilters."Academic Year":=ExamCoreg.GETFILTER(ExamCoreg."Academic Year");
        // //    ACAExamFilters.INSERT;
        // //    END;
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
        ACAExamFilters: Record UnknownRecord77704;
        YosText: Integer;

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
        NewName:=FirsName+','+OtherNames;
        */
        NewName:=CommonName;

    end;
}

