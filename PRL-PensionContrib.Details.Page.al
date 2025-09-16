#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68083 "PRL-Pension Contrib. Details"
{
    PageType = Card;
    SourceTable = UnknownTable61121;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Inception Date";"Inception Date")
                {
                    ApplicationArea = Basic;
                }
                field("Pension Number";"Pension Number")
                {
                    ApplicationArea = Basic;
                }
                field(Company;Company)
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Code";"Transaction Code")
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

