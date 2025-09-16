#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 843 "Cash Flow Wksh. - Register"
{
    TableNo = "Cash Flow Worksheet Line";

    trigger OnRun()
    begin
        CFWkshLine.Copy(Rec);
        Code;
        Copy(CFWkshLine);
    end;

    var
        Text1001: label 'Do you want to register the worksheet lines?';
        Text1002: label 'There is nothing to register.';
        Text1003: label 'The worksheet lines were successfully registered.';
        CFWkshLine: Record "Cash Flow Worksheet Line";

    local procedure "Code"()
    begin
        with CFWkshLine do begin
          if not Confirm(Text1001) then
            exit;

          Codeunit.Run(Codeunit::"Cash Flow Wksh.-Register Batch",CFWkshLine);

          if "Line No." = 0 then
            Message(Text1002)
          else
            Message(Text1003);

          if not Find('=><') then begin
            Reset;
            "Line No." := 1;
          end;
        end;
    end;
}

