#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69077 "CAT-Cafe. General Setup Card"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "General Ledger Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Meals Booking No.";"Meals Booking No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cafeteria Sales Account";"Cafeteria Sales Account")
                {
                    ApplicationArea = Basic;
                }
                field("Cafeteria Credit Sales Account";"Cafeteria Credit Sales Account")
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

