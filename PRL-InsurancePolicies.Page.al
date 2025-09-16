#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68074 "PRL-Insurance Policies"
{
    PageType = List;
    SourceTable = UnknownTable61083;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Policy Number";"Policy Number")
                {
                    ApplicationArea = Basic;
                }
                field("Insurance Code";"Insurance Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Deduct premium";"Deduct premium")
                {
                    ApplicationArea = Basic;
                }
                field(balance;balance)
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

