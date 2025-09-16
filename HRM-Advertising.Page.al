#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68404 "HRM-Advertising"
{
    PageType = ListPart;
    SourceTable = UnknownTable61309;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Advertising Media";"Advertising Media")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Advertisement Doc Link";"Advertisement Doc Link")
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

