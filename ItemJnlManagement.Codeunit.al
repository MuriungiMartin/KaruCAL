#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 240 ItemJnlManagement
{
    Permissions = TableData "Item Journal Template"=imd,
                  TableData "Item Journal Batch"=imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label '%1 journal';
        Text001: label 'RECURRING';
        Text002: label 'Recurring Item Journal';
        Text003: label 'DEFAULT';
        Text004: label 'Default Journal';
        OldItemNo: Code[20];
        OldCapNo: Code[20];
        OldCapType: Option "Work Center","Machine Center";
        OldProdOrderNo: Code[20];
        OldOperationNo: Code[20];
        Text005: label 'REC-';
        Text006: label 'Recurring ';
        OpenFromBatch: Boolean;


    procedure TemplateSelection(PageID: Integer;PageTemplate: Option Item,Transfer,"Phys. Inventory",Revaluation,Consumption,Output,Capacity,"Prod. Order";RecurringJnl: Boolean;var ItemJnlLine: Record "Item Journal Line";var JnlSelected: Boolean)
    var
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        JnlSelected := true;

        ItemJnlTemplate.Reset;
        ItemJnlTemplate.SetRange("Page ID",PageID);
        ItemJnlTemplate.SetRange(Recurring,RecurringJnl);
        ItemJnlTemplate.SetRange(Type,PageTemplate);

        case ItemJnlTemplate.Count of
          0:
            begin
              ItemJnlTemplate.Init;
              ItemJnlTemplate.Recurring := RecurringJnl;
              ItemJnlTemplate.Validate(Type,PageTemplate);
              ItemJnlTemplate.Validate("Page ID");
              if not RecurringJnl then begin
                ItemJnlTemplate.Name := Format(ItemJnlTemplate.Type,MaxStrLen(ItemJnlTemplate.Name));
                ItemJnlTemplate.Description := StrSubstNo(Text000,ItemJnlTemplate.Type);
              end else
                if ItemJnlTemplate.Type = ItemJnlTemplate.Type::Item then begin
                  ItemJnlTemplate.Name := Text001;
                  ItemJnlTemplate.Description := Text002;
                end else begin
                  ItemJnlTemplate.Name :=
                    Text005 + Format(ItemJnlTemplate.Type,MaxStrLen(ItemJnlTemplate.Name) - StrLen(Text005));
                  ItemJnlTemplate.Description := Text006 + StrSubstNo(Text000,ItemJnlTemplate.Type);
                end;
              ItemJnlTemplate.Insert;
              Commit;
            end;
          1:
            ItemJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,ItemJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
          ItemJnlLine.FilterGroup := 2;
          ItemJnlLine.SetRange("Journal Template Name",ItemJnlTemplate.Name);
          ItemJnlLine.FilterGroup := 0;
          if OpenFromBatch then begin
            ItemJnlLine."Journal Template Name" := '';
            Page.Run(ItemJnlTemplate."Page ID",ItemJnlLine);
          end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var ItemJnlBatch: Record "Item Journal Batch")
    var
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlTemplate: Record "Item Journal Template";
    begin
        OpenFromBatch := true;
        ItemJnlTemplate.Get(ItemJnlBatch."Journal Template Name");
        ItemJnlTemplate.TestField("Page ID");
        ItemJnlBatch.TestField(Name);

        ItemJnlLine.FilterGroup := 2;
        ItemJnlLine.SetRange("Journal Template Name",ItemJnlTemplate.Name);
        ItemJnlLine.FilterGroup := 0;

        ItemJnlLine."Journal Template Name" := '';
        ItemJnlLine."Journal Batch Name" := ItemJnlBatch.Name;
        Page.Run(ItemJnlTemplate."Page ID",ItemJnlLine);
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10];var ItemJnlLine: Record "Item Journal Line")
    begin
        CheckTemplateName(ItemJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
        ItemJnlLine.FilterGroup := 2;
        ItemJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        ItemJnlLine.FilterGroup := 0;
    end;


    procedure OpenJnlBatch(var ItemJnlBatch: Record "Item Journal Batch")
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        JnlSelected: Boolean;
    begin
        if ItemJnlBatch.GetFilter("Journal Template Name") <> '' then
          exit;
        ItemJnlBatch.FilterGroup(2);
        if ItemJnlBatch.GetFilter("Journal Template Name") <> '' then begin
          ItemJnlBatch.FilterGroup(0);
          exit;
        end;
        ItemJnlBatch.FilterGroup(0);

        if not ItemJnlBatch.Find('-') then
          for ItemJnlTemplate.Type := ItemJnlTemplate.Type::Item to ItemJnlTemplate.Type::"Prod. Order" do begin
            ItemJnlTemplate.SetRange(Type,ItemJnlTemplate.Type);
            if not ItemJnlTemplate.FindFirst then
              TemplateSelection(0,ItemJnlTemplate.Type,false,ItemJnlLine,JnlSelected);
            if ItemJnlTemplate.FindFirst then
              CheckTemplateName(ItemJnlTemplate.Name,ItemJnlBatch.Name);
            if ItemJnlTemplate.Type in [ItemJnlTemplate.Type::Item,
                                        ItemJnlTemplate.Type::Consumption,
                                        ItemJnlTemplate.Type::Output,
                                        ItemJnlTemplate.Type::Capacity]
            then begin
              ItemJnlTemplate.SetRange(Recurring,true);
              if not ItemJnlTemplate.FindFirst then
                TemplateSelection(0,ItemJnlTemplate.Type,true,ItemJnlLine,JnlSelected);
              if ItemJnlTemplate.FindFirst then
                CheckTemplateName(ItemJnlTemplate.Name,ItemJnlBatch.Name);
              ItemJnlTemplate.SetRange(Recurring);
            end;
          end;

        ItemJnlBatch.Find('-');
        JnlSelected := true;
        ItemJnlBatch.CalcFields("Template Type",Recurring);
        ItemJnlTemplate.SetRange(Recurring,ItemJnlBatch.Recurring);
        if not ItemJnlBatch.Recurring then
          ItemJnlTemplate.SetRange(Type,ItemJnlBatch."Template Type");
        if ItemJnlBatch.GetFilter("Journal Template Name") <> '' then
          ItemJnlTemplate.SetRange(Name,ItemJnlBatch.GetFilter("Journal Template Name"));
        case ItemJnlTemplate.Count of
          1:
            ItemJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,ItemJnlTemplate) = Action::LookupOK;
        end;
        if not JnlSelected then
          Error('');

        ItemJnlBatch.FilterGroup(2);
        ItemJnlBatch.SetRange("Journal Template Name",ItemJnlTemplate.Name);
        ItemJnlBatch.FilterGroup(0);
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10];var CurrentJnlBatchName: Code[10])
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.SetRange("Journal Template Name",CurrentJnlTemplateName);
        if not ItemJnlBatch.Get(CurrentJnlTemplateName,CurrentJnlBatchName) then begin
          if not ItemJnlBatch.FindFirst then begin
            ItemJnlBatch.Init;
            ItemJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
            ItemJnlBatch.SetupNewBatch;
            ItemJnlBatch.Name := Text003;
            ItemJnlBatch.Description := Text004;
            ItemJnlBatch.Insert(true);
            Commit;
          end;
          CurrentJnlBatchName := ItemJnlBatch.Name
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10];var ItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Get(ItemJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10];var ItemJnlLine: Record "Item Journal Line")
    begin
        ItemJnlLine.FilterGroup := 2;
        ItemJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        ItemJnlLine.FilterGroup := 0;
        if ItemJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10];var ItemJnlLine: Record "Item Journal Line")
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        Commit;
        ItemJnlBatch."Journal Template Name" := ItemJnlLine.GetRangemax("Journal Template Name");
        ItemJnlBatch.Name := ItemJnlLine.GetRangemax("Journal Batch Name");
        ItemJnlBatch.FilterGroup(2);
        ItemJnlBatch.SetRange("Journal Template Name",ItemJnlBatch."Journal Template Name");
        ItemJnlBatch.FilterGroup(0);
        if Page.RunModal(0,ItemJnlBatch) = Action::LookupOK then begin
          CurrentJnlBatchName := ItemJnlBatch.Name;
          SetName(CurrentJnlBatchName,ItemJnlLine);
        end;
    end;


    procedure GetItem(ItemNo: Code[20];var ItemDescription: Text[50])
    var
        Item: Record Item;
    begin
        if ItemNo <> OldItemNo then begin
          ItemDescription := '';
          if ItemNo <> '' then
            if Item.Get(ItemNo) then
              ItemDescription := Item.Description;
          OldItemNo := ItemNo;
        end;
    end;


    procedure GetConsump(var ItemJnlLine: Record "Item Journal Line";var ProdOrderDescription: Text[50])
    var
        ProdOrder: Record "Production Order";
    begin
        if (ItemJnlLine."Order Type" = ItemJnlLine."order type"::Production) and (ItemJnlLine."Order No." <> OldProdOrderNo) then begin
          ProdOrderDescription := '';
          if ProdOrder.Get(ProdOrder.Status::Released,ItemJnlLine."Order No.") then
            ProdOrderDescription := ProdOrder.Description;
          OldProdOrderNo := ProdOrder."No.";
        end;
    end;


    procedure GetOutput(var ItemJnlLine: Record "Item Journal Line";var ProdOrderDescription: Text[50];var OperationDescription: Text[50])
    var
        ProdOrder: Record "Production Order";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
    begin
        if (ItemJnlLine."Operation No." <> OldOperationNo) or
           ((ItemJnlLine."Order Type" = ItemJnlLine."order type"::Production) and (ItemJnlLine."Order No." <> OldProdOrderNo))
        then begin
          OperationDescription := '';
          if ProdOrderRtngLine.Get(
               ProdOrder.Status::Released,
               ItemJnlLine."Order No.",
               ItemJnlLine."Routing Reference No.",
               ItemJnlLine."Routing No.",
               ItemJnlLine."Operation No.")
          then
            OperationDescription := ProdOrderRtngLine.Description;
          OldOperationNo := ProdOrderRtngLine."Operation No.";
        end;

        if (ItemJnlLine."Order Type" = ItemJnlLine."order type"::Production) and (ItemJnlLine."Order No." <> OldProdOrderNo) then begin
          ProdOrderDescription := '';
          if ProdOrder.Get(ProdOrder.Status::Released,ItemJnlLine."Order No.") then
            ProdOrderDescription := ProdOrder.Description;
          OldProdOrderNo := ProdOrder."No.";
        end;
    end;


    procedure GetCapacity(CapType: Option "Work Center","Machine Center";CapNo: Code[20];var CapDescription: Text[50])
    var
        WorkCenter: Record "Work Center";
        MachineCenter: Record "Machine Center";
    begin
        if (CapNo <> OldCapNo) or (CapType <> OldCapType) then begin
          CapDescription := '';
          if CapNo <> '' then
            case CapType of
              Captype::"Work Center":
                if WorkCenter.Get(CapNo) then
                  CapDescription := WorkCenter.Name;
              Captype::"Machine Center":
                if MachineCenter.Get(CapNo) then
                  CapDescription := MachineCenter.Name;
            end;
          OldCapNo := CapNo;
          OldCapType := CapType;
        end;
    end;
}

