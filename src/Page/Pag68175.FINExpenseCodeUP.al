#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68175 "FIN-Expense Code UP"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    PageType = Card;
    SourceTable = UnknownTable61727;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
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

