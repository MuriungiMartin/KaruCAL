#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7504 "Item Attribute Value List"
{
    Caption = 'Item Attribute Values';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Item Attribute Value Selection";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Attribute Name";"Attribute Name")
                {
                    ApplicationArea = Basic,Suite;
                    AssistEdit = false;
                    Caption = 'Attribute';
                    TableRelation = "Item Attribute".Name where (Blocked=const(false));
                    ToolTip = 'Specifies the item attribute.';

                    trigger OnValidate()
                    var
                        ItemAttributeValue: Record "Item Attribute Value";
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    begin
                        if xRec."Attribute Name" <> '' then
                          DeleteItemAttributeValueMapping(xRec."Attribute ID");

                        CheckInsertItemAttributeValue(ItemAttributeValue);

                        if ItemAttributeValue.Get(ItemAttributeValue."Attribute ID",ItemAttributeValue.ID) then begin
                          ItemAttributeValueMapping.Reset;
                          ItemAttributeValueMapping.Init;
                          ItemAttributeValueMapping."Table ID" := Database::Item;
                          ItemAttributeValueMapping."No." := RelatedRecordCode;
                          ItemAttributeValueMapping."Item Attribute ID" := ItemAttributeValue."Attribute ID";
                          ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                          ItemAttributeValueMapping.Insert;
                        end;
                    end;
                }
                field(Value;Value)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Value';
                    TableRelation = if ("Attribute Type"=const(Option)) "Item Attribute Value".Value where ("Attribute ID"=field("Attribute ID"),
                                                                                                            Blocked=const(false));
                    ToolTip = 'Specifies the value of the item attribute.';

                    trigger OnValidate()
                    var
                        ItemAttributeValue: Record "Item Attribute Value";
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                        ItemAttribute: Record "Item Attribute";
                    begin
                        CheckInsertItemAttributeValue(ItemAttributeValue);

                        ItemAttributeValueMapping.SetRange("Table ID",Database::Item);
                        ItemAttributeValueMapping.SetRange("No.",RelatedRecordCode);
                        ItemAttributeValueMapping.SetRange("Item Attribute ID",ItemAttributeValue."Attribute ID");

                        if ItemAttributeValueMapping.FindFirst then begin
                          ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                          ItemAttributeValueMapping.Modify;

                          ItemAttribute.Get("Attribute ID");
                          ItemAttribute.RemoveUnusedArbitraryValues;
                        end;
                    end;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure for the item attribute.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        DeleteItemAttributeValueMapping("Attribute ID");
    end;

    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
    end;

    var
        RelatedRecordCode: Code[20];


    procedure LoadAttributes(ItemNo: Code[20])
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        TempItemAttributeValue: Record "Item Attribute Value" temporary;
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        RelatedRecordCode := ItemNo;
        ItemAttributeValueMapping.SetRange("Table ID",Database::Item);
        ItemAttributeValueMapping.SetRange("No.",ItemNo);
        if ItemAttributeValueMapping.FindSet then
          repeat
            ItemAttributeValue.Get(ItemAttributeValueMapping."Item Attribute ID",ItemAttributeValueMapping."Item Attribute Value ID");
            TempItemAttributeValue.TransferFields(ItemAttributeValue);
            TempItemAttributeValue.Insert;
          until ItemAttributeValueMapping.Next = 0;

        PopulateItemAttributeValueSelection(TempItemAttributeValue);
    end;

    local procedure DeleteItemAttributeValueMapping(AttributeToDeleteID: Integer)
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttributeValueMapping.SetRange("Table ID",Database::Item);
        ItemAttributeValueMapping.SetRange("No.",RelatedRecordCode);
        ItemAttributeValueMapping.SetRange("Item Attribute ID",AttributeToDeleteID);
        if ItemAttributeValueMapping.FindFirst then
          ItemAttributeValueMapping.Delete;

        ItemAttribute.Get(AttributeToDeleteID);
        ItemAttribute.RemoveUnusedArbitraryValues;
    end;

    local procedure CheckInsertItemAttributeValue(var ItemAttributeValue: Record "Item Attribute Value")
    var
        ValDecimal: Decimal;
    begin
        ItemAttributeValue.Reset;
        ItemAttributeValue.SetRange("Attribute ID","Attribute ID");
        case "Attribute Type" of
          "attribute type"::Option,
          "attribute type"::Text,
          "attribute type"::Integer:
            ItemAttributeValue.SetRange(Value,Value);
          "attribute type"::Decimal:
            begin
              if Value <> '' then
                Evaluate(ValDecimal,Value);
              ItemAttributeValue.SetRange(Value,Format(ValDecimal,0,9));
            end;
        end;
        if not ItemAttributeValue.FindFirst then
          InsertItemAttributeValue(ItemAttributeValue,Rec);
    end;
}

