#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9085 "Service Hist. Sell-to FactBox"
{
    Caption = 'Customer Service History - Sell-to Customer';
    PageType = CardPart;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = All;
                Caption = 'Customer No.';
                ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            group(Control1)
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
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Quotes",ServiceHeader);
                    end;
                }
                field(NoOfOrders;NoOfOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Orders",ServiceHeader);
                    end;
                }
                field(NoOfInvoices;NoOfInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoices';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Invoices",ServiceHeader);
                    end;
                }
                field(NoOfCreditMemos;NoOfCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Credit Memos';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Credit Memos",ServiceHeader);
                    end;
                }
                field(NoOfPostedShipments;NoOfPostedShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Shipments';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceShipmentHdr: Record "Service Shipment Header";
                    begin
                        ServiceShipmentHdr.SetRange("Customer No.","No.");
                        Page.Run(Page::"Posted Service Shipments",ServiceShipmentHdr);
                    end;
                }
                field(NoOfPostedInvoices;NoOfPostedInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Invoices';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceInvoiceHdr: Record "Service Invoice Header";
                    begin
                        ServiceInvoiceHdr.SetRange("Customer No.","No.");
                        Page.Run(Page::"Posted Service Invoices",ServiceInvoiceHdr);
                    end;
                }
                field(NoOfPostedCreditMemos;NoOfPostedCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Credit Memos';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceCrMemoHdr: Record "Service Cr.Memo Header";
                    begin
                        ServiceCrMemoHdr.SetRange("Customer No.","No.");
                        Page.Run(Page::"Posted Service Credit Memos",ServiceCrMemoHdr);
                    end;
                }
            }
            cuegroup(Control14)
            {
                Visible = not RegularFastTabVisible;
                field(NoOfQuotesTile;NoOfQuotes)
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Quotes",ServiceHeader);
                    end;
                }
                field(NoOfOrdersTile;NoOfOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Orders",ServiceHeader);
                    end;
                }
                field(NoOfInvoicesTile;NoOfInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Invoices';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Invoices",ServiceHeader);
                    end;
                }
                field(NoOfCreditMemosTile;NoOfCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Credit Memos';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceHeader: Record "Service Header";
                    begin
                        ServiceHeader.SetRange("Customer No.","No.");
                        Page.Run(Page::"Service Credit Memos",ServiceHeader);
                    end;
                }
                field(NoOfPostedShipmentsTile;NoOfPostedShipments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Shipments';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceShipmentHdr: Record "Service Shipment Header";
                    begin
                        ServiceShipmentHdr.SetRange("Customer No.","No.");
                        Page.Run(Page::"Posted Service Shipments",ServiceShipmentHdr);
                    end;
                }
                field(NoOfPostedInvoicesTile;NoOfPostedInvoices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Invoices';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceInvoiceHdr: Record "Service Invoice Header";
                    begin
                        ServiceInvoiceHdr.SetRange("Customer No.","No.");
                        Page.Run(Page::"Posted Service Invoices",ServiceInvoiceHdr);
                    end;
                }
                field(NoOfPostedCreditMemosTile;NoOfPostedCreditMemos)
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Credit Memos';
                    DrillDown = true;
                    Editable = true;

                    trigger OnDrillDown()
                    var
                        ServiceCrMemoHdr: Record "Service Cr.Memo Header";
                    begin
                        ServiceCrMemoHdr.SetRange("Customer No.","No.");
                        Page.Run(Page::"Posted Service Credit Memos",ServiceCrMemoHdr);
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
        CalcNoOfRecords;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        NoOfQuotes := 0;
        NoOfOrders := 0;
        NoOfInvoices := 0;
        NoOfCreditMemos := 0;
        NoOfPostedShipments := 0;
        NoOfPostedInvoices := 0;
        NoOfPostedCreditMemos := 0;

        exit(Find(Which));
    end;

    trigger OnOpenPage()
    begin
        CalcNoOfRecords;
        RegularFastTabVisible := CurrentClientType = Clienttype::Windows;
    end;

    var
        RegularFastTabVisible: Boolean;
        NoOfQuotes: Integer;
        NoOfOrders: Integer;
        NoOfInvoices: Integer;
        NoOfCreditMemos: Integer;
        NoOfPostedShipments: Integer;
        NoOfPostedInvoices: Integer;
        NoOfPostedCreditMemos: Integer;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Customer Card",Rec);
    end;

    local procedure CalcNoOfRecords()
    var
        ServHeader: Record "Service Header";
        ServShptHeader: Record "Service Shipment Header";
        ServInvHeader: Record "Service Invoice Header";
        ServCrMemoHeader: Record "Service Cr.Memo Header";
    begin
        ServHeader.Reset;
        ServHeader.SetRange("Document Type",ServHeader."document type"::Quote);
        ServHeader.SetRange("Customer No.","No.");
        NoOfQuotes := ServHeader.Count;

        ServHeader.Reset;
        ServHeader.SetRange("Document Type",ServHeader."document type"::Order);
        ServHeader.SetRange("Customer No.","No.");
        NoOfOrders := ServHeader.Count;

        ServHeader.Reset;
        ServHeader.SetRange("Document Type",ServHeader."document type"::Invoice);
        ServHeader.SetRange("Customer No.","No.");
        NoOfInvoices := ServHeader.Count;

        ServHeader.Reset;
        ServHeader.SetRange("Document Type",ServHeader."document type"::"Credit Memo");
        ServHeader.SetRange("Customer No.","No.");
        NoOfCreditMemos := ServHeader.Count;

        ServShptHeader.Reset;
        ServShptHeader.SetRange("Customer No.","No.");
        NoOfPostedShipments := ServShptHeader.Count;

        ServInvHeader.Reset;
        ServInvHeader.SetRange("Customer No.","No.");
        NoOfPostedInvoices := ServInvHeader.Count;

        ServCrMemoHeader.Reset;
        ServCrMemoHeader.SetRange("Customer No.","No.");
        NoOfPostedCreditMemos := ServCrMemoHeader.Count;
    end;
}

