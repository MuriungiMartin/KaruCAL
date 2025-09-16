#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 429 "IC Dimension Value-Indent"
{
    TableNo = "IC Dimension Value";

    trigger OnRun()
    begin
        if not
           Confirm(
             StrSubstNo(
               Text000 +
               Text001 +
               Text002 +
               Text003,"Dimension Code"),true)
        then
          exit;
        ICDimVal.SetRange("Dimension Code","Dimension Code");
        Indent;
    end;

    var
        Text000: label 'This function updates the indentation of all the IC dimension values for IC dimension %1. ';
        Text001: label 'All IC dimension values between a Begin-Total and the matching End-Total are indented by one level. ';
        Text002: label 'The Totaling field for each End-Total is also updated.\\';
        Text003: label 'Do you want to indent the IC dimension values?';
        Text004: label 'Indenting IC Dimension Values @1@@@@@@@@@@@@@@@@@@';
        ICDimVal: Record "IC Dimension Value";
        Window: Dialog;
        i: Integer;
        Text005: label 'End-Total %1 is missing a matching Begin-Total.';

    local procedure Indent()
    var
        NoOfDimVals: Integer;
        Progress: Integer;
    begin
        Window.Open(Text004);

        NoOfDimVals := ICDimVal.Count;
        if NoOfDimVals = 0 then
          NoOfDimVals := 1;
        with ICDimVal do
          if FindSet then
            repeat
              Progress := Progress + 1;
              Window.Update(1,10000 * Progress DIV NoOfDimVals);
              if "Dimension Value Type" = "dimension value type"::"End-Total" then begin
                if i < 1 then
                  Error(
                    Text005,
                    Code);
                i := i - 1;
              end;

              Indentation := i;
              Modify;

              if "Dimension Value Type" = "dimension value type"::"Begin-Total" then
                i += 1;
            until Next = 0;

        Window.Close;
    end;
}

