#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5430 "Planning Error Log"
{
    Caption = 'Planning Error Log';
    DataCaptionExpression = Caption;
    Editable = false;
    PageType = List;
    SourceTable = "Planning Error Log";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number associated with this entry.';
                }
                field("Error Description";"Error Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description to the error in this entry.';
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
            action("&Show")
            {
                ApplicationArea = Basic;
                Caption = '&Show';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ShowError;
                end;
            }
        }
    }
}

