#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5757 "Check on Negative Inventory"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Check on Negative Inventory.rdlc';
    Caption = 'Check on Negative Inventory';

    dataset
    {
        dataitem(Output;"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_1743; 1743)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(LocationCode;StrSubstNo('%1: %2',ItemLedgEntry.FieldCaption("Location Code"),LocCode))
            {
            }
            column(ItemLedgEntryBufferItemNo;ItemLedgEntryBuffer."Item No.")
            {
            }
            column(ItemLedgEntryBufferRemainQty;ItemLedgEntryBuffer."Remaining Quantity")
            {
                DecimalPlaces = 0:5;
            }
            column(ItemLedgEntryBufferLotNo;ItemLedgEntryBuffer."Lot No.")
            {
            }
            column(ItemLedgEntryBufferSerialNo;ItemLedgEntryBuffer."Serial No.")
            {
            }
            column(ItemLedgEntryBufferUOMCode;ItemLedgEntryBuffer."Unit of Measure Code")
            {
            }
            column(ItemLedgEntryBufferDesc;ItemLedgEntryBuffer.Description)
            {
            }
            column(ItemLedgEntryBufferVariantCode;ItemLedgEntryBuffer."Variant Code")
            {
            }
            column(Check_on_Negative_InventoryCaption;Check_on_Negative_InventoryCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ItemLedgEntryBufferRemainQtyCaption;ItemLedgEntryBufferRemainQtyCaptionLbl)
            {
            }
            column(ItemLedgEntryBufferLotNoCaption;ItemLedgEntryBufferLotNoCaptionLbl)
            {
            }
            column(ItemLedgEntryBufferSerialNoCaption;ItemLedgEntryBufferSerialNoCaptionLbl)
            {
            }
            column(ItemLedgEntryBufferUOMCodeCaption;ItemLedgEntryBufferUOMCodeCaptionLbl)
            {
            }
            column(ItemLedgEntryBufferDescCaption;ItemLedgEntryBufferDescCaptionLbl)
            {
            }
            column(ItemLedgEntryBufferVariantCodeCaption;ItemLedgEntryBufferVariantCodeCaptionLbl)
            {
            }
            column(ItemLedgEntryBufferItemNoCaption;ItemLedgEntryBufferItemNoCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ILECounter = 0 then
                  ItemLedgEntryBuffer.Description := Text004
                else begin
                  if Number = 1 then
                    ItemLedgEntryBuffer.Find('-')
                  else
                    ItemLedgEntryBuffer.Next;

                  if ItemLedgEntryBuffer.Description = '' then
                    if ItemLedgEntryBuffer."Variant Code" <> '' then begin
                      ItemVariant.Get(ItemLedgEntryBuffer."Item No.",ItemLedgEntryBuffer."Variant Code");
                      ItemLedgEntryBuffer.Description := ItemVariant.Description;
                    end else begin
                      Item.Get(ItemLedgEntryBuffer."Item No.");
                      ItemLedgEntryBuffer.Description := Item.Description;
                    end
                end;
            end;

            trigger OnPreDataItem()
            begin
                ItemLedgEntryBuffer.SetCurrentkey(
                  "Item No.","Location Code",Open,"Variant Code","Unit of Measure Code","Lot No.","Serial No.");

                ILECounter := ItemLedgEntryBuffer.Count;
                if ILECounter = 0 then
                  SetRange(Number,1)
                else
                  SetRange(Number,1,ILECounter);
            end;
        }
        dataitem(ErrorLoop;"Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_1162; 1162)
            {
            }
            column(ErrorTextNumber;ErrorText[Number])
            {
            }
            column(ErrorTextNumberCaption;ErrorTextNumberCaptionLbl)
            {
            }

            trigger OnPostDataItem()
            begin
                ErrorCounter := 0;
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number,1,ErrorCounter);
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
                    field(LocationCode;LocCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            Clear(Location);
                            if LocCode <> '' then
                              Location.Code := LocCode;
                            if Page.RunModal(0,Location) = Action::LookupOK then
                              LocCode := Location.Code;
                        end;

                        trigger OnValidate()
                        begin
                            Location.Get(LocCode);
                        end;
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if LocCode = '' then
          Error(Text001);

        with ItemLedgEntry do begin
          SetCurrentkey(
            "Item No.","Location Code",Open,"Variant Code","Unit of Measure Code","Lot No.","Serial No.");

          if Find('-') then begin
            Window.Open(StrSubstNo(Text002,FieldCaption("Location Code"),LocCode) + Text003);
            i := 1;
            ILECounter := Count;
            repeat
              Window.Update(100,i);
              Window.Update(102,ROUND(i / ILECounter * 10000,1));

              SetRange("Item No.","Item No.");
              if Find('-') then begin
                SetRange("Location Code",LocCode);
                SetRange(Open,true);
                if Find('-') then
                  repeat
                    SetRange("Variant Code","Variant Code");
                    if Find('-') then
                      repeat
                        SetRange("Unit of Measure Code","Unit of Measure Code");
                        if Find('-') then
                          repeat
                            SetRange("Lot No.","Lot No.");
                            if Find('-') then
                              repeat
                                SetRange("Serial No.","Serial No.");

                                CalcSums("Remaining Quantity");

                                if "Remaining Quantity" < 0 then
                                  FillBuffer;

                                Find('+');
                                SetRange("Serial No.");
                              until Next = 0;

                            Find('+');
                            SetRange("Lot No.");
                          until Next = 0;

                        Find('+');
                        SetRange("Unit of Measure Code")
                      until Next = 0;

                    Find('+');
                    SetRange("Variant Code");
                  until Next = 0;
              end;

              SetRange(Open);
              SetRange("Location Code");
              Find('+');
              i := i + Count;
              SetRange("Item No.");
            until Next = 0;

            Window.Close;
          end;
        end;

        ErrorCounter := 0;
        WhseRcptHeader.SetCurrentkey("Location Code");
        WhseRcptHeader.SetRange("Location Code",LocCode);
        if WhseRcptHeader.FindFirst then
          AddError(
            StrSubstNo(
              Text005,
              WhseRcptHeader.TableCaption,
              WhseRcptHeader.FieldCaption("Location Code"),
              LocCode));

        WhseShipHeader.SetCurrentkey("Location Code");
        WhseShipHeader.SetRange("Location Code",LocCode);
        if WhseShipHeader.FindFirst then
          AddError(
            StrSubstNo(
              Text005,
              WhseShipHeader.TableCaption,
              WhseShipHeader.FieldCaption("Location Code"),
              LocCode));

        for i := 1 to 2 do begin
          WhseActHeader.SetCurrentkey("Location Code");
          WhseActHeader.SetRange("Location Code",LocCode);
          WhseActHeader.SetRange(Type,i);
          if WhseActHeader.FindFirst then
            AddError(
              StrSubstNo(
                Text006,
                WhseActHeader.Type,
                WhseActHeader.FieldCaption("Location Code"),
                LocCode));
        end;

        WhseWkshLine.SetCurrentkey("Item No.","Location Code");
        WhseWkshLine.SetRange("Location Code",LocCode);
        if WhseWkshLine.FindFirst then
          AddError(
            StrSubstNo(
              Text007,
              WhseWkshLine.TableCaption,
              WhseWkshLine.FieldCaption("Location Code"),
              LocCode));
    end;

    var
        Location: Record Location;
        ItemLedgEntry: Record "Item Ledger Entry";
        ItemLedgEntryBuffer: Record "Item Ledger Entry" temporary;
        Item: Record Item;
        ItemVariant: Record "Item Variant";
        WhseRcptHeader: Record "Warehouse Receipt Header";
        WhseShipHeader: Record "Warehouse Shipment Header";
        WhseActHeader: Record "Warehouse Activity Header";
        WhseWkshLine: Record "Whse. Worksheet Line";
        Window: Dialog;
        LocCode: Code[10];
        Text001: label 'Enter a location code.';
        Text002: label 'Checking %1 %2 for negative inventory...\\';
        Text003: label 'Count #100##### @102@@@@@@@@';
        i: Integer;
        ILECounter: Integer;
        Text004: label 'No negative inventory was found.';
        Text005: label 'A %1 exists for %2 %3. It must be either posted or deleted before running the Create Whse. Location batch job.';
        ErrorCounter: Integer;
        ErrorText: array [5] of Text[250];
        Text006: label 'A %1 exists for %2 %3. It must be either registered or deleted before running the Create Whse. Location batch job.';
        Text007: label 'A %1 exists for %2 %3. It must be deleted before running the Create Whse. Location batch job.';
        Check_on_Negative_InventoryCaptionLbl: label 'Check on Negative Inventory';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ItemLedgEntryBufferRemainQtyCaptionLbl: label 'Quantity';
        ItemLedgEntryBufferLotNoCaptionLbl: label 'Lot No.';
        ItemLedgEntryBufferSerialNoCaptionLbl: label 'Serial No.';
        ItemLedgEntryBufferUOMCodeCaptionLbl: label 'Unit of Measure Code';
        ItemLedgEntryBufferDescCaptionLbl: label 'Description';
        ItemLedgEntryBufferVariantCodeCaptionLbl: label 'Variant Code';
        ItemLedgEntryBufferItemNoCaptionLbl: label 'Item No.';
        ErrorTextNumberCaptionLbl: label 'Error!';

    local procedure FillBuffer()
    begin
        ItemLedgEntryBuffer := ItemLedgEntry;
        ItemLedgEntryBuffer.Insert;
    end;

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;


    procedure InitializeRequest(NewLocCode: Code[10])
    begin
        LocCode := NewLocCode;
    end;
}

