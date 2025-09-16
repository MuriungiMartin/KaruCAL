#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68310 "CAT-Catering Transfer Order"
{
    Caption = 'Transfer Order';
    PageType = Document;
    RefreshOnActivate = true;
    SourceTable = "Transfer Header";

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

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Transfer-to Code";"Transfer-to Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("In-Transit Code";"In-Transit Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    Editable = true;

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = true;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(TransferLines;"Transfer Order Subform")
            {
                SubPageLink = "Document No."=field("No."),
                              "Derived From Line No."=const(0);
            }
            group("Transfer-from")
            {
                Caption = 'Transfer-from';
                field("Transfer-from Name";"Transfer-from Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-from Name 2";"Transfer-from Name 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-from Address";"Transfer-from Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-from Address 2";"Transfer-from Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-from Post Code";"Transfer-from Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer-from Post Code/City';
                    Editable = false;
                }
                field("Transfer-from City";"Transfer-from City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-from Contact";"Transfer-from Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name";"Transfer-to Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-to Name 2";"Transfer-to Name 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-to Address";"Transfer-to Address")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-to Address 2";"Transfer-to Address 2")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-to Post Code";"Transfer-to Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer-to Post Code/City';
                    Editable = false;
                }
                field("Transfer-to City";"Transfer-to City")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Transfer-to Contact";"Transfer-to Contact")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        ReceiptDateOnAfterValidate;
                    end;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
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
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                }
                field("Entry/Exit Point";"Entry/Exit Point")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("O&rder")
            {
                Caption = 'O&rder';
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Transfer Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Inventory Comment Sheet";
                    RunPageLink = "Document Type"=const("Transfer Order"),
                                  "No."=field("No.");
                }
                action("S&hipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&hipments';
                    RunObject = Page "Posted Transfer Shipments";
                    RunPageLink = "Transfer Order No."=field("No.");
                }
                action("Re&ceipts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&ceipts';
                    Image = PostedReceipts;
                    RunObject = Page "Posted Transfer Receipts";
                    RunPageLink = "Transfer Order No."=field("No.");
                }
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Dim. Allowed Values per Acc.";
                }
                action("Whse. Shi&pments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Shi&pments';
                    RunObject = Page "Whse. Shipment Lines";
                    RunPageLink = "Source Type"=const(5741),
                                  "Source Subtype"=const("0"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.");
                }
                action("&Whse. Receipts")
                {
                    ApplicationArea = Basic;
                    Caption = '&Whse. Receipts';
                    RunObject = Page "Whse. Receipt Lines";
                    RunPageLink = "Source Type"=const(5741),
                                  "Source Subtype"=const("1"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Type","Source Subtype","Source No.","Source Line No.");
                }
                action("In&vt. Put-away/Pick Lines")
                {
                    ApplicationArea = Basic;
                    Caption = 'In&vt. Put-away/Pick Lines';
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document"=filter("Inbound Transfer"|"Outbound Transfer"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Document","Source No.","Location Code");
                }
            }
            group("&Line")
            {
                Caption = '&Line';
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                action("Create Inventor&y Put-away / Pick")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Inventor&y Put-away / Pick';
                    Ellipsis = true;
                    Image = CreateInventoryPickup;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;
                    end;
                }
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    RunObject = Codeunit "Release Transfer Document";
                    ShortCutKey = 'Ctrl+F9';
                }
                action("Reo&pen")
                {
                    ApplicationArea = Basic;
                    Caption = 'Reo&pen';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleaseTransferDoc: Codeunit "Release Transfer Document";
                    begin
                        ReleaseTransferDoc.Reopen(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                action("P&ost")
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit UnknownCodeunit51101;
                    ShortCutKey = 'F9';
                }
                action("Post and &Print")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "TransferOrder-Post + Print";
                    ShortCutKey = 'Shift+F9';
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
                var
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintTransferHeader(Rec);
                end;
            }
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        TestField(Status,Status::Open);
    end;

    local procedure PostingDateOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure ShippingAgentServiceCodeOnAfte()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure ShippingAgentCodeOnAfterValida()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure ShippingTimeOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure OutboundWhseHandlingTimeOnAfte()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure ReceiptDateOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure InboundWhseHandlingTimeOnAfter()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;
}

