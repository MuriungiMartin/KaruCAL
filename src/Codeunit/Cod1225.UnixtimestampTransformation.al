#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1225 "Unixtimestamp Transformation"
{

    trigger OnRun()
    begin
    end;

    var
        UNIXTimeStampDescTxt: label 'Transforming UNIX timestamp to text format.';
        UNIXTimeStampTxt: label 'UNIXTIMESTAMP', Locked=true;

    [EventSubscriber(ObjectType::Table, Database::"Transformation Rule", 'OnTransformation', '', false, false)]
    local procedure TransformUnixtimestampOnTransformation(TransformationCode: Code[20];InputText: Text;var OutputText: Text)
    begin
        if TransformationCode <> GetUnixTimestampCode then
          exit;
        if not TryConvert2BigInteger(InputText,OutputText) then
          OutputText := ''
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transformation Rule", 'OnCreateTransformationRules', '', false, false)]
    local procedure InsertUnixtimestampOnCreateTransformationRules()
    var
        TransformationRule: Record "Transformation Rule";
    begin
        TransformationRule.InsertRec(
          GetUnixTimestampCode,UNIXTimeStampDescTxt,TransformationRule."transformation type"::Custom,0,0,'','');
    end;

    [TryFunction]
    local procedure TryConvert2BigInteger(InputText: Text;var OutputText: Text)
    var
        TypeHelper: Codeunit "Type Helper";
        TempBinteger: BigInteger;
    begin
        Evaluate(TempBinteger,InputText);
        OutputText := Format(TypeHelper.EvaluateUnixTimestamp(TempBinteger));
    end;


    procedure GetUnixTimestampCode(): Code[20]
    begin
        exit(UNIXTimeStampTxt);
    end;
}

