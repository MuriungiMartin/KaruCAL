#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 78082 "Missing Marks Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Missing Marks Report.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            RequestFilterFields = "School Code",Programme,"Academic Year",Semester,Stage,Unit;
            column(ReportForNavId_1000000001; 1000000001)
            {
            }
            column(SchoolNameFlow_ACAStudentUnits;"ACA-Student Units"."School Name (Flow)")
            {
            }
            column(Semester_ACAStudentUnits;"ACA-Student Units".Semester)
            {
            }
            column(Programme_ACAStudentUnits;"ACA-Student Units".Programme)
            {
            }
            column(Stage_ACAStudentUnits;"ACA-Student Units".Stage)
            {
            }
            column(Unit_ACAStudentUnits;"ACA-Student Units".Unit)
            {
            }
            column(StudentNo_ACAStudentUnits;"ACA-Student Units"."Student No.")
            {
            }
            column(GRadeCode;GRadeCode)
            {
            }
            column(compName;CompanyInfo.Name)
            {
            }
            column(StudentName_ACAStudentUnits;"ACA-Student Units"."Student Name")
            {
            }
            column(ShowonMissingMarks_ACAStudentUnits;"ACA-Student Units"."Show on Missing Marks")
            {
            }

            trigger OnAfterGetRecord()
            begin

                "ACA-Student Units"."Show on Missing Marks":=false;
                CatExists:=false;
                ExamExists:=false;
                SpecialValid:=false;
                SpecialX:=false;
                HasX:=false;
                HAsE:=false;
                HasC:=false;
                GRadeCode:='';

                ExamResults.Reset;


                //ExamResults.SETRANGE("Academic Year","ACA-Student Units"."Academic Year");
                ExamResults.SetRange(ExamResults.Semester,"ACA-Student Units".Semester);
                ExamResults.SetRange(ExamResults.Programme,"ACA-Student Units".Programme);
                ExamResults.SetRange(ExamResults.Stage,"ACA-Student Units".Stage);
                ExamResults.SetRange(ExamResults."Student No.","ACA-Student Units"."Student No.");
                ExamResults.SetRange(ExamResults.Unit,"ACA-Student Units".Unit);
                ExamResults.SetRange(ExamResults.ExamType,'FINAL EXAM');
                if ExamResults.Find('-') then
                  ExamExists:=true;

                ExamResults.Reset;
                //ExamResults.SETRANGE("Academic Year","ACA-Student Units"."Academic Year");
                ExamResults.SetRange(ExamResults.Programme,"ACA-Student Units".Programme);
                ExamResults.SetRange(ExamResults.Semester,"ACA-Student Units".Semester);
                ExamResults.SetRange(ExamResults.Stage,"ACA-Student Units".Stage);
                ExamResults.SetRange(ExamResults."Student No.","ACA-Student Units"."Student No.");
                ExamResults.SetRange(ExamResults.Unit,"ACA-Student Units".Unit);
                ExamResults.SetRange(ExamResults.ExamType,'CAT');
                if ExamResults.Find('-') then
                  CatExists:=true;

                SpecialExam.Reset;
                SpecialExam.SetRange(SpecialExam."Student No.","ACA-Student Units"."Student No.");
                //SpecialExam.SETRANGE("Academic Year","Academic Year");
                SpecialExam.SetRange(SpecialExam.Programme,"ACA-Student Units".Programme);
                SpecialExam.SetRange(SpecialExam.Stage,"ACA-Student Units".Stage);
                SpecialExam.SetRange(SpecialExam.Semester,"ACA-Student Units".Semester);
                SpecialExam.SetRange(SpecialExam."Unit Code","ACA-Student Units".Unit);
                SpecialExam.SetRange(SpecialExam."Exam Marks",0);
                SpecialX:=SpecialExam.FindSet();

                SpecialExam.Reset;
                SpecialExam.SetRange(SpecialExam."Student No.","ACA-Student Units"."Student No.");
                //SpecialExam.SETRANGE("Academic Year","Academic Year");
                SpecialExam.SetRange(SpecialExam.Programme,"ACA-Student Units".Programme);
                SpecialExam.SetRange(SpecialExam.Stage,"ACA-Student Units".Stage);
                SpecialExam.SetRange(SpecialExam.Semester,"ACA-Student Units".Semester);
                SpecialExam.SetRange(SpecialExam."Unit Code","ACA-Student Units".Unit);
                SpecialExam.SetFilter(SpecialExam."Exam Marks",'>%1',0);
                SpecialValid:=SpecialExam.FindSet();

                HasC:=(CatExists and not ExamExists);
                if HasC then GRadeCode:='c';
                HAsE:=ExamExists and not CatExists;
                if not HAsE then
                  HAsE:=SpecialValid and not CatExists;
                if HAsE then GRadeCode:='e';
                HasX:=(not CatExists and not ExamExists) or (SpecialX) ;
                if HasX then GRadeCode:='X';
                if ExamExists and CatExists then
                  GRadeCode:='';

                CourseReg.Reset;
                CourseReg.SetRange(CourseReg."Student No.","ACA-Student Units"."Student No.");
                CourseReg.SetRange(CourseReg.Semester,"ACA-Student Units".Semester);
                CourseReg.SetRange(CourseReg.Programme,"ACA-Student Units".Programme);
                CourseReg.SetFilter(CourseReg."Stoppage Reason",'%1|%2|%3','COP','WB','WRA');
                if CourseReg.FindFirst then
                  GRadeCode:='';

                 Cust.Reset;
                 Cust.SetRange("No.","ACA-Student Units"."Student No.");
                 //Cust.SETRANGE("Customer Type",Cust."Customer Type"::Student);
                 if not Cust.FindFirst then GRadeCode:='';


                // IF CatExists AND ExamExists THEN CurrReport.SKIP;
                //
                 if SpecialValid and CatExists then
                GRadeCode:='';
                  if not HasX and not HAsE and not HasC then
                    GRadeCode:='';

                "ACA-Student Units"."Temp Grade Code":=GRadeCode;
                if GRadeCode<>'' then
                  "ACA-Student Units"."Show on Missing Marks":=true;
                "ACA-Student Units".Modify;
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

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ExamResults: Record UnknownRecord61548;
        HasX: Boolean;
        ExamExists: Boolean;
        CatExists: Boolean;
        SpecialExam: Record UnknownRecord78002;
        SpecialX: Boolean;
        GRadeCode: Code[10];
        HAsE: Boolean;
        HasC: Boolean;
        CompanyInfo: Record "Company Information";
        CourseReg: Record UnknownRecord61532;
        Cust: Record Customer;
        SpecialValid: Boolean;
}

