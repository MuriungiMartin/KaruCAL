#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 848 "Cash Flow Comment"
{
    AutoSplitKey = true;
    Caption = 'Cash Flow Comment';
    PageType = List;
    SourceTable = "Cash Flow Account Comment";

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic,Suite;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the comment for the record.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code of the record.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1905767507;Notes)
            {
                ApplicationArea = Basic,Suite;
                Visible = true;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetUpNewLine;
    end;
}

