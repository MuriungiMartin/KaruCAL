#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6662 "Posted Return Receipts"
{
    ApplicationArea = Basic;
    Caption = 'Posted Return Receipts';
    CardPageID = "Posted Return Receipt";
    Editable = false;
    PageType = List;
    SourceTable = "Return Receipt Header";
    SourceTableView = sorting("Posting Date")
                      order(descending);
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer No.";"Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Customer Name";"Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field("Sell-to Post Code";"Sell-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sell-to Country/Region Code";"Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Sell-to Contact";"Sell-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Customer No.";"Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Name";"Bill-to Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Post Code";"Bill-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Country/Region Code";"Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Bill-to Contact";"Bill-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Code";"Ship-to Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Name";"Ship-to Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Post Code";"Ship-to Post Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Country/Region Code";"Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Ship-to Contact";"Ship-to Contact")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Location Code";"Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the location from where inventory items to the customer on the sales document are to be shipped by default.';
                }
                field("No. Printed";"No. Printed")
                {
                    ApplicationArea = Basic;
                }
                field("Document Date";"Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which shipping agent is used to transport the items on the sales document to the customer.';
                    Visible = false;
                }
                field("Package Tracking No.";"Package Tracking No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping agent''s package number.';
                    Visible = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Return Rcpt.")
            {
                Caption = '&Return Rcpt.';
                Image = Receipt;
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Return Receipt Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type"=const("Posted Return Receipt"),
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
                begin
                    CurrPage.SetSelectionFilter(ReturnRcptHeader);
                    ReturnRcptHeader.PrintRecords(true);
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
        if FindFirst then;
    end;

    var
        ReturnRcptHeader: Record "Return Receipt Header";
}

