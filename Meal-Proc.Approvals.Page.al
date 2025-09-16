#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99908 "Meal-Proc. Approvals"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = UnknownTable99901;
    SourceTableView = where("BOM Count"=filter(>0),
                            Approve=filter(No));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group("Filter")
            {
                Caption = 'Filters';
                field(DateFil;DateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Batch Date';

                    trigger OnValidate()
                    begin
                        //Rec.SETFILTER("Batch Date",'=%1',DateFilter);
                        //CurrPage.UPDATE;
                    end;
                }
            }
            repeater(Group)
            {
                field("Item Code";"Item Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Item Description";"Item Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Production  Area";"Production  Area")
                {
                    ApplicationArea = Basic;
                }
                field("Required QTY";"Required QTY")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Requirered Unit of Measure";"Requirered Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("QTY in KGs";"QTY in KGs")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("QTY in Tones";"QTY in Tones")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("BOM Count";"BOM Count")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Batch Serial";"Batch Serial")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Manufacture";"Date of Manufacture")
                {
                    ApplicationArea = Basic;
                }
                field("Expiry Date";"Expiry Date")
                {
                    ApplicationArea = Basic;
                }
                field(Control1000000035;Approve)
                {
                    ApplicationArea = Basic;
                }
                field(Reject;Reject)
                {
                    ApplicationArea = Basic;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Created Time";"Created Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Reject Reason";"Reject Reason")
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
            action("Mark as Final")
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Final';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    ProductionBatches.Reset;
                    ProductionBatches.SetRange(ProductionBatches."Batch Date",DateFilter);
                    ProductionBatches.SetRange(ProductionBatches."Batch ID","Batch ID");
                    if ProductionBatches.Find('-') then begin
                     if ProductionBatches.Status<>ProductionBatches.Status::Draft then Error('');
                      end;


                    if Confirm('CONFIRM:\Mark as Final?',false)=false then exit;
                    ProductionBatches.Reset;
                    ProductionBatches.SetRange(ProductionBatches."Batch Date",DateFilter);
                    ProductionBatches.SetRange(ProductionBatches."Batch ID","Batch ID");
                    if ProductionBatches.Find('-') then begin
                      ProductionBatches.Status:=ProductionBatches.Status::Final;
                      ProductionBatches.Modify;
                      end;
                end;
            }
            action(Approve)
            {
                ApplicationArea = Basic;
                Caption = 'Approve';
                Image = EncryptionKeys;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    MealProcPermissions.Reset;
                    MealProcPermissions.SetRange("User Id",UserId);
                    if MealProcPermissions.Find('-') then begin
                      MealProcPermissions.TestField("Approve Orders");
                      end else Error('Access Denied!');
                    if Confirm('Approve?',true)= false then Error('Cancelled!');
                    Rec.Approve:=true;
                    Rec."Approved by":=UserId;
                    Rec."Approved Time":=Time;
                    if Modify then;
                    Message('Approved!');
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

    trigger OnAfterGetRecord()
    begin
        Rec.SetFilter("Batch Date",'=%1',DateFilter);
        //CLEAR(currPayments);
        /*
        DetailedCustLedgEntry.RESET;
        DetailedCustLedgEntry.SETRANGE(DetailedCustLedgEntry."Customer No.",Rec."Item Code");
        DetailedCustLedgEntry.SETFILTER(DetailedCustLedgEntry."Posting Date",'=%1',TODAY);
        //DetailedCustLedgEntry.SETFILTER(DetailedCustLedgEntry.Amount,'<%1',0);
        IF DetailedCustLedgEntry.FIND('-') THEN BEGIN
          REPEAT
            BEGIN
            IF ((COPYSTR(DetailedCustLedgEntry."Document No.",1,2)='EQ')
              OR (COPYSTR(DetailedCustLedgEntry."Document No.",1,2)='RE')
              OR (COPYSTR(DetailedCustLedgEntry."Document No.",1,2)='KC')) THEN
            currPayments:=currPayments+DetailedCustLedgEntry.Amount;
            END;
            UNTIL DetailedCustLedgEntry.NEXT=0;
          END;
          */

    end;

    trigger OnOpenPage()
    begin
        DateFilter:=Today;
        Rec.SetFilter("Batch Date",'=%1',DateFilter);
    end;

    var
        Customer1: Record Customer;
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
        currPayments: Decimal;
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ProductionBatchLines: Record UnknownRecord99901;
        MealProcPermissions: Record UnknownRecord99905;
}

