#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7391 "Whse. Get Bin Content"
{
    Caption = 'Whse. Get Bin Content';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Bin Content";"Bin Content")
        {
            RequestFilterFields = "Location Code","Zone Code","Bin Code","Item No.","Variant Code","Unit of Measure Code";
            column(ReportForNavId_4810; 4810)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if BinType.Code <> "Bin Type Code" then
                  BinType.Get("Bin Type Code");
                if BinType.Receive and not "Cross-Dock Bin" then
                  CurrReport.Skip;

                QtyToEmptyBase := GetQtyToEmptyBase('','');
                if QtyToEmptyBase <= 0 then
                  CurrReport.Skip;

                case DestinationType2 of
                  Destinationtype2::MovementWorksheet:
                    InsertWWL;
                  Destinationtype2::WhseInternalPutawayHeader:
                    InsertWIPL;
                  Destinationtype2::ItemJournalLine:
                    InsertItemJournalLine;
                  Destinationtype2::TransferHeader:
                    begin
                      TransferHeader.TestField("Transfer-from Code","Location Code");
                      InsertTransferLine;
                    end;
                  Destinationtype2::InternalMovementHeader:
                    InsertIntMovementLine;
                end;

                GetSerialNoAndLotNo;
            end;

            trigger OnPreDataItem()
            begin
                if not ReportInitialized then
                  Error(Text001);

                Location.Init;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PostingDate;PostingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Posting Date';
                        Editable = PostingDateEditable;
                    }
                    field(DocNo;DocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';
                        Editable = DocNoEditable;
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            DocNoEditable := true;
            PostingDateEditable := true;
        end;

        trigger OnOpenPage()
        begin
            case DestinationType2 of
              Destinationtype2::ItemJournalLine:
                begin
                  PostingDateEditable := true;
                  DocNoEditable := true;
                end;
              else begin
                PostingDateEditable := false;
                DocNoEditable := false;
              end;
            end;
        end;
    }

    labels
    {
    }

    var
        WWLine: Record "Whse. Worksheet Line";
        WIPLine: Record "Whse. Internal Put-away Line";
        ItemJournalLine: Record "Item Journal Line";
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        BinType: Record "Bin Type";
        Location: Record Location;
        InternalMovementHeader: Record "Internal Movement Header";
        InternalMovementLine: Record "Internal Movement Line";
        QtyToEmptyBase: Decimal;
        ReportInitialized: Boolean;
        Text001: label 'Report must be initialized.';
        DestinationType2: Option MovementWorksheet,WhseInternalPutawayHeader,ItemJournalLine,TransferHeader,InternalMovementHeader;
        PostingDate: Date;
        DocNo: Code[20];
        [InDataSet]
        PostingDateEditable: Boolean;
        [InDataSet]
        DocNoEditable: Boolean;


    procedure InitializeReport(WWL: Record "Whse. Worksheet Line";WIPH: Record "Whse. Internal Put-away Header";DestinationType: Option)
    begin
        DestinationType2 := DestinationType;
        case DestinationType2 of
          Destinationtype2::MovementWorksheet:
            begin
              WWLine := WWL;
              WWLine.SetCurrentkey("Worksheet Template Name",Name,"Location Code","Line No.");
              WWLine.SetRange("Worksheet Template Name",WWLine."Worksheet Template Name");
              WWLine.SetRange(Name,WWLine.Name);
              WWLine.SetRange("Location Code",WWLine."Location Code");
              if WWLine.FindLast then;
            end;
          Destinationtype2::WhseInternalPutawayHeader:
            begin
              WIPLine."No." := WIPH."No.";
              WIPLine.SetRange("No.",WIPLine."No.");
              if WIPLine.FindLast then;
            end;
        end;
        ReportInitialized := true;
    end;


    procedure InitializeItemJournalLine(ItemJournalLine2: Record "Item Journal Line")
    begin
        ItemJournalLine := ItemJournalLine2;
        ItemJournalLine.SetRange("Journal Template Name",ItemJournalLine2."Journal Template Name");
        ItemJournalLine.SetRange("Journal Batch Name",ItemJournalLine2."Journal Batch Name");
        if ItemJournalLine.FindLast then;

        PostingDate := ItemJournalLine2."Posting Date";
        DocNo := ItemJournalLine2."Document No.";

        DestinationType2 := Destinationtype2::ItemJournalLine;
        ReportInitialized := true;
    end;


    procedure InitializeTransferHeader(TransferHeader2: Record "Transfer Header")
    begin
        TransferLine.Reset;
        TransferLine.SetRange("Document No.",TransferHeader2."No.");
        if not TransferLine.FindLast then begin
          TransferLine.Init;
          TransferLine."Document No." := TransferHeader2."No.";
        end;

        TransferHeader := TransferHeader2;

        DestinationType2 := Destinationtype2::TransferHeader;
        ReportInitialized := true;
    end;


    procedure InitializeInternalMovement(InternalMovementHeader2: Record "Internal Movement Header")
    begin
        InternalMovementLine.Reset;
        InternalMovementLine.SetRange("No.",InternalMovementHeader2."No.");
        if not InternalMovementLine.FindLast then begin
          InternalMovementLine.Init;
          InternalMovementLine."No." := InternalMovementHeader2."No.";
        end;
        InternalMovementHeader := InternalMovementHeader2;

        DestinationType2 := Destinationtype2::InternalMovementHeader;
        ReportInitialized := true;
    end;


    procedure InsertWWL()
    begin
        with WWLine do begin
          Init;
          "Line No." := "Line No." + 10000;
          Validate("Location Code","Bin Content"."Location Code");
          Validate("Item No.","Bin Content"."Item No.");
          Validate("Variant Code","Bin Content"."Variant Code");
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate("From Bin Code","Bin Content"."Bin Code");
          "From Zone Code" := "Bin Content"."Zone Code";
          Validate("From Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate(Quantity,CalcQtyUOM(QtyToEmptyBase,"Qty. per From Unit of Measure"));
          if QtyToEmptyBase <> (Quantity * "Qty. per From Unit of Measure") then begin
            "Qty. (Base)" := QtyToEmptyBase;
            "Qty. Outstanding (Base)" := QtyToEmptyBase;
            "Qty. to Handle (Base)" := QtyToEmptyBase;
          end;
          "Whse. Document Type" := "whse. document type"::"Whse. Mov.-Worksheet";
          "Whse. Document No." := Name;
          "Whse. Document Line No." := "Line No.";
          Insert;
        end;
    end;


    procedure InsertWIPL()
    begin
        with WIPLine do begin
          Init;
          "Line No." := "Line No." + 10000;
          Validate("Location Code","Bin Content"."Location Code");
          Validate("Item No.","Bin Content"."Item No.");
          Validate("Variant Code","Bin Content"."Variant Code");
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate("From Bin Code","Bin Content"."Bin Code");
          "From Zone Code" := "Bin Content"."Zone Code";
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate(Quantity,CalcQtyUOM(QtyToEmptyBase,"Qty. per Unit of Measure"));
          if QtyToEmptyBase <> (Quantity * "Qty. per Unit of Measure") then begin
            "Qty. (Base)" := QtyToEmptyBase;
            "Qty. Outstanding (Base)" := QtyToEmptyBase;
          end;
          Insert;
        end;
    end;


    procedure InsertItemJournalLine()
    var
        ItemJournalTempl: Record "Item Journal Template";
    begin
        with ItemJournalLine do begin
          Init;
          "Line No." := "Line No." + 10000;
          Validate("Entry Type","entry type"::Transfer);
          Validate("Item No.","Bin Content"."Item No.");
          Validate("Posting Date",PostingDate);
          Validate("Document No.",DocNo);
          Validate("Location Code","Bin Content"."Location Code");
          Validate("New Location Code","Bin Content"."Location Code");
          Validate("Variant Code","Bin Content"."Variant Code");
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate("Bin Code","Bin Content"."Bin Code");
          Validate("New Bin Code",'');
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate(Quantity,CalcQtyUOM(QtyToEmptyBase,"Qty. per Unit of Measure"));
          ItemJournalTempl.Get("Journal Template Name");
          "Source Code" := ItemJournalTempl."Source Code";
          Insert;
        end;
    end;


    procedure InsertTransferLine()
    begin
        with TransferLine do begin
          Init;
          "Line No." := "Line No." + 10000;
          Validate("Item No.","Bin Content"."Item No.");
          Validate("Variant Code","Bin Content"."Variant Code");
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate("Transfer-from Bin Code","Bin Content"."Bin Code");
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate(Quantity,CalcQtyUOM(QtyToEmptyBase,"Qty. per Unit of Measure"));
          Insert;
        end;
    end;


    procedure InsertIntMovementLine()
    begin
        with InternalMovementLine do begin
          Init;
          "Line No." := "Line No." + 10000;
          Validate("Location Code","Bin Content"."Location Code");
          Validate("Item No.","Bin Content"."Item No.");
          Validate("Variant Code","Bin Content"."Variant Code");
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate("From Bin Code","Bin Content"."Bin Code");
          Validate("To Bin Code",InternalMovementHeader."To Bin Code");
          Validate("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          Validate(Quantity,CalcQtyUOM(QtyToEmptyBase,"Qty. per Unit of Measure"));
          Insert;
        end;
    end;


    procedure GetSerialNoAndLotNo()
    var
        WarehouseEntry: Record "Warehouse Entry";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ReserveItemJnlLine: Codeunit "Item Jnl. Line-Reserve";
        ReserveTransferLine: Codeunit "Transfer Line-Reserve";
        Direction: Option Outbound,Inbound;
        SNRequired: Boolean;
        LNRequired: Boolean;
    begin
        Clear(ItemTrackingMgt);
        ItemTrackingMgt.CheckWhseItemTrkgSetup("Bin Content"."Item No.",SNRequired,LNRequired,false);
        if not (SNRequired or LNRequired) then
          exit;

        with WarehouseEntry do begin
          Reset;
          SetCurrentkey(
            "Item No.","Bin Code","Location Code","Variant Code","Unit of Measure Code","Lot No.","Serial No.");
          SetRange("Item No.","Bin Content"."Item No.");
          SetRange("Bin Code","Bin Content"."Bin Code");
          SetRange("Location Code","Bin Content"."Location Code");
          SetRange("Variant Code","Bin Content"."Variant Code");
          SetRange("Unit of Measure Code","Bin Content"."Unit of Measure Code");
          if FindSet then
            repeat
              if TrackingExists then begin
                if "Lot No." <> '' then
                  SetRange("Lot No.","Lot No.");
                if "Serial No." <> '' then
                  SetRange("Serial No.","Serial No.");

                QtyToEmptyBase := GetQtyToEmptyBase("Lot No.","Serial No.");

                if QtyToEmptyBase > 0 then begin
                  GetLocation("Location Code",Location);
                  ItemTrackingMgt.GetWhseExpirationDate("Item No.","Variant Code",Location,"Lot No.","Serial No.","Expiration Date");

                  case DestinationType2 of
                    Destinationtype2::MovementWorksheet:
                      WWLine.SetItemTrackingLines("Serial No.","Lot No.","Expiration Date",QtyToEmptyBase);
                    Destinationtype2::WhseInternalPutawayHeader:
                      WIPLine.SetItemTrackingLines("Serial No.","Lot No.","Expiration Date",QtyToEmptyBase);
                    Destinationtype2::ItemJournalLine:
                      TempTrackingSpecification.InitFromItemJnlLine(ItemJournalLine);
                    Destinationtype2::TransferHeader:
                      TempTrackingSpecification.InitFromTransLine(
                        TransferLine,TransferLine."Shipment Date",Direction::Outbound);
                    Destinationtype2::InternalMovementHeader:
                      InternalMovementLine.SetItemTrackingLines("Serial No.","Lot No.","Expiration Date",QtyToEmptyBase);
                  end;
                end;
                Find('+');
                SetRange("Lot No.");
                SetRange("Serial No.");
              end;
              if DestinationType2 in [Destinationtype2::ItemJournalLine,Destinationtype2::TransferHeader] then
                InsertTempTrackingSpec(WarehouseEntry,QtyToEmptyBase,TempTrackingSpecification);
            until Next = 0;
          case DestinationType2 of
            Destinationtype2::ItemJournalLine:
              ReserveItemJnlLine.RegisterBinContentItemTracking(ItemJournalLine,TempTrackingSpecification);
            Destinationtype2::TransferHeader:
              ReserveTransferLine.RegisterBinContentItemTracking(TransferLine,TempTrackingSpecification);
          end;
        end;
    end;

    local procedure GetLocation(LocationCode: Code[10];var Location: Record Location)
    begin
        if LocationCode = Location.Code then
          exit;

        if LocationCode = '' then
          Location.Init
        else
          Location.Get(LocationCode);
    end;


    procedure InsertTempTrackingSpec(WarehouseEntry: Record "Warehouse Entry";QtyOnBin: Decimal;var TempTrackingSpecification: Record "Tracking Specification" temporary)
    begin
        with WarehouseEntry do begin
          TempTrackingSpecification.SetSkipSerialNoQtyValidation(true);
          TempTrackingSpecification.Validate("Serial No.","Serial No.");
          TempTrackingSpecification.SetSkipSerialNoQtyValidation(false);
          TempTrackingSpecification."New Serial No." := "Serial No.";
          TempTrackingSpecification.Validate("Lot No.","Lot No.");
          TempTrackingSpecification."New Lot No." := "Lot No.";
          TempTrackingSpecification."Quantity Handled (Base)" := 0;
          TempTrackingSpecification."Expiration Date" := "Expiration Date";
          TempTrackingSpecification."New Expiration Date" := "Expiration Date";
          TempTrackingSpecification.Validate("Quantity (Base)",QtyOnBin);
          TempTrackingSpecification."Entry No." += 1;
          TempTrackingSpecification.Insert;
        end;
    end;

    local procedure CalcQtyUOM(QtyBase: Decimal;QtyPerUOM: Decimal): Decimal
    begin
        if QtyPerUOM = 0 then
          exit(0);

        exit(ROUND(QtyBase / QtyPerUOM,0.00001));
    end;

    local procedure GetQtyToEmptyBase(LotNo: Code[20];SerialNo: Code[20]): Decimal
    var
        BinContent: Record "Bin Content";
    begin
        with BinContent do begin
          Init;
          Copy("Bin Content");
          FilterGroup(8);
          if LotNo <> '' then
            SetRange("Lot No. Filter",LotNo);
          if SerialNo <> '' then
            SetRange("Serial No. Filter",SerialNo);
          if DestinationType2 = Destinationtype2::TransferHeader then
            exit(CalcQtyAvailToPick(0));
          exit(CalcQtyAvailToTake(0));
        end;
    end;
}

