#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6506 "Item Tracking Comments"
{
    AutoSplitKey = true;
    Caption = 'Item Tracking Comments';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Item Tracking Comment";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a date to reference the comment.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item tracking comment.';
                }
            }
        }
    }

    actions
    {
    }
}

