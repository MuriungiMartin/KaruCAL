#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68799 "ACA-Exam Category"
{
    PageType = CardPart;
    SourceTable = UnknownTable61568;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Supplementary Max. Score";"Supplementary Max. Score")
                {
                    ApplicationArea = Basic;
                }
                field("2nd Supp. Max. Score";"2nd Supp. Max. Score")
                {
                    ApplicationArea = Basic;
                }
                field(Passmark;Passmark)
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

