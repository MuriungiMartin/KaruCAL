#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 911 "Pstd. Assembly - Undo (Yes/No)"
{
    TableNo = "Posted Assembly Header";

    trigger OnRun()
    begin
        PostedAsmHeader.Copy(Rec);
        Code;
        Rec := PostedAsmHeader;
    end;

    var
        PostedAsmHeader: Record "Posted Assembly Header";
        Text000: label 'Do you want to undo posting of the posted assembly order?';
        Text001: label 'Do you want to recreate the assembly order from the posted assembly order?';

    local procedure "Code"()
    var
        AsmHeader: Record "Assembly Header";
        AsmPost: Codeunit "Assembly-Post";
        DoRecreateAsmOrder: Boolean;
    begin
        if not Confirm(Text000,false) then
          exit;

        if not AsmHeader.Get(AsmHeader."document type"::Order,PostedAsmHeader."Order No.") then
          DoRecreateAsmOrder := Confirm(Text001);

        AsmPost.Undo(PostedAsmHeader,DoRecreateAsmOrder);
        Commit;
    end;
}

