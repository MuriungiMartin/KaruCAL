#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 701 "Data Type Management"
{

    trigger OnRun()
    begin
    end;


    procedure GetRecordRefAndFieldRef(RecRelatedVariant: Variant;FieldNumber: Integer;var RecordRef: RecordRef;var FieldRef: FieldRef): Boolean
    begin
        if not GetRecordRef(RecRelatedVariant,RecordRef) then
          exit(false);

        FieldRef := RecordRef.Field(FieldNumber);
        exit(true);
    end;


    procedure GetRecordRef(RecRelatedVariant: Variant;var ResultRecordRef: RecordRef): Boolean
    var
        RecID: RecordID;
    begin
        case true of
          RecRelatedVariant.IsRecord:
            ResultRecordRef.GetTable(RecRelatedVariant);
          RecRelatedVariant.IsRecordRef:
            ResultRecordRef := RecRelatedVariant;
          RecRelatedVariant.IsRecordId:
            begin
              RecID := RecRelatedVariant;
              if RecID.TableNo = 0 then
                exit(false);
              if not ResultRecordRef.Get(RecID) then
                ResultRecordRef.Open(RecID.TableNo);
            end;
          else
            exit(false);
        end;
        exit(true);
    end;


    procedure FindFieldByName(RecordRef: RecordRef;var FieldRef: FieldRef;FieldNameTxt: Text): Boolean
    var
        "Field": Record "Field";
    begin
        Field.SetRange(TableNo,RecordRef.Number);
        Field.SetRange(FieldName,FieldNameTxt);

        if not Field.FindFirst then
          exit(false);

        FieldRef := RecordRef.Field(Field."No.");
        exit(true);
    end;
}

