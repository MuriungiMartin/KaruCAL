#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 858 "Cash Flow Comment List"
{
    Caption = 'Cash Flow Comment List';
    Editable = false;
    PageType = List;
    SourceTable = "Cash Flow Account Comment";

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the record.';
                }
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
    }

    actions
    {
    }
}

