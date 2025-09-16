#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 575 "VAT Registration No. Formats"
{
    AutoSplitKey = true;
    Caption = 'Tax Registration No. Formats';
    DataCaptionFields = "Country/Region Code";
    PageType = List;
    SourceTable = "VAT Registration No. Format";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the contents of the Country/Region Code field in the Country/Region table.';
                    Visible = false;
                }
                field(Format;Format)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a format for a country''s/region''s tax registration number.';
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

