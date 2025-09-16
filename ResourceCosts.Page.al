#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 203 "Resource Costs"
{
    ApplicationArea = Basic;
    Caption = 'Resource Costs';
    DataCaptionFields = "Code";
    PageType = List;
    SourceTable = "Resource Cost";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code.';
                }
                field("Work Type Code";"Work Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the type of work. You can also assign a unit price to a work type.';
                }
                field("Cost Type";"Cost Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of cost.';
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the direct unit cost. The entry in this field depends on your selection in the Cost Type field.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'The entry in this field depends on your selection in the Cost Type field.';
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

