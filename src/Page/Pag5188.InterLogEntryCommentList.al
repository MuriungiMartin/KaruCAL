#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5188 "Inter. Log Entry Comment List"
{
    Caption = 'Inter. Log Entry Comment List';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Inter. Log Entry Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the entry in the interaction log.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the comment was created.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the comment itself. You can enter a maximum of 80 characters, both numbers and letters.';
                }
            }
        }
    }

    actions
    {
    }
}

