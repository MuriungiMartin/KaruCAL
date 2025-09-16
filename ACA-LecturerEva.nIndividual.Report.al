#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65253 "ACA-Lecturer Eva.n Individual"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Lecturer Eva.n Individual.rdlc';

    dataset
    {
        dataitem(LectEval;UnknownTable61036)
        {
            CalcFields = Category;
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(ProgCode;LectEval.Programme)
            {
            }
            column(ProgDesc;ACAProgramme.Description)
            {
            }
            column(Stage;LectEval.Stage)
            {
            }
            column(UnitCode;LectEval.Unit)
            {
            }
            column(UnitDesc;ACAUnitsSubjects.Desription)
            {
            }
            column(Sem;LectEval.Semester)
            {
            }
            column(StudNo;LectEval."Student No")
            {
            }
            column(Lectno;LectEval."Lecturer No")
            {
            }
            column(LectName;HRMEmployeeC."First Name"+' '+HRMEmployeeC."Middle Name"+' '+HRMEmployeeC."Last Name")
            {
            }
            column(QuizNo;LectEval."Question No")
            {
            }
            column(QuizDesc;ACAEvaluationQuestions.Description)
            {
            }
            column(IntValue;LectEval.Value)
            {
            }
            column(RespValue;LectEval.Choices)
            {
            }
            column(Responses;LectEval.Response)
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(Address;CompanyInformation.Address+' '+CompanyInformation."Address 2"+' '+CompanyInformation.City)
            {
            }
            column(Phone;CompanyInformation."Phone No."+','+CompanyInformation."Phone No. 2")
            {
            }
            column(Mails;CompanyInformation."Home Page"+'/'+CompanyInformation."E-Mail")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(SchoolCode;SchoolCode)
            {
            }
            column(SchoolName;SchoolName)
            {
            }
            column(DeptCode;DeptCode)
            {
            }
            column(DeptName;DeptName)
            {
            }
            column(GrouppingNos;LectEval.Programme+LectEval.Semester+LectEval."Lecturer No"+LectEval.Unit)
            {
            }
            column(i;ACALecturersEvaluationCount.Sequence)
            {
            }
            column(Category;LectEval.Category)
            {
            }

            trigger OnAfterGetRecord()
            var
                i: Integer;
            begin
                Clear(SchoolCode);
                Clear(SchoolName);
                Clear(DeptCode);
                Clear(DeptName);
                ACAEvaluationQuestions.Reset;
                ACAEvaluationQuestions.SetRange(Semester,LectEval.Semester);
                ACAEvaluationQuestions.SetRange(ID,LectEval."Question No");
                if ACAEvaluationQuestions.Find('-') then;
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.",LectEval."Lecturer No");
                if HRMEmployeeC.Find('-') then;
                if ((HRMEmployeeC."First Name"='') or (HRMEmployeeC."Middle Name"='') or (HRMEmployeeC."Last Name"='')) then
                   CurrReport.Skip;
                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,LectEval.Programme);
                if ACAProgramme.Find('-') then begin
                  //Dim School
                  DimensionValue.Reset;
                  DimensionValue.SetRange("Dimension Code",'SCHOOL');
                  DimensionValue.SetRange(Code,ACAProgramme."School Code");
                  if DimensionValue.Find('-') then begin
                    SchoolCode:=DimensionValue.Code;
                    SchoolName:=DimensionValue.Name;
                    end;

                  //Dim School
                  DimensionValue.Reset;
                  DimensionValue.SetRange("Dimension Code",'DEPARTMENT');
                  DimensionValue.SetRange(Code,ACAProgramme."Department Code");
                  if DimensionValue.Find('-') then begin
                    DeptCode:=DimensionValue.Code;
                    DeptName:=DimensionValue.Name;
                    end;
                  end;
                ACAUnitsSubjects.Reset;
                ACAUnitsSubjects.SetRange(Code,LectEval.Unit);
                ACAUnitsSubjects.SetRange("Programme Code",LectEval.Programme);
                if ACAUnitsSubjects.Find('-') then;
                if ACAUnitsSubjects.Desription='' then  CurrReport.Skip;
                Clear(i);
                ACALecturersEvaluationCount.Reset;
                  ACALecturersEvaluationCount.SetRange("Semester Code",LectEval.Semester);
                  ACALecturersEvaluationCount.SetRange("User ID",UserId);
                  i:=ACALecturersEvaluationCount.Count;
                  i:=i+1;

                ACALecturersEvaluationCount.Reset;
                  ACALecturersEvaluationCount.SetRange("Semester Code",LectEval.Semester);
                  ACALecturersEvaluationCount.SetRange("User ID",UserId);
                  ACALecturersEvaluationCount.SetRange("Lecturer No.",LectEval."Lecturer No");
                  ACALecturersEvaluationCount.SetRange("Course Code",LectEval.Unit);
                 if not ACALecturersEvaluationCount.Find('-') then begin
                    ACALecturersEvaluationCount.Init;
                    ACALecturersEvaluationCount."Lecturer No.":=LectEval."Lecturer No";
                    ACALecturersEvaluationCount."Semester Code":=LectEval.Semester;
                    ACALecturersEvaluationCount."Course Code":=LectEval.Unit;
                    ACALecturersEvaluationCount."User ID":=UserId;
                    ACALecturersEvaluationCount.Sequence:=i;
                    ACALecturersEvaluationCount.Insert;
                 end;

                ACALecturersEvaluationCount.Reset;
                  ACALecturersEvaluationCount.SetRange("Semester Code",LectEval.Semester);
                  ACALecturersEvaluationCount.SetRange("User ID",UserId);
                  ACALecturersEvaluationCount.SetRange("Lecturer No.",LectEval."Lecturer No");
                  ACALecturersEvaluationCount.SetRange("Course Code",LectEval.Unit);
                 if  ACALecturersEvaluationCount.Find('-') then;
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
           // CompanyInformation.CALCFIELDS(Picture);
          end;
    end;

    var
        ACAEvaluationQuestions: Record UnknownRecord61035;
        ACAProgramme: Record UnknownRecord61511;
        HRMEmployeeC: Record UnknownRecord61188;
        ACAUnitsSubjects: Record UnknownRecord61517;
        CompanyInformation: Record "Company Information";
        DimensionValue: Record "Dimension Value";
        Customer: Record Customer;
        SchoolCode: Code[20];
        SchoolName: Text[150];
        DeptCode: Code[20];
        DeptName: Text[150];
        ACALecturersEvaluationCount: Record UnknownRecord77761;
}

