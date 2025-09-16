#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5159 "Sales Order Archive"
{
    Caption = 'Sales Order Archive';
    DeleteAllowed = false;
    Editable = false;
    PageType = Document;
    SourceTable = "Sales Header Archive";
    SourceTableView = where("Document Type"=const(Order));

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
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Contact No.";"Sell-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Address";"Sell-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Address 2";"Sell-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to City";"Sell-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to County";"Sell-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sell-to State / ZIP Code';
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field("Order Date";"Order Date")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field("External Document No.";"External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
            }
            part(SalesLinesArchive;"Sales Order Archive Subform")
            {
                SubPageLink = "Document No."=field("No."),
                              "Doc. No. Occurrence"=field("Doc. No. Occurrence"),
                              "Version No."=field("Version No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Contact No.";"Bill-to Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Address";"Bill-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Address 2";"Bill-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to City";"Bill-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to County";"Bill-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'State / ZIP Code';
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Terms Code";"Payment Terms Code")
                {
                    ApplicationArea = Basic;
                }
                field("Due Date";"Due Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Discount %";"Payment Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Pmt. Discount Date";"Pmt. Discount Date")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Method Code";"Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Liable";"Tax Liable")
                {
                    ApplicationArea = Basic;
                }
                field("Tax Area Code";"Tax Area Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Ship-to State / ZIP Code';
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                }
                field("Ship-to UPS Zone";"Ship-to UPS Zone")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the UPS Zone used by the customer for this document.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                }
                field("Late Order Shipping";"Late Order Shipping")
                {
                    ApplicationArea = Basic;
                }
                field("Package Tracking No.";"Package Tracking No.")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("EU 3-Party Trade";"EU 3-Party Trade")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field("Exit Point";"Exit Point")
                {
                    ApplicationArea = Basic;
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                }
            }
            group(Version)
            {
                Caption = 'Version';
                field("Version No.";"Version No.")
                {
                    ApplicationArea = Basic;
                }
                field("Archived By";"Archived By")
                {
                    ApplicationArea = Basic;
                }
                field("Date Archived";"Date Archived")
                {
                    ApplicationArea = Basic;
                }
                field("Time Archived";"Time Archived")
                {
                    ApplicationArea = Basic;
                }
                field("Interaction Exist";"Interaction Exist")
                {
                    ApplicationArea = Basic;
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
            group("Ver&sion")
            {
                Caption = 'Ver&sion';
                Image = Versions;
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No."=field("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
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
                        CurrPage.SaveRecord;
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Archive Comment Sheet";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("No."),
                                  "Document Line No."=const(0),
                                  "Doc. No. Occurrence"=field("Doc. No. Occurrence"),
                                  "Version No."=field("Version No.");
                }
                action(Print)
                {
                    ApplicationArea = Basic;
                    Caption = 'Print';
                    Image = Print;

                    trigger OnAction()
                    begin
                        DocPrint.PrintSalesHeaderArch(Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            action(Restore)
            {
                ApplicationArea = Basic;
                Caption = '&Restore';
                Ellipsis = true;
                Image = Restore;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ArchiveManagement: Codeunit ArchiveManagement;
                begin
                    ArchiveManagement.RestoreSalesDocument(Rec);
                end;
            }
        }
    }

    var
        DocPrint: Codeunit "Document-Print";
}

