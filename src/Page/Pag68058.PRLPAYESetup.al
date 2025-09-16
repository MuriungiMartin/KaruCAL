#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68058 "PRL-P.A.Y.E Setup"
{
    Editable = true;
    PageType = Card;
    SourceTable = UnknownTable61076;

    layout
    {
        area(content)
        {
            repeater(Control1102755000)
            {
                field("Tier Code";"Tier Code")
                {
                    ApplicationArea = Basic;
                }
                field("PAYE Tier";"PAYE Tier")
                {
                    ApplicationArea = Basic;
                }
                field(Rate;Rate)
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

