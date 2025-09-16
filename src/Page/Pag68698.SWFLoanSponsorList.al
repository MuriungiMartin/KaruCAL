#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68698 "SWF-Loan Sponsor List"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = UnknownTable61457;

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
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                }
                field("Postal Code";"Postal Code")
                {
                    ApplicationArea = Basic;
                }
                field(Telephone;Telephone)
                {
                    ApplicationArea = Basic;
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field(Email;Email)
                {
                    ApplicationArea = Basic;
                }
                field(Website;Website)
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

