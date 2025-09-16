#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5754 "Create Pick"
{
    Caption = 'Create Pick';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            column(ReportForNavId_5444; 5444)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PickWkshLine.SetFilter("Qty. to Handle (Base)",'>%1',0);
                PickWkshLineFilter.CopyFilters(PickWkshLine);

                if PickWkshLine.Find('-') then begin
                  if PickWkshLine."Location Code" = '' then
                    Location.Init
                  else
                    Location.Get(PickWkshLine."Location Code");
                  repeat
                    PickWkshLine.CheckBin(PickWkshLine."Location Code",PickWkshLine."To Bin Code",true);
                    TempNo := TempNo + 1;

                    if PerWhseDoc then begin
                      PickWkshLine.SetRange("Whse. Document Type",PickWkshLine."Whse. Document Type");
                      PickWkshLine.SetRange("Whse. Document No.",PickWkshLine."Whse. Document No.");
                    end;
                    if PerDestination then begin
                      PickWkshLine.SetRange("Destination Type",PickWkshLine."Destination Type");
                      PickWkshLine.SetRange("Destination No.",PickWkshLine."Destination No.");
                      SetPickFilters;
                      PickWkshLineFilter.Copyfilter("Destination Type",PickWkshLine."Destination Type");
                      PickWkshLineFilter.Copyfilter("Destination No.",PickWkshLine."Destination No.");
                    end else begin
                      PickWkshLineFilter.Copyfilter("Destination Type",PickWkshLine."Destination Type");
                      PickWkshLineFilter.Copyfilter("Destination No.",PickWkshLine."Destination No.");
                      SetPickFilters;
                    end;
                    PickWkshLineFilter.Copyfilter("Whse. Document Type",PickWkshLine."Whse. Document Type");
                    PickWkshLineFilter.Copyfilter("Whse. Document No.",PickWkshLine."Whse. Document No.");
                  until not PickWkshLine.Find('-');
                  CheckPickActivity;
                end else
                  Error(Text000);
            end;

            trigger OnPreDataItem()
            begin
                Clear(CreatePick);
                CreatePick.SetValues(
                  AssignedID,0,SortPick,1,MaxNoOfSourceDoc,MaxNoOfLines,PerZone,
                  DoNotFillQtytoHandle,BreakbulkFilter,PerBin);
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
                    group("Create Pick")
                    {
                        Caption = 'Create Pick';
                        field(PerWhseDoc;PerWhseDoc)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Per Whse. Document';
                        }
                        field(PerDestination;PerDestination)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Per Cust./Vend./Loc.';
                        }
                        field(PerItem;PerItem)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Per Item';
                        }
                        field(PerZone;PerZone)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Per From Zone';
                        }
                        field(PerBin;PerBin)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Per Bin';
                        }
                        field(PerDate;PerDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Per Due Date';
                        }
                    }
                    field(MaxNoOfLines;MaxNoOfLines)
                    {
                        ApplicationArea = Basic;
                        BlankZero = true;
                        Caption = 'Max. No. of Pick Lines';
                        MultiLine = true;
                    }
                    field(MaxNoOfSourceDoc;MaxNoOfSourceDoc)
                    {
                        ApplicationArea = Basic;
                        BlankZero = true;
                        Caption = 'Max. No. of Pick Source Docs.';
                        MultiLine = true;
                    }
                    field(AssignedID;AssignedID)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Assigned User ID';
                        TableRelation = "Warehouse Employee";

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            WhseEmployee: Record "Warehouse Employee";
                            LookupWhseEmployee: Page "Warehouse Employee List";
                        begin
                            WhseEmployee.SetCurrentkey("Location Code");
                            WhseEmployee.SetRange("Location Code",LocationCode);
                            LookupWhseEmployee.LookupMode(true);
                            LookupWhseEmployee.SetTableview(WhseEmployee);
                            if LookupWhseEmployee.RunModal = Action::LookupOK then begin
                              LookupWhseEmployee.GetRecord(WhseEmployee);
                              AssignedID := WhseEmployee."User ID";
                            end;
                        end;

                        trigger OnValidate()
                        var
                            WhseEmployee: Record "Warehouse Employee";
                        begin
                            if AssignedID <> '' then
                              WhseEmployee.Get(AssignedID,LocationCode);
                        end;
                    }
                    field(SortPick;SortPick)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sorting Method for Pick Lines';
                        MultiLine = true;
                        OptionCaption = ' ,Item,Document,Shelf/Bin No.,Due Date,Destination,Bin Ranking,Action Type';
                    }
                    field(BreakbulkFilter;BreakbulkFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Set Breakbulk Filter';
                    }
                    field(DoNotFillQtytoHandle;DoNotFillQtytoHandle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Do Not Fill Qty. to Handle';
                    }
                    field(PrintPick;PrintPick)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Pick';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if LocationCode <> '' then begin
              Location.Get(LocationCode);
              if Location."Use ADCS" then
                DoNotFillQtytoHandle := true;
            end;
        end;
    }

    labels
    {
    }

    var
        Text000: label 'There is nothing to handle.';
        Text001: label 'Pick activity no. %1 has been created.';
        Text002: label 'Pick activities no. %1 to %2 have been created.';
        Location: Record Location;
        PickWkshLine: Record "Whse. Worksheet Line";
        PickWkshLineFilter: Record "Whse. Worksheet Line";
        Cust: Record Customer;
        CreatePick: Codeunit "Create Pick";
        LocationCode: Code[10];
        AssignedID: Code[50];
        FirstPickNo: Code[20];
        FirstSetPickNo: Code[20];
        LastPickNo: Code[20];
        MaxNoOfLines: Integer;
        MaxNoOfSourceDoc: Integer;
        TempNo: Integer;
        SortPick: Option " ",Item,Document,"Shelf No.","Due Date",Destination,"Bin Ranking","Action Type";
        PerDestination: Boolean;
        PerItem: Boolean;
        PerZone: Boolean;
        PerBin: Boolean;
        PerWhseDoc: Boolean;
        PerDate: Boolean;
        PrintPick: Boolean;
        DoNotFillQtytoHandle: Boolean;
        Text003: label 'You can create a Pick only for the available quantity in %1 %2 = %3,%4 = %5,%6 = %7,%8 = %9.';
        BreakbulkFilter: Boolean;
        NothingToHandleErr: label 'There is nothing to handle. %1.';

    local procedure CreateTempLine()
    var
        PickWhseActivHeader: Record "Warehouse Activity Header";
        TempWhseItemTrkgLine: Record "Whse. Item Tracking Line" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        PickQty: Decimal;
        PickQtyBase: Decimal;
        TempMaxNoOfSourceDoc: Integer;
        OldFirstSetPickNo: Code[20];
        TotalQtyPickedBase: Decimal;
    begin
        PickWkshLine.LockTable;
        repeat
          if Location."Bin Mandatory" and
             (not Location."Always Create Pick Line")
          then
            if PickWkshLine.CalcAvailableQtyBase(true) < 0 then
              Error(
                Text003,
                PickWkshLine.TableCaption,PickWkshLine.FieldCaption("Worksheet Template Name"),
                PickWkshLine."Worksheet Template Name",PickWkshLine.FieldCaption(Name),
                PickWkshLine.Name,PickWkshLine.FieldCaption("Location Code"),
                PickWkshLine."Location Code",PickWkshLine.FieldCaption("Line No."),
                PickWkshLine."Line No.");

          PickWkshLine.TestField("Qty. per Unit of Measure");
          CreatePick.SetWhseWkshLine(PickWkshLine,TempNo);
          case PickWkshLine."Whse. Document Type" of
            PickWkshLine."whse. document type"::Shipment:
              CreatePick.SetTempWhseItemTrkgLine(
                PickWkshLine."Whse. Document No.",Database::"Warehouse Shipment Line",'',0,
                PickWkshLine."Whse. Document Line No.",PickWkshLine."Location Code");
            PickWkshLine."whse. document type"::Assembly:
              CreatePick.SetTempWhseItemTrkgLine(
                PickWkshLine."Whse. Document No.",Database::"Assembly Line",'',0,
                PickWkshLine."Whse. Document Line No.",PickWkshLine."Location Code");
            PickWkshLine."whse. document type"::"Internal Pick":
              CreatePick.SetTempWhseItemTrkgLine(
                PickWkshLine."Whse. Document No.",Database::"Whse. Internal Pick Line",'',0,
                PickWkshLine."Whse. Document Line No.",PickWkshLine."Location Code");
            PickWkshLine."whse. document type"::Production:
              CreatePick.SetTempWhseItemTrkgLine(
                PickWkshLine."Source No.",PickWkshLine."Source Type",'',PickWkshLine."Source Line No.",
                PickWkshLine."Source Subline No.",PickWkshLine."Location Code");
            else // Movement Worksheet Line
              CreatePick.SetTempWhseItemTrkgLine(
                PickWkshLine.Name,Database::"Prod. Order Component",PickWkshLine."Worksheet Template Name",
                0,PickWkshLine."Line No.",PickWkshLine."Location Code");
          end;

          PickQty := PickWkshLine."Qty. to Handle";
          PickQtyBase := PickWkshLine."Qty. to Handle (Base)";
          if (PickQty > 0) and
             (PickWkshLine."Destination Type" = PickWkshLine."destination type"::Customer)
          then begin
            PickWkshLine.TestField("Destination No.");
            Cust.Get(PickWkshLine."Destination No.");
            Cust.CheckBlockedCustOnDocs(Cust,PickWkshLine."Source Document",false,false);
          end;

          CreatePick.SetCalledFromWksh(true);

          with PickWkshLine do
            CreatePick.CreateTempLine("Location Code","Item No.","Variant Code",
              "Unit of Measure Code",'',"To Bin Code","Qty. per Unit of Measure",PickQty,PickQtyBase);

          TotalQtyPickedBase := CreatePick.GetActualQtyPickedBase;

          // Update/delete lines
          PickWkshLine."Qty. to Handle (Base)" := PickWkshLine.CalcBaseQty(PickWkshLine."Qty. to Handle");
          if PickWkshLine."Qty. (Base)" =
             PickWkshLine."Qty. Handled (Base)" + TotalQtyPickedBase
          then
            PickWkshLine.Delete(true)
          else begin
            PickWkshLine."Qty. Handled" := PickWkshLine."Qty. Handled" + PickWkshLine.CalcQty(TotalQtyPickedBase);
            PickWkshLine."Qty. Handled (Base)" := PickWkshLine.CalcBaseQty(PickWkshLine."Qty. Handled");
            PickWkshLine."Qty. Outstanding" := PickWkshLine.Quantity - PickWkshLine."Qty. Handled";
            PickWkshLine."Qty. Outstanding (Base)" := PickWkshLine.CalcBaseQty(PickWkshLine."Qty. Outstanding");
            PickWkshLine."Qty. to Handle" := 0;
            PickWkshLine."Qty. to Handle (Base)" := 0;
            PickWkshLine.Modify;
          end;
        until PickWkshLine.Next = 0;

        OldFirstSetPickNo := FirstSetPickNo;
        CreatePick.CreateWhseDocument(FirstSetPickNo,LastPickNo,false);
        if FirstSetPickNo = OldFirstSetPickNo then
          exit;

        if FirstPickNo = '' then
          FirstPickNo := FirstSetPickNo;
        CreatePick.ReturnTempItemTrkgLines(TempWhseItemTrkgLine);
        ItemTrackingMgt.UpdateWhseItemTrkgLines(TempWhseItemTrkgLine);
        Commit;

        TempMaxNoOfSourceDoc := MaxNoOfSourceDoc;
        PickWhseActivHeader.SetRange(Type,PickWhseActivHeader.Type::Pick);
        PickWhseActivHeader.SetRange("No.",FirstSetPickNo,LastPickNo);
        PickWhseActivHeader.Find('-');
        repeat
          if SortPick > 0 then
            PickWhseActivHeader.SortWhseDoc;
          Commit;
          if PrintPick then begin
            Report.Run(Report::"Picking List",false,false,PickWhseActivHeader);
            TempMaxNoOfSourceDoc -= 1;
          end;
        until ((PickWhseActivHeader.Next = 0) or (TempMaxNoOfSourceDoc = 0));
    end;


    procedure SetWkshPickLine(var PickWkshLine2: Record "Whse. Worksheet Line")
    begin
        PickWkshLine.CopyFilters(PickWkshLine2);
        LocationCode := PickWkshLine2."Location Code";
    end;


    procedure GetResultMessage(): Boolean
    begin
        if FirstPickNo <> '' then
          if FirstPickNo = LastPickNo then
            Message(Text001,FirstPickNo)
          else
            Message(Text002,FirstPickNo,LastPickNo);
        exit(FirstPickNo <> '');
    end;


    procedure InitializeReport(AssignedID2: Code[50];MaxNoOfLines2: Integer;MaxNoOfSourceDoc2: Integer;SortPick2: Option " ",Item,Document,"Shelf/Bin No.","Due Date","Ship-To","Bin Ranking","Action Type";PerDestination2: Boolean;PerItem2: Boolean;PerZone2: Boolean;PerBin2: Boolean;PerWhseDoc2: Boolean;PerDate2: Boolean;PrintPick2: Boolean;DoNotFillQtytoHandle2: Boolean;BreakbulkFilter2: Boolean)
    begin
        AssignedID := AssignedID2;
        MaxNoOfLines := MaxNoOfLines2;
        MaxNoOfSourceDoc := MaxNoOfSourceDoc2;
        SortPick := SortPick2;
        PerDestination := PerDestination2;
        PerItem := PerItem2;
        PerZone := PerZone2;
        PerBin := PerBin2;
        PerWhseDoc := PerWhseDoc2;
        PerDate := PerDate2;
        PrintPick := PrintPick2;
        DoNotFillQtytoHandle := DoNotFillQtytoHandle2;
        BreakbulkFilter := BreakbulkFilter2;
    end;

    local procedure CheckPickActivity()
    begin
        if FirstPickNo = '' then
          Error(NothingToHandleErr,CreatePick.GetExpiredItemMessage);
    end;

    local procedure SetPickFilters()
    begin
        if PerItem then begin
          PickWkshLine.SetRange("Item No.",PickWkshLine."Item No.");
          if PerBin then
            SetPerBinFilters
          else begin
            if not Location."Bin Mandatory" then
              PickWkshLineFilter.Copyfilter("Shelf No.",PickWkshLine."Shelf No.");
            SetPerDateFilters;
          end;
          PickWkshLineFilter.Copyfilter("Item No.",PickWkshLine."Item No.");
        end else begin
          PickWkshLineFilter.Copyfilter("Item No.",PickWkshLine."Item No.");
          if PerBin then
            SetPerBinFilters
          else begin
            if not Location."Bin Mandatory" then
              PickWkshLineFilter.Copyfilter("Shelf No.",PickWkshLine."Shelf No.");
            SetPerDateFilters;
          end;
        end;
    end;

    local procedure SetPerBinFilters()
    begin
        if not Location."Bin Mandatory" then
          PickWkshLine.SetRange("Shelf No.",PickWkshLine."Shelf No.");
        if PerDate then begin
          PickWkshLine.SetRange("Due Date",PickWkshLine."Due Date");
          CreateTempLine;
          PickWkshLineFilter.Copyfilter("Due Date",PickWkshLine."Due Date");
        end else begin
          PickWkshLineFilter.Copyfilter("Due Date",PickWkshLine."Due Date");
          CreateTempLine;
        end;
        if not Location."Bin Mandatory" then
          PickWkshLineFilter.Copyfilter("Shelf No.",PickWkshLine."Shelf No.");
    end;

    local procedure SetPerDateFilters()
    begin
        if PerDate then begin
          PickWkshLine.SetRange("Due Date",PickWkshLine."Due Date");
          CreateTempLine;
          PickWkshLineFilter.Copyfilter("Due Date",PickWkshLine."Due Date");
        end else begin
          PickWkshLineFilter.Copyfilter("Due Date",PickWkshLine."Due Date");
          CreateTempLine;
        end;
    end;
}

