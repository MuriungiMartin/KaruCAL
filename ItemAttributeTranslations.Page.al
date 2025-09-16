#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7502 "Item Attribute Translations"
{
    Caption = 'Item Attribute Translations';
    DataCaptionFields = "Attribute ID";
    PageType = List;
    SourceTable = "Item Attribute Translation";

    layout
    {
        area(content)
        {
            repeater(Control1)
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
                    ToolTip = 'Specifies the translated name of the item attribute.';
                }
            }
        }
    }

    actions
    {
    }
}

