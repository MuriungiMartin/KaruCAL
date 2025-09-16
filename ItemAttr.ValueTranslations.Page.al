#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7505 "Item Attr. Value Translations"
{
    Caption = 'Item Attribute Value Translations';
    DataCaptionExpression = DynamicCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Item Attr. Value Translation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Languages;
                    ToolTip = 'Specifies a language code.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the translated name of the item attribute value.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateWindowCaption
    end;

    var
        DynamicCaption: Text;

    local procedure UpdateWindowCaption()
    var
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        if ItemAttributeValue.Get("Attribute ID",ID) then
          DynamicCaption := ItemAttributeValue.Value
        else
          DynamicCaption := '';
    end;
}

