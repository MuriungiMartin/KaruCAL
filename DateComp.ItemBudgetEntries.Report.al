#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7139 "Date Comp. Item Budget Entries"
{
    Caption = 'Date Compr. Item Budget Entries';
    Permissions = TableData "Date Compr. Register"=rimd;
    ProcessingOnly = true;
    UsageCategory = Tasks;

    dataset
    {
        dataitem("Item Budget Entry";"Item Budget Entry")
        {
            DataItemTableView = sorting("Analysis Area","Budget Name","Item No.",Date);
            RequestFilterFields = "Budget Name","Item No.";
            column(ReportForNavId_4172; 4172)
            {
            }

            trigger OnAfterGetRecord()
            var
                ItemBudgetName: Record "Item Budget Name";
            begin
                ItemBudgetName.Get("Analysis Area","Budget Name");
                Retain[3] :=
                  TempSelectedDim.Get(
                    UserId,3,Report::"Date Comp. Item Budget Entries",'',ItemBudgetName."Budget Dimension 1 Code");
                Retain[4] :=
                  TempSelectedDim.Get(
                    UserId,3,Report::"Date Comp. Item Budget Entries",'',ItemBudgetName."Budget Dimension 2 Code");
                Retain[5] :=
                  TempSelectedDim.Get(
                    UserId,3,Report::"Date Comp. Item Budget Entries",'',ItemBudgetName."Budget Dimension 3 Code");
                ItemBudgetEntry2 := "Item Budget Entry";
                with ItemBudgetEntry2 do begin
                  SetCurrentkey("Analysis Area","Budget Name","Item No.",Date);
                  CopyFilters("Item Budget Entry");
                  SetFilter(Date,DateComprMgt.GetDateFilter(Date,EntrdDateComprReg,false));
                  SetRange("Analysis Area","Analysis Area");
                  SetRange("Budget Name","Budget Name");
                  SetRange("Item No.","Item No.");

                  LastEntryNo := LastEntryNo + 1;

                  if RetainNo(FieldNo("Global Dimension 1 Code")) then
                    SetRange("Global Dimension 1 Code","Global Dimension 1 Code");
                  if RetainNo(FieldNo("Global Dimension 2 Code")) then
                    SetRange("Global Dimension 2 Code","Global Dimension 2 Code");
                  if Quantity >= 0 then
                    SetFilter(Quantity,'>=0')
                  else
                    SetFilter(Quantity,'<0');
                  if "Cost Amount" >= 0 then
                    SetFilter("Cost Amount",'>=0')
                  else
                    SetFilter("Cost Amount",'<0');
                  if "Sales Amount" >= 0 then
                    SetFilter("Sales Amount",'>=0')
                  else
                    SetFilter("Sales Amount",'<0');

                  InitNewEntry(NewItemBudgetEntry);

                  DimBufMgt.CollectDimEntryNo(
                    TempSelectedDim,"Dimension Set ID","Entry No.",0,false,DimEntryNo);
                  ComprDimEntryNo := DimEntryNo;
                  SummarizeEntry(NewItemBudgetEntry,ItemBudgetEntry2);
                  while Next <> 0 do begin
                    DimBufMgt.CollectDimEntryNo(
                      TempSelectedDim,"Dimension Set ID","Entry No.",ComprDimEntryNo,true,DimEntryNo);
                    if DimEntryNo = ComprDimEntryNo then
                      SummarizeEntry(NewItemBudgetEntry,ItemBudgetEntry2);
                  end;

                  InsertNewEntry(NewItemBudgetEntry,ComprDimEntryNo);

                  ComprCollectedEntries;
                end;

                if DateComprReg."No. Records Deleted" >= NoOfDeleted + 10 then begin
                  NoOfDeleted := DateComprReg."No. Records Deleted";
                  InsertRegisters(DateComprReg);
                  Commit;
                  ItemBudgetEntry2.LockTable;
                  ItemBudgetEntry2.Reset;
                  if ItemBudgetEntry2.Find('+') then;
                  LastEntryNo := ItemBudgetEntry2."Entry No.";
                end;
            end;

            trigger OnPostDataItem()
            var
                UpdateAnalysisView: Codeunit "Update Analysis View";
            begin
                if DateComprReg."No. Records Deleted" > NoOfDeleted then
                  InsertRegisters(DateComprReg);

                if AnalysisView.FindFirst then
                  if LowestEntryNo < 2147483647 then
                    UpdateAnalysisView.SetLastBudgetEntryNo(LowestEntryNo - 1);
            end;

            trigger OnPreDataItem()
            var
                GLSetup: Record "General Ledger Setup";
            begin
                if not
                   Confirm(Text000,false)
                then
                  CurrReport.Break;

                if EntrdDateComprReg."Ending Date" = 0D then
                  Error(
                    Text002,
                    EntrdDateComprReg.FieldCaption("Ending Date"));

                DateComprReg.Init;
                DateComprReg."Starting Date" := EntrdDateComprReg."Starting Date";
                DateComprReg."Ending Date" := EntrdDateComprReg."Ending Date";
                DateComprReg."Period Length" := EntrdDateComprReg."Period Length";

                if AnalysisView.FindFirst then begin
                  AnalysisView.CheckDimensionsAreRetained(3,Report::"Date Comp. Item Budget Entries",true);
                  AnalysisView.CheckViewsAreUpdated;
                  Commit;
                end;

                SelectedDim.GetSelectedDim(
                  UserId,3,Report::"Date Comp. Item Budget Entries",'',TempSelectedDim);
                GLSetup.Get;
                Retain[1] :=
                  TempSelectedDim.Get(
                    UserId,3,Report::"Date Comp. Item Budget Entries",'',GLSetup."Global Dimension 1 Code");
                Retain[2] :=
                  TempSelectedDim.Get(
                    UserId,3,Report::"Date Comp. Item Budget Entries",'',GLSetup."Global Dimension 2 Code");

                SourceCodeSetup.Get;
                SourceCodeSetup.TestField("Compress Item Budget");

                ItemBudgetEntry2.LockTable;
                if ItemBudgetEntry2.Find('+') then;
                LastEntryNo := ItemBudgetEntry2."Entry No.";
                LowestEntryNo := 2147483647;

                Window.Open(
                  Text003 +
                  Text004 +
                  Text005 +
                  Text006 +
                  Text007 +
                  Text008);

                SetRange("Entry No.",0,LastEntryNo);
                SetRange(Date,EntrdDateComprReg."Starting Date",EntrdDateComprReg."Ending Date");
                SetRange("Analysis Area",AnalysisAreaSelection);

                InitRegisters;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(AnalysisArea;AnalysisAreaSelection)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Analysis Area';
                        OptionCaption = 'Sales,Purchase';
                    }
                    field(StartingDate;EntrdDateComprReg."Starting Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                        ClosingDates = true;
                    }
                    field(EndingDate;EntrdDateComprReg."Ending Date")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                        ClosingDates = true;
                    }
                    field(PeriodLength;EntrdDateComprReg."Period Length")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period Length';
                        OptionCaption = 'Day,Week,Month,Quarter,Year,Period';
                    }
                    field(PostingDescription;EntrdItemBudgetEntry.Description)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Description';
                    }
                    field(RetainDimensions;RetainDimText)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Retain Dimensions';
                        Editable = false;

                        trigger OnAssistEdit()
                        begin
                            DimSelectionBuf.SetDimSelectionMultiple(3,Report::"Date Comp. Item Budget Entries",RetainDimText);
                        end;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitializeVariables;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        DimSelectionBuf.CompareDimText(
          3,Report::"Date Comp. Item Budget Entries",'',RetainDimText,Text009);
        ItemBudgetEntryFilter := "Item Budget Entry".GetFilters;
    end;

    var
        Text000: label 'This batch job deletes entries.\\Do you want to date compress the entries?';
        Text002: label '%1 must be specified.';
        Text003: label 'Date compressing Item budget entries...\\';
        Text004: label 'Budget Name          #1##########\';
        Text005: label 'Item No.             #2##########\';
        Text006: label 'Date                 #3######\\';
        Text007: label 'No. of new entries   #4######\';
        Text008: label 'No. of entries del.  #5######';
        Text009: label 'Retain Dimensions';
        SourceCodeSetup: Record "Source Code Setup";
        DateComprReg: Record "Date Compr. Register";
        EntrdDateComprReg: Record "Date Compr. Register";
        EntrdItemBudgetEntry: Record "Item Budget Entry";
        NewItemBudgetEntry: Record "Item Budget Entry";
        ItemBudgetEntry2: Record "Item Budget Entry";
        SelectedDim: Record "Selected Dimension";
        TempSelectedDim: Record "Selected Dimension" temporary;
        DimSelectionBuf: Record "Dimension Selection Buffer";
        AnalysisView: Record "Item Analysis View";
        DateComprMgt: Codeunit DateComprMgt;
        DimBufMgt: Codeunit "Dimension Buffer Management";
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        NoOfFields: Integer;
        Retain: array [10] of Boolean;
        FieldNumber: array [10] of Integer;
        FieldNameArray: array [10] of Text[100];
        LastEntryNo: Integer;
        LowestEntryNo: Integer;
        NoOfDeleted: Integer;
        i: Integer;
        ComprDimEntryNo: Integer;
        DimEntryNo: Integer;
        RetainDimText: Text[250];
        AnalysisAreaSelection: Option Sales,Purchase;
        ItemBudgetEntryFilter: Text;

    local procedure InitRegisters()
    begin
        if DateComprReg.FindLast then;
        DateComprReg.Init;
        DateComprReg."No." := DateComprReg."No." + 1;
        DateComprReg."Table ID" := Database::"Item Budget Entry";
        DateComprReg."Creation Date" := Today;
        DateComprReg."Starting Date" := EntrdDateComprReg."Starting Date";
        DateComprReg."Ending Date" := EntrdDateComprReg."Ending Date";
        DateComprReg."Period Length" := EntrdDateComprReg."Period Length";
        for i := 1 to NoOfFields do
          if Retain[i] then
            DateComprReg."Retain Field Contents" :=
              CopyStr(
                DateComprReg."Retain Field Contents" + ',' + FieldNameArray[i],1,
                MaxStrLen(DateComprReg."Retain Field Contents"));
        DateComprReg."Retain Field Contents" := CopyStr(DateComprReg."Retain Field Contents",2);
        DateComprReg.Filter := CopyStr(ItemBudgetEntryFilter,1,MaxStrLen(DateComprReg.Filter));
        DateComprReg."Register No." := "Item Budget Entry"."Entry No.";
        DateComprReg."Source Code" := SourceCodeSetup."Compress Item Budget";
        DateComprReg."User ID" := UserId;

        NoOfDeleted := 0;
    end;

    local procedure InsertRegisters(var DateComprReg: Record "Date Compr. Register")
    begin
        DateComprReg.Insert;

        NewItemBudgetEntry.LockTable;
        DateComprReg.LockTable;

        ItemBudgetEntry2.Reset;
        if ItemBudgetEntry2.Find('+') then;
        if LastEntryNo <> ItemBudgetEntry2."Entry No." then begin
          LastEntryNo := ItemBudgetEntry2."Entry No.";
          InitRegisters;
        end;
    end;

    local procedure InsertField(Number: Integer;Name: Text[100])
    begin
        NoOfFields := NoOfFields + 1;
        FieldNumber[NoOfFields] := Number;
        FieldNameArray[NoOfFields] := Name;
    end;

    local procedure RetainNo(Number: Integer): Boolean
    begin
        exit(Retain[Index(Number)]);
    end;

    local procedure Index(Number: Integer): Integer
    begin
        for i := 1 to NoOfFields do
          if Number = FieldNumber[i] then
            exit(i);
    end;

    local procedure SummarizeEntry(var NewItemBudgetEntry: Record "Item Budget Entry";ItemBudgetEntry: Record "Item Budget Entry")
    begin
        with ItemBudgetEntry do begin
          NewItemBudgetEntry.Quantity := NewItemBudgetEntry.Quantity + Quantity;
          NewItemBudgetEntry."Cost Amount" := NewItemBudgetEntry."Cost Amount" + "Cost Amount";
          NewItemBudgetEntry."Sales Amount" := NewItemBudgetEntry."Sales Amount" + "Sales Amount";
          Delete;
          if "Entry No." < LowestEntryNo then
            LowestEntryNo := "Entry No.";
          DateComprReg."No. Records Deleted" := DateComprReg."No. Records Deleted" + 1;
          Window.Update(5,DateComprReg."No. Records Deleted");
        end;
    end;

    local procedure ComprCollectedEntries()
    var
        ItemBudgetEntry: Record "Item Budget Entry";
        OldDimEntryNo: Integer;
        Found: Boolean;
        ItemBudgetEntryNo: Integer;
    begin
        OldDimEntryNo := 0;
        if DimBufMgt.FindFirstDimEntryNo(DimEntryNo,ItemBudgetEntryNo) then begin
          InitNewEntry(NewItemBudgetEntry);
          repeat
            ItemBudgetEntry.Get(ItemBudgetEntryNo);
            SummarizeEntry(ItemBudgetEntry,ItemBudgetEntry);
            OldDimEntryNo := DimEntryNo;
            Found := DimBufMgt.NextDimEntryNo(DimEntryNo,ItemBudgetEntryNo);
            if (OldDimEntryNo <> DimEntryNo) or not Found then begin
              InsertNewEntry(NewItemBudgetEntry,OldDimEntryNo);
              if Found then
                InitNewEntry(NewItemBudgetEntry);
            end;
            OldDimEntryNo := DimEntryNo;
          until not Found;
        end;
        DimBufMgt.DeleteAllDimEntryNo;
    end;


    procedure InitNewEntry(var NewItemBudgetEntry: Record "Item Budget Entry")
    begin
        LastEntryNo := LastEntryNo + 1;

        with ItemBudgetEntry2 do begin
          NewItemBudgetEntry.Init;
          NewItemBudgetEntry."Entry No." := LastEntryNo;
          NewItemBudgetEntry."Analysis Area" := AnalysisAreaSelection;
          NewItemBudgetEntry."Budget Name" := "Budget Name";
          NewItemBudgetEntry."Item No." := "Item No.";
          NewItemBudgetEntry.Date := GetRangeMin(Date);
          NewItemBudgetEntry.Description := EntrdItemBudgetEntry.Description;
          NewItemBudgetEntry."User ID" := UserId;

          if RetainNo(FieldNo("Global Dimension 1 Code")) then
            NewItemBudgetEntry."Global Dimension 1 Code" := "Global Dimension 1 Code";
          if RetainNo(FieldNo("Global Dimension 2 Code")) then
            NewItemBudgetEntry."Global Dimension 2 Code" := "Global Dimension 2 Code";
          if RetainNo(FieldNo("Budget Dimension 1 Code")) then
            NewItemBudgetEntry."Budget Dimension 1 Code" := "Budget Dimension 1 Code";
          if RetainNo(FieldNo("Budget Dimension 2 Code")) then
            NewItemBudgetEntry."Budget Dimension 2 Code" := "Budget Dimension 2 Code";
          if RetainNo(FieldNo("Budget Dimension 3 Code")) then
            NewItemBudgetEntry."Budget Dimension 3 Code" := "Budget Dimension 3 Code";

          Window.Update(1,NewItemBudgetEntry."Budget Name");
          Window.Update(2,NewItemBudgetEntry."Item No.");
          Window.Update(3,NewItemBudgetEntry.Date);
          DateComprReg."No. of New Records" := DateComprReg."No. of New Records" + 1;
          Window.Update(4,DateComprReg."No. of New Records");
        end;
    end;

    local procedure InsertNewEntry(var NewItemBudgetEntry: Record "Item Budget Entry";DimEntryNo: Integer)
    var
        TempDimBuf: Record "Dimension Buffer" temporary;
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
    begin
        TempDimBuf.DeleteAll;
        DimBufMgt.GetDimensions(DimEntryNo,TempDimBuf);
        DimMgt.CopyDimBufToDimSetEntry(TempDimBuf,TempDimSetEntry);
        NewItemBudgetEntry."Dimension Set ID" := DimMgt.GetDimensionSetID(TempDimSetEntry);
        NewItemBudgetEntry.Insert;
    end;


    procedure InitializeRequest(AnalAreaSelection: Option;StartDate: Date;EndDate: Date;PeriodLength: Option;Desc: Text[50])
    begin
        InitializeVariables;
        AnalysisAreaSelection := AnalAreaSelection;
        EntrdDateComprReg."Starting Date" := StartDate;
        EntrdDateComprReg."Ending Date" := EndDate;
        EntrdDateComprReg."Period Length" := PeriodLength;
        EntrdItemBudgetEntry.Description := Desc;
    end;

    local procedure InitializeVariables()
    begin
        if EntrdDateComprReg."Ending Date" = 0D then
          EntrdDateComprReg."Ending Date" := Today;

        with "Item Budget Entry" do begin
          InsertField(FieldNo("Global Dimension 1 Code"),FieldCaption("Global Dimension 1 Code"));
          InsertField(FieldNo("Global Dimension 2 Code"),FieldCaption("Global Dimension 2 Code"));
          InsertField(FieldNo("Budget Dimension 1 Code"),FieldCaption("Budget Dimension 1 Code"));
          InsertField(FieldNo("Budget Dimension 2 Code"),FieldCaption("Budget Dimension 2 Code"));
          InsertField(FieldNo("Budget Dimension 3 Code"),FieldCaption("Budget Dimension 3 Code"));
        end;

        RetainDimText := DimSelectionBuf.GetDimSelectionText(3,Report::"Date Comp. Item Budget Entries",'');
    end;
}

