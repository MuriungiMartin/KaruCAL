#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1303 "Correct Posted Sales Invoice"
{
    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Cr.Memo Header"=rm;
    TableNo = "Sales Invoice Header";

    trigger OnRun()
    var
        SalesHeader: Record "Sales Header";
    begin
        UnapplyCostApplication("No.");
        CreateCopyDocument(Rec,SalesHeader,SalesHeader."document type"::"Credit Memo",false);

        Codeunit.Run(Codeunit::"Sales-Post",SalesHeader);
        SetTrackInfoForCancellation(Rec);

        Commit;
    end;

    var
        PostedInvoiceIsPaidCorrectErr: label 'You cannot correct this posted sales invoice because it is fully or partially paid.\\To reverse a paid sales invoice, you must manually create a sales credit memo.';
        PostedInvoiceIsPaidCCancelErr: label 'You cannot cancel this posted sales invoice because it is fully or partially paid.\\To reverse a paid sales invoice, you must manually create a sales credit memo.';
        AlreadyCorrectedErr: label 'You cannot correct this posted sales invoice because it has been canceled.';
        AlreadyCancelledErr: label 'You cannot cancel this posted sales invoice because it has already been canceled.';
        CorrCorrectiveDocErr: label 'You cannot correct this posted sales invoice because it represents a correction of a credit memo.';
        CancelCorrectiveDocErr: label 'You cannot cancel this posted sales invoice because it represents a correction of a credit memo.';
        CustomerIsBlockedCorrectErr: label 'You cannot correct this posted sales invoice because customer %1 is blocked.', Comment='%1 = Customer name';
        CustomerIsBlockedCancelErr: label 'You cannot cancel this posted sales invoice because customer %1 is blocked.', Comment='%1 = Customer name';
        ItemIsBlockedCorrectErr: label 'You cannot correct this posted sales invoice because item %1 %2 is blocked.', Comment='%1 = Item No. %2 = Item Description';
        ItemIsBlockedCancelErr: label 'You cannot cancel this posted sales invoice because item %1 %2 is blocked.', Comment='%1 = Item No. %2 = Item Description';
        AccountIsBlockedCorrectErr: label 'You cannot correct this posted sales invoice because %1 %2 is blocked.', Comment='%1 = Table Caption %2 = Account number.';
        AccountIsBlockedCancelErr: label 'You cannot cancel this posted sales invoice because %1 %2 is blocked.', Comment='%1 = Table Caption %2 = Account number.';
        NoFreeInvoiceNoSeriesCorrectErr: label 'You cannot correct this posted sales invoice because no unused invoice numbers are available. \\You must extend the range of the number series for sales invoices.';
        NoFreeInvoiceNoSeriesCancelErr: label 'You cannot cancel this posted sales invoice because no unused invoice numbers are available. \\You must extend the range of the number series for sales invoices.';
        NoFreeCMSeriesCorrectErr: label 'You cannot correct this posted sales invoice because no unused credit memo numbers are available. \\You must extend the range of the number series for credit memos.';
        NoFreeCMSeriesCancelErr: label 'You cannot cancel this posted sales invoice because no unused credit memo numbers are available. \\You must extend the range of the number series for credit memos.';
        NoFreePostCMSeriesCorrectErr: label 'You cannot correct this posted sales invoice because no unused posted credit memo numbers are available. \\You must extend the range of the number series for posted credit memos.';
        NoFreePostCMSeriesCancelErr: label 'You cannot cancel this posted sales invoice because no unused posted credit memo numbers are available. \\You must extend the range of the number series for posted credit memos.';
        SalesLineFromOrderCorrectErr: label 'You cannot correct this posted sales invoice because item %1 %2 is used on a sales order.', Comment='%1 = Item no. %2 = Item description';
        SalesLineFromOrderCancelErr: label 'You cannot cancel this posted sales invoice because item %1 %2 is used on a sales order.', Comment='%1 = Item no. %2 = Item description';
        ShippedQtyReturnedCorrectErr: label 'You cannot correct this posted sales invoice because item %1 %2 has already been fully or partially returned.', Comment='%1 = Item no. %2 = Item description.';
        ShippedQtyReturnedCancelErr: label 'You cannot cancel this posted sales invoice because item %1 %2 has already been fully or partially returned.', Comment='%1 = Item no. %2 = Item description.';
        UsedInJobCorrectErr: label 'You cannot correct this posted sales invoice because item %1 %2 is used in a job.', Comment='%1 = Item no. %2 = Item description.';
        UsedInJobCancelErr: label 'You cannot cancel this posted sales invoice because item %1 %2 is used in a job.', Comment='%1 = Item no. %2 = Item description.';
        PostingNotAllowedCorrectErr: label 'You cannot correct this posted sales invoice because it was posted in a posting period that is closed.';
        PostingNotAllowedCancelErr: label 'You cannot cancel this posted sales invoice because it was posted in a posting period that is closed.';
        LineTypeNotAllowedCorrectErr: label 'You cannot correct this posted sales invoice because the sales invoice line for %1 %2 is of type %3, which is not allowed on a simplified sales invoice.', Comment='%1 = Item no. %2 = Item description %3 = Item type.';
        LineTypeNotAllowedCancelErr: label 'You cannot cancel this posted sales invoice because the sales invoice line for %1 %2 is of type %3, which is not allowed on a simplified sales invoice.', Comment='%1 = Item no. %2 = Item description %3 = Item type.';
        CancellingOnly: Boolean;
        InvalidDimCodeCorrectErr: label 'You cannot correct this posted sales invoice because the dimension rule setup for account ''%1'' %2 prevents %3 %4 from being canceled.', Comment='%1 = Table caption %2 = Account number %3 = Item no. %4 = Item description.';
        InvalidDimCodeCancelErr: label 'You cannot cancel this posted sales invoice because the dimension rule setup for account ''%1'' %2 prevents %3 %4 from being canceled.', Comment='%1 = Table caption %2 = Account number %3 = Item no. %4 = Item description.';
        InvalidDimCombinationCorrectErr: label 'You cannot correct this posted sales invoice because the dimension combination for item %1 %2 is not allowed.', Comment='%1 = Item no. %2 = Item description.';
        InvalidDimCombinationCancelErr: label 'You cannot cancel this posted sales invoice because the dimension combination for item %1 %2 is not allowed.', Comment='%1 = Item no. %2 = Item description.';
        InvalidDimCombHeaderCorrectErr: label 'You cannot correct this posted sales invoice because the combination of dimensions on the invoice is blocked.';
        InvalidDimCombHeaderCancelErr: label 'You cannot cancel this posted sales invoice because the combination of dimensions on the invoice is blocked.';
        ExternalDocCorrectErr: label 'You cannot correct this posted sales invoice because the external document number is required on the invoice.';
        ExternalDocCancelErr: label 'You cannot cancel this posted sales invoice because the external document number is required on the invoice.';
        InventoryPostClosedCorrectErr: label 'You cannot correct this posted sales invoice because the posting inventory period is already closed.';
        InventoryPostClosedCancelErr: label 'You cannot cancel this posted sales invoice because the posting inventory period is already closed.';
        PostingCreditMemoFailedOpenPostedCMQst: label 'Canceling the invoice failed because of the following error: \\%1\\A credit memo is posted. Do you want to open the posted credit memo?';
        PostingCreditMemoFailedOpenCMQst: label 'Canceling the invoice failed because of the following error: \\%1\\A credit memo is created but not posted. Do you want to open the credit memo?';
        CreatingCreditMemoFailedNothingCreatedErr: label 'Canceling the invoice failed because of the following error: \\%1.';
        ErrorType: Option IsPaid,CustomerBlocked,ItemBlocked,AccountBlocked,IsCorrected,IsCorrective,SerieNumInv,SerieNumCM,SerieNumPostCM,ItemIsReturned,FromOrder,PostingNotAllowed,LineFromOrder,WrongItemType,LineFromJob,DimErr,DimCombErr,DimCombHeaderErr,ExtDocErr,InventoryPostClosed;
        WrongDocumentTypeForCopyDocumentErr: label 'You cannot correct or cancel this type of document.';


    procedure CancelPostedInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    begin
        CancellingOnly := true;
        exit(CreateCreditMemo(SalesInvoiceHeader));
    end;

    local procedure CreateCreditMemo(var SalesInvoiceHeader: Record "Sales Invoice Header"): Boolean
    var
        SalesHeader: Record "Sales Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        TestCorrectInvoiceIsAllowed(SalesInvoiceHeader,CancellingOnly);
        if not Codeunit.Run(Codeunit::"Correct Posted Sales Invoice",SalesInvoiceHeader) then begin
          SalesCrMemoHeader.SetRange("Applies-to Doc. No.",SalesInvoiceHeader."No.");
          if SalesCrMemoHeader.FindFirst then begin
            if Confirm(StrSubstNo(PostingCreditMemoFailedOpenPostedCMQst,GetLastErrorText)) then
              Page.Run(Page::"Posted Sales Credit Memo",SalesCrMemoHeader);
          end else begin
            SalesHeader.SetRange("Applies-to Doc. No.",SalesInvoiceHeader."No.");
            if SalesHeader.FindFirst then begin
              if Confirm(StrSubstNo(PostingCreditMemoFailedOpenCMQst,GetLastErrorText)) then
                Page.Run(Page::"Sales Credit Memo",SalesHeader);
            end else
              Error(CreatingCreditMemoFailedNothingCreatedErr,GetLastErrorText);
          end;
          exit(false);
        end;
        exit(true);
    end;

    local procedure CreateCopyDocument(var SalesInvoiceHeader: Record "Sales Invoice Header";var SalesHeader: Record "Sales Header";DocumentType: Option;SkipCopyFromDescription: Boolean)
    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
    begin
        Clear(SalesHeader);
        SalesHeader."No." := '';
        SalesHeader."Document Type" := DocumentType;
        SalesHeader.Insert(true);

        case DocumentType of
          SalesHeader."document type"::"Credit Memo":
            CopyDocMgt.SetPropertiesForCreditMemoCorrection;
          SalesHeader."document type"::Invoice:
            CopyDocMgt.SetPropertiesForInvoiceCorrection(SkipCopyFromDescription);
          else
            Error(WrongDocumentTypeForCopyDocumentErr);
        end;

        CopyDocMgt.CopySalesDocForInvoiceCancelling(SalesInvoiceHeader."No.",SalesHeader);
    end;


    procedure CreateCreditMemoCopyDocument(var SalesInvoiceHeader: Record "Sales Invoice Header";var SalesHeader: Record "Sales Header")
    begin
        CreateCopyDocument(SalesInvoiceHeader,SalesHeader,SalesHeader."document type"::"Credit Memo",false);
    end;


    procedure CancelPostedInvoiceStartNewInvoice(var SalesInvoiceHeader: Record "Sales Invoice Header";var SalesHeader: Record "Sales Header")
    begin
        CancellingOnly := false;

        if CreateCreditMemo(SalesInvoiceHeader) then begin
          CreateCopyDocument(SalesInvoiceHeader,SalesHeader,SalesHeader."document type"::Invoice,true);
          Commit;
        end;
    end;


    procedure TestCorrectInvoiceIsAllowed(var SalesInvoiceHeader: Record "Sales Invoice Header";Cancelling: Boolean)
    begin
        CancellingOnly := Cancelling;

        SalesInvoiceHeader.CalcFields(Amount);
        SalesInvoiceHeader.TestField(Amount);
        TestIfPostingIsAllowed(SalesInvoiceHeader);
        TestIfInvoiceIsCorrectedOnce(SalesInvoiceHeader);
        TestIfInvoiceIsNotCorrectiveDoc(SalesInvoiceHeader);
        TestIfInvoiceIsPaid(SalesInvoiceHeader);
        TestIfCustomerIsBlocked(SalesInvoiceHeader,SalesInvoiceHeader."Sell-to Customer No.");
        TestIfCustomerIsBlocked(SalesInvoiceHeader,SalesInvoiceHeader."Bill-to Customer No.");
        TestCustomerDimension(SalesInvoiceHeader,SalesInvoiceHeader."Bill-to Customer No.");
        TestDimensionOnHeader(SalesInvoiceHeader);
        TestSalesLines(SalesInvoiceHeader);
        TestIfAnyFreeNumberSeries(SalesInvoiceHeader);
        TestExternalDocument(SalesInvoiceHeader);
        TestInventoryPostingClosed(SalesInvoiceHeader);
    end;

    local procedure SetTrackInfoForCancellation(var SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        CancelledDocument: Record "Cancelled Document";
    begin
        SalesCrMemoHeader.SetRange("Applies-to Doc. No.",SalesInvoiceHeader."No.");
        if SalesCrMemoHeader.FindLast then
          CancelledDocument.InsertSalesInvToCrMemoCancelledDocument(SalesInvoiceHeader."No.",SalesCrMemoHeader."No.");
    end;

    local procedure TestDimensionOnHeader(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        if not DimensionManagement.CheckDimIDComb(SalesInvoiceHeader."Dimension Set ID") then
          ErrorHelperHeader(Errortype::DimCombHeaderErr,SalesInvoiceHeader);
    end;

    local procedure TestIfCustomerIsBlocked(SalesInvoiceHeader: Record "Sales Invoice Header";CustNo: Code[20])
    var
        Customer: Record Customer;
    begin
        Customer.Get(CustNo);
        if Customer.Blocked in [Customer.Blocked::Invoice,Customer.Blocked::All] then
          ErrorHelperHeader(Errortype::CustomerBlocked,SalesInvoiceHeader);
    end;

    local procedure TestCustomerDimension(SalesInvoiceHeader: Record "Sales Invoice Header";CustNo: Code[20])
    var
        Customer: Record Customer;
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        Customer.Get(CustNo);
        TableID[1] := Database::Customer;
        No[1] := Customer."No.";
        if not DimensionManagement.CheckDimValuePosting(TableID,No,SalesInvoiceHeader."Dimension Set ID") then
          ErrorHelperAccount(Errortype::DimErr,Customer.TableCaption,Customer."No.",Customer."No.",Customer.Name);
    end;

    local procedure TestSalesLines(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        Item: Record Item;
        DimensionManagement: Codeunit DimensionManagement;
        ShippedQtyNoReturned: Decimal;
        RevUnitCostLCY: Decimal;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        SalesInvoiceLine.SetRange("Document No.",SalesInvoiceHeader."No.");
        if SalesInvoiceLine.Find('-') then
          repeat
            if not IsCommentLine(SalesInvoiceLine) then begin
              if SalesShipmentLine.Get(SalesInvoiceLine."Shipment No.",SalesInvoiceLine."Shipment Line No.") then begin
                if SalesShipmentLine."Order No." <> '' then
                  ErrorHelperLine(Errortype::LineFromOrder,SalesInvoiceLine);
              end;

              TestSalesLineType(SalesInvoiceLine,SalesInvoiceHeader."Customer Posting Group");

              if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
                if (SalesInvoiceLine.Quantity > 0) and (SalesInvoiceLine."Job No." = '') and
                   WasNotCancelled(SalesInvoiceHeader."No.")
                then begin
                  SalesInvoiceLine.CalcShippedSaleNotReturned(ShippedQtyNoReturned,RevUnitCostLCY,false);
                  if SalesInvoiceLine.Quantity <> ShippedQtyNoReturned then
                    ErrorHelperLine(Errortype::ItemIsReturned,SalesInvoiceLine);
                end;

                Item.Get(SalesInvoiceLine."No.");

                if Item.Blocked then
                  ErrorHelperLine(Errortype::ItemBlocked,SalesInvoiceLine);

                TableID[1] := Database::Item;
                No[1] := SalesInvoiceLine."No.";
                if not DimensionManagement.CheckDimValuePosting(TableID,No,SalesInvoiceLine."Dimension Set ID") then
                  ErrorHelperAccount(Errortype::DimErr,Item.TableCaption,No[1],Item."No.",Item.Description);

                if Item.Type = Item.Type::Inventory then
                  TestInventoryPostingSetup(SalesInvoiceLine);
              end;

              TestGenPostingSetup(SalesInvoiceLine);
              TestCustomerPostingGroup(SalesInvoiceLine,SalesInvoiceHeader."Customer Posting Group");
              TestVATPostingSetup(SalesInvoiceLine);

              if not DimensionManagement.CheckDimIDComb(SalesInvoiceLine."Dimension Set ID") then
                ErrorHelperLine(Errortype::DimCombErr,SalesInvoiceLine);
            end;
          until SalesInvoiceLine.Next = 0;
    end;

    local procedure TestGLAccount(AccountNo: Code[20];SalesInvoiceLine: Record "Sales Invoice Line")
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        GLAccount.Get(AccountNo);
        if GLAccount.Blocked then
          ErrorHelperAccount(Errortype::AccountBlocked,GLAccount.TableCaption,AccountNo,'','');
        TableID[1] := Database::"G/L Account";
        No[1] := AccountNo;

        if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
          Item.Get(SalesInvoiceLine."No.");
          if not DimensionManagement.CheckDimValuePosting(TableID,No,SalesInvoiceLine."Dimension Set ID") then
            ErrorHelperAccount(Errortype::DimErr,GLAccount.TableCaption,AccountNo,Item."No.",Item.Description);
        end;
    end;

    local procedure TestIfInvoiceIsPaid(SalesInvoiceHeader: Record "Sales Invoice Header")
    begin
        SalesInvoiceHeader.CalcFields("Amount Including VAT");
        SalesInvoiceHeader.CalcFields("Remaining Amount");
        if SalesInvoiceHeader."Amount Including VAT" <> SalesInvoiceHeader."Remaining Amount" then
          ErrorHelperHeader(Errortype::IsPaid,SalesInvoiceHeader);
    end;

    local procedure TestIfInvoiceIsCorrectedOnce(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CancelledDocument: Record "Cancelled Document";
    begin
        if CancelledDocument.FindSalesCancelledInvoice(SalesInvoiceHeader."No.") then
          ErrorHelperHeader(Errortype::IsCorrected,SalesInvoiceHeader);
    end;

    local procedure TestIfInvoiceIsNotCorrectiveDoc(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        CancelledDocument: Record "Cancelled Document";
    begin
        if CancelledDocument.FindSalesCorrectiveInvoice(SalesInvoiceHeader."No.") then
          ErrorHelperHeader(Errortype::IsCorrective,SalesInvoiceHeader);
    end;

    local procedure TestIfPostingIsAllowed(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        if GenJnlCheckLine.DateNotAllowed(SalesInvoiceHeader."Posting Date") then
          ErrorHelperHeader(Errortype::PostingNotAllowed,SalesInvoiceHeader);
    end;

    local procedure TestIfAnyFreeNumberSeries(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PostingDate: Date;
    begin
        PostingDate := WorkDate;
        SalesReceivablesSetup.Get;

        if NoSeriesManagement.TryGetNextNo(SalesReceivablesSetup."Credit Memo Nos.",PostingDate) = '' then
          ErrorHelperHeader(Errortype::SerieNumCM,SalesInvoiceHeader);

        if NoSeriesManagement.TryGetNextNo(SalesReceivablesSetup."Posted Credit Memo Nos.",PostingDate) = '' then
          ErrorHelperHeader(Errortype::SerieNumPostCM,SalesInvoiceHeader);

        if (not CancellingOnly) and (NoSeriesManagement.TryGetNextNo(SalesReceivablesSetup."Invoice Nos.",PostingDate) = '') then
          ErrorHelperHeader(Errortype::SerieNumInv,SalesInvoiceHeader);
    end;

    local procedure TestExternalDocument(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.Get;
        if (SalesInvoiceHeader."External Document No." = '') and SalesReceivablesSetup."Ext. Doc. No. Mandatory" then
          ErrorHelperHeader(Errortype::ExtDocErr,SalesInvoiceHeader);
    end;

    local procedure TestInventoryPostingClosed(SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        InventoryPeriod: Record "Inventory Period";
    begin
        InventoryPeriod.SetRange(Closed,true);
        InventoryPeriod.SetFilter("Ending Date",'>=%1',SalesInvoiceHeader."Posting Date");
        if InventoryPeriod.FindFirst then
          ErrorHelperHeader(Errortype::InventoryPostClosed,SalesInvoiceHeader);
    end;

    local procedure TestSalesLineType(SalesInvoiceLine: Record "Sales Invoice Line";CustPostingGroupCode: Code[10])
    begin
        if SalesInvoiceLine."Job No." = '' then begin
          if SalesInvoiceLine.Type in [SalesInvoiceLine.Type::" ",SalesInvoiceLine.Type::Item] then
            exit;
          if IsInvRndAccount(CustPostingGroupCode,SalesInvoiceLine) then
            exit;
        end else begin
          if SalesInvoiceLine.Type in [SalesInvoiceLine.Type::" ",
                                       SalesInvoiceLine.Type::Item,
                                       SalesInvoiceLine.Type::"G/L Account",
                                       SalesInvoiceLine.Type::Resource]
          then
            exit;
        end;

        ErrorHelperLine(Errortype::WrongItemType,SalesInvoiceLine)
    end;

    local procedure TestGenPostingSetup(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        GenPostingSetup: Record "General Posting Setup";
    begin
        with GenPostingSetup do begin
          Get(SalesInvoiceLine."Gen. Bus. Posting Group",SalesInvoiceLine."Gen. Prod. Posting Group");
          TestField("Sales Account");
          TestGLAccount("Sales Account",SalesInvoiceLine);
          TestField("Sales Credit Memo Account");
          TestGLAccount("Sales Credit Memo Account",SalesInvoiceLine);
          TestField("Sales Line Disc. Account");
          TestGLAccount("Sales Line Disc. Account",SalesInvoiceLine);
          if SalesInvoiceLine.Type = SalesInvoiceLine.Type::Item then begin
            TestField("COGS Account");
            TestGLAccount("COGS Account",SalesInvoiceLine);
          end;
        end;
    end;

    local procedure TestCustomerPostingGroup(SalesInvoiceLine: Record "Sales Invoice Line";CustomerPostingGr: Code[10])
    var
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        with CustomerPostingGroup do begin
          Get(CustomerPostingGr);
          TestField("Receivables Account");
          TestGLAccount("Receivables Account",SalesInvoiceLine);
        end;
    end;

    local procedure TestVATPostingSetup(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        with VATPostingSetup do begin
          Get(SalesInvoiceLine."VAT Bus. Posting Group",SalesInvoiceLine."VAT Prod. Posting Group");
          if "VAT Calculation Type" <> "vat calculation type"::"Sales Tax" then begin
            TestField("Sales VAT Account");
            TestGLAccount("Sales VAT Account",SalesInvoiceLine);
          end;
        end;
    end;

    local procedure TestInventoryPostingSetup(SalesInvoiceLine: Record "Sales Invoice Line")
    var
        InventoryPostingSetup: Record "Inventory Posting Setup";
    begin
        with InventoryPostingSetup do begin
          Get(SalesInvoiceLine."Location Code",SalesInvoiceLine."Posting Group");
          TestField("Inventory Account");
          TestGLAccount("Inventory Account",SalesInvoiceLine);
        end;
    end;

    local procedure IsCommentLine(SalesInvoiceLine: Record "Sales Invoice Line"): Boolean
    begin
        exit((SalesInvoiceLine.Type = SalesInvoiceLine.Type::" ") or (SalesInvoiceLine."No." = ''));
    end;

    local procedure WasNotCancelled(InvNo: Code[20]): Boolean
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        SalesCrMemoHeader.SetRange("Applies-to Doc. Type",SalesCrMemoHeader."applies-to doc. type"::Invoice);
        SalesCrMemoHeader.SetRange("Applies-to Doc. No.",InvNo);
        exit(SalesCrMemoHeader.IsEmpty);
    end;

    local procedure IsInvRndAccount(CustPostingGroupCode: Code[10];SalesInvLine: Record "Sales Invoice Line"): Boolean
    var
        CustPostingGroup: Record "Customer Posting Group";
    begin
        if SalesInvLine.Type <> SalesInvLine.Type::"G/L Account" then
          exit(false);

        CustPostingGroup.Get(CustPostingGroupCode);
        exit((CustPostingGroup."Invoice Rounding Account" = SalesInvLine."No.") and SalesInvLine."System-Created Entry");
    end;

    local procedure UnapplyCostApplication(InvNo: Code[20])
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        TempItemApplicationEntry: Record "Item Application Entry" temporary;
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
        FindItemLedgEntries(TempItemLedgEntry,InvNo);
        if FindAppliedInbndEntries(TempItemApplicationEntry,TempItemLedgEntry) then begin
          repeat
            ItemJnlPostLine.UnApply(TempItemApplicationEntry);
          until TempItemApplicationEntry.Next = 0;
          ItemJnlPostLine.RedoApplications;
        end;
    end;

    local procedure FindItemLedgEntries(var ItemLedgEntry: Record "Item Ledger Entry";InvNo: Code[20])
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        with SalesInvLine do begin
          SetRange("Document No.",InvNo);
          SetRange(Type,Type::Item);
          if FindSet then
            repeat
              GetItemLedgEntries(ItemLedgEntry,false);
            until Next = 0;
        end;
    end;

    local procedure FindAppliedInbndEntries(var TempItemApplicationEntry: Record "Item Application Entry" temporary;var ItemLedgEntry: Record "Item Ledger Entry"): Boolean
    var
        ItemApplicationEntry: Record "Item Application Entry";
    begin
        TempItemApplicationEntry.Reset;
        TempItemApplicationEntry.DeleteAll;
        if ItemLedgEntry.FindSet then
          repeat
            if ItemApplicationEntry.AppliedInbndEntryExists(ItemLedgEntry."Entry No.",true) then
              repeat
                TempItemApplicationEntry := ItemApplicationEntry;
                if not TempItemApplicationEntry.Find then
                  TempItemApplicationEntry.Insert;
              until ItemApplicationEntry.Next = 0;
          until ItemLedgEntry.Next = 0;
        exit(TempItemApplicationEntry.FindSet);
    end;

    local procedure ErrorHelperHeader(ErrorOption: Option;SalesInvoiceHeader: Record "Sales Invoice Header")
    var
        Customer: Record Customer;
    begin
        if CancellingOnly then
          case ErrorOption of
            Errortype::IsPaid:
              Error(PostedInvoiceIsPaidCCancelErr);
            Errortype::CustomerBlocked:
              begin
                Customer.Get(SalesInvoiceHeader."Bill-to Customer No.");
                Error(CustomerIsBlockedCancelErr,Customer.Name);
              end;
            Errortype::IsCorrected:
              Error(AlreadyCancelledErr);
            Errortype::IsCorrective:
              Error(CancelCorrectiveDocErr);
            Errortype::SerieNumInv:
              Error(NoFreeInvoiceNoSeriesCancelErr);
            Errortype::SerieNumCM:
              Error(NoFreeCMSeriesCancelErr);
            Errortype::SerieNumPostCM:
              Error(NoFreePostCMSeriesCancelErr);
            Errortype::PostingNotAllowed:
              Error(PostingNotAllowedCancelErr);
            Errortype::ExtDocErr:
              Error(ExternalDocCancelErr);
            Errortype::InventoryPostClosed:
              Error(InventoryPostClosedCancelErr);
            Errortype::DimCombHeaderErr:
              Error(InvalidDimCombHeaderCancelErr);
          end
        else
          case ErrorOption of
            Errortype::IsPaid:
              Error(PostedInvoiceIsPaidCorrectErr);
            Errortype::CustomerBlocked:
              begin
                Customer.Get(SalesInvoiceHeader."Bill-to Customer No.");
                Error(CustomerIsBlockedCorrectErr,Customer.Name);
              end;
            Errortype::IsCorrected:
              Error(AlreadyCorrectedErr);
            Errortype::IsCorrective:
              Error(CorrCorrectiveDocErr);
            Errortype::SerieNumInv:
              Error(NoFreeInvoiceNoSeriesCorrectErr);
            Errortype::SerieNumPostCM:
              Error(NoFreePostCMSeriesCorrectErr);
            Errortype::SerieNumCM:
              Error(NoFreeCMSeriesCorrectErr);
            Errortype::PostingNotAllowed:
              Error(PostingNotAllowedCorrectErr);
            Errortype::ExtDocErr:
              Error(ExternalDocCorrectErr);
            Errortype::InventoryPostClosed:
              Error(InventoryPostClosedCorrectErr);
            Errortype::DimCombHeaderErr:
              Error(InvalidDimCombHeaderCorrectErr);
          end;
    end;

    local procedure ErrorHelperLine(ErrorOption: Option;SalesInvoiceLine: Record "Sales Invoice Line")
    var
        Item: Record Item;
    begin
        if CancellingOnly then
          case ErrorOption of
            Errortype::ItemBlocked:
              begin
                Item.Get(SalesInvoiceLine."No.");
                Error(ItemIsBlockedCancelErr,Item."No.",Item.Description);
              end;
            Errortype::ItemIsReturned:
              begin
                Item.Get(SalesInvoiceLine."No.");
                Error(ShippedQtyReturnedCancelErr,Item."No.",Item.Description);
              end;
            Errortype::LineFromOrder:
              Error(SalesLineFromOrderCancelErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description);
            Errortype::WrongItemType:
              Error(LineTypeNotAllowedCancelErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description,SalesInvoiceLine.Type);
            Errortype::LineFromJob:
              Error(UsedInJobCancelErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description);
            Errortype::DimCombErr:
              Error(InvalidDimCombinationCancelErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description);
          end
        else
          case ErrorOption of
            Errortype::ItemBlocked:
              begin
                Item.Get(SalesInvoiceLine."No.");
                Error(ItemIsBlockedCorrectErr,Item."No.",Item.Description);
              end;
            Errortype::ItemIsReturned:
              begin
                Item.Get(SalesInvoiceLine."No.");
                Error(ShippedQtyReturnedCorrectErr,Item."No.",Item.Description);
              end;
            Errortype::LineFromOrder:
              Error(SalesLineFromOrderCorrectErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description);
            Errortype::WrongItemType:
              Error(LineTypeNotAllowedCorrectErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description,SalesInvoiceLine.Type);
            Errortype::LineFromJob:
              Error(UsedInJobCorrectErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description);
            Errortype::DimCombErr:
              Error(InvalidDimCombinationCorrectErr,SalesInvoiceLine."No.",SalesInvoiceLine.Description);
          end;
    end;

    local procedure ErrorHelperAccount(ErrorOption: Option;AccountNo: Code[20];AccountCaption: Text;No: Code[20];Name: Text)
    begin
        if CancellingOnly then
          case ErrorOption of
            Errortype::AccountBlocked:
              Error(AccountIsBlockedCancelErr,AccountCaption,AccountNo);
            Errortype::DimErr:
              Error(InvalidDimCodeCancelErr,AccountCaption,AccountNo,No,Name);
          end
        else
          case ErrorOption of
            Errortype::AccountBlocked:
              Error(AccountIsBlockedCorrectErr,AccountCaption,AccountNo);
            Errortype::DimErr:
              Error(InvalidDimCodeCorrectErr,AccountCaption,AccountNo,No,Name);
          end;
    end;
}

