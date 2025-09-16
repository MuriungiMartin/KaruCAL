#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 757 "Shipment Method Translations"
{
    Caption = 'Shipment Method Translations';
    DataCaptionFields = "Shipment Method";
    PageType = List;
    SourceTable = "Shipment Method Translation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the language that the shipment method is translated into.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the translation of the shipment method.';
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
    }
}

