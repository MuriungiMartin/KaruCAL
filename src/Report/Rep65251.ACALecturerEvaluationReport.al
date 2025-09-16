#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 65251 "ACA-Lecturer Evaluation Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ACA-Lecturer Evaluation Report.rdlc';

    dataset
    {
        dataitem(LectEval;UnknownTable61036)
        {
            RequestFilterFields = Semester,Programme,Stage,Unit,"Lecturer No","Department Code";
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
            column(RespValue;Chosen)
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
            column(integerOrder;OrderVal)
            {
            }
            column(DimVal;DimensionValue.Name)
            {
            }
            column(DeptCode;ACAProgramme."Department Code")
            {
            }

            trigger OnAfterGetRecord()
            begin

                Clear(Chosen);
                Chosen:=Format(LectEval.Choices);
                if LectEval.Choices=LectEval.Choices::" " then Chosen:='Numerical';
                ACAEvaluationQuestions.Reset;
                ACAEvaluationQuestions.SetRange(Semester,LectEval.Semester);
                ACAEvaluationQuestions.SetRange(ID,LectEval."Question No");
                if ACAEvaluationQuestions.Find('-') then;
                Clear(OrderVal);
                if LectEval.Choices=LectEval.Choices::"Strongly Disagree" then begin
                   OrderVal:=5
                  end else if LectEval.Choices=LectEval.Choices::Disagree then begin
                   OrderVal:=4
                  end else if LectEval.Choices=LectEval.Choices::"Neither Agree Nor Disagree" then begin
                   OrderVal:=3
                  end else if LectEval.Choices=LectEval.Choices::Agree then begin
                   OrderVal:=2
                  end else if LectEval.Choices=LectEval.Choices::"Strongly Agree" then begin
                   OrderVal:=1
                  end else OrderVal:=6;
                HRMEmployeeC.Reset;
                HRMEmployeeC.SetRange("No.",LectEval."Lecturer No");
                if HRMEmployeeC.Find('-') then;

                ACAProgramme.Reset;
                ACAProgramme.SetRange(Code,LectEval.Programme);
                if ACAProgramme.Find('-') then;
                DimensionValue.Reset;
                DimensionValue.SetRange(DimensionValue.Code,ACAProgramme."Department Code");
                if DimensionValue.Find('-') then;
                ACAUnitsSubjects.Reset;
                ACAUnitsSubjects.SetRange(Code,LectEval.Unit);
                ACAUnitsSubjects.SetRange("Programme Code",LectEval.Programme);
                if ACAUnitsSubjects.Find('-') then;
                //ACA-Lecture Eval. Questions Li
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
          //  CompanyInformation.CALCFIELDS(Picture);
          end;
    end;

    var
        ACAEvaluationQuestions: Record UnknownRecord61035;
        ACAProgramme: Record UnknownRecord61511;
        HRMEmployeeC: Record UnknownRecord61188;
        ACAUnitsSubjects: Record UnknownRecord61517;
        CompanyInformation: Record "Company Information";
        OrderVal: Integer;
        DimensionValue: Record "Dimension Value";
        Chosen: Code[10];
}

