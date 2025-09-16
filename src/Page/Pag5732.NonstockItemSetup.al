#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5732 "Nonstock Item Setup"
{
    ApplicationArea = Basic;
    Caption = 'Nonstock Item Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Nonstock Item Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No. Format";"No. Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the format of the nonstock item number that appears on the item card.';
                }
                field("No. Format Separator";"No. Format Separator")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the character that separates the elements of your nonstock item number format, if the format uses both a code and a number.';
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

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;
}

