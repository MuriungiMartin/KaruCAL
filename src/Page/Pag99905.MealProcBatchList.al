#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99905 "Meal-Proc. Batch List"
{
    ApplicationArea = Basic;
    CardPageID = "Meal-Proc. Batch Card";
    DeleteAllowed = false;
    InsertAllowed = true;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = UnknownTable99900;
    SourceTableView = sorting("Batch Date","Production  Area")
                      order(descending)
                      where(Status=filter(Draft));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Batch Date";"Batch Date")
                {
                    ApplicationArea = Basic;
                }
                field("Created Time";"Created Time")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Month";"Batch Month")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Month Name";"Batch Month Name")
                {
                    ApplicationArea = Basic;
                }
                field("Batch Year";"Batch Year")
                {
                    ApplicationArea = Basic;
                }
                field("No of Items";"No of Items")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Total Value";"Total Value")
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Repopulate)
            {
                ApplicationArea = Basic;
                Caption = 'Re-Populate Items';
                Image = PostedMemo;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if Confirm('CONFIRM:\Re-populate Items?',false)=false then Error('Cancelled!');
                    Rec.Validate("Batch Date");
                    Message('Items Populated Automatically!');
                end;
            }
            action(MarkasFin)
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Final';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                     if Rec.Status<>Rec.Status::Draft then Error('Already Closed!');


                    if Confirm('CONFIRM:\Mark as Final?',false)=false then exit;
                    if Confirm('******WARNING!!!!!!!:\You will not post into an already posted Batch. \Continue?',false)=false then exit;
                      Rec.Status:=Rec.Status::Final;
                      Rec.Modify;
                end;
            }
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
                RunObject = Report "Daily Meal-Proc. Summary";

                trigger OnAction()
                var
                    ProductionBatches: Record UnknownRecord99900;
                begin
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

