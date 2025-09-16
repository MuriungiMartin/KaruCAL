#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5778 "Whse. Create Pick"
{
    TableNo = "Whse. Worksheet Line";

    trigger OnRun()
    begin
        WkshPickLine.Copy(Rec);
        WhseCreatePick.SetWkshPickLine(WkshPickLine);
        WhseCreatePick.RunModal;
        if WhseCreatePick.GetResultMessage then
          AutofillQtyToHandle(Rec);
        Clear(WhseCreatePick);

        Reset;
        SetCurrentkey("Worksheet Template Name",Name,"Location Code","Sorting Sequence No.");
        FilterGroup := 2;
        SetRange("Worksheet Template Name","Worksheet Template Name");
        SetRange(Name,Name);
        SetRange("Location Code","Location Code");
        FilterGroup := 0;
    end;

    var
        WkshPickLine: Record "Whse. Worksheet Line";
        WhseCreatePick: Report "Create Pick";
}

