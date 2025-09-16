#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5811 "Change Exp. Cost Post. to G/L"
{
    Permissions = TableData "Value Entry"=rm,
                  TableData "Avg. Cost Adjmt. Entry Point"=id,
                  TableData "Post Value Entry to G/L"=id;
    TableNo = "Inventory Setup";

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'If you change the %1, the program must update table %2.';
        Text001: label 'This can take several hours.\';
        Text002: label 'Do you really want to change the %1?';
        Text003: label 'The change has been canceled.';
        Text004: label 'Processing entries...\\';
        Text005: label 'Item No. #1########## @2@@@@@@@@@@@@@';
        Text007: label '%1 has been changed to %2. You should now run %3.';
        Text008: label 'Deleting %1 entries...';
        Window: Dialog;
        EntriesModified: Boolean;


    procedure ChangeExpCostPostingToGL(var InvtSetup: Record "Inventory Setup";ExpCostPostingToGL: Boolean)
    var
        PostValueEntryToGL: Record "Post Value Entry to G/L";
    begin
        if not
           Confirm(
             StrSubstNo(
               Text000 + Text001 + Text002,
               InvtSetup.FieldCaption("Expected Cost Posting to G/L"),
               PostValueEntryToGL.TableCaption),false)
        then
          Error(Text003);

        if ExpCostPostingToGL then
          EnableExpCostPostingToGL
        else
          DisableExpCostPostingToGL;

        UpdateInvtSetup(InvtSetup,ExpCostPostingToGL)
    end;

    local procedure EnableExpCostPostingToGL()
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        PostValueEntryToGL: Record "Post Value Entry to G/L";
        OldItemNo: Code[20];
        LastUpdateTime: Time;
        RecordNo: Integer;
        NoOfRecords: Integer;
    begin
        Window.Open(
          Text004 +
          Text005);

        ValueEntry.LockTable;
        LastUpdateTime := Time;

        if PostValueEntryToGL.FindSet then
          repeat
            ValueEntry.Get(PostValueEntryToGL."Value Entry No.");
            UpdatePostValueEntryToGL(ValueEntry."Item Ledger Entry No.");
          until PostValueEntryToGL.Next = 0;

        with ItemLedgEntry do begin
          SetCurrentkey("Item No.","Entry Type");
          SetFilter("Entry Type",'%1|%2|%3',"entry type"::Sale,"entry type"::Purchase,"entry type"::Output);
          NoOfRecords := Count;
          if Find('-') then
            repeat
              RecordNo := RecordNo + 1;

              if "Item No." <> OldItemNo then begin
                Window.Update(1,"Item No.");
                OldItemNo := "Item No.";
              end;

              if Time - LastUpdateTime >= 1000 then begin
                Window.Update(2,ROUND(RecordNo / NoOfRecords * 10000,1));
                LastUpdateTime := Time;
              end;

              if (Quantity <> "Invoiced Quantity") and (Quantity <> 0) then
                UpdatePostValueEntryToGL("Entry No.");

            until Next = 0;
        end;

        Window.Close;
    end;

    local procedure UpdatePostValueEntryToGL(ItemLedgEntryNo: Integer)
    var
        PostValueEntryToGL: Record "Post Value Entry to G/L";
        ValueEntry: Record "Value Entry";
    begin
        with ValueEntry do begin
          SetCurrentkey("Item Ledger Entry No.");
          SetRange("Item Ledger Entry No.",ItemLedgEntryNo);
          if Find('-') then
            repeat
              if not EntriesModified then
                EntriesModified := true;
              if not PostValueEntryToGL.Get("Entry No.") and
                 (("Cost Amount (Expected)" <> "Expected Cost Posted to G/L") or
                  ("Cost Amount (Expected) (ACY)" <> "Exp. Cost Posted to G/L (ACY)"))
              then begin
                PostValueEntryToGL."Value Entry No." := "Entry No.";
                PostValueEntryToGL."Item No." := "Item No.";
                PostValueEntryToGL."Posting Date" := "Posting Date";
                PostValueEntryToGL.Insert;
              end;
            until Next = 0;
        end;
    end;

    local procedure DisableExpCostPostingToGL()
    var
        PostValueEntryToGL: Record "Post Value Entry to G/L";
        ValueEntry: Record "Value Entry";
    begin
        with PostValueEntryToGL do begin
          Window.Open(StrSubstNo(Text008,TableCaption));
          if FindSet(true,true) then
            repeat
              ValueEntry.Get("Value Entry No.");
              if ValueEntry."Expected Cost" then
                Delete;

            until Next = 0;
        end;
        Window.Close;
    end;

    local procedure UpdateInvtSetup(var InvtSetup: Record "Inventory Setup";ExpCostPostingToGL: Boolean)
    var
        ObjTransl: Record "Object Translation";
    begin
        with InvtSetup do begin
          "Expected Cost Posting to G/L" := ExpCostPostingToGL;
          Modify;
          if EntriesModified then
            Message(
              Text007,FieldCaption("Expected Cost Posting to G/L"),"Expected Cost Posting to G/L",
              ObjTransl.TranslateObject(ObjTransl."object type"::Report,Report::"Post Inventory Cost to G/L"));
        end;
    end;
}

