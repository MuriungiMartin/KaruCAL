#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9626 "New Page Patterns List Part"
{
    Caption = 'New Page Patterns List Part';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable2000000174;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Display Name";"Display Name")
                {
                    ApplicationArea = All;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

