#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1503 "Workflow Record Management"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        VarArray: array [100] of Variant;
        NotSupportedTypeErr: label 'The type is not supported.';
        NotEnoughSpaceErr: label 'There is not enough space to save the record.';


    procedure BackupRecord(Variant: Variant) Idx: Integer
    var
        VariantArrayElem: Variant;
    begin
        if not Variant.IsRecord then
          Error(NotSupportedTypeErr);

        for Idx := 1 to ArrayLen(VarArray) do begin
          VariantArrayElem := VarArray[Idx];
          if not VariantArrayElem.IsRecord then begin
            VarArray[Idx] := Variant;
            exit(Idx);
          end;
        end;

        Error(NotEnoughSpaceErr);
    end;


    procedure RestoreRecord(Index: Integer;var Variant: Variant)
    begin
        Variant := VarArray[Index];
        Clear(VarArray[Index]);
    end;
}

