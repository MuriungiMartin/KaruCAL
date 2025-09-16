#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69151 "FLT-Approved  Maintenance Req"
{
    PageType = List;
    SourceTable = UnknownTable61803;
    SourceTableView = order(ascending)
                      where(Type=filter(Maintenance),
                            Status=filter(Approved));

    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                field("Quantity of Fuel(Litres)";"Quantity of Fuel(Litres)")
                {
                    ApplicationArea = Basic;
                }
                field("Total Price of Fuel";"Total Price of Fuel")
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
                field("Date Taken for Fueling";"Date Taken for Fueling")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Prepared By";"Prepared By")
                {
                    ApplicationArea = Basic;
                }
                field("Closed By";"Closed By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Invoice No";"Vendor Invoice No")
                {
                    ApplicationArea = Basic;
                }
                field("Posted Invoice No";"Posted Invoice No")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Name";"Vendor Name")
                {
                    ApplicationArea = Basic;
                }
                field("Date Taken for Maintenance";"Date Taken for Maintenance")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Type of Maintenance";"Type of Maintenance")
                {
                    ApplicationArea = Basic;
                }
                field(Driver;Driver)
                {
                    ApplicationArea = Basic;
                }
                field("Driver Name";"Driver Name")
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Asset No";"Fixed Asset No")
                {
                    ApplicationArea = Basic;
                }
                field("Litres of Oil";"Litres of Oil")
                {
                    ApplicationArea = Basic;
                }
                field("Quote No";"Quote No")
                {
                    ApplicationArea = Basic;
                }
                field("Price/Litre";"Price/Litre")
                {
                    ApplicationArea = Basic;
                }
                field("Type of Fuel";"Type of Fuel")
                {
                    ApplicationArea = Basic;
                }
                field(Coolant;Coolant)
                {
                    ApplicationArea = Basic;
                }
                field("Battery Water";"Battery Water")
                {
                    ApplicationArea = Basic;
                }
                field("Wheel Alignment";"Wheel Alignment")
                {
                    ApplicationArea = Basic;
                }
                field("Wheel Balancing";"Wheel Balancing")
                {
                    ApplicationArea = Basic;
                }
                field("Car Wash";"Car Wash")
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

