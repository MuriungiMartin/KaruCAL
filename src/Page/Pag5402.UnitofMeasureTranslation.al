#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5402 "Unit of Measure Translation"
{
    Caption = 'Unit of Measure Translation';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Unit of Measure Translation";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code for which you want to enter a translation.';
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the language code for which you want to set up unit of measure translations.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the unit of measure code that corresponds to Code in the selected foreign language.';
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

