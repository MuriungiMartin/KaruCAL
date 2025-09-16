#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 15 "Location List"
{
    ApplicationArea = Basic;
    Caption = 'Location List';
    CardPageID = "Location Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = Location;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a location code for the warehouse or distribution center where your items are handled and stored before being sold.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name or address of the location.';
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
                    RunObject = Page Zones;
                    RunPageLink = "Location Code"=field(Code);
                }
                action("&Bins")
                {
                    ApplicationArea = Basic;
                    Caption = '&Bins';
                    Image = Bins;
                    RunObject = Page Bins;
                    RunPageLink = "Location Code"=field(Code);
                }
            }
        }
        area(creation)
        {
            action("Transfer Order")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Transfer Order";
                RunPageMode = Create;
            }
        }
        area(processing)
        {
            action("Create Warehouse location")
            {
                ApplicationArea = Basic;
                Caption = 'Create Warehouse location';
                Image = NewWarehouse;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Create Warehouse Location";
            }
            action(AssignTaxArea)
            {
                ApplicationArea = Basic;
                Caption = 'Assign Tax Area';
                Image = RefreshText;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Report "Assign Tax Area to Location";
            }
        }
        area(reporting)
        {
            action("Inventory - Inbound Transfer")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - Inbound Transfer';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Inbound Transfer";
            }
            action(Action1907283206)
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Order';
                Image = Document;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Transfer Order";
            }
            action("Transfer Shipment")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Shipment';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Transfer Shipment";
            }
            action("Transfer Receipt")
            {
                ApplicationArea = Basic;
                Caption = 'Transfer Receipt';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Transfer Receipt";
            }
            action("Check on Negative Inventory")
            {
                ApplicationArea = Basic;
                Caption = 'Check on Negative Inventory';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Items with Negative Inventory";
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        Loc: Record Location;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Loc);
        exit(SelectionFilterManagement.GetSelectionFilterForLocation(Loc));
    end;
}

