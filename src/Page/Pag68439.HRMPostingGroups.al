#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68439 "HRM-Posting Groups"
{
    PageType = ListPart;
    SourceTable = UnknownTable61327;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Posting Group";"Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Training Debit Account";"Training Debit Account")
                {
                    ApplicationArea = Basic;
                }
                field("Training Credit A/C Type";"Training Credit A/C Type")
                {
                    ApplicationArea = Basic;
                }
                field("Training Credit Account";"Training Credit Account")
                {
                    ApplicationArea = Basic;
                }
                field("Comp. Act. Debit Account";"Comp. Act. Debit Account")
                {
                    ApplicationArea = Basic;
                }
                field("Comp. Act. Credit A/C Type";"Comp. Act. Credit A/C Type")
                {
                    ApplicationArea = Basic;
                }
                field("Comp. Act. Credit Account";"Comp. Act. Credit Account")
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

