#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 243 "Item Jnl.-B.Post"
{
    TableNo = "Item Journal Batch";

    trigger OnRun()
    begin
        ItemJnlBatch.Copy(Rec);
        Code;
        Copy(ItemJnlBatch);
    end;

    var
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlBatch: Record "Item Journal Batch";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlPostBatch: Codeunit "Item Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        with ItemJnlBatch do begin
          ItemJnlTemplate.Get("Journal Template Name");
          ItemJnlTemplate.TestField("Force Posting Report",false);

          if not Confirm(Text000,false) then
            exit;

          Find('-');
          repeat
            ItemJnlLine."Journal Template Name" := "Journal Template Name";
            ItemJnlLine."Journal Batch Name" := Name;
            ItemJnlLine."Line No." := 1;
            Clear(ItemJnlPostBatch);
            if ItemJnlPostBatch.Run(ItemJnlLine) then
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
            FilterGroup(0);
            Name := '';
          end;
        end;
    end;
}

