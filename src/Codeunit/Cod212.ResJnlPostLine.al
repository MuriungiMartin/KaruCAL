#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 212 "Res. Jnl.-Post Line"
{
    Permissions = TableData "Res. Ledger Entry"=imd,
                  TableData "Resource Register"=imd,
                  TableData "Time Sheet Line"=m,
                  TableData "Time Sheet Detail"=m;
    TableNo = "Res. Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;
        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ResJnlLine: Record "Res. Journal Line";
        ResLedgEntry: Record "Res. Ledger Entry";
        Res: Record Resource;
        ResReg: Record "Resource Register";
        GenPostingSetup: Record "General Posting Setup";
        ResUOM: Record "Resource Unit of Measure";
        ResJnlCheckLine: Codeunit "Res. Jnl.-Check Line";
        XferCustomFields: Codeunit "Transfer Custom Fields";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;


    procedure RunWithCheck(var ResJnlLine2: Record "Res. Journal Line")
    begin
        ResJnlLine.Copy(ResJnlLine2);
        Code;
        ResJnlLine2 := ResJnlLine;
    end;

    local procedure "Code"()
    begin
        with ResJnlLine do begin
          if EmptyLine then
            exit;

          ResJnlCheckLine.RunCheck(ResJnlLine);

          if NextEntryNo = 0 then begin
            ResLedgEntry.LockTable;
            if ResLedgEntry.FindLast then
              NextEntryNo := ResLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
          end;

          if "Document Date" = 0D then
            "Document Date" := "Posting Date";

          if ResReg."No." = 0 then begin
            ResReg.LockTable;
            if (not ResReg.FindLast) or (ResReg."To Entry No." <> 0) then begin
              ResReg.Init;
              ResReg."No." := ResReg."No." + 1;
              ResReg."From Entry No." := NextEntryNo;
              ResReg."To Entry No." := NextEntryNo;
              ResReg."Creation Date" := Today;
              ResReg."Source Code" := "Source Code";
              ResReg."Journal Batch Name" := "Journal Batch Name";
              ResReg."User ID" := UserId;
              ResReg.Insert;
            end;
          end;
          ResReg."To Entry No." := NextEntryNo;
          ResReg.Modify;

          Res.Get("Resource No.");
          Res.TestField(Blocked,false);

          if (GenPostingSetup."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
             (GenPostingSetup."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group")
          then
            GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");

          "Resource Group No." := Res."Resource Group No.";

          ResLedgEntry.Init;
          ResLedgEntry."Entry Type" := "Entry Type";
          ResLedgEntry."Document No." := "Document No.";
          ResLedgEntry."External Document No." := "External Document No.";
          ResLedgEntry."Order Type" := "Order Type";
          ResLedgEntry."Order No." := "Order No.";
          ResLedgEntry."Order Line No." := "Order Line No.";
          ResLedgEntry."Posting Date" := "Posting Date";
          ResLedgEntry."Document Date" := "Document Date";
          ResLedgEntry."Resource No." := "Resource No.";
          ResLedgEntry."Resource Group No." := "Resource Group No.";
          ResLedgEntry.Description := Description;
          ResLedgEntry."Work Type Code" := "Work Type Code";
          ResLedgEntry."Job No." := "Job No.";
          ResLedgEntry."Unit of Measure Code" := "Unit of Measure Code";
          ResLedgEntry.Quantity := Quantity;
          ResLedgEntry."Direct Unit Cost" := "Direct Unit Cost";
          ResLedgEntry."Unit Cost" := "Unit Cost";
          ResLedgEntry."Total Cost" := "Total Cost";
          ResLedgEntry."Unit Price" := "Unit Price";
          ResLedgEntry."Total Price" := "Total Price";
          ResLedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
          ResLedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";
          ResLedgEntry."Dimension Set ID" := "Dimension Set ID";
          ResLedgEntry."Source Code" := "Source Code";
          ResLedgEntry."Journal Batch Name" := "Journal Batch Name";
          ResLedgEntry."Reason Code" := "Reason Code";
          ResLedgEntry."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          ResLedgEntry."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          ResLedgEntry."No. Series" := "Posting No. Series";
          ResLedgEntry."Source Type" := "Source Type";
          ResLedgEntry."Source No." := "Source No.";
          ResLedgEntry."Qty. per Unit of Measure" := "Qty. per Unit of Measure";
          GetGLSetup;

          with ResLedgEntry do begin
            "Total Cost" := ROUND("Total Cost");
            "Total Price" := ROUND("Total Price");
            if "Entry Type" = "entry type"::Sale then begin
              Quantity := -Quantity;
              "Total Cost" := -"Total Cost";
              "Total Price" := -"Total Price";
            end;
            "Direct Unit Cost" := ROUND("Direct Unit Cost",GLSetup."Unit-Amount Rounding Precision");
            "User ID" := UserId;
            "Entry No." := NextEntryNo;
            ResUOM.Get("Resource No.","Unit of Measure Code");
            if ResUOM."Related to Base Unit of Meas." then
              "Quantity (Base)" := Quantity * "Qty. per Unit of Measure";
          end;

          if "Entry Type" = "entry type"::Usage then begin
            PostTimeSheetDetail(ResJnlLine,ResLedgEntry."Quantity (Base)");
            ResLedgEntry.Chargeable := IsChargable(ResJnlLine,ResLedgEntry.Chargeable);
          end;

          XferCustomFields.ResJnlLineTOResLedgEntry(ResJnlLine,ResLedgEntry);
          ResLedgEntry.Insert(true);

          NextEntryNo := NextEntryNo + 1;
        end;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
          GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure PostTimeSheetDetail(ResJnlLine2: Record "Res. Journal Line";QtyToPost: Decimal)
    var
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetDetail: Record "Time Sheet Detail";
        TimeSheetMgt: Codeunit "Time Sheet Management";
    begin
        with ResJnlLine2 do begin
          if "Time Sheet No." <> '' then begin
            TimeSheetDetail.Get("Time Sheet No.","Time Sheet Line No.","Time Sheet Date");
            TimeSheetDetail."Posted Quantity" += QtyToPost;
            TimeSheetDetail.Posted := TimeSheetDetail.Quantity = TimeSheetDetail."Posted Quantity";
            TimeSheetDetail.Modify;
            TimeSheetLine.Get("Time Sheet No.","Time Sheet Line No.");
            TimeSheetMgt.CreateTSPostingEntry(TimeSheetDetail,Quantity,"Posting Date","Document No.",TimeSheetLine.Description);

            TimeSheetDetail.SetRange("Time Sheet No.","Time Sheet No.");
            TimeSheetDetail.SetRange("Time Sheet Line No.","Time Sheet Line No.");
            TimeSheetDetail.SetRange(Posted,false);
            if TimeSheetDetail.IsEmpty then begin
              TimeSheetLine.Posted := true;
              TimeSheetLine.Modify;
            end;
          end;
        end;
    end;

    local procedure IsChargable(ResJournalLine: Record "Res. Journal Line";Chargeable: Boolean): Boolean
    var
        TimeSheetLine: Record "Time Sheet Line";
    begin
        if ResJournalLine."Time Sheet No." <> '' then begin
          TimeSheetLine.Get(ResJournalLine."Time Sheet No.",ResJournalLine."Time Sheet Line No.");
          exit(TimeSheetLine.Chargeable);
        end;
        exit(Chargeable);
    end;
}

