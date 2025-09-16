#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 901 "Assembly-Post (Yes/No)"
{
    TableNo = "Assembly Header";

    trigger OnRun()
    begin
        AssemblyHeader.Copy(Rec);
        Code;
        Rec := AssemblyHeader;
    end;

    var
        AssemblyHeader: Record "Assembly Header";
        Text000: label 'Do you want to post the %1?';

    local procedure "Code"()
    begin
        with AssemblyHeader do begin
          if not Confirm(Text000,false,"Document Type") then
            exit;

          Codeunit.Run(Codeunit::"Assembly-Post",AssemblyHeader);
          Commit;
        end;
    end;
}

