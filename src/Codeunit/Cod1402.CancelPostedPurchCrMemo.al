#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1402 "Cancel Posted Purch. Cr. Memo"
{
    Permissions = TableData "Sales Invoice Header"=rm,
                  TableData "Sales Cr.Memo Header"=rm;
    TableNo = "Purch. Cr. Memo Hdr.";

    trigger OnRun()
    var
        PurchHeader: Record "Purchase Header";
    begin
        UnapplyEntries(Rec);
        CreateCopyDocument(Rec,PurchHeader);

        Codeunit.Run(Codeunit::"Purch.-Post",PurchHeader);
        SetTrackInfoForCancellation(Rec);

        Commit;
    end;

    var
        AlreadyCancelledErr: label 'You cannot cancel this posted purchase credit memo because it has already been canceled.';
        NotCorrectiveDocErr: label 'You cannot cancel this posted purchase credit memo because it is not a corrective document.';
        VendorIsBlockedCancelErr: label 'You cannot cancel this posted purchase credit memo because vendor %1 is blocked.', Comment='%1 = Customer name';
        ItemIsBlockedCancelErr: label 'You cannot cancel this posted purchase credit memo because item %1 %2 is blocked.', Comment='%1 = Item No. %2 = Item Description';
        AccountIsBlockedCancelErr: label 'You cannot cancel this posted purchase credit memo because %1 %2 is blocked.', Comment='%1 = Table Caption %2 = Account number.';
        NoFreeInvoiceNoSeriesCancelErr: label 'You cannot cancel this posted purchase credit memo because no unused invoice numbers are available. \\You must extend the range of the number series for purchase invoices.';
        NoFreePostInvSeriesCancelErr: label 'You cannot cancel this posted purchase credit memo because no unused posted invoice numbers are available. \\You must extend the range of the number series for posted invoices.';
        PostingNotAllowedCancelErr: label 'You cannot cancel this posted purchase credit memo because it was posted in a posting period that is closed.';
        InvalidDimCodeCancelErr: label 'You cannot cancel this posted purchase credit memo because the dimension rule setup for account ''%1'' %2 prevents %3 %4 from being canceled.', Comment='%1 = Table caption %2 = Account number %3 = Item no. %4 = Item description.';
        InvalidDimCombinationCancelErr: label 'You cannot cancel this posted purchase credit memo because the dimension combination for item %1 %2 is not allowed.', Comment='%1 = Item no. %2 = Item description.';
        InvalidDimCombHeaderCancelErr: label 'You cannot cancel this posted purchase credit memo because the combination of dimensions on the credit memo is blocked.';
        ExternalDocCancelErr: label 'You cannot cancel this posted purchase memo because the external document number is required on the credit memo.';
        InventoryPostClosedCancelErr: label 'You cannot cancel this posted purchase credit memo because the inventory period is already closed.';
        PostingCreditMemoFailedOpenPostedInvQst: label 'Canceling the credit memo failed because of the following error: \\%1\\An invoice is posted. Do you want to open the posted invoice?', Comment='%1 = error text';
        PostingCreditMemoFailedOpenInvQst: label 'Canceling the credit memo failed because of the following error: \\%1\\An invoice is created but not posted. Do you want to open the invoice?', Comment='%1 = error text';
        CreatingInvFailedNothingCreatedErr: label 'Canceling the credit memo failed because of the following error: \\%1.', Comment='%1 = error text';
        ErrorType: Option VendorBlocked,ItemBlocked,AccountBlocked,IsAppliedIncorrectly,IsUnapplied,IsCanceled,IsCorrected,SerieNumInv,SerieNumPostInv,FromOrder,PostingNotAllowed,DimErr,DimCombErr,DimCombHeaderErr,ExtDocErr,InventoryPostClosed;
        UnappliedErr: label 'You cannot cancel this posted purchase credit memo because it is fully or partially applied.\\To reverse an applied purchase credit memo, you must manually unapply all applied entries.';
        NotAppliedCorrectlyErr: label 'You cannot cancel this posted purchase credit memo because it is not fully applied to an invoice.';


    procedure CancelPostedCrMemo(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."): Boolean
    var
        PurchHeader: Record "Purchase Header";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        TestCorrectCrMemoIsAllowed(PurchCrMemoHdr);
        if not Codeunit.Run(Codeunit::"Cancel Posted Purch. Cr. Memo",PurchCrMemoHdr) then begin
          PurchInvHeader.SetRange("Applies-to Doc. No.",PurchCrMemoHdr."No.");
          if PurchInvHeader.FindFirst then begin
            if Confirm(StrSubstNo(PostingCreditMemoFailedOpenPostedInvQst,GetLastErrorText)) then
              Page.Run(Page::"Posted Purchase Invoice",PurchInvHeader);
          end else begin
            PurchHeader.SetRange("Applies-to Doc. No.",PurchCrMemoHdr."No.");
            if PurchHeader.FindFirst then begin
              if Confirm(StrSubstNo(PostingCreditMemoFailedOpenInvQst,GetLastErrorText)) then
                Page.Run(Page::"Purchase Invoice",PurchHeader);
            end else
              Error(CreatingInvFailedNothingCreatedErr,GetLastErrorText);
          end;
          exit(false);
        end;
        exit(true);
    end;

    local procedure CreateCopyDocument(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";var PurchHeader: Record "Purchase Header")
    var
        CopyDocMgt: Codeunit "Copy Document Mgt.";
    begin
        Clear(PurchHeader);
        PurchHeader."No." := '';
        PurchHeader."Document Type" := PurchHeader."document type"::Invoice;
        PurchHeader.Insert(true);
        CopyDocMgt.SetPropertiesForInvoiceCorrection(false);
        CopyDocMgt.CopyPurchDocForCrMemoCancelling(PurchCrMemoHdr."No.",PurchHeader);
        PurchHeader."Vendor Invoice No." := PurchHeader."No.";
    end;


    procedure TestCorrectCrMemoIsAllowed(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    begin
        TestIfPostingIsAllowed(PurchCrMemoHdr);
        TestIfVendorIsBlocked(PurchCrMemoHdr,PurchCrMemoHdr."Buy-from Vendor No.");
        TestIfVendorIsBlocked(PurchCrMemoHdr,PurchCrMemoHdr."Pay-to Vendor No.");
        TestIfInvoiceIsCorrectedOnce(PurchCrMemoHdr);
        TestIfCrMemoIsCorrectiveDoc(PurchCrMemoHdr);
        TestVendorDimension(PurchCrMemoHdr,PurchCrMemoHdr."Pay-to Vendor No.");
        TestDimensionOnHeader(PurchCrMemoHdr);
        TestPurchLines(PurchCrMemoHdr);
        TestIfAnyFreeNumberSeries(PurchCrMemoHdr);
        TestExternalDocument(PurchCrMemoHdr);
        TestInventoryPostingClosed(PurchCrMemoHdr);
    end;

    local procedure SetTrackInfoForCancellation(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        CancelledDocument: Record "Cancelled Document";
    begin
        PurchInvHeader.SetRange("Applies-to Doc. No.",PurchCrMemoHdr."No.");
        if PurchInvHeader.FindLast then
          CancelledDocument.InsertPurchCrMemoToInvCancelledDocument(PurchCrMemoHdr."No.",PurchInvHeader."No.");
    end;

    local procedure TestDimensionOnHeader(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        if not DimensionManagement.CheckDimIDComb(PurchCrMemoHdr."Dimension Set ID") then
          ErrorHelperHeader(Errortype::DimCombHeaderErr,PurchCrMemoHdr);
    end;

    local procedure TestIfVendorIsBlocked(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";VendNo: Code[20])
    var
        Vendor: Record Vendor;
    begin
        Vendor.Get(VendNo);
        if Vendor.Blocked = Vendor.Blocked::All then
          ErrorHelperHeader(Errortype::VendorBlocked,PurchCrMemoHdr);
    end;

    local procedure TestIfAppliedCorrectly(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";VendLedgEntry: Record "Vendor Ledger Entry")
    var
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PartiallyApplied: Boolean;
    begin
        VendLedgEntry.CalcFields(Amount,"Remaining Amount");
        PartiallyApplied :=
          ((VendLedgEntry.Amount <> VendLedgEntry."Remaining Amount") and (VendLedgEntry."Remaining Amount" <> 0));
        if (CalcDtldVendLedgEntryCount(DetailedVendLedgEntry."entry type"::"Initial Entry",VendLedgEntry."Entry No.") <> 1) or
           (not (CalcDtldVendLedgEntryCount(DetailedVendLedgEntry."entry type"::Application,VendLedgEntry."Entry No.") in [0,1])) or
           AnyDtldVendLedgEntriesExceptInitialAndApplicaltionExists(VendLedgEntry."Entry No.") or
           PartiallyApplied
        then
          ErrorHelperHeader(Errortype::IsAppliedIncorrectly,PurchCrMemoHdr);
    end;

    local procedure TestIfUnapplied(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    begin
        PurchCrMemoHdr.CalcFields("Amount Including VAT");
        PurchCrMemoHdr.CalcFields("Remaining Amount");
        if PurchCrMemoHdr."Amount Including VAT" <> -PurchCrMemoHdr."Remaining Amount" then
          ErrorHelperHeader(Errortype::IsUnapplied,PurchCrMemoHdr);
    end;

    local procedure TestVendorDimension(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";VendNo: Code[20])
    var
        Vendor: Record Vendor;
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        Vendor.Get(VendNo);
        TableID[1] := Database::Vendor;
        No[1] := Vendor."No.";
        if not DimensionManagement.CheckDimValuePosting(TableID,No,PurchCrMemoHdr."Dimension Set ID") then
          ErrorHelperAccount(Errortype::DimErr,Vendor.TableCaption,Vendor."No.",Vendor."No.",Vendor.Name);
    end;

    local procedure TestPurchLines(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        Item: Record Item;
        DimensionManagement: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        PurchCrMemoLine.SetRange("Document No.",PurchCrMemoHdr."No.");
        if PurchCrMemoLine.Find('-') then
          repeat
            if not IsCommentLine(PurchCrMemoLine) then begin
              if PurchCrMemoLine.Type = PurchCrMemoLine.Type::Item then begin
                Item.Get(PurchCrMemoLine."No.");

                if Item.Blocked then
                  ErrorHelperLine(Errortype::ItemBlocked,PurchCrMemoLine);

                TableID[1] := Database::Item;
                No[1] := PurchCrMemoLine."No.";
                if not DimensionManagement.CheckDimValuePosting(TableID,No,PurchCrMemoLine."Dimension Set ID") then
                  ErrorHelperAccount(Errortype::DimErr,Item.TableCaption,No[1],Item."No.",Item.Description);

                if Item.Type = Item.Type::Inventory then
                  TestInventoryPostingSetup(PurchCrMemoLine);
              end;

              TestGenPostingSetup(PurchCrMemoLine);
              TestVendorPostingGroup(PurchCrMemoLine,PurchCrMemoHdr."Vendor Posting Group");
              TestVATPostingSetup(PurchCrMemoLine);

              if not DimensionManagement.CheckDimIDComb(PurchCrMemoLine."Dimension Set ID") then
                ErrorHelperLine(Errortype::DimCombErr,PurchCrMemoLine);
            end;
          until PurchCrMemoLine.Next = 0;
    end;

    local procedure TestGLAccount(AccountNo: Code[20];PurchCrMemoLine: Record "Purch. Cr. Memo Line")
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

        if PurchCrMemoLine.Type = PurchCrMemoLine.Type::Item then begin
          Item.Get(PurchCrMemoLine."No.");
          if not DimensionManagement.CheckDimValuePosting(TableID,No,PurchCrMemoLine."Dimension Set ID") then
            ErrorHelperAccount(Errortype::DimErr,GLAccount.TableCaption,AccountNo,Item."No.",Item.Description);
        end;
    end;

    local procedure TestIfInvoiceIsCorrectedOnce(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        CancelledDocument: Record "Cancelled Document";
    begin
        if CancelledDocument.FindPurchCancelledCrMemo(PurchCrMemoHdr."No.") then
          ErrorHelperHeader(Errortype::IsCorrected,PurchCrMemoHdr);
    end;

    local procedure TestIfCrMemoIsCorrectiveDoc(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        CancelledDocument: Record "Cancelled Document";
    begin
        if not CancelledDocument.FindPurchCorrectiveCrMemo(PurchCrMemoHdr."No.") then
          ErrorHelperHeader(Errortype::IsCanceled,PurchCrMemoHdr);
    end;

    local procedure TestIfPostingIsAllowed(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        if GenJnlCheckLine.DateNotAllowed(PurchCrMemoHdr."Posting Date") then
          ErrorHelperHeader(Errortype::PostingNotAllowed,PurchCrMemoHdr);
    end;

    local procedure TestIfAnyFreeNumberSeries(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        PostingDate: Date;
    begin
        PostingDate := WorkDate;
        PurchasesPayablesSetup.Get;

        if NoSeriesManagement.TryGetNextNo(PurchasesPayablesSetup."Invoice Nos.",PostingDate) = '' then
          ErrorHelperHeader(Errortype::SerieNumInv,PurchCrMemoHdr);

        if NoSeriesManagement.TryGetNextNo(PurchasesPayablesSetup."Posted Invoice Nos.",PostingDate) = '' then
          ErrorHelperHeader(Errortype::SerieNumPostInv,PurchCrMemoHdr);
    end;

    local procedure TestExternalDocument(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        PurchasesPayablesSetup: Record "Purchases & Payables Setup";
    begin
        PurchasesPayablesSetup.Get;
        if (PurchCrMemoHdr."Vendor Cr. Memo No." = '') and PurchasesPayablesSetup."Ext. Doc. No. Mandatory" then
          ErrorHelperHeader(Errortype::ExtDocErr,PurchCrMemoHdr);
    end;

    local procedure TestInventoryPostingClosed(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        InventoryPeriod: Record "Inventory Period";
    begin
        InventoryPeriod.SetRange(Closed,true);
        InventoryPeriod.SetFilter("Ending Date",'>=%1',PurchCrMemoHdr."Posting Date");
        if InventoryPeriod.FindFirst then
          ErrorHelperHeader(Errortype::InventoryPostClosed,PurchCrMemoHdr);
    end;

    local procedure TestGenPostingSetup(PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    var
        GenPostingSetup: Record "General Posting Setup";
    begin
        with GenPostingSetup do begin
          Get(PurchCrMemoLine."Gen. Bus. Posting Group",PurchCrMemoLine."Gen. Prod. Posting Group");
          TestField("Purch. Account");
          TestGLAccount("Purch. Account",PurchCrMemoLine);
          TestField("Purch. Credit Memo Account");
          TestGLAccount("Purch. Credit Memo Account",PurchCrMemoLine);
          TestField("Purch. Line Disc. Account");
          TestGLAccount("Purch. Line Disc. Account",PurchCrMemoLine);
          if PurchCrMemoLine.Type = PurchCrMemoLine.Type::Item then begin
            TestField("COGS Account");
            TestGLAccount("COGS Account",PurchCrMemoLine);
          end;
        end;
    end;

    local procedure TestVendorPostingGroup(PurchCrMemoLine: Record "Purch. Cr. Memo Line";VendorPostingGr: Code[10])
    var
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        with VendorPostingGroup do begin
          Get(VendorPostingGr);
          TestField("Payables Account");
          TestGLAccount("Payables Account",PurchCrMemoLine);
        end;
    end;

    local procedure TestVATPostingSetup(PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        with VATPostingSetup do begin
          Get(PurchCrMemoLine."VAT Bus. Posting Group",PurchCrMemoLine."VAT Prod. Posting Group");
          if "VAT Calculation Type" <> "vat calculation type"::"Sales Tax" then begin
            TestField("Purchase VAT Account");
            TestGLAccount("Purchase VAT Account",PurchCrMemoLine);
          end;
        end;
    end;

    local procedure TestInventoryPostingSetup(PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    var
        InventoryPostingSetup: Record "Inventory Posting Setup";
    begin
        with InventoryPostingSetup do begin
          Get(PurchCrMemoLine."Location Code",PurchCrMemoLine."Posting Group");
          TestField("Inventory Account");
          TestGLAccount("Inventory Account",PurchCrMemoLine);
        end;
    end;

    local procedure UnapplyEntries(PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
    begin
        FindVendLedgEntry(VendorLedgerEntry,PurchCrMemoHdr."No.");
        TestIfAppliedCorrectly(PurchCrMemoHdr,VendorLedgerEntry);
        if VendorLedgerEntry.Open then
          exit;

        FindDetailedApplicationEntry(DetailedVendLedgEntry,VendorLedgerEntry);
        VendEntryApplyPostedEntries.PostUnApplyVendor(
          DetailedVendLedgEntry,DetailedVendLedgEntry."Document No.",DetailedVendLedgEntry."Posting Date");
        TestIfUnapplied(PurchCrMemoHdr);
    end;

    local procedure FindVendLedgEntry(var VendorLedgerEntry: Record "Vendor Ledger Entry";DocNo: Code[20])
    begin
        VendorLedgerEntry.SetRange("Document Type",VendorLedgerEntry."document type"::"Credit Memo");
        VendorLedgerEntry.SetRange("Document No.",DocNo);
        VendorLedgerEntry.FindLast;
    end;

    local procedure FindDetailedApplicationEntry(var DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";VendLedgerEntry: Record "Vendor Ledger Entry")
    begin
        DetailedVendLedgEntry.SetRange("Entry Type",DetailedVendLedgEntry."entry type"::Application);
        DetailedVendLedgEntry.SetRange("Vendor No.",VendLedgerEntry."Vendor No.");
        DetailedVendLedgEntry.SetRange("Document No.",VendLedgerEntry."Document No.");
        DetailedVendLedgEntry.SetRange("Vendor Ledger Entry No.",VendLedgerEntry."Entry No.");
        DetailedVendLedgEntry.SetRange(Unapplied,false);
        DetailedVendLedgEntry.FindFirst;
    end;

    local procedure AnyDtldVendLedgEntriesExceptInitialAndApplicaltionExists(VendLedgEntryNo: Integer): Boolean
    var
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DetailedVendLedgEntry.SetFilter(
          "Entry Type",'<>%1&<>%2',DetailedVendLedgEntry."entry type"::"Initial Entry",DetailedVendLedgEntry."entry type"::Application);
        DetailedVendLedgEntry.SetRange("Vendor Ledger Entry No.",VendLedgEntryNo);
        exit(not DetailedVendLedgEntry.IsEmpty);
    end;

    local procedure CalcDtldVendLedgEntryCount(EntryType: Option;VendLedgEntryNo: Integer): Integer
    var
        DetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        DetailedVendLedgEntry.SetRange("Entry Type",EntryType);
        DetailedVendLedgEntry.SetRange("Vendor Ledger Entry No.",VendLedgEntryNo);
        DetailedVendLedgEntry.SetRange(Unapplied,false);
        exit(DetailedVendLedgEntry.Count);
    end;

    local procedure IsCommentLine(PurchCrMemoLine: Record "Purch. Cr. Memo Line"): Boolean
    begin
        exit((PurchCrMemoLine.Type = PurchCrMemoLine.Type::" ") or (PurchCrMemoLine."No." = ''));
    end;

    local procedure ErrorHelperHeader(ErrorOption: Option;PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        Vendor: Record Vendor;
    begin
        case ErrorOption of
          Errortype::VendorBlocked:
            begin
              Vendor.Get(PurchCrMemoHdr."Pay-to Vendor No.");
              Error(VendorIsBlockedCancelErr,Vendor.Name);
            end;
          Errortype::IsAppliedIncorrectly:
            Error(NotAppliedCorrectlyErr);
          Errortype::IsUnapplied:
            Error(UnappliedErr);
          Errortype::IsCorrected:
            Error(AlreadyCancelledErr);
          Errortype::IsCanceled:
            Error(NotCorrectiveDocErr);
          Errortype::SerieNumInv:
            Error(NoFreeInvoiceNoSeriesCancelErr);
          Errortype::SerieNumPostInv:
            Error(NoFreePostInvSeriesCancelErr);
          Errortype::PostingNotAllowed:
            Error(PostingNotAllowedCancelErr);
          Errortype::ExtDocErr:
            Error(ExternalDocCancelErr);
          Errortype::InventoryPostClosed:
            Error(InventoryPostClosedCancelErr);
          Errortype::DimCombHeaderErr:
            Error(InvalidDimCombHeaderCancelErr);
        end
    end;

    local procedure ErrorHelperLine(ErrorOption: Option;PurchCrMemoLine: Record "Purch. Cr. Memo Line")
    var
        Item: Record Item;
    begin
        case ErrorOption of
          Errortype::ItemBlocked:
            begin
              Item.Get(PurchCrMemoLine."No.");
              Error(ItemIsBlockedCancelErr,Item."No.",Item.Description);
            end;
          Errortype::DimCombErr:
            Error(InvalidDimCombinationCancelErr,PurchCrMemoLine."No.",PurchCrMemoLine.Description);
        end
    end;

    local procedure ErrorHelperAccount(ErrorOption: Option;AccountNo: Code[20];AccountCaption: Text;No: Code[20];Name: Text)
    begin
        case ErrorOption of
          Errortype::AccountBlocked:
            Error(AccountIsBlockedCancelErr,AccountCaption,AccountNo);
          Errortype::DimErr:
            Error(InvalidDimCodeCancelErr,AccountCaption,AccountNo,No,Name);
        end;
    end;
}

