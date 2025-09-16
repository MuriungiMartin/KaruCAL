#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6633 "Sales Return Orders"
{
    Caption = 'Sales Return Orders';
    DataCaptionFields = "No.";
    Editable = false;
    PageType = List;
    SourceTable = "Sales Line";
    SourceTableView = where("Document Type"=filter("Return Order"));

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
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Return Reason Code";"Return Reason Code")
                {
                    ApplicationArea = Basic;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document No.";"Document No.")
                {
                    ApplicationArea = Basic;
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = Basic;
                }
                field("Outstanding Quantity";"Outstanding Quantity")
                {
                    ApplicationArea = Basic;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field("Line Discount %";"Line Discount %")
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("Show Order")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Order';
                    Image = ViewOrder;
                    RunObject = Page "Sales Return Order";
                    RunPageLink = "Document Type"=field("Document Type"),
                                  "No."=field("Document No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Reservation Entries")
                {
                    AccessByPermission = TableData Item=R;
                    ApplicationArea = Basic;
                    Caption = 'Reservation Entries';
                    Image = ReservationLedger;

                    trigger OnAction()
                    begin
                        ShowReservationEntries(true);
                    end;
                }
            }
        }
    }
}

