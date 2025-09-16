#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5810 "Change Average Cost Setting"
{
    TableNo = "Inventory Setup";

    trigger OnRun()
    begin
        WindowUpdateDateTime := CurrentDatetime;
        WindowIsOpen := false;

        AvgCostAdjmtEntryPoint.LockTable;
        LockTable;
        AccPeriod.LockTable;

        Modify;

        AccPeriod.SetRange("New Fiscal Year",true);
        AccPeriod.Find('-');
        if AccPeriod.Closed then begin
          AccPeriod.SetRange(Closed,false);
          AccPeriod.Find('-');
          StartingValuationDate := AccPeriod."Starting Date";
        end;
        repeat
          AccPeriod."Average Cost Period" := "Average Cost Period";
          AccPeriod."Average Cost Calc. Type" := "Average Cost Calc. Type";
          AccPeriod.Modify;
        until AccPeriod.Next = 0;

        ProcessItemsFromDate(StartingValuationDate);

        if WindowIsOpen then
          Window.Close;

        Commit;
    end;

    var
        AccPeriod: Record "Accounting Period";
        ValueEntry: Record "Value Entry";
        Item: Record Item;
        InvtSetup: Record "Inventory Setup";
        AvgCostAdjmtEntryPoint: Record "Avg. Cost Adjmt. Entry Point";
        Window: Dialog;
        StartingValuationDate: Date;
        WindowIsOpen: Boolean;
        WindowNo: Text[20];
        WindowPostingDate: Date;
        WindowUpdateDateTime: DateTime;
        Text000: label 'Processing Item...\\';
        Text001: label 'Item No.       #1######\';
        Text002: label 'Valuation Date #2######';


    procedure UpdateAvgCostFromAccPeriodChg(var AccPeriod: Record "Accounting Period";PrevAccPeriod: Record "Accounting Period";UpdateType: Option " ",Insert,Modify,Delete,Rename)
    var
        AccPeriod2: Record "Accounting Period";
        StartingValuationDate: Date;
    begin
        if not InvtSetup.Get then
          exit;

        with AccPeriod do begin
          if not ("New Fiscal Year" or PrevAccPeriod."New Fiscal Year" or
                  (InvtSetup."Average Cost Period" = InvtSetup."average cost period"::"Accounting Period"))
          then
            exit;

          StartingValuationDate := 0D;
          AccPeriod2 := AccPeriod;
          case UpdateType of
            Updatetype::Insert:
              Insert;
            Updatetype::Delete:
              Delete;
            Updatetype::Modify:
              Modify;
            Updatetype::Rename:
              begin
                Insert;
                PrevAccPeriod.Delete;
                if (PrevAccPeriod."Starting Date" < "Starting Date") and
                   (PrevAccPeriod."Starting Date" <> 0D)
                then
                  AccPeriod2 := PrevAccPeriod;
              end;
          end;

          if AccPeriod2.Next(-1) <> 0 then
            StartingValuationDate := AccPeriod2."Starting Date";
          ProcessItemsFromDate(StartingValuationDate);

          case UpdateType of
            Updatetype::Insert:
              Delete;
            Updatetype::Delete:
              Insert;
            Updatetype::Rename:
              begin
                Delete;
                PrevAccPeriod.Insert;
              end;
          end;
        end;
    end;

    local procedure ProcessItemsFromDate(StartingValuationDate: Date)
    begin
        if Item.Find('-') then
          repeat
            if Item."Costing Method" = Item."costing method"::Average then
              ProcessItemAvgCostPoint(Item,StartingValuationDate);
          until Item.Next = 0;
    end;

    local procedure ProcessItemAvgCostPoint(var Item: Record Item;StartingValuationDate: Date)
    begin
        InvtSetup.Get;
        AvgCostAdjmtEntryPoint.Reset;
        AvgCostAdjmtEntryPoint.SetRange("Item No.",Item."No.");
        AvgCostAdjmtEntryPoint.SetFilter("Valuation Date",'>=%1',StartingValuationDate);
        AvgCostAdjmtEntryPoint.DeleteAll;

        with ValueEntry do begin
          Reset;
          SetCurrentkey("Item No.","Valuation Date","Location Code","Variant Code");

          SetRange("Item No.",Item."No.");
          SetFilter("Valuation Date",'>=%1',StartingValuationDate);
          if Find('-') then begin
            repeat
              UpDateWindow("Item No.","Valuation Date");

              AvgCostAdjmtEntryPoint.UpdateValuationDate(ValueEntry);

              SetRange("Valuation Date","Valuation Date");
              if InvtSetup."Average Cost Calc. Type" =
                 InvtSetup."average cost calc. type"::"Item & Location & Variant"
              then begin
                SetRange("Location Code","Location Code");
                SetRange("Variant Code","Variant Code");
              end;
              if Find('+') then;
              SetRange("Valuation Date");
              SetRange("Location Code");
              SetRange("Variant Code");
            until Next = 0;
            Item."Cost is Adjusted" := false;
            Item.Modify;
          end;
        end;
    end;

    local procedure OpenWindow()
    begin
        Window.Open(
          Text000 +
          Text001 +
          Text002);
        WindowIsOpen := true;
        WindowUpdateDateTime := CurrentDatetime;
    end;

    local procedure UpDateWindow(NewWindowNo: Code[20];NewWindowPostingDate: Date)
    begin
        WindowNo := NewWindowNo;
        WindowPostingDate := NewWindowPostingDate;

        if IsTimeForUpdate then begin
          if not WindowIsOpen then
            OpenWindow;
          Window.Update(1,WindowNo);
          Window.Update(2,WindowPostingDate);
        end;
    end;

    local procedure IsTimeForUpdate(): Boolean
    begin
        if WindowUpdateDateTime = 0DT then
          WindowUpdateDateTime := CurrentDatetime;
        if CurrentDatetime - WindowUpdateDateTime >= 1000 then begin
          WindowUpdateDateTime := CurrentDatetime;
          exit(true);
        end;
        exit(false);
    end;
}

