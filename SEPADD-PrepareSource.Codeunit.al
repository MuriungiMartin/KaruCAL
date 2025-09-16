#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1232 "SEPA DD-Prepare Source"
{
    TableNo = "Direct Debit Collection Entry";

    trigger OnRun()
    var
        DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";
    begin
        DirectDebitCollectionEntry.CopyFilters(Rec);
        CopyLines(DirectDebitCollectionEntry,Rec);
    end;

    local procedure CopyLines(var FromDirectDebitCollectionEntry: Record "Direct Debit Collection Entry";var ToDirectDebitCollectionEntry: Record "Direct Debit Collection Entry")
    begin
        if not FromDirectDebitCollectionEntry.IsEmpty then begin
          FromDirectDebitCollectionEntry.SetFilter(Status,'%1|%2',
            FromDirectDebitCollectionEntry.Status::New,FromDirectDebitCollectionEntry.Status::"File Created");
          if FromDirectDebitCollectionEntry.FindSet then
            repeat
              ToDirectDebitCollectionEntry := FromDirectDebitCollectionEntry;
              ToDirectDebitCollectionEntry.Insert;
            until FromDirectDebitCollectionEntry.Next = 0
        end else
          CreateTempCollectionEntries(FromDirectDebitCollectionEntry,ToDirectDebitCollectionEntry);
    end;

    local procedure CreateTempCollectionEntries(var FromDirectDebitCollectionEntry: Record "Direct Debit Collection Entry";var ToDirectDebitCollectionEntry: Record "Direct Debit Collection Entry")
    begin
        // To fill ToDirectDebitCollectionEntry from the source identified by filters set on FromDirectDebitCollectionEntry
        ToDirectDebitCollectionEntry := FromDirectDebitCollectionEntry;
    end;
}

