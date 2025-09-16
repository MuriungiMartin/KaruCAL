#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1313 "Correct Posted Purch. Invoice"
{
    Permissions = TableData "Purch. Inv. Header"=rm,
                  TableData "Purch. Cr. Memo Hdr."=rm;
    TableNo = "Purch. Inv. Header";

    trigger OnRun()
    var
        PurchaseHeader: Record "Purchase Header";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        RedoApplications: Boolean;
    begin
        RedoApplications := UnapplyCostApplication(ItemJnlPostLine,"No.");

        Clear(PurchaseHeader);
        PurchaseHeader."No." := '';
        PurchaseHeader."Document Type" := PurchaseHeader."document type"::"Credit Memo";
        PurchaseHeader.Insert(true);
        CopyDocMgt.SetPropertiesForCreditMemoCorrection;
        CopyDocMgt.CopyPurchaseDocForInvoiceCancelling("No.",PurchaseHeader);
        PurchaseHeader."Vendor Cr. Memo No." := PurchaseHeader."No.";

        Codeunit.Run(Codeunit::"Purch.-Post",PurchaseHeader);
        SetTrackInfoForCancellation(Rec);
        if RedoApplications then
          ItemJnlPostLine.RedoApplications;
        Commit;
    end;

    var
        PostedInvoiceIsPaidCorrectErr: label 'You cannot correct this posted purchase invoice because it is fully or partially paid.\\To reverse a paid purchase invoice, you must manually create a purchase credit memo.';
        PostedInvoiceIsPaidCCancelErr: label 'You cannot cancel this posted purchase invoice because it is fully or partially paid.\\To reverse a paid purchase invoice, you must manually create a purchase credit memo.';
        AlreadyCorrectedErr: label 'You cannot correct this posted purchase invoice because it has been canceled.';
        AlreadyCancelledErr: label 'You cannot cancel this posted purchase invoice because it has already been canceled.';
        CorrCorrectiveDocErr: label 'You cannot correct this posted purchase invoice because it represents a correction of a credit memo.';
        CancelCorrectiveDocErr: label 'You cannot cancel this posted purchase invoice because it represents a correction of a credit memo.';
        VendorIsBlockedCorrectErr: label 'You cannot correct this posted purchase invoice because vendor %1 is blocked.', Comment='%1 = Customer name';
        VendorIsBlockedCancelErr: label 'You cannot cancel this posted purchase invoice because vendor %1 is blocked.', Comment='%1 = Customer name';
        ItemIsBlockedCorrectErr: label 'You cannot correct this posted purchase invoice because item %1 %2 is blocked.', Comment='%1 = Item No. %2 = Item Description';
        ItemIsBlockedCancelErr: label 'You cannot cancel this posted purchase invoice because item %1 %2 is blocked.', Comment='%1 = Item No. %2 = Item Description';
        AccountIsBlockedCorrectErr: label 'You cannot correct this posted purchase invoice because %1 %2 is blocked.', Comment='%1 = Table Caption %2 = Account number.';
        AccountIsBlockedCancelErr: label 'You cannot cancel this posted purchase invoice because %1 %2 is blocked.', Comment='%1 = Table Caption %2 = Account number.';
        NoFreeInvoiceNoSeriesCorrectErr: label 'You cannot correct this posted purchase invoice because no unused invoice numbers are available. \\You must extend the range of the number series for purchase invoices.';
        NoFreeInvoiceNoSeriesCancelErr: label 'You cannot cancel this posted purchase invoice because no unused invoice numbers are available. \\You must extend the range of the number series for purchase invoices.';
        NoFreeCMSeriesCorrectErr: label 'You cannot correct this posted purchase invoice because no unused credit memo numbers are available. \\You must extend the range of the number series for credit memos.';
        NoFreeCMSeriesCancelErr: label 'You cannot cancel this posted purchase invoice because no unused credit memo numbers are available. \\You must extend the range of the number series for credit memos.';
        NoFreePostCMSeriesCorrectErr: label 'You cannot correct this posted purchase invoice because no unused posted credit memo numbers are available. \\You must extend the range of the number series for posted credit memos.';
        NoFreePostCMSeriesCancelErr: label 'You cannot cancel this posted purchase invoice because no unused posted credit memo numbers are available. \\You must extend the range of the number series for posted credit memos.';
        PurchaseLineFromOrderCorrectErr: label 'You cannot correct this posted purchase invoice because item %1 %2 is used on a purchase order.', Comment='%1 = Item no. %2 = Item description';
        PurchaseLineFromOrderCancelErr: label 'You cannot cancel this posted purchase invoice because item %1 %2 is used on a purchase order.', Comment='%1 = Item no. %2 = Item description';
        ShippedQtyReturnedCorrectErr: label 'You cannot correct this posted purchase invoice because item %1 %2 has already been fully or partially returned.', Comment='%1 = Item no. %2 = Item description.';
        ShippedQtyReturnedCancelErr: label 'You cannot cancel this posted purchase invoice because item %1 %2 has already been fully or partially returned.', Comment='%1 = Item no. %2 = Item description.';
        UsedInJobCorrectErr: label 'You cannot correct this posted purchase invoice because item %1 %2 is used in a job.', Comment='%1 = Item no. %2 = Item description.';
        UsedInJobCancelErr: label 'You cannot cancel this posted purchase invoice because item %1 %2 is used in a job.', Comment='%1 = Item no. %2 = Item description.';
        PostingNotAllowedCorrectErr: label 'You cannot correct this posted purchase invoice because it was posted in a posting period that is closed.';
        PostingNotAllowedCancelErr: label 'You cannot cancel this posted purchase invoice because it was posted in a posting period that is closed.';
        InvoiceIsBasedOnOrderCorrectErr: label 'You cannot correct this posted purchase invoice because the invoice is based on a purchase order.';
        InvoiceIsBasedOnOrderCancelErr: label 'You cannot cancel this posted purchase invoice because the invoice is based on a purchase order.';
        LineTypeNotAllowedCorrectErr: label 'You cannot correct this posted purchase invoice because the purchase invoice line for %1 %2 is of type %3, which is not allowed on a simplified purchase invoice.', Comment='%1 = Item no. %2 = Item description %3 = Item type.';
        LineTypeNotAllowedCancelErr: label 'You cannot cancel this posted purchase invoice because the purchase invoice line for %1 %2 is of type %3, which is not allowed on a simplified purchase invoice.', Comment='%1 = Item no. %2 = Item description %3 = Item type.';
        CancellingOnly: Boolean;
        InvalidDimCodeCorrectErr: label 'You cannot correct this posted purchase invoice because the dimension rule setup for account ''%1'' %2 prevents %3 %4 from being canceled.', Comment='%1 = Table caption %2 = Account number %3 = Item no. %4 = Item description.';
        InvalidDimCodeCancelErr: label 'You cannot cancel this posted purchase invoice because the dimension rule setup for account ''%1'' %2 prevents %3 %4 from being canceled.', Comment='%1 = Table caption %2 = Account number %3 = Item no. %4 = Item description.';
        InvalidDimCombinationCorrectErr: label 'You cannot correct this posted purchase invoice because the dimension combination for item %1 %2 is not allowed.', Comment='%1 = Item no. %2 = Item description.';
        InvalidDimCombinationCancelErr: label 'You cannot cancel this posted purchase invoice because the dimension combination for item %1 %2 is not allowed.', Comment='%1 = Item no. %2 = Item description.';
        InvalidDimCombHeaderCorrectErr: label 'You cannot correct this posted purchase invoice because the combination of dimensions on the invoice is blocked.';
        InvalidDimCombHeaderCancelErr: label 'You cannot cancel this posted purchase invoice because the combination of dimensions on the invoice is blocked.';
        ExternalDocCorrectErr: label 'You cannot correct this posted purchase invoice because the external document number is required on the invoice.';
        ExternalDocCancelErr: label 'You cannot cancel this posted purchase invoice because the external document number is required on the invoice.';
        InventoryPostClosedCorrectErr: label 'You cannot correct this posted purchase invoice because the posting inventory period is already closed.';
        InventoryPostClosedCancelErr: label 'You cannot cancel this posted purchase invoice because the posting inventory period is already closed.';
        PostingCreditMemoFailedOpenPostedCMQst: label 'Canceling the invoice failed because of the following error: \\%1\\A credit memo is posted. Do you want to open the posted credit memo?';
        PostingCreditMemoFailedOpenCMQst: label 'Canceling the invoice failed because of the following error: \\%1\\A credit memo is created but not posted. Do you want to open the credit memo?';
        CreatingCreditMemoFailedNothingCreatedErr: label 'Canceling the invoice failed because of the following error: \\%1.';
        ErrorType: Option IsPaid,VendorBlocked,ItemBlocked,AccountBlocked,IsCorrected,IsCorrective,SerieNumInv,SerieNumCM,SerieNumPostCM,ItemIsReturned,FromOrder,PostingNotAllowed,LineFromOrder,WrongItemType,LineFromJob,DimErr,DimCombErr,DimCombHeaderErr,ExtDocErr,InventoryPostClosed;
        WrongDocumentTypeForCopyDocumentErr: label 'You cannot correct or cancel this type of document.';


    procedure CancelPostedInvoice(var PurchInvHeader: Record "Purch. Inv. Header"): Boolean
    begin
        CancellingOnly := true;
        exit(CreateCreditMemo(PurchInvHeader));
    end;

    local procedure CreateCreditMemo(var PurchInvHeader: Record "Purch. Inv. Header"): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        TestCorrectInvoiceIsAllowed(PurchInvHeader,CancellingOnly);
        if not Codeunit.Run(Codeunit::"Correct Posted Purch. Invoice",PurchInvHeader) then begin
          PurchCrMemoHdr.SetRange("Applies-to Doc. No.",PurchInvHeader."No.");
          if PurchCrMemoHdr.FindFirst then begin
            if Confirm(StrSubstNo(PostingCreditMemoFailedOpenPostedCMQst,GetLastErrorText)) then
              Page.Run(Page::"Posted Purchase Credit Memo",PurchCrMemoHdr);
          end else begin
            PurchaseHeader.SetRange("Applies-to Doc. No.",PurchInvHeader."No.");
            if PurchaseHeader.FindFirst then begin
              if Confirm(StrSubstNo(PostingCreditMemoFailedOpenCMQst,GetLastErrorText)) then
                Page.Run(Page::"Purchase Credit Memo",PurchaseHeader);
            end else
              Error(CreatingCreditMemoFailedNothingCreatedErr,GetLastErrorText);
          end;
          exit(false);
        end;
        exit(true);
    end;

    local procedure CreateCopyDocument(var PurchInvHeader: Record "Purch. Inv. Header";var PurchaseHeader: Record "Purchase Header";DocumentType: Option;SkipCopyFromDescription: Boolean)
    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
    begin
        Clear(PurchaseHeader);
        PurchaseHeader."Document Type" := DocumentType;
        PurchaseHeader."No." := '';
        PurchaseHeader.Insert(true);

        case DocumentType of
          PurchaseHeader."document type"::"Credit Memo":
            CopyDocMgt.SetPropertiesForCreditMemoCorrection;
          PurchaseHeader."document type"::Invoice:
            CopyDocMgt.SetPropertiesForInvoiceCorrection(SkipCopyFromDescription);
          else
            Error(WrongDocumentTypeForCopyDocumentErr);
        end;

        CopyDocMgt.CopyPurchaseDocForInvoiceCancelling(PurchInvHeader."No.",PurchaseHeader);
    end;


    procedure CreateCreditMemoCopyDocument(var PurchInvHeader: Record "Purch. Inv. Header";var PurchaseHeader: Record "Purchase Header")
    begin
        CreateCopyDocument(PurchInvHeader,PurchaseHeader,PurchaseHeader."document type"::"Credit Memo",false);
    end;


    procedure CancelPostedInvoiceStartNewInvoice(var PurchInvHeader: Record "Purch. Inv. Header";var PurchaseHeader: Record "Purchase Header")
    begin
        CancellingOnly := false;

        if CreateCreditMemo(PurchInvHeader) then begin
          CreateCopyDocument(PurchInvHeader,PurchaseHeader,PurchaseHeader."document type"::Invoice,true);
          Commit;
        end;
    end;


    procedure TestCorrectInvoiceIsAllowed(var PurchInvHeader: Record "Purch. Inv. Header";Cancelling: Boolean)
    begin
        CancellingOnly := Cancelling;

        PurchInvHeader.CalcFields(Amount);
        PurchInvHeader.TestField(Amount);
        TestIfPostingIsAllowed(PurchInvHeader);
        TestIfInvoiceIsCorrectedOnce(PurchInvHeader);
        TestIfInvoiceIsNotCorrectiveDoc(PurchInvHeader);
        TestIfInvoiceIsPaid(PurchInvHeader);
        TestIfVendorIsBlocked(PurchInvHeader,PurchInvHeader."Buy-from Vendor No.");
        TestIfVendorIsBlocked(PurchInvHeader,PurchInvHeader."Pay-to Vendor No.");
        TestVendorDimension(PurchInvHeader,PurchInvHeader."Pay-to Vendor No.");
        TestDimensionOnHeader(PurchInvHeader);
        TestPurchaseLines(PurchInvHeader);
        TestIfAnyFreeNumberSeries(PurchInvHeader);
        TestIfInvoiceIsBasedOnOrder(PurchInvHeader);
        TestExternalDocument(PurchInvHeader);
        TestInventoryPostingClosed(PurchInvHeader);
    end;

    local procedure SetTrackInfoForCancellation(var PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        CancelledDocument: Record "Cancelled Document";
    begin
        PurchCrMemoHdr.SetRange("Applies-to Doc. No.",PurchInvHeader."No.");
        if PurchCrMemoHdr.FindLast then
          CancelledDocument.InsertPurchInvToCrMemoCancelledDocument(PurchInvHeader."No.",PurchCrMemoHdr."No.");
    end;

    local procedure TestDimensionOnHeader(PurchInvHeader: Record "Purch. Inv. Header")
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        if not DimensionManagement.CheckDimIDComb(PurchInvHeader."Dimension Set ID") then
          ErrorHelperHeader(Errortype::DimCombHeaderErr,PurchInvHeader);
    end;

    local procedure TestIfVendorIsBlocked(PurchInvHeader: Record "Purch. Inv. Header";VendNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(VendNo);
        if Vendor.Blocked in [Vendor.Blocked::All] then
          ErrorHelperHeader(Errortype::VendorBlocked,PurchInvHeader);
    end;

    local procedure TestVendorDimension(PurchInvHeader: Record "Purch. Inv. Header";VendNo: Code[20])
    var
        Vendor: Record Vendor;
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        Vendor.Get(VendNo);
        TableID[1] := Database::Vendor;
        No[1] := Vendor."No.";
        if not DimensionManagement.CheckDimValuePosting(TableID,No,PurchInvHeader."Dimension Set ID") then
          ErrorHelperAccount(Errortype::DimErr,Vendor.TableCaption,Vendor."No.",Vendor."No.",Vendor.Name);
    end;

    local procedure TestPurchaseLines(PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
        PurchInvLine: Record "Purch. Inv. Line";
        Item: Record Item;
        DimensionManagement: Codeunit DimensionManagement;
        ReceivedQtyNoReturned: Decimal;
        RevUnitCostLCY: Decimal;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        PurchInvLine.SetRange("Document No.",PurchInvHeader."No.");
        if PurchInvLine.Find('-') then
          repeat
            if not IsCommentLine(PurchInvLine) then begin
              if PurchRcptLine.Get(PurchInvLine."Receipt No.",PurchInvLine."Receipt Line No.") then begin
                if PurchRcptLine."Order No." <> '' then
                  ErrorHelperLine(Errortype::LineFromOrder,PurchInvLine);
              end;

              if (not (PurchInvLine.Type in [PurchInvLine.Type::" ",PurchInvLine.Type::Item])) and
                 NotInvRndAccount(PurchInvHeader."Vendor Posting Group",PurchInvLine)
              then
                ErrorHelperLine(Errortype::WrongItemType,PurchInvLine);

              if PurchInvLine.Type = PurchInvLine.Type::Item then begin
                Item.Get(PurchInvLine."No.");

                if Item.Type <> Item.Type::Service then
                  if (PurchInvLine.Quantity > 0) and (PurchInvLine."Job No." = '') and WasNotCancelled(PurchInvHeader."No.") then begin
                    PurchInvLine.CalcReceivedPurchNotReturned(ReceivedQtyNoReturned,RevUnitCostLCY,false);
                    if PurchInvLine.Quantity <> ReceivedQtyNoReturned then
                      ErrorHelperLine(Errortype::ItemIsReturned,PurchInvLine);
                  end;

                if Item.Blocked then
                  ErrorHelperLine(Errortype::ItemBlocked,PurchInvLine);

                TableID[1] := Database::Item;
                No[1] := PurchInvLine."No.";
                if not DimensionManagement.CheckDimValuePosting(TableID,No,PurchInvLine."Dimension Set ID") then
                  ErrorHelperAccount(Errortype::DimErr,Item.TableCaption,No[1],Item."No.",Item.Description);

                if Item.Type <> Item.Type::Service then
                  TestInventoryPostingSetup(PurchInvLine);

                TestGenPostingSetup(PurchInvLine);
                TestVendorPostingGroup(PurchInvLine,PurchInvHeader."Vendor Posting Group");
                TestVATPostingSetup(PurchInvLine);

                if not DimensionManagement.CheckDimIDComb(PurchInvLine."Dimension Set ID") then
                  ErrorHelperLine(Errortype::DimCombErr,PurchInvLine);
              end;
            end;
          until PurchInvLine.Next = 0;
    end;

    local procedure TestGLAccount(AccountNo: Code[20];PurchInvLine: Record "Purch. Inv. Line")
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
        Item.Get(PurchInvLine."No.");
        if not DimensionManagement.CheckDimValuePosting(TableID,No,PurchInvLine."Dimension Set ID") then
          ErrorHelperAccount(Errortype::DimErr,GLAccount.TableCaption,AccountNo,Item."No.",Item.Description);
    end;

    local procedure TestIfInvoiceIsPaid(PurchInvHeader: Record "Purch. Inv. Header")
    begin
        PurchInvHeader.CalcFields("Amount Including VAT");
        PurchInvHeader.CalcFields("Remaining Amount");
        if PurchInvHeader."Amount Including VAT" <> PurchInvHeader."Remaining Amount" then
          ErrorHelperHeader(Errortype::IsPaid,PurchInvHeader);
    end;

    local procedure TestIfInvoiceIsCorrectedOnce(PurchInvHeader: Record "Purch. Inv. Header")
    var
        CancelledDocument: Record "Cancelled Document";
    begin
        if CancelledDocument.FindPurchCancelledInvoice(PurchInvHeader."No.") then
          ErrorHelperHeader(Errortype::IsCorrected,PurchInvHeader);
    end;

    local procedure TestIfInvoiceIsNotCorrectiveDoc(PurchInvHeader: Record "Purch. Inv. Header")
    var
        CancelledDocument: Record "Cancelled Document";
    begin
        if CancelledDocument.FindPurchCorrectiveInvoice(PurchInvHeader."No.") then
          ErrorHelperHeader(Errortype::IsCorrective,PurchInvHeader);
    end;

    local procedure TestIfPostingIsAllowed(PurchInvHeader: Record "Purch. Inv. Header")
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        if GenJnlCheckLine.DateNotAllowed(PurchInvHeader."Posting Date") then
          ErrorHelperHeader(Errortype::PostingNotAllowed,PurchInvHeader);
    end;

    local procedure TestIfAnyFreeNumberSeries(PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PostingDate: Date;
    begin
        PostingDate := WorkDate;
        PurchasesPayablesSetup.Get;

        if NoSeriesManagement.TryGetNextNo(PurchasesPayablesSetup."Credit Memo Nos.",PostingDate) = '' then
          ErrorHelperHeader(Errortype::SerieNumCM,PurchInvHeader);

        if NoSeriesManagement.TryGetNextNo(PurchasesPayablesSetup."Posted Credit Memo Nos.",PostingDate) = '' then
          ErrorHelperHeader(Errortype::SerieNumPostCM,PurchInvHeader);

        if (not CancellingOnly) and (NoSeriesManagement.TryGetNextNo(PurchasesPayablesSetup."Invoice Nos.",PostingDate) = '') then
          ErrorHelperHeader(Errortype::SerieNumInv,PurchInvHeader);
    end;

    local procedure TestIfInvoiceIsBasedOnOrder(PurchInvHeader: Record "Purch. Inv. Header")
    begin
        if PurchInvHeader."Order No." <> '' then
          ErrorHelperHeader(Errortype::FromOrder,PurchInvHeader);
    end;

    local procedure TestExternalDocument(PurchInvHeader: Record "Purch. Inv. Header")
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get;
        if (PurchInvHeader."Vendor Invoice No." = '') and PurchasesPayablesSetup."Ext. Doc. No. Mandatory" then
          ErrorHelperHeader(Errortype::ExtDocErr,PurchInvHeader);
    end;

    local procedure TestInventoryPostingClosed(PurchInvHeader: Record "Purch. Inv. Header")
    var
        InventoryPeriod: Record "Inventory Period";
    begin
        InventoryPeriod.SetRange(Closed,true);
        InventoryPeriod.SetFilter("Ending Date",'>=%1',PurchInvHeader."Posting Date");
        if InventoryPeriod.FindFirst then
          ErrorHelperHeader(Errortype::InventoryPostClosed,PurchInvHeader);
    end;

    local procedure TestGenPostingSetup(PurchInvLine: Record "Purch. Inv. Line")
    var
        GenPostingSetup: Record "General Posting Setup";
    begin
        with GenPostingSetup do begin
          Get(PurchInvLine."Gen. Bus. Posting Group",PurchInvLine."Gen. Prod. Posting Group");
          TestField("Purch. Account");
          TestGLAccount("Purch. Account",PurchInvLine);
          TestField("Purch. Credit Memo Account");
          TestGLAccount("Purch. Credit Memo Account",PurchInvLine);
          TestField("Direct Cost Applied Account");
          TestGLAccount("Direct Cost Applied Account",PurchInvLine);
          TestField("Purch. Line Disc. Account");
          TestGLAccount("Purch. Line Disc. Account",PurchInvLine);
        end;
    end;

    local procedure TestVendorPostingGroup(PurchInvLine: Record "Purch. Inv. Line";VendorPostingGr: Code[10])
    var
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        with VendorPostingGroup do begin
          Get(VendorPostingGr);
          TestField("Payables Account");
          TestGLAccount("Payables Account",PurchInvLine);
        end;
    end;

    local procedure TestVATPostingSetup(PurchInvLine: Record "Purch. Inv. Line")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        with VATPostingSetup do begin
          Get(PurchInvLine."VAT Bus. Posting Group",PurchInvLine."VAT Prod. Posting Group");
          if "VAT Calculation Type" <> "vat calculation type"::"Sales Tax" then begin
            TestField("Purchase VAT Account");
            TestGLAccount("Purchase VAT Account",PurchInvLine);
          end;
        end;
    end;

    local procedure TestInventoryPostingSetup(PurchInvLine: Record "Purch. Inv. Line")
    var
        InventoryPostingSetup: Record "Inventory Posting Setup";
    begin
        with InventoryPostingSetup do begin
          Get(PurchInvLine."Location Code",PurchInvLine."Posting Group");
          TestField("Inventory Account");
          TestGLAccount("Inventory Account",PurchInvLine);
        end;
    end;

    local procedure IsCommentLine(PurchInvLine: Record "Purch. Inv. Line"): Boolean
    begin
        exit((PurchInvLine.Type = PurchInvLine.Type::" ") or (PurchInvLine."No." = ''));
    end;

    local procedure WasNotCancelled(InvNo: Code[20]): Boolean
    var
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        PurchCrMemoHdr.SetRange("Applies-to Doc. Type",PurchCrMemoHdr."applies-to doc. type"::Invoice);
        PurchCrMemoHdr.SetRange("Applies-to Doc. No.",InvNo);
        exit(PurchCrMemoHdr.IsEmpty);
    end;

    local procedure NotInvRndAccount(VendorPostingGroupCode: Code[10];PurchInvLine: Record "Purch. Inv. Line"): Boolean
    var
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        if PurchInvLine.Type <> PurchInvLine.Type::"G/L Account" then
          exit(true);

        VendorPostingGroup.Get(VendorPostingGroupCode);
        exit((VendorPostingGroup."Invoice Rounding Account" <> PurchInvLine."No.") or (not PurchInvLine."System-Created Entry"));
    end;

    local procedure UnapplyCostApplication(var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";InvNo: Code[20]): Boolean
    var
        TempItemLedgEntry: Record "Item Ledger Entry" temporary;
        TempItemApplicationEntry: Record "Item Application Entry" temporary;
    begin
        FindItemLedgEntries(TempItemLedgEntry,InvNo);
        if FindAppliedInbndEntries(TempItemApplicationEntry,TempItemLedgEntry) then begin
          repeat
            ItemJnlPostLine.UnApply(TempItemApplicationEntry);
          until TempItemApplicationEntry.Next = 0;
          exit(true);
        end;
    end;

    local procedure FindItemLedgEntries(var ItemLedgEntry: Record "Item Ledger Entry";InvNo: Code[20])
    var
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        with PurchInvLine do begin
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
            if ItemApplicationEntry.AppliedOutbndEntryExists(ItemLedgEntry."Entry No.",true,false) then
              repeat
                TempItemApplicationEntry := ItemApplicationEntry;
                if not TempItemApplicationEntry.Find then
                  TempItemApplicationEntry.Insert;
              until ItemApplicationEntry.Next = 0;
          until ItemLedgEntry.Next = 0;
        exit(TempItemApplicationEntry.FindSet);
    end;

    local procedure ErrorHelperHeader(ErrorOption: Option;PurchInvHeader: Record "Purch. Inv. Header")
    var
        Vendor: Record Vendor;
    begin
        if CancellingOnly then
          case ErrorOption of
            Errortype::IsPaid:
              Error(PostedInvoiceIsPaidCCancelErr);
            Errortype::VendorBlocked:
              begin
                Vendor.Get(PurchInvHeader."Pay-to Vendor No.");
                Error(VendorIsBlockedCancelErr,Vendor.Name);
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
            Errortype::FromOrder:
              Error(InvoiceIsBasedOnOrderCancelErr);
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
            Errortype::VendorBlocked:
              begin
                Vendor.Get(PurchInvHeader."Pay-to Vendor No.");
                Error(VendorIsBlockedCorrectErr,Vendor.Name);
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
            Errortype::FromOrder:
              Error(InvoiceIsBasedOnOrderCorrectErr);
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

    local procedure ErrorHelperLine(ErrorOption: Option;PurchInvLine: Record "Purch. Inv. Line")
    var
        Item: Record Item;
    begin
        if CancellingOnly then
          case ErrorOption of
            Errortype::ItemBlocked:
              begin
                Item.Get(PurchInvLine."No.");
                Error(ItemIsBlockedCancelErr,Item."No.",Item.Description);
              end;
            Errortype::ItemIsReturned:
              begin
                Item.Get(PurchInvLine."No.");
                Error(ShippedQtyReturnedCancelErr,Item."No.",Item.Description);
              end;
            Errortype::LineFromOrder:
              Error(PurchaseLineFromOrderCancelErr,PurchInvLine."No.",PurchInvLine.Description);
            Errortype::WrongItemType:
              Error(LineTypeNotAllowedCancelErr,PurchInvLine."No.",PurchInvLine.Description,PurchInvLine.Type);
            Errortype::LineFromJob:
              Error(UsedInJobCancelErr,PurchInvLine."No.",PurchInvLine.Description);
            Errortype::DimCombErr:
              Error(InvalidDimCombinationCancelErr,PurchInvLine."No.",PurchInvLine.Description);
          end
        else
          case ErrorOption of
            Errortype::ItemBlocked:
              begin
                Item.Get(PurchInvLine."No.");
                Error(ItemIsBlockedCorrectErr,Item."No.",Item.Description);
              end;
            Errortype::ItemIsReturned:
              begin
                Item.Get(PurchInvLine."No.");
                Error(ShippedQtyReturnedCorrectErr,Item."No.",Item.Description);
              end;
            Errortype::LineFromOrder:
              Error(PurchaseLineFromOrderCorrectErr,PurchInvLine."No.",PurchInvLine.Description);
            Errortype::WrongItemType:
              Error(LineTypeNotAllowedCorrectErr,PurchInvLine."No.",PurchInvLine.Description,PurchInvLine.Type);
            Errortype::LineFromJob:
              Error(UsedInJobCorrectErr,PurchInvLine."No.",PurchInvLine.Description);
            Errortype::DimCombErr:
              Error(InvalidDimCombinationCorrectErr,PurchInvLine."No.",PurchInvLine.Description);
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

