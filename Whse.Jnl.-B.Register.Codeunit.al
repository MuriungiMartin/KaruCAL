#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7305 "Whse. Jnl.-B.Register"
{
    TableNo = "Warehouse Journal Batch";

    trigger OnRun()
    begin
        WhseJnlBatch.Copy(Rec);
        Code;
        Copy(WhseJnlBatch);
    end;

    var
        Text000: label 'Do you want to register the journals?';
        Text001: label 'The journals were successfully registered.';
        Text002: label 'It was not possible to register all of the journals. ';
        Text003: label 'The journals that were not successfully registered are now marked.';
        WhseJnlTemplate: Record "Warehouse Journal Template";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        WhseJnlLine: Record "Warehouse Journal Line";
        WhseJnlRegisterBatch: Codeunit "Whse. Jnl.-Register Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        with WhseJnlBatch do begin
          WhseJnlTemplate.Get("Journal Template Name");
          WhseJnlTemplate.TestField("Force Registering Report",false);

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            WhseJnlLine."Journal Template Name" := "Journal Template Name";
            WhseJnlLine."Journal Batch Name" := Name;
            WhseJnlLine."Location Code" := "Location Code";
            WhseJnlLine."Line No." := 10000;
            Clear(WhseJnlRegisterBatch);
            if WhseJnlRegisterBatch.Run(WhseJnlLine) then
              Mark(false)
            else begin
              Mark(true);
              JnlWithErrors := true;
            end;
          until Next = 0;

          if not JnlWithErrors then
            Message(Text001)
          else
            Message(
              Text002 +
              Text003);

          if not Find('=><') then begin
            Reset;
            FilterGroup(2);
            SetRange("Journal Template Name","Journal Template Name");
            SetRange("Location Code","Location Code");
            FilterGroup(0);
            Name := '';
          end;
        end;
    end;
}

