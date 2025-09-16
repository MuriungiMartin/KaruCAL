#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68302 "CAT-Menu Sales Line"
{
    PageType = ListPart;
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

                            DailyMenu.Reset;
                            DailyMenu.SetRange(DailyMenu.Menu,Menu) ;
                          //  DailyMenu.SETRANGE(DailyMenu."Menu Date",TODAY);
                            //DailyMenu.SETRANGE(DailyMenu.Type,DailyMenu.Type::Student);
                            if DailyMenu.Find('-') then
                            begin
                              if DailyMenu."Remaining Qty"<1 then begin
                               // ERROR('The Selected Menu Item is Out Of Stock')
                               end
                              else begin
                                "Unit Cost":=DailyMenu."Unit Cost";
                                Quantity:=1;
                                Amount:=DailyMenu."Unit Cost";
                                Description:=DailyMenu.Description;
                              end;
                            end;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                            Amount:=Quantity*"Unit Cost";
                    end;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                    Editable = false;
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

