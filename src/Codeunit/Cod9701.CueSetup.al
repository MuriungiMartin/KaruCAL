#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9701 "Cue Setup"
{
    Permissions = TableData "Cue Setup"=r;
    SingleInstance = true;

    trigger OnRun()
    begin
    end;


    procedure GetCustomizedCueStyle(TableId: Integer;FieldId: Integer;CueValue: Decimal): Text
    var
        CueSetup: Record "Cue Setup";
        Style: Option;
    begin
        Style := GetCustomizedCueStyleOption(TableId,FieldId,CueValue);
        exit(CueSetup.ConvertStyleToStyleText(Style));
    end;


    procedure OpenCustomizePageForCurrentUser(TableId: Integer)
    var
        TempCueSetupRecord: Record "Cue Setup" temporary;
    begin
        // Set TableNo in filter group 4, which is invisible and unchangeable for the user.
        // The user should only be able to set personal styles/thresholds, and only for the given table.
        TempCueSetupRecord.FilterGroup(4);
        TempCueSetupRecord.SetRange("Table ID",TableId);
        Page.RunModal(Page::"Cue Setup End User",TempCueSetupRecord);
    end;


    procedure PopulateTempCueSetupRecords(var TempCueSetupPageSourceRec: Record "Cue Setup" temporary)
    var
        CueSetup: Record "Cue Setup";
        "Field": Record "Field";
    begin
        // Populate temporary records with appropriate records from the real table.
        CueSetup.CopyFilters(TempCueSetupPageSourceRec);
        CueSetup.SetFilter("User Name",'%1|%2',UserId,'');

        // Insert user specific records and company wide records.
        CueSetup.Ascending := false;
        if CueSetup.FindSet then begin
          repeat
            TempCueSetupPageSourceRec.TransferFields(CueSetup);

            if TempCueSetupPageSourceRec."User Name" = '' then
              TempCueSetupPageSourceRec.Personalized := false
            else
              TempCueSetupPageSourceRec.Personalized := true;

            TempCueSetupPageSourceRec."User Name" := UserId;
            if TempCueSetupPageSourceRec.Insert then;
          until CueSetup.Next = 0;
        end;

        // Insert default records
        // Look up in the Fields virtual table
        // Filter on Table No=Table No and Type=Decimal|Integer. This should give us approximately the
        // fields that are "valid" for a cue control.
        Field.SetFilter(TableNo,TempCueSetupPageSourceRec.GetFilter("Table ID"));
        Field.SetFilter(Type,'%1|%2',Field.Type::Decimal,Field.Type::Integer);
        if Field.FindSet then begin
          repeat
            if not TempCueSetupPageSourceRec.Get(UserId,Field.TableNo,Field."No.") then begin
              TempCueSetupPageSourceRec.Init;
              TempCueSetupPageSourceRec."User Name" := UserId;
              TempCueSetupPageSourceRec."Table ID" := Field.TableNo;
              TempCueSetupPageSourceRec."Field No." := Field."No.";
              TempCueSetupPageSourceRec.Personalized := false;
              TempCueSetupPageSourceRec.Insert;
            end;
          until Field.Next = 0;

          // Clear last filter
          TempCueSetupPageSourceRec.SetRange("Field No.");
        end;
    end;


    procedure CopyTempCueSetupRecordsToTable(var TempCueSetupPageSourceRec: Record "Cue Setup" temporary)
    var
        CueSetup: Record "Cue Setup";
    begin
        if TempCueSetupPageSourceRec.FindSet then begin
          repeat
            if TempCueSetupPageSourceRec.Personalized then begin
              CueSetup.TransferFields(TempCueSetupPageSourceRec);
              if CueSetup.Find then begin
                CueSetup.TransferFields(TempCueSetupPageSourceRec);
                // Personalized field contains tempororaty property we never save it in the database.
                CueSetup.Personalized := false;
                CueSetup.Modify
              end else begin
                // Personalized field contains tempororaty property we never save it in the database.
                CueSetup.Personalized := false;
                CueSetup.Insert;
              end;
            end else begin
              CueSetup.TransferFields(TempCueSetupPageSourceRec);
              if CueSetup.Delete then;
            end;
          until TempCueSetupPageSourceRec.Next = 0;
        end;
    end;


    procedure ValidatePersonalizedField(var TempCueSetupPageSourceRec: Record "Cue Setup" temporary)
    var
        CueSetup: Record "Cue Setup";
    begin
        if TempCueSetupPageSourceRec.Personalized = false then
          if CueSetup.Get('',TempCueSetupPageSourceRec."Table ID",TempCueSetupPageSourceRec."Field No.") then begin
            // Revert back to company default if present.
            TempCueSetupPageSourceRec."Low Range Style" := CueSetup."Low Range Style";
            TempCueSetupPageSourceRec."Threshold 1" := CueSetup."Threshold 1";
            TempCueSetupPageSourceRec."Middle Range Style" := CueSetup."Middle Range Style";
            TempCueSetupPageSourceRec."Threshold 2" := CueSetup."Threshold 2";
            TempCueSetupPageSourceRec."High Range Style" := CueSetup."High Range Style";
          end else begin
            // Revert to "no values".
            TempCueSetupPageSourceRec."Low Range Style" := TempCueSetupPageSourceRec."low range style"::None;
            TempCueSetupPageSourceRec."Threshold 1" := 0;
            TempCueSetupPageSourceRec."Middle Range Style" := TempCueSetupPageSourceRec."middle range style"::None;
            TempCueSetupPageSourceRec."Threshold 2" := 0;
            TempCueSetupPageSourceRec."High Range Style" := TempCueSetupPageSourceRec."high range style"::None;
          end;
    end;

    local procedure GetCustomizedCueStyleOption(TableId: Integer;FieldNo: Integer;CueValue: Decimal): Integer
    var
        CueSetup: Record "Cue Setup";
    begin
        if FindCueSetup(CueSetup,TableId,FieldNo) then
          exit(CueSetup.GetStyleForValue(CueValue));

        exit(CueSetup."low range style"::None);
    end;

    local procedure FindCueSetup(var CueSetup: Record "Cue Setup";TableId: Integer;FieldNo: Integer): Boolean
    begin
        CueSetup.SetRange("Table ID",TableId);
        CueSetup.SetRange("Field No.",FieldNo);

        // First see if we have a record for the current user
        CueSetup.SetRange("User Name",UserId);
        if not CueSetup.FindFirst then begin
          // We didn't, so see if we have a record for all users
          CueSetup.SetRange("User Name",'');
          if not CueSetup.FindFirst then
            exit(false)
        end;

        exit(true);
    end;
}

