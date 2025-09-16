#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5703 "Location Card"
{
    Caption = 'Location Card';
    PageType = Card;
    SourceTable = Location;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name or address of the location.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location address.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional line of the location address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the location.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region of the location.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person to whom items for the location will be shipped.';
                }
                field("Use As In-Transit";"Use As In-Transit")
                {
                    ApplicationArea = Basic;
                    Editable = EditInTransit;
                    ToolTip = 'Specifies this location is an in-transit location.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Do Not Use For Tax Calculation";"Do Not Use For Tax Calculation")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Here you can specify whether the tax information included on this location record will be used for Sales Tax calculations on purchase documents.';
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Here you can specify the tax area code for this location.';
                }
                field("Tax Exemption No.";"Tax Exemption No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the company''s tax exemption number. If the company has been registered exempt for sales and use tax this number would have been assigned by the taxing authority.';
                }
                field("Provincial Tax Area Code";"Provincial Tax Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the tax area code for self assessed Provincial Sales Tax for the company.';
                }
                field(UserID;UserID)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the telephone number of the location.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fax number of the location.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the email address of the location.';
                }
                field("Home Page";"Home Page")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the home page address of the location.';
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                field("Require Receive";"Require Receive")
                {
                    ApplicationArea = Basic;
                    Enabled = RequireReceiveEnable;
                    ToolTip = 'Specifies whether you require the location to use the Receive function on the Warehouse Management menu.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Require Shipment";"Require Shipment")
                {
                    ApplicationArea = Basic;
                    Enabled = RequireShipmentEnable;
                    ToolTip = 'Specifies whether you require the location to use the Shipment function on the Warehouse Management menu.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Require Put-away";"Require Put-away")
                {
                    ApplicationArea = Basic;
                    Enabled = RequirePutAwayEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether you must perform put-away activities in the warehouse at this location.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Use Put-away Worksheet";"Use Put-away Worksheet")
                {
                    ApplicationArea = Basic;
                    Enabled = UsePutAwayWorksheetEnable;
                    ToolTip = 'Specifies that put-always are not created for direct action by warehouse employees, when you post a warehouse receipt.';
                }
                field("Require Pick";"Require Pick")
                {
                    ApplicationArea = Basic;
                    Enabled = RequirePickEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether you must perform pick activities in the warehouse at this location.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Bin Mandatory";"Bin Mandatory")
                {
                    ApplicationArea = Basic;
                    Enabled = BinMandatoryEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies that this location should use bins in all transactions with items.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Directed Put-away and Pick";"Directed Put-away and Pick")
                {
                    ApplicationArea = Basic;
                    Enabled = DirectedPutawayandPickEnable;
                    ToolTip = 'Specifies if you require the location to use advanced warehouse functionality, such as calculated bin suggestion.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Use ADCS";"Use ADCS")
                {
                    ApplicationArea = Basic;
                    Enabled = UseADCSEnable;
                    ToolTip = 'Specifies the automatic data capture system that warehouse employees must use to keep track of items within the warehouse.';
                }
                field("Default Bin Selection";"Default Bin Selection")
                {
                    ApplicationArea = Basic;
                    Enabled = DefaultBinSelectionEnable;
                    ToolTip = 'Specifies the method used to select the default bin.';
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Enabled = OutboundWhseHandlingTimeEnable;
                    ToolTip = 'Specifies a date formula for the outbound warehouse handling time for the location.';
                }
                field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Enabled = InboundWhseHandlingTimeEnable;
                    ToolTip = 'Specifies a date formula for the inbound warehouse handling time for the location.';
                }
                field("Base Calendar Code";"Base Calendar Code")
                {
                    ApplicationArea = Basic;
                    Enabled = BaseCalendarCodeEnable;
                    ToolTip = 'Specifies the code for the base calendar you want to assign to your location.';
                }
                field("Customized Calendar";CalendarMgmt.CustomizedCalendarExistText(CustomizedCalendar."source type"::Location,Code,'',"Base Calendar Code"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Customized Calendar';
                    Editable = false;
                    ToolTip = 'Indicates whether you have set up a customized calendar for the location.';

                    trigger OnDrillDown()
                    begin
                        CurrPage.SaveRecord;
                        TestField("Base Calendar Code");
                        CalendarMgmt.ShowCustomizedCalendar(
                          CustomizedCalEntry."source type"::Location,Code,'',"Base Calendar Code");
                    end;
                }
                field("Use Cross-Docking";"Use Cross-Docking")
                {
                    ApplicationArea = Basic;
                    Enabled = UseCrossDockingEnable;
                    ToolTip = 'Specifies if you want to activate the cross-docking functionality at the location.';

                    trigger OnValidate()
                    begin
                        UpdateEnabled;
                    end;
                }
                field("Cross-Dock Due Date Calc.";"Cross-Dock Due Date Calc.")
                {
                    ApplicationArea = Basic;
                    Enabled = CrossDockDueDateCalcEnable;
                    ToolTip = 'Specifies the cross-dock due date calculation.';
                }
            }
            group(Bins)
            {
                Caption = 'Bins';
                group(Receipt)
                {
                    Caption = 'Receipt';
                    field("Receipt Bin Code";"Receipt Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = ReceiptBinCodeEnable;
                        Importance = Promoted;
                        ToolTip = 'Specifies the default receipt bin code.';
                    }
                }
                group(Shipment)
                {
                    Caption = 'Shipment';
                    field("Shipment Bin Code";"Shipment Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = ShipmentBinCodeEnable;
                        Importance = Promoted;
                        ToolTip = 'Specifies the default shipment bin code.';
                    }
                }
                group(Production)
                {
                    Caption = 'Production';
                    field("Open Shop Floor Bin Code";"Open Shop Floor Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = OpenShopFloorBinCodeEnable;
                        ToolTip = 'Specifies the bin that functions as the default open shop floor bin at this location.';
                    }
                    field("To-Production Bin Code";"To-Production Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = ToProductionBinCodeEnable;
                        ToolTip = 'Specifies the bin in the production area where components picked for production are placed by default, before they can be consumed.';
                    }
                    field("From-Production Bin Code";"From-Production Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = FromProductionBinCodeEnable;
                        ToolTip = 'Specifies the bin in the production area, where finished end items are taken from by default, when the process involves warehouse activity.';
                    }
                }
                group(Adjustment)
                {
                    Caption = 'Adjustment';
                    field("Adjustment Bin Code";"Adjustment Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = AdjustmentBinCodeEnable;
                        ToolTip = 'Specifies the code of the bin in which you record observed differences in inventory quantities.';
                    }
                }
                group("Cross-Dock")
                {
                    Caption = 'Cross-Dock';
                    field("Cross-Dock Bin Code";"Cross-Dock Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = CrossDockBinCodeEnable;
                        ToolTip = 'Specifies the bin code that is used as default for the receipt of items to be cross-docked.';
                    }
                }
                group(Assembly)
                {
                    Caption = 'Assembly';
                    field("To-Assembly Bin Code";"To-Assembly Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = ToAssemblyBinCodeEnable;
                        ToolTip = 'Specifies the bin in the assembly area where components are placed by default before they can be consumed in assembly.';
                    }
                    field("From-Assembly Bin Code";"From-Assembly Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = FromAssemblyBinCodeEnable;
                        ToolTip = 'Specifies the bin in the assembly area where finished assembly items are posted to when they are assembled to stock.';
                    }
                    field("Asm.-to-Order Shpt. Bin Code";"Asm.-to-Order Shpt. Bin Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = AssemblyShipmentBinCodeEnable;
                        ToolTip = 'Specifies the bin where finished assembly items are posted to when they are assembled to a linked sales order.';
                    }
                }
            }
            group("Bin Policies")
            {
                Caption = 'Bin Policies';
                field("Special Equipment";"Special Equipment")
                {
                    ApplicationArea = Basic;
                    Enabled = SpecialEquipmentEnable;
                    ToolTip = 'Indicates where the program will first look for a special equipment designation for warehouse activities.';
                }
                field("Bin Capacity Policy";"Bin Capacity Policy")
                {
                    ApplicationArea = Basic;
                    Enabled = BinCapacityPolicyEnable;
                    Importance = Promoted;
                    ToolTip = 'Defines how bins are automatically filled, according to their capacity.';
                }
                field("Allow Breakbulk";"Allow Breakbulk")
                {
                    ApplicationArea = Basic;
                    Enabled = AllowBreakbulkEnable;
                    ToolTip = 'Specifies the order is met with items stored in alternate units of measure, if an item stored in the requested unit of measure is not found.';
                }
                group("Put-away")
                {
                    Caption = 'Put-away';
                    field("Put-away Template Code";"Put-away Template Code")
                    {
                        ApplicationArea = Basic;
                        Enabled = PutAwayTemplateCodeEnable;
                        ToolTip = 'Specifies the code of the put-away template used for the location.';
                    }
                    field("Always Create Put-away Line";"Always Create Put-away Line")
                    {
                        ApplicationArea = Basic;
                        Enabled = AlwaysCreatePutawayLineEnable;
                        ToolTip = 'Specifies that a put-away line is created, even if an appropriate zone and bin in which to place the items cannot be found.';
                    }
                }
                group(Pick)
                {
                    Caption = 'Pick';
                    field("Always Create Pick Line";"Always Create Pick Line")
                    {
                        ApplicationArea = Basic;
                        Enabled = AlwaysCreatePickLineEnable;
                        ToolTip = 'Specifies that a pick line is created, even if an appropriate zone and bin from which to pick the item cannot be found.';
                    }
                    field("Pick According to FEFO";"Pick According to FEFO")
                    {
                        ApplicationArea = Basic;
                        Enabled = PickAccordingToFEFOEnable;
                        Importance = Promoted;
                        ToolTip = 'Specifies whether to use the First-Expired-First-Out (FEFO) method to determine which items to pick, according to expiration dates.';
                    }
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Location")
            {
                Caption = '&Location';
                Image = Warehouse;
                action("&Resource Locations")
                {
                    ApplicationArea = Basic;
                    Caption = '&Resource Locations';
                    Image = Resource;
                    RunObject = Page "Resource Locations";
                    RunPageLink = "Location Code"=field(Code);
                }
                separator(Action7301)
                {
                }
                action("&Zones")
                {
                    ApplicationArea = Basic;
                    Caption = '&Zones';
                    Image = Zones;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Zones;
                    RunPageLink = "Location Code"=field(Code);
                }
                action("&Bins")
                {
                    ApplicationArea = Basic;
                    Caption = '&Bins';
                    Image = Bins;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page Bins;
                    RunPageLink = "Location Code"=field(Code);
                }
                separator(Action97)
                {
                }
                action("Online Map")
                {
                    ApplicationArea = Basic;
                    Caption = 'Online Map';
                    Image = Map;

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateEnabled;
        TransitValidation;
    end;

    trigger OnInit()
    begin
        UseCrossDockingEnable := true;
        UsePutAwayWorksheetEnable := true;
        BinMandatoryEnable := true;
        RequireShipmentEnable := true;
        RequireReceiveEnable := true;
        RequirePutAwayEnable := true;
        RequirePickEnable := true;
        DefaultBinSelectionEnable := true;
        UseADCSEnable := true;
        DirectedPutawayandPickEnable := true;
        CrossDockBinCodeEnable := true;
        PickAccordingToFEFOEnable := true;
        AdjustmentBinCodeEnable := true;
        ShipmentBinCodeEnable := true;
        ReceiptBinCodeEnable := true;
        FromProductionBinCodeEnable := true;
        ToProductionBinCodeEnable := true;
        OpenShopFloorBinCodeEnable := true;
        ToAssemblyBinCodeEnable := true;
        FromAssemblyBinCodeEnable := true;
        AssemblyShipmentBinCodeEnable := true;
        CrossDockDueDateCalcEnable := true;
        AlwaysCreatePutawayLineEnable := true;
        AlwaysCreatePickLineEnable := true;
        PutAwayTemplateCodeEnable := true;
        AllowBreakbulkEnable := true;
        SpecialEquipmentEnable := true;
        BinCapacityPolicyEnable := true;
        BaseCalendarCodeEnable := true;
        InboundWhseHandlingTimeEnable := true;
        OutboundWhseHandlingTimeEnable := true;
        EditInTransit := true;
    end;

    var
        CustomizedCalEntry: Record "Customized Calendar Entry";
        CustomizedCalendar: Record "Customized Calendar Change";
        CalendarMgmt: Codeunit "Calendar Management";
        [InDataSet]
        OutboundWhseHandlingTimeEnable: Boolean;
        [InDataSet]
        InboundWhseHandlingTimeEnable: Boolean;
        [InDataSet]
        BaseCalendarCodeEnable: Boolean;
        [InDataSet]
        BinCapacityPolicyEnable: Boolean;
        [InDataSet]
        SpecialEquipmentEnable: Boolean;
        [InDataSet]
        AllowBreakbulkEnable: Boolean;
        [InDataSet]
        PutAwayTemplateCodeEnable: Boolean;
        [InDataSet]
        AlwaysCreatePickLineEnable: Boolean;
        [InDataSet]
        AlwaysCreatePutawayLineEnable: Boolean;
        [InDataSet]
        CrossDockDueDateCalcEnable: Boolean;
        [InDataSet]
        OpenShopFloorBinCodeEnable: Boolean;
        [InDataSet]
        ToProductionBinCodeEnable: Boolean;
        [InDataSet]
        FromProductionBinCodeEnable: Boolean;
        [InDataSet]
        ReceiptBinCodeEnable: Boolean;
        [InDataSet]
        ShipmentBinCodeEnable: Boolean;
        [InDataSet]
        AdjustmentBinCodeEnable: Boolean;
        [InDataSet]
        ToAssemblyBinCodeEnable: Boolean;
        [InDataSet]
        FromAssemblyBinCodeEnable: Boolean;
        AssemblyShipmentBinCodeEnable: Boolean;
        [InDataSet]
        PickAccordingToFEFOEnable: Boolean;
        [InDataSet]
        CrossDockBinCodeEnable: Boolean;
        [InDataSet]
        DirectedPutawayandPickEnable: Boolean;
        [InDataSet]
        UseADCSEnable: Boolean;
        [InDataSet]
        DefaultBinSelectionEnable: Boolean;
        [InDataSet]
        RequirePickEnable: Boolean;
        [InDataSet]
        RequirePutAwayEnable: Boolean;
        [InDataSet]
        RequireReceiveEnable: Boolean;
        [InDataSet]
        RequireShipmentEnable: Boolean;
        [InDataSet]
        BinMandatoryEnable: Boolean;
        [InDataSet]
        UsePutAwayWorksheetEnable: Boolean;
        [InDataSet]
        UseCrossDockingEnable: Boolean;
        [InDataSet]
        EditInTransit: Boolean;

    local procedure UpdateEnabled()
    begin
        RequirePickEnable := not "Use As In-Transit" and not "Directed Put-away and Pick";
        RequirePutAwayEnable := not "Use As In-Transit" and not "Directed Put-away and Pick";
        RequireReceiveEnable := not "Use As In-Transit" and not "Directed Put-away and Pick";
        RequireShipmentEnable := not "Use As In-Transit" and not "Directed Put-away and Pick";
        OutboundWhseHandlingTimeEnable := not "Use As In-Transit";
        InboundWhseHandlingTimeEnable := not "Use As In-Transit";
        BinMandatoryEnable := not "Use As In-Transit" and not "Directed Put-away and Pick";
        DirectedPutawayandPickEnable := not "Use As In-Transit" and "Bin Mandatory";
        BaseCalendarCodeEnable := not "Use As In-Transit";

        BinCapacityPolicyEnable := "Directed Put-away and Pick";
        SpecialEquipmentEnable := "Directed Put-away and Pick";
        AllowBreakbulkEnable := "Directed Put-away and Pick";
        PutAwayTemplateCodeEnable := "Directed Put-away and Pick";
        UsePutAwayWorksheetEnable :=
          "Directed Put-away and Pick" or ("Require Put-away" and "Require Receive" and not "Use As In-Transit");
        AlwaysCreatePickLineEnable := "Directed Put-away and Pick";
        AlwaysCreatePutawayLineEnable := "Directed Put-away and Pick";

        UseCrossDockingEnable := not "Use As In-Transit" and "Require Receive" and "Require Shipment" and "Require Put-away" and
          "Require Pick";
        CrossDockDueDateCalcEnable := "Use Cross-Docking";

        OpenShopFloorBinCodeEnable := "Bin Mandatory";
        ToProductionBinCodeEnable := "Bin Mandatory";
        FromProductionBinCodeEnable := "Bin Mandatory";
        ReceiptBinCodeEnable := "Bin Mandatory" and "Require Receive";
        ShipmentBinCodeEnable := "Bin Mandatory" and "Require Shipment";
        AdjustmentBinCodeEnable := "Directed Put-away and Pick";
        CrossDockBinCodeEnable := "Bin Mandatory" and "Use Cross-Docking";
        ToAssemblyBinCodeEnable := "Bin Mandatory";
        FromAssemblyBinCodeEnable := "Bin Mandatory";
        AssemblyShipmentBinCodeEnable := "Bin Mandatory" and not ShipmentBinCodeEnable;
        DefaultBinSelectionEnable := "Bin Mandatory" and not "Directed Put-away and Pick";
        UseADCSEnable := not "Use As In-Transit" and "Directed Put-away and Pick";
        PickAccordingToFEFOEnable := "Require Pick" and "Bin Mandatory";
    end;

    local procedure TransitValidation()
    var
        TransferHeader: Record "Transfer Header";
    begin
        TransferHeader.SetFilter("In-Transit Code",Code);
        EditInTransit := TransferHeader.IsEmpty;
    end;
}

