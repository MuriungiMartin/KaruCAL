#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99910 "Posted Meal-Proc. Batches"
{
    ApplicationArea = Basic;
    CardPageID = "Meal-Proc. Batch Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable99900;
    SourceTableView = sorting("Batch Date","Production  Area")
                      order(descending)
                      where(Status=filter(Final|Posted));
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
            action(MarkAsFinal)
            {
                ApplicationArea = Basic;
                Caption = 'Mark as Final';
                Image = AvailableToPromise;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProductionBatches.Reset;
                    ProductionBatches.SetRange(ProductionBatches."Batch Date","Batch Date");
                    if ProductionBatches.Find('-') then begin
                     if ProductionBatches.Status<>ProductionBatches.Status::Draft then Error('Already Closed!');
                      end;


                    if Confirm('CONFIRM:\Mark as Final?',false)=false then exit;
                    ProductionBatches.Reset;
                    ProductionBatches.SetRange(ProductionBatches."Batch Date","Batch Date");
                    if ProductionBatches.Find('-') then begin
                      ProductionBatches.Status:=ProductionBatches.Status::Final;
                      ProductionBatches.Modify;
                      end;
                      Message('The batch has been closed!');
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


    procedure CreateTransferOrder()
    var
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
        ItmJnl: Record UnknownRecord99901;
        ItemRec: Record Item;
        TransferNo: Code[20];
    begin
        /*
        //IF "Transfer Order Created" THEN
         //ERROR('Transfer order has been created for this document');
        WITH TransferHeader DO BEGIN
         INIT;
         ItmJnl.RESET;
         ItmJnl.SETRANGE("Batch Date",Rec."Batch Serial);
         IF ItmJnl.FINDFIRST THEN
         TransferNo:=NoSeriesManagement.GetNextNo('MI-11',"Posting Date",TRUE);
         //TransferNo:=
         TransferHeader."No.":=TransferNo;
         "Transfer-from Code":= ItmJnl."Location Code";
         VALIDATE("Transfer-from Code");
         "Transfer-to Code":= 'COLD ROOM 2';
         VALIDATE("Transfer-to Code");
         "In-Transit Code":='IN-TRANS';
         "Posting Date":=ItmJnl."Posting Date";
        "Shipment Date":=ItmJnl."Posting Date";
        "Receipt Date":=ItmJnl."Posting Date";
        //"Output Voucher No.":="Document No.";
        //"Transfer Type":="Transfer Type"::"Output Transfer";
         TransferHeader."Assigned User ID":=USERID;
         //TransferHeader."External Document No.":=Rec."Order No.";
          VALIDATE("Transfer-from Code");
          VALIDATE("Transfer-to Code");
         IF INSERT THEN BEGIN
         //Rec."Transfer Order No.":=TransferHeader."No.";
         //Rec."Transfer Order Created":=TRUE;
         MODIFY;
        END;
         END;
         {"Transfer Order No.":=TransferHeader."No.";
         "Transfer Order Created":=TRUE;
         MODIFY;
        }
        TransferHeader.RESET;
        TransferHeader.SETRANGE(TransferHeader."No.","Batch Serial");
        TransferHeader.SETRANGE("Posting Date","Batch Date");
        //TransferHeader.SETRANGE(TransferHeader."External Document No.","Order No.");
        IF TransferHeader.FINDFIRST THEN BEGIN
        ItmJnl.RESET;
        ItmJnl.SETRANGE(ItmJnl."Document No.",Rec."Batch Serial");
        ItmJnl.SETFILTER(ItmJnl."Output Quantity",'>%1',0);
        IF ItmJnl.FINDSET THEN BEGIN
         REPEAT
         LineNo+=10000;
         WITH TransferLine DO BEGIN
          INIT;
           "Line No.":=LineNo;
           TransferLine."Document No.":=TransferHeader."No.";
            IF ItemRec.GET(ItmJnl."Item No.") THEN BEGIN
            TransferLine."Item Category Code":=ItemRec."Item Category Code";
            TransferLine."Product Group Code":=ItemRec."Product Group Code";
            END;
            TransferLine."Item No.":=ItmJnl."Item No.";
            TransferLine.VALIDATE("Item No.");
            TransferLine.Quantity:=ItmJnl."Output Quantity";
            TransferLine."Transfer-from Code":=TransferHeader."Transfer-from Code";
            TransferLine."Transfer-to Code":=TransferHeader."Transfer-to Code";
            TransferLine."Shortcut Dimension 1 Code":=ItmJnl."Shortcut Dimension 1 Code";
            TransferLine."Shipment Date":=TransferHeader."Posting Date";
            TransferLine."Receipt Date":=TransferHeader."Posting Date";
            TransferLine.VALIDATE("Shortcut Dimension 1 Code");
            TransferLine."Shortcut Dimension 2 Code":=ItmJnl."Shortcut Dimension 2 Code";
            TransferLine.VALIDATE("Shortcut Dimension 2 Code");
            TransferLine."Gen. Prod. Posting Group":=ItmJnl."Gen. Prod. Posting Group";
            TransferLine.VALIDATE(Quantity);
             TransferLine.VALIDATE("Transfer-from Code");
             TransferLine.VALIDATE("Transfer-to Code");
             TransferLine."Unit of Measure Code":=ItmJnl."Unit of Measure Code";
          TransferLine."Document No." :=TransferHeader."No.";
          TransferLine."Unit of Measure":=ItmJnl."Unit of Measure Code";
          TransferLine.VALIDATE("Unit of Measure Code");
           INSERT(TRUE);
          END;
          UNTIL ItmJnl.NEXT = 0;
         END;
         //"Transfer Order No.":=TransferHeader."No.";
         //"Transfer Order Created":=TRUE;
         MODIFY;
        
        END;
         //"Transfer Order No.":=TransferHeader."No.";
         //"Transfer Order Created":=TRUE;
        
          PAGE.RUN(PAGE::"Transfer Order",TransferHeader);
          */

    end;
}

