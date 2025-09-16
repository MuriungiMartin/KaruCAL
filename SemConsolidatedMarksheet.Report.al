#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51587 "Sem Consolidated Marksheet"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sem Consolidated Marksheet.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=const(No));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Year Of Study","Academic Year","Student No.",Programme,Stage,Semester,Session;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(GroupingConcortion;"ACA-Course Registration"."Academic Year"+"ACA-Course Registration".Programme+DeptName+SchoolName+"ACA-Course Registration".Options+Format("ACA-Course Registration"."Year Of Study")+"ACA-Course Registration".Semester)
            {
            }
            column(StudNo;"ACA-Course Registration"."Student No.")
            {
            }
            column(Prog;"ACA-Course Registration".Programme)
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
            column(Option;"ACA-Course Registration".Options)
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(YoS;"ACA-Course Registration"."Year Of Study")
            {
            }
            column(TotalYearlyMarks;"ACA-Course Registration"."Total Yearly Marks")
            {
            }
            column(YearlyAverage;"ACA-Course Registration"."Yearly Average")
            {
            }
            column(YearlyGrade;"ACA-Course Registration"."Yearly Grade")
            {
            }
            column(YearlyFailed;"ACA-Course Registration"."Yearly Failed Units")
            {
            }
            column(YearlyTotalUnits;"ACA-Course Registration"."Yearly Total Units Taken")
            {
            }
            column(YearlyRemarks;"ACA-Course Registration"."Yearly Remarks")
            {
            }
            column(TotalSemMarks;"ACA-Course Registration"."Total Semester Marks")
            {
            }
            column(YearlyWeightedTotal;"ACA-Course Registration"."Yearly Weighted Total")
            {
            }
            column(YearlyCFFailed;"ACA-Course Registration"."Yearly CF% Failed")
            {
            }
            column(YearlyCurrAverage;"ACA-Course Registration"."Yearly Curr. Average")
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
            column(CommAverage;"ACA-Course Registration"."Cummulative Average")
            {
            }
            column(CummGrade;"ACA-Course Registration"."Cummulative Grade")
            {
            }
            column(CumScore;"ACA-Course Registration"."Cummulative Score")
            {
            }
            column(CumUnits;"ACA-Course Registration"."Cummulative Units Taken")
            {
            }
            column(CumUnits2;"ACA-Course Registration"."Cummulative Units")
            {
            }
            column(CummMarks;"ACA-Course Registration"."Cummulative Marks")
            {
            }
            column(CummAward;"ACA-Course Registration".Award)
            {
            }
            column(YOSText;YOSTewxt)
            {
            }
            column(sName;sName)
            {
            }
            column(pName;pName)
            {
            }
            column(YearOfStudy;YearOfStudy)
            {
            }
            column(YearOfAdmi;YearOfAdmi)
            {
            }
            column(SchoolName;SchoolName)
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
            column(signedSignature;dimVal.Signature)
            {
            }
            column(TranscriptSignatory;dimVal."HOD Names")
            {
            }
            column(TransCriptTitle;dimVal.Titles)
            {
            }
            column(FacultyName;dimVal."Faculty Name")
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
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Semester=field(Semester),"Reg. Transacton ID"=field("Reg. Transacton ID");
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                column(Unit;"ACA-Student Units".Unit)
                {
                }
                column(Desc;"ACA-Student Units".Description)
                {
                }
                column(Score;"ACA-Student Units"."Total Marks")
                {
                }
                column(Final;"ACA-Student Units"."Final Score")
                {
                }
                column(Grade;"ACA-Student Units".Grade)
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

                trigger OnAfterGetRecord()
                begin
                    Clear(ScoreLabel);
                    "ACA-Student Units".CalcFields("ACA-Student Units"."CATs Marks Exists","ACA-Student Units"."EXAMs Marks Exists");
                    if (("ACA-Student Units"."CATs Marks Exists"=false) and ("ACA-Student Units"."EXAMs Marks Exists"=false)) then begin
                      ScoreLabel:='X';
                    end else begin
                    ScoreLabel:=Format("ACA-Student Units"."Total Marks");
                      ScoreLabel:=ScoreLabel+"ACA-Student Units"."Consolidated Mark Pref.";
                      end;
                    //IF ("ACA-Student Units"."Total Marks"<>0)  THEN ScoreLabel:=FORMAT("ACA-Student Units"."Total Marks")
                    //ELSE
                      "ACA-Student Units".CalcFields("ACA-Student Units"."Total Score");
                end;
            }

            trigger OnAfterGetRecord()
            begin
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
                  dimVal.SetRange(dimVal."Dimension Code",'School');
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
                    dimVal.CalcFields(Signature);
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


                Sem.Reset;
                Sem.SetRange(Sem.Code,"ACA-Course Registration".Semester);
                if Sem.Find('-') then
                acadyear:=Sem."Academic Year";
            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
            end;

            trigger OnPreDataItem()
            begin
                if "ACA-Course Registration".GetFilter("ACA-Course Registration".Semester)='' then Error('Specify a Semester Filter');
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
        CompanyInformation.Reset;
        if CompanyInformation.Find('-') then begin
          CompanyInformation.CalcFields(Picture);
          end;
    end;

    trigger OnPreReport()
    begin
          //  IF acadyear='' THEN ERROR('Please specify the academic year.');
    end;

    var
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
        ScoreLabel: Code[10];
        YOSTewxt: Text[20];
}

