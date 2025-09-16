#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7500 "Item Attribute Management"
{

    trigger OnRun()
    begin
    end;

    var
        DeleteAttributesInheritedFromOldCategoryQst: label 'Do you want to delete the attributes that are inherited from item category ''%1''?', Comment='%1 - item category code';
        DeleteItemInheritedParentCategoryAttributesQst: label 'One or more items belong to item category ''''%1'''', which is a child of item category ''''%2''''.\\Do you want to delete the inherited item attributes for the items in question?', Comment='%1 - item category code,%2 - item category code';


    procedure FindItemsByAttribute(var FilterItemAttributesBuffer: Record "Filter Item Attributes Buffer") ItemFilter: Text
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
        AttributeValueIDFilter: Text;
        CurrentItemFilter: Text;
    begin
        if not FilterItemAttributesBuffer.FindSet then
          exit;

        ItemFilter := '<>*';

        ItemAttributeValueMapping.SetRange("Table ID",Database::Item);
        CurrentItemFilter := '*';

        repeat
          ItemAttribute.SetRange(Name,FilterItemAttributesBuffer.Attribute);
          if ItemAttribute.FindFirst then begin
            ItemAttributeValueMapping.SetRange("Item Attribute ID",ItemAttribute.ID);
            AttributeValueIDFilter := GetItemAttributeValueFilter(FilterItemAttributesBuffer,ItemAttribute);
            if AttributeValueIDFilter = '' then
              exit;

            CurrentItemFilter := GetItemNoFilter(ItemAttributeValueMapping,CurrentItemFilter,AttributeValueIDFilter);
            if CurrentItemFilter = '' then
              exit;
          end;
        until FilterItemAttributesBuffer.Next = 0;

        ItemFilter := CurrentItemFilter;
    end;

    local procedure GetItemAttributeValueFilter(var FilterItemAttributesBuffer: Record "Filter Item Attributes Buffer";var ItemAttribute: Record "Item Attribute") AttributeFilter: Text
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        ItemAttributeValue.SetRange("Attribute ID",ItemAttribute.ID);
        ItemAttributeValue.SetValueFilter(ItemAttribute,FilterItemAttributesBuffer.Value);

        if not ItemAttributeValue.FindSet then
          exit;

        repeat
          AttributeFilter += StrSubstNo('%1|',ItemAttributeValue.ID);
        until ItemAttributeValue.Next = 0;

        exit(CopyStr(AttributeFilter,1,StrLen(AttributeFilter) - 1));
    end;

    local procedure GetItemNoFilter(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping";PreviousItemNoFilter: Text;AttributeValueIDFilter: Text) ItemNoFilter: Text
    begin
        ItemAttributeValueMapping.SetFilter("No.",PreviousItemNoFilter);
        ItemAttributeValueMapping.SetFilter("Item Attribute Value ID",AttributeValueIDFilter);

        if not ItemAttributeValueMapping.FindSet then
          exit;

        repeat
          ItemNoFilter += StrSubstNo('%1|',ItemAttributeValueMapping."No.");
        until ItemAttributeValueMapping.Next = 0;

        exit(CopyStr(ItemNoFilter,1,StrLen(ItemNoFilter) - 1));
    end;


    procedure InheritAttributesFromItemCategory(Item: Record Item;NewItemCategoryCode: Code[20];OldItemCategoryCode: Code[20])
    var
        TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary;
        TempItemAttributeValueToDelete: Record "Item Attribute Value" temporary;
    begin
        GenerateAttributesToInsertAndToDelete(
          TempItemAttributeValueToInsert,TempItemAttributeValueToDelete,NewItemCategoryCode,OldItemCategoryCode);

        if not TempItemAttributeValueToDelete.IsEmpty then
          if not GuiAllowed then
            DeleteItemAttributeValueMapping(Item,TempItemAttributeValueToDelete)
          else
            if Confirm(StrSubstNo(DeleteAttributesInheritedFromOldCategoryQst,OldItemCategoryCode)) then
              DeleteItemAttributeValueMapping(Item,TempItemAttributeValueToDelete);

        if not TempItemAttributeValueToInsert.IsEmpty then
          InsertItemAttributeValueMapping(Item,TempItemAttributeValueToInsert);
    end;


    procedure UpdateCategoryAttributesAfterChangingParentCategory(ItemCategoryCode: Code[20];NewParentItemCategory: Code[20];OldParentItemCategory: Code[20])
    var
        TempNewParentItemAttributeValue: Record "Item Attribute Value" temporary;
        TempOldParentItemAttributeValue: Record "Item Attribute Value" temporary;
    begin
        TempNewParentItemAttributeValue.LoadCategoryAttributesFactBoxData(NewParentItemCategory);
        TempOldParentItemAttributeValue.LoadCategoryAttributesFactBoxData(OldParentItemCategory);
        UpdateCategoryItemsAttributeValueMapping(
          TempNewParentItemAttributeValue,TempOldParentItemAttributeValue,ItemCategoryCode,OldParentItemCategory);
    end;

    local procedure GenerateAttributesToInsertAndToDelete(var TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary;var TempItemAttributeValueToDelete: Record "Item Attribute Value" temporary;NewItemCategoryCode: Code[20];OldItemCategoryCode: Code[20])
    var
        TempNewCategItemAttributeValue: Record "Item Attribute Value" temporary;
        TempOldCategItemAttributeValue: Record "Item Attribute Value" temporary;
    begin
        TempNewCategItemAttributeValue.LoadCategoryAttributesFactBoxData(NewItemCategoryCode);
        TempOldCategItemAttributeValue.LoadCategoryAttributesFactBoxData(OldItemCategoryCode);
        GenerateAttributeDifference(TempNewCategItemAttributeValue,TempOldCategItemAttributeValue,TempItemAttributeValueToInsert);
        GenerateAttributeDifference(TempOldCategItemAttributeValue,TempNewCategItemAttributeValue,TempItemAttributeValueToDelete);
    end;

    local procedure GenerateAttributeDifference(var TempFirstItemAttributeValue: Record "Item Attribute Value" temporary;var TempSecondItemAttributeValue: Record "Item Attribute Value" temporary;var TempResultingItemAttributeValue: Record "Item Attribute Value" temporary)
    begin
        if TempFirstItemAttributeValue.FindFirst then
          repeat
            TempSecondItemAttributeValue.SetRange("Attribute ID",TempFirstItemAttributeValue."Attribute ID");
            if TempSecondItemAttributeValue.IsEmpty then begin
              TempResultingItemAttributeValue.TransferFields(TempFirstItemAttributeValue);
              TempResultingItemAttributeValue.Insert;
            end;
            TempSecondItemAttributeValue.Reset;
          until TempFirstItemAttributeValue.Next = 0;
    end;


    procedure DeleteItemAttributeValueMapping(Item: Record Item;var TempItemAttributeValueToRemove: Record "Item Attribute Value" temporary)
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValuesToRemoveTxt: Text;
    begin
        ItemAttributeValueMapping.SetRange("Table ID",Database::Item);
        ItemAttributeValueMapping.SetRange("No.",Item."No.");
        if TempItemAttributeValueToRemove.FindFirst then begin
          repeat
            if ItemAttributeValuesToRemoveTxt <> '' then
              ItemAttributeValuesToRemoveTxt += StrSubstNo('|%1',TempItemAttributeValueToRemove."Attribute ID")
            else
              ItemAttributeValuesToRemoveTxt := Format(TempItemAttributeValueToRemove."Attribute ID");
          until TempItemAttributeValueToRemove.Next = 0;
          ItemAttributeValueMapping.SetFilter("Item Attribute ID",ItemAttributeValuesToRemoveTxt);
          ItemAttributeValueMapping.DeleteAll(true);
        end;
    end;

    local procedure InsertItemAttributeValueMapping(Item: Record Item;var TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary)
    var
        DummyItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        if TempItemAttributeValueToInsert.FindFirst then
          repeat
            DummyItemAttributeValueMapping."Table ID" := Database::Item;
            DummyItemAttributeValueMapping."No." := Item."No.";
            DummyItemAttributeValueMapping."Item Attribute ID" := TempItemAttributeValueToInsert."Attribute ID";
            DummyItemAttributeValueMapping."Item Attribute Value ID" := TempItemAttributeValueToInsert.ID;
            if DummyItemAttributeValueMapping.Insert(true) then;
          until TempItemAttributeValueToInsert.Next = 0;
    end;


    procedure UpdateCategoryItemsAttributeValueMapping(var TempNewItemAttributeValue: Record "Item Attribute Value" temporary;var TempOldItemAttributeValue: Record "Item Attribute Value" temporary;ItemCategoryCode: Code[20];OldItemCategoryCode: Code[20])
    var
        TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary;
        TempItemAttributeValueToDelete: Record "Item Attribute Value" temporary;
    begin
        GenerateAttributeDifference(TempNewItemAttributeValue,TempOldItemAttributeValue,TempItemAttributeValueToInsert);
        GenerateAttributeDifference(TempOldItemAttributeValue,TempNewItemAttributeValue,TempItemAttributeValueToDelete);

        if not TempItemAttributeValueToDelete.IsEmpty then
          if not GuiAllowed then
            DeleteCategoryItemsAttributeValueMapping(TempItemAttributeValueToDelete,ItemCategoryCode)
          else
            if Confirm(StrSubstNo(DeleteItemInheritedParentCategoryAttributesQst,ItemCategoryCode,OldItemCategoryCode)) then
              DeleteCategoryItemsAttributeValueMapping(TempItemAttributeValueToDelete,ItemCategoryCode);

        if not TempItemAttributeValueToInsert.IsEmpty then
          InsertCategoryItemsAttributeValueMapping(TempItemAttributeValueToInsert,ItemCategoryCode);
    end;


    procedure DeleteCategoryItemsAttributeValueMapping(var TempItemAttributeValueToRemove: Record "Item Attribute Value" temporary;CategoryCode: Code[20])
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
    begin
        Item.SetRange("Item Category Code",CategoryCode);
        if Item.FindSet then
          repeat
            DeleteItemAttributeValueMapping(Item,TempItemAttributeValueToRemove);
          until Item.Next = 0;

        ItemCategory.SetRange("Parent Category",CategoryCode);
        if ItemCategory.FindSet then
          repeat
            DeleteCategoryItemsAttributeValueMapping(TempItemAttributeValueToRemove,ItemCategory.Code);
          until ItemCategory.Next = 0;
    end;


    procedure InsertCategoryItemsAttributeValueMapping(var TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary;CategoryCode: Code[20])
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
    begin
        Item.SetRange("Item Category Code",CategoryCode);
        if Item.FindSet then
          repeat
            InsertItemAttributeValueMapping(Item,TempItemAttributeValueToInsert);
          until Item.Next = 0;

        ItemCategory.SetRange("Parent Category",CategoryCode);
        if ItemCategory.FindSet then
          repeat
            InsertCategoryItemsAttributeValueMapping(TempItemAttributeValueToInsert,ItemCategory.Code);
          until ItemCategory.Next = 0;
    end;


    procedure InsertCategoryItemsBufferedAttributeValueMapping(var TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary;var TempInsertedItemAttributeValueMapping: Record "Item Attribute Value Mapping" temporary;CategoryCode: Code[20])
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
    begin
        Item.SetRange("Item Category Code",CategoryCode);
        if Item.FindSet then
          repeat
            InsertBufferedItemAttributeValueMapping(Item,TempItemAttributeValueToInsert,TempInsertedItemAttributeValueMapping);
          until Item.Next = 0;

        ItemCategory.SetRange("Parent Category",CategoryCode);
        if ItemCategory.FindSet then
          repeat
            InsertCategoryItemsBufferedAttributeValueMapping(
              TempItemAttributeValueToInsert,TempInsertedItemAttributeValueMapping,ItemCategory.Code);
          until ItemCategory.Next = 0;
    end;

    local procedure InsertBufferedItemAttributeValueMapping(Item: Record Item;var TempItemAttributeValueToInsert: Record "Item Attribute Value" temporary;var TempInsertedItemAttributeValueMapping: Record "Item Attribute Value Mapping" temporary)
    var
        DummyItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        if TempItemAttributeValueToInsert.FindFirst then
          repeat
            DummyItemAttributeValueMapping."Table ID" := Database::Item;
            DummyItemAttributeValueMapping."No." := Item."No.";
            DummyItemAttributeValueMapping."Item Attribute ID" := TempItemAttributeValueToInsert."Attribute ID";
            DummyItemAttributeValueMapping."Item Attribute Value ID" := TempItemAttributeValueToInsert.ID;
            if DummyItemAttributeValueMapping.Insert(true) then begin
              TempInsertedItemAttributeValueMapping.TransferFields(DummyItemAttributeValueMapping);
              TempInsertedItemAttributeValueMapping.Insert;
            end;
          until TempItemAttributeValueToInsert.Next = 0;
    end;


    procedure SearchCategoryItemsForAttribute(CategoryCode: Code[20];AttributeID: Integer): Boolean
    var
        Item: Record Item;
        ItemCategory: Record "Item Category";
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
    begin
        Item.SetRange("Item Category Code",CategoryCode);
        if Item.FindSet then
          repeat
            ItemAttributeValueMapping.SetRange("Table ID",Database::Item);
            ItemAttributeValueMapping.SetRange("No.",Item."No.");
            ItemAttributeValueMapping.SetRange("Item Attribute ID",AttributeID);
            if ItemAttributeValueMapping.FindFirst then
              exit(true);
          until Item.Next = 0;

        ItemCategory.SetRange("Parent Category",CategoryCode);
        if ItemCategory.FindSet then
          repeat
            SearchCategoryItemsForAttribute(ItemCategory.Code,AttributeID);
          until ItemCategory.Next = 0;
    end;
}

