#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7111 "Analysis Type List"
{
    Caption = 'Analysis Type List';
    Editable = false;
    PageType = List;
    SourceTable = "Analysis Type";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the analysis type.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the analysis type.';
                }
                field("Value Type";"Value Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value type that the analysis type is based on.';
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
        area(processing)
        {
            action("&Setup")
            {
                ApplicationArea = Basic;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Analysis Types";
                ToolTip = 'Set up the analysis type.';
            }
        }
    }
}

