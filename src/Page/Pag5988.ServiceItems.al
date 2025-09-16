#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5988 "Service Items"
{
    Caption = 'Service Items';
    CardPageID = "Service Item Card";
    DataCaptionExpression = GetCaption;
    Editable = false;
    PageType = List;
    SourceTable = "Service Item";

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
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of this item.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the item number linked to the service item.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of this item.';
                }
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the customer who owns this item.';
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ship-to code for the customer who owns this item.';
                }
                field("Warranty Starting Date (Parts)";"Warranty Starting Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the spare parts warranty for this item.';
                }
                field("Warranty Ending Date (Parts)";"Warranty Ending Date (Parts)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending date of the spare parts warranty for this item.';
                }
                field("Warranty Starting Date (Labor)";"Warranty Starting Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting date of the labor warranty for this item.';
                }
                field("Warranty Ending Date (Labor)";"Warranty Ending Date (Labor)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending date of the labor warranty for this item.';
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
                separator(Action18)
                {
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
                action(Statistics)
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
                action("&Trendscape")
                {
                    ApplicationArea = Basic;
                    Caption = '&Trendscape';
                    Image = Trendscape;
                    RunObject = Page "Service Item Trendscape";
                    RunPageLink = "No."=field("No.");
                }
                action("L&og")
                {
                    ApplicationArea = Basic;
                    Caption = 'L&og';
                    Image = Approve;
                    RunObject = Page "Service Item Log";
                    RunPageLink = "Service Item No."=field("No.");
                }
                separator(Action36)
                {
                }
                action("Com&ponents")
                {
                    ApplicationArea = Basic;
                    Caption = 'Com&ponents';
                    Image = Components;
                    RunObject = Page "Service Item Component List";
                    RunPageLink = Active=const(true),
                                  "Parent Service Item No."=field("No.");
                    RunPageView = sorting(Active,"Parent Service Item No.","Line No.");
                }
                separator(Action38)
                {
                }
                group("Trou&bleshooting  Setup")
                {
                    Caption = 'Trou&bleshooting  Setup';
                    Image = Troubleshoot;
                    action(ServiceItemGroup)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Item Group';
                        Image = ServiceItemGroup;
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=const("Service Item Group"),
                                      "No."=field("Service Item Group Code");
                    }
                    action(ServiceItem)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Service Item';
                        Image = "Report";
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=const("Service Item"),
                                      "No."=field("No.");
                    }
                    action(Item)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item';
                        Image = Item;
                        RunObject = Page "Troubleshooting Setup";
                        RunPageLink = Type=const(Item),
                                      "No."=field("Item No.");
                    }
                }
            }
        }
    }

    var
        Text000: label '%1 %2', Comment='%1=Cust."No."  %2=Cust.Name';
        Text001: label '%1 %2', Comment='%1 = Item no, %2 = Item description';

    local procedure GetCaption(): Text[80]
    var
        Cust: Record Customer;
        Item: Record Item;
    begin
        case true of
          GetFilter("Customer No.") <> '':
            begin
              if Cust.Get(GetRangeMin("Customer No.")) then
                exit(StrSubstNo(Text000,Cust."No.",Cust.Name));
              exit(StrSubstNo('%1 %2',GetRangeMin("Customer No.")));
            end;
          GetFilter("Item No.") <> '':
            begin
              if Item.Get(GetRangeMin("Item No.")) then
                exit(StrSubstNo(Text001,Item."No.",Item.Description));
              exit(StrSubstNo('%1 %2',GetRangeMin("Item No.")));
            end;
          else
            exit('');
        end;
    end;
}

