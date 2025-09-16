#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 748 "VAT Clause Translations"
{
    Caption = 'Tax Clause Translations';
    DataCaptionFields = "VAT Clause Code";
    PageType = List;
    SourceTable = "VAT Clause Translation";

    layout
    {
        area(content)
        {
            repeater(Control2)
            {
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the language code that the tax clause description is translated into.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the translation of the tax clause description. The translated version of the description is displayed as the tax clause, based on the Language Code setting on the Customer card.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the translation of the additional tax clause description.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control7;Links)
            {
                Visible = false;
            }
            systempart(Control8;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

