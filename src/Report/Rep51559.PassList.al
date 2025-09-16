#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51559 "Pass List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Pass List.rdlc';

    dataset
    {
        dataitem(UnknownTable61532;UnknownTable61532)
        {
            DataItemTableView = sorting("Reg. Transacton ID","Student No.",Programme,Semester,"Register for",Stage,Unit,"Student Type") where("Result Status"=filter(<>Fail));
            PrintOnlyIfDetail = true;
            RequestFilterFields = Programme,Stage,Semester;
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
            column(RCount;RCount)
            {
            }
            column(Remark;Remark)
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
            column(Registration_No_Caption;Registration_No_CaptionLbl)
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
            dataitem(UnknownTable61549;UnknownTable61549)
            {
                DataItemLink = "Student No."=field("Student No."),"Reg. Transacton ID"=field("Reg. Transacton ID");
                RequestFilterFields = Taken,Failed,Status;
                column(ReportForNavId_2992; 2992)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    /*
                    Remark:='REPEAT';
                    PassedUnits:=0;
                    Grading.RESET;
                    Grading.SETRANGE(Grading.Category,'DEFAULT');
                    Grading.SETRANGE(Grading.Failed,TRUE);
                    IF Grading.FIND('+') THEN
                    FailScore:=Grading."Up to";
                    
                    IF "Student Units"."Total Score">=FailScore THEN begin
                       Remark:='PASSED';
                       PassedUnits:=PassedUnits+1;
                    end ELSE begin
                       Remark:='REPEAT';
                     end;
                     {
                    IF ("Course Registration"."Units Taken" - PassedUnits) > 4 THEN
                    Remark:='REPEAT';
                    
                    IF ("Course Registration"."Units Taken" - PassedUnits) <= 4 THEN
                    Remark:='REPEAT';
                    //Remark:='SUPPLEMENTARY';
                    
                    //IF "Course Registration"."Units Taken" = PassedUnits THEN
                    //Remark:='PASSED';
                    
                    "Course Registration"."General Remark":=Remark;
                    "Course Registration".MODIFY;
                    }
                     if Remark='REPEAT'then CurrReport.SKIP;
                    */

                end;
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
                PASS:=true;
                StudUnits.Reset;
                StudUnits.SetFilter(StudUnits."Student No.","ACA-Course Registration"."Student No.");
                StudUnits.SetFilter(StudUnits."Reg. Transacton ID","ACA-Course Registration"."Reg. Transacton ID");
                StudUnits.SetFilter(StudUnits."Stage Filter","ACA-Course Registration".Stage);
                //studunits.setfilter(StudUnits.Taken,true);
                if StudUnits.Find('-') then begin
                repeat
                StudUnits.CalcFields(StudUnits."Total Score");
                if StudUnits."Total Score" >FailScore then begin
                 PassedUnits:=PassedUnits+1;
                 StudUnits.Failed:=false;
                 PASS:=true;
                end else begin
                 StudUnits.Failed:=true;
                 StudUnits."Repeat Unit":=false;
                 StudUnits.Modify;
                 "ACA-Course Registration"."Result Status":="ACA-Course Registration"."result status"::Fail;
                 "ACA-Course Registration".Modify;

                 PASS:=false;
                end;

                until StudUnits.Next = 0;
                end;

                if ("ACA-Course Registration"."Units Taken" - PassedUnits) > 4 then
                Remark:='REPEAT';

                if ("ACA-Course Registration"."Units Taken" - PassedUnits) <= 4 then
                Remark:='REPEAT';
                //Remark:='SUPPLEMENTARY';

                if "ACA-Course Registration"."Units Taken" = PassedUnits then
                Remark:='PASSED';


                if Cust.Get("ACA-Course Registration"."Student No.") then begin
                if (Cust.Status<>Cust.Status::Current) and (Cust.Status<>Cust.Status::Registration) then
                "General Remark":=Format(Cust.Status);
                end;

                "ACA-Course Registration"."General Remark":=Remark;
                "ACA-Course Registration".Modify;

                //IF PASS=FALSE THEN CurrReport.SKIP;
            end;

            trigger OnPostDataItem()
            begin
                /*
                  IF Remark='REPEAT' THEN
                   CurrReport.SKIP;
                */

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
        marks: Text[255];
        PASS: Boolean;
        Pass_ListCaptionLbl: label 'Pass List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Year_of_Study_CaptionLbl: label 'Year of Study:';
        Department_CaptionLbl: label 'Department:';
        Programme_of_Study_CaptionLbl: label 'Programme of Study:';
        Combination_CaptionLbl: label 'Combination:';
        Faculty_CaptionLbl: label 'Faculty:';
        Registration_No_CaptionLbl: label 'Registration No.';
}

