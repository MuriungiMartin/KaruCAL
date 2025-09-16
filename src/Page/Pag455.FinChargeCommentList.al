#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 455 "Fin. Charge Comment List"
{
    AutoSplitKey = true;
    Caption = 'Comment List';
    DataCaptionExpression = Caption(Rec);
    DelayedInsert = true;
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Fin. Charge Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the type of document the comment is attached to: either Finance Charge Memo or Issued Finance Charge Memo.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the document number of the finance charge memo to which the comment applies.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the comment was created.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the comment itself.';
                }
            }
        }
    }

    actions
    {
    }

    var
        Text000: label 'untitled', Comment='it is a caption for empty page';
        Text001: label 'Fin. Charge Memo';

    local procedure Caption(FinChrgCommentLine: Record "Fin. Charge Comment Line"): Text[110]
    begin
        if FinChrgCommentLine."No." = '' then
          exit(Text000);
        exit(Text001 + ' ' + FinChrgCommentLine."No." + ' ');
    end;
}

