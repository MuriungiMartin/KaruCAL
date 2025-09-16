#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 70043 "Recruitment Inv/Regret Mail Cd"
{
    PageType = Card;
    SourceTable = UnknownTable60239;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Message Type";"Message Type")
                {
                    ApplicationArea = Basic;
                }
                field(Salutation;Salutation)
                {
                    ApplicationArea = Basic;
                }
                field("Include Initials";"Include Initials")
                {
                    ApplicationArea = Basic;
                }
                field(Subject;Subject)
                {
                    ApplicationArea = Basic;
                }
                field("Paragraph 1";"Paragraph 1")
                {
                    ApplicationArea = Basic;
                    ColumnSpan = 50;
                    RowSpan = 50;
                }
                field("Paragraph 2";"Paragraph 2")
                {
                    ApplicationArea = Basic;
                    ColumnSpan = 50;
                    RowSpan = 50;
                }
                field("Disclaimer 1";"Disclaimer 1")
                {
                    ApplicationArea = Basic;
                }
                field("Disclaimer 2";"Disclaimer 2")
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

