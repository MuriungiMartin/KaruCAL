#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 60232 "Single Instance Code Unit"
{

    trigger OnRun()
    begin
        if not StoreToTemp then begin
        StoreToTemp := true;
        end else
        Page.RunModal(0,TempGLEntry);
    end;

    var
        TempGLEntry: Record "G/L Entry" temporary;
        StoreToTemp: Boolean;

    local procedure InsertGL(GLEntry: Record "G/L Entry")
    begin
        if StoreToTemp then begin
        TempGLEntry := GLEntry;
        if not TempGLEntry.Insert then begin
        TempGLEntry.DeleteAll;
        TempGLEntry.Insert;
        end;
        end;
    end;
}

