#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1327 "Adjust Item Inventory"
{

    trigger OnRun()
    begin
    end;

    var
        CantFindTemplateOrBatchErr: label 'Unable to find the correct Item Journal template or batch to post this change. Use the Item Journal instead.';
        SimpleInvJnlNameTxt: label 'DEFAULT', Comment='The default name of the item journal';


    procedure PostAdjustmentToItemLedger(Item: Record Item;NewInventory: Decimal) LastErrorText: Text
    var
        ItemJnlLine: Record "Item Journal Line";
        Completed: Boolean;
    begin
        Item.CalcFields(Inventory);
        if Item.Inventory = NewInventory then
          exit;

        ItemJnlLine.Init;
        ItemJnlLine.Validate("Journal Template Name",SelectItemTemplateForAdjustment);
        ItemJnlLine.Validate("Journal Batch Name",CreateItemBatch(ItemJnlLine."Journal Template Name"));
        ItemJnlLine.Validate("Posting Date",WorkDate);
        ItemJnlLine."Document No." := Item."No.";

        if Item.Inventory < NewInventory then
          ItemJnlLine.Validate("Entry Type",ItemJnlLine."entry type"::"Positive Adjmt.")
        else
          ItemJnlLine.Validate("Entry Type",ItemJnlLine."entry type"::"Negative Adjmt.");

        ItemJnlLine.Validate("Item No.",Item."No.");
        ItemJnlLine.Validate(Description,Item.Description);
        ItemJnlLine.Validate(Quantity,Abs(NewInventory - Item.Inventory));
        ItemJnlLine.Insert(true);
        Commit;

        Completed := Codeunit.Run(Codeunit::"Item Jnl.-Post Batch",ItemJnlLine);

        DeleteItemBatch(ItemJnlLine."Journal Template Name",ItemJnlLine."Journal Batch Name");

        if not Completed then begin
          LastErrorText := GetLastErrorText;
          Commit;
        end;
    end;

    local procedure SelectItemTemplateForAdjustment(): Code[10]
    var
        ItemJnlTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        ItemJnlManagement: Codeunit ItemJnlManagement;
        JnlSelected: Boolean;
    begin
        ItemJnlManagement.TemplateSelection(Page::"Item Journal",0,false,ItemJnlLine,JnlSelected);

        ItemJnlTemplate.SetRange("Page ID",Page::"Item Journal");
        ItemJnlTemplate.SetRange(Recurring,false);
        ItemJnlTemplate.SetRange(Type,ItemJnlTemplate.Type::Item);
        if not ItemJnlTemplate.FindFirst then
          Error(CantFindTemplateOrBatchErr);

        exit(ItemJnlTemplate.Name);
    end;

    local procedure CreateItemBatch(TemplateName: Code[10]): Code[10]
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ItemJnlBatch.Init;
        ItemJnlBatch."Journal Template Name" := TemplateName;
        ItemJnlBatch.Name := CreateBatchName;
        ItemJnlBatch.Description := SimpleInvJnlNameTxt;
        ItemJnlBatch.Insert;

        exit(ItemJnlBatch.Name);
    end;

    local procedure DeleteItemBatch(TemplateName: Code[10];BatchName: Code[10])
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        if ItemJnlBatch.Get(TemplateName,BatchName) then
          ItemJnlBatch.Delete(true);
    end;

    local procedure CreateBatchName(): Code[10]
    var
        GuidStr: Text;
        BatchName: Text;
    begin
        GuidStr := Format(CreateGuid);
        // Remove numbers to avoid batch name change by INCSTR in codeunit 23
        BatchName := ConvertStr(GuidStr,'1234567890-','GHIJKLMNOPQ');
        exit(CopyStr(BatchName,2,10));
    end;
}

