#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9110 "Item Attributes Factbox"
{
    Caption = 'Item Attributes';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Item Attribute Value";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field(Attribute;GetAttributeNameInCurrentLanguage)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the item attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field(Value;GetValueInCurrentLanguage)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the item attribute.';
                    Visible = TranslatedValuesVisible;
                }
                field("Attribute Name";"Attribute Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Attribute';
                    ToolTip = 'Specifies the name of the item attribute.';
                    Visible = not TranslatedValuesVisible;
                }
                field(RawValue;Value)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Value';
                    ToolTip = 'Specifies the value of the item attribute.';
                    Visible = not TranslatedValuesVisible;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        SetAutocalcFields("Attribute Name");
        TranslatedValuesVisible := CurrentClientType <> Clienttype::Phone;
    end;

    var
        TranslatedValuesVisible: Boolean;


    procedure LoadItemAttributesData(KeyValue: Code[20])
    begin
        LoadItemAttributesFactBoxData(KeyValue);
        CurrPage.Update(false);
    end;


    procedure LoadCategoryAttributesData(CategoryCode: Code[20])
    begin
        LoadCategoryAttributesFactBoxData(CategoryCode);
        CurrPage.Update(false);
    end;
}

