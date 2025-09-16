#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5722 "Item Category Management"
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Category", 'OnAfterRenameEvent', '', false, false)]
    local procedure UpdatedPresentationOrderOnAfterRenameItemCategory(var Rec: Record "Item Category";var xRec: Record "Item Category";RunTrigger: Boolean)
    begin
        UpdatePresentationOrder;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Category", 'OnAfterModifyEvent', '', false, false)]
    local procedure UpdatePresentationOrderOnAfterModifyItemCategory(var Rec: Record "Item Category";var xRec: Record "Item Category";RunTrigger: Boolean)
    var
        NewParentItemCategory: Record "Item Category";
    begin
        if xRec."Parent Category" <> Rec."Parent Category" then begin
          UpdatePresentationOrder;
          if NewParentItemCategory.Get(Rec."Parent Category") then
            Rec.Validate(Indentation,NewParentItemCategory.Indentation + 1)
          else
            Rec.Validate(Indentation,0);
          Rec.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Category", 'OnAfterInsertEvent', '', false, false)]
    local procedure UpdatePresentationOrdOnAfterInsertItemCategory(var Rec: Record "Item Category";RunTrigger: Boolean)
    var
        NewParentItemCategory: Record "Item Category";
    begin
        UpdatePresentationOrder;
        if NewParentItemCategory.Get(Rec."Parent Category") then begin
          Rec.Validate(Indentation,NewParentItemCategory.Indentation + 1);
          Rec.Modify;
        end;
    end;


    procedure UpdatePresentationOrder()
    var
        PresentationOrder: Integer;
    begin
        PresentationOrder := 0;
        UpdatePresentationOrderRecursively('',PresentationOrder,0);
    end;

    local procedure UpdatePresentationOrderRecursively(ParentCode: Code[20];var PresentationOrder: Integer;Indentation: Integer)
    var
        ItemCategory: Record "Item Category";
    begin
        ItemCategory.SetRange("Parent Category",ParentCode);
        if ItemCategory.FindSet then
          repeat
            PresentationOrder += 1;
            ItemCategory."Presentation Order" := PresentationOrder;
            ItemCategory.Indentation := Indentation;
            ItemCategory.Modify;
            UpdatePresentationOrderRecursively(ItemCategory.Code,PresentationOrder,Indentation + 1);
          until ItemCategory.Next = 0;
    end;
}

