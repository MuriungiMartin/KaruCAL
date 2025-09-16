#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5118 "Rlshp. Mgt. Comment List"
{
    Caption = 'Rlshp. Mgt. Comment List';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Rlshp. Mgt. Comment Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the contact, Web source, to-do, campaign, opportunity or sales cycle to which the comment applies.';
                }
                field("Sub No.";"Sub No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the stage within the sales cycle.';
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
}

