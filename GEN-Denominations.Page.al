#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68842 "GEN-Denominations"
{
    CardPageID = "ACA-Religions 2";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable61658;
    SourceTableView = where(Category=filter(Denominations));

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

