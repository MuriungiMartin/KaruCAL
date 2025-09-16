#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51080 "Val Marks"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Val Marks.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            DataItemTableView = sorting(Programme,Stage,Unit,Semester,"Reg. Transacton ID","Student No.",ENo);
            RequestFilterFields = "Student No.",Programme,Semester,Stage;
            column(ReportForNavId_2992; 2992)
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
            column(Student_Units__Student_No__;"Student No.")
            {
            }
            column(Student_Units_Semester;Semester)
            {
            }
            column(Student_Units_Programme;Programme)
            {
            }
            column(Student_Units__Final_Score_;"Final Score")
            {
            }
            column(Student_Units__Total_Score_;"Total Score")
            {
            }
            column(Student_Units_Grade;Grade)
            {
            }
            column(Student_Units__Result_Status_;"Result Status")
            {
            }
            column(Student_UnitsCaption;Student_UnitsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Student_Units__Student_No__Caption;FieldCaption("Student No."))
            {
            }
            column(Student_Units_SemesterCaption;FieldCaption(Semester))
            {
            }
            column(Student_Units_ProgrammeCaption;FieldCaption(Programme))
            {
            }
            column(Student_Units__Final_Score_Caption;FieldCaption("Final Score"))
            {
            }
            column(Student_Units__Total_Score_Caption;FieldCaption("Total Score"))
            {
            }
            column(Student_Units_GradeCaption;FieldCaption(Grade))
            {
            }
            column(Student_Units__Result_Status_Caption;FieldCaption("Result Status"))
            {
            }
            column(Student_Units_Stage;Stage)
            {
            }
            column(Student_Units_Unit;Unit)
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
                  "Units/Subj".Reset;
                  "Units/Subj".SetRange("Units/Subj"."Programme Code","ACA-Student Units".Programme);
                  "Units/Subj".SetRange("Units/Subj".Code,"ACA-Student Units".Unit);
                  "Units/Subj".SetRange("Units/Subj"."Stage Code","ACA-Student Units".Stage);
                  if "Units/Subj".Find('-') then
                  "ACA-Student Units".Description:="Units/Subj".Desription;

                  "ACA-Student Units".CalcFields("ACA-Student Units"."Total Score");
                  "ACA-Student Units".CalcFields("ACA-Student Units"."Cust Exist");
                  "ACA-Student Units"."Final Score":="ACA-Student Units"."Total Score";
                  "ACA-Student Units".Registered:="ACA-Student Units".Registered;

                  if (GetGradeStatus("ACA-Student Units"."Final Score","ACA-Student Units".Programme,"ACA-Student Units".Unit)) or
                  ("ACA-Student Units"."Final Score"=0)  then begin
                  "ACA-Student Units"."Result Status":='FAIL';
                  "ACA-Student Units".Failed:=true;
                  end else begin
                  "ACA-Student Units"."Result Status":='PASS';
                  end;
                  "ACA-Student Units".Grade:=GetGrade("ACA-Student Units"."Final Score","ACA-Student Units".Unit);
                  "ACA-Student Units".Modify;

                // Update Supplimentary
                 if "ACA-Student Units"."Register for"="ACA-Student Units"."register for"::Supplimentary then begin
                 StudUnits.Reset;
                 StudUnits.SetRange(StudUnits."Student No.","ACA-Student Units"."Student No.");
                 StudUnits.SetRange(StudUnits.Unit,"ACA-Student Units".Unit);
                 StudUnits.SetRange(StudUnits."Re-Take",false);
                 StudUnits.SetRange(StudUnits."Supp Taken",false);
                 if StudUnits.Find('-') then begin
                 repeat
                 StudUnits."Supp Taken":=true;
                 StudUnits.Modify;
                 until StudUnits.Next=0;
                 end;
                 end;

                 EResults.Reset;
                 EResults.SetRange(EResults."Student No.","ACA-Student Units"."Student No.");
                 EResults.SetRange(EResults.Unit,"ACA-Student Units".Unit);
                 EResults.SetRange(EResults.Programme,"ACA-Student Units".Programme);
                 EResults.SetRange(EResults.Stage,"ACA-Student Units".Stage);
                 EResults.SetRange(EResults.Semester,"ACA-Student Units".Semester);
                 EResults.SetRange(EResults."Re-Take",false);
                 if EResults.Find('-') then begin
                 repeat
                 EResults.CalcFields(EResults."Re-Sit");
                 EResults."Re-Sited":=EResults."Re-Sit";
                 EResults.Modify;
                 until EResults.Next=0;
                 end;

                // Update Online Results
                OnlineGrading.Reset;
                OnlineGrading.SetRange(OnlineGrading."Student No","ACA-Student Units"."Student No.");
                OnlineGrading.SetRange(OnlineGrading."Unit Code","ACA-Student Units".Unit);
                if OnlineGrading.Find('-') then
                OnlineGrading.DeleteAll;

                if Sem.Get("ACA-Student Units".Semester) then
                if Sem."SMS Results Semester"=true then begin
                if "ACA-Student Units"."Final Score">0 then begin
                OnlineGrading.Init;
                OnlineGrading."Student No":="ACA-Student Units"."Student No.";
                OnlineGrading."Unit Code":="ACA-Student Units".Unit;
                OnlineGrading.Description:="ACA-Student Units".Description;
                OnlineGrading.Exam:=Format("ACA-Student Units"."Final Score");
                OnlineGrading.Grade:="ACA-Student Units".Grade;
                OnlineGrading.Insert;
                end;
                end;
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
        OnlineGrading: Record UnknownRecord61006;
        "Units/Subj": Record UnknownRecord61517;
        Sem: Record UnknownRecord61518;
        StudUnits: Record UnknownRecord61549;
        EResults: Record UnknownRecord61548;
        Student_UnitsCaptionLbl: label 'Student Units';
        CurrReport_PAGENOCaptionLbl: label 'Page';


    procedure GetGrade(Marks: Decimal;UnitG: Code[20]) xGrade: Text[100]
    var
        UnitsRR: Record UnknownRecord61517;
        ProgrammeRec: Record UnknownRecord61511;
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GradeCategory: Code[20];
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        Grd: Code[80];
        Grade: Code[20];
    begin
        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code","ACA-Student Units".Programme);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        UnitsRR.SetRange(UnitsRR."Stage Code","ACA-Student Units".Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get("ACA-Student Units".Programme) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;
        end;
        xGrade:='';
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
        xGrade:=Gradings.Grade;
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin
        Grade:='';
        //Remarks:='Not Done';
        end;
    end;


    procedure GetGradeStatus(var AvMarks: Decimal;var ProgCode: Code[20];var Unit: Code[20]) F: Boolean
    var
        LastGrade: Code[20];
        LastRemark: Code[20];
        ExitDo: Boolean;
        LastScore: Decimal;
        Gradings: Record UnknownRecord61599;
        Gradings2: Record UnknownRecord61599;
        GLabel: array [6] of Code[20];
        i: Integer;
        GLabel2: array [6] of Code[100];
        FStatus: Boolean;
        ProgrammeRec: Record UnknownRecord61511;
        Grd: Code[80];
        GradeCategory: Code[20];
        UnitsRR: Record UnknownRecord61517;
    begin
        F:=false;

        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",ProgCode);
        UnitsRR.SetRange(UnitsRR.Code,Unit);
        UnitsRR.SetRange(UnitsRR."Stage Code","ACA-Student Units".Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(ProgCode) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then Error('Please note that you must specify Exam Category in Programme Setup');
        end;
        end;

        if AvMarks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        repeat
        LastScore:=Gradings."Up to";
        if AvMarks < LastScore then begin
        if ExitDo = false then begin
        Grd:=Gradings.Grade;
        F:=Gradings.Failed;
        ExitDo:=true;
        end;
        end;

        until Gradings.Next = 0;


        end;

        end else begin


        end;
    end;
}

