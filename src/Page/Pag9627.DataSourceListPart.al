#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9627 "Data Source List Part"
{
    Caption = 'Data Source List Part';
    DelayedInsert = false;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Table Metadata";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                }
            }
        }
    }

    actions
    {
    }
}

