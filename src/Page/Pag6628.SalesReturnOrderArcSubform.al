#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6628 "Sales Return Order Arc Subform"
{
    Caption = 'Lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Sales Line Archive";
    SourceTableView = where("Document Type"=const("Return Order"));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Cross-Reference No.";"Cross-Reference No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Substitution Available";"Substitution Available")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Purchasing Code";"Purchasing Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Nonstock;Nonstock)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Drop Shipment";"Drop Shipment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Special Order";"Special Order")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(Reserve;Reserve)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure";"Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Line Amount";"Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field("Line Discount Amount";"Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Allow Invoice Disc.";"Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Inv. Discount Amount";"Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Qty. to Ship";"Qty. to Ship")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity Shipped";"Quantity Shipped")
                {
                    ApplicationArea = Basic;
                }
                field("Qty. to Invoice";"Qty. to Invoice")
                {
                    ApplicationArea = Basic;
                }
                field("Quantity Invoiced";"Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                }
                field("Allow Item Charge Assignment";"Allow Item Charge Assignment")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Requested Delivery Date";"Requested Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Promised Delivery Date";"Promised Delivery Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Planned Delivery Date";"Planned Delivery Date")
                {
                    ApplicationArea = Basic;
                }
                field("Planned Shipment Date";"Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Blanket Order No.";"Blanket Order No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Blanket Order Line No.";"Blanket Order Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("FA Posting Date";"FA Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Depr. until FA Posting Date";"Depr. until FA Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Depreciation Book Code";"Depreciation Book Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Use Duplication List";"Use Duplication List")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Duplicate in Depreciation Book";"Duplicate in Depreciation Book")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-from Item Entry";"Appl.-from Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Appl.-to Item Entry";"Appl.-to Item Entry")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Deferral Code";"Deferral Code")
                {
                    ApplicationArea = Basic;
                }
                field("Returns Deferral Start Date";"Returns Deferral Start Date")
                {
                    ApplicationArea = Basic;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
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
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;

                    trigger OnAction()
                    begin
                        ShowLineComments;
                    end;
                }
                action(DeferralSchedule)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deferral Schedule';
                    Image = PaymentPeriod;

                    trigger OnAction()
                    begin
                        ShowDeferrals;
                    end;
                }
            }
        }
    }
}

