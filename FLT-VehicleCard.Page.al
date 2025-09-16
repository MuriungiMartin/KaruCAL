#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69118 "FLT-Vehicle Card"
{
    PageType = Card;
    SourceTable = UnknownTable61816;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic;
                }
                field("Responsible Employee";"Responsible Employee")
                {
                    ApplicationArea = Basic;
                }
                field("LogBook No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'LogBook No.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(Inactive;Inactive)
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Last Service Date";"Last Service Date")
                {
                    ApplicationArea = Basic;
                }
                field("Service Interval";"Service Interval")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Posting)
            {
                field("FA Class Code";"FA Class Code")
                {
                    ApplicationArea = Basic;
                }
                field("FA Subclass Code";"FA Subclass Code")
                {
                    ApplicationArea = Basic;
                }
                field("FA Location Code";"FA Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Budgeted Asset";"Budgeted Asset")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Maintenance)
            {
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Maintenance Vendor No.";"Maintenance Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Next Service Date";"Next Service Date")
                {
                    ApplicationArea = Basic;
                }
                field("Warranty Date";"Warranty Date")
                {
                    ApplicationArea = Basic;
                }
                field(Insured;Insured)
                {
                    ApplicationArea = Basic;
                }
                field("Under Maintenance";"Under Maintenance")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Vehicle Details")
            {
                field(Make;Make)
                {
                    ApplicationArea = Basic;
                }
                field(Model;Model)
                {
                    ApplicationArea = Basic;
                }
                field("Year Of Manufacture";"Year Of Manufacture")
                {
                    ApplicationArea = Basic;
                }
                field("Country Of Origin";"Country Of Origin")
                {
                    ApplicationArea = Basic;
                }
                field(Ownership;Ownership)
                {
                    ApplicationArea = Basic;
                }
                field("Body Color";"Body Color")
                {
                    ApplicationArea = Basic;
                }
                field("Interior Color";"Interior Color")
                {
                    ApplicationArea = Basic;
                }
                field("Registration No.";"Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field("Chassis Serial No.";"Chassis Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("Engine Serial No.";"Engine Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field("Ignition Key Code";"Ignition Key Code")
                {
                    ApplicationArea = Basic;
                }
                field("Door Key Code";"Door Key Code")
                {
                    ApplicationArea = Basic;
                }
                field("Tare Weight";"Tare Weight")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Drive train")
            {
                field("Horse Power";"Horse Power")
                {
                    ApplicationArea = Basic;
                }
                field(Cylinders;Cylinders)
                {
                    ApplicationArea = Basic;
                }
                field("Tire Size Rear";"Tire Size Rear")
                {
                    ApplicationArea = Basic;
                }
                field("Tire Size Front";"Tire Size Front")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Mileage/Hrs Worded Details")
            {
                field("Readings Based On";"Readings Based On")
                {
                    ApplicationArea = Basic;
                }
                field("Start Reading";"Start Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Current Reading";"Current Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Fuel Type";"Fuel Type")
                {
                    ApplicationArea = Basic;
                }
                field("Fuel Rating (CC)";"Fuel Rating (CC)")
                {
                    ApplicationArea = Basic;
                }
                field("Total Consumption";"Total Consumption")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Open_Travel)
            {
                ApplicationArea = Basic;
                Caption = 'Open Travel Requests';
                Image = ResourceSetup;
                Promoted = true;
                RunObject = Page "FLT-Approved Transport Req.";
                RunPageLink = "Vehicle Allocated"=field("Registration No.");
            }
            action(Open_Maint)
            {
                ApplicationArea = Basic;
                Caption = 'Open Maintenance/Fuel Requests';
                Image = History;
                Promoted = true;
                RunObject = Page "FLT-Fuel and Maint. List";
                RunPageLink = "Vehicle Reg No"=field("Registration No.");
            }
        }
    }
}

