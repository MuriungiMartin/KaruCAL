#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5981 "Service Item List"
{
    ApplicationArea = Basic;
    Caption = 'Service Item List';
    CardPageID = "Service Item Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Service Item";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains a description of this item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the item number linked to the service item.';
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the description of the item that the service item is linked to.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the serial number of this item.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the customer who owns this item.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the ship-to code for the customer who owns this item.';
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
                field("Search Description";"Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an alternate description to search for the service item.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the status of the service item.';
                    Visible = false;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service priority for this item.';
                    Visible = false;
                }
                field("Last Service Date";"Last Service Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the last service on this item.';
                    Visible = false;
                }
                field("Service Contracts";"Service Contracts")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this service item is associated with one or more service contracts/quotes.';
                    Visible = false;
                }
                field("Vendor No.";"Vendor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the number of the vendor for this item.';
                    Visible = false;
                }
                field("Vendor Name";"Vendor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the vendor name for this item.';
                    Visible = false;
                }
                field("Installation Date";"Installation Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Contains the date when this item was installed at the customer''s site.';
                    Visible = false;
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
                action("Com&ponent List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Com&ponent List';
                    Image = Components;
                    RunObject = Page "Service Item Component List";
                    RunPageLink = Active=const(true),
                                  "Parent Service Item No."=field("No.");
                    RunPageView = sorting(Active,"Parent Service Item No.","Line No.");
                }
                separator(Action27)
                {
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("&Dimensions-Single")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(5940),
                                      "No."=field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            ServiceItem: Record "Service Item";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(ServiceItem);
                            DefaultDimMultiple.SetMultiServiceItem(ServiceItem);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                separator(Action58)
                {
                    Caption = '';
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action59)
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
                separator(Action61)
                {
                    Caption = '';
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
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=const("Service Item"),
                                      "No."=field("No.");
                    }
                    action(Action3)
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
                separator(Action56)
                {
                    Caption = '';
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
                    action(Action67)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Item Lines';
                        Image = ItemLines;
                        RunObject = Page "Posted Shpt. Item Line List";
                        RunPageLink = "Service Item No."=field("No.");
                        RunPageView = sorting("Service Item No.");
                    }
                    action(Action68)
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
                separator(Action30)
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
            action("Service Item")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Items";
            }
            action("Service Item Label")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item Label';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Service Item Line Labels";
            }
            action("Service Item Resource usage")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item Resource usage';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Item - Resource Usage";
            }
            action("Service Item Out of Warranty")
            {
                ApplicationArea = Basic;
                Caption = 'Service Item Out of Warranty';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Service Items Out of Warranty";
            }
        }
    }

    var
        ResourceSkill: Record "Resource Skill";
        SkilledResourceList: Page "Skilled Resource List";
}

