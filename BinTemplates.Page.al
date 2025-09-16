#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7367 "Bin Templates"
{
    ApplicationArea = Basic;
    Caption = 'Bin Templates';
    DataCaptionFields = "Code",Description;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Bin Template";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the bin template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the bin creation template.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location code that will apply to all the bins set up with this bin template.';
                }
                field("Zone Code";"Zone Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the zone where the bins created by this template are located.';
                    Visible = false;
                }
                field("Bin Description";"Bin Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the bins that are set up using the bin template.';
                }
                field("Bin Type Code";"Bin Type Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a bin type code that will be copied to all bins created using the template.';
                    Visible = false;
                }
                field("Warehouse Class Code";"Warehouse Class Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a warehouse class code that will be copied to all bins created using the template.';
                    Visible = false;
                }
                field("Block Movement";"Block Movement")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the movement of a particular item, or bin content, into or out of this bin, is blocked.';
                    Visible = false;
                }
                field("Special Equipment Code";"Special Equipment Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a special equipment code that will be copied to all bins created using the template.';
                    Visible = false;
                }
                field("Bin Ranking";"Bin Ranking")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the bin ranking that will be copied to all bins created using the template.';
                    Visible = false;
                }
                field("Maximum Cubage";"Maximum Cubage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum cubage that will be copied to all bins that are created using the template.';
                    Visible = false;
                }
                field("Maximum Weight";"Maximum Weight")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum weight that will be copied to all bins that are created using the template.';
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

