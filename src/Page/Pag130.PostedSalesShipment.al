#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 130 "Posted Sales Shipment"
{
    Caption = 'Posted Sales Shipment';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Sales Shipment Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer';
                    Editable = false;
                    ToolTip = 'Specifies the name of customer at the sell-to address.';
                }
                group("Sell-to")
                {
                    Caption = 'Sell-to';
                    field("Sell-to Address";"Sell-to Address")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the customer''s sell-to address.';
                    }
                    field("Sell-to Address 2";"Sell-to Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Address 2';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the customer''s extended sell-to address.';
                    }
                    field("Sell-to City";"Sell-to City")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'City';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the city of the customer''s sell-to address.';
                    }
                    field("Sell-to County";"Sell-to County")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Sell-to Post Code";"Sell-to Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'ZIP Code';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the ZIP code of the customer''s sell-to address.';
                    }
                    field("Sell-to Contact No.";"Sell-to Contact No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Contact No.';
                        Editable = false;
                        Importance = Additional;
                        ToolTip = 'Specifies the contact number.';
                    }
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact';
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact at the customer''s sell-to address.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the posting date of the document.';
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date that the customer has asked for the order to be delivered.';
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Quote No.";"Quote No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ToolTip = 'Specifies the number of the sales quote document if a quote was used to start the sales process.';
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the sales order that this invoice was posted from.';
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number that the customer uses in their own system to refer to this sales document.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Additional;
                }
            }
            part(SalesShipmLines;"Posted Sales Shpt. Subform")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Document No."=field("No.");
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address Code';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for the customer''s additional shipment address.';
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer that you delivered the items to.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address';
                    Editable = false;
                    ToolTip = 'Specifies the address that you delivered the items to.';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address 2';
                    Editable = false;
                    ToolTip = 'Specifies the extended address that you delivered the items to.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'City';
                    Editable = false;
                    ToolTip = 'Specifies the city of the customer''s ship-to address.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'State';
                    Editable = false;
                    ToolTip = 'Specifies the state as a part of the address.';
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'ZIP Code';
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the ZIP code of the customer''s ship-to address.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact';
                    Editable = false;
                    ToolTip = 'Specifies the name of the person you regularly contact at the address that the items were shipped to.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                group("Shipment Method")
                {
                    Caption = 'Shipment Method';
                    field("Shipment Method Code";"Shipment Method Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Code';
                        Editable = false;
                        ToolTip = 'Specifies the shipment method for the shipment.';
                    }
                    field("Shipping Agent Code";"Shipping Agent Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Agent';
                        Importance = Additional;
                        ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                    }
                    field("Shipping Agent Service Code";"Shipping Agent Service Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Agent Service';
                        Importance = Additional;
                        ToolTip = 'Specifies which shipping agent service is used to transport the items on the sales document to the customer.';
                    }
                    field("Package Tracking No.";"Package Tracking No.")
                    {
                        ApplicationArea = Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the shipping agent''s package number.';
                    }
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the sales shipment was posted.';
                }
            }
            group(Billing)
            {
                Caption = 'Billing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Customer No.';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the customer at the billing address.';
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer that you sent the invoice to.';
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the address that you sent the invoice to.';
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Address 2';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the extended address that you sent the invoice to.';
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'City';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the city of the customer''s address.';
                }
                field("Bill-to County";"Bill-to County")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'State';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the state as a part of the address.';
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'ZIP Code';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the ZIP code of the customer''s address.';
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact No.';
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the contact at the customer''s address.';
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Contact';
                    Editable = false;
                    ToolTip = 'Specifies the name of the person you regularly contact at the customer to whom you sent the invoice.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Shipment")
            {
                Caption = '&Shipment';
                Image = Shipment;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Sales Shipment Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type"=const(Shipment),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Posted Approval Entry"=R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ShowPostedApprovalEntries(RecordId);
                    end;
                }
                action(CertificateOfSupplyDetails)
                {
                    ApplicationArea = Basic;
                    Caption = 'Certificate of Supply Details';
                    Image = Certificate;
                    RunObject = Page "Certificates of Supply";
                    RunPageLink = "Document Type"=filter("Sales Shipment"),
                                  "Document No."=field("No.");
                }
                action(PrintCertificateofSupply)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print Certificate of Supply';
                    Image = PrintReport;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;

                    trigger OnAction()
                    var
                        CertificateOfSupply: Record "Certificate of Supply";
                    begin
                        CertificateOfSupply.SetRange("Document Type",CertificateOfSupply."document type"::"Sales Shipment");
                        CertificateOfSupply.SetRange("Document No.","No.");
                        CertificateOfSupply.Print;
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
                    CurrPage.SetSelectionFilter(SalesShptHeader);
                    SalesShptHeader.PrintRecords(true);
                end;
            }
            action("&Navigate")
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate;
                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        Codeunit.Run(Codeunit::"Shipment Header - Edit",Rec);
        exit(false);
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        SalesShptHeader: Record "Sales Shipment Header";
}

