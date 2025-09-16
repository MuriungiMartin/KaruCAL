#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5777 "Warehouse Comment List"
{
    Caption = 'Comment List';
    DataCaptionExpression = FormCaption;
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Warehouse Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the warehouse activity for which the comment is created.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date when the comment was created.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the comment.';
                }
            }
        }
    }

    actions
    {
    }
}

