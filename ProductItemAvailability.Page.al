#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5390 "Product Item Availability"
{
    Caption = 'Product Item Availability';
    PageType = List;
    SourceTable = "CRM Integration Record";
    SourceTableView = where("Table ID"=const(27));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("CRM ID";"CRM ID")
                {
                    ApplicationArea = Basic;
                }
                field("Integration ID";"Integration ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemNo;Item."No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'ItemNo';
                    ToolTip = 'Specifies Item No.';
                }
                field(UOM;Item."Base Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Caption = 'UOM';
                    ToolTip = 'Specifies Unit of Measure';
                }
                field(Inventory;Item.Inventory)
                {
                    ApplicationArea = Basic;
                    Caption = 'Inventory';
                    ToolTip = 'Specifies Inventory';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        IntegrationRecord: Record "Integration Record";
        RecordRef: RecordRef;
    begin
        Clear(Item);
        if IsNullGuid("Integration ID") or ("Table ID" <> Database::Item) then
          exit;

        if IntegrationRecord.Get("Integration ID") then begin
          RecordRef.Get(IntegrationRecord."Record ID");
          RecordRef.SetTable(Item);
          Item.CalcFields(Inventory);
        end;
    end;

    var
        Item: Record Item;
}

