#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68240 "FIN-Imprest View Window"
{
    PageType = List;
    SourceTable = UnknownTable61704;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Requested By";"Requested By")
                {
                    ApplicationArea = Basic;
                }
                field(Purpose;Purpose)
                {
                    ApplicationArea = Basic;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = Basic;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = Basic;
                }
                field("On Behalf Of";"On Behalf Of")
                {
                    ApplicationArea = Basic;
                }
                field("Total Payment Amount";"Total Payment Amount")
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

