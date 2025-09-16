#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8613 "Config. Try Validate"
{

    trigger OnRun()
    begin
        FieldRefToValidate.Validate(Value);
    end;

    var
        FieldRefToValidate: FieldRef;
        Value: Variant;


    procedure SetValidateParameters(var SourceFieldRef: FieldRef;SourceValue: Variant)
    begin
        FieldRefToValidate := SourceFieldRef;
        Value := SourceValue;
    end;
}

