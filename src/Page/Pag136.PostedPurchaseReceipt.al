#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 136 "Posted Purchase Receipt"
{
    Caption = 'Posted Purchase Receipt';
    Editable = false;
    InsertAllowed = false;
    PageType = Document;
    SourceTable = "Purch. Rcpt. Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                }
                field("Buy-from Vendor No.";"Buy-from Vendor No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the vendor who will delivers the items.';
                }
                field("Buy-from Contact No.";"Buy-from Contact No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Buy-from Vendor Name";"Buy-from Vendor Name")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field("Buy-from Address";"Buy-from Address")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the address of the vendor who delivered the items.';
                }
                field("Buy-from Address 2";"Buy-from Address 2")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies an additional part of the address of the vendor who delivered the items.';
                }
                field("Buy-from City";"Buy-from City")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the city of the vendor who delivered the items.';
                }
                field("Buy-from County";"Buy-from County")
                {
                    ApplicationArea = Suite;
                    Caption = 'Buy-from State';
                    Editable = false;
                }
                field("Buy-from Post Code";"Buy-from Post Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP Code of the vendor who delivered the items.';
                }
                field("Buy-from Contact";"Buy-from Contact")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the contact person at the vendor who delivered the items.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the posting date of the record.';
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the date when the purchase document was created.';
                }
                field("Requested Receipt Date";"Requested Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.';
                }
                field("Promised Receipt Date";"Promised Receipt Date")
                {
                    ApplicationArea = Basic;
                }
                field("Quote No.";"Quote No.")
                {
                    ApplicationArea = Basic;
                }
                field("Order No.";"Order No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Vendor Order No.";"Vendor Order No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the vendor''s order number.';
                }
                field("Vendor Shipment No.";"Vendor Shipment No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Order Address Code";"Order Address Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Purchaser Code";"Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies which purchaser is associated with the receipt.';
                }
                field("Responsibility Center";"Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(PurchReceiptLines;"Posted Purchase Rcpt. Subform")
            {
                ApplicationArea = Suite;
                SubPageLink = "Document No."=field("No.");
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Pay-to Vendor No.";"Pay-to Vendor No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the vendor that you received the invoice from.';
                }
                field("Pay-to Contact no.";"Pay-to Contact no.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Pay-to Name";"Pay-to Name")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the vendor that you received the invoice from.';
                }
                field("Pay-to Address";"Pay-to Address")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the address of the vendor that you received the invoice from.';
                }
                field("Pay-to Address 2";"Pay-to Address 2")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies an additional part of the address of the vendor that the invoice was received from.';
                }
                field("Pay-to City";"Pay-to City")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the city of the vendor that you received the invoice from.';
                }
                field("Pay-to County";"Pay-to County")
                {
                    ApplicationArea = Suite;
                    Caption = ' State';
                    Editable = false;
                }
                field("Pay-to Post Code";"Pay-to Post Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP Code of the vendor that you received the invoice from.';
                }
                field("Pay-to Contact";"Pay-to Contact")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the contact person at the vendor that you received the invoice from.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            group(Shipping)
            {
                Caption = 'Shipping';
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the name of the customer that items on the purchase order were shipped to, as a drop shipment.';
                }
                field("Ship-to Address";"Ship-to Address")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the address that items on the purchase order were shipped to, as a drop shipment..';
                }
                field("Ship-to Address 2";"Ship-to Address 2")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies an additional part of the address that items on the purchase order were shipped to, as a drop shipment.';
                }
                field("Ship-to City";"Ship-to City")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the city that items on the purchase order were shipped to, as a drop shipment.';
                }
                field("Ship-to County";"Ship-to County")
                {
                    ApplicationArea = Suite;
                    Caption = 'Ship-to State';
                    Editable = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the ZIP Code that items on the purchase order were shipped to, as a drop shipment.';
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies the contact person at the customer that items on the purchase order were shipped to, as a drop shipment.';
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Importance = Promoted;
                }
                field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies how the vendor must ship items to you. The shipment method code is copied from this field to purchase documents that you send to the vendor.';
                }
                field("Lead Time Calculation";"Lead Time Calculation")
                {
                    ApplicationArea = Basic;
                }
                field("Expected Receipt Date";"Expected Receipt Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse. If you leave the field blank, it will be calculated as follows: Planned Receipt Date + Safety Lead Time + Inbound Warehouse Handling Time = Expected Receipt Date.';
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
            group("&Receipt")
            {
                Caption = '&Receipt';
                Image = Receipt;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Purchase Receipt Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type"=const(Receipt),
                                  "No."=field("No."),
                                  "Document Line No."=const(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension=R;
                    ApplicationArea = Suite;
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
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    //CurrPage.SETSELECTIONFILTER(PurchRcptHeader);
                    //PurchRcptHeader.PrintRecords(TRUE);

                    CurrPage.SetSelectionFilter(PurchRcptHeader);
                    //PurchRcptHeader.PrintRecords(TRUE);
                    PurchRcptHeader.SetRange(PurchRcptHeader."No.","No.");
                    Report.Run(51270,true,false,PurchRcptHeader);
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

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;
    end;

    var
        PurchRcptHeader: Record "Purch. Rcpt. Header";
}

