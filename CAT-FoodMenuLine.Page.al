#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68296 "CAT-Food Menu Line"
{
    Editable = true;
    PageType = CardPart;
    SourceTable = UnknownTable61168;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Item No";"Item No")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                           Item.SetRange(Item."No.","Item No");
                           if Item.Find('-') then
                           begin
                            Description:=Item.Description;
                            Units:=Item."Base Unit of Measure";
                            "Unit Cost":=Item."Last Direct Cost";
                            Location:='kitchen';
                           end;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                           "Total Cost":="Unit Cost"*Quantity;
                    end;
                }
                field(Units;Units)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                           "Total Cost":="Unit Cost"*Quantity;
                    end;
                }
                field("Total Cost";"Total Cost")
                {
                    ApplicationArea = Basic;
                }
                field(Menu;Menu)
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
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
        Item: Record Item;
}

