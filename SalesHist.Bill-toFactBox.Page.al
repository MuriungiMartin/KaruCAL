#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9081 "Sales Hist. Bill-to FactBox"
{
    Caption = 'Customer Sales History';
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
                Visible = ShowCustomerNo;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            group(Control2)
            {
                Visible = RegularFastTabVisible;
                field("Bill-To No. of Quotes";"Bill-To No. of Quotes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    DrillDownPageID = "Sales Quotes";
                    ToolTip = 'Specifies how many quotes have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Blanket Orders";"Bill-To No. of Blanket Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Orders';
                    DrillDownPageID = "Blanket Sales Orders";
                    ToolTip = 'Specifies how many blanket orders have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Orders";"Bill-To No. of Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Orders';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies how many sales orders have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Invoices";"Bill-To No. of Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoices';
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Specifies how many invoices have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Return Orders";"Bill-To No. of Return Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    DrillDownPageID = "Sales Return Order List";
                    ToolTip = 'Specifies how many return orders have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Credit Memos";"Bill-To No. of Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Credit Memos';
                    DrillDownPageID = "Sales Credit Memos";
                    ToolTip = 'Specifies how many credit memos have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Pstd. Shipments";"Bill-To No. of Pstd. Shipments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Shipments';
                    DrillDownPageID = "Posted Sales Shipments";
                    ToolTip = 'Specifies how many posted shipments have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Pstd. Invoices";"Bill-To No. of Pstd. Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Invoices';
                    DrillDownPageID = "Posted Sales Invoices";
                    ToolTip = 'Specifies how many posted invoices have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Pstd. Return R.";"Bill-To No. of Pstd. Return R.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Return Receipts';
                    DrillDownPageID = "Posted Return Receipts";
                    ToolTip = 'Specifies how many posted return receipts have been registered for the customer when the customer acts as the customer.';
                }
                field("Bill-To No. of Pstd. Cr. Memos";"Bill-To No. of Pstd. Cr. Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Credit Memos';
                    DrillDownPageID = "Posted Sales Credit Memos";
                    ToolTip = 'Specifies how many posted credit memos have been registered for the customer when the customer acts as the customer.';
                }
            }
            cuegroup(Control23)
            {
                Visible = CuesVisible;
                field(NoOfQuotesTile;"Bill-To No. of Quotes")
                {
                    ApplicationArea = Basic;
                    Caption = 'Quotes';
                    DrillDownPageID = "Sales Quotes";
                    ToolTip = 'Specifies how many quotes have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfBlanketOrdersTile;"Bill-To No. of Blanket Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Blanket Orders';
                    DrillDownPageID = "Blanket Sales Orders";
                    ToolTip = 'Specifies how many blanket orders have been registered for the customer when the customer acts as the customer.';
                }
                field(NorOfOrdersTile;"Bill-To No. of Orders")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Orders';
                    DrillDownPageID = "Sales Order List";
                    ToolTip = 'Specifies how many sales orders have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfInvoicesTile;"Bill-To No. of Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Invoices';
                    DrillDownPageID = "Sales Invoice List";
                    ToolTip = 'Specifies how many invoices have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfReturnOrdersTile;"Bill-To No. of Return Orders")
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    DrillDownPageID = "Sales Return Order List";
                    ToolTip = 'Specifies how many return orders have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfCreditMemosTile;"Bill-To No. of Credit Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Credit Memos';
                    DrillDownPageID = "Sales Credit Memos";
                    ToolTip = 'Specifies how many credit memos have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfPostedShipmentsTile;"Bill-To No. of Pstd. Shipments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Shipments';
                    DrillDownPageID = "Posted Sales Shipments";
                    ToolTip = 'Specifies how many posted shipments have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfPostedInvoicesTile;"Bill-To No. of Pstd. Invoices")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Invoices';
                    DrillDownPageID = "Posted Sales Invoices";
                    ToolTip = 'Specifies how many posted invoices have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfPostedReturnOrdersTile;"Bill-To No. of Pstd. Return R.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Pstd. Return Receipts';
                    DrillDownPageID = "Posted Return Receipts";
                    ToolTip = 'Specifies how many posted return receipts have been registered for the customer when the customer acts as the customer.';
                }
                field(NoOfPostedCrMemosTile;"Bill-To No. of Pstd. Cr. Memos")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Pstd. Credit Memos';
                    DrillDownPageID = "Posted Sales Credit Memos";
                    ToolTip = 'Specifies how many posted credit memos have been registered for the customer when the customer acts as the customer.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        if Find(Which) then begin
          FilterGroup(4);
          SetFilter("No.",GetBillToCustomerNo);
          FilterGroup(0);
        end;

        exit(Find(Which));
    end;

    trigger OnInit()
    begin
        ShowCustomerNo := true;
    end;

    trigger OnOpenPage()
    var
        OfficeManagement: Codeunit "Office Management";
    begin
        RegularFastTabVisible := CurrentClientType = Clienttype::Windows;
        CuesVisible := (not RegularFastTabVisible) or OfficeManagement.IsAvailable;
    end;

    var
        ShowCustomerNo: Boolean;
        RegularFastTabVisible: Boolean;
        CuesVisible: Boolean;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Customer Card",Rec);
    end;


    procedure SetCustomerNoVisibility(Visible: Boolean)
    begin
        ShowCustomerNo := Visible;
    end;
}

