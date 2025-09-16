#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5874 "BOM Warning Log"
{
    Caption = 'BOM Warning Log';
    Editable = false;
    PageType = List;
    SourceTable = "BOM Warning Log";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Warning Description";"Warning Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the warning associated with the entry.';
                }
                field("Table ID";"Table ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the table ID associated with the entry.';
                    Visible = false;
                }
                field("Table Position";"Table Position")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the table position associated with the entry.';
                    Visible = false;
                }
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
                    ShowWarning;
                end;
            }
        }
    }
}

