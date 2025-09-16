#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51596 "Pass List BU"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pass List BU.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type");
            RequestFilterFields = Programme,Stage,Unit,"Student No.";
            column(ReportForNavId_2901; 2901)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Comb;Comb)
            {
            }
            column(PName;PName)
            {
            }
            column(SDesc;SDesc)
            {
            }
            column(Dept;Dept)
            {
            }
            column(FDesc;FDesc)
            {
            }
            column(Course_Registration__Student_No__;"Student No.")
            {
            }
            column(Course_Registration__Units_Taken_;"Units Taken")
            {
            }
            column(PassedUnits;PassedUnits)
            {
            }
            column(Units_Taken__PassedUnits;"Units Taken"-PassedUnits)
            {
            }
            column(Cust_Name;Cust.Name)
            {
            }
            column(Course_Registration__General_Remark_;"General Remark")
            {
            }
            column(RCount;RCount)
            {
            }
            column(Pass_ListCaption;Pass_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Year_of_Study_Caption;Year_of_Study_CaptionLbl)
            {
            }
            column(Department_Caption;Department_CaptionLbl)
            {
            }
            column(Programme_of_Study_Caption;Programme_of_Study_CaptionLbl)
            {
            }
            column(Combination_Caption;Combination_CaptionLbl)
            {
            }
            column(Faculty_Caption;Faculty_CaptionLbl)
            {
            }
            column(Course_Registration__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Course_Registration__Units_Taken_Caption;FieldCaption("Units Taken"))
            {
            }
            column(Units_PassedCaption;Units_PassedCaptionLbl)
            {
            }
            column(Units_FailedCaption;Units_FailedCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(RemarkCaption;RemarkCaptionLbl)
            {
            }
            column(Course_Registration_Reg__Transacton_ID;"Reg. Transacton ID")
            {
            }
            column(Course_Registration_Programme;Programme)
            {
            }
            column(Course_Registration_Semester;Semester)
            {
            }
            column(Course_Registration_Register_for;"Register for")
            {
            }
            column(Course_Registration_Stage;Stage)
            {
            }
            column(Course_Registration_Unit;Unit)
            {
            }
            column(Course_Registration_Student_Type;"Student Type")
            {
            }
            column(Course_Registration_Entry_No_;"Entry No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount:=RCount+1;

                if Dept = '' then begin
                if Prog.Get("ACA-Course Registration".Programme) then begin
                PName:=Prog.Description;
                if FacultyR.Get(Prog.Faculty) then
                FDesc:=FacultyR.Description;

                DValue.Reset;
                DValue.SetRange(DValue.Code,Prog."School Code");
                if DValue.Find('-') then
                Dept:=DValue.Name;

                end;

                if Stages.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage) then
                SDesc:=Stages.Description;

                if ProgOptions.Get("ACA-Course Registration".Programme,"ACA-Course Registration".Stage,"ACA-Course Registration".Options) then
                Comb:=ProgOptions.Desription;


                end;


                PassedUnits:=0;
                Grading.Reset;
                Grading.SetRange(Grading.Category,'DEFAULT');
                Grading.SetRange(Grading.Failed,true);
                if Grading.Find('+') then
                FailScore:=Grading."Up to";

                StudUnits.Reset;
                StudUnits.SetRange(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                StudUnits.SetRange(StudUnits."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                if StudUnits.Find('-') then begin
                repeat
                StudUnits.CalcFields(StudUnits."Total Score");
                if StudUnits."Total Score" > FailScore then begin
                PassedUnits:=PassedUnits+1;
                StudUnits.Failed:=false;
                end else
                StudUnits.Failed:=true;

                StudUnits.Modify;

                until StudUnits.Next = 0;
                end;

                if ("ACA-Course Registration"."Units Taken" - PassedUnits) > 4 then
                Remark:='REPEAT';

                if ("ACA-Course Registration"."Units Taken" - PassedUnits) <= 4 then
                Remark:='SUPPLEMENTARY';

                if "ACA-Course Registration"."Units Taken" = PassedUnits then
                Remark:='PASSED';


                if Cust.Get("ACA-Course Registration"."Student No.") then begin
                if (Cust.Status<>Cust.Status::Current) and (Cust.Status<>Cust.Status::Registration) then
                "General Remark":=Format(Cust.Status);
                end;

                "ACA-Course Registration"."General Remark":=Remark;
                "ACA-Course Registration".Modify;
            end;

            trigger OnPreDataItem()
            begin
                RCount:=0;
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

    var
        Cust: Record Customer;
        Grading: Record UnknownRecord61569;
        StudUnits: Record UnknownRecord61549;
        FailScore: Decimal;
        PassedUnits: Integer;
        Remark: Text[150];
        RCount: Integer;
        DValue: Record "Dimension Value";
        FacultyR: Record UnknownRecord61587;
        FDesc: Text[200];
        Dept: Text[200];
        Prog: Record UnknownRecord61511;
        PName: Text[200];
        Stages: Record UnknownRecord61516;
        SDesc: Text[200];
        ProgOptions: Record UnknownRecord61554;
        Comb: Text[200];
        Pass_ListCaptionLbl: label 'Pass List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Year_of_Study_CaptionLbl: label 'Year of Study:';
        Department_CaptionLbl: label 'Department:';
        Programme_of_Study_CaptionLbl: label 'Programme of Study:';
        Combination_CaptionLbl: label 'Combination:';
        Faculty_CaptionLbl: label 'Faculty:';
        Units_PassedCaptionLbl: label 'Units Passed';
        Units_FailedCaptionLbl: label 'Units Failed';
        NamesCaptionLbl: label 'Names';
        RemarkCaptionLbl: label 'Remark';
}

