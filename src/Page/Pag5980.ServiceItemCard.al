#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5980 "Service Item Card"
{
    Caption = 'Service Item Card';
    PageType = Card;
    SourceTable = "Service Item";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Contains the number of the item.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Contains a description of this item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Contains the item number linked to the service item.';

                    trigger OnValidate()
                    begin
                        CalcFields("Item Description");
                    end;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the description of the item that the service item is linked to.';
                }
                field("Service Item Group Code";"Service Item Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the code of the service item group associated with this item.';
                }
                field("Service Price Group Code";"Service Price Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the code of the Service Price Group associated with this item.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the variant code for this item.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    AssistEdit = true;
                    ToolTip = 'Contains the serial number of this item.';

                    trigger OnAssistEdit()
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        Clear(ItemLedgerEntry);
                        ItemLedgerEntry.FilterGroup(2);
                        ItemLedgerEntry.SetRange("Item No.","Item No.");
                        if "Variant Code" <> '' then
                          ItemLedgerEntry.SetRange("Variant Code","Variant Code");
                        ItemLedgerEntry.SetFilter("Serial No.",'<>%1','');
                        ItemLedgerEntry.FilterGroup(0);

                        if Page.RunModal(0,ItemLedgerEntry) = Action::LookupOK then
                          Validate("Serial No.",ItemLedgerEntry."Serial No.");
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Contains the status of the service item.';
                }
                field("Service Item Components";"Service Item Components")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that there is a component for this service item.';
                }
                field("Search Description";"Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate description to search for the service item.';
                }
                field("Response Time (Hours)";"Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the estimated number of hours this item requires before service on it should be started.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service priority for this item.';
                }
                field("Last Service Date";"Last Service Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date of the last service on this item.';
                }
                field("Warranty Starting Date (Parts)";"Warranty Starting Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the starting date of the spare parts warranty for this item.';
                }
                field("Warranty Ending Date (Parts)";"Warranty Ending Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the ending date of the spare parts warranty for this item.';
                }
                field("Warranty % (Parts)";"Warranty % (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the percentage of spare parts costs covered by the warranty for the item.';
                }
                field("Warranty Starting Date (Labor)";"Warranty Starting Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the starting date of the labor warranty for this item.';
                }
                field("Warranty Ending Date (Labor)";"Warranty Ending Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the ending date of the labor warranty for this item.';
                }
                field("Warranty % (Labor)";"Warranty % (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the percentage of labor costs covered by the warranty for this item.';
                }
                field("Preferred Resource";"Preferred Resource")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the resource that the customer prefers for servicing of the item.';
                }
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Contains the number of the customer who owns this item.';

                    trigger OnValidate()
                    begin
                        CalcFields(Name,"Name 2",Address,"Address 2","Post Code",
                          City,Contact,"Phone No.",County,"Country/Region Code");
                        CustomerNoOnAfterValidate;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Importance = Promoted;
                    ToolTip = 'Contains the name of the customer who owns this item.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the address of the customer who owns this item.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Specifies an additional line of the address.';
                }
                field(City;City)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the city of the customer address.';
                }
                field(County;County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the ZIP code of the address.';
                }
                field(Contact;Contact)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Importance = Promoted;
                    ToolTip = 'Contains the name of the person you regularly contact when you do business with the customer who owns this item.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the customer phone number.';
                }
                field("Location of Service Item";"Location of Service Item")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Contains the code of the location of this item.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Contains the ship-to code for the customer who owns this item.';

                    trigger OnValidate()
                    begin
                        UpdateShipToCode;
                    end;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the name at the address.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the address where this service item is located.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains an additional line of the address.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the city of the address.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Importance = Promoted;
                    ToolTip = 'Contains the ZIP code of the address.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Importance = Promoted;
                    ToolTip = 'Contains the name of a contact person for the address.';
                }
                field("Ship-to Phone No.";"Ship-to Phone No.")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the telephone number for the address.';
                }
            }
            group(Contract)
            {
                Caption = 'Contract';
                field("Default Contract Cost";"Default Contract Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the default contract cost of a service item that later will be included in a service contract or contract quote.';
                }
                field("Default Contract Value";"Default Contract Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the default contract value of an item that later will be included in a service contract or contract quote.';
                }
                field("Default Contract Discount %";"Default Contract Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a default contract discount percentage for an item, if this item will be part of a service contract.';
                }
                field("Service Contracts";"Service Contracts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this service item is associated with one or more service contracts/quotes.';
                }
            }
            group(Vendor)
            {
                Caption = 'Vendor';
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the vendor for this item.';

                    trigger OnValidate()
                    begin
                        CalcFields("Vendor Name");
                    end;
                }
                field("Vendor Name";"Vendor Name")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    ToolTip = 'Contains the vendor name for this item.';
                }
                field("Vendor Item No.";"Vendor Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number assigned to this service item by its vendor.';
                }
                field("Vendor Item Name";"Vendor Item Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the name assigned to this item by the vendor.';
                }
            }
            group(Detail)
            {
                Caption = 'Detail';
                field("Sales Unit Cost";"Sales Unit Cost")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the unit cost of this item when it was sold.';
                }
                field("Sales Unit Price";"Sales Unit Price")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the unit price of this item when it was sold.';
                }
                field("Sales Date";"Sales Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the date when this item was sold.';
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the code of the unit of measure used when this item was sold.';
                }
                field("Installation Date";"Installation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the date when this item was installed at the customer''s site.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1900316107;"Customer Details FactBox")
            {
                SubPageLink = "No."=field("Customer No."),
                              "Date Filter"=field("Date Filter");
                Visible = true;
            }
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Service Item")
            {
                Caption = '&Service Item';
                Image = ServiceItem;
                separator(Action123)
                {
                }
                action("&Components")
                {
                    ApplicationArea = Basic;
                    Caption = '&Components';
                    Image = Components;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Item Component List";
                    RunPageLink = Active=const(true),
                                  "Parent Service Item No."=field("No.");
                    RunPageView = sorting(Active,"Parent Service Item No.","Line No.");
                }
                action("&Dimensions")
                {
                    ApplicationArea = Basic;
                    Caption = '&Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(5940),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action39)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Service Item Statistics";
                        RunPageLink = "No."=field("No.");
                        ShortCutKey = 'F7';
                    }
                    action("Tr&endscape")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Tr&endscape';
                        Image = Trendscape;
                        RunObject = Page "Service Item Trendscape";
                        RunPageLink = "No."=field("No.");
                    }
                }
                group(Troubleshooting)
                {
                    Caption = 'Troubleshooting';
                    Image = Troubleshoot;
                    action("Troubleshooting Setup")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Troubleshooting Setup';
                        Image = Troubleshoot;
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=const("Service Item"),
                                      "No."=field("No.");
                    }
                    action("<Page Troubleshooting>")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Troubleshooting';
                        Image = Troubleshoot;

                        trigger OnAction()
                        var
                            TroubleshootingHeader: Record "Troubleshooting Header";
                        begin
                            TroubleshootingHeader.ShowForServItem(Rec);
                        end;
                    }
                    separator(Action128)
                    {
                        Caption = '';
                    }
                }
                action("Resource Skills")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Skills';
                    Image = ResourceSkills;
                    RunObject = Page "Resource Skills";
                    RunPageLink = Type=const("Service Item"),
                                  "No."=field("No.");
                }
                action("S&killed Resources")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&killed Resources';
                    Image = ResourceSkills;

                    trigger OnAction()
                    begin
                        Clear(SkilledResourceList);
                        SkilledResourceList.Initialize(ResourceSkill.Type::"Service Item","No.",Description);
                        SkilledResourceList.RunModal;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const("Service Item"),
                                  "Table Subtype"=const(0),
                                  "No."=field("No.");
                }
                separator(Action131)
                {
                    Caption = '';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                group("S&ervice Orders")
                {
                    Caption = 'S&ervice Orders';
                    Image = "Order";
                    action("&Item Lines")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Item Lines';
                        Image = ItemLines;
                        RunObject = Page "Service Item Lines";
                        RunPageLink = "Service Item No."=field("No.");
                        RunPageView = sorting("Service Item No.");
                    }
                    action("&Service Lines")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Service Lines';
                        Image = ServiceLines;
                        RunObject = Page "Service Line List";
                        RunPageLink = "Service Item No."=field("No.");
                        RunPageView = sorting("Service Item No.");
                    }
                }
                group("Service Shi&pments")
                {
                    Caption = 'Service Shi&pments';
                    Image = Shipment;
                    action(Action117)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Item Lines';
                        Image = ItemLines;
                        RunObject = Page "Posted Shpt. Item Line List";
                        RunPageLink = "Service Item No."=field("No.");
                        RunPageView = sorting("Service Item No.");
                    }
                    action(Action113)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Service Lines';
                        Image = ServiceLines;
                        RunObject = Page "Posted Serv. Shpt. Line List";
                        RunPageLink = "Service Item No."=field("No.");
                        RunPageView = sorting("Service Item No.");
                    }
                }
                action("Ser&vice Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Serv. Contr. List (Serv. Item)";
                    RunPageLink = "Service Item No."=field("No.");
                    RunPageView = sorting("Service Item No.","Contract Status");
                }
                separator(Action126)
                {
                    Caption = '';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Service Item Lo&g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Item Lo&g';
                    Image = Log;
                    RunObject = Page "Service Item Log";
                    RunPageLink = "Service Item No."=field("No.");
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Item No. (Serviced)"=field("No."),
                                  "Service Order No."=field("Service Order Filter"),
                                  "Service Contract No."=field("Contract Filter"),
                                  "Posting Date"=field("Date Filter");
                    RunPageView = sorting("Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.",Type,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Item No. (Serviced)"=field("No.");
                    RunPageView = sorting("Service Item No. (Serviced)","Posting Date","Document No.");
                }
                separator(Action127)
                {
                    Caption = '';
                }
            }
        }
        area(processing)
        {
            group(New)
            {
                Caption = 'New';
                Image = NewItem;
                action("New Item")
                {
                    ApplicationArea = Basic;
                    Caption = 'New Item';
                    Image = NewItem;
                    Promoted = true;
                    PromotedCategory = New;
                    RunObject = Page "Item Card";
                    RunPageMode = Create;
                }
            }
        }
        area(reporting)
        {
            action("Service Line Item Label")
            {
                ApplicationArea = Basic;
                Caption = 'Service Line Item Label';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Service Item Line Labels";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        UpdateShipToCode;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if "Item No." = '' then
          if GetFilter("Item No.") <> '' then
            if GetRangeMin("Item No.") = GetRangemax("Item No.") then
              "Item No." := GetRangeMin("Item No.");

        if "Customer No." = '' then
          if GetFilter("Customer No.") <> '' then
            if GetRangeMin("Customer No.") = GetRangemax("Customer No.") then
              "Customer No." := GetRangeMin("Customer No.");
    end;

    var
        ResourceSkill: Record "Resource Skill";
        SkilledResourceList: Page "Skilled Resource List";

    local procedure UpdateShipToCode()
    begin
        if "Ship-to Code" = '' then begin
          "Ship-to Name" := Name;
          "Ship-to Address" := Address;
          "Ship-to Address 2" := "Address 2";
          "Ship-to Post Code" := "Post Code";
          "Ship-to City" := City;
          "Ship-to County" := County;
          "Ship-to Phone No." := "Phone No.";
          "Ship-to Contact" := Contact;
        end else
          CalcFields(
            "Ship-to Name","Ship-to Name 2","Ship-to Address","Ship-to Address 2","Ship-to Post Code","Ship-to City",
            "Ship-to County","Ship-to Country/Region Code","Ship-to Contact","Ship-to Phone No.");
    end;

    local procedure CustomerNoOnAfterValidate()
    begin
        if "Customer No." <> xRec."Customer No." then
          UpdateShipToCode;
    end;
}

