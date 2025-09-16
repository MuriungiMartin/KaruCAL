#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5235 "HR Confidential Comment List"
{
    Caption = 'Comment List';
    DataCaptionExpression = Caption(Rec);
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "HR Confidential Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                }
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    var
        Employee: Record Employee;
        ConfidentialInfo: Record "Confidential Information";
        Text000: label 'untitled', Comment='it is a caption for empty page';


    procedure Caption(HRCommentLine: Record "HR Confidential Comment Line"): Text[110]
    begin
        if ConfidentialInfo.Get(HRCommentLine."No.",HRCommentLine.Code,HRCommentLine."Table Line No.") and
           Employee.Get(HRCommentLine."No.")
        then
          exit(HRCommentLine."No." + ' ' + Employee.FullName + ' ' +
            ConfidentialInfo."Confidential Code");
        exit(Text000);
    end;
}

