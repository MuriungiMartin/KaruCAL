#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5742 "Transfer List"
{
    ApplicationArea = Basic;
    Caption = 'Transfer List';
    CardPageID = "Transfer Order";
    Editable = false;
    PageType = List;
    SourceTable = "Transfer Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the transfer order.';
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location from which items are transferred.';
                }
                field("Transfer-to Code";"Transfer-to Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the location that you are transferring items to.';
                }
                field("In-Transit Code";"In-Transit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the in-transit code that identifies this transfer.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Indicates whether the transfer order is open or has been released for the next stage of processing.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 1.';
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 2.';
                    Visible = false;
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date the order is expected to be shipped.';
                    Visible = false;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment method code that you have entered for this order.';
                    Visible = false;
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipping agent you are using to ship the items on this transfer order.';
                    Visible = false;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies advice for the warehouse sending the items, about whether a partial delivery is acceptable.';
                    Visible = false;
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that you expect the transfer-to location to receive the shipment.';
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
                Visible = true;
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
                Image = "Order";
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
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("S&hipments")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&hipments';
                    Image = Shipment;
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
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                Image = Warehouse;
                action("Whse. Shi&pments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Whse. Shi&pments';
                    Image = Shipment;
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
                    Image = Receipt;
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
                    Image = PickLines;
                    RunObject = Page "Warehouse Activity List";
                    RunPageLink = "Source Document"=filter("Inbound Transfer"|"Outbound Transfer"),
                                  "Source No."=field("No.");
                    RunPageView = sorting("Source Document","Source No.","Location Code");
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
                    DocPrint: Codeunit "Document-Print";
                begin
                    DocPrint.PrintTransferHeader(Rec);
                end;
            }
            group(Release)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action("Re&lease")
                {
                    ApplicationArea = Basic;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Process;
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
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Create Whse. S&hipment")
                {
                    AccessByPermission = TableData "Warehouse Shipment Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Create Whse. S&hipment';
                    Image = NewShipment;

                    trigger OnAction()
                    var
                        GetSourceDocOutbound: Codeunit "Get Source Doc. Outbound";
                    begin
                        GetSourceDocOutbound.CreateFromOutbndTransferOrder(Rec);
                    end;
                }
                action("Create &Whse. Receipt")
                {
                    AccessByPermission = TableData "Warehouse Receipt Header"=R;
                    ApplicationArea = Basic;
                    Caption = 'Create &Whse. Receipt';
                    Image = NewReceipt;

                    trigger OnAction()
                    var
                        GetSourceDocInbound: Codeunit "Get Source Doc. Inbound";
                    begin
                        GetSourceDocInbound.CreateFromInbndTransferOrder(Rec);
                    end;
                }
                action("Create Inventor&y Put-away/Pick")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create Inventor&y Put-away/Pick';
                    Ellipsis = true;
                    Image = CreatePutawayPick;

                    trigger OnAction()
                    begin
                        CreateInvtPutAwayPick;
                    end;
                }
                action("Get Bin Content")
                {
                    AccessByPermission = TableData "Bin Content"=R;
                    ApplicationArea = Basic;
                    Caption = 'Get Bin Content';
                    Ellipsis = true;
                    Image = GetBinContent;

                    trigger OnAction()
                    var
                        BinContent: Record "Bin Content";
                        GetBinContent: Report "Whse. Get Bin Content";
                    begin
                        BinContent.SetRange("Location Code","Transfer-from Code");
                        GetBinContent.SetTableview(BinContent);
                        GetBinContent.InitializeTransferHeader(Rec);
                        GetBinContent.RunModal;
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"TransferOrder-Post (Yes/No)",Rec);
                    end;
                }
                action(PostAndPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"TransferOrder-Post + Print",Rec);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Inventory - Inbound Transfer")
            {
                ApplicationArea = Basic;
                Caption = 'Inventory - Inbound Transfer';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Inbound Transfer";
            }
        }
    }
}

