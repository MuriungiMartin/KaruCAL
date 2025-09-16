#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99401 "POS Setup"
{
    ApplicationArea = Basic;
    PageType = Card;
    SourceTable = "POS Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Receipt No.";"Receipt No.")
                {
                    ApplicationArea = Basic;
                }
                field("Students Sales Account";"Students Sales Account")
                {
                    ApplicationArea = Basic;
                }
                field("Pos Items Series";"Pos Items Series")
                {
                    ApplicationArea = Basic;
                }
                field("Sales No.";"Sales No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Sales Account";"Staff Sales Account")
                {
                    ApplicationArea = Basic;
                }
                field("Stock Adjustment";"Stock Adjustment")
                {
                    ApplicationArea = Basic;
                }
                field("Cash Account";"Cash Account")
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

