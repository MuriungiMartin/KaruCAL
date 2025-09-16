#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68868 "GEN-Nationality List"
{
    CardPageID = "GEN-Nationality Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61658;
    SourceTableView = where(Category=filter(Nationality));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Title Code";"Title Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Denomination';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

