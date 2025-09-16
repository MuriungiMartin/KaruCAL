#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78061 "ACA-Grad. Cons. Marksheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Grad. Cons. Marksheet.rdlc';

    dataset
    {
        dataitem(ExamCoreg;UnknownTable66651)
        {
            CalcFields = "Total Courses","Total Units","Total Marks","Total Failed Courses","Total Failed Units","Failed Courses","Failed Units","Total Cores Passed","Tota Electives Passed","Total Required Passed","Total Cores Done","Total Required Done","Total Electives Done","Supp/Special Exists","Prog. Option Name","Programme Name";
            RequestFilterFields = Programme,"Academic Year","Graduation Academic Year","Year of Study","Programme Option";
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
            column(NAverage;ROUND(ExamCoreg."Normal Average",0.01,'='))
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
            column(serials;AcaFinalConsMksCount.Serial)
            {
            }
            column(Progname;ExamCoreg."Programme Name")
            {
            }
            column(ProgOptionName;ExamCoreg."Prog. Option Name")
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
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                seq:=seq+1;
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
                end;
                if ExamCoreg."Total Units">0 then begin
                 CfFailed:=ExamCoreg."Total Failed Units"/ExamCoreg."Total Units";
                  CfFailed:=CfFailed*100;
                 // CfFailed:=ROUND(CfFailed,0.01,'=')*100;
                 end;

                AcaFinalConsMksCount.Reset;
                AcaFinalConsMksCount.SetRange("Student No.",ExamCoreg."Student Number");
                AcaFinalConsMksCount.SetRange("User Names",UserId);
                AcaFinalConsMksCount.SetRange("Graduation Academic Year",ExamCoreg."Graduation Academic Year");
                AcaFinalConsMksCount.SetRange("Academic Year",ExamCoreg."Academic Year");
                AcaFinalConsMksCount.SetRange("Program Option",ExamCoreg."Programme Option");
                AcaFinalConsMksCount.SetRange(Programme,ExamCoreg.Programme);
                AcaFinalConsMksCount.SetRange("Year of Study",ExamCoreg."Year of Study");
                if AcaFinalConsMksCount.Find('-') then;
            end;

            trigger OnPreDataItem()
            begin
                Clear(seq);
                if ExamCoreg.GetFilter(Programme)='' then Error('Specify a programme');
                if ExamCoreg.GetFilter("Graduation Academic Year")='' then Error('Specify Academic year');
                if ExamCoreg.GetFilter("Year of Study")='' then Error('Specify Year of Study');
                if ExamCoreg.GetFilter("Academic Year")='' then Error('Specify the Academic Year');
                // ACAProgrammeOptions.RESET;
                // ACAProgrammeOptions.SETRANGE("Programme Code",ExamCoreg.GETFILTER(Programme));
                // ACAProgrammeOptions.SETFILTER(Code,'<>%1','');
                // IF ACAProgrammeOptions.FIND('-') THEN BEGIN
                //  END;
                ExamCoregForNumber.CopyFilters(ExamCoreg);
                ExamCoregForNumber.SetCurrentkey("Student Number");
                if ExamCoregForNumber.Find('-') then begin
                    repeat
                      begin
                      //
                      AcaFinalConsMksCount.Init;
                      AcaFinalConsMksCount."User Names":=UserId;
                      AcaFinalConsMksCount."Program Option":=ExamCoregForNumber."Programme Option";
                      AcaFinalConsMksCount.Programme:=ExamCoregForNumber.Programme;
                      AcaFinalConsMksCount."Graduation Academic Year":=ExamCoregForNumber."Graduation Academic Year";
                      AcaFinalConsMksCount."Academic Year":=ExamCoregForNumber."Academic Year";
                      AcaFinalConsMksCount."Student No.":=ExamCoregForNumber."Student Number";
                      AcaFinalConsMksCount."Year of Study":=ExamCoregForNumber."Year of Study";
                      if  AcaFinalConsMksCount.Insert then;
                      end;
                      until ExamCoregForNumber.Next=0;
                  end;
                  AcaFinalConsMksCount.Reset;
                  AcaFinalConsMksCount.SetCurrentkey("Student No.");
                  if AcaFinalConsMksCount.Find('-') then begin
                    Clear(seqs);
                    repeat
                      begin
                        seqs:=seqs+1;
                        AcaFinalConsMksCount.Serial:=seqs;
                        AcaFinalConsMksCount.Modify;
                      end;
                        until AcaFinalConsMksCount.Next=0;
                    end;
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
        ACASuppExamClassUnits: Record UnknownRecord66641;
        ACASuppExamCoReg: Record UnknownRecord66642;
        ExamCoregForNumber: Record UnknownRecord66651;
        AcaFinalConsMksCount: Record UnknownRecord77745 temporary;
        seqs: Integer;

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

