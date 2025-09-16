#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 66668 "Student Progress Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Student Progress Report.rdlc';

    dataset
    {
        dataitem(UnknownTable61549;UnknownTable61549)
        {
            CalcFields = "CATs Marks Exists","EXAMs Marks Exists";
            DataItemTableView = sorting(Stage) order(ascending) where(Reversed=filter(No));
            RequestFilterFields = Programme,Stage,Semester,Unit,"Student No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(No;"ACA-Student Units"."Student No.")
            {
            }
            column(Prog;"ACA-Student Units".Programme)
            {
            }
            column(Stage;"ACA-Student Units".Stage)
            {
            }
            column(Unit;"ACA-Student Units".Unit)
            {
            }
            column(Sem;"ACA-Student Units".Semester)
            {
            }
            column(Year;"ACA-Student Units"."Academic Year")
            {
            }
            column(Grade;"ACA-Student Units".Grade)
            {
            }
            column(Fin_Score;"ACA-Student Units"."Final Score")
            {
            }
            column(Total_Score;"ACA-Student Units"."Total Score")
            {
            }
            column(TotScore;"ACA-Student Units"."Total Score")
            {
            }
            column(Cat;"ACA-Student Units"."CATs Marks")
            {
            }
            column(exam;"ACA-Student Units"."EXAMs Marks")
            {
            }
            column(ProgCode;ACAProgramme.Code)
            {
            }
            column(ProgDesc;ACAProgramme.Description)
            {
            }
            column(UnitName;"ACA-Student Units"."Unit Name")
            {
            }
            column(UnitDesc;"ACA-Student Units"."Unit Description")
            {
            }
            column(StudName;Customer.Name)
            {
            }
            column(seq;seq)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   CalcFields("ACA-Student Units"."Total Score","ACA-Student Units"."Unit Description");
                   ACAProgramme.Reset;
                   ACAProgramme.SetRange(Code,"ACA-Student Units".Programme);
                   if ACAProgramme.Find('-') then begin

                     end;
                     Customer.Reset;
                     Customer.SetRange("No.","ACA-Student Units"."Student No.");
                     if Customer.Find('-') then begin
                       end;
                seq+=1;
                "ACA-Student Units".CalcFields("Total Score");
                "ACA-Student Units"."Total Marks":="ACA-Student Units"."Total Score";
                if (("ACA-Student Units"."EXAMs Marks Exists"=false) or ("ACA-Student Units"."CATs Marks Exists"=false)) then begin
                "ACA-Student Units".Grade:='!';
                "ACA-Student Units".Failed:=true;
                //"ACA-Student Units".MODIFY;
                end else begin
                  "ACA-Student Units".Grade:=GetGrade("ACA-Student Units"."Total Score","ACA-Student Units".Unit,"ACA-Student Units".Programme);
                "ACA-Student Units".Failed:=GetUnitPassStatus("ACA-Student Units"."Total Score","ACA-Student Units".Unit,"ACA-Student Units".Programme);
                //  "ACA-Student Units".MODIFY;
                  end;
            end;

            trigger OnPreDataItem()
            begin
                seq:=0;
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
        ACAProgramme: Record UnknownRecord61511;
        ACAUnitsSubjects: Record UnknownRecord61517;
        Customer: Record Customer;
        seq: Integer;


    procedure GetGrade(EXAMMark: Decimal;UnitG: Code[20];Proga: Code[20]) xGrade: Text[100]
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
        Marks: Decimal;
    begin
         Clear(Marks);
        Marks:=EXAMMark;
        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",Proga);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Student Units".Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(UnitG) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';
        end;
        end;
        xGrade:='';
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        Gradings.SetFilter(Gradings."Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Upper Limit",'>%1|=%2',Marks,Marks);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        //REPEAT
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


        end;

        end else begin
        Grade:='';
        end;
    end;


    procedure GetUnitPassStatus(EXAMMark: Decimal;UnitG: Code[20];Proga: Code[20]) Passed: Boolean
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
        Marks: Decimal;
    begin
         Clear(Marks);
        Marks:=EXAMMark;
        GradeCategory:='';
        UnitsRR.Reset;
        UnitsRR.SetRange(UnitsRR."Programme Code",Proga);
        UnitsRR.SetRange(UnitsRR.Code,UnitG);
        //UnitsRR.SETRANGE(UnitsRR."Stage Code","Student Units".Stage);
        if UnitsRR.Find('-') then begin
        if UnitsRR."Default Exam Category"<>'' then begin
        GradeCategory:=UnitsRR."Default Exam Category";
        end else begin
        ProgrammeRec.Reset;
        if ProgrammeRec.Get(UnitG) then
        GradeCategory:=ProgrammeRec."Exam Category";
        if GradeCategory='' then  GradeCategory:='DEFAULT';
        end;
        end;
        Passed:=false;
        if Marks > 0 then begin
        Gradings.Reset;
        Gradings.SetRange(Gradings.Category,GradeCategory);
        Gradings.SetFilter(Gradings."Lower Limit",'<%1|=%2',Marks,Marks);
        Gradings.SetFilter(Gradings."Upper Limit",'>%1|=%2',Marks,Marks);
        LastGrade:='';
        LastRemark:='';
        LastScore:=0;
        if Gradings.Find('-') then begin
        ExitDo:=false;
        //REPEAT
        LastScore:=Gradings."Up to";
        if Marks < LastScore then begin
        if ExitDo = false then begin
          if Gradings.Failed then
        Passed:=false else Passed:=true;
        if Gradings.Failed=false then
        LastRemark:='PASS'
        else
        LastRemark:='FAIL';
        ExitDo:=true;
        end;
        end;


        end;

        end else begin
        Passed:=false;
        end;
    end;
}

