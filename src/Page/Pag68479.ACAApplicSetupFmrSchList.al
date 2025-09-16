#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68479 "ACA-Applic. Setup Fmr Sch List"
{
    Editable = true;
    PageType = ListPart;
    SourceTable = UnknownTable61366;

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
                field("Contact person";"Contact person")
                {
                    ApplicationArea = Basic;
                }
                field("Address 1";"Address 1")
                {
                    ApplicationArea = Basic;
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Address 3";"Address 3")
                {
                    ApplicationArea = Basic;
                }
                field("Telephone No.";"Telephone No.")
                {
                    ApplicationArea = Basic;
                }
                field("Fax Number";"Fax Number")
                {
                    ApplicationArea = Basic;
                }
                field("Email Address";"Email Address")
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

