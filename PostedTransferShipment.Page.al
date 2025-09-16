#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5743 "Posted Transfer Shipment"
{
    Caption = 'Posted Transfer Shipment';
    InsertAllowed = false;
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Transfer Shipment Header";

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
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the transfer shipment.';
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that you are transferring items from.';
                }
                field("Transfer-to Code";"Transfer-to Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that you are transferring items to.';
                }
                field("In-Transit Code";"In-Transit Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the in-transit code that is used for this transfer.';
                }
                field("Transfer Order No.";"Transfer Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    Lookup = false;
                    ToolTip = 'Specifies the number of the transfer order on which the transfer shipment was based.';
                }
                field("Transfer Order Date";"Transfer Order Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the date on which the transfer order was created.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for this document.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 1.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 2.';
                }
            }
            part(TransferShipmentLines;"Posted Transfer Shpt. Subform")
            {
                SubPageLink = "Document No."=field("No.");
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name";"Transfer-from Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the location that you are transferring items from.';
                }
                field("Transfer-from Name 2";"Transfer-from Name 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional part of the name of the location that you are transferring items from.';
                }
                field("Transfer-from Address";"Transfer-from Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address of the location that you are transferring items from.';
                }
                field("Transfer-from Address 2";"Transfer-from Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional part of the address of the location.';
                }
                field("Transfer-from City";"Transfer-from City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the location that you are transferring items from.';
                }
                field("Transfer-from County";"Transfer-from County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer-from State / ZIP Code';
                    Editable = false;
                }
                field("Transfer-from Post Code";"Transfer-from Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP code of the location that you are transferring items from.';
                }
                field("Transfer-from Contact";"Transfer-from Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person at the transfer-from location.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the shipment date of the transfer order.';
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a code that represents the shipment method.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for the shipping agent you have used for this transfer shipment.';
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for the shipping agent service you have used for this transfer shipment.';
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name";"Transfer-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the location that you are transferring items to.';
                }
                field("Transfer-to Name 2";"Transfer-to Name 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional part of the name of the location that you are transferring items to.';
                }
                field("Transfer-to Address";"Transfer-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the address of the location that you are transferring items to.';
                }
                field("Transfer-to Address 2";"Transfer-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies an additional part of the address of the location.';
                }
                field("Transfer-to City";"Transfer-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the city of the location to which items are transferred.';
                }
                field("Transfer-to County";"Transfer-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer-to State / ZIP Code';
                    Editable = false;
                }
                field("Transfer-to Post Code";"Transfer-to Post Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP code of the location.';
                }
                field("Transfer-to Contact";"Transfer-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the name of the contact person at the transfer-to location.';
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the receipt date of the transfer order.';
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the transaction type of the transfer.';
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the transaction specification code that was used in the transfer.';
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for the transport method used for the item on this line.';
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code for an area at the customer or vendor with which you are trading the items on the line.';
                }
                field("Entry/Exit Point";"Entry/Exit Point")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the code of either the port of entry at which the items passed into your country/region, or the port of exit.';
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
                    RunObject = Page "Transfer Shipment Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type"=const("Posted Transfer Shipment"),
                                  "No."=field("No.");
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
            }
        }
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic;
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    TransShptHeader: Record "Transfer Shipment Header";
                begin
                    CurrPage.SetSelectionFilter(TransShptHeader);
                    TransShptHeader.PrintRecords(true);
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
}

