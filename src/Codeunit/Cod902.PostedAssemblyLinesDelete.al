#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 902 "PostedAssemblyLines-Delete"
{
    Permissions = TableData "Posted Assembly Line"=d;

    trigger OnRun()
    begin
    end;

    var
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        MoveEntries: Codeunit MoveEntries;


    procedure DeleteLines(PostedAssemblyHeader: Record "Posted Assembly Header")
    var
        PostedAssemblyLine: Record "Posted Assembly Line";
    begin
        PostedAssemblyLine.SetCurrentkey("Document No.");
        PostedAssemblyLine.SetRange("Document No.",PostedAssemblyHeader."No.");
        if PostedAssemblyLine.Find('-') then
          repeat
            PostedAssemblyLine.Delete(true);
          until PostedAssemblyLine.Next = 0;
        ItemTrackingMgt.DeleteItemEntryRelation(
          Database::"Posted Assembly Line",0,PostedAssemblyHeader."No.",'',0,0,true);

        MoveEntries.MoveDocRelatedEntries(Database::"Posted Assembly Header",PostedAssemblyHeader."No.");
    end;
}

