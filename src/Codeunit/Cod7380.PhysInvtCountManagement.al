#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7380 "Phys. Invt. Count.-Management"
{

    trigger OnRun()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
    begin
        with Item do begin
          SetFilter("Phys Invt Counting Period Code",'<>''''');
          SetFilter("Next Counting Start Date",'<>%1',0D);
          SetFilter("Next Counting End Date",'<>%1',0D);
          if Find('-') then
            repeat
              if ("Last Counting Period Update" < "Next Counting Start Date") and
                 (WorkDate >= "Next Counting Start Date") and (WorkDate <= "Next Counting End Date")
              then
                InsertTempPhysCountBuffer(
                  "No.",'','',"Shelf No.","Phys Invt Counting Period Code",
                  Description,"Next Counting Start Date","Next Counting End Date","Last Counting Period Update",1);

            until Next = 0;
        end;

        with SKU do begin
          SetFilter("Phys Invt Counting Period Code",'<>''''');
          SetFilter("Next Counting Start Date",'<>%1',0D);
          SetFilter("Next Counting End Date",'<>%1',0D);
          if SourceJnl = Sourcejnl::WhseJnl then
            SetRange("Location Code",WhseJnlLine."Location Code");
          if Find('-') then
            repeat
              if ("Last Counting Period Update" < "Next Counting Start Date") and
                 (WorkDate >= "Next Counting Start Date") and (WorkDate <= "Next Counting End Date")
              then
                InsertTempPhysCountBuffer(
                  "Item No.","Variant Code","Location Code",
                  "Shelf No.","Phys Invt Counting Period Code",Description,
                  "Next Counting Start Date","Next Counting End Date","Last Counting Period Update",2);

            until Next = 0;
        end;

        if Page.RunModal(
             Page::"Phys. Invt. Item Selection",TempPhysInvtItemSel) <> Action::LookupOK
        then
          exit;

        TempPhysInvtItemSel.SetRange(Selected,true);
        if TempPhysInvtItemSel.Find('-') then begin
          if SourceJnl = Sourcejnl::ItemJnl then
            CreatePhysInvtItemJnl
          else
            CreatePhysInvtWhseJnl;
        end;
    end;

    var
        TempPhysInvtItemSel: Record "Phys. Invt. Item Selection" temporary;
        PhysInvtCount: Record "Phys. Invt. Counting Period";
        ItemJnlLine: Record "Item Journal Line";
        WhseJnlLine: Record "Warehouse Journal Line";
        TempItem: Record Item temporary;
        TempSKU: Record "Stockkeeping Unit" temporary;
        SourceJnl: Option ItemJnl,WhseJnl;
        Text000: label 'Processing items    #1##########';
        SortingMethod: Option " ",Item,Bin;
        Text001: label 'Do you want to update the Next Counting Period of the %1?';
        Text002: label 'Canceled.';
        HideValidationDialog: Boolean;

    local procedure InsertTempPhysCountBuffer(ItemNo: Code[20];VariantCode: Code[10];LocationCode: Code[10];ShelfBin: Code[10];PhysInvtCountCode: Code[10];Description: Text[50];CountingPeriodStartDate: Date;CountingPeriodEndDate: Date;LastCountDate: Date;SourceType: Option Item,SKU)
    begin
        TempPhysInvtItemSel.Init;
        TempPhysInvtItemSel."Item No." := ItemNo;
        TempPhysInvtItemSel."Variant Code" := VariantCode;
        TempPhysInvtItemSel."Location Code" := LocationCode;
        TempPhysInvtItemSel."Phys Invt Counting Period Code" := PhysInvtCountCode;
        TempPhysInvtItemSel."Phys Invt Counting Period Type" := SourceType;
        TempPhysInvtItemSel."Shelf No." := ShelfBin;
        TempPhysInvtItemSel."Last Counting Date" := LastCountDate;
        TempPhysInvtItemSel."Next Counting Start Date" := CountingPeriodStartDate;
        TempPhysInvtItemSel."Next Counting End Date" := CountingPeriodEndDate;
        GetPhysInvtCount(PhysInvtCountCode);
        TempPhysInvtItemSel."Count Frequency per Year" :=
          PhysInvtCount."Count Frequency per Year";
        TempPhysInvtItemSel.Description := Description;
        if TempPhysInvtItemSel.Insert then;
    end;

    local procedure CreatePhysInvtItemJnl()
    var
        Item: Record Item;
        ItemJnlBatch: Record "Item Journal Batch";
        PhysInvtCountRep: Report "Calculate Phys. Invt. Counting";
        CalcQtyOnHand: Report "Calculate Inventory";
        PhysInvtList: Report "Phys. Inventory List";
        Window: Dialog;
        PostingDate: Date;
        DocNo: Code[20];
        PrintDoc: Boolean;
        PrintDocPerItem: Boolean;
        ZeroQty: Boolean;
        PrintQtyCalculated: Boolean;
    begin
        ItemJnlBatch.Get(
          ItemJnlLine."Journal Template Name",ItemJnlLine."Journal Batch Name");
        PhysInvtCountRep.SetItemJnlLine(ItemJnlBatch);
        PhysInvtCountRep.RunModal;

        if PhysInvtCountRep.GetRequest(
             PostingDate,DocNo,SortingMethod,PrintDoc,PrintDocPerItem,ZeroQty,PrintQtyCalculated)
        then begin
          Window.Open(Text000,TempPhysInvtItemSel."Item No.");
          repeat
            Window.Update;
            CalcQtyOnHand.SetSkipDim(true);
            CalcQtyOnHand.InitializeRequest(PostingDate,DocNo,ZeroQty);
            CalcQtyOnHand.SetItemJnlLine(ItemJnlLine);
            CalcQtyOnHand.InitializePhysInvtCount(
              TempPhysInvtItemSel."Phys Invt Counting Period Code",
              TempPhysInvtItemSel."Phys Invt Counting Period Type");
            CalcQtyOnHand.UseRequestPage(false);
            CalcQtyOnHand.SetHideValidationDialog(true);
            Item.SetRange("No.",TempPhysInvtItemSel."Item No.");
            if TempPhysInvtItemSel."Phys Invt Counting Period Type" =
               TempPhysInvtItemSel."phys invt counting period type"::SKU
            then begin
              Item.SetRange("Variant Filter",TempPhysInvtItemSel."Variant Code");
              Item.SetRange("Location Filter",TempPhysInvtItemSel."Location Code");
            end;
            CalcQtyOnHand.SetTableview(Item);
            CalcQtyOnHand.RunModal;
            Clear(CalcQtyOnHand);
          until TempPhysInvtItemSel.Next = 0;
          Window.Close;

          if PrintDoc then begin
            if not PrintDocPerItem then begin
              ItemJnlBatch.SetRecfilter;
              ItemJnlLine.SetRange(
                "Journal Template Name",ItemJnlLine."Journal Template Name");
              ItemJnlLine.SetRange(
                "Journal Batch Name",ItemJnlLine."Journal Batch Name");
              PhysInvtList.UseRequestPage(false);
              PhysInvtList.Initialize(PrintQtyCalculated);
              PhysInvtList.SetTableview(ItemJnlBatch);
              PhysInvtList.SetTableview(ItemJnlLine);
              PhysInvtList.Run;
            end else begin
              TempPhysInvtItemSel.Find('-');
              repeat
                ItemJnlBatch.SetRecfilter;
                PhysInvtList.SetTableview(ItemJnlBatch);
                ItemJnlLine.SetRange(
                  "Journal Template Name",ItemJnlLine."Journal Template Name");
                ItemJnlLine.SetRange(
                  "Journal Batch Name",ItemJnlLine."Journal Batch Name");
                ItemJnlLine.SetRange("Item No.",TempPhysInvtItemSel."Item No.");
                PhysInvtList.UseRequestPage(false);
                PhysInvtList.Initialize(PrintQtyCalculated);
                PhysInvtList.SetTableview(ItemJnlLine);
                PhysInvtList.Run;
                TempPhysInvtItemSel.SetRange("Item No.",
                  TempPhysInvtItemSel."Item No.");
                TempPhysInvtItemSel.Find('+');
                TempPhysInvtItemSel.SetRange("Item No.");
              until TempPhysInvtItemSel.Next = 0;
            end;
            Clear(PhysInvtList);
          end;
        end;
    end;

    local procedure CreatePhysInvtWhseJnl()
    var
        BinContent: Record "Bin Content";
        WhseJnlBatch: Record "Warehouse Journal Batch";
        PhysInvtCountRep: Report "Calculate Phys. Invt. Counting";
        CalcWhseQtyOnHand: Report "Whse. Calculate Inventory";
        WhsePhysInvtList: Report "Whse. Phys. Inventory List";
        Window: Dialog;
        PostingDate: Date;
        DocNo: Code[20];
        PrintDoc: Boolean;
        PrintDocPerItem: Boolean;
        ZeroQty: Boolean;
        PrintQtyCalculated: Boolean;
    begin
        WhseJnlBatch.Get(
          WhseJnlLine."Journal Template Name",WhseJnlLine."Journal Batch Name",WhseJnlLine."Location Code");
        PhysInvtCountRep.SetWhseJnlLine(WhseJnlBatch);
        PhysInvtCountRep.RunModal;

        if PhysInvtCountRep.GetRequest(
             PostingDate,DocNo,SortingMethod,PrintDoc,PrintDocPerItem,ZeroQty,PrintQtyCalculated)
        then begin
          Window.Open(Text000,TempPhysInvtItemSel."Item No.");
          repeat
            Window.Update;
            CalcWhseQtyOnHand.InitializeRequest(PostingDate,DocNo,ZeroQty);

            CalcWhseQtyOnHand.InitializePhysInvtCount(
              TempPhysInvtItemSel."Phys Invt Counting Period Code",
              TempPhysInvtItemSel."Phys Invt Counting Period Type");
            CalcWhseQtyOnHand.SetWhseJnlLine(WhseJnlLine);
            CalcWhseQtyOnHand.UseRequestPage(false);
            CalcWhseQtyOnHand.SetHideValidationDialog(true);
            BinContent.SetRange("Location Code",TempPhysInvtItemSel."Location Code");
            BinContent.SetRange("Item No.",TempPhysInvtItemSel."Item No.");
            if TempPhysInvtItemSel."Phys Invt Counting Period Type" =
               TempPhysInvtItemSel."phys invt counting period type"::SKU
            then
              BinContent.SetRange("Variant Code",TempPhysInvtItemSel."Variant Code");
            CalcWhseQtyOnHand.SetTableview(BinContent);
            CalcWhseQtyOnHand.RunModal;
            Clear(CalcWhseQtyOnHand);
          until TempPhysInvtItemSel.Next = 0;
          Window.Close;

          if PrintDoc then begin
            if not PrintDocPerItem then begin
              WhseJnlBatch.SetRecfilter;
              case SortingMethod of
                Sortingmethod::Item:
                  WhseJnlLine.SetCurrentkey("Location Code","Item No.","Variant Code");
                Sortingmethod::Bin:
                  WhseJnlLine.SetCurrentkey("Location Code","Bin Code");
              end;
              WhseJnlLine.SetRange(
                "Journal Template Name",WhseJnlLine."Journal Template Name");
              WhseJnlLine.SetRange(
                "Journal Batch Name",WhseJnlLine."Journal Batch Name");
              WhseJnlLine.SetRange(
                "Journal Template Name",WhseJnlLine."Journal Template Name");
              WhseJnlLine.SetRange(
                "Journal Batch Name",WhseJnlLine."Journal Batch Name");
              WhseJnlLine.SetRange("Location Code",WhseJnlBatch."Location Code");
              WhsePhysInvtList.UseRequestPage(false);
              WhsePhysInvtList.Initialize(PrintQtyCalculated);
              WhsePhysInvtList.SetTableview(WhseJnlBatch);
              WhsePhysInvtList.SetTableview(WhseJnlLine);
              WhsePhysInvtList.Run;
            end else begin
              TempPhysInvtItemSel.Find('-');
              repeat
                WhseJnlBatch.SetRecfilter;
                case SortingMethod of
                  Sortingmethod::Item:
                    WhseJnlLine.SetCurrentkey("Location Code","Item No.","Variant Code");
                  Sortingmethod::Bin:
                    WhseJnlLine.SetCurrentkey("Location Code","Bin Code");
                end;
                WhseJnlLine.SetRange(
                  "Journal Template Name",WhseJnlLine."Journal Template Name");
                WhseJnlLine.SetRange(
                  "Journal Batch Name",WhseJnlLine."Journal Batch Name");
                WhseJnlLine.SetRange("Item No.",TempPhysInvtItemSel."Item No.");
                WhseJnlLine.SetRange("Location Code",TempPhysInvtItemSel."Location Code");
                WhsePhysInvtList.UseRequestPage(false);
                WhsePhysInvtList.Initialize(PrintQtyCalculated);
                WhsePhysInvtList.SetTableview(WhseJnlBatch);
                WhsePhysInvtList.SetTableview(WhseJnlLine);
                WhsePhysInvtList.Run;
                TempPhysInvtItemSel.SetRange("Item No.",
                  TempPhysInvtItemSel."Item No.");
                TempPhysInvtItemSel.Find('+');
                TempPhysInvtItemSel.SetRange("Item No.");
              until TempPhysInvtItemSel.Next = 0;
            end;
            Clear(WhsePhysInvtList);
          end;
        end;
    end;


    procedure CalcPeriod(LastDate: Date;var NextCountingStartDate: Date;var NextCountingEndDate: Date;CountFrequency: Integer;UpdateCountingPeriod: Boolean)
    var
        Calendar: Record Date;
        OldStartDate: Date;
        LastCountDate: Date;
        NextStartDate: Date;
        YearEndDate: Date;
        StartDate: Date;
        EndDate: Date;
        Days: Decimal;
        i: Integer;
    begin
        if LastDate = 0D then
          LastCountDate := WorkDate
        else
          LastCountDate := LastDate;

        i := Date2dmy(WorkDate,3);
        Calendar.Reset;
        Calendar.SetRange("Period Type",Calendar."period type"::Year);
        Calendar.SetRange("Period No.",i);
        Calendar.Find('-');
        StartDate := Calendar."Period Start";
        YearEndDate := NormalDate(Calendar."Period End");

        case CountFrequency of
          1,2,3,4,6,12:
            begin
              if StartDate > LastCountDate then begin
                i := Date2dmy(LastCountDate,3);
                Calendar.Reset;
                Calendar.SetRange("Period Type",Calendar."period type"::Year);
                Calendar.SetRange("Period No.",i);
                Calendar.Find('-');
                StartDate := Calendar."Period Start";
              end;
              Calendar.Reset;
              Calendar.SetRange("Period Type",Calendar."period type"::Month);
              Calendar.SetFilter("Period Start",'>= %1',StartDate);
              Calendar.Find('-');
              while StartDate <= LastCountDate do begin
                OldStartDate := StartDate;
                Calendar.Next(12 / CountFrequency);
                StartDate := Calendar."Period Start";
                EndDate := NormalDate(Calendar."Period Start") - 1;
              end;
              StartDate := OldStartDate;
              if UpdateCountingPeriod then begin
                if LastDate <> 0D then begin
                  Calendar.Next(12 / CountFrequency);
                  StartDate := EndDate + 1;
                  EndDate := NormalDate(Calendar."Period Start") - 1;
                end;
                NextCountingStartDate := StartDate;
                NextCountingEndDate := EndDate;
              end;
            end
          else begin
            Calendar.Reset;
            Calendar.SetRange("Period Type",Calendar."period type"::Date);
            Calendar.SetRange("Period Start",StartDate,YearEndDate);
            Calendar.SetRange("Period No.");
            Days := (Calendar.Count DIV CountFrequency);
            if NextCountingStartDate <> 0D then begin
              Calendar.Reset;
              Calendar.SetRange("Period Start",NextCountingStartDate,NextCountingEndDate);
              StartDate := CalcDate('<+1D>',Calendar.GetRangemax("Period Start"));
              OldStartDate := CalcDate('<-1D>',Calendar.GetRangeMin("Period Start"));
              if LastCountDate <= OldStartDate then
                UpdateCountingPeriod := false;
            end;
            if UpdateCountingPeriod then begin
              if LastDate = 0D then
                NextStartDate := CalcDate('<+' + Format(Days) + 'D>',LastCountDate)
              else
                NextStartDate := StartDate;
              EndDate := CalcDate('<+' + Format(Days) + 'D>',NextStartDate);
              NextCountingStartDate := NextStartDate;
              NextCountingEndDate := EndDate;
            end;
          end;
        end;
    end;

    local procedure GetPhysInvtCount(PhysInvtCountCode: Code[10])
    begin
        if PhysInvtCount.Code <> PhysInvtCountCode then
          PhysInvtCount.Get(PhysInvtCountCode);
    end;


    procedure InitFromItemJnl(ItemJnlLine2: Record "Item Journal Line")
    begin
        ItemJnlLine := ItemJnlLine2;
        SourceJnl := Sourcejnl::ItemJnl;
    end;


    procedure InitFromWhseJnl(WhseJnlLine2: Record "Warehouse Journal Line")
    begin
        WhseJnlLine := WhseJnlLine2;
        SourceJnl := Sourcejnl::WhseJnl;
    end;


    procedure GetSortingMethod(var SortingMethod2: Option " ",Item,Bin)
    begin
        SortingMethod2 := SortingMethod;
    end;


    procedure UpdateSKUPhysInvtCount(var SKU: Record "Stockkeeping Unit")
    begin
        with SKU do begin
          if (not MarkedOnly) and (GetFilters = '') then
            SetRecfilter;

          FindSet;
          repeat
            TestField("Phys Invt Counting Period Code");
          until Next = 0;

          if not HideValidationDialog then
            if not Confirm(Text001,false,TableCaption) then
              Error(Text002);

          FindSet;
          repeat
            GetPhysInvtCount("Phys Invt Counting Period Code");
            PhysInvtCount.TestField("Count Frequency per Year");
            "Last Counting Period Update" := WorkDate;
            CalcPeriod(
              "Last Counting Period Update","Next Counting Start Date","Next Counting End Date",
              PhysInvtCount."Count Frequency per Year",true);
            Modify;
          until Next = 0;
        end;
    end;


    procedure UpdateItemPhysInvtCount(var Item: Record Item)
    begin
        with Item do begin
          if (not MarkedOnly) and (GetFilters = '') then
            SetRecfilter;

          FindSet;
          repeat
            TestField("Phys Invt Counting Period Code");
          until Next = 0;

          if not HideValidationDialog then
            if not Confirm(Text001,false,TableCaption) then
              Error(Text002);

          FindSet;
          repeat
            GetPhysInvtCount("Phys Invt Counting Period Code");
            PhysInvtCount.TestField("Count Frequency per Year");
            "Last Counting Period Update" := WorkDate;
            CalcPeriod(
              "Last Counting Period Update","Next Counting Start Date","Next Counting End Date",
              PhysInvtCount."Count Frequency per Year",true);
            Modify;
          until Next = 0;
        end;
    end;


    procedure UpdateItemSKUListPhysInvtCount()
    var
        Item: Record Item;
        SKU: Record "Stockkeeping Unit";
    begin
        with TempItem do begin
          if FindSet then
            repeat
              Item.Reset;
              Item.Get("No.");
              UpdateItemPhysInvtCount(Item);
            until Next = 0;
        end;

        with TempSKU do begin
          if FindSet then
            repeat
              SKU.Reset;
              SKU.Get("Location Code","Item No.","Variant Code");
              UpdateSKUPhysInvtCount(SKU);
            until Next = 0;
        end;
    end;


    procedure AddToTempItemSKUList(ItemNo: Code[20];LocationCode: Code[10];VariantCode: Code[10];PhysInvtCountingPeriodType: Option " ",Item,SKU)
    begin
        case PhysInvtCountingPeriodType of
          Physinvtcountingperiodtype::Item:
            InsertTempItem(ItemNo);
          Physinvtcountingperiodtype::SKU:
            InsertTempSKU(ItemNo,LocationCode,VariantCode);
        end;
    end;

    local procedure InsertTempItem(ItemNo: Code[20])
    begin
        with TempItem do begin
          if Get(ItemNo) then
            exit;

          Init;
          "No." := ItemNo;
          Insert;
        end;
    end;

    local procedure InsertTempSKU(ItemNo: Code[20];LocationCode: Code[10];VariantCode: Code[10])
    begin
        with TempSKU do begin
          if Get(LocationCode,ItemNo,VariantCode) then
            exit;

          Init;
          "Location Code" := LocationCode;
          "Item No." := ItemNo;
          "Variant Code" := VariantCode;
          Insert;
        end;
    end;


    procedure InitTempItemSKUList()
    begin
        SetHideValidationDialog(true);

        TempItem.DeleteAll;
        TempSKU.DeleteAll;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;
}

