#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 580 "Dimension Translations"
{
    Caption = 'Dimension Translations';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Dimension Translation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Language ID";"Language ID")
                {
                    ApplicationArea = Suite;
                    LookupPageID = "Windows Languages";
                    ToolTip = 'Specifies a language code.';
                }
                field("Language Name";"Language Name")
                {
                    ApplicationArea = Suite;
                    DrillDown = false;
                    Editable = false;
                    ToolTip = 'Specifies the name of the language.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the dimension code.';
                }
                field("Code Caption";"Code Caption")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the dimension code as you want it to appear as a field name after the Language ID code is selected.';
                }
                field("Filter Caption";"Filter Caption")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension filter caption.';
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

