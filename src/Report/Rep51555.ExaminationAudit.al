#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51555 "Examination Audit"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Examination Audit.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            RequestFilterFields = Programme,Unit,"Student No.","Reg. Transacton ID";
            column(ReportForNavId_2992; 2992)
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Unit;Unit)
            {
            }
            column(Student_Units_Unit_Control1102760024;Unit)
            {
            }
            column(Student_Units_Grade;Grade)
            {
            }
            column(Student_Units_Remarks;Remarks)
            {
            }
            column(Student_Units__Total_Score_;"Total Score")
            {
            }
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(RemarkCaption;RemarkCaptionLbl)
            {
            }
            column(GradeCaption;GradeCaptionLbl)
            {
            }
            column(Units_CodeCaption;Units_CodeCaptionLbl)
            {
            }
            column(ResultsCaption;ResultsCaptionLbl)
            {
            }
            column(Maseno_UniversityCaption;Maseno_UniversityCaptionLbl)
            {
            }
            column(Examination_AuditCaption;Examination_AuditCaptionLbl)
            {
            }
            column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Programme_FilterCaption;Programme_FilterCaptionLbl)
            {
            }
            column(Stage_FilterCaption;Stage_FilterCaptionLbl)
            {
            }
            column(Unit_FilterCaption;Unit_FilterCaptionLbl)
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Student_Units_ENo;ENo)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "ACA-Student Units".Taken = true then begin
                UDesc:='';
                Units.Reset;
                Units.SetRange(Units."Programme Code","ACA-Student Units".Programme);
                Units.SetRange(Units.Code,Unit);
                if Units.Find('-') then
                UDesc:=Units.Desription;


                if "ACA-Student Units"."Total Score" > 0 then begin
                Gradings.Reset;
                Gradings.SetRange(Gradings.Category,'DEFAULT');
                LastGrade:='';
                LastRemark:='';
                LastScore:=0;
                if Gradings.Find('-') then begin
                ExitDo:=false;
                repeat
                if "ACA-Student Units"."Total Score" < LastScore then begin
                if ExitDo = false then begin
                ExitDo:=true;
                Grade:=LastGrade;
                Remarks:=LastRemark;
                end;
                end;
                LastGrade:=Gradings.Grade;
                LastScore:=Gradings."Up to";
                if Gradings.Failed = true then
                LastRemark:='Suplimentary'
                else
                LastRemark:=Gradings.Remarks;

                until Gradings.Next = 0;

                if ExitDo = false then begin
                Gradings2.Reset;
                Gradings2.SetRange(Gradings2.Category,'DEFAULT');
                if Gradings2.Find('+') then begin
                Grade:=Gradings2.Grade;
                Remarks:=Gradings2.Remarks;
                end;

                end;
                end;

                end else begin
                Grade:='';
                Remarks:='Not Done';
                end;


                OUnits:=OUnits + 1;
                OScore:=OScore + "ACA-Student Units"."Total Score";

                end else begin
                Grade:='';
                Remarks:='**Exempted**';


                end;

                if Cust.Get("ACA-Student Units"."Student No.") then
;
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

    var
        Cust: Record Customer;
        Prog: Record UnknownRecord61511;
        Stages: Record UnknownRecord61516;
        RFound: Boolean;
        UDesc: Text[200];
        Units: Record UnknownRecord61517;
        Result: Decimal;
        Grade: Text[150];
        Remarks: Text[150];
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        TotalScore: Decimal;
        LastGrade: Code[20];
        LastScore: Decimal;
        ExitDo: Boolean;
        Desc: Text[200];
        OScore: Decimal;
        OUnits: Integer;
        MeanScore: Decimal;
        MeanGrade: Code[20];
        LastRemark: Text[200];
        CReg: Record UnknownRecord61532;
        RemarkCaptionLbl: label 'Remark';
        GradeCaptionLbl: label 'Grade';
        Units_CodeCaptionLbl: label 'Units Code';
        ResultsCaptionLbl: label 'Results';
        Maseno_UniversityCaptionLbl: label 'Maseno University';
        Examination_AuditCaptionLbl: label 'Examination Audit';
        NameCaptionLbl: label 'Name';
        Programme_FilterCaptionLbl: label 'Programme Filter';
        Stage_FilterCaptionLbl: label 'Stage Filter';
        Unit_FilterCaptionLbl: label 'Unit Filter';
}

