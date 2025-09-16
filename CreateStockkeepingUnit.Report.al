#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5706 "Create Stockkeeping Unit"
{
    Caption = 'Create Stockkeeping Unit';
    ProcessingOnly = true;
    UsageCategory = Administration;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Inventory Posting Group","Location Filter","Variant Filter";
            column(ReportForNavId_8129; 8129)
            {
            }

            trigger OnAfterGetRecord()
            var
                ItemVariant: Record "Item Variant";
            begin
                if SaveFilters then begin
                  LocationFilter := GetFilter("Location Filter");
                  VariantFilter := GetFilter("Variant Filter");
                  SaveFilters := false;
                end;
                SetFilter("Location Filter",LocationFilter);
                SetFilter("Variant Filter",VariantFilter);

                Location.SetFilter(Code,GetFilter("Location Filter"));

                if ReplacePreviousSKUs then begin
                  StockkeepingUnit.Reset;
                  StockkeepingUnit.SetRange("Item No.","No.");
                  if GetFilter("Variant Filter") <> '' then
                    StockkeepingUnit.SetFilter("Variant Code",GetFilter("Variant Filter"));
                  if GetFilter("Location Filter") <> '' then
                    StockkeepingUnit.SetFilter("Location Code",GetFilter("Location Filter"));
                  StockkeepingUnit.DeleteAll;
                end;

                DialogWindow.Update(1,"No.");
                ItemVariant.SetRange("Item No.","No.");
                ItemVariant.SetFilter(Code,GetFilter("Variant Filter"));
                case true of
                  (SKUCreationMethod = Skucreationmethod::Location) or
                  ((SKUCreationMethod = Skucreationmethod::"Location & Variant") and
                   (not ItemVariant.Find('-'))):
                    begin
                      if Location.Find('-') then
                        repeat
                          DialogWindow.Update(2,Location.Code);
                          SetRange("Location Filter",Location.Code);
                          CreateSKU(Item,Location.Code,'');
                        until Location.Next = 0;
                    end;
                  (SKUCreationMethod = Skucreationmethod::Variant) or
                  ((SKUCreationMethod = Skucreationmethod::"Location & Variant") and
                   (not Location.Find('-'))):
                    begin
                      if ItemVariant.Find('-') then
                        repeat
                          DialogWindow.Update(3,ItemVariant.Code);
                          SetRange("Variant Filter",ItemVariant.Code);
                          CreateSKU(Item,'',ItemVariant.Code);
                        until ItemVariant.Next = 0;
                    end;
                  (SKUCreationMethod = Skucreationmethod::"Location & Variant"):
                    begin
                      if Location.Find('-') then
                        repeat
                          DialogWindow.Update(2,Location.Code);
                          SetRange("Location Filter",Location.Code);
                          if ItemVariant.Find('-') then
                            repeat
                              DialogWindow.Update(3,ItemVariant.Code);
                              SetRange("Variant Filter",ItemVariant.Code);
                              CreateSKU(Item,Location.Code,ItemVariant.Code);
                            until ItemVariant.Next = 0;
                        until Location.Next = 0;
                    end;
                end;
            end;

            trigger OnPostDataItem()
            begin
                DialogWindow.Close;
            end;

            trigger OnPreDataItem()
            begin
                Location.SetRange("Use As In-Transit",false);

                DialogWindow.Open(
                  Text000 +
                  Text001 +
                  Text002);

                SaveFilters := true;
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
                    field(SKUCreationMethod;SKUCreationMethod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create Per';
                        OptionCaption = 'Location,Variant,Location & Variant';
                    }
                    field(ItemInInventoryOnly;ItemInInventoryOnly)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item In Inventory Only';
                    }
                    field(ReplacePreviousSKUs;ReplacePreviousSKUs)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Replace Previous SKUs';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ReplacePreviousSKUs := false;
        end;
    }

    labels
    {
    }

    var
        Text000: label 'Item No.       #1##################\';
        Text001: label 'Location Code  #2########\';
        Text002: label 'Variant Code   #3########\';
        StockkeepingUnit: Record "Stockkeeping Unit";
        Location: Record Location;
        DialogWindow: Dialog;
        SKUCreationMethod: Option Location,Variant,"Location & Variant";
        ItemInInventoryOnly: Boolean;
        ReplacePreviousSKUs: Boolean;
        SaveFilters: Boolean;
        LocationFilter: Code[1024];
        VariantFilter: Code[1024];

    local procedure CreateSKU(var Item2: Record Item;LocationCode: Code[10];VariantCode: Code[10])
    begin
        Item2.CalcFields(Inventory);
        if (ItemInInventoryOnly and (Item2.Inventory > 0)) or
           (not ItemInInventoryOnly)
        then
          if not StockkeepingUnit.Get(LocationCode,Item2."No.",VariantCode) then begin
            StockkeepingUnit.Init;
            StockkeepingUnit."Item No." := Item2."No.";
            StockkeepingUnit."Location Code" := LocationCode;
            StockkeepingUnit."Variant Code" := VariantCode;
            StockkeepingUnit."Shelf No." := Item2."Shelf No.";
            StockkeepingUnit."Standard Cost" := Item2."Standard Cost";
            StockkeepingUnit."Last Direct Cost" := Item2."Last Direct Cost";
            StockkeepingUnit."Unit Cost" := Item2."Unit Cost";
            StockkeepingUnit."Vendor No." := Item2."Vendor No.";
            StockkeepingUnit."Vendor Item No." := Item2."Vendor Item No.";
            StockkeepingUnit."Lead Time Calculation" := Item2."Lead Time Calculation";
            StockkeepingUnit."Reorder Point" := Item2."Reorder Point";
            StockkeepingUnit."Maximum Inventory" := Item2."Maximum Inventory";
            StockkeepingUnit."Reorder Quantity" := Item2."Reorder Quantity";
            StockkeepingUnit."Lot Size" := Item2."Lot Size";
            StockkeepingUnit."Reordering Policy" := Item2."Reordering Policy";
            StockkeepingUnit."Include Inventory" := Item2."Include Inventory";
            StockkeepingUnit."Assembly Policy" := Item2."Assembly Policy";
            StockkeepingUnit."Manufacturing Policy" := Item2."Manufacturing Policy";
            StockkeepingUnit."Discrete Order Quantity" := Item2."Discrete Order Quantity";
            StockkeepingUnit."Minimum Order Quantity" := Item2."Minimum Order Quantity";
            StockkeepingUnit."Maximum Order Quantity" := Item2."Maximum Order Quantity";
            StockkeepingUnit."Safety Stock Quantity" := Item2."Safety Stock Quantity";
            StockkeepingUnit."Order Multiple" := Item2."Order Multiple";
            StockkeepingUnit."Safety Lead Time" := Item2."Safety Lead Time";
            StockkeepingUnit."Flushing Method" := Item2."Flushing Method";
            StockkeepingUnit."Replenishment System" := Item2."Replenishment System";
            StockkeepingUnit."Time Bucket" := Item2."Time Bucket";
            StockkeepingUnit."Rescheduling Period" := Item2."Rescheduling Period";
            StockkeepingUnit."Lot Accumulation Period" := Item2."Lot Accumulation Period";
            StockkeepingUnit."Dampener Period" := Item2."Dampener Period";
            StockkeepingUnit."Dampener Quantity" := Item2."Dampener Quantity";
            StockkeepingUnit."Overflow Level" := Item2."Overflow Level";
            StockkeepingUnit."Last Date Modified" := WorkDate;
            StockkeepingUnit."Special Equipment Code" := Item2."Special Equipment Code";
            StockkeepingUnit."Put-away Template Code" := Item2."Put-away Template Code";
            StockkeepingUnit."Phys Invt Counting Period Code" :=
              Item2."Phys Invt Counting Period Code";
            StockkeepingUnit."Put-away Unit of Measure Code" :=
              Item2."Put-away Unit of Measure Code";
            StockkeepingUnit."Use Cross-Docking" := Item2."Use Cross-Docking";
            StockkeepingUnit.Insert(true);
          end;
    end;


    procedure InitializeRequest(CreatePerOption: Option Location,Variant,"Location & Variant";NewItemInInventoryOnly: Boolean;NewReplacePreviousSKUs: Boolean)
    begin
        SKUCreationMethod := CreatePerOption;
        ItemInInventoryOnly := NewItemInInventoryOnly;
        ReplacePreviousSKUs := NewReplacePreviousSKUs;
    end;
}

