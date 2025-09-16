#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9624 "Finish Design List Part"
{
    Caption = 'Finish Design List Part';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Intelligent Cloud Status";

    layout
    {
        area(content)
        {
            repeater(Control4)
            {
                field("Display Name";"Display Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies Name displayed to users.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies description.';
                }
            }
        }
    }

    actions
    {
    }
}

