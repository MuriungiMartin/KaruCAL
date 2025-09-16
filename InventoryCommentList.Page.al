#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5751 "Inventory Comment List"
{
    Caption = 'Comment List';
    DataCaptionFields = "Document Type","No.";
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Inventory Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the comment number.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies when the comment was created.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the actual comment text.';
                }
            }
        }
    }

    actions
    {
    }
}

