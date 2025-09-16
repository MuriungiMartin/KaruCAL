#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 409 "Dimension Value-Indent"
{
    TableNo = "Dimension Value";

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

        DimVal.SetRange("Dimension Code","Dimension Code");
        Indent;
    end;

    var
        Text000: label 'This function updates the indentation of all the dimension values for dimension %1. ';
        Text001: label 'All dimension values between a Begin-Total and the matching End-Total are indented by one level. ';
        Text002: label 'The Totaling field for each End-Total is also updated.\\';
        Text003: label 'Do you want to indent the dimension values?';
        Text004: label 'Indenting Dimension Values @1@@@@@@@@@@@@@@@@@@';
        Text005: label 'End-Total %1 is missing a matching Begin-Total.';
        DimVal: Record "Dimension Value";
        Window: Dialog;
        DimValCode: array [10] of Code[20];
        i: Integer;


    procedure Indent()
    var
        NoOfDimVals: Integer;
        Progress: Integer;
    begin
        Window.Open(Text004);

        NoOfDimVals := DimVal.Count;
        if NoOfDimVals = 0 then
          NoOfDimVals := 1;
        with DimVal do
          if Find('-') then
            repeat
              Progress := Progress + 1;
              Window.Update(1,10000 * Progress DIV NoOfDimVals);

              if "Dimension Value Type" = "dimension value type"::"End-Total" then begin
                if i < 1 then
                  Error(
                    Text005,
                    Code);
                Totaling := DimValCode[i] + '..' + Code;
                i := i - 1;
              end;

              Indentation := i;
              Modify;

              if "Dimension Value Type" = "dimension value type"::"Begin-Total" then begin
                i := i + 1;
                DimValCode[i] := Code;
              end;
            until Next = 0;

        Window.Close;
    end;
}

