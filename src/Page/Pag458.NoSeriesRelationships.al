#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 458 "No. Series Relationships"
{
    Caption = 'No. Series Relationships';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "No. Series Relationship";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series code that represents the related number series.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies the description of the number series represented by the code in the Code field.';
                    Visible = false;
                }
                field("Series Code";"Series Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for a number series that you want to include in the group of related number series.';
                }
                field("Series Description";"Series Description")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the description of the number series represented by the code in the Series Code field.';
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

