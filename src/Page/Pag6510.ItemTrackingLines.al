#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6510 "Item Tracking Lines"
{
    Caption = 'Item Tracking Lines';
    DataCaptionFields = "Item No.","Variant Code",Description;
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Tracking Specification";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            group(Control59)
            {
                fixed(Control1903651101)
                {
                    group(Source)
                    {
                        Caption = 'Source';
                        field(CurrentSourceCaption;CurrentSourceCaption)
                        {
                            ApplicationArea = Basic;
                            Editable = false;
                            ShowCaption = false;
                        }
                        field("SourceQuantityArray[1]";SourceQuantityArray[1])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(Handle1;SourceQuantityArray[2])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. to Handle';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            Visible = Handle1Visible;
                        }
                        field(Invoice1;SourceQuantityArray[3])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. to Invoice';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            Visible = Invoice1Visible;
                        }
                    }
                    group("Item Tracking")
                    {
                        Caption = 'Item Tracking';
                        field(Text020;Text020)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Quantity_ItemTracking;TotalItemTrackingLine."Quantity (Base)")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Quantity';
                            DecimalPlaces = 0:5;
                            Editable = false;
                        }
                        field(Handle2;TotalItemTrackingLine."Qty. to Handle (Base)")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. to Handle';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            Visible = Handle2Visible;
                        }
                        field(Invoice2;TotalItemTrackingLine."Qty. to Invoice (Base)")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Qty. to Invoice';
                            DecimalPlaces = 0:5;
                            Editable = false;
                            Visible = Invoice2Visible;
                        }
                    }
                    group(Undefined)
                    {
                        Caption = 'Undefined';
                        field(Control88;Text020)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                        field(Quantity3;UndefinedQtyArray[1])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'Undefined Quantity';
                            DecimalPlaces = 2:5;
                            Editable = false;
                        }
                        field(Handle3;UndefinedQtyArray[2])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'Undefined Quantity to Handle';
                            DecimalPlaces = 2:5;
                            Editable = false;
                            Visible = Handle3Visible;
                        }
                        field(Invoice3;UndefinedQtyArray[3])
                        {
                            ApplicationArea = Basic;
                            BlankZero = true;
                            Caption = 'Undefined Quantity to Invoice';
                            DecimalPlaces = 2:5;
                            Editable = false;
                            Visible = Invoice3Visible;
                        }
                    }
                }
            }
            group(Control82)
            {
                field("ItemTrackingCode.Code";ItemTrackingCode.Code)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item Tracking Code';
                    Editable = false;
                    Lookup = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Page.RunModal(0,ItemTrackingCode);
                    end;
                }
                field("ItemTrackingCode.Description";ItemTrackingCode.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                    Editable = false;
                }
            }
            repeater(Control1)
            {
                field(AvailabilitySerialNo;LotSnAvailable(Rec,0))
                {
                    ApplicationArea = Basic;
                    Caption = 'Availability, Serial No.';
                    Editable = false;
                    OptionCaption = 'Bitmap45';
                    ToolTip = 'Specifies a warning icon if the sum of the quantities of the item in outbound documents is greater than the serial number quantity in inventory.';

                    trigger OnDrillDown()
                    begin
                        LookupAvailable(0);
                    end;
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = SerialNoEditable;
                    ToolTip = 'Specifies the serial number associated with the entry.';

                    trigger OnAssistEdit()
                    var
                        MaxQuantity: Decimal;
                    begin
                        MaxQuantity := UndefinedQtyArray[1];

                        "Bin Code" := ForBinCode;
                        ItemTrackingDataCollection.AssistEditLotSerialNo(Rec,
                          (CurrentSignFactor * SourceQuantityArray[1] < 0) and not
                          InsertIsBlocked,CurrentSignFactor,0,MaxQuantity);
                        "Bin Code" := '';
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        SerialNoOnAfterValidate;
                    end;
                }
                field("New Serial No.";"New Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = NewSerialNoEditable;
                    ToolTip = 'Specifies a new serial number that will take the place of the serial number in the Serial No. field.';
                    Visible = NewSerialNoVisible;
                }
                field(AvailabilityLotNo;LotSnAvailable(Rec,1))
                {
                    ApplicationArea = Basic;
                    Caption = 'Availability, Lot No.';
                    Editable = false;
                    OptionCaption = 'Bitmap45';
                    ToolTip = 'Specifies a warning icon if the sum of the quantities of the item in outbound documents is greater than the lot number quantity in inventory.';

                    trigger OnDrillDown()
                    begin
                        LookupAvailable(1);
                    end;
                }
                field("Lot No.";"Lot No.")
                {
                    ApplicationArea = Basic;
                    Editable = LotNoEditable;
                    ToolTip = 'Specifies the lot number of the item being handled for the associated document line.';

                    trigger OnAssistEdit()
                    var
                        MaxQuantity: Decimal;
                    begin
                        MaxQuantity := UndefinedQtyArray[1];

                        "Bin Code" := ForBinCode;
                        ItemTrackingDataCollection.AssistEditLotSerialNo(Rec,
                          (CurrentSignFactor * SourceQuantityArray[1] < 0) and not
                          InsertIsBlocked,CurrentSignFactor,1,MaxQuantity);
                        "Bin Code" := '';
                        CurrPage.Update;
                    end;

                    trigger OnValidate()
                    begin
                        LotNoOnAfterValidate;
                    end;
                }
                field("New Lot No.";"New Lot No.")
                {
                    ApplicationArea = Basic;
                    Editable = NewLotNoEditable;
                    ToolTip = 'Specifies a new lot number that will take the place of the lot number in the Lot No. field.';
                    Visible = NewLotNoVisible;
                }
                field("Expiration Date";"Expiration Date")
                {
                    ApplicationArea = Basic;
                    Editable = ExpirationDateEditable;
                    ToolTip = 'Specifies the expiration date, if any, of the item carrying the item tracking number.';
                    Visible = false;
                }
                field("New Expiration Date";"New Expiration Date")
                {
                    ApplicationArea = Basic;
                    Editable = NewExpirationDateEditable;
                    ToolTip = 'Specifies a new expiration date.';
                    Visible = NewExpirationDateVisible;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic;
                    Editable = WarrantyDateEditable;
                    ToolTip = 'Specifies that a warranty date must be entered manually.';
                    Visible = false;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = ItemNoEditable;
                    ToolTip = 'Specifies the number of the item associated with the entry.';
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Editable = VariantCodeEditable;
                    ToolTip = 'Specifies a code to identify the variant.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = DescriptionEditable;
                    ToolTip = 'Specifies the description of the entry.';
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = LocationCodeEditable;
                    ToolTip = 'Specifies the location code for the entry.';
                    Visible = false;
                }
                field("Quantity (Base)";"Quantity (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = QuantityBaseEditable;
                    ToolTip = 'Specifies the quantity on the line expressed in base units of measure.';

                    trigger OnValidate()
                    begin
                        QuantityBaseOnValidate;
                        QuantityBaseOnAfterValidate;
                    end;
                }
                field("Qty. to Handle (Base)";"Qty. to Handle (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = QtyToHandleBaseEditable;
                    ToolTip = 'Specifies the quantity that you want to handle in the base unit of measure.';
                    Visible = QtyToHandleBaseVisible;

                    trigger OnValidate()
                    begin
                        QtytoHandleBaseOnAfterValidate;
                    end;
                }
                field("Qty. to Invoice (Base)";"Qty. to Invoice (Base)")
                {
                    ApplicationArea = Basic;
                    Editable = QtyToInvoiceBaseEditable;
                    ToolTip = 'Specifies how many of the items, in base units of measure, are scheduled for invoicing.';
                    Visible = QtyToInvoiceBaseVisible;

                    trigger OnValidate()
                    begin
                        QtytoInvoiceBaseOnAfterValidat;
                    end;
                }
                field("Quantity Handled (Base)";"Quantity Handled (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of serial/lot numbers shipped or received for the associated document line, expressed in base units of measure.';
                    Visible = false;
                }
                field("Quantity Invoiced (Base)";"Quantity Invoiced (Base)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the quantity of serial/lot numbers that is invoiced with the associated document line, expressed in base units of measure.';
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of a particular item entry that the line should be applied to.';
                    Visible = ApplToItemEntryVisible;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item ledger entry that the program will use to retrieve the cost for this line of an inbound transaction.';
                    Visible = ApplFromItemEntryVisible;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ButtonLineReclass)
            {
                Caption = '&Line';
                Image = Line;
                Visible = ButtonLineReclassVisible;
                action(Reclass_SerialNoInfoCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No. Information Card';
                    Image = SNInfo;
                    RunObject = Page "Serial No. Information List";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Serial No."=field("Serial No.");

                    trigger OnAction()
                    begin
                        TestField("Serial No.");
                    end;
                }
                action(Reclass_LotNoInfoCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lot No. Information Card';
                    Image = LotInfo;
                    RunObject = Page "Lot No. Information List";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Lot No."=field("Lot No.");

                    trigger OnAction()
                    begin
                        TestField("Lot No.");
                    end;
                }
                separator(Action69)
                {
                }
                action(NewSerialNoInformation)
                {
                    ApplicationArea = Basic;
                    Caption = 'New S&erial No. Information';
                    Image = NewSerialNoProperties;

                    trigger OnAction()
                    var
                        SerialNoInfoNew: Record "Serial No. Information";
                        SerialNoInfoForm: Page "Serial No. Information Card";
                    begin
                        TestField("New Serial No.");

                        Clear(SerialNoInfoForm);
                        SerialNoInfoForm.Init(Rec);

                        SerialNoInfoNew.SetRange("Item No.","Item No.");
                        SerialNoInfoNew.SetRange("Variant Code","Variant Code");
                        SerialNoInfoNew.SetRange("Serial No.","New Serial No.");

                        SerialNoInfoForm.SetTableview(SerialNoInfoNew);
                        SerialNoInfoForm.Run;
                    end;
                }
                action(NewLotNoInformation)
                {
                    ApplicationArea = Basic;
                    Caption = 'New L&ot No. Information';
                    Image = NewLotProperties;
                    RunPageOnRec = false;

                    trigger OnAction()
                    var
                        LotNoInfoNew: Record "Lot No. Information";
                        LotNoInfoForm: Page "Lot No. Information Card";
                    begin
                        TestField("New Lot No.");

                        Clear(LotNoInfoForm);
                        LotNoInfoForm.Init(Rec);

                        LotNoInfoNew.SetRange("Item No.","Item No.");
                        LotNoInfoNew.SetRange("Variant Code","Variant Code");
                        LotNoInfoNew.SetRange("Lot No.","New Lot No.");

                        LotNoInfoForm.SetTableview(LotNoInfoNew);
                        LotNoInfoForm.Run;
                    end;
                }
            }
            group(ButtonLine)
            {
                Caption = '&Line';
                Image = Line;
                Visible = ButtonLineVisible;
                action(Line_SerialNoInfoCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No. Information Card';
                    Image = SNInfo;
                    RunObject = Page "Serial No. Information List";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Serial No."=field("Serial No.");

                    trigger OnAction()
                    begin
                        TestField("Serial No.");
                    end;
                }
                action(Line_LotNoInfoCard)
                {
                    ApplicationArea = Basic;
                    Caption = 'Lot No. Information Card';
                    Image = LotInfo;
                    RunObject = Page "Lot No. Information List";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field("Variant Code"),
                                  "Lot No."=field("Lot No.");

                    trigger OnAction()
                    begin
                        TestField("Lot No.");
                    end;
                }
            }
        }
        area(processing)
        {
            group(FunctionsSupply)
            {
                Caption = 'F&unctions';
                Image = "Action";
                Visible = FunctionsSupplyVisible;
                action("Assign Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign &Serial No.';
                    Image = SerialNo;

                    trigger OnAction()
                    begin
                        if InsertIsBlocked then
                          exit;
                        AssignSerialNo;
                    end;
                }
                action("Assign Lot No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign &Lot No.';
                    Image = Lot;

                    trigger OnAction()
                    begin
                        if InsertIsBlocked then
                          exit;
                        AssignLotNo;
                    end;
                }
                action("Create Customized SN")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Customized SN';
                    Image = CreateSerialNo;

                    trigger OnAction()
                    begin
                        if InsertIsBlocked then
                          exit;
                        CreateCustomizedSN;
                    end;
                }
                action("Refresh Availability")
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh Availability';
                    Image = Refresh;

                    trigger OnAction()
                    begin
                        ItemTrackingDataCollection.RefreshLotSNAvailability(Rec,true);
                    end;
                }
            }
            group(FunctionsDemand)
            {
                Caption = 'F&unctions';
                Image = "Action";
                Visible = FunctionsDemandVisible;
                action("Assign &Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign &Serial No.';
                    Image = SerialNo;

                    trigger OnAction()
                    begin
                        if InsertIsBlocked then
                          exit;
                        AssignSerialNo;
                    end;
                }
                action("Assign &Lot No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign &Lot No.';
                    Image = Lot;

                    trigger OnAction()
                    begin
                        if InsertIsBlocked then
                          exit;
                        AssignLotNo;
                    end;
                }
                action(CreateCustomizedSN)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Customized SN';
                    Image = CreateSerialNo;

                    trigger OnAction()
                    begin
                        if InsertIsBlocked then
                          exit;
                        CreateCustomizedSN;
                    end;
                }
                action("Select Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Select &Entries';
                    Image = SelectEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        if InsertIsBlocked then
                          exit;

                        SelectEntries;
                    end;
                }
                action(Action64)
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh Availability';
                    Image = Refresh;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        ItemTrackingDataCollection.RefreshLotSNAvailability(Rec,true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateExpDateEditable;
    end;

    trigger OnAfterGetRecord()
    begin
        ExpirationDateOnFormat;
    end;

    trigger OnClosePage()
    begin
        if UpdateUndefinedQty then
          WriteToDatabase;
        if FormRunMode = Formrunmode::"Drop Shipment" then
          case CurrentSourceType of
            Database::"Sales Line":
              SynchronizeLinkedSources(StrSubstNo(Text015,Text016));
            Database::"Purchase Line":
              SynchronizeLinkedSources(StrSubstNo(Text015,Text017));
          end;
        if FormRunMode = Formrunmode::Transfer then
          SynchronizeLinkedSources('');
        SynchronizeWarehouseItemTracking;
    end;

    trigger OnDeleteRecord(): Boolean
    var
        TrackingSpec: Record "Tracking Specification";
        WMSManagement: Codeunit "WMS Management";
        AlreadyDeleted: Boolean;
    begin
        TrackingSpec."Item No." := "Item No.";
        TrackingSpec."Location Code" := "Location Code";
        TrackingSpec."Source Type" := "Source Type";
        TrackingSpec."Source Subtype" := "Source Subtype";
        WMSManagement.CheckItemTrackingChange(TrackingSpec,Rec);

        if not DeleteIsBlocked then begin
          AlreadyDeleted := TempItemTrackLineDelete.Get("Entry No.");
          TempItemTrackLineDelete.TransferFields(Rec);
          Delete(true);

          if not AlreadyDeleted then
            TempItemTrackLineDelete.Insert;
          ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
            TempItemTrackLineDelete,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,2);
          if TempItemTrackLineInsert.Get("Entry No.") then
            TempItemTrackLineInsert.Delete;
          if TempItemTrackLineModify.Get("Entry No.") then
            TempItemTrackLineModify.Delete;
        end;
        CalculateSums;

        exit(false);
    end;

    trigger OnInit()
    begin
        WarrantyDateEditable := true;
        ExpirationDateEditable := true;
        NewExpirationDateEditable := true;
        NewLotNoEditable := true;
        NewSerialNoEditable := true;
        DescriptionEditable := true;
        LotNoEditable := true;
        SerialNoEditable := true;
        QuantityBaseEditable := true;
        QtyToInvoiceBaseEditable := true;
        QtyToHandleBaseEditable := true;
        FunctionsDemandVisible := true;
        FunctionsSupplyVisible := true;
        ButtonLineVisible := true;
        QtyToInvoiceBaseVisible := true;
        Invoice3Visible := true;
        Invoice2Visible := true;
        Invoice1Visible := true;
        QtyToHandleBaseVisible := true;
        Handle3Visible := true;
        Handle2Visible := true;
        Handle1Visible := true;
        LocationCodeEditable := true;
        VariantCodeEditable := true;
        ItemNoEditable := true;
        InboundIsSet := false;
        ApplFromItemEntryVisible := false;
        ApplToItemEntryVisible := false;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if "Entry No." <> 0 then
          exit(false);
        "Entry No." := NextEntryNo;
        if (not InsertIsBlocked) and (not ZeroLineExists) then
          if not TestTempSpecificationExists then begin
            TempItemTrackLineInsert.TransferFields(Rec);
            TempItemTrackLineInsert.Insert;
            Insert;
            ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
              TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
          end;
        CalculateSums;

        exit(false);
    end;

    trigger OnModifyRecord(): Boolean
    var
        xTempTrackingSpec: Record "Tracking Specification" temporary;
    begin
        if InsertIsBlocked then
          if (xRec."Lot No." <> "Lot No.") or
             (xRec."Serial No." <> "Serial No.") or
             (xRec."Quantity (Base)" <> "Quantity (Base)")
          then
            exit(false);

        if not TestTempSpecificationExists then begin
          Modify;

          if (xRec."Lot No." <> "Lot No.") or (xRec."Serial No." <> "Serial No.") then begin
            xTempTrackingSpec := xRec;
            ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
              xTempTrackingSpec,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,2);
          end;

          if TempItemTrackLineModify.Get("Entry No.") then
            TempItemTrackLineModify.Delete;
          if TempItemTrackLineInsert.Get("Entry No.") then begin
            TempItemTrackLineInsert.TransferFields(Rec);
            TempItemTrackLineInsert.Modify;
            ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
              TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,1);
          end else begin
            TempItemTrackLineModify.TransferFields(Rec);
            TempItemTrackLineModify.Insert;
            ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
              TempItemTrackLineModify,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,1);
          end;
        end;
        CalculateSums;

        exit(false);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Qty. per Unit of Measure" := QtyPerUOM;
    end;

    trigger OnOpenPage()
    begin
        ItemNoEditable := false;
        VariantCodeEditable := false;
        LocationCodeEditable := false;
        if InboundIsSet then begin
          ApplFromItemEntryVisible := Inbound;
          ApplToItemEntryVisible := not Inbound;
        end;

        UpdateUndefinedQtyArray;

        CurrentFormIsOpen := true;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if not UpdateUndefinedQty then
          exit(Confirm(Text006));

        if not ItemTrackingDataCollection.RefreshLotSNAvailability(Rec,false) then begin
          CurrPage.Update;
          exit(Confirm(Text019,true));
        end;
    end;

    var
        xTempItemTrackingLine: Record "Tracking Specification" temporary;
        TotalItemTrackingLine: Record "Tracking Specification";
        TempItemTrackLineInsert: Record "Tracking Specification" temporary;
        TempItemTrackLineModify: Record "Tracking Specification" temporary;
        TempItemTrackLineDelete: Record "Tracking Specification" temporary;
        TempItemTrackLineReserv: Record "Tracking Specification" temporary;
        Item: Record Item;
        ItemTrackingCode: Record "Item Tracking Code";
        TempReservEntry: Record "Reservation Entry" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ItemTrackingDataCollection: Codeunit "Item Tracking Data Collection";
        UndefinedQtyArray: array [3] of Decimal;
        SourceQuantityArray: array [5] of Decimal;
        QtyPerUOM: Decimal;
        QtyToAddAsBlank: Decimal;
        CurrentSignFactor: Integer;
        Text002: label 'Quantity must be %1.';
        Text003: label 'negative';
        Text004: label 'positive';
        LastEntryNo: Integer;
        CurrentSourceType: Integer;
        SecondSourceID: Integer;
        IsAssembleToOrder: Boolean;
        ExpectedReceiptDate: Date;
        ShipmentDate: Date;
        Text005: label 'Error when writing to database.';
        Text006: label 'The corrections cannot be saved as excess quantity has been defined.\Close the form anyway?';
        Text007: label 'Another user has modified the item tracking data since it was retrieved from the database.\Start again.';
        CurrentEntryStatus: Option Reservation,Tracking,Surplus,Prospect;
        FormRunMode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment",Transfer;
        InsertIsBlocked: Boolean;
        Text008: label 'The quantity to create must be an integer.';
        Text009: label 'The quantity to create must be positive.';
        Text011: label 'Tracking specification with Serial No. %1 and Lot No. %2 already exists.';
        Text012: label 'Tracking specification with Serial No. %1 already exists.';
        DeleteIsBlocked: Boolean;
        Text014: label 'The total item tracking quantity %1 exceeds the %2 quantity %3.\The changes cannot be saved to the database.';
        Text015: label 'Do you want to synchronize item tracking on the line with item tracking on the related drop shipment %1?';
        BlockCommit: Boolean;
        IsCorrection: Boolean;
        CurrentFormIsOpen: Boolean;
        CalledFromSynchWhseItemTrkg: Boolean;
        Inbound: Boolean;
        CurrentSourceCaption: Text[255];
        CurrentSourceRowID: Text[250];
        SecondSourceRowID: Text[250];
        Text016: label 'purchase order line';
        Text017: label 'sales order line';
        Text018: label 'Saving item tracking line changes';
        ForBinCode: Code[20];
        Text019: label 'There are availability warnings on one or more lines.\Close the form anyway?';
        Text020: label 'Placeholder';
        IsPick: Boolean;
        [InDataSet]
        ApplFromItemEntryVisible: Boolean;
        [InDataSet]
        ApplToItemEntryVisible: Boolean;
        [InDataSet]
        ItemNoEditable: Boolean;
        [InDataSet]
        VariantCodeEditable: Boolean;
        [InDataSet]
        LocationCodeEditable: Boolean;
        [InDataSet]
        Handle1Visible: Boolean;
        [InDataSet]
        Handle2Visible: Boolean;
        [InDataSet]
        Handle3Visible: Boolean;
        [InDataSet]
        QtyToHandleBaseVisible: Boolean;
        [InDataSet]
        Invoice1Visible: Boolean;
        [InDataSet]
        Invoice2Visible: Boolean;
        [InDataSet]
        Invoice3Visible: Boolean;
        [InDataSet]
        QtyToInvoiceBaseVisible: Boolean;
        [InDataSet]
        NewSerialNoVisible: Boolean;
        [InDataSet]
        NewLotNoVisible: Boolean;
        [InDataSet]
        NewExpirationDateVisible: Boolean;
        [InDataSet]
        ButtonLineReclassVisible: Boolean;
        [InDataSet]
        ButtonLineVisible: Boolean;
        [InDataSet]
        FunctionsSupplyVisible: Boolean;
        [InDataSet]
        FunctionsDemandVisible: Boolean;
        InboundIsSet: Boolean;
        [InDataSet]
        QtyToHandleBaseEditable: Boolean;
        [InDataSet]
        QtyToInvoiceBaseEditable: Boolean;
        [InDataSet]
        QuantityBaseEditable: Boolean;
        [InDataSet]
        SerialNoEditable: Boolean;
        [InDataSet]
        LotNoEditable: Boolean;
        [InDataSet]
        DescriptionEditable: Boolean;
        [InDataSet]
        NewSerialNoEditable: Boolean;
        [InDataSet]
        NewLotNoEditable: Boolean;
        [InDataSet]
        NewExpirationDateEditable: Boolean;
        [InDataSet]
        ExpirationDateEditable: Boolean;
        [InDataSet]
        WarrantyDateEditable: Boolean;
        ExcludePostedEntries: Boolean;
        ProdOrderLineHandling: Boolean;


    procedure SetFormRunMode(Mode: Option ,Reclass,"Combined Ship/Rcpt","Drop Shipment")
    begin
        FormRunMode := Mode;
    end;


    procedure SetSourceSpec(TrackingSpecification: Record "Tracking Specification";AvailabilityDate: Date)
    var
        ReservEntry: Record "Reservation Entry";
        TempTrackingSpecification: Record "Tracking Specification" temporary;
        TempTrackingSpecification2: Record "Tracking Specification" temporary;
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        Controls: Option Handle,Invoice,Quantity,Reclass,LotSN;
    begin
        GetItem(TrackingSpecification."Item No.");
        ForBinCode := TrackingSpecification."Bin Code";
        SetFilters(TrackingSpecification);
        TempTrackingSpecification.DeleteAll;
        TempItemTrackLineInsert.DeleteAll;
        TempItemTrackLineModify.DeleteAll;
        TempItemTrackLineDelete.DeleteAll;

        TempReservEntry.DeleteAll;
        LastEntryNo := 0;
        if ItemTrackingMgt.IsOrderNetworkEntity(TrackingSpecification."Source Type",
             TrackingSpecification."Source Subtype") and not (FormRunMode = Formrunmode::"Drop Shipment")
        then
          CurrentEntryStatus := Currententrystatus::Surplus
        else
          CurrentEntryStatus := Currententrystatus::Prospect;

        // Set controls for Qty to handle:
        SetControls(Controls::Handle,GetHandleSource(TrackingSpecification));
        // Set controls for Qty to Invoice:
        SetControls(Controls::Invoice,GetInvoiceSource(TrackingSpecification));

        SetControls(Controls::Reclass,FormRunMode = Formrunmode::Reclass);

        if FormRunMode = Formrunmode::"Combined Ship/Rcpt" then
          SetControls(Controls::LotSN,false);
        if ItemTrackingMgt.ItemTrkgIsManagedByWhse(
             TrackingSpecification."Source Type",
             TrackingSpecification."Source Subtype",
             TrackingSpecification."Source ID",
             TrackingSpecification."Source Prod. Order Line",
             TrackingSpecification."Source Ref. No.",
             TrackingSpecification."Location Code",
             TrackingSpecification."Item No.")
        then begin
          SetControls(Controls::Quantity,false);
          QtyToHandleBaseEditable := true;
          DeleteIsBlocked := true;
        end;

        ReservEntry."Source Type" := TrackingSpecification."Source Type";
        ReservEntry."Source Subtype" := TrackingSpecification."Source Subtype";
        CurrentSignFactor := CreateReservEntry.SignFactor(ReservEntry);
        CurrentSourceCaption := ReservEntry.TextCaption;
        CurrentSourceType := ReservEntry."Source Type";

        if CurrentSignFactor < 0 then begin
          ExpectedReceiptDate := 0D;
          ShipmentDate := AvailabilityDate;
        end else begin
          ExpectedReceiptDate := AvailabilityDate;
          ShipmentDate := 0D;
        end;

        SourceQuantityArray[1] := TrackingSpecification."Quantity (Base)";
        SourceQuantityArray[2] := TrackingSpecification."Qty. to Handle (Base)";
        SourceQuantityArray[3] := TrackingSpecification."Qty. to Invoice (Base)";
        SourceQuantityArray[4] := TrackingSpecification."Quantity Handled (Base)";
        SourceQuantityArray[5] := TrackingSpecification."Quantity Invoiced (Base)";
        QtyPerUOM := TrackingSpecification."Qty. per Unit of Measure";

        ReservEntry.SetCurrentkey(
          "Source ID","Source Ref. No.","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Reservation Status");

        ReservEntry.SetRange("Source ID",TrackingSpecification."Source ID");
        ReservEntry.SetRange("Source Ref. No.",TrackingSpecification."Source Ref. No.");
        ReservEntry.SetRange("Source Type",TrackingSpecification."Source Type");
        ReservEntry.SetRange("Source Subtype",TrackingSpecification."Source Subtype");
        ReservEntry.SetRange("Source Batch Name",TrackingSpecification."Source Batch Name");
        ReservEntry.SetRange("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");

        // Transfer Receipt gets special treatment:
        if (TrackingSpecification."Source Type" = Database::"Transfer Line") and
           (FormRunMode <> Formrunmode::Transfer) and
           (TrackingSpecification."Source Subtype" = 1)
        then begin
          ReservEntry.SetRange("Source Subtype",0);
          AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification2,true,8421504);
          ReservEntry.SetRange("Source Subtype",1);
          ReservEntry.SetRange("Source Prod. Order Line",TrackingSpecification."Source Ref. No.");
          ReservEntry.SetRange("Source Ref. No.");
          DeleteIsBlocked := true;
          SetControls(Controls::Quantity,false);
        end;

        AddReservEntriesToTempRecSet(ReservEntry,TempTrackingSpecification,false,0);

        TempReservEntry.CopyFilters(ReservEntry);

        TrackingSpecification.SetCurrentkey(
          "Source ID","Source Type","Source Subtype",
          "Source Batch Name","Source Prod. Order Line","Source Ref. No.");

        TrackingSpecification.SetRange("Source ID",TrackingSpecification."Source ID");
        TrackingSpecification.SetRange("Source Type",TrackingSpecification."Source Type");
        TrackingSpecification.SetRange("Source Subtype",TrackingSpecification."Source Subtype");
        TrackingSpecification.SetRange("Source Batch Name",TrackingSpecification."Source Batch Name");
        TrackingSpecification.SetRange("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");
        TrackingSpecification.SetRange("Source Ref. No.",TrackingSpecification."Source Ref. No.");

        if TrackingSpecification.FindSet then
          repeat
            TempTrackingSpecification := TrackingSpecification;
            TempTrackingSpecification.Insert;
          until TrackingSpecification.Next = 0;

        // Data regarding posted quantities on transfers is collected from Item Ledger Entries:
        if TrackingSpecification."Source Type" = Database::"Transfer Line" then
          CollectPostedTransferEntries(TrackingSpecification,TempTrackingSpecification);

        // Data regarding posted quantities on assembly orders is collected from Item Ledger Entries:
        if not ExcludePostedEntries then
          if (TrackingSpecification."Source Type" = Database::"Assembly Line") or
             (TrackingSpecification."Source Type" = Database::"Assembly Header")
          then
            CollectPostedAssemblyEntries(TrackingSpecification,TempTrackingSpecification);

        // Data regarding posted output quantities on prod.orders is collected from Item Ledger Entries:
        if TrackingSpecification."Source Type" = Database::"Prod. Order Line" then
          if TrackingSpecification."Source Subtype" = 3 then
            CollectPostedOutputEntries(TrackingSpecification,TempTrackingSpecification);

        // If run for Drop Shipment a RowID is prepared for synchronisation:
        if FormRunMode = Formrunmode::"Drop Shipment" then
          CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");

        // Synchronization of outbound transfer order:
        if (TrackingSpecification."Source Type" = Database::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 0)
        then begin
          BlockCommit := true;
          CurrentSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              TrackingSpecification."Source Subtype",TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
          SecondSourceRowID := ItemTrackingMgt.ComposeRowID(TrackingSpecification."Source Type",
              1,TrackingSpecification."Source ID",
              TrackingSpecification."Source Batch Name",TrackingSpecification."Source Prod. Order Line",
              TrackingSpecification."Source Ref. No.");
          FormRunMode := Formrunmode::Transfer;
        end;

        AddToGlobalRecordSet(TempTrackingSpecification);
        AddToGlobalRecordSet(TempTrackingSpecification2);
        CalculateSums;

        ItemTrackingDataCollection.SetCurrentBinAndItemTrkgCode(ForBinCode,ItemTrackingCode);
        ItemTrackingDataCollection.RetrieveLookupData(Rec,false);

        FunctionsDemandVisible := CurrentSignFactor * SourceQuantityArray[1] < 0;
        FunctionsSupplyVisible := not FunctionsDemandVisible;
    end;


    procedure SetSecondSourceQuantity(SecondSourceQuantityArray: array [3] of Decimal)
    var
        Controls: Option Handle,Invoice;
    begin
        case SecondSourceQuantityArray[1] of
          Database::"Warehouse Receipt Line",Database::"Warehouse Shipment Line":
            begin
              SourceQuantityArray[2] := SecondSourceQuantityArray[2]; // "Qty. to Handle (Base)"
              SourceQuantityArray[3] := SecondSourceQuantityArray[3]; // "Qty. to Invoice (Base)"
              SetControls(Controls::Invoice,false);
            end;
          else
            exit;
        end;
        CalculateSums;
    end;


    procedure SetSecondSourceRowID(RowID: Text[250])
    begin
        SecondSourceRowID := RowID;
    end;

    local procedure AddReservEntriesToTempRecSet(var ReservEntry: Record "Reservation Entry";var TempTrackingSpecification: Record "Tracking Specification" temporary;SwapSign: Boolean;Color: Integer)
    var
        FromReservEntry: Record "Reservation Entry";
        AddTracking: Boolean;
    begin
        if ReservEntry.FindSet then
          repeat
            if Color = 0 then begin
              TempReservEntry := ReservEntry;
              TempReservEntry.Insert;
            end;
            if ReservEntry.TrackingExists then begin
              AddTracking := true;
              if SecondSourceID = Database::"Warehouse Shipment Line" then
                if FromReservEntry.Get(ReservEntry."Entry No.",not ReservEntry.Positive) then
                  AddTracking := (FromReservEntry."Source Type" = Database::"Assembly Header") = IsAssembleToOrder;

              if AddTracking then begin
                TempTrackingSpecification.TransferFields(ReservEntry);
                // Ensure uniqueness of Entry No. by making it negative:
                TempTrackingSpecification."Entry No." *= -1;
                if SwapSign then
                  TempTrackingSpecification."Quantity (Base)" *= -1;
                if Color <> 0 then begin
                  TempTrackingSpecification."Quantity Handled (Base)" :=
                    TempTrackingSpecification."Quantity (Base)";
                  TempTrackingSpecification."Quantity Invoiced (Base)" :=
                    TempTrackingSpecification."Quantity (Base)";
                  TempTrackingSpecification."Qty. to Handle (Base)" := 0;
                  TempTrackingSpecification."Qty. to Invoice (Base)" := 0;
                end;
                TempTrackingSpecification."Buffer Status" := Color;
                TempTrackingSpecification.Insert;
              end;
            end;
          until ReservEntry.Next = 0;
    end;

    local procedure AddToGlobalRecordSet(var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ExpDate: Date;
        EntriesExist: Boolean;
    begin
        TempTrackingSpecification.SetCurrentkey("Lot No.","Serial No.");
        if TempTrackingSpecification.Find('-') then
          repeat
            TempTrackingSpecification.SetRange("Lot No.",TempTrackingSpecification."Lot No.");
            TempTrackingSpecification.SetRange("Serial No.",TempTrackingSpecification."Serial No.");
            TempTrackingSpecification.CalcSums("Quantity (Base)","Qty. to Handle (Base)",
              "Qty. to Invoice (Base)","Quantity Handled (Base)","Quantity Invoiced (Base)");
            if TempTrackingSpecification."Quantity (Base)" <> 0 then begin
              Rec := TempTrackingSpecification;
              "Quantity (Base)" *= CurrentSignFactor;
              "Qty. to Handle (Base)" *= CurrentSignFactor;
              "Qty. to Invoice (Base)" *= CurrentSignFactor;
              "Quantity Handled (Base)" *= CurrentSignFactor;
              "Quantity Invoiced (Base)" *= CurrentSignFactor;
              "Qty. to Handle" :=
                CalcQty("Qty. to Handle (Base)");
              "Qty. to Invoice" :=
                CalcQty("Qty. to Invoice (Base)");
              "Entry No." := NextEntryNo;

              ExpDate := ItemTrackingMgt.ExistingExpirationDate(
                  "Item No.","Variant Code",
                  "Lot No.","Serial No.",false,EntriesExist);

              if ExpDate <> 0D then begin
                "Expiration Date" := ExpDate;
                "Buffer Status2" := "buffer status2"::"ExpDate blocked";
              end;

              Insert;

              if "Buffer Status" = 0 then begin
                xTempItemTrackingLine := Rec;
                xTempItemTrackingLine.Insert;
              end;
            end;

            TempTrackingSpecification.Find('+');
            TempTrackingSpecification.SetRange("Lot No.");
            TempTrackingSpecification.SetRange("Serial No.");
          until TempTrackingSpecification.Next = 0;
    end;

    local procedure SetControls(Controls: Option Handle,Invoice,Quantity,Reclass,LotSN;SetAccess: Boolean)
    begin
        case Controls of
          Controls::Handle:
            begin
              Handle1Visible := SetAccess;
              Handle2Visible := SetAccess;
              Handle3Visible := SetAccess;
              QtyToHandleBaseVisible := SetAccess;
              QtyToHandleBaseEditable := SetAccess;
            end;
          Controls::Invoice:
            begin
              Invoice1Visible := SetAccess;
              Invoice2Visible := SetAccess;
              Invoice3Visible := SetAccess;
              QtyToInvoiceBaseVisible := SetAccess;
              QtyToInvoiceBaseEditable := SetAccess;
            end;
          Controls::Quantity:
            begin
              QuantityBaseEditable := SetAccess;
              SerialNoEditable := SetAccess;
              LotNoEditable := SetAccess;
              DescriptionEditable := SetAccess;
              InsertIsBlocked := true;
            end;
          Controls::Reclass:
            begin
              NewSerialNoVisible := SetAccess;
              NewSerialNoEditable := SetAccess;
              NewLotNoVisible := SetAccess;
              NewLotNoEditable := SetAccess;
              NewExpirationDateVisible := SetAccess;
              NewExpirationDateEditable := SetAccess;
              ButtonLineReclassVisible := SetAccess;
              ButtonLineVisible := not SetAccess;
            end;
          Controls::LotSN:
            begin
              SerialNoEditable := SetAccess;
              LotNoEditable := SetAccess;
              ExpirationDateEditable := SetAccess;
              WarrantyDateEditable := SetAccess;
              InsertIsBlocked := SetAccess;
            end;
        end;
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        if Item."No." <> ItemNo then begin
          Item.Get(ItemNo);
          Item.TestField("Item Tracking Code");
          if ItemTrackingCode.Code <> Item."Item Tracking Code" then
            ItemTrackingCode.Get(Item."Item Tracking Code");
        end;
    end;

    local procedure SetFilters(TrackingSpecification: Record "Tracking Specification")
    begin
        FilterGroup := 2;
        SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
        SetRange("Source ID",TrackingSpecification."Source ID");
        SetRange("Source Type",TrackingSpecification."Source Type");
        SetRange("Source Subtype",TrackingSpecification."Source Subtype");
        SetRange("Source Batch Name",TrackingSpecification."Source Batch Name");
        if (TrackingSpecification."Source Type" = Database::"Transfer Line") and
           (TrackingSpecification."Source Subtype" = 1)
        then begin
          SetFilter("Source Prod. Order Line",'0 | ' + Format(TrackingSpecification."Source Ref. No."));
          SetRange("Source Ref. No.");
        end else begin
          SetRange("Source Prod. Order Line",TrackingSpecification."Source Prod. Order Line");
          SetRange("Source Ref. No.",TrackingSpecification."Source Ref. No.");
        end;
        SetRange("Item No.",TrackingSpecification."Item No.");
        SetRange("Location Code",TrackingSpecification."Location Code");
        SetRange("Variant Code",TrackingSpecification."Variant Code");
        FilterGroup := 0;
    end;

    local procedure CheckLine(TrackingLine: Record "Tracking Specification")
    begin
        if TrackingLine."Quantity (Base)" * SourceQuantityArray[1] < 0 then
          if SourceQuantityArray[1] < 0 then
            Error(Text002,Text003)
          else
            Error(Text002,Text004);
    end;

    local procedure CalculateSums()
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        xTrackingSpec.Copy(Rec);
        Reset;
        CalcSums("Quantity (Base)",
          "Qty. to Handle (Base)",
          "Qty. to Invoice (Base)");
        TotalItemTrackingLine := Rec;
        Copy(xTrackingSpec);

        UpdateUndefinedQtyArray;
    end;

    local procedure UpdateUndefinedQty(): Boolean
    begin
        UpdateUndefinedQtyArray;
        if ProdOrderLineHandling then // Avoid check for prod.journal lines
          exit(true);
        exit(Abs(SourceQuantityArray[1]) >= Abs(TotalItemTrackingLine."Quantity (Base)"));
    end;

    local procedure UpdateUndefinedQtyArray()
    begin
        UndefinedQtyArray[1] := SourceQuantityArray[1] - TotalItemTrackingLine."Quantity (Base)";
        UndefinedQtyArray[2] := SourceQuantityArray[2] - TotalItemTrackingLine."Qty. to Handle (Base)";
        UndefinedQtyArray[3] := SourceQuantityArray[3] - TotalItemTrackingLine."Qty. to Invoice (Base)";
    end;

    local procedure TempRecIsValid() OK: Boolean
    var
        ReservEntry: Record "Reservation Entry";
        RecordCount: Integer;
        IdenticalArray: array [2] of Boolean;
    begin
        OK := false;
        TempReservEntry.SetCurrentkey("Entry No.",Positive);
        ReservEntry.SetCurrentkey("Source ID","Source Ref. No.","Source Type",
          "Source Subtype","Source Batch Name","Source Prod. Order Line");

        ReservEntry.CopyFilters(TempReservEntry);

        if ReservEntry.FindSet then
          repeat
            if not TempReservEntry.Get(ReservEntry."Entry No.",ReservEntry.Positive) then
              exit(false);
            if not EntriesAreIdentical(ReservEntry,TempReservEntry,IdenticalArray) then
              exit(false);
            RecordCount += 1;
          until ReservEntry.Next = 0;

        OK := RecordCount = TempReservEntry.Count;
    end;

    local procedure EntriesAreIdentical(var ReservEntry1: Record "Reservation Entry";var ReservEntry2: Record "Reservation Entry";var IdenticalArray: array [2] of Boolean): Boolean
    begin
        IdenticalArray[1] := (
                              (ReservEntry1."Entry No." = ReservEntry2."Entry No.") and
                              (ReservEntry1."Item No." = ReservEntry2."Item No.") and
                              (ReservEntry1."Location Code" = ReservEntry2."Location Code") and
                              (ReservEntry1."Quantity (Base)" = ReservEntry2."Quantity (Base)") and
                              (ReservEntry1."Reservation Status" = ReservEntry2."Reservation Status") and
                              (ReservEntry1."Creation Date" = ReservEntry2."Creation Date") and
                              (ReservEntry1."Transferred from Entry No." = ReservEntry2."Transferred from Entry No.") and
                              (ReservEntry1."Source Type" = ReservEntry2."Source Type") and
                              (ReservEntry1."Source Subtype" = ReservEntry2."Source Subtype") and
                              (ReservEntry1."Source ID" = ReservEntry2."Source ID") and
                              (ReservEntry1."Source Batch Name" = ReservEntry2."Source Batch Name") and
                              (ReservEntry1."Source Prod. Order Line" = ReservEntry2."Source Prod. Order Line") and
                              (ReservEntry1."Source Ref. No." = ReservEntry2."Source Ref. No.") and
                              (ReservEntry1."Expected Receipt Date" = ReservEntry2."Expected Receipt Date") and
                              (ReservEntry1."Shipment Date" = ReservEntry2."Shipment Date") and
                              (ReservEntry1."Serial No." = ReservEntry2."Serial No.") and
                              (ReservEntry1."Created By" = ReservEntry2."Created By") and
                              (ReservEntry1."Changed By" = ReservEntry2."Changed By") and
                              (ReservEntry1.Positive = ReservEntry2.Positive) and
                              (ReservEntry1."Qty. per Unit of Measure" = ReservEntry2."Qty. per Unit of Measure") and
                              (ReservEntry1.Quantity = ReservEntry2.Quantity) and
                              (ReservEntry1."Action Message Adjustment" = ReservEntry2."Action Message Adjustment") and
                              (ReservEntry1.Binding = ReservEntry2.Binding) and
                              (ReservEntry1."Suppressed Action Msg." = ReservEntry2."Suppressed Action Msg.") and
                              (ReservEntry1."Planning Flexibility" = ReservEntry2."Planning Flexibility") and
                              (ReservEntry1."Lot No." = ReservEntry2."Lot No.") and
                              (ReservEntry1."Variant Code" = ReservEntry2."Variant Code") and
                              (ReservEntry1."Quantity Invoiced (Base)" = ReservEntry2."Quantity Invoiced (Base)"));

        IdenticalArray[2] := (
                              (ReservEntry1.Description = ReservEntry2.Description) and
                              (ReservEntry1."New Serial No." = ReservEntry2."New Serial No.") and
                              (ReservEntry1."New Lot No." = ReservEntry2."New Lot No.") and
                              (ReservEntry1."Expiration Date" = ReservEntry2."Expiration Date") and
                              (ReservEntry1."Warranty Date" = ReservEntry2."Warranty Date") and
                              (ReservEntry1."New Expiration Date" = ReservEntry2."New Expiration Date"));

        exit(IdenticalArray[1] and IdenticalArray[2]);
    end;

    local procedure QtyToHandleAndInvoiceChanged(var ReservEntry1: Record "Reservation Entry";var ReservEntry2: Record "Reservation Entry"): Boolean
    begin
        exit(
          (ReservEntry1."Qty. to Handle (Base)" <> ReservEntry2."Qty. to Handle (Base)") or
          (ReservEntry1."Qty. to Invoice (Base)" <> ReservEntry2."Qty. to Invoice (Base)"));
    end;

    local procedure NextEntryNo(): Integer
    begin
        LastEntryNo += 1;
        exit(LastEntryNo);
    end;

    local procedure WriteToDatabase()
    var
        Window: Dialog;
        ChangeType: Option Insert,Modify,Delete;
        EntryNo: Integer;
        NoOfLines: Integer;
        i: Integer;
        ModifyLoop: Integer;
        Decrease: Boolean;
    begin
        if CurrentFormIsOpen then begin
          TempReservEntry.LockTable;
          TempRecValid;

          if Item."Order Tracking Policy" = Item."order tracking policy"::None then
            QtyToAddAsBlank := 0
          else
            QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

          Reset;
          DeleteAll;

          Window.Open('#1############# @2@@@@@@@@@@@@@@@@@@@@@');
          Window.Update(1,Text018);
          NoOfLines := TempItemTrackLineInsert.Count + TempItemTrackLineModify.Count + TempItemTrackLineDelete.Count;
          if TempItemTrackLineDelete.Find('-') then begin
            repeat
              i := i + 1;
              if i MOD 100 = 0 then
                Window.Update(2,ROUND(i / NoOfLines * 10000,1));
              RegisterChange(TempItemTrackLineDelete,TempItemTrackLineDelete,Changetype::Delete,false);
              if TempItemTrackLineModify.Get(TempItemTrackLineDelete."Entry No.") then
                TempItemTrackLineModify.Delete;
            until TempItemTrackLineDelete.Next = 0;
            TempItemTrackLineDelete.DeleteAll;
          end;

          for ModifyLoop := 1 to 2 do begin
            if TempItemTrackLineModify.Find('-') then
              repeat
                if xTempItemTrackingLine.Get(TempItemTrackLineModify."Entry No.") then begin
                  // Process decreases before increases
                  Decrease := (xTempItemTrackingLine."Quantity (Base)" > TempItemTrackLineModify."Quantity (Base)");
                  if ((ModifyLoop = 1) and Decrease) or ((ModifyLoop = 2) and not Decrease) then begin
                    i := i + 1;
                    if (xTempItemTrackingLine."Serial No." <> TempItemTrackLineModify."Serial No.") or
                       (xTempItemTrackingLine."Lot No." <> TempItemTrackLineModify."Lot No.") or
                       (xTempItemTrackingLine."Appl.-from Item Entry" <> TempItemTrackLineModify."Appl.-from Item Entry") or
                       (xTempItemTrackingLine."Appl.-to Item Entry" <> TempItemTrackLineModify."Appl.-to Item Entry")
                    then begin
                      RegisterChange(xTempItemTrackingLine,xTempItemTrackingLine,Changetype::Delete,false);
                      RegisterChange(TempItemTrackLineModify,TempItemTrackLineModify,Changetype::Insert,false);
                      if (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") or
                         (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
                      then
                        SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
                    end else begin
                      RegisterChange(xTempItemTrackingLine,TempItemTrackLineModify,Changetype::Modify,false);
                      SetQtyToHandleAndInvoice(TempItemTrackLineModify);
                    end;
                    TempItemTrackLineModify.Delete;
                  end;
                end else begin
                  i := i + 1;
                  TempItemTrackLineModify.Delete;
                end;
                if i MOD 100 = 0 then
                  Window.Update(2,ROUND(i / NoOfLines * 10000,1));
              until TempItemTrackLineModify.Next = 0;
          end;

          if TempItemTrackLineInsert.Find('-') then begin
            repeat
              i := i + 1;
              if i MOD 100 = 0 then
                Window.Update(2,ROUND(i / NoOfLines * 10000,1));
              if TempItemTrackLineModify.Get(TempItemTrackLineInsert."Entry No.") then
                TempItemTrackLineInsert.TransferFields(TempItemTrackLineModify);
              if not RegisterChange(TempItemTrackLineInsert,TempItemTrackLineInsert,Changetype::Insert,false) then
                Error(Text005);
              if (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Handle (Base)") or
                 (TempItemTrackLineInsert."Quantity (Base)" <> TempItemTrackLineInsert."Qty. to Invoice (Base)")
              then
                SetQtyToHandleAndInvoice(TempItemTrackLineInsert);
            until TempItemTrackLineInsert.Next = 0;
            TempItemTrackLineInsert.DeleteAll;
          end;
          Window.Close;
        end else begin
          TempReservEntry.LockTable;
          TempRecValid;

          if Item."Order Tracking Policy" = Item."order tracking policy"::None then
            QtyToAddAsBlank := 0
          else
            QtyToAddAsBlank := UndefinedQtyArray[1] * CurrentSignFactor;

          Reset;
          SetFilter("Buffer Status",'<>%1',0);
          DeleteAll;
          Reset;

          xTempItemTrackingLine.Reset;
          SetCurrentkey("Entry No.");
          xTempItemTrackingLine.SetCurrentkey("Entry No.");
          if xTempItemTrackingLine.Find('-') then
            repeat
              SetRange("Lot No.",xTempItemTrackingLine."Lot No.");
              SetRange("Serial No.",xTempItemTrackingLine."Serial No.");
              if Find('-') then begin
                if RegisterChange(xTempItemTrackingLine,Rec,Changetype::Modify,false) then begin
                  EntryNo := xTempItemTrackingLine."Entry No.";
                  xTempItemTrackingLine := Rec;
                  xTempItemTrackingLine."Entry No." := EntryNo;
                  xTempItemTrackingLine.Modify;
                end;
                SetQtyToHandleAndInvoice(Rec);
                Delete;
              end else begin
                RegisterChange(xTempItemTrackingLine,xTempItemTrackingLine,Changetype::Delete,false);
                xTempItemTrackingLine.Delete;
              end;
            until xTempItemTrackingLine.Next = 0;

          Reset;

          if Find('-') then
            repeat
              if RegisterChange(Rec,Rec,Changetype::Insert,false) then begin
                xTempItemTrackingLine := Rec;
                xTempItemTrackingLine.Insert;
              end else
                Error(Text005);
              SetQtyToHandleAndInvoice(Rec);
              Delete;
            until Next = 0;
        end;

        UpdateOrderTracking;
        ReestablishReservations; // Late Binding

        if not BlockCommit then
          Commit;
    end;

    local procedure RegisterChange(var OldTrackingSpecification: Record "Tracking Specification";var NewTrackingSpecification: Record "Tracking Specification";ChangeType: Option Insert,Modify,FullDelete,PartDelete,ModifyAll;ModifySharedFields: Boolean) OK: Boolean
    var
        ReservEntry1: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        ReservationMgt: Codeunit "Reservation Management";
        QtyToAdd: Decimal;
        LostReservQty: Decimal;
        IdenticalArray: array [2] of Boolean;
    begin
        OK := false;
        ReservEngineMgt.SetPick(IsPick);

        if ((CurrentSignFactor * NewTrackingSpecification."Qty. to Handle") < 0) and
           (FormRunMode <> Formrunmode::"Drop Shipment")
        then begin
          NewTrackingSpecification."Expiration Date" := 0D;
          OldTrackingSpecification."Expiration Date" := 0D;
        end;

        case ChangeType of
          Changetype::Insert:
            begin
              if (OldTrackingSpecification."Quantity (Base)" = 0) or not OldTrackingSpecification.TrackingExists then
                exit(true);
              TempReservEntry.SetRange("Serial No.",'');
              TempReservEntry.SetRange("Lot No.",'');
              OldTrackingSpecification."Quantity (Base)" :=
                CurrentSignFactor *
                ReservEngineMgt.AddItemTrackingToTempRecSet(
                  TempReservEntry,NewTrackingSpecification,
                  CurrentSignFactor * OldTrackingSpecification."Quantity (Base)",QtyToAddAsBlank,
                  ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
              TempReservEntry.SetRange("Serial No.");
              TempReservEntry.SetRange("Lot No.");

              // Late Binding
              if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                TempItemTrackLineReserv := NewTrackingSpecification;
                TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                TempItemTrackLineReserv.Insert;
              end;

              if OldTrackingSpecification."Quantity (Base)" = 0 then
                exit(true);

              if FormRunMode = Formrunmode::Reclass then begin
                CreateReservEntry.SetNewSerialLotNo(
                  OldTrackingSpecification."New Serial No.",OldTrackingSpecification."New Lot No.");
                CreateReservEntry.SetNewExpirationDate(OldTrackingSpecification."New Expiration Date");
              end;
              CreateReservEntry.SetDates(
                NewTrackingSpecification."Warranty Date",NewTrackingSpecification."Expiration Date");
              CreateReservEntry.SetApplyFromEntryNo(NewTrackingSpecification."Appl.-from Item Entry");
              CreateReservEntry.SetApplyToEntryNo(NewTrackingSpecification."Appl.-to Item Entry");
              CreateReservEntry.CreateReservEntryFor(
                OldTrackingSpecification."Source Type",
                OldTrackingSpecification."Source Subtype",
                OldTrackingSpecification."Source ID",
                OldTrackingSpecification."Source Batch Name",
                OldTrackingSpecification."Source Prod. Order Line",
                OldTrackingSpecification."Source Ref. No.",
                OldTrackingSpecification."Qty. per Unit of Measure",
                0,
                OldTrackingSpecification."Quantity (Base)",
                OldTrackingSpecification."Serial No.",
                OldTrackingSpecification."Lot No.");
              CreateReservEntry.CreateEntry(OldTrackingSpecification."Item No.",
                OldTrackingSpecification."Variant Code",
                OldTrackingSpecification."Location Code",
                OldTrackingSpecification.Description,
                ExpectedReceiptDate,
                ShipmentDate,0,CurrentEntryStatus);
              CreateReservEntry.GetLastEntry(ReservEntry1);
              if Item."Order Tracking Policy" = Item."order tracking policy"::"Tracking & Action Msg." then
                ReservEngineMgt.UpdateActionMessages(ReservEntry1);

              if ModifySharedFields then begin
                ReservationMgt.SetPointerFilter(ReservEntry1);
                ReservEntry1.SetRange("Lot No.",ReservEntry1."Lot No.");
                ReservEntry1.SetRange("Serial No.",ReservEntry1."Serial No.");
                ReservEntry1.SetFilter("Entry No.",'<>%1',ReservEntry1."Entry No.");
                ModifyFieldsWithinFilter(ReservEntry1,NewTrackingSpecification);
              end;

              OK := true;
            end;
          Changetype::Modify:
            begin
              ReservEntry1.TransferFields(OldTrackingSpecification);
              ReservEntry2.TransferFields(NewTrackingSpecification);

              ReservEntry1."Entry No." := ReservEntry2."Entry No."; // If only entry no. has changed it should not trigger
              if EntriesAreIdentical(ReservEntry1,ReservEntry2,IdenticalArray) then
                exit(QtyToHandleAndInvoiceChanged(ReservEntry1,ReservEntry2));

              if Abs(OldTrackingSpecification."Quantity (Base)") < Abs(NewTrackingSpecification."Quantity (Base)") then begin
                // Item Tracking is added to any blank reservation entries:
                TempReservEntry.SetRange("Serial No.",'');
                TempReservEntry.SetRange("Lot No.",'');
                QtyToAdd :=
                  CurrentSignFactor *
                  ReservEngineMgt.AddItemTrackingToTempRecSet(
                    TempReservEntry,NewTrackingSpecification,
                    CurrentSignFactor * (NewTrackingSpecification."Quantity (Base)" -
                                         OldTrackingSpecification."Quantity (Base)"),QtyToAddAsBlank,
                    ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
                TempReservEntry.SetRange("Serial No.");
                TempReservEntry.SetRange("Lot No.");

                // Late Binding
                if ReservEngineMgt.RetrieveLostReservQty(LostReservQty) then begin
                  TempItemTrackLineReserv := NewTrackingSpecification;
                  TempItemTrackLineReserv."Quantity (Base)" := LostReservQty * CurrentSignFactor;
                  TempItemTrackLineReserv.Insert;
                end;

                OldTrackingSpecification."Quantity (Base)" := QtyToAdd;
                OldTrackingSpecification."Warranty Date" := NewTrackingSpecification."Warranty Date";
                OldTrackingSpecification."Expiration Date" := NewTrackingSpecification."Expiration Date";
                OldTrackingSpecification.Description := NewTrackingSpecification.Description;
                RegisterChange(OldTrackingSpecification,OldTrackingSpecification,
                  Changetype::Insert,not IdenticalArray[2]);
              end else begin
                TempReservEntry.SetRange("Serial No.",OldTrackingSpecification."Serial No.");
                TempReservEntry.SetRange("Lot No.",OldTrackingSpecification."Lot No.");
                OldTrackingSpecification."Serial No." := '';
                OldTrackingSpecification."Lot No." := '';
                OldTrackingSpecification."Warranty Date" := 0D;
                OldTrackingSpecification."Expiration Date" := 0D;
                QtyToAdd :=
                  CurrentSignFactor *
                  ReservEngineMgt.AddItemTrackingToTempRecSet(
                    TempReservEntry,OldTrackingSpecification,
                    CurrentSignFactor * (OldTrackingSpecification."Quantity (Base)" -
                                         NewTrackingSpecification."Quantity (Base)"),QtyToAddAsBlank,
                    ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
                TempReservEntry.SetRange("Serial No.");
                TempReservEntry.SetRange("Lot No.");
                RegisterChange(NewTrackingSpecification,NewTrackingSpecification,
                  Changetype::PartDelete,not IdenticalArray[2]);
              end;
              OK := true;
            end;
          Changetype::FullDelete,Changetype::PartDelete:
            begin
              ReservationMgt.SetItemTrackingHandling(1); // Allow deletion of Item Tracking
              ReservEntry1.TransferFields(OldTrackingSpecification);
              ReservationMgt.SetPointerFilter(ReservEntry1);
              ReservEntry1.SetRange("Lot No.",ReservEntry1."Lot No.");
              ReservEntry1.SetRange("Serial No.",ReservEntry1."Serial No.");
              if ChangeType = Changetype::FullDelete then begin
                TempReservEntry.SetRange("Serial No.",OldTrackingSpecification."Serial No.");
                TempReservEntry.SetRange("Lot No.",OldTrackingSpecification."Lot No.");
                OldTrackingSpecification."Serial No." := '';
                OldTrackingSpecification."Lot No." := '';
                OldTrackingSpecification."Warranty Date" := 0D;
                OldTrackingSpecification."Expiration Date" := 0D;
                QtyToAdd :=
                  CurrentSignFactor *
                  ReservEngineMgt.AddItemTrackingToTempRecSet(
                    TempReservEntry,OldTrackingSpecification,
                    CurrentSignFactor * OldTrackingSpecification."Quantity (Base)",QtyToAddAsBlank,
                    ItemTrackingCode."SN Specific Tracking",ItemTrackingCode."Lot Specific Tracking");
                TempReservEntry.SetRange("Serial No.");
                TempReservEntry.SetRange("Lot No.");
                ReservationMgt.DeleteReservEntries2(true,0,ReservEntry1)
              end else begin
                ReservationMgt.DeleteReservEntries2(false,ReservEntry1."Quantity (Base)" -
                  OldTrackingSpecification."Quantity Handled (Base)",ReservEntry1);
                if ModifySharedFields then begin
                  ReservEntry1.SetRange("Reservation Status");
                  ModifyFieldsWithinFilter(ReservEntry1,OldTrackingSpecification);
                end;
              end;
              OK := true;
            end;
        end;
        SetQtyToHandleAndInvoice(NewTrackingSpecification);
    end;

    local procedure UpdateOrderTracking()
    var
        TempReservEntry: Record "Reservation Entry" temporary;
    begin
        if not ReservEngineMgt.CollectAffectedSurplusEntries(TempReservEntry) then
          exit;
        if Item."Order Tracking Policy" = Item."order tracking policy"::None then
          exit;
        ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
    end;

    local procedure ModifyFieldsWithinFilter(var ReservEntry1: Record "Reservation Entry";var TrackingSpecification: Record "Tracking Specification")
    begin
        // Used to ensure that field values that are common to a SN/Lot are copied to all entries.
        if ReservEntry1.Find('-') then
          repeat
            ReservEntry1.Description := TrackingSpecification.Description;
            ReservEntry1."Warranty Date" := TrackingSpecification."Warranty Date";
            ReservEntry1."Expiration Date" := TrackingSpecification."Expiration Date";
            ReservEntry1."New Serial No." := TrackingSpecification."New Serial No.";
            ReservEntry1."New Lot No." := TrackingSpecification."New Lot No.";
            ReservEntry1."New Expiration Date" := TrackingSpecification."New Expiration Date";
            ReservEntry1.Modify;
          until ReservEntry1.Next = 0;
    end;

    local procedure SetQtyToHandleAndInvoice(TrackingSpecification: Record "Tracking Specification")
    var
        ReservEntry1: Record "Reservation Entry";
        ReservationMgt: Codeunit "Reservation Management";
        TotalQtyToHandle: Decimal;
        TotalQtyToInvoice: Decimal;
        QtyToHandleThisLine: Decimal;
        QtyToInvoiceThisLine: Decimal;
    begin
        if IsCorrection then
          exit;

        TotalQtyToHandle := TrackingSpecification."Qty. to Handle (Base)" * CurrentSignFactor;
        TotalQtyToInvoice := TrackingSpecification."Qty. to Invoice (Base)" * CurrentSignFactor;

        ReservEntry1.TransferFields(TrackingSpecification);
        ReservationMgt.SetPointerFilter(ReservEntry1);
        ReservEntry1.SetRange("Lot No.",ReservEntry1."Lot No.");
        ReservEntry1.SetRange("Serial No.",ReservEntry1."Serial No.");
        if TrackingSpecification.TrackingExists then begin
          ItemTrackingMgt.SetPointerFilter(TrackingSpecification);
          TrackingSpecification.SetRange("Lot No.",TrackingSpecification."Lot No.");
          TrackingSpecification.SetRange("Serial No.",TrackingSpecification."Serial No.");

          if TrackingSpecification.Find('-') then
            repeat
              if not TrackingSpecification.Correction then begin
                QtyToInvoiceThisLine :=
                  TrackingSpecification."Quantity Handled (Base)" - TrackingSpecification."Quantity Invoiced (Base)";
                if Abs(QtyToInvoiceThisLine) > Abs(TotalQtyToInvoice) then
                  QtyToInvoiceThisLine := TotalQtyToInvoice;

                if TrackingSpecification."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine then begin
                  TrackingSpecification."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                  TrackingSpecification.Modify;
                end;

                TotalQtyToInvoice -= QtyToInvoiceThisLine;
              end;
            until (TrackingSpecification.Next = 0);
        end;

        if TrackingSpecification."Lot No." <> '' then
          for ReservEntry1."Reservation Status" := ReservEntry1."reservation status"::Reservation to
              ReservEntry1."reservation status"::Prospect
          do begin
            ReservEntry1.SetRange("Reservation Status",ReservEntry1."Reservation Status");
            if ReservEntry1.Find('-') then
              repeat
                QtyToHandleThisLine := ReservEntry1."Quantity (Base)";
                QtyToInvoiceThisLine := QtyToHandleThisLine;

                if Abs(QtyToHandleThisLine) > Abs(TotalQtyToHandle) then
                  QtyToHandleThisLine := TotalQtyToHandle;
                if Abs(QtyToInvoiceThisLine) > Abs(TotalQtyToInvoice) then
                  QtyToInvoiceThisLine := TotalQtyToInvoice;

                if (ReservEntry1."Qty. to Handle (Base)" <> QtyToHandleThisLine) or
                   (ReservEntry1."Qty. to Invoice (Base)" <> QtyToInvoiceThisLine) and not ReservEntry1.Correction
                then begin
                  ReservEntry1."Qty. to Handle (Base)" := QtyToHandleThisLine;
                  ReservEntry1."Qty. to Invoice (Base)" := QtyToInvoiceThisLine;
                  ReservEntry1.Modify;
                end;

                TotalQtyToHandle -= QtyToHandleThisLine;
                TotalQtyToInvoice -= QtyToInvoiceThisLine;

              until (ReservEntry1.Next = 0);
          end
        else
          if ReservEntry1.Find('-') then
            if (ReservEntry1."Qty. to Handle (Base)" <> TotalQtyToHandle) or
               (ReservEntry1."Qty. to Invoice (Base)" <> TotalQtyToInvoice) and not ReservEntry1.Correction
            then begin
              ReservEntry1."Qty. to Handle (Base)" := TotalQtyToHandle;
              ReservEntry1."Qty. to Invoice (Base)" := TotalQtyToInvoice;
              ReservEntry1.Modify;
            end;
    end;

    local procedure CollectPostedTransferEntries(TrackingSpecification: Record "Tracking Specification";var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Used for collecting information about posted Transfer Shipments from the created Item Ledger Entries.
        if TrackingSpecification."Source Type" <> Database::"Transfer Line" then
          exit;

        ItemEntryRelation.SetCurrentkey("Order No.","Order Line No.");
        ItemEntryRelation.SetRange("Order No.",TrackingSpecification."Source ID");
        ItemEntryRelation.SetRange("Order Line No.",TrackingSpecification."Source Ref. No.");

        case TrackingSpecification."Source Subtype" of
          0: // Outbound
            ItemEntryRelation.SetRange("Source Type",Database::"Transfer Shipment Line");
          1: // Inbound
            ItemEntryRelation.SetRange("Source Type",Database::"Transfer Receipt Line");
        end;

        if ItemEntryRelation.Find('-') then
          repeat
            ItemLedgerEntry.Get(ItemEntryRelation."Item Entry No.");
            TempTrackingSpecification := TrackingSpecification;
            TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
            TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
            TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
            TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
            TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
            TempTrackingSpecification.InitQtyToShip;
            TempTrackingSpecification.Insert;
          until ItemEntryRelation.Next = 0;
    end;

    local procedure CollectPostedAssemblyEntries(TrackingSpecification: Record "Tracking Specification";var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemEntryRelation: Record "Item Entry Relation";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        // Used for collecting information about posted Assembly Lines from the created Item Ledger Entries.
        if (TrackingSpecification."Source Type" <> Database::"Assembly Line") and
           (TrackingSpecification."Source Type" <> Database::"Assembly Header")
        then
          exit;

        ItemEntryRelation.SetCurrentkey("Order No.","Order Line No.");
        ItemEntryRelation.SetRange("Order No.",TrackingSpecification."Source ID");
        ItemEntryRelation.SetRange("Order Line No.",TrackingSpecification."Source Ref. No.");
        if TrackingSpecification."Source Type" = Database::"Assembly Line" then
          ItemEntryRelation.SetRange("Source Type",Database::"Posted Assembly Line")
        else
          ItemEntryRelation.SetRange("Source Type",Database::"Posted Assembly Header");

        if ItemEntryRelation.Find('-') then
          repeat
            ItemLedgerEntry.Get(ItemEntryRelation."Item Entry No.");
            TempTrackingSpecification := TrackingSpecification;
            TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
            TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
            TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
            TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
            TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
            TempTrackingSpecification.InitQtyToShip;
            TempTrackingSpecification.Insert;
          until ItemEntryRelation.Next = 0;
    end;

    local procedure CollectPostedOutputEntries(TrackingSpecification: Record "Tracking Specification";var TempTrackingSpecification: Record "Tracking Specification" temporary)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        BackwardFlushing: Boolean;
    begin
        // Used for collecting information about posted prod. order output from the created Item Ledger Entries.
        if TrackingSpecification."Source Type" <> Database::"Prod. Order Line" then
          exit;

        if (TrackingSpecification."Source Type" = Database::"Prod. Order Line") and
           (TrackingSpecification."Source Subtype" = 3)
        then begin
          ProdOrderRoutingLine.SetRange(Status,TrackingSpecification."Source Subtype");
          ProdOrderRoutingLine.SetRange("Prod. Order No.",TrackingSpecification."Source ID");
          ProdOrderRoutingLine.SetRange("Routing Reference No.",TrackingSpecification."Source Prod. Order Line");
          if ProdOrderRoutingLine.FindLast then
            BackwardFlushing :=
              ProdOrderRoutingLine."Flushing Method" = ProdOrderRoutingLine."flushing method"::Backward;
        end;

        ItemLedgerEntry.SetCurrentkey("Order Type","Order No.","Order Line No.","Entry Type");
        ItemLedgerEntry.SetRange("Order Type",ItemLedgerEntry."order type"::Production);
        ItemLedgerEntry.SetRange("Order No.",TrackingSpecification."Source ID");
        ItemLedgerEntry.SetRange("Order Line No.",TrackingSpecification."Source Prod. Order Line");
        ItemLedgerEntry.SetRange("Entry Type",ItemLedgerEntry."entry type"::Output);

        if ItemLedgerEntry.Find('-') then
          repeat
            TempTrackingSpecification := TrackingSpecification;
            TempTrackingSpecification."Entry No." := ItemLedgerEntry."Entry No.";
            TempTrackingSpecification."Item No." := ItemLedgerEntry."Item No.";
            TempTrackingSpecification."Serial No." := ItemLedgerEntry."Serial No.";
            TempTrackingSpecification."Lot No." := ItemLedgerEntry."Lot No.";
            TempTrackingSpecification."Quantity (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Quantity Handled (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Quantity Invoiced (Base)" := ItemLedgerEntry.Quantity;
            TempTrackingSpecification."Qty. per Unit of Measure" := ItemLedgerEntry."Qty. per Unit of Measure";
            TempTrackingSpecification.InitQtyToShip;
            TempTrackingSpecification.Insert;

            if BackwardFlushing then begin
              SourceQuantityArray[1] += ItemLedgerEntry.Quantity;
              SourceQuantityArray[2] += ItemLedgerEntry.Quantity;
              SourceQuantityArray[3] += ItemLedgerEntry.Quantity;
            end;

          until ItemLedgerEntry.Next = 0;
    end;

    local procedure ZeroLineExists() OK: Boolean
    var
        xTrackingSpec: Record "Tracking Specification";
    begin
        if ("Quantity (Base)" <> 0) or TrackingExists then
          exit(false);
        xTrackingSpec.Copy(Rec);
        Reset;
        SetRange("Quantity (Base)",0);
        SetRange("Serial No.",'');
        SetRange("Lot No.",'');
        OK := not IsEmpty;
        Copy(xTrackingSpec);
    end;

    local procedure AssignSerialNo()
    var
        EnterQuantityToCreate: Page "Enter Quantity to Create";
        QtyToCreate: Decimal;
        QtyToCreateInt: Integer;
        CreateLotNo: Boolean;
    begin
        if ZeroLineExists then
          Delete;

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
        if QtyToCreate < 0 then
          QtyToCreate := 0;

        if QtyToCreate MOD 1 <> 0 then
          Error(Text008);

        QtyToCreateInt := QtyToCreate;

        Clear(EnterQuantityToCreate);
        EnterQuantityToCreate.SetFields("Item No.","Variant Code",QtyToCreate,false);
        if EnterQuantityToCreate.RunModal = Action::OK then begin
          EnterQuantityToCreate.GetFields(QtyToCreateInt,CreateLotNo);
          AssignSerialNoBatch(QtyToCreateInt,CreateLotNo);
        end;
    end;

    local procedure AssignSerialNoBatch(QtyToCreate: Integer;CreateLotNo: Boolean)
    var
        i: Integer;
    begin
        if QtyToCreate <= 0 then
          Error(Text009);
        if QtyToCreate MOD 1 <> 0 then
          Error(Text008);

        GetItem("Item No.");

        if CreateLotNo then begin
          TestField("Lot No.",'');
          Item.TestField("Lot Nos.");
          Validate("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WorkDate,true));
        end;

        Item.TestField("Serial Nos.");
        ItemTrackingDataCollection.SetSkipLot(true);
        for i := 1 to QtyToCreate do begin
          Validate("Quantity Handled (Base)",0);
          Validate("Quantity Invoiced (Base)",0);
          Validate("Serial No.",NoSeriesMgt.GetNextNo(Item."Serial Nos.",WorkDate,true));
          Validate("Quantity (Base)",QtySignFactor);
          "Entry No." := NextEntryNo;
          if TestTempSpecificationExists then
            Error('');
          Insert;
          TempItemTrackLineInsert.TransferFields(Rec);
          TempItemTrackLineInsert.Insert;
          if i = QtyToCreate then
            ItemTrackingDataCollection.SetSkipLot(false);
          ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
            TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
        end;
        CalculateSums;
    end;

    local procedure AssignLotNo()
    var
        QtyToCreate: Decimal;
    begin
        if ZeroLineExists then
          Delete;

        if (SourceQuantityArray[1] * UndefinedQtyArray[1] <= 0) or
           (Abs(SourceQuantityArray[1]) < Abs(UndefinedQtyArray[1]))
        then
          QtyToCreate := 0
        else
          QtyToCreate := UndefinedQtyArray[1];

        GetItem("Item No.");

        Item.TestField("Lot Nos.");
        Validate("Quantity Handled (Base)",0);
        Validate("Quantity Invoiced (Base)",0);
        Validate("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WorkDate,true));
        "Qty. per Unit of Measure" := QtyPerUOM;
        Validate("Quantity (Base)",QtyToCreate);
        "Entry No." := NextEntryNo;
        TestTempSpecificationExists;
        Insert;
        TempItemTrackLineInsert.TransferFields(Rec);
        TempItemTrackLineInsert.Insert;
        ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
          TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
        CalculateSums;
    end;

    local procedure CreateCustomizedSN()
    var
        EnterCustomizedSN: Page "Enter Customized SN";
        QtyToCreate: Decimal;
        QtyToCreateInt: Integer;
        Increment: Integer;
        CreateLotNo: Boolean;
        CustomizedSN: Code[20];
    begin
        if ZeroLineExists then
          Delete;

        QtyToCreate := UndefinedQtyArray[1] * QtySignFactor;
        if QtyToCreate < 0 then
          QtyToCreate := 0;

        if QtyToCreate MOD 1 <> 0 then
          Error(Text008);

        QtyToCreateInt := QtyToCreate;

        Clear(EnterCustomizedSN);
        EnterCustomizedSN.SetFields("Item No.","Variant Code",QtyToCreate,false);
        if EnterCustomizedSN.RunModal = Action::OK then begin
          EnterCustomizedSN.GetFields(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
          CreateCustomizedSNBatch(QtyToCreateInt,CreateLotNo,CustomizedSN,Increment);
        end;
        CalculateSums;
    end;

    local procedure CreateCustomizedSNBatch(QtyToCreate: Decimal;CreateLotNo: Boolean;CustomizedSN: Code[20];Increment: Integer)
    var
        TextManagement: Codeunit "Filter Tokens";
        i: Integer;
        Counter: Integer;
    begin
        TextManagement.EvaluateIncStr(CustomizedSN,CustomizedSN);
        NoSeriesMgt.TestManual(Item."Serial Nos.");

        if QtyToCreate <= 0 then
          Error(Text009);
        if QtyToCreate MOD 1 <> 0 then
          Error(Text008);

        if CreateLotNo then begin
          TestField("Lot No.",'');
          Item.TestField("Lot Nos.");
          Validate("Lot No.",NoSeriesMgt.GetNextNo(Item."Lot Nos.",WorkDate,true));
        end;

        for i := 1 to QtyToCreate do begin
          Validate("Quantity Handled (Base)",0);
          Validate("Quantity Invoiced (Base)",0);
          Validate("Serial No.",CustomizedSN);
          Validate("Quantity (Base)",QtySignFactor);
          "Entry No." := NextEntryNo;
          if TestTempSpecificationExists then
            Error('');
          Insert;
          TempItemTrackLineInsert.TransferFields(Rec);
          TempItemTrackLineInsert.Insert;
          ItemTrackingDataCollection.UpdateLotSNDataSetWithChange(
            TempItemTrackLineInsert,CurrentSignFactor * SourceQuantityArray[1] < 0,CurrentSignFactor,0);
          if i < QtyToCreate then begin
            Counter := Increment;
            repeat
              CustomizedSN := IncStr(CustomizedSN);
              Counter := Counter - 1;
            until Counter <= 0;
          end;
        end;
        CalculateSums;
    end;

    local procedure TestTempSpecificationExists() Exists: Boolean
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        TrackingSpecification.Copy(Rec);
        SetCurrentkey("Lot No.","Serial No.");
        SetRange("Serial No.","Serial No.");
        if "Serial No." = '' then
          SetRange("Lot No.","Lot No.");
        SetFilter("Entry No.",'<>%1',"Entry No.");
        SetRange("Buffer Status",0);
        Exists := not IsEmpty;
        Copy(TrackingSpecification);
        if Exists and CurrentFormIsOpen then
          if "Serial No." = '' then
            Message(
              Text011,
              "Serial No.",
              "Lot No.")
          else
            Message(
              Text012,
              "Serial No.");
    end;

    local procedure QtySignFactor(): Integer
    begin
        if SourceQuantityArray[1] < 0 then
          exit(-1);

        exit(1)
    end;


    procedure RegisterItemTrackingLines(SourceSpecification: Record "Tracking Specification";AvailabilityDate: Date;var TempSpecification: Record "Tracking Specification" temporary)
    begin
        SourceSpecification.TestField("Source Type"); // Check if source has been set.
        if not CalledFromSynchWhseItemTrkg then
          TempSpecification.Reset;
        if not TempSpecification.Find('-') then
          exit;

        IsCorrection := SourceSpecification.Correction;
        ExcludePostedEntries := true;
        SetSourceSpec(SourceSpecification,AvailabilityDate);
        Reset;
        SetCurrentkey("Lot No.","Serial No.");

        repeat
          SetRange("Lot No.",TempSpecification."Lot No.");
          SetRange("Serial No.",TempSpecification."Serial No.");
          if Find('-') then begin
            if IsCorrection then begin
              "Quantity (Base)" :=
                "Quantity (Base)" + TempSpecification."Quantity (Base)";
              "Qty. to Handle (Base)" :=
                "Qty. to Handle (Base)" + TempSpecification."Qty. to Handle (Base)";
              "Qty. to Invoice (Base)" :=
                "Qty. to Invoice (Base)" + TempSpecification."Qty. to Invoice (Base)";
            end else
              Validate("Quantity (Base)",
                "Quantity (Base)" + TempSpecification."Quantity (Base)");
            Modify;
          end else begin
            TransferFields(SourceSpecification);
            "Serial No." := TempSpecification."Serial No.";
            "Lot No." := TempSpecification."Lot No.";
            "Warranty Date" := TempSpecification."Warranty Date";
            "Expiration Date" := TempSpecification."Expiration Date";
            if FormRunMode = Formrunmode::Reclass then begin
              "New Serial No." := TempSpecification."New Serial No.";
              "New Lot No." := TempSpecification."New Lot No.";
              "New Expiration Date" := TempSpecification."New Expiration Date"
            end;
            Validate("Quantity (Base)",TempSpecification."Quantity (Base)");
            "Entry No." := NextEntryNo;
            Insert;
          end;
        until TempSpecification.Next = 0;
        Reset;
        if Find('-') then
          repeat
            CheckLine(Rec);
          until Next = 0;

        SetRange("Lot No.",SourceSpecification."Lot No.");
        SetRange("Serial No.",SourceSpecification."Serial No.");

        CalculateSums;
        if UpdateUndefinedQty then
          WriteToDatabase
        else
          Error(Text014,TotalItemTrackingLine."Quantity (Base)",
            Lowercase(TempReservEntry.TextCaption),SourceQuantityArray[1]);

        // Copy to inbound part of transfer
        if FormRunMode = Formrunmode::Transfer then
          SynchronizeLinkedSources('');
    end;

    local procedure SynchronizeLinkedSources(DialogText: Text[250]): Boolean
    begin
        if CurrentSourceRowID = '' then
          exit(false);
        if SecondSourceRowID = '' then
          exit(false);

        ItemTrackingMgt.SynchronizeItemTracking(CurrentSourceRowID,SecondSourceRowID,DialogText);
        exit(true);
    end;


    procedure SetBlockCommit(NewBlockCommit: Boolean)
    begin
        BlockCommit := NewBlockCommit;
    end;


    procedure SetCalledFromSynchWhseItemTrkg(CalledFromSynchWhseItemTrkg2: Boolean)
    begin
        CalledFromSynchWhseItemTrkg := CalledFromSynchWhseItemTrkg2;
    end;

    local procedure UpdateExpDateColor()
    begin
        if ("Buffer Status2" = "buffer status2"::"ExpDate blocked") or (CurrentSignFactor < 0) then;
    end;

    local procedure UpdateExpDateEditable()
    begin
        ExpirationDateEditable :=
          not (("Buffer Status2" = "buffer status2"::"ExpDate blocked") or (CurrentSignFactor < 0));
    end;

    local procedure LookupAvailable(LookupMode: Option "Serial No.","Lot No.")
    begin
        "Bin Code" := ForBinCode;
        ItemTrackingDataCollection.LookupLotSerialNoAvailability(Rec,LookupMode);
        "Bin Code" := '';
        CurrPage.Update;
    end;

    local procedure LotSnAvailable(var TrackingSpecification: Record "Tracking Specification";LookupMode: Option "Serial No.","Lot No."): Boolean
    begin
        exit(ItemTrackingDataCollection.LotSNAvailable(TrackingSpecification,LookupMode));
    end;

    local procedure SelectEntries()
    var
        xTrackingSpec: Record "Tracking Specification";
        MaxQuantity: Decimal;
    begin
        xTrackingSpec.CopyFilters(Rec);
        MaxQuantity := UndefinedQtyArray[1];
        if MaxQuantity * CurrentSignFactor > 0 then
          MaxQuantity := 0;
        "Bin Code" := ForBinCode;
        ItemTrackingDataCollection.SelectMultipleLotSerialNo(Rec,MaxQuantity,CurrentSignFactor);
        "Bin Code" := '';
        if FindSet then
          repeat
            case "Buffer Status" of
              "buffer status"::Modify:
                begin
                  if TempItemTrackLineModify.Get("Entry No.") then
                    TempItemTrackLineModify.Delete;
                  if TempItemTrackLineInsert.Get("Entry No.") then begin
                    TempItemTrackLineInsert.TransferFields(Rec);
                    TempItemTrackLineInsert.Modify;
                  end else begin
                    TempItemTrackLineModify.TransferFields(Rec);
                    TempItemTrackLineModify.Insert;
                  end;
                end;
              "buffer status"::Insert:
                begin
                  TempItemTrackLineInsert.TransferFields(Rec);
                  TempItemTrackLineInsert.Insert;
                end;
            end;
            "Buffer Status" := 0;
            Modify;
          until Next = 0;
        LastEntryNo := "Entry No.";
        CalculateSums;
        UpdateUndefinedQtyArray;
        CopyFilters(xTrackingSpec);
        CurrPage.Update(false);
    end;

    local procedure ReestablishReservations()
    var
        LateBindingMgt: Codeunit "Late Binding Management";
    begin
        if TempItemTrackLineReserv.FindSet then
          repeat
            LateBindingMgt.ReserveItemTrackingLine2(TempItemTrackLineReserv,0,TempItemTrackLineReserv."Quantity (Base)");
            SetQtyToHandleAndInvoice(TempItemTrackLineReserv);
          until TempItemTrackLineReserv.Next = 0;
        TempItemTrackLineReserv.DeleteAll;
    end;


    procedure SetInbound(NewInbound: Boolean)
    begin
        InboundIsSet := true;
        Inbound := NewInbound;
    end;


    procedure SetPick(IsPick2: Boolean)
    begin
        IsPick := IsPick2;
    end;

    local procedure SerialNoOnAfterValidate()
    begin
        UpdateExpDateEditable;
        CurrPage.Update;
    end;

    local procedure LotNoOnAfterValidate()
    begin
        UpdateExpDateEditable;
        CurrPage.Update;
    end;

    local procedure QuantityBaseOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QuantityBaseOnValidate()
    begin
        CheckLine(Rec);
    end;

    local procedure QtytoHandleBaseOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure QtytoInvoiceBaseOnAfterValidat()
    begin
        CurrPage.Update;
    end;

    local procedure ExpirationDateOnFormat()
    begin
        UpdateExpDateColor;
    end;

    local procedure TempRecValid()
    begin
        if not TempRecIsValid then
          Error(Text007);
    end;

    local procedure GetHandleSource(TrackingSpecification: Record "Tracking Specification"): Boolean
    var
        QtyToHandleColumnIsHidden: Boolean;
    begin
        with TrackingSpecification do begin
          if ("Source Type" = Database::"Item Journal Line") and ("Source Subtype" = 6) then begin // 6 => Prod.order line
            ProdOrderLineHandling := true;
            exit(true);  // Display Handle column for prod. orders
          end;
          QtyToHandleColumnIsHidden :=
            ("Source Type" in
             [Database::"Item Ledger Entry",
              Database::"Item Journal Line",
              Database::"Job Journal Line",
              Database::"Requisition Line"]) or
            (("Source Type" in [Database::"Sales Line",Database::"Purchase Line",Database::"Service Line"]) and
             ("Source Subtype" in [0,2,3])) or
            (("Source Type" = Database::"Assembly Line") and ("Source Subtype" = 0));
        end;
        exit(not QtyToHandleColumnIsHidden);
    end;

    local procedure GetInvoiceSource(TrackingSpecification: Record "Tracking Specification"): Boolean
    var
        QtyToInvoiceColumnIsHidden: Boolean;
    begin
        with TrackingSpecification do begin
          QtyToInvoiceColumnIsHidden :=
            ("Source Type" in
             [Database::"Item Ledger Entry",
              Database::"Item Journal Line",
              Database::"Job Journal Line",
              Database::"Requisition Line",
              Database::"Transfer Line",
              Database::"Assembly Line",
              Database::"Assembly Header",
              Database::"Prod. Order Line",
              Database::"Prod. Order Component"]) or
            (("Source Type" in [Database::"Sales Line",Database::"Purchase Line",Database::"Service Line"]) and
             ("Source Subtype" in [0,2,3,4]))
        end;
        exit(not QtyToInvoiceColumnIsHidden);
    end;


    procedure SetSecondSourceID(SourceID: Integer;IsATO: Boolean)
    begin
        SecondSourceID := SourceID;
        IsAssembleToOrder := IsATO;
    end;

    local procedure SynchronizeWarehouseItemTracking()
    var
        WarehouseShipmentLine: Record "Warehouse Shipment Line";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
    begin
        if ItemTrackingMgt.ItemTrkgIsManagedByWhse(
             "Source Type","Source Subtype","Source ID",
             "Source Prod. Order Line","Source Ref. No.","Location Code","Item No.")
        then
          exit;

        WarehouseShipmentLine.SetRange("Source Type","Source Type");
        WarehouseShipmentLine.SetRange("Source Subtype","Source Subtype");
        WarehouseShipmentLine.SetRange("Source No.","Source ID");
        WarehouseShipmentLine.SetRange("Source Line No.","Source Ref. No.");
        if WarehouseShipmentLine.FindSet then
          repeat
            DeleteWhseItemTracking(WarehouseShipmentLine);
            WarehouseShipmentLine.CreateWhseItemTrackingLines;
          until WarehouseShipmentLine.Next = 0;
    end;

    local procedure DeleteWhseItemTracking(WarehouseShipmentLine: Record "Warehouse Shipment Line")
    var
        WhseItemTrackingLine: Record "Whse. Item Tracking Line";
    begin
        WhseItemTrackingLine.SetRange("Source Type",Database::"Warehouse Shipment Line");
        WhseItemTrackingLine.SetRange("Source ID",WarehouseShipmentLine."No.");
        WhseItemTrackingLine.SetRange("Source Ref. No.",WarehouseShipmentLine."Line No.");
        WhseItemTrackingLine.DeleteAll(true);
    end;
}

