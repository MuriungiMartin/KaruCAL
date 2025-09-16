#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1209 "Credit Trans Re-export History"
{
    Caption = 'Credit Trans Re-export History';
    Editable = false;
    PageType = List;
    SourceTable = "Credit Trans Re-export History";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Re-export Date";"Re-export Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date when the payment file was re-exported.';
                }
                field("Re-exported By";"Re-exported By")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user who re-exported the payment file.';
                }
            }
        }
    }

    actions
    {
    }
}

