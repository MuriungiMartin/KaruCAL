#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 447 "Record Link Management"
{

    trigger OnRun()
    begin
        if Confirm(Text001,false) then begin
          RemoveOrphanedLink;
          Message(Text004,NoOfRemoved);
        end;
    end;

    var
        Text001: label 'Do you want to remove links with no record reference?';
        Text002: label 'Removing Record Links without record reference.\';
        Text003: label '@1@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@';
        Text004: label '%1 orphaned links were removed.';
        NoOfRemoved: Integer;

    local procedure RemoveOrphanedLink()
    var
        RecordLink: Record "Record Link";
        RecordRef: RecordRef;
        PrevRecID: RecordID;
        Window: Dialog;
        i: Integer;
        Total: Integer;
        TimeLocked: Time;
        InTransaction: Boolean;
        RecordExists: Boolean;
    begin
        Window.Open(Text002 + Text003);
        TimeLocked := Time;
        with RecordLink do begin
          SetFilter(Company,'%1|%2','',COMPANYNAME);
          SetCurrentkey("Record ID");
          Total := Count;
          if Total = 0 then
            exit;
          if Find('-') then
            repeat
              i := i + 1;
              if (i MOD 1000) = 0 then
                Window.Update(1,ROUND(i / Total * 10000,1));
              if Format("Record ID") <> Format(PrevRecID) then begin  // Direct comparison doesn't work.
                PrevRecID := "Record ID";
                RecordExists := RecordRef.Get("Record ID");
              end;
              if not RecordExists then begin
                Delete;
                NoOfRemoved := NoOfRemoved + 1;
                if not InTransaction then
                  TimeLocked := Time;
                InTransaction := true;
              end;
              if InTransaction and (Time > (TimeLocked + 1000)) then begin
                Commit;
                TimeLocked := Time;
                InTransaction := false;
              end;
            until Next = 0;
        end;
        Window.Close;
    end;

    local procedure ResetNotifyOnLinks(RecVar: Variant)
    var
        RecordLink: Record "Record Link";
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecVar);
        RecordLink.SetRange("Record ID",RecRef.RecordId);
        RecordLink.SetRange(Notify,true);
        if not RecordLink.IsEmpty then
          RecordLink.ModifyAll(Notify,false);
    end;


    procedure CopyLinks(FromRecord: Variant;ToRecord: Variant)
    var
        RecRefTo: RecordRef;
    begin
        RecRefTo.GetTable(ToRecord);
        RecRefTo.CopyLinks(FromRecord);
        ResetNotifyOnLinks(RecRefTo);
    end;
}

