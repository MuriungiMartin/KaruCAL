#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51797 "Official University Resultslip"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Official University Resultslip.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = where(Reversed=filter(No));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Student No.",Programme,Stage,Semester,Session;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(pic;Info.Picture)
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
            column(PassMarkLegend;'NOTE:   Pass mark is 40%')
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
            column(signedSignature;'Signed......................................................')
            {
            }
            column(codSchool;'(COD, '+SchoolName+')')
            {
            }
            column(CodDept;'(COD,'+Deptname+')')
            {
            }
            column(dateSigned;'Date:.......................................................')
            {
            }
            column(RegAcadLabel;'Registrar, Academic Affairs')
            {
            }
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),Semester=field(Semester);
                DataItemTableView = where("Reg. Reversed"=filter(No));
                column(ReportForNavId_1000000005; 1000000005)
                {
                }
                column(Unit;"ACA-Student Units".Unit)
                {
                }
                column(Desc;"ACA-Student Units".Description)
                {
                }
                column(Score;"ACA-Student Units"."Total Score")
                {
                }
                column(Final;"ACA-Student Units"."Final Score")
                {
                }
                column(Grade;"ACA-Student Units".Grade)
                {
                }
                column(Status;"ACA-Student Units".Status)
                {
                }
                column(ResultsStatus;"ACA-Student Units"."Result Status")
                {
                }
                column(CF;"ACA-Student Units".Units)
                {
                }

                trigger OnAfterGetRecord()
                begin
                      "ACA-Student Units".CalcFields("ACA-Student Units"."Total Score");
                      if "ACA-Student Units"."Total Score"=0 then
                     "ACA-Student Units".Grade:='E';

                    if "ACA-Student Units"."Result Status" = 'FAIL' then begin
                      Clear(ACASuppExamClassUnits);
                      ACASuppExamClassUnits.Reset;
                      ACASuppExamClassUnits.SetRange("Student No.","ACA-Student Units"."Student No.");
                      ACASuppExamClassUnits.SetRange(Programme,"ACA-Student Units".Programme);
                      ACASuppExamClassUnits.SetRange("Unit Code","ACA-Student Units".Unit);
                      if ACASuppExamClassUnits.Find('-') then begin
                        ACASuppExamClassUnits.CalcFields(Pass);
                        if ACASuppExamClassUnits.Pass then  "ACA-Student Units"."Result Status":='PASS *';
                        end;
                      end;

                    if "ACA-Student Units"."Result Status" = 'FAIL' then begin
                      Clear(ACA2ndSuppExamClassUnits);
                      ACA2ndSuppExamClassUnits.Reset;
                      ACA2ndSuppExamClassUnits.SetRange("Student No.","ACA-Student Units"."Student No.");
                      ACA2ndSuppExamClassUnits.SetRange(Programme,"ACA-Student Units".Programme);
                      ACA2ndSuppExamClassUnits.SetRange("Unit Code","ACA-Student Units".Unit);
                      if ACA2ndSuppExamClassUnits.Find('-') then begin
                        ACA2ndSuppExamClassUnits.CalcFields(Pass);
                        if ACA2ndSuppExamClassUnits.Pass then  "ACA-Student Units"."Result Status":='PASS **';
                        end;
                      end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
                 /*
                 IF "Course Registration"."Academic Year"<> acadyear THEN
                 CurrReport.SKIP;
                 IF "Course Registration".Semester<>Sems THEN
                 CurrReport.SKIP;
                 */
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
                   Deptname:=dimVal.Name;
                  end;
                
                
                Clear(YearOfStudy);
                ProgrammeStages.Reset;
                ProgrammeStages.SetRange(ProgrammeStages."Programme Code","ACA-Course Registration".Programme);
                ProgrammeStages.SetRange(ProgrammeStages.Code,"ACA-Course Registration".Stage);
                if ProgrammeStages.Find('-') then
                YearOfStudy:= ProgrammeStages.Description;
                
                
                Clear(sName);
                Clear(YearOfAdmi);
                cust.Reset;
                cust.SetRange(cust."No.","ACA-Course Registration"."Student No.");
                if cust.Find('-') then begin
                   sName:=cust.Name;
                
                end;
                
                IntakeRec.Reset;
                IntakeRec.SetRange(IntakeRec.Code,"ACA-Course Registration".Session);
                if IntakeRec.Find('-') then
                YearOfAdmi:=IntakeRec.Description;
                
                acadyear:="Academic Year";

            end;

            trigger OnPostDataItem()
            begin
                 // ExamProcess.UpdateCourseReg("Course Registration"."Student No.","Course Registration".Programme,"Course Registration".Stage,"Course Registration".Semester);
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
          //  IF Sems='' THEN ERROR('Please specify the Semester.');

         //Info.RESET;
        // IF Info.FIND('-') THEN BEGIN
        // Info.CALCFIELDS(Picture);
        // END;
    end;

    var
        ACASuppExamClassUnits: Record UnknownRecord66641;
        ACA2ndSuppExamClassUnits: Record UnknownRecord66681;
        ProgrammeStages: Record UnknownRecord61516;
        pName: Text[250];
        units_Subjects: Record UnknownRecord61517;
        YearOfStudy: Code[50];
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
        Info: Record "Company Information";
        IntakeRec: Record UnknownRecord61383;
        Deptname: Text[100];
}

