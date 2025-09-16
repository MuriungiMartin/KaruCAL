#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50140 "Admissions Qualifations"
{

    trigger OnRun()
    begin
    end;


    procedure QualificationValidation(ApplicantNo: Code[20];Programme: Code[20]) Qualify: Boolean
    var
        Prog: Record UnknownRecord61511;
        ProgEntry: Record UnknownRecord61467;
        RequiredCount: Integer;
        PassCount: Integer;
        AppRec: Record UnknownRecord61358;
    begin
        Qualify:=false;
        if Prog.Get(Programme) then begin
        if AppRec.Get(ApplicantNo) then begin
        if AppRec."Points Acquired">=Prog."Minimum Points" then
        Qualify:=true;
        end;
        end;
    end;


    procedure QualificationValidationSubjects(ApplicantNo: Code[20];Programme: Code[20]) Qualify: Boolean
    var
        Prog: Record UnknownRecord61511;
        ProgEntry: Record UnknownRecord61467;
        RequiredCount: Integer;
        PassCount: Integer;
        AppRec: Record UnknownRecord61358;
        AppSubjects: Record UnknownRecord61362;
    begin
        Qualify:=false;
        if Prog.Get(Programme) then begin
        ProgEntry.Reset;
        ProgEntry.SetRange(ProgEntry.Programme,Programme);
        if ProgEntry.Find('-') then begin
        RequiredCount:=ProgEntry.Count;
        repeat
        AppSubjects.Reset;
        AppSubjects.SetRange(AppSubjects."Application No.",ApplicantNo);
        AppSubjects.SetRange(AppSubjects."Subject Code",ProgEntry.Subject);
        if AppSubjects.Find('-') then begin
        repeat
        AppSubjects.CalcFields(AppSubjects.Points);
        if AppSubjects.Points>=ProgEntry."Minimum Points" then
        PassCount:=PassCount+1;
        until AppSubjects.Next=0;
        end;
        until ProgEntry.Next=0;
        end;
        end;

        if PassCount>=RequiredCount then
        Qualify:=true;
    end;
}

