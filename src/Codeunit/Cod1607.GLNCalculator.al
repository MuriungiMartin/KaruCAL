#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1607 "GLN Calculator"
{

    trigger OnRun()
    begin
    end;

    var
        GLNLengthErr: label 'The GLN length should be %1 and not %2.';
        GLNCheckDigitErr: label 'The GLN %1 is not valid.';


    procedure AssertValidCheckDigit13(GLNValue: Code[20])
    begin
        if not IsValidCheckDigit(GLNValue,13) then
          Error(GLNCheckDigitErr,GLNValue);
    end;


    procedure IsValidCheckDigit13(GLNValue: Code[20]): Boolean
    begin
        exit(IsValidCheckDigit(GLNValue,13));
    end;

    local procedure IsValidCheckDigit(GLNValue: Code[20];ExpectedSize: Integer): Boolean
    begin
        if GLNValue = '' then
          exit(false);

        if StrLen(GLNValue) <> ExpectedSize then
          Error(GLNLengthErr,ExpectedSize,StrLen(GLNValue));

        exit(Format(StrCheckSum(CopyStr(GLNValue,1,ExpectedSize - 1),'131313131313')) = Format(GLNValue[ExpectedSize]));
    end;
}

