#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66666 "Final Transcript"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Final Transcript.rdlc';
    Caption = 'Final Transcript';

    dataset
    {
        dataitem(Coregs;UnknownTable66631)
        {
            CalcFields = "Admissions Date","Graduation Date","Academic Year";
            DataItemTableView = sorting("Student Number",Programme,"Year of Study","Graduation Academic Year") order(ascending) where(Graduating=filter(Yes));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "School Code",Programme,"Student Number","Graduation Academic Year","Year of Study","Academic Year";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(StudNo;Coregs."Student Number")
            {
            }
            column(ProgClassInt;ProgClassInt)
            {
            }
            column(Prog;Coregs.Programme)
            {
            }
            column(Sem;'')
            {
            }
            column(Stag;'')
            {
            }
            column(CumSc;Coregs."Total Marks")
            {
            }
            column(CurrSem;Coregs."Total Marks")
            {
            }
            column(AdmissionDates;ACAAcademicYear369."Admission Date")
            {
            }
            column(GradDates;Coregs."Graduation Date")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(YoS;Coregs."Year of Study")
            {
            }
            column(TotalYearlyMarks;Coregs."Total Marks")
            {
            }
            column(TRemarks;Coregs."Transcript Comments")
            {
            }
            column(YearlyAverage;Coregs."Normal Average")
            {
            }
            column(acadYear;Coregs."Academic Year")
            {
            }
            column(YearlyGrade;Coregs."Final Classification Grade")
            {
            }
            column(classification;Coregs.Classification)
            {
            }
            column(YearlyFailed;Coregs."Failed Courses")
            {
            }
            column(TotalCourses;Coregs."Total Courses")
            {
            }
            column(TotalUnits;Coregs."Total Units")
            {
            }
            column(YearlyRemarks;TransCriptRemarks)
            {
            }
            column(AcadYearz;Coregs."Graduation Academic Year")
            {
            }
            column(sName;UpperCase(sName))
            {
            }
            column(pName;pName)
            {
            }
            column(GRADDATE;GRADDATE)
            {
            }
            column(YearOfStudy;Coregs."Year of Study")
            {
            }
            column(YoSTested;TextedYos)
            {
            }
            column(YearOfAdmi;Coregs."Admission Academic Year")
            {
            }
            column(SchoolNamez;Coregs."School Name")
            {
            }
            column(acadyearz2;Coregs."Graduation Academic Year")
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
            column(signedSignature;dimVal.Signature)
            {
            }
            column(TranscriptSignatory;dimVal."HOD Names")
            {
            }
            column(TransCriptTitle;dimVal.Titles)
            {
            }
            column(ExamCategory;prog."Exam Category")
            {
            }
            column(FacultyName;UpperCase(dimVal."Faculty Name"))
            {
            }
            column(codSchool;'COD, '+SchoolName)
            {
            }
            column(codDept;'COD,'+DeptName)
            {
            }
            column(dateSigned;'Date:.......................................................')
            {
            }
            column(PassRemarks;PassRemark)
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
            column(LegendRange1;LegendRange[1])
            {
            }
            column(LegendGrade1;LegendGrade[1])
            {
            }
            column(LegendDesc1;LegendDesc[1])
            {
            }
            column(LegendRange2;LegendRange[2])
            {
            }
            column(LegendGrade2;LegendGrade[2])
            {
            }
            column(LegendDesc2;LegendDesc[2])
            {
            }
            column(LegendRange3;LegendRange[3])
            {
            }
            column(LegendGrade3;LegendGrade[3])
            {
            }
            column(LegendDesc3;LegendDesc[3])
            {
            }
            column(LegendRange4;LegendRange[4])
            {
            }
            column(LegendGrade4;LegendGrade[4])
            {
            }
            column(LegendDesc4;LegendDesc[4])
            {
            }
            column(LegendRange5;LegendRange[5])
            {
            }
            column(LegendGrade5;LegendGrade[5])
            {
            }
            column(LegendDesc5;LegendDesc[5])
            {
            }
            column(LegendRange6;LegendRange[6])
            {
            }
            column(LegendGrade6;LegendGrade[6])
            {
            }
            column(LegendDesc6;LegendDesc[6])
            {
            }
            column(RegAcadLabel;'Registrar, Academic Affairs')
            {
            }
            column(PassGrade;PassGrade)
            {
            }
            dataitem(UnitsReg;UnknownTable66632)
            {
                DataItemLink = "Student No."=field("Student Number"),Programme=field(Programme),"Year of Study"=field("Year of Study"),"Graduation Academic Year"=field("Graduation Academic Year");
                DataItemTableView = sorting("Student No.","Unit Code",Programme,"Graduation Academic Year") order(ascending);
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                column(Unit;UnitsReg."Unit Code")
                {
                }
                column(Desc;UnitsReg."Unit Description")
                {
                }
                column(Score;UnitsReg."Total Score Decimal")
                {
                }
                column(Final;UnitsReg."Weighted Total Score")
                {
                }
                column(Grade;UnitsReg.Grade)
                {
                }
                column(Status;'')
                {
                }
                column(AcadHours;units_Subjects."Academic Hours")
                {
                }
                column(CreditHours;UnitsReg."Credit Hours")
                {
                }

                trigger OnAfterGetRecord()
                begin
                     units_Subjects.Reset;
                     units_Subjects.SetRange("Programme Code",UnitsReg.Programme);
                     units_Subjects.SetRange(Code,UnitsReg."Unit Code");
                     units_Subjects.SetRange("Old Unit",false);
                     if units_Subjects.Find('-') then begin

                       end;
                    if UnitsReg.Grade='P' then PExists:=true;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                  PassRemarks:='';
                  PassGrade:='';
                ACAClassificationUnits369.Reset;
                ACAClassificationUnits369.SetRange("Student No.",Coregs."Student Number");
                ACAClassificationUnits369.SetRange("Year of Study",Coregs."Year of Study");
                ACAClassificationUnits369.SetRange(Programme,Coregs.Programme);
                ACAClassificationUnits369.SetRange(Grade,'P');
                if ACAClassificationUnits369.Find('-') then begin
                  PassRemarks:='PASS';
                  PassGrade:='P';
                  end;
                TextedYos:=ConvertDecimalToText.GetNthTextEquivalent(Format(Coregs."Year of Study"));
                  ACACourseRegistration369.Reset;
                  ACACourseRegistration369.SetRange("Student No.",Coregs."Student Number");
                  ACACourseRegistration369.SetFilter(Reversed,'%1',false);
                  ACACourseRegistration369.SetCurrentkey(Semester);
                  if ACACourseRegistration369.Find('-') then begin
                    Sem.Reset;
                    Sem.SetRange(Code,ACACourseRegistration369.Semester);
                    if Sem.Find('-') then begin
                   ACAAcademicYear369.Reset;
                   ACAAcademicYear369.SetRange(Code,Sem."Academic Year");
                   if ACAAcademicYear369.Find('-') then   begin
                      //Coregs."Admissions Date":=ACAAcademicYear369."Admission Date";
                     end;
                     end;
                   end;

                Clear(LegendDesc);
                Clear(LegendGrade);
                Clear(LegendRange);
                Clear(Countings);
                 Clear(SchoolName);
                 Clear(Countings);
                 Clear(ProgClassInt);
                 prog.Reset;
                 prog.SetRange(Code,Coregs.Programme);
                 if prog.Find('-') then
                  begin
                 if prog."Special Programme Class"=prog."special programme class"::"Medicine & Nursing" then ProgClassInt:='B'
                 else if prog."Special Programme Class"=prog."special programme class"::General then   ProgClassInt:='A';
                 if ((prog.Category=prog.Category::"Certificate ")
                   or (prog.Category=prog.Category::Professional)
                   or (prog.Category=prog.Category::Diploma)
                   or (prog.Category=prog.Category::"Course List")) then ProgClassInt:='C';
                   prog.TestField("Exam Category");
                    ACAExamGraddingSetup.Reset;
                   ACAExamGraddingSetup.SetRange(Category,prog."Exam Category");
                   if ACAExamGraddingSetup.SetCurrentkey(Grade) then;
                                   if ACAExamGraddingSetup.Find('-') then begin
                                     repeat
                                       begin
                                     Countings +=1;
                                     LegendDesc[Countings]:=ACAExamGraddingSetup.Description;
                                     LegendGrade[Countings]:=ACAExamGraddingSetup.Grade;
                                     LegendRange[Countings]:=ACAExamGraddingSetup.Range;
                                     end;
                                     until ACAExamGraddingSetup.Next=0;
                                     end;
                 pName:=prog.Description;
                  dimVal.Reset;
                  dimVal.SetRange(dimVal."Dimension Code",'FACULTY');
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
                  end;

                Clear(YearOfStudy);

                YearOfStudy:= Format(Coregs."Year of Study");

                Clear(sName);
                Clear(YearOfAdmi);
                Clear(GRADDATE);
                cust.Reset;
                cust.SetRange(cust."No.",Coregs."Student Number");
                if cust.Find('-') then begin
                   sName:=cust.Name;

                end;



                i:=1;
                Gradings.Reset;
                Gradings.SetRange(Gradings.Category,prog."Exam Category");
                Gradings.SetFilter(Grade,'<>%1&<>%2','X','!');
                Gradings.Ascending:=false;
                if Gradings.Find('-') then begin
                repeat
                GLabel[i]:=Gradings.Grade+'   ('+Gradings.Range+') - '+Gradings.Description;
                GLabel2[i]:=' - '+Gradings.Description;
                if Gradings.Failed=true then
                Passmark:=ROUND(Gradings."Up to",1);
                i:=i+1;
                until Gradings.Next=0;
                end;


                Clear(TransCriptRemarks);
                Clear(PassRemark);
                        ACAProgCatTranscriptComm.Reset;
                        ACAProgCatTranscriptComm.SetRange("Exam Catogory",prog."Exam Category");
                        ACAProgCatTranscriptComm.SetRange("Year of Study",Coregs."Year of Study");
                        if ACAProgCatTranscriptComm.Find('-') then begin
                          if Coregs."Final Classification Pass" then begin
                            PassRemark:=ACAProgCatTranscriptComm."Pass Comment";
                            if ACAProgCatTranscriptComm."Include Programme Name" then PassRemark:=PassRemark+' '+UpperCase(prog.Description);
                            if ACAProgCatTranscriptComm."Include Classification" then PassRemark:=PassRemark+' '+Coregs.Classification;
                          end else begin
                            PassRemark:=ACAProgCatTranscriptComm."Failed Comment";
                            //PassRemark:=UPPERCASE(PassRemark);
                            TransCriptRemarks:=PassRemark;
                            end;
                          end;

                          ACAAcademicYear.Reset;
                          ACAAcademicYear.SetRange(Code,CourseReg12."Academic Year");
                          if ACAAcademicYear.Find('-') then begin
                            GRADDATE:=ACAAcademicYear."Graduation Date";
                            end;
                 CourseReg12.Reset;
                 CourseReg12.SetRange("Student No.",Coregs."Student Number");
                 CourseReg12.SetRange("Year Of Study",Coregs."Year of Study");
                 CourseReg12.SetFilter(Reversed,'%1',false);
                 if CourseReg12.Find('-') then;
                    YearOfAdmi:=Coregs."Admission Date";
                acadyear:=CourseReg12."Academic Year";
            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
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
        if CompanyInformation.Find('-') then begin
          end;
    end;

    trigger OnPreReport()
    begin
        Clear(PExists);
    end;

    var
        TextedYos: Text;
        ConvertDecimalToText: Codeunit "Convert Decimal To Text";
        ACAClassificationUnits369: Record UnknownRecord66632;
        PassRemarks: Code[10];
        PassGrade: Code[10];
        ACAAcademicYear369: Record UnknownRecord61382;
        ProgClassInt: Code[10];
        ACAProgCatTranscriptComm: Record UnknownRecord78020;
        ACAResultsStatus: Record UnknownRecord61739;
        TransCriptRemarks: Text[250];
        CourseReg12: Record UnknownRecord61532;
        GRADDATE: Date;
        pName: Text[250];
        units_Subjects: Record UnknownRecord61517;
        YearOfStudy: Code[10];
        YearOfAdmi: Date;
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
        sName: Code[250];
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
        LegendRange: array [40] of Code[20];
        LegendGrade: array [40] of Code[2];
        LegendDesc: array [40] of Code[50];
        ACAExamGraddingSetup: Record UnknownRecord61599;
        Countings: Integer;
        ACAAcademicYear: Record UnknownRecord61382;
        ACACourseRegistration369: Record UnknownRecord61532;
        PExists: Boolean;
}

