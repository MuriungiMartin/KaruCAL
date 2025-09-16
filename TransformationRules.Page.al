#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1237 "Transformation Rules"
{
    Caption = 'Transformation Rules';
    CardPageID = "Transformation Rule Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Transformation Rule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field("Transformation Type";"Transformation Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field("Find Value";"Find Value")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field("Replace Value";"Replace Value")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field("Start Position";"Start Position")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field(Length;Length)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field("Data Format";"Data Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
                field("Data Formatting Culture";"Data Formatting Culture")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies rules for how text that was imported from an external file is transformed to a supported value that can be mapped to the specified field in Dynamics NAV.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if IsEmpty then
          CreateDefaultTransformations;
        OnCreateTransformationRules;
    end;
}

