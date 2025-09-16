#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69121 "FLT-Vehicle Card List"
{
    CardPageID = "FLT-Vehicle Card";
    PageType = List;
    SourceTable = UnknownTable61816;

    layout
    {
        area(content)
        {
            repeater(General)
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
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
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
                field("Maintenance Vendor No.";"Maintenance Vendor No.")
                {
                    ApplicationArea = Basic;
                }
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
        }
    }

    actions
    {
        area(creation)
        {
            action(MentSche)
            {
                ApplicationArea = Basic;
                Caption = 'Maintenance Schedule';
                Image = ResourceSetup;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    FLTMaintenanceReqHeader.Reset;
                    FLTMaintenanceReqHeader.SetRange("Vehicle Registration",Rec."Registration No.");
                    if FLTMaintenanceReqHeader.Find('-') then
                    Report.Run(55511,true,false,FLTMaintenanceReqHeader);
                end;
            }
            action("Fuel Analysis")
            {
                ApplicationArea = Basic;
                Image = Allocate;

                trigger OnAction()
                begin
                    Report.Run(51869,true);
                end;
            }
        }
    }

    var
        FLTMaintenanceReqHeader: Record UnknownRecord55517;
}

