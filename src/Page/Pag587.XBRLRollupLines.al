#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 587 "XBRL Rollup Lines"
{
    Caption = 'XBRL Rollup Lines';
    PageType = List;
    SourceTable = "XBRL Rollup Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("From XBRL Taxonomy Line No.";"From XBRL Taxonomy Line No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the XBRL line from which this XBRL line is rolled up.';
                }
                field("From XBRL Taxonomy Line Name";"From XBRL Taxonomy Line Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the XBRL line from which this XBRL line is rolled up.';
                    Visible = false;
                }
                field("From XBRL Taxonomy Line Label";"From XBRL Taxonomy Line Label")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the label of the XBRL line from which this XBRL line is rolled up.';
                }
                field(Weight;Weight)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the label of the XBRL line from which this XBRL line is rolled up.';
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

