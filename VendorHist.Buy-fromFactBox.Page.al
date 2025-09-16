#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9095 "Vendor Hist. Buy-from FactBox"
{
    Caption = 'Buy-from Vendor History';
    PageType = CardPart;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = All;
                Caption = 'Vendor No.';
                ToolTip = 'Specifies the number of the vendor. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                Visible = ShowVendorNo;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            group(Control23)
            {
                Visible = RegularFastTabVisible;
                field(NoOfQuotes;NoOfQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Quotes",PurchHdr);
                    end;
                }
                field(NoOfBlanketOrders;NoOfBlanketOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Orders';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Blanket Purchase Orders",PurchHdr);
                    end;
                }
                field(NoOfOrders;NoOfOrders)
                {
                    ApplicationArea = Suite;
                    Caption = 'Orders';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Order List",PurchHdr);
                    end;
                }
                field(NoOfInvoices;NoOfInvoices)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoices';
                    DrillDown = true;
                    Editable = true;
                    ToolTip = 'Specifies the amount that relates to invoices.';

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Invoices",PurchHdr);
                    end;
                }
                field(NoOfReturnOrders;NoOfReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Return Order List",PurchHdr);
                    end;
                }
                field(NoOfCreditMemos;NoOfCreditMemos)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Credit Memos';
                    DrillDown = true;
                    Editable = true;
                    ToolTip = 'Specifies the amount that relates to credit memos.';

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Credit Memos",PurchHdr);
                    end;
                }
                field(NoOfPostedReturnShipments;NoOfPostedReturnShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Return Shipments';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        PurchReturnShptHdr: Record "Return Shipment Header";
                    begin
                        PurchReturnShptHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Return Shipments",PurchReturnShptHdr);
                    end;
                }
                field(NoOfPostedReceipts;NoOfPostedReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Receipts';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        PurchReceiptHdr: Record "Purch. Rcpt. Header";
                    begin
                        PurchReceiptHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Purchase Receipts",PurchReceiptHdr);
                    end;
                }
                field(NoOfPostedInvoices;NoOfPostedInvoices)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Invoices';
                    DrillDown = true;
                    Editable = true;
                    ToolTip = 'Specifies the amount that relates to invoices.';

                    trigger OnDrillDown()
                    var
                        PurchInvHdr: Record "Purch. Inv. Header";
                    begin
                        PurchInvHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Purchase Invoices",PurchInvHdr);
                    end;
                }
                field(NoOfPostedCreditMemos;NoOfPostedCreditMemos)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Credit Memos';
                    DrillDown = true;
                    Editable = true;
                    ToolTip = 'Specifies the amount that relates to credit memos.';

                    trigger OnDrillDown()
                    var
                        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                    begin
                        PurchCrMemoHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Purchase Credit Memos",PurchCrMemoHdr);
                    end;
                }
                field(NoOfIncomingDocuments;NoOfIncomingDocuments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Incoming Documents';
                    ToolTip = 'Specifies the amount that relates to Incoming Documents.';

                    trigger OnDrillDown()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.SetRange("Vendor Name",Name);
                        Page.Run(Page::"Incoming Documents",IncomingDocument);
                    end;
                }
            }
            cuegroup(Control1)
            {
                Visible = CuesVisible;
                field(CueQuotes;NoOfQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Quotes",PurchHdr);
                    end;
                }
                field(CueBlanketOrders;NoOfBlanketOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Orders';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Blanket Purchase Orders",PurchHdr);
                    end;
                }
                field(CueOrders;NoOfOrders)
                {
                    ApplicationArea = Suite;
                    Caption = 'Orders';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Order List",PurchHdr);
                    end;
                }
                field(CueInvoices;NoOfInvoices)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoices';
                    DrillDown = true;
                    ToolTip = 'Specifies the amount that relates to invoices.';

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Invoices",PurchHdr);
                    end;
                }
                field(CueReturnOrders;NoOfReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Return Order List",PurchHdr);
                    end;
                }
                field(CueCreditMemos;NoOfCreditMemos)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Credit Memos';
                    DrillDown = true;
                    ToolTip = 'Specifies the amount that relates to credit memos.';

                    trigger OnDrillDown()
                    var
                        PurchHdr: Record "Purchase Header";
                    begin
                        PurchHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Purchase Credit Memos",PurchHdr);
                    end;
                }
                field(CuePostedRetShip;NoOfPostedReturnShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Return Shipments';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        PurchReturnShptHdr: Record "Return Shipment Header";
                    begin
                        PurchReturnShptHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Return Shipments",PurchReturnShptHdr);
                    end;
                }
                field(CuePostedReceipts;NoOfPostedReceipts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Receipts';
                    DrillDown = true;

                    trigger OnDrillDown()
                    var
                        PurchRcptHeader: Record "Purch. Rcpt. Header";
                    begin
                        PurchRcptHeader.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Purchase Receipts",PurchRcptHeader);
                    end;
                }
                field(CuePostedInvoices;NoOfPostedInvoices)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Invoices';
                    DrillDown = true;
                    ToolTip = 'Specifies the amount that relates to invoices.';

                    trigger OnDrillDown()
                    var
                        PurchInvHdr: Record "Purch. Inv. Header";
                    begin
                        PurchInvHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Purchase Invoices",PurchInvHdr);
                    end;
                }
                field(CuePostedCreditMemos;NoOfPostedCreditMemos)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Credit Memos';
                    DrillDown = true;
                    ToolTip = 'Specifies the amount that relates to credit memos.';

                    trigger OnDrillDown()
                    var
                        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                    begin
                        PurchCrMemoHdr.SetRange("Buy-from Vendor No.","No.");
                        Page.Run(Page::"Posted Purchase Credit Memos",PurchCrMemoHdr);
                    end;
                }
                field(CueIncomingDocuments;NoOfIncomingDocuments)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Incoming Documents';
                    ToolTip = 'Specifies the amount that relates to Incoming Documents.';

                    trigger OnDrillDown()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.SetRange("Vendor Name",Name);
                        Page.Run(Page::"Incoming Documents",IncomingDocument);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        CalcNoOfBuyRecords;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        NoOfQuotes := 0;
        NoOfBlanketOrders := 0;
        NoOfOrders := 0;
        NoOfInvoices := 0;
        NoOfReturnOrders := 0;
        NoOfCreditMemos := 0;
        NoOfPostedReturnShipments := 0;
        NoOfPostedReceipts := 0;
        NoOfPostedInvoices := 0;
        NoOfPostedCreditMemos := 0;

        exit(Find(Which));
    end;

    trigger OnInit()
    begin
        ShowVendorNo := true;
    end;

    trigger OnOpenPage()
    var
        OfficeManagement: Codeunit "Office Management";
    begin
        CalcNoOfBuyRecords;
        RegularFastTabVisible := CurrentClientType = Clienttype::Windows;
        CuesVisible := (not RegularFastTabVisible) or OfficeManagement.IsAvailable;
    end;

    var
        RegularFastTabVisible: Boolean;
        CuesVisible: Boolean;
        NoOfQuotes: Integer;
        NoOfBlanketOrders: Integer;
        NoOfOrders: Integer;
        NoOfInvoices: Integer;
        NoOfReturnOrders: Integer;
        NoOfCreditMemos: Integer;
        NoOfPostedReturnShipments: Integer;
        NoOfPostedReceipts: Integer;
        NoOfPostedInvoices: Integer;
        NoOfPostedCreditMemos: Integer;
        NoOfIncomingDocuments: Integer;
        ShowVendorNo: Boolean;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Vendor Card",Rec);
    end;

    local procedure CalcNoOfBuyRecords()
    var
        PurchHeader: Record "Purchase Header";
        PurchReturnShptHeader: Record "Return Shipment Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchReceiptHeader: Record "Purch. Rcpt. Header";
        IncomingDocument: Record "Incoming Document";
    begin
        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type",PurchHeader."document type"::Quote);
        PurchHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfQuotes := PurchHeader.Count;

        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type",PurchHeader."document type"::"Blanket Order");
        PurchHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfBlanketOrders := PurchHeader.Count;

        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type",PurchHeader."document type"::Order);
        PurchHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfOrders := PurchHeader.Count;

        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type",PurchHeader."document type"::"Return Order");
        PurchHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfReturnOrders := PurchHeader.Count;

        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type",PurchHeader."document type"::Invoice);
        PurchHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfInvoices := PurchHeader.Count;

        PurchHeader.Reset;
        PurchHeader.SetRange("Document Type",PurchHeader."document type"::"Credit Memo");
        PurchHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfCreditMemos := PurchHeader.Count;

        PurchReturnShptHeader.Reset;
        PurchReturnShptHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfPostedReturnShipments := PurchReturnShptHeader.Count;

        PurchInvHeader.Reset;
        PurchInvHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfPostedInvoices := PurchInvHeader.Count;

        PurchCrMemoHeader.Reset;
        PurchCrMemoHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfPostedCreditMemos := PurchCrMemoHeader.Count;

        PurchReceiptHeader.Reset;
        PurchReceiptHeader.SetRange("Buy-from Vendor No.","No.");
        NoOfPostedReceipts := PurchReceiptHeader.Count;

        IncomingDocument.Reset;
        IncomingDocument.SetRange("Vendor Name",Name);
        NoOfIncomingDocuments := IncomingDocument.Count;
    end;


    procedure SetVendorNoVisibility(Visible: Boolean)
    begin
        ShowVendorNo := Visible;
    end;
}

