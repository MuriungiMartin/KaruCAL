#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99900 "Meal-Proc. Batch Card"
{
    DataCaptionFields = "Batch Date",Status,"Created By";
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = UnknownTable99900;

    layout
    {
        area(content)
        {
            group(Group)
            {
                field("Batch ID";"Batch ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Batch Date";"Batch Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Production  Area";"Production  Area")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Daily Total";"Daily Total")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
            part(Control1000000003;"Meal-Proc. Batch Lines")
            {
                Caption = 'Orders List';
                SubPageLink = "Batch Date"=field("Batch Date"),
                              "Batch ID"=field("Batch ID");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(BOMSummary)
            {
                ApplicationArea = Basic;
                Caption = 'BoM Summary report';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "BOM Summary Report - Meal";

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
                end;
            }
            action(DailyProdSummary)
            {
                ApplicationArea = Basic;
                Caption = 'Daily prod. Summary';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
                    MealProcBatchesLines.Reset;
                    MealProcBatchesLines.SetRange("Batch Date",Rec."Batch Date");
                    if MealProcBatchesLines.Find('-') then begin
                        Report.Run(99900,true,false,MealProcBatchesLines);
                      end;
                end;
            }
            action(MonthlyProdSummary)
            {
                ApplicationArea = Basic;
                Caption = 'Monthly Pro. Summary';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Monthly Meal-Proc. Summary";

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
                end;
            }
            action(MonthlyProdAnalysis)
            {
                ApplicationArea = Basic;
                Caption = 'Monthly Pro. Analysis';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Monthly Meal-Proc. Analysis";

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
                end;
            }
            action(RMSumm)
            {
                ApplicationArea = Basic;
                Caption = 'Material Requisition Summ.';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Meal Cons. Material Req. Sum.";

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
                end;
            }
            action(RmMontTo)
            {
                ApplicationArea = Basic;
                Caption = 'Monthly Raw Material Summary';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Monthly Comsumption Rm Sum.";

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
                end;
            }
            action(RMMontlySumm2)
            {
                ApplicationArea = Basic;
                Caption = 'Monthly Consuption Sum';
                Image = PrintForm;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Report "Meal Proc. Monthly Consumption";

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
                end;
            }
            action(ProcBatched)
            {
                ApplicationArea = Basic;
                Caption = 'Proccessing Batches';
                Image = Description;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "Meal Process Batches";
                RunPageLink = "Batch Date"=field("Batch Date");
            }
        }
    }

    var
        MealProcBatchesLines: Record UnknownRecord99901;
        ProductionBatches1: Record UnknownRecord99900;
        lineNo: Integer;
        DateFilter: Date;
        ProductionBatches: Record UnknownRecord99900;
        NextOderNo: Code[20];
        SalesSetup: Record "Sales & Receivables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesCommentLine: Record "Sales Comment Line";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        InvtSetup: Record "Inventory Setup";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        CompanyInfo: Record "Company Information";
        UserSetupMgt: Codeunit "User Setup Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WhseSourceHeader: Codeunit "Whse. Validate Source Header";
        ArchiveManagement: Codeunit ArchiveManagement;
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        InsertMode: Boolean;
        HideCreditCheckDialogue: Boolean;
        UpdateDocumentDate: Boolean;
        BilltoCustomerNoChanged: Boolean;
        FINCashOfficeUserTemplate: Record UnknownRecord61712;
        Customer: Record Customer;
        ProductionCustProdSource: Record UnknownRecord99902;
        Item: Record Item;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesShipmentHeader: Record "Sales Shipment Header";
        DocPrint: Codeunit "Document-Print";
        Usage: Option "Order Confirmation","Work Order","Pick Instruction";
}

