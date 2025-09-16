#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5906 "Service Item Worksheet"
{
    Caption = 'Service Item Worksheet';
    DataCaptionExpression = Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Service Item Line";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the service order linked to this service item line.';
                }
                field("Service Item No.";"Service Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the service item number registered in the Service Item table.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the item number linked to this service item.';
                }
                field("Service Item Group Code";"Service Item Group Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the service item group for this item.';
                }
                field("Serial No.";"Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the serial number of this item.';
                }
                field("Fault Reason Code";"Fault Reason Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the fault reason code for the item.';
                }
                field("Document Type";"Document Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Document Type';
                    Editable = false;
                    OptionCaption = 'Quote,Order';
                    ToolTip = 'Specifies whether the service document is a service order or service quote.';
                }
                field("Loaner No.";"Loaner No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the loaner that has been lent to the customer in the service order to replace this item.';
                }
                field("Service Shelf No.";"Service Shelf No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the service shelf this item is stored on.';
                }
                field("Service Price Group Code";"Service Price Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service price group associated with the item.';
                }
                field("Fault Area Code";"Fault Area Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault area code for this item.';
                }
                field("Symptom Code";"Symptom Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the symptom code for this item.';
                }
                field("Fault Code";"Fault Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fault code for this item.';
                }
                field("Resolution Code";"Resolution Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the resolution code for this item.';
                }
                field("Repair Status Code";"Repair Status Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the repair status of this service item.';
                }
            }
            part(ServInvLines;"Service Item Worksheet Subform")
            {
                SubPageLink = "Document Type"=field("Document Type"),
                              "Document No."=field("Document No."),
                              "Service Item No."=field("Service Item No."),
                              "Service Item Line No."=field("Line No.");
            }
            group(Customer)
            {
                Caption = 'Customer';
                field("Customer No.";"Customer No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Customer No.';
                    Editable = false;
                    ToolTip = 'Specifies the customer number associated with the service contract.';
                }
                field("ServHeader.Name";ServHeader.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Name';
                    Editable = false;
                }
                field("ServHeader.Address";ServHeader.Address)
                {
                    ApplicationArea = Basic;
                    Caption = 'Address';
                    Editable = false;
                }
                field("ServHeader.""Address 2""";ServHeader."Address 2")
                {
                    ApplicationArea = Basic;
                    Caption = 'Address 2';
                    Editable = false;
                }
                field("ServHeader.City";ServHeader.City)
                {
                    ApplicationArea = Basic;
                    Caption = 'City';
                    Editable = false;
                }
                field("ServHeader.County";ServHeader.County)
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                    Editable = false;
                }
                field("ServHeader.""Post Code""";ServHeader."Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'ZIP Code';
                    Editable = false;
                }
                field("ServHeader.""Contact Name""";ServHeader."Contact Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Contact Name';
                    Editable = false;
                }
                field("ServHeader.""Phone No.""";ServHeader."Phone No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Phone No.';
                    Editable = false;
                }
                field("Location of Service Item";"Location of Service Item")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of the location of this item.';
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Code';
                    Editable = false;
                    ToolTip = 'Specifies the ship-to code of the service item associated with the service contract or service order.';
                }
                field(ShiptoName;ShiptoName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Name';
                    Editable = false;
                }
                field(ShiptoAddress;ShiptoAddress)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Address';
                    Editable = false;
                }
                field(ShiptoAddress2;ShiptoAddress2)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Address 2';
                    Editable = false;
                }
                field(ShiptoCity;ShiptoCity)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to City';
                    Editable = false;
                }
                field(ShiptoCounty;ShiptoCounty)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to State / ZIP Code';
                    Editable = false;
                }
                field(ShiptoPostCode;ShiptoPostCode)
                {
                    ApplicationArea = Basic;
                    Caption = 'ZIP Code';
                    Editable = false;
                }
                field("ServHeader.""Ship-to Contact""";ServHeader."Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Contact';
                    Editable = false;
                }
                field("ServHeader.""Ship-to Phone""";ServHeader."Ship-to Phone")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to Phone No.';
                    Editable = false;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field("Contract No.";"Contract No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the number of the service contract associated with the item or service on the line.';
                }
                field(Warranty;Warranty)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies that warranty on either parts or labor exists for this item.';
                }
                field("Response Date";"Response Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the estimated date when service should start on this service item line.';
                }
                field("Response Time";"Response Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the estimated time when service should start on this service item.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the service priority for this item.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date when service on this item began and when the repair status changed to In process.';
                }
                field("Starting Time";"Starting Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the time when service on this item began and when the repair status changed to In process.';
                }
                field("Finishing Date";"Finishing Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the finishing date of the service and when the repair status of this item changes to Finished.';
                }
                field("Finishing Time";"Finishing Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the finishing time of the service and when the repair status of this item changes to Finished.';
                }
                field("No. of Previous Services";"No. of Previous Services")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of services performed on service items with the same item and serial number as this service item.';
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
            group("&Worksheet")
            {
                Caption = '&Worksheet';
                Image = Worksheet;
                group("Com&ments")
                {
                    Caption = 'Com&ments';
                    Image = ViewComments;
                    action(Faults)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Faults';
                        Image = Error;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Fault);
                    }
                    action(Resolutions)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resolutions';
                        Image = Completed;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Resolution);
                    }
                    action(Internal)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Internal';
                        Image = Comment;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Internal);
                    }
                    action(Accessories)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Accessories';
                        Image = ServiceAccessories;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const(Accessory);
                    }
                    action(Loaners)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Loaners';
                        Image = Loaners;
                        RunObject = Page "Service Comment Sheet";
                        RunPageLink = "Table Name"=const("Service Header"),
                                      "Table Subtype"=field("Document Type"),
                                      "No."=field("Document No."),
                                      "Table Line No."=field("Line No."),
                                      Type=const("Service Item Loaner");
                    }
                }
                group("Service &Item")
                {
                    Caption = 'Service &Item';
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
                    action("&Log")
                    {
                        ApplicationArea = Basic;
                        Caption = '&Log';
                        Image = Approve;
                        RunObject = Page "Service Item Log";
                        RunPageLink = "Service Item No."=field("Service Item No.");
                    }
                }
                action("&Fault/Resol. Codes Relationships")
                {
                    ApplicationArea = Basic;
                    Caption = '&Fault/Resol. Codes Relationships';
                    Image = FaultDefault;

                    trigger OnAction()
                    begin
                        SelectFaultResolutionCode;
                    end;
                }
                action("&Troubleshooting")
                {
                    ApplicationArea = Basic;
                    Caption = '&Troubleshooting';
                    Image = Troubleshoot;

                    trigger OnAction()
                    begin
                        TblshtgHeader.ShowForServItemLine(Rec);
                    end;
                }
                separator(Action125)
                {
                }
                action("Demand Overview")
                {
                    ApplicationArea = Basic;
                    Caption = 'Demand Overview';
                    Image = Forecast;

                    trigger OnAction()
                    var
                        DemandOverview: Page "Demand Overview";
                    begin
                        DemandOverview.SetCalculationParameter(true);
                        DemandOverview.Initialize(0D,4,"Document No.",'','');
                        DemandOverview.RunModal
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Adjust Service Price")
                {
                    ApplicationArea = Basic;
                    Caption = 'Adjust Service Price';
                    Image = PriceAdjustment;

                    trigger OnAction()
                    var
                        ServPriceMgmt: Codeunit "Service Price Management";
                    begin
                        ServPriceMgmt.ShowPriceAdjustment(Rec);
                    end;
                }
                separator(Action128)
                {
                }
            }
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Clear(ServItemLine);
                    ServItemLine.SetRange("Document Type","Document Type");
                    ServItemLine.SetRange("Document No.","Document No.");
                    ServItemLine.SetRange("Line No.","Line No.");
                    Report.Run(Report::"Service Item Worksheet",true,false,ServItemLine);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ServHeader.Get("Document Type","Document No.");
        UpdateShiptoCode;
        if "Serial No." = '' then
          "No. of Previous Services" := 0;
    end;

    trigger OnAfterGetRecord()
    begin
        ServHeader.Get("Document Type","Document No.");
        UpdateShiptoCode;
        SetRange("Line No.");
        if not ServItem.Get("Service Item No.") then
          Clear(ServItem);

        if "Serial No." = '' then
          "No. of Previous Services" := 0;

        CurrPage.ServInvLines.Page.SetValues("Line No.");
    end;

    var
        CannotOpenWindowErr: label 'You cannot open the window because %1 is %2 in the %3 table.';
        ServHeader: Record "Service Header";
        ShiptoAddr: Record "Ship-to Address";
        ServItemLine: Record "Service Item Line";
        ServItem: Record "Service Item";
        TblshtgHeader: Record "Troubleshooting Header";
        ShiptoName: Text[50];
        ShiptoAddress: Text[50];
        ShiptoAddress2: Text[50];
        ShiptoPostCode: Code[20];
        ShiptoCity: Text[30];
        ShiptoCounty: Text[30];

    local procedure Caption(): Text[80]
    begin
        if "Service Item No." <> '' then
          exit(StrSubstNo('%1 %2',"Service Item No.",Description));
        if "Item No." <> '' then
          exit(StrSubstNo('%1 %2',"Item No.",Description));
        exit(StrSubstNo('%1 %2',"Serial No.",Description));
    end;

    local procedure SelectFaultResolutionCode()
    var
        ServSetup: Record "Service Mgt. Setup";
        FaultResolutionRelation: Page "Fault/Resol. Cod. Relationship";
    begin
        ServSetup.Get;
        case ServSetup."Fault Reporting Level" of
          ServSetup."fault reporting level"::None:
            Error(
              CannotOpenWindowErr,
              ServSetup.FieldCaption("Fault Reporting Level"),ServSetup."Fault Reporting Level",ServSetup.TableCaption);
        end;
        Clear(FaultResolutionRelation);
        FaultResolutionRelation.SetDocument(Database::"Service Item Line","Document Type","Document No.","Line No.");
        FaultResolutionRelation.SetFilters("Symptom Code","Fault Code","Fault Area Code","Service Item Group Code");
        FaultResolutionRelation.RunModal;
        CurrPage.Update(false);
    end;

    local procedure UpdateShiptoCode()
    begin
        ServHeader.Get("Document Type","Document No.");
        if "Ship-to Code" = '' then begin
          ShiptoName := ServHeader.Name;
          ShiptoAddress := ServHeader.Address;
          ShiptoAddress2 := ServHeader."Address 2";
          ShiptoPostCode := ServHeader."Post Code";
          ShiptoCity := ServHeader.City;
          ShiptoCounty := ServHeader.County;
        end else begin
          ShiptoAddr.Get("Customer No.","Ship-to Code");
          ShiptoName := ShiptoAddr.Name;
          ShiptoAddress := ShiptoAddr.Address;
          ShiptoAddress2 := ShiptoAddr."Address 2";
          ShiptoPostCode := ShiptoAddr."Post Code";
          ShiptoCity := ShiptoAddr.City;
          ShiptoCounty := ShiptoAddr.County;
        end;
    end;
}

