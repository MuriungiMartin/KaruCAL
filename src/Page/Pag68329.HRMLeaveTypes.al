#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68329 "HRM-Leave Types"
{
    PageType = ListPart;
    SourceTable = UnknownTable61279;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Days;Days)
                {
                    ApplicationArea = Basic;
                }
                field("Unlimited Days";"Unlimited Days")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field(Balance;Balance)
                {
                    ApplicationArea = Basic;
                }
                field("Max Carry Forward Days";"Max Carry Forward Days")
                {
                    ApplicationArea = Basic;
                }
                field("Inclusive of Holidays";"Inclusive of Holidays")
                {
                    ApplicationArea = Basic;
                }
                field("Inclusive of Saturday";"Inclusive of Saturday")
                {
                    ApplicationArea = Basic;
                }
                field("Inclusive of Sunday";"Inclusive of Sunday")
                {
                    ApplicationArea = Basic;
                }
                field("Off/Holidays Days Leave";"Off/Holidays Days Leave")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

