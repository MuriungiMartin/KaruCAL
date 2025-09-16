#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1289 "Additional Match Details"
{
    Caption = 'Additional Match Details';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Payment Matching Details";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Message;Message)
                {
                    ApplicationArea = Basic,Suite;
                    ShowCaption = false;
                    ToolTip = 'Specifies if a message with additional match details exists.';
                    Width = 250;
                }
            }
        }
    }

    actions
    {
    }
}

