#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68306 "CAT-Daily menu List Staff"
{
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61169;
    SourceTableView = where(Posted=const(Yes),
                            Type=const(Staff));

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Menu;Menu)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Units;Units)
                {
                    ApplicationArea = Basic;
                }
                field("Total Qty";"Total Qty")
                {
                    ApplicationArea = Basic;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field("Remaining Qty";"Remaining Qty")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
             Rec.SetRange("Menu Date",Today) ;
    end;
}

