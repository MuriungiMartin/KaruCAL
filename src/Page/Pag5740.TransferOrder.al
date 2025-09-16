#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5740 "Transfer Order"
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
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the transfer order.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field("Transfer-from Code";"Transfer-from Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location from which items are transferred.';
                }
                field("Transfer-to Code";"Transfer-to Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the location that you are transferring items to.';
                }
                field("In-Transit Code";"In-Transit Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the in-transit code that identifies this transfer.';
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting date of the transfer order.';

                    trigger OnValidate()
                    begin
                        PostingDateOnAfterValidate;
                    end;
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 1.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the dimension value code for the dimension that has been chosen as Global Dimension 2.';
                }
                field("Assigned User ID";"Assigned User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID of the user who is responsible for the document.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Indicates whether the transfer order is open or has been released for the next stage of processing.';
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
                    ToolTip = 'Specifies the name of the location from which items are transferred.';
                }
                field("Transfer-from Name 2";"Transfer-from Name 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional part of the name of the location from which items are transferred.';
                }
                field("Transfer-from Address";"Transfer-from Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the location from which items are transferred.';
                }
                field("Transfer-from Address 2";"Transfer-from Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional part of the address.';
                }
                field("Transfer-from City";"Transfer-from City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the location from which items are transferred.';
                }
                field("Transfer-from County";"Transfer-from County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer-from State / ZIP Code';
                }
                field("Transfer-from Post Code";"Transfer-from Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the location from which items are transferred.';
                }
                field("Transfer-from Contact";"Transfer-from Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person at the transfer-from location.';
                }
                field("Shipment Date";"Shipment Date")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date the order is expected to be shipped.';

                    trigger OnValidate()
                    begin
                        ShipmentDateOnAfterValidate;
                    end;
                }
                field("Outbound Whse. Handling Time";"Outbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time it takes for the Transfer-from location to prepare the shipment to the Transfer-to location.';

                    trigger OnValidate()
                    begin
                        OutboundWhseHandlingTimeOnAfte;
                    end;
                }
                field("Shipment Method Code";"Shipment Method Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipment method code that you have entered for this order.';
                }
                field("Shipping Agent Code";"Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for the shipping agent you are using to ship the items on this transfer order.';

                    trigger OnValidate()
                    begin
                        ShippingAgentCodeOnAfterValida;
                    end;
                }
                field("Shipping Agent Service Code";"Shipping Agent Service Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for the shipping agent service that you are using to ship the items on this transfer order.';

                    trigger OnValidate()
                    begin
                        ShippingAgentServiceCodeOnAfte;
                    end;
                }
                field("Shipping Time";"Shipping Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the shipping time, used to calculate the receipt date.';

                    trigger OnValidate()
                    begin
                        ShippingTimeOnAfterValidate;
                    end;
                }
                field("Shipping Advice";"Shipping Advice")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies advice for the warehouse sending the items, about whether a partial delivery is acceptable.';

                    trigger OnValidate()
                    begin
                        if "Shipping Advice" <> xRec."Shipping Advice" then
                          if not Confirm(Text000,false,FieldCaption("Shipping Advice")) then
                            Error('');
                    end;
                }
            }
            group("Transfer-to")
            {
                Caption = 'Transfer-to';
                field("Transfer-to Name";"Transfer-to Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the location that you are transferring items to.';
                }
                field("Transfer-to Name 2";"Transfer-to Name 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional part of the transfer-to name of the location that you are transferring items to.';
                }
                field("Transfer-to Address";"Transfer-to Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the address of the location that you are transferring items to.';
                }
                field("Transfer-to Address 2";"Transfer-to Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional part of the address of the location to which items are transferred.';
                }
                field("Transfer-to City";"Transfer-to City")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the city of the location that you are transferring items to.';
                }
                field("Transfer-to County";"Transfer-to County")
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer-to State / ZIP Code';
                }
                field("Transfer-to Post Code";"Transfer-to Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ZIP code of the location that you are transferring items to.';
                }
                field("Transfer-to Contact";"Transfer-to Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the contact person at the transfer-to location.';
                }
                field("Receipt Date";"Receipt Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date that you expect the transfer-to location to receive the shipment.';

                    trigger OnValidate()
                    begin
                        ReceiptDateOnAfterValidate;
                    end;
                }
                field("Inbound Whse. Handling Time";"Inbound Whse. Handling Time")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the time it takes to make items part of available inventory, after the items have been posted as received.';

                    trigger OnValidate()
                    begin
                        InboundWhseHandlingTimeOnAfter;
                    end;
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Transaction Type";"Transaction Type")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the transaction type of the transfer.';
                }
                field("Transaction Specification";"Transaction Specification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the transaction specification code that was used in the transfer.';
                }
                field("Transport Method";"Transport Method")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code for the transport method used for the item on this line.';
                }
                field("Area";Area)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code for an area at the customer or vendor with which you are trading the items on the line.';
                }
                field("Entry/Exit Point";"Entry/Exit Point")
                {
                    ApplicationArea = Basic;
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
                    Promoted = true;
                    PromotedCategory = Process;

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
                    Image = CreateInventoryPickup;

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
                        //Send notification
                          CompanyInfo.Get();
                          SMTPSetup.Get();
                          SenderName:=CompanyInfo.Name;
                          SenderAddress:=SMTPSetup."Payments Email Address";
                          Receipient:=SMTPSetup."Email Sender Address";//'bndegwa@pedaids.org';
                          Subject:=Text001;
                          Message(Receipient);
                          Body:=StrSubstNo(Text002,UserId);
                          SMTP.CreateMessage(SenderName,SenderAddress,Receipient,Subject,Body,true);
                          SMTP.AppendBody(Text003);
                          SMTP.AppendBody(Text004);
                          SMTP.AppendBody:=StrSubstNo(Text005,"Transfer-from Code");
                          SMTP.AppendBody:=StrSubstNo(Text016,"Transfer-to Code");
                          //SMTP.AppendBody:=STRSUBSTNO(Text006,COPYSTR("Beneficiary Account No",6,5));
                          SMTP.AppendBody:=StrSubstNo(Text007,Format("Date Filter",0,4));
                          //SMTP.AppendBody:=STRSUBSTNO(Text008,Amount);
                          SMTP.AppendBody:=StrSubstNo(Text009,"No.");
                          SMTP.AppendBody(Text012);
                          SMTP.AppendBody(Text015);
                          SMTP.AppendBody(Text015);
                          SMTP.AppendBody(Text013);
                          SMTP.AppendBody(Text015);
                          SMTP.AppendBody(Text015);
                          SMTP.AppendBody(Text015);
                          SMTP.AppendBody(CompanyInfo.Name);
                          //SMTP.AddAttachment('\\172.20.90.142\leadway external notifications\'+'PAY ADVICE_'+No+'_'+FORMAT(LineNo)+'.pdf');
                          //IF Email<>'' THEN
                          SMTP.Send();
                          ///END;
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

    trigger OnDeleteRecord(): Boolean
    begin
        TestField(Status,Status::Open);
    end;

    var
        Text000: label 'Do you want to change %1 in all related records in the warehouse?';
        NoSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Vend: Record Vendor;
        Banks: Record "Bank Account";
        CompanyInfo: Record "Company Information";
        SenderName: Text[250];
        SenderAddress: Text[250];
        Subject: Text[250];
        Receipient: Text[250];
        Body: Text;
        SMTP: Codeunit "SMTP Mail";
        ThisNarration: Text;
        SMTPSetup: Record "SMTP Mail Setup";
        LastNo: Integer;
        Text001: label 'TRANSFER ORDER NOTE';
        Text002: label '<p>Dear Sir or Madam</p>';
        Text003: label '<p>Kindly be informed of The goods transfered to you with and an executive summary below, and details attached where necessary.</p>';
        Text004: label '<p></p>';
        Text005: label '<table><tr><td> Name</td><td>%1</td></tr>';
        Text006: label '<tr><td>Account No</td><td>xxxxx%1</td></tr>';
        Text007: label '<tr><td>Date of Transfer</td><td>%1</td></tr>';
        Text008: label '<tr><td>Method of transfer</td><td>%1</td></tr>';
        Text009: label '<tr><td>Amount</td><td>NGN%1</td></tr>';
        Text010: label '<tr><td></td><td>%1</td></tr>';
        Text011: label '<tr><td></td><td>%1</td></tr>';
        Text012: label '</table>';
        Text013: label 'Yours Faithfully.';
        Text014: label '%1';
        Text015: label '<br>';
        Text016: label '<tr><td>Order Name</td><td>%1</td></tr>';

    local procedure PostingDateOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(true);
    end;

    local procedure ShipmentDateOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(false);
    end;

    local procedure ShippingAgentServiceCodeOnAfte()
    begin
        CurrPage.TransferLines.Page.UpdateForm(false);
    end;

    local procedure ShippingAgentCodeOnAfterValida()
    begin
        CurrPage.TransferLines.Page.UpdateForm(false);
    end;

    local procedure ShippingTimeOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(false);
    end;

    local procedure OutboundWhseHandlingTimeOnAfte()
    begin
        CurrPage.TransferLines.Page.UpdateForm(false);
    end;

    local procedure ReceiptDateOnAfterValidate()
    begin
        CurrPage.TransferLines.Page.UpdateForm(false);
    end;

    local procedure InboundWhseHandlingTimeOnAfter()
    begin
        CurrPage.TransferLines.Page.UpdateForm(false);
    end;
}

