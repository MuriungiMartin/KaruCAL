#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5776 "Warehouse Comment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Comment Sheet';
    DataCaptionExpression = FormCaption;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Warehouse Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
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
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the comment.';
                    Visible = false;
                }
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

