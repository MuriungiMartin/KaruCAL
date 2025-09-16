#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 845 "Cash Flow Wksh.- Check Line"
{

    trigger OnRun()
    begin
    end;


    procedure RunCheck(var CFWkshLine: Record "Cash Flow Worksheet Line")
    var
        CFAccount: Record "Cash Flow Account";
    begin
        with CFWkshLine do begin
          if EmptyLine then
            exit;

          TestField("Cash Flow Forecast No.");
          TestField("Cash Flow Account No.");
          TestField("Cash Flow Date");
          if "Source Type" = "source type"::"G/L Budget" then
            TestField("G/L Budget Name");
          if ("Cash Flow Account No." <> '') and CFAccount.Get("Cash Flow Account No.") then
            CFAccount.TestField(Blocked,false);
        end;
    end;
}

