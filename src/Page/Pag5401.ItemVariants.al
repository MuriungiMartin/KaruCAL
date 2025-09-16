#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5401 "Item Variants"
{
    Caption = 'Item Variants';
    DataCaptionFields = "Item No.";
    PageType = List;
    SourceTable = "Item Variant";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item card from which you opened the Item Variant Translations window.';
                    Visible = false;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code to identify the variant.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies text that describes the item variant.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Describes the item variant in more detail than the Description field.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("V&ariant")
            {
                Caption = 'V&ariant';
                Image = ItemVariant;
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No."=field("Item No."),
                                  "Variant Code"=field(Code);
                }
            }
        }
    }
}

