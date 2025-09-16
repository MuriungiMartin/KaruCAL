#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5180 "Sales Archive Comment Sheet"
{
    Caption = 'Comment Sheet';
    Editable = false;
    PageType = List;
    SourceTable = "Sales Comment Line Archive";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the version number of the archived document.';
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document line number of the quote or order to which the comment applies.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the line number for the comment.';
                }
            }
        }
    }

    actions
    {
    }
}

