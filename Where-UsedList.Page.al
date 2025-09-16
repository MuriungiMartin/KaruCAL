#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 37 "Where-Used List"
{
    Caption = 'Where-Used List';
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "BOM Component";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Parent Item No.";"Parent Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the assembly item that the assembly BOM component belongs to.';
                }
                field("BOM Description";"BOM Description")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies a description of the assembly BOM if the item on the line is an assembly BOM.';
                }
                field("Quantity per";"Quantity per")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the assembly BOM component are required in the assembly BOM.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the assembly BOM component''s unit of measure.';
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component''s position in the assembly BOM structure.';
                }
                field("Position 2";"Position 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component''s position in the assembly BOM structure.';
                    Visible = false;
                }
                field("Position 3";"Position 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the component''s position in the assembly BOM structure.';
                    Visible = false;
                }
                field("Machine No.";"Machine No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a machine that should be used when processing the component on this line of the assembly BOM.';
                    Visible = false;
                }
                field("Lead-Time Offset";"Lead-Time Offset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the total number of days required to assemble the item on the assembly BOM line.';
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
    }
}

