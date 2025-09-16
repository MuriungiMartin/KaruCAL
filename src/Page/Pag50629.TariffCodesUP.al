#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 50629 "Tariff Codes UP"
{
    DeleteAllowed = false;
    Editable = true;
    PageType = Card;
    SourceTable = UnknownTable60248;

    layout
    {
        area(content)
        {
            repeater(Control1102758000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field(Percentage;Percentage)
                {
                    ApplicationArea = Basic;
                }
                field("G/L Account";"G/L Account")
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

