#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65006 "Mpesa Bank Accounts Setup"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable99909;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Mpesa Code";"Mpesa Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bank Account Code";"Bank Account Code")
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

