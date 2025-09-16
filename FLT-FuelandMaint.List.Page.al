#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69110 "FLT-Fuel and Maint. List"
{
    PageType = List;
    SourceTable = UnknownTable61803;
    SourceTableView = order(ascending)
                      where(Status=filter(Approved));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Requisition No";"Requisition No")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Reg No";"Vehicle Reg No")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor(Dealer)";"Vendor(Dealer)")
                {
                    ApplicationArea = Basic;
                }
                field("Odometer Reading";"Odometer Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Request Date";"Request Date")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity of Fuel(Litres)";"Quantity of Fuel(Litres)")
                {
                    ApplicationArea = Basic;
                }
                field("Total Price of Fuel";"Total Price of Fuel")
                {
                    ApplicationArea = Basic;
                }
                field("Date Taken for Fueling";"Date Taken for Fueling")
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

