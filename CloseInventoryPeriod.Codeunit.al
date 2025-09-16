#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5820 "Close Inventory Period"
{
    Permissions = TableData "Inventory Period"=imd,
                  TableData "Inventory Period Entry"=imd;
    TableNo = "Inventory Period";

    trigger OnRun()
    begin
        if not HideDialog then
          if not ReOpen then begin
            if not Confirm(
                 Text002,
                 false,
                 "Ending Date")
            then
              exit
          end else
            if not Confirm(Text006,false,TableCaption,"Ending Date") then
              exit;

        TestField(Closed,ReOpen);
        if not ReOpen then begin
          TestField("Ending Date");
          CheckCostIsAdjusted("Ending Date");
          CheckOpenOutboundEntryExist("Ending Date");
        end else
          if not HideDialog and AccPeriodIsClosed("Ending Date") then
            if not Confirm(Text008,false,TableCaption,"Ending Date") then
              exit;

        UpdateInvtPeriod(Rec);
        CreateInvtPeriodEntry(Rec);

        if not HideDialog then
          if not ReOpen then begin
            Message(Text005,TableCaption,"Ending Date")
          end else
            Message(Text007,"Ending Date");
    end;

    var
        Text000: label 'The Inventory Period cannot be closed because there is at least one item with unadjusted entries in the current period.\\Run the Close Inventory Period - Test report to identify item ledger entries for the affected items.';
        Text001: label 'The Inventory Period cannot be closed because there is negative inventory for one or more items.\\Run the Close Inventory Period - Test report to identify item ledger entries for the affected items.';
        Text002: label 'This function closes the inventory up to %1. Once it is closed, you cannot post in the period until it is re-opened.\\Make sure that all your inventory is posted to G/L.\\Do you want to close the inventory period?';
        Text005: label 'The %1 has been closed on %2.';
        Text006: label 'Do you want to reopen the %1 that ends %2?';
        Text007: label 'All inventory periods from %1 have been reopened.';
        ReOpen: Boolean;
        HideDialog: Boolean;
        Text008: label 'The accounting period is already closed. Are you sure you want to reopen the %1 that ends %2?';
        Text010: label 'The Inventory Period cannot be closed because there is at least one %1 Order in the current period that has not been adjusted.\\Run the Close Inventory Period - Test report to identify the affected orders.';

    local procedure CheckCostIsAdjusted(EndingDate: Date)
    var
        AvgCostAdjmtEntryPoint: Record "Avg. Cost Adjmt. Entry Point";
        InvtAdjmtEntryOrder: Record "Inventory Adjmt. Entry (Order)";
        ValueEntry: Record "Value Entry";
    begin
        AvgCostAdjmtEntryPoint.Reset;
        AvgCostAdjmtEntryPoint.SetCurrentkey("Item No.","Cost Is Adjusted","Valuation Date");
        AvgCostAdjmtEntryPoint.SetRange("Cost Is Adjusted",false);
        AvgCostAdjmtEntryPoint.SetRange("Valuation Date",0D,EndingDate);
        if not AvgCostAdjmtEntryPoint.IsEmpty then
          Error(Text000);

        InvtAdjmtEntryOrder.SetCurrentkey("Cost is Adjusted");
        InvtAdjmtEntryOrder.SetRange("Cost is Adjusted",false);
        InvtAdjmtEntryOrder.SetRange("Is Finished",true);
        if InvtAdjmtEntryOrder.FindSet then
          repeat
            ValueEntry.SetCurrentkey("Order Type","Order No.","Order Line No.");
            ValueEntry.SetRange("Order Type",InvtAdjmtEntryOrder."Order Type");
            ValueEntry.SetRange("Order No.",InvtAdjmtEntryOrder."Order No.");
            ValueEntry.SetRange("Order Line No.",InvtAdjmtEntryOrder."Order Line No.");
            ValueEntry.SetFilter("Item Ledger Entry Type",'%1|%2',
              ValueEntry."item ledger entry type"::Output,ValueEntry."item ledger entry type"::"Assembly Output");
            ValueEntry.SetRange("Valuation Date",0D,EndingDate);
            if not ValueEntry.IsEmpty then
              Error(Text010,InvtAdjmtEntryOrder."Order Type");
          until InvtAdjmtEntryOrder.Next = 0;
    end;

    local procedure CheckOpenOutboundEntryExist(EndingDate: Date)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.SetCurrentkey("Item No.",Open,"Variant Code",Positive,"Location Code","Posting Date");
        ItemLedgEntry.SetRange(Open,true);
        ItemLedgEntry.SetRange(Positive,false);
        ItemLedgEntry.SetRange("Posting Date",0D,EndingDate);
        if not ItemLedgEntry.IsEmpty then
          Error(Text001);
    end;

    local procedure AccPeriodIsClosed(StartDate: Date): Boolean
    var
        AccPeriod: Record "Accounting Period";
    begin
        AccPeriod.SetCurrentkey(Closed);
        AccPeriod.SetRange(Closed,true);
        AccPeriod.SetFilter("Starting Date",'>=%1',StartDate);
        exit(not AccPeriod.IsEmpty);
    end;

    local procedure UpdateInvtPeriod(var TheInvtPeriod: Record "Inventory Period")
    var
        InvtPeriod2: Record "Inventory Period";
        InvtPeriod3: Record "Inventory Period";
    begin
        with TheInvtPeriod do begin
          InvtPeriod2.SetRange(Closed,ReOpen);
          if ReOpen then
            InvtPeriod2.SetFilter("Ending Date",'>%1',"Ending Date")
          else
            InvtPeriod2.SetFilter("Ending Date",'<%1',"Ending Date");
          if InvtPeriod2.FindSet(true,true) then
            repeat
              InvtPeriod3 := InvtPeriod2;
              InvtPeriod3.Closed := not ReOpen;
              InvtPeriod3.Modify;
              CreateInvtPeriodEntry(InvtPeriod3);
            until InvtPeriod2.Next = 0;

          Closed := not ReOpen;
          Modify;
        end;
    end;

    local procedure CreateInvtPeriodEntry(InvtPeriod: Record "Inventory Period")
    var
        InvtPeriodEntry: Record "Inventory Period Entry";
        ItemRegister: Record "Item Register";
        EntryNo: Integer;
    begin
        with InvtPeriod do begin
          InvtPeriodEntry.SetRange("Ending Date","Ending Date");
          if InvtPeriodEntry.FindLast then
            EntryNo := InvtPeriodEntry."Entry No." + 1
          else
            EntryNo := 1;

          InvtPeriodEntry.Init;
          InvtPeriodEntry."Entry No." := EntryNo;
          InvtPeriodEntry."Ending Date" := "Ending Date";
          InvtPeriodEntry."User ID" := UserId;
          InvtPeriodEntry."Creation Date" := WorkDate;
          InvtPeriodEntry."Creation Time" := Time;
          if Closed then begin
            InvtPeriodEntry."Entry Type" := InvtPeriodEntry."entry type"::Close;
            if ItemRegister.FindLast then
              InvtPeriodEntry."Closing Item Register No." := ItemRegister."No.";
          end else
            InvtPeriodEntry."Entry Type" := InvtPeriodEntry."entry type"::"Re-open";

          InvtPeriodEntry.Insert;
        end;
    end;


    procedure SetReOpen(NewReOpen: Boolean)
    begin
        ReOpen := NewReOpen;
    end;


    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;
}

