#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68305 "CAT-Menu Sales Line Staff"
{
    PageType = List;
    SourceTable = UnknownTable61173;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Menu;Menu)
                {
                    ApplicationArea = Basic;
                    LookupPageID = "CAT-Daily menu List";

                    trigger OnValidate()
                    begin
                            DailyMenu.SetRange(DailyMenu.Menu,Menu) ;
                            DailyMenu.SetRange(DailyMenu."Menu Date",Today);
                            if DailyMenu.Find('-') then
                            begin
                              "Unit Cost":=DailyMenu."Unit Cost"
                            end;
                    end;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        DailyMenu: Record UnknownRecord61169;
}

