#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99405 "POS Item Ledger"
{
    PageType = List;
    SourceTable = "POS Item Ledger";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Entry Type";"Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
                field("User ID";"User ID")
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

