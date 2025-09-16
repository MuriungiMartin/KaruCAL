#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 590 "XBRL Taxonomy Labels"
{
    Caption = 'XBRL Taxonomy Labels';
    PageType = List;
    SourceTable = "XBRL Taxonomy Label";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("XML Language Identifier";"XML Language Identifier")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a one or two-letter abbreviation code for the language of the label. There is no connection to the Windows Language ID code.';
                }
                field("Windows Language ID";"Windows Language ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the Windows language associated with the language code you have set up in this line.';
                    Visible = false;
                }
                field("Windows Language Name";"Windows Language Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if you enter an ID in the Windows Language ID field.';
                    Visible = false;
                }
                field(Label;Label)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the user-readable element of the taxonomy.';
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

