#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6076 "Serv. Item List (Contract)"
{
    Caption = 'Service Item List';
    Editable = false;
    PageType = List;
    SourceTable = "Service Contract Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service contract or service contract quote associated with the service contract line.';
                    Visible = false;
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the service item that is subject to the service contract.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the service item that is subject to the contract.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the item linked to the service item in the service contract.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of the service item that is subject to the contract.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer associated with the service contract.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer associated with the service contract or service item.';
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
            group("&Serv. Item")
            {
                Caption = '&Serv. Item';
                Image = ServiceItem;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Service Item Card";
                    RunPageLink = "No."=field("Service Item No.");
                    ShortCutKey = 'Shift+F7';
                }
                separator(Action21)
                {
                }
                action("Service Ledger E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Ledger E&ntries';
                    Image = ServiceLedger;
                    RunObject = Page "Service Ledger Entries";
                    RunPageLink = "Service Item No. (Serviced)"=field("Service Item No.");
                    RunPageView = sorting("Service Item No. (Serviced)","Entry Type","Moved from Prepaid Acc.",Type,"Posting Date");
                    ShortCutKey = 'Ctrl+F7';
                }
                action("&Warranty Ledger Entries")
                {
                    ApplicationArea = Basic;
                    Caption = '&Warranty Ledger Entries';
                    Image = WarrantyLedger;
                    RunObject = Page "Warranty Ledger Entries";
                    RunPageLink = "Service Item No. (Serviced)"=field("Service Item No.");
                    RunPageView = sorting("Service Item No. (Serviced)","Posting Date","Document No.");
                }
                separator(Action24)
                {
                    Caption = '';
                }
                action("Com&ponent List")
                {
                    ApplicationArea = Basic;
                    Caption = 'Com&ponent List';
                    Image = Components;
                    RunObject = Page "Service Item Component List";
                    RunPageLink = Active=const(true),
                                  "Parent Service Item No."=field("Service Item No.");
                    RunPageView = sorting(Active,"Parent Service Item No.","Line No.");
                }
                action("Troubleshooting Set&up")
                {
                    ApplicationArea = Basic;
                    Caption = 'Troubleshooting Set&up';
                    Image = Troubleshoot;
                    RunObject = Page "Troubleshooting Setup";
                    RunPageLink = Type=const("Service Item"),
                                  "No."=field("Service Item No.");
                }
                action("&Troubleshooting")
                {
                    ApplicationArea = Basic;
                    Caption = '&Troubleshooting';
                    Image = Troubleshoot;

                    trigger OnAction()
                    var
                        ServItem: Record "Service Item";
                        TblshtgHeader: Record "Troubleshooting Header";
                    begin
                        ServItem.Get("Service Item No.");
                        TblshtgHeader.ShowForServItem(ServItem);
                    end;
                }
                action("Resource Skills")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Skills';
                    Image = ResourceSkills;
                    ToolTip = 'Show the skills for this resource.';

                    trigger OnAction()
                    var
                        ResourceSkill: Record "Resource Skill";
                    begin
                        case true of
                          "Service Item No." <> '':
                            begin
                              ResourceSkill.SetRange(Type,ResourceSkill.Type::"Service Item");
                              ResourceSkill.SetRange("No.","Service Item No.");
                            end;
                          "Item No." <> '':
                            begin
                              ResourceSkill.SetRange(Type,ResourceSkill.Type::Item);
                              ResourceSkill.SetRange("No.","Item No.");
                            end;
                        end;
                        Page.RunModal(Page::"Resource Skills",ResourceSkill);
                    end;
                }
                action("S&killed Resources")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&killed Resources';
                    Image = ResourceSkills;

                    trigger OnAction()
                    var
                        Item: Record Item;
                        ServiceItem: Record "Service Item";
                        ResourceSkill: Record "Resource Skill";
                        SkilledResourceList: Page "Skilled Resource List";
                    begin
                        if "Service Item No." <> '' then begin
                          if ServiceItem.Get("Service Item No.") then begin
                            SkilledResourceList.Initialize(
                              ResourceSkill.Type::"Service Item",
                              "Service Item No.",
                              ServiceItem.Description);
                            SkilledResourceList.RunModal;
                          end;
                        end else
                          if "Item No." <> '' then
                            if Item.Get("Item No.") then begin
                              SkilledResourceList.Initialize(
                                ResourceSkill.Type::Item,
                                "Item No.",
                                Item.Description);
                              SkilledResourceList.RunModal;
                            end;
                    end;
                }
                separator(Action30)
                {
                    Caption = '';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Service Comment Sheet";
                    RunPageLink = "Table Name"=const(Loaner),
                                  "Table Subtype"=const(0),
                                  "No."=field("Service Item No.");
                }
                separator(Action32)
                {
                    Caption = '';
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Service Item Statistics";
                    RunPageLink = "No."=field("Service Item No.");
                    ShortCutKey = 'F7';
                }
                action("Tr&endscape")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tr&endscape';
                    Image = Trendscape;
                    RunObject = Page "Service Item Trendscape";
                    RunPageLink = "No."=field("Service Item No.");
                }
                separator(Action35)
                {
                    Caption = '';
                }
                action("Service Item Lo&g")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Item Lo&g';
                    Image = Log;
                    RunObject = Page "Service Item Log";
                    RunPageLink = "Service Item No."=field("Service Item No.");
                }
                action("Ser&vice Contracts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ser&vice Contracts';
                    Image = ServiceAgreement;
                    RunObject = Page "Serv. Contr. List (Serv. Item)";
                    RunPageLink = "Service Item No."=field("Service Item No.");
                    RunPageView = sorting("Service Item No.","Contract Status");
                }
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
                        RunPageLink = "Service Item No."=field("Service Item No.");
                        RunPageView = sorting("Service Item No.");
                    }
                    action("&Service Lines")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Service Lines';
                        Image = ServiceLines;
                        RunObject = Page "Service Line List";
                        RunPageLink = "Service Item No."=field("Service Item No.");
                        RunPageView = sorting("Service Item No.");
                    }
                }
                group("Service Shi&pments")
                {
                    Caption = 'Service Shi&pments';
                    Image = Shipment;
                    action(Action41)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Item Lines';
                        Image = ItemLines;
                        RunObject = Page "Posted Shpt. Item Line List";
                        RunPageLink = "Service Item No."=field("Service Item No.");
                        RunPageView = sorting("Service Item No.");
                    }
                    action(Action42)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Service Lines';
                        Image = ServiceLines;
                        RunObject = Page "Posted Serv. Shpt. Line List";
                        RunPageLink = "Service Item No."=field("Service Item No.");
                        RunPageView = sorting("Service Item No.");
                    }
                }
            }
        }
    }
}

