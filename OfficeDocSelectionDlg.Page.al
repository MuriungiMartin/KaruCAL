#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1606 "Office Doc Selection Dlg"
{
    Caption = 'No document found';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    ShowFilter = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            label(Control4)
            {
                ApplicationArea = Basic;
            }
            label(Control2)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'This document could not be found. You may use the links below to browse document lists or search for a specific document.';
                Editable = false;
                HideValue = true;
            }
            group("Search Sales Documents")
            {
                Caption = 'Search Sales Documents';
                Editable = false;
                field(SalesQuotes;SalesQuotesLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies entered sales quotes.';

                    trigger OnDrillDown()
                    begin
                        with DummyOfficeDocumentSelection do
                          OfficeDocumentHandler.ShowDocumentSelection(Series::Sales,"document type"::Quote);
                    end;
                }
                field(SalesOrders;SalesOrdersLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies entered sales orders.';

                    trigger OnDrillDown()
                    begin
                        with DummyOfficeDocumentSelection do
                          OfficeDocumentHandler.ShowDocumentSelection(Series::Sales,"document type"::Order);
                    end;
                }
                field(SalesInvoices;SalesInvoicesLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies entered sales invoices.';

                    trigger OnDrillDown()
                    begin
                        with DummyOfficeDocumentSelection do
                          OfficeDocumentHandler.ShowDocumentSelection(Series::Sales,"document type"::Invoice);
                    end;
                }
                field(SalesCrMemos;SalesCredMemosLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies entered sales credit memos.';

                    trigger OnDrillDown()
                    begin
                        with DummyOfficeDocumentSelection do
                          OfficeDocumentHandler.ShowDocumentSelection(Series::Sales,"document type"::"Credit Memo");
                    end;
                }
            }
            group("Search Purchasing Documents")
            {
                Caption = 'Search Purchasing Documents';
                field(PurchaseOrders;PurchOrdersLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies entered purchase orders.';

                    trigger OnDrillDown()
                    begin
                        with DummyOfficeDocumentSelection do
                          OfficeDocumentHandler.ShowDocumentSelection(Series::Purchase,"document type"::Order);
                    end;
                }
                field(PurchaseInvoices;PurchInvoicesLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies entered purchase invoices.';

                    trigger OnDrillDown()
                    begin
                        with DummyOfficeDocumentSelection do
                          OfficeDocumentHandler.ShowDocumentSelection(Series::Purchase,"document type"::Invoice);
                    end;
                }
                field(PurchaseCrMemos;PurchCredMemosLbl)
                {
                    ApplicationArea = Basic,Suite;
                    Editable = false;
                    ShowCaption = false;
                    ToolTip = 'Specifies entered purchase credit memos.';

                    trigger OnDrillDown()
                    begin
                        with DummyOfficeDocumentSelection do
                          OfficeDocumentHandler.ShowDocumentSelection(Series::Purchase,"document type"::"Credit Memo");
                    end;
                }
            }
        }
    }

    actions
    {
    }

    var
        DummyOfficeDocumentSelection: Record "Office Document Selection";
        SalesOrdersLbl: label 'Sales Orders';
        SalesQuotesLbl: label 'Sales Quotes';
        SalesInvoicesLbl: label 'Sales Invoices';
        SalesCredMemosLbl: label 'Sales Credit Memos';
        PurchInvoicesLbl: label 'Purchase Invoices';
        PurchCredMemosLbl: label 'Purchase Credit Memos';
        OfficeDocumentHandler: Codeunit "Office Document Handler";
        PurchOrdersLbl: label 'Purchase Orders';
}

