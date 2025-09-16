#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51772 "Official University Transcript"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Official University Transcript.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where("Register for"=const(Stage),Reversed=filter(No));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Student No.",Programme,Stage,Semester,Session,"Academic Year","Year Of Study";
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(TRemarks;"ACA-Course Registration"."Transcript Remarks")
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
            column(SemesterFilter_CourseRegistration;"ACA-Course Registration"."Semester Filter")
            {
            }
            column(CurrSem;"ACA-Course Registration"."Current Cumm Score")
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
            column(DoubleLine;'======================================================================')
            {
            }
            column(Recomm;'Recommendation:')
            {
            }
            column(singleLine;'=======================================================================')
            {
            }
            column(signedSignature;'Signed......................................................')
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
            column(RegAcadLabel;'Registrar (Academic Affairs)')
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Semester=field(Semester);
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                column(Unit;"ACA-Student Units".Unit)
                {
                }
                column(Desc;UnitsR3.Desription)
                {
                }
                column(Score;ROUND("ACA-Student Units"."Total Score",1,'='))
                {
                }
                column(Final;ROUND("ACA-Student Units"."Final Score",1,'='))
                {
                }
                column(Grade;"ACA-Student Units".Grade)
                {
                }
                column(Status;"ACA-Student Units"."Exam Status")
                {
                }
                column(CF;"ACA-Student Units".Units)
                {
                }
                column(r;"ACA-Student Units"."Total Score")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    "ACA-Student Units".CalcFields("ACA-Student Units"."Total Score");
                      if "ACA-Student Units"."Total Score"=0 then
                     "ACA-Student Units".Grade:='E';

                    UnitsCount:=UnitsCount+1;

                    UnitsR3.Reset;
                    UnitsR3.SetRange(Code,"ACA-Student Units".Unit);
                    UnitsR3.SetRange("Programme Code","ACA-Student Units".Programme);
                    if UnitsR3.Find('-') then begin

                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
                // IF "Course Registration"."Academic Year"<> acadyear THEN
                // CurrReport.SKIP;

                if (("ACA-Course Registration"."Year Of Study"=1) and ("ACA-Course Registration"."Transcript Remarks"='PASS')) then
                  "ACA-Course Registration"."Transcript Remarks":='REMARKS: PASS, PROCEED TO SECOND YEAR OF STUDY'
                else if (("ACA-Course Registration"."Year Of Study"=2) and ("ACA-Course Registration"."Transcript Remarks"='PASS')) then
                  "ACA-Course Registration"."Transcript Remarks":='REMARKS: PASS, PROCEED TO THIRD YEAR OF STUDY'
                else if (("ACA-Course Registration"."Year Of Study"=3) and ("ACA-Course Registration"."Transcript Remarks"='PASS')) then
                  "ACA-Course Registration"."Transcript Remarks":='REMARKS: PASS, PROCEED TO FOURTH YEAR OF STUDY'
                else if (("ACA-Course Registration"."Year Of Study"=4) and ("ACA-Course Registration"."Transcript Remarks"='PASS')) then
                  "ACA-Course Registration"."Transcript Remarks":='REMARKS: PASS';

                 Clear(SchoolName);
                 if prog.Get("ACA-Course Registration".Programme) then begin
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
                "ACA-Course Registration".SetFilter("Semester Filter","ACA-Course Registration".GetFilter("ACA-Course Registration".Semester));
                "ACA-Course Registration".SetFilter("Stage Filter","ACA-Course Registration".GetFilter("ACA-Course Registration".Stage));
                "ACA-Course Registration".CalcFields("ACA-Course Registration"."Cum Units Failed");
                ProgStages.Reset;
                ProgStages.SetRange(ProgStages."Programme Code","ACA-Course Registration".Programme);
                ProgStages.SetRange(ProgStages.Code,"ACA-Course Registration".Stage);
                if ProgStages.Find('-') then begin
                PassRemark:='Remarks: '+ProgStages.Remarks;
                if ProgStages."Final Stage"=true then
                PassRemark:='Remarks: '+"ACA-Course Registration".Award;
                if "ACA-Course Registration"."Cum Units Failed">0 then
                PassRemark:='Remarks: '+"ACA-Course Registration"."Exam Status";
                end;

                IntakeRec.Reset;
                IntakeRec.SetRange(IntakeRec.Code,"ACA-Course Registration".Session);
                if IntakeRec.Find('-') then
                YearOfAdmi:=IntakeRec.Description;

                Sem.Reset;
                Sem.SetRange(Sem.Code,"ACA-Course Registration".Semester);
                if Sem.Find('-') then
                acadyear:=Sem."Academic Year";

                if prog.Get("ACA-Course Registration".Programme) then begin
                i:=1;
                Gradings.Reset;
                Gradings.SetRange(Gradings.Category,prog."Exam Category");
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
                end;
            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
            end;

            trigger OnPreDataItem()
            begin

                    UnitsCount:=0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

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
        UnitsR3: Record UnknownRecord61517;
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
        UnitsCount: Integer;
}

