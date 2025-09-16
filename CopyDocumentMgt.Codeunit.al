#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6620 "Copy Document Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Please enter a Document No.';
        Text001: label '%1 %2 cannot be copied onto itself.';
        DeleteLinesQst: label 'The existing lines for %1 %2 will be deleted.\\Do you want to continue?', Comment='%1=Document type, e.g. Invoice. %2=Document No., e.g. 001';
        Text004: label 'The document line(s) with a G/L account where direct posting is not allowed have not been copied to the new document by the Copy Document batch job.';
        Text006: label 'NOTE: A Payment Discount was Granted by %1 %2.';
        Text007: label 'Quote,Blanket Order,Order,Invoice,Credit Memo,Posted Shipment,Posted Invoice,Posted Credit Memo,Posted Return Receipt';
        Currency: Record Currency;
        Item: Record Item;
        AsmHeader: Record "Assembly Header";
        PostedAsmHeader: Record "Posted Assembly Header";
        TempAsmHeader: Record "Assembly Header" temporary;
        TempAsmLine: Record "Assembly Line" temporary;
        TempSalesInvLine: Record "Sales Invoice Line" temporary;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        TransferOldExtLines: Codeunit "Transfer Old Ext. Text Lines";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        DeferralUtilities: Codeunit "Deferral Utilities";
        Window: Dialog;
        WindowUpdateDateTime: DateTime;
        InsertCancellationLine: Boolean;
        SalesDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Shipment","Posted Invoice","Posted Return Receipt","Posted Credit Memo";
        PurchDocType: Option Quote,"Blanket Order","Order",Invoice,"Return Order","Credit Memo","Posted Receipt","Posted Invoice","Posted Return Shipment","Posted Credit Memo";
        ServDocType: Option Quote,Contract;
        QtyToAsmToOrder: Decimal;
        QtyToAsmToOrderBase: Decimal;
        IncludeHeader: Boolean;
        RecalculateLines: Boolean;
        MoveNegLines: Boolean;
        Text008: label 'There are no negative sales lines to move.';
        Text009: label 'NOTE: A Payment Discount was Received by %1 %2.';
        Text010: label 'There are no negative purchase lines to move.';
        CreateToHeader: Boolean;
        Text011: label 'Please enter a Vendor No.';
        HideDialog: Boolean;
        Text012: label 'There are no sales lines to copy.';
        Text013: label 'Shipment No.,Invoice No.,Return Receipt No.,Credit Memo No.';
        Text014: label 'Receipt No.,Invoice No.,Return Shipment No.,Credit Memo No.';
        Text015: label '%1 %2:';
        Text016: label 'Inv. No. ,Shpt. No. ,Cr. Memo No. ,Rtrn. Rcpt. No. ';
        Text017: label 'Inv. No. ,Rcpt. No. ,Cr. Memo No. ,Rtrn. Shpt. No. ';
        Text018: label '%1 - %2:';
        Text019: label 'Exact Cost Reversing Link has not been created for all copied document lines.';
        Text020: label '\';
        Text022: label 'Copying document lines...\';
        Text023: label 'Processing source lines      #1######\';
        Text024: label 'Creating new lines           #2######';
        ExactCostRevMandatory: Boolean;
        ApplyFully: Boolean;
        AskApply: Boolean;
        ReappDone: Boolean;
        Text025: label 'For one or more return document lines, you chose to return the original quantity, which is already fully applied. Therefore, when you post the return document, the program will reapply relevant entries. Beware that this may change the cost of existing entries. To avoid this, you must delete the affected return document lines before posting.';
        SkippedLine: Boolean;
        Text029: label 'One or more return document lines were not inserted or they contain only the remaining quantity of the original document line. This is because quantities on the posted document line are already fully or partially applied. If you want to reverse the full quantity, you must select Return Original Quantity before getting the posted document lines.';
        Text030: label 'One or more return document lines were not copied. This is because quantities on the posted document line are already fully or partially applied, so the Exact Cost Reversing link could not be created.';
        Text031: label 'Return document line contains only the original document line quantity, that is not already manually applied.';
        SomeAreFixed: Boolean;
        AsmHdrExistsForFromDocLine: Boolean;
        Text032: label 'The posted sales invoice %1 covers more than one shipment of linked assembly orders that potentially have different assembly components. Select Posted Shipment as document type, and then select a specific shipment of assembled items.';
        SkipCopyFromDescription: Boolean;
        SkipTestCreditLimit: Boolean;
        WarningDone: Boolean;
        LinesApplied: Boolean;
        DiffPostDateOrderQst: label 'The Posting Date of the copied document is different from the Posting Date of the original document. The original document already has a Posting No. based on a number series with date order. When you post the copied document, you may have the wrong date order in the posted documents.\Do you want to continue?';
        CopyPostedDeferral: Boolean;
        CrMemoCancellationMsg: label 'Cancelation of credit memo %1.', Comment='%1 = Document No.';


    procedure SetProperties(NewIncludeHeader: Boolean;NewRecalculateLines: Boolean;NewMoveNegLines: Boolean;NewCreateToHeader: Boolean;NewHideDialog: Boolean;NewExactCostRevMandatory: Boolean;NewApplyFully: Boolean)
    begin
        IncludeHeader := NewIncludeHeader;
        RecalculateLines := NewRecalculateLines;
        MoveNegLines := NewMoveNegLines;
        CreateToHeader := NewCreateToHeader;
        HideDialog := NewHideDialog;
        ExactCostRevMandatory := NewExactCostRevMandatory;
        ApplyFully := NewApplyFully;
        AskApply := false;
        ReappDone := false;
        SkippedLine := false;
        SomeAreFixed := false;
        SkipCopyFromDescription := false;
        SkipTestCreditLimit := false;
    end;


    procedure SetPropertiesForCreditMemoCorrection()
    begin
        SetProperties(true,false,false,false,true,true,false);
    end;


    procedure SetPropertiesForInvoiceCorrection(NewSkipCopyFromDescription: Boolean)
    begin
        SetProperties(true,false,false,false,true,false,false);
        SkipTestCreditLimit := true;
        SkipCopyFromDescription := NewSkipCopyFromDescription;
    end;


    procedure SalesHeaderDocType(DocType: Option): Integer
    var
        SalesHeader: Record "Sales Header";
    begin
        case DocType of
          Salesdoctype::Quote:
            exit(SalesHeader."document type"::Quote);
          Salesdoctype::"Blanket Order":
            exit(SalesHeader."document type"::"Blanket Order");
          Salesdoctype::Order:
            exit(SalesHeader."document type"::Order);
          Salesdoctype::Invoice:
            exit(SalesHeader."document type"::Invoice);
          Salesdoctype::"Return Order":
            exit(SalesHeader."document type"::"Return Order");
          Salesdoctype::"Credit Memo":
            exit(SalesHeader."document type"::"Credit Memo");
        end;
    end;


    procedure PurchHeaderDocType(DocType: Option): Integer
    var
        FromPurchHeader: Record "Purchase Header";
    begin
        case DocType of
          Purchdoctype::Quote:
            exit(FromPurchHeader."document type"::Quote);
          Purchdoctype::"Blanket Order":
            exit(FromPurchHeader."document type"::"Blanket Order");
          Purchdoctype::Order:
            exit(FromPurchHeader."document type"::Order);
          Purchdoctype::Invoice:
            exit(FromPurchHeader."document type"::Invoice);
          Purchdoctype::"Return Order":
            exit(FromPurchHeader."document type"::"Return Order");
          Purchdoctype::"Credit Memo":
            exit(FromPurchHeader."document type"::"Credit Memo");
        end;
    end;


    procedure CopySalesDocForInvoiceCancelling(FromDocNo: Code[20];var ToSalesHeader: Record "Sales Header")
    begin
        CopySalesDoc(Salesdoctype::"Posted Invoice",FromDocNo,ToSalesHeader);
    end;


    procedure CopySalesDocForCrMemoCancelling(FromDocNo: Code[20];var ToSalesHeader: Record "Sales Header")
    begin
        InsertCancellationLine := true;
        CopySalesDoc(Salesdoctype::"Posted Credit Memo",FromDocNo,ToSalesHeader);
        InsertCancellationLine := false;
    end;


    procedure CopySalesDoc(FromDocType: Option;FromDocNo: Code[20];var ToSalesHeader: Record "Sales Header")
    var
        PaymentTerms: Record "Payment Terms";
        ToSalesLine: Record "Sales Line";
        OldSalesHeader: Record "Sales Header";
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        FromSalesShptHeader: Record "Sales Shipment Header";
        FromSalesShptLine: Record "Sales Shipment Line";
        FromSalesInvHeader: Record "Sales Invoice Header";
        FromSalesInvLine: Record "Sales Invoice Line";
        FromReturnRcptHeader: Record "Return Receipt Header";
        FromReturnRcptLine: Record "Return Receipt Line";
        FromSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        FromSalesCrMemoLine: Record "Sales Cr.Memo Line";
        GLSetUp: Record "General Ledger Setup";
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        NextLineNo: Integer;
        ItemChargeAssgntNextLineNo: Integer;
        LinesNotCopied: Integer;
        MissingExCostRevLink: Boolean;
        ReleaseDocument: Boolean;
    begin
        with ToSalesHeader do begin
          if not CreateToHeader then begin
            TestField(Status,Status::Open);
            if FromDocNo = '' then
              Error(Text000);
            Find;
          end;

          OnBeforeCopySalesDocument(FromDocType,FromDocNo,ToSalesHeader);

          TransferOldExtLines.ClearLineNumbers;

          if not InitAndCheckSalesDocuments(
               FromDocType,FromDocNo,FromSalesHeader,ToSalesHeader,
               FromSalesShptHeader,FromSalesInvHeader,FromReturnRcptHeader,FromSalesCrMemoHeader)
          then
            exit;

          ToSalesLine.LockTable;

          ToSalesLine.SetRange("Document Type","Document Type");
          if CreateToHeader then begin
            Insert(true);
            ToSalesLine.SetRange("Document No.","No.");
          end else begin
            ToSalesLine.SetRange("Document No.","No.");
            if IncludeHeader then
              if not ToSalesLine.IsEmpty then begin
                Commit;
                if not Confirm(DeleteLinesQst,true,"Document Type","No.") then
                  exit;
                ToSalesLine.DeleteAll(true);
              end;
          end;

          if ToSalesLine.FindLast then
            NextLineNo := ToSalesLine."Line No."
          else
            NextLineNo := 0;

          if IncludeHeader then begin
            CheckCustomer(FromSalesHeader,ToSalesHeader);
            OldSalesHeader := ToSalesHeader;
            case FromDocType of
              Salesdoctype::Quote,
              Salesdoctype::"Blanket Order",
              Salesdoctype::Order,
              Salesdoctype::Invoice,
              Salesdoctype::"Return Order",
              Salesdoctype::"Credit Memo":
                begin
                  FromSalesHeader.CalcFields("Work Description");
                  TransferFields(FromSalesHeader,false);
                  "Last Shipping No." := '';
                  Status := Status::Open;
                  if "Document Type" <> "document type"::Order then
                    "Prepayment %" := 0;
                  if FromDocType = Salesdoctype::"Return Order" then
                    Validate("Ship-to Code");
                  if FromDocType in [Salesdoctype::Quote,Salesdoctype::"Blanket Order"] then
                    if OldSalesHeader."Posting Date" = 0D then
                      "Posting Date" := WorkDate
                    else
                      "Posting Date" := OldSalesHeader."Posting Date";
                end;
              Salesdoctype::"Posted Shipment":
                begin
                  Validate("Sell-to Customer No.",FromSalesShptHeader."Sell-to Customer No.");
                  TransferFields(FromSalesShptHeader,false);
                end;
              Salesdoctype::"Posted Invoice":
                begin
                  FromSalesInvHeader.CalcFields("Work Description");
                  Validate("Sell-to Customer No.",FromSalesInvHeader."Sell-to Customer No.");
                  TransferFields(FromSalesInvHeader,false);
                end;
              Salesdoctype::"Posted Return Receipt":
                begin
                  Validate("Sell-to Customer No.",FromReturnRcptHeader."Sell-to Customer No.");
                  TransferFields(FromReturnRcptHeader,false);
                end;
              Salesdoctype::"Posted Credit Memo":
                begin
                  Validate("Sell-to Customer No.",FromSalesCrMemoHeader."Sell-to Customer No.");
                  TransferFields(FromSalesCrMemoHeader,false);
                end;
            end;
            Invoice := false;
            Ship := false;
            if Status = Status::Released then begin
              Status := Status::Open;
              ReleaseDocument := true;
            end;
            if MoveNegLines or IncludeHeader then
              Validate("Location Code");

            CopyFieldsFromOldSalesHeader(ToSalesHeader,OldSalesHeader);
            if RecalculateLines then
              CreateDim(
                Database::"Responsibility Center","Responsibility Center",
                Database::Customer,"Bill-to Customer No.",
                Database::"Salesperson/Purchaser","Salesperson Code",
                Database::Campaign,"Campaign No.",
                Database::"Customer Template","Bill-to Customer Template Code");
            "No. Printed" := 0;
            "Applies-to Doc. Type" := "applies-to doc. type"::" ";
            "Applies-to Doc. No." := '';
            "Applies-to ID" := '';
            "Opportunity No." := '';
            "Quote No." := '';
            if ((FromDocType = Salesdoctype::"Posted Invoice") and
                ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"])) or
               ((FromDocType = Salesdoctype::"Posted Credit Memo") and
                not ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]))
            then
              UpdateCustLedgEntry(ToSalesHeader,FromDocType,FromDocNo);

            if "Document Type" in ["document type"::"Blanket Order","document type"::Quote] then
              "Posting Date" := 0D;

            Correction := false;
            if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then begin
              "Shipment Date" := 0D;
              GLSetUp.Get;
              Correction := GLSetUp."Mark Cr. Memos as Corrections";
              if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then
                PaymentTerms.Get("Payment Terms Code")
              else
                Clear(PaymentTerms);
              if not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then begin
                "Payment Terms Code" := '';
                "Payment Discount %" := 0;
                "Pmt. Discount Date" := 0D;
              end;
            end;

            if CreateToHeader then begin
              Validate("Payment Terms Code");
              Modify(true);
            end else
              Modify;
          end;

          LinesNotCopied := 0;
          case FromDocType of
            Salesdoctype::Quote,
            Salesdoctype::"Blanket Order",
            Salesdoctype::Order,
            Salesdoctype::Invoice,
            Salesdoctype::"Return Order",
            Salesdoctype::"Credit Memo":
              begin
                ItemChargeAssgntNextLineNo := 0;
                FromSalesLine.Reset;
                FromSalesLine.SetRange("Document Type",FromSalesHeader."Document Type");
                FromSalesLine.SetRange("Document No.",FromSalesHeader."No.");
                if MoveNegLines then
                  FromSalesLine.SetFilter(Quantity,'<=0');
                if FromSalesLine.Find('-') then
                  repeat
                    if not ExtTxtAttachedToPosSalesLine(FromSalesHeader,MoveNegLines,FromSalesLine."Attached to Line No.") then begin
                      InitAsmCopyHandling(true);
                      ToSalesLine."Document Type" := "Document Type";
                      AsmHdrExistsForFromDocLine := FromSalesLine.AsmToOrderExists(AsmHeader);
                      if AsmHdrExistsForFromDocLine then begin
                        case ToSalesLine."Document Type" of
                          ToSalesLine."document type"::Order:
                            begin
                              QtyToAsmToOrder := FromSalesLine."Qty. to Assemble to Order";
                              QtyToAsmToOrderBase := FromSalesLine."Qty. to Asm. to Order (Base)";
                            end;
                          ToSalesLine."document type"::Quote,
                          ToSalesLine."document type"::"Blanket Order":
                            begin
                              QtyToAsmToOrder := FromSalesLine.Quantity;
                              QtyToAsmToOrderBase := FromSalesLine."Quantity (Base)";
                            end;
                        end;
                        GenerateAsmDataFromNonPosted(AsmHeader);
                      end;
                      if CopySalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine,
                           NextLineNo,LinesNotCopied,false,DeferralTypeForSalesDoc(FromDocType),CopyPostedDeferral)
                      then begin
                        if FromSalesLine.Type = FromSalesLine.Type::"Charge (Item)" then
                          CopyFromSalesDocAssgntToLine(ToSalesLine,FromSalesLine,ItemChargeAssgntNextLineNo);
                      end;
                    end;
                  until FromSalesLine.Next = 0;
              end;
            Salesdoctype::"Posted Shipment":
              begin
                FromSalesHeader.TransferFields(FromSalesShptHeader);
                FromSalesShptLine.Reset;
                FromSalesShptLine.SetRange("Document No.",FromSalesShptHeader."No.");
                if MoveNegLines then
                  FromSalesShptLine.SetFilter(Quantity,'<=0');
                CopySalesShptLinesToDoc(ToSalesHeader,FromSalesShptLine,LinesNotCopied,MissingExCostRevLink);
              end;
            Salesdoctype::"Posted Invoice":
              begin
                FromSalesHeader.TransferFields(FromSalesInvHeader);
                FromSalesInvLine.Reset;
                FromSalesInvLine.SetRange("Document No.",FromSalesInvHeader."No.");
                if MoveNegLines then
                  FromSalesInvLine.SetFilter(Quantity,'<=0');
                CopySalesInvLinesToDoc(ToSalesHeader,FromSalesInvLine,LinesNotCopied,MissingExCostRevLink);
              end;
            Salesdoctype::"Posted Return Receipt":
              begin
                FromSalesHeader.TransferFields(FromReturnRcptHeader);
                FromReturnRcptLine.Reset;
                FromReturnRcptLine.SetRange("Document No.",FromReturnRcptHeader."No.");
                if MoveNegLines then
                  FromReturnRcptLine.SetFilter(Quantity,'<=0');
                CopySalesReturnRcptLinesToDoc(ToSalesHeader,FromReturnRcptLine,LinesNotCopied,MissingExCostRevLink);
              end;
            Salesdoctype::"Posted Credit Memo":
              begin
                FromSalesHeader.TransferFields(FromSalesCrMemoHeader);
                FromSalesCrMemoLine.Reset;
                FromSalesCrMemoLine.SetRange("Document No.",FromSalesCrMemoHeader."No.");
                if MoveNegLines then
                  FromSalesCrMemoLine.SetFilter(Quantity,'<=0');
                CopySalesCrMemoLinesToDoc(ToSalesHeader,FromSalesCrMemoLine,LinesNotCopied,MissingExCostRevLink);
              end;
          end;
        end;

        if MoveNegLines then begin
          DeleteSalesLinesWithNegQty(FromSalesHeader,false);
          LinkJobPlanningLine(ToSalesHeader);
        end;
        SalesCalcSalesTaxLines(ToSalesHeader);
        if ReleaseDocument then begin
          ToSalesHeader.Status := ToSalesHeader.Status::Released;
          ReleaseSalesDocument.Reopen(ToSalesHeader);
        end else
          if (FromDocType in
              [Salesdoctype::Quote,
               Salesdoctype::"Blanket Order",
               Salesdoctype::Order,
               Salesdoctype::Invoice,
               Salesdoctype::"Return Order",
               Salesdoctype::"Credit Memo"])
             and not IncludeHeader and not RecalculateLines
          then
            if FromSalesHeader.Status = FromSalesHeader.Status::Released then begin
              ReleaseSalesDocument.Run(ToSalesHeader);
              ReleaseSalesDocument.Reopen(ToSalesHeader);
            end;
        case true of
          MissingExCostRevLink and (LinesNotCopied <> 0):
            Message(Text019 + Text020 + Text004);
          MissingExCostRevLink:
            Message(Text019);
          LinesNotCopied <> 0:
            Message(Text004);
        end;

        OnAfterCopySalesDocument(FromDocType,FromDocNo,ToSalesHeader);
    end;

    local procedure CheckCustomer(var FromSalesHeader: Record "Sales Header";var ToSalesHeader: Record "Sales Header")
    var
        Cust: Record Customer;
    begin
        if Cust.Get(FromSalesHeader."Sell-to Customer No.") then
          Cust.CheckBlockedCustOnDocs(Cust,ToSalesHeader."Document Type",false,false);
        if Cust.Get(FromSalesHeader."Bill-to Customer No.") then
          Cust.CheckBlockedCustOnDocs(Cust,ToSalesHeader."Document Type",false,false);
    end;


    procedure CopyPurchaseDocForInvoiceCancelling(FromDocNo: Code[20];var ToPurchaseHeader: Record "Purchase Header")
    begin
        CopyPurchDoc(Purchdoctype::"Posted Invoice",FromDocNo,ToPurchaseHeader);
    end;


    procedure CopyPurchDocForCrMemoCancelling(FromDocNo: Code[20];var ToPurchaseHeader: Record "Purchase Header")
    begin
        InsertCancellationLine := true;
        CopyPurchDoc(Salesdoctype::"Posted Credit Memo",FromDocNo,ToPurchaseHeader);
        InsertCancellationLine := false;
    end;


    procedure CopyPurchDoc(FromDocType: Option;FromDocNo: Code[20];var ToPurchHeader: Record "Purchase Header")
    var
        PaymentTerms: Record "Payment Terms";
        ToPurchLine: Record "Purchase Line";
        OldPurchHeader: Record "Purchase Header";
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        FromPurchRcptHeader: Record "Purch. Rcpt. Header";
        FromPurchRcptLine: Record "Purch. Rcpt. Line";
        FromPurchInvHeader: Record "Purch. Inv. Header";
        FromPurchInvLine: Record "Purch. Inv. Line";
        FromReturnShptHeader: Record "Return Shipment Header";
        FromReturnShptLine: Record "Return Shipment Line";
        FromPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        FromPurchCrMemoLine: Record "Purch. Cr. Memo Line";
        GLSetup: Record "General Ledger Setup";
        Vend: Record Vendor;
        ReleasePurchaseDocument: Codeunit "Release Purchase Document";
        NextLineNo: Integer;
        ItemChargeAssgntNextLineNo: Integer;
        LinesNotCopied: Integer;
        MissingExCostRevLink: Boolean;
        ReleaseDocument: Boolean;
    begin
        with ToPurchHeader do begin
          if not CreateToHeader then begin
            TestField(Status,Status::Open);
            if FromDocNo = '' then
              Error(Text000);
            Find;
          end;

          OnBeforeCopyPurchaseDocument(FromDocType,FromDocNo,ToPurchHeader);

          TransferOldExtLines.ClearLineNumbers;

          if not InitAndCheckPurchaseDocuments(
               FromDocType,FromDocNo,FromPurchHeader,ToPurchHeader,
               FromPurchRcptHeader,FromPurchInvHeader,FromReturnShptHeader,FromPurchCrMemoHeader)
          then
            exit;

          ToPurchLine.LockTable;

          if CreateToHeader then begin
            Insert(true);
            ToPurchLine.SetRange("Document Type","Document Type");
            ToPurchLine.SetRange("Document No.","No.");
          end else begin
            ToPurchLine.SetRange("Document Type","Document Type");
            ToPurchLine.SetRange("Document No.","No.");
            if IncludeHeader then
              if ToPurchLine.FindFirst then begin
                Commit;
                if not Confirm(DeleteLinesQst,true,"Document Type","No.") then
                  exit;
                ToPurchLine.DeleteAll(true);
              end;
          end;

          if ToPurchLine.FindLast then
            NextLineNo := ToPurchLine."Line No."
          else
            NextLineNo := 0;

          if IncludeHeader then begin
            if Vend.Get(FromPurchHeader."Buy-from Vendor No.") then
              Vend.CheckBlockedVendOnDocs(Vend,false);
            if Vend.Get(FromPurchHeader."Pay-to Vendor No.") then
              Vend.CheckBlockedVendOnDocs(Vend,false);
            OldPurchHeader := ToPurchHeader;
            case FromDocType of
              Purchdoctype::Quote,
              Purchdoctype::"Blanket Order",
              Purchdoctype::Order,
              Purchdoctype::Invoice,
              Purchdoctype::"Return Order",
              Purchdoctype::"Credit Memo":
                begin
                  TransferFields(FromPurchHeader,false);
                  "Last Receiving No." := '';
                  Status := Status::Open;
                  "IC Status" := "ic status"::New;
                  if "Document Type" <> "document type"::Order then
                    "Prepayment %" := 0;
                  if FromDocType in [Purchdoctype::Quote,Purchdoctype::"Blanket Order"] then
                    if OldPurchHeader."Posting Date" = 0D then
                      "Posting Date" := WorkDate
                    else
                      "Posting Date" := OldPurchHeader."Posting Date";
                end;
              Purchdoctype::"Posted Receipt":
                begin
                  Validate("Buy-from Vendor No.",FromPurchRcptHeader."Buy-from Vendor No.");
                  TransferFields(FromPurchRcptHeader,false);
                end;
              Purchdoctype::"Posted Invoice":
                begin
                  Validate("Buy-from Vendor No.",FromPurchInvHeader."Buy-from Vendor No.");
                  TransferFields(FromPurchInvHeader,false);
                end;
              Purchdoctype::"Posted Return Shipment":
                begin
                  Validate("Buy-from Vendor No.",FromReturnShptHeader."Buy-from Vendor No.");
                  TransferFields(FromReturnShptHeader,false);
                end;
              Purchdoctype::"Posted Credit Memo":
                begin
                  Validate("Buy-from Vendor No.",FromPurchCrMemoHeader."Buy-from Vendor No.");
                  TransferFields(FromPurchCrMemoHeader,false);
                end;
            end;
            Invoice := false;
            Receive := false;
            if Status = Status::Released then begin
              Status := Status::Open;
              ReleaseDocument := true;
            end;
            if MoveNegLines or IncludeHeader then
              Validate("Location Code");
            if MoveNegLines then
              Validate("Order Address Code");

            CopyFieldsFromOldPurchHeader(ToPurchHeader,OldPurchHeader);
            if RecalculateLines then
              CreateDim(
                Database::Vendor,"Pay-to Vendor No.",
                Database::"Salesperson/Purchaser","Purchaser Code",
                Database::Campaign,"Campaign No.",
                Database::"Responsibility Center","Responsibility Center");
            "No. Printed" := 0;
            "Applies-to Doc. Type" := "applies-to doc. type"::" ";
            "Applies-to Doc. No." := '';
            "Applies-to ID" := '';
            "Quote No." := '';
            if ((FromDocType = Purchdoctype::"Posted Invoice") and
                ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"])) or
               ((FromDocType = Purchdoctype::"Posted Credit Memo") and
                not ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]))
            then
              UpdateVendLedgEntry(ToPurchHeader,FromDocType,FromDocNo);

            if "Document Type" in ["document type"::"Blanket Order","document type"::Quote] then
              "Posting Date" := 0D;

            Correction := false;
            if "Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"] then begin
              "Expected Receipt Date" := 0D;
              GLSetup.Get;
              Correction := GLSetup."Mark Cr. Memos as Corrections";
              if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then
                PaymentTerms.Get("Payment Terms Code")
              else
                Clear(PaymentTerms);
              if not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then begin
                "Payment Terms Code" := '';
                "Payment Discount %" := 0;
                "Pmt. Discount Date" := 0D;
              end;
            end;

            if CreateToHeader then begin
              Validate("Payment Terms Code");
              Modify(true);
            end else
              Modify;
          end;

          LinesNotCopied := 0;
          case FromDocType of
            Purchdoctype::Quote,
            Purchdoctype::"Blanket Order",
            Purchdoctype::Order,
            Purchdoctype::Invoice,
            Purchdoctype::"Return Order",
            Purchdoctype::"Credit Memo":
              begin
                ItemChargeAssgntNextLineNo := 0;
                FromPurchLine.Reset;
                FromPurchLine.SetRange("Document Type",FromPurchHeader."Document Type");
                FromPurchLine.SetRange("Document No.",FromPurchHeader."No.");
                if MoveNegLines then
                  FromPurchLine.SetFilter(Quantity,'<=0');
                if FromPurchLine.Find('-') then
                  repeat
                    if not ExtTxtAttachedToPosPurchLine(FromPurchHeader,MoveNegLines,FromPurchLine."Attached to Line No.") then
                      if CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine,
                           NextLineNo,LinesNotCopied,false,DeferralTypeForPurchDoc(FromDocType),CopyPostedDeferral)
                      then begin
                        if FromPurchLine.Type = FromPurchLine.Type::"Charge (Item)" then
                          CopyFromPurchDocAssgntToLine(ToPurchLine,FromPurchLine,ItemChargeAssgntNextLineNo);
                      end;
                  until FromPurchLine.Next = 0;
              end;
            Purchdoctype::"Posted Receipt":
              begin
                FromPurchHeader.TransferFields(FromPurchRcptHeader);
                FromPurchRcptLine.Reset;
                FromPurchRcptLine.SetRange("Document No.",FromPurchRcptHeader."No.");
                if MoveNegLines then
                  FromPurchRcptLine.SetFilter(Quantity,'<=0');
                CopyPurchRcptLinesToDoc(ToPurchHeader,FromPurchRcptLine,LinesNotCopied,MissingExCostRevLink);
              end;
            Purchdoctype::"Posted Invoice":
              begin
                FromPurchHeader.TransferFields(FromPurchInvHeader);
                FromPurchInvLine.Reset;
                FromPurchInvLine.SetRange("Document No.",FromPurchInvHeader."No.");
                if MoveNegLines then
                  FromPurchInvLine.SetFilter(Quantity,'<=0');
                CopyPurchInvLinesToDoc(ToPurchHeader,FromPurchInvLine,LinesNotCopied,MissingExCostRevLink);
              end;
            Purchdoctype::"Posted Return Shipment":
              begin
                FromPurchHeader.TransferFields(FromReturnShptHeader);
                FromReturnShptLine.Reset;
                FromReturnShptLine.SetRange("Document No.",FromReturnShptHeader."No.");
                if MoveNegLines then
                  FromReturnShptLine.SetFilter(Quantity,'<=0');
                CopyPurchReturnShptLinesToDoc(ToPurchHeader,FromReturnShptLine,LinesNotCopied,MissingExCostRevLink);
              end;
            Purchdoctype::"Posted Credit Memo":
              begin
                FromPurchHeader.TransferFields(FromPurchCrMemoHeader);
                FromPurchCrMemoLine.Reset;
                FromPurchCrMemoLine.SetRange("Document No.",FromPurchCrMemoHeader."No.");
                if MoveNegLines then
                  FromPurchCrMemoLine.SetFilter(Quantity,'<=0');
                CopyPurchCrMemoLinesToDoc(ToPurchHeader,FromPurchCrMemoLine,LinesNotCopied,MissingExCostRevLink);
              end;
          end;
        end;

        if MoveNegLines then
          DeletePurchLinesWithNegQty(FromPurchHeader,false);

        if ReleaseDocument then begin
          ToPurchHeader.Status := ToPurchHeader.Status::Released;
          ReleasePurchaseDocument.Reopen(ToPurchHeader);
        end else
          if (FromDocType in
              [Purchdoctype::Quote,
               Purchdoctype::"Blanket Order",
               Purchdoctype::Order,
               Purchdoctype::Invoice,
               Purchdoctype::"Return Order",
               Purchdoctype::"Credit Memo"])
             and not IncludeHeader and not RecalculateLines
          then
            if FromPurchHeader.Status = FromPurchHeader.Status::Released then begin
              ReleasePurchaseDocument.Run(ToPurchHeader);
              ReleasePurchaseDocument.Reopen(ToPurchHeader);
            end;

        case true of
          MissingExCostRevLink and (LinesNotCopied <> 0):
            Message(Text019 + Text020 + Text004);
          MissingExCostRevLink:
            Message(Text019);
          LinesNotCopied <> 0:
            Message(Text004);
        end;

        OnAfterCopyPurchaseDocument(FromDocType,FromDocNo,ToPurchHeader);
    end;


    procedure ShowSalesDoc(ToSalesHeader: Record "Sales Header")
    begin
        with ToSalesHeader do
          case "Document Type" of
            "document type"::Order:
              Page.Run(Page::"Sales Order",ToSalesHeader);
            "document type"::Invoice:
              Page.Run(Page::"Sales Invoice",ToSalesHeader);
            "document type"::"Return Order":
              Page.Run(Page::"Sales Return Order",ToSalesHeader);
            "document type"::"Credit Memo":
              Page.Run(Page::"Sales Credit Memo",ToSalesHeader);
          end;
    end;


    procedure ShowPurchDoc(ToPurchHeader: Record "Purchase Header")
    begin
        with ToPurchHeader do
          case "Document Type" of
            "document type"::Order:
              Page.Run(Page::"Purchase Order",ToPurchHeader);
            "document type"::Invoice:
              Page.Run(Page::"Purchase Invoice",ToPurchHeader);
            "document type"::"Return Order":
              Page.Run(Page::"Purchase Return Order",ToPurchHeader);
            "document type"::"Credit Memo":
              Page.Run(Page::"Purchase Credit Memo",ToPurchHeader);
          end;
    end;


    procedure CopyFromSalesToPurchDoc(VendorNo: Code[20];FromSalesHeader: Record "Sales Header";var ToPurchHeader: Record "Purchase Header")
    var
        FromSalesLine: Record "Sales Line";
        ToPurchLine: Record "Purchase Line";
        NextLineNo: Integer;
    begin
        if VendorNo = '' then
          Error(Text011);

        with ToPurchLine do begin
          LockTable;
          ToPurchHeader.Insert(true);
          ToPurchHeader.Validate("Buy-from Vendor No.",VendorNo);
          ToPurchHeader.Modify(true);
          FromSalesLine.SetRange("Document Type",FromSalesHeader."Document Type");
          FromSalesLine.SetRange("Document No.",FromSalesHeader."No.");
          if not FromSalesLine.Find('-') then
            Error(Text012);
          repeat
            NextLineNo := NextLineNo + 10000;
            Clear(ToPurchLine);
            Init;
            "Document Type" := ToPurchHeader."Document Type";
            "Document No." := ToPurchHeader."No.";
            "Line No." := NextLineNo;
            if FromSalesLine.Type = FromSalesLine.Type::" " then
              Description := FromSalesLine.Description
            else begin
              TransfldsFromSalesToPurchLine(FromSalesLine,ToPurchLine);
              if (Type = Type::Item) and (Quantity <> 0) then
                CopyItemTrackingEntries(
                  FromSalesLine,ToPurchLine,FromSalesHeader."Prices Including VAT",
                  ToPurchHeader."Prices Including VAT");
            end;
            Insert(true);
          until FromSalesLine.Next = 0;
        end;
    end;


    procedure TransfldsFromSalesToPurchLine(var FromSalesLine: Record "Sales Line";var ToPurchLine: Record "Purchase Line")
    begin
        with ToPurchLine do begin
          Validate(Type,FromSalesLine.Type);
          Validate("No.",FromSalesLine."No.");
          Validate("Variant Code",FromSalesLine."Variant Code");
          Validate("Location Code",FromSalesLine."Location Code");
          Validate("Unit of Measure Code",FromSalesLine."Unit of Measure Code");
          if (Type = Type::Item) and ("No." <> '') then
            UpdateUOMQtyPerStockQty;
          "Expected Receipt Date" := FromSalesLine."Shipment Date";
          "Bin Code" := FromSalesLine."Bin Code";
          if (FromSalesLine."Document Type" = FromSalesLine."document type"::"Return Order") and
             ("Document Type" = "document type"::"Return Order")
          then
            Validate(Quantity,FromSalesLine.Quantity)
          else
            Validate(Quantity,FromSalesLine."Outstanding Quantity");
          Validate("Return Reason Code",FromSalesLine."Return Reason Code");
          Validate("Direct Unit Cost");
          Description := FromSalesLine.Description;
          "Description 2" := FromSalesLine."Description 2";
        end;
    end;

    local procedure DeleteSalesLinesWithNegQty(FromSalesHeader: Record "Sales Header";OnlyTest: Boolean)
    var
        FromSalesLine: Record "Sales Line";
    begin
        with FromSalesLine do begin
          SetRange("Document Type",FromSalesHeader."Document Type");
          SetRange("Document No.",FromSalesHeader."No.");
          SetFilter(Quantity,'<0');
          if OnlyTest then begin
            if not Find('-') then
              Error(Text008);
            repeat
              TestField("Shipment No.",'');
              TestField("Return Receipt No.",'');
              TestField("Quantity Shipped",0);
              TestField("Quantity Invoiced",0);
            until Next = 0;
          end else
            DeleteAll(true);
        end;
    end;

    local procedure DeletePurchLinesWithNegQty(FromPurchHeader: Record "Purchase Header";OnlyTest: Boolean)
    var
        FromPurchLine: Record "Purchase Line";
    begin
        with FromPurchLine do begin
          SetRange("Document Type",FromPurchHeader."Document Type");
          SetRange("Document No.",FromPurchHeader."No.");
          SetFilter(Quantity,'<0');
          if OnlyTest then begin
            if not Find('-') then
              Error(Text010);
            repeat
              TestField("Receipt No.",'');
              TestField("Return Shipment No.",'');
              TestField("Quantity Received",0);
              TestField("Quantity Invoiced",0);
            until Next = 0;
          end else
            DeleteAll(true);
        end;
    end;

    local procedure CopySalesLine(var ToSalesHeader: Record "Sales Header";var ToSalesLine: Record "Sales Line";var FromSalesHeader: Record "Sales Header";var FromSalesLine: Record "Sales Line";var NextLineNo: Integer;var LinesNotCopied: Integer;RecalculateAmount: Boolean;FromSalesDocType: Option;var CopyPostedDeferral: Boolean): Boolean
    var
        ToSalesLine2: Record "Sales Line";
        RoundingLineInserted: Boolean;
        CopyThisLine: Boolean;
        InvDiscountAmount: Decimal;
    begin
        CopyThisLine := true;

        CheckSalesRounding(FromSalesLine,RoundingLineInserted);

        if ((ToSalesHeader."Language Code" <> FromSalesHeader."Language Code") or RecalculateLines) and
           (FromSalesLine."Attached to Line No." <> 0) or
           FromSalesLine."Prepayment Line" or RoundingLineInserted
        then
          exit(false);
        ToSalesLine.SetSalesHeader(ToSalesHeader);
        if RecalculateLines and not FromSalesLine."System-Created Entry" then
          ToSalesLine.Init
        else begin
          ToSalesLine := FromSalesLine;
          ToSalesLine."Returns Deferral Start Date" := 0D;
          if ToSalesHeader."Document Type" in [ToSalesHeader."document type"::Quote,ToSalesHeader."document type"::"Blanket Order"] then
            ToSalesLine."Deferral Code" := '';
          if MoveNegLines and (ToSalesLine.Type <> ToSalesLine.Type::" ") then begin
            ToSalesLine.Amount := -ToSalesLine.Amount;
            ToSalesLine."Amount Including VAT" := -ToSalesLine."Amount Including VAT";
          end
        end;

        if (not RecalculateLines) and (ToSalesLine."No." <> '') then
          ToSalesLine.TestField("VAT Bus. Posting Group",ToSalesHeader."VAT Bus. Posting Group");

        NextLineNo := NextLineNo + 10000;
        ToSalesLine."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine."Document No." := ToSalesHeader."No.";
        ToSalesLine."Line No." := NextLineNo;
        if (ToSalesLine.Type <> ToSalesLine.Type::" ") and
           (ToSalesLine."Document Type" in [ToSalesLine."document type"::"Return Order",ToSalesLine."document type"::"Credit Memo"])
        then begin
          ToSalesLine."Job Contract Entry No." := 0;
          if (ToSalesLine.Amount = 0) or
             (ToSalesHeader."Prices Including VAT" <> FromSalesHeader."Prices Including VAT") or
             (ToSalesHeader."Currency Factor" <> FromSalesHeader."Currency Factor")
          then begin
            InvDiscountAmount := ToSalesLine."Inv. Discount Amount";
            ToSalesLine.Validate("Line Discount %");
            ToSalesLine.Validate("Inv. Discount Amount",InvDiscountAmount);
          end;
        end;
        ToSalesLine.Validate("Currency Code",FromSalesHeader."Currency Code");

        UpdateSalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,
          FromSalesLine,CopyThisLine,RecalculateAmount,FromSalesDocType,CopyPostedDeferral);
        ToSalesLine.CheckLocationOnWMS;

        if ExactCostRevMandatory and
           (FromSalesLine.Type = FromSalesLine.Type::Item) and
           (FromSalesLine."Appl.-from Item Entry" <> 0) and
           not MoveNegLines
        then begin
          if RecalculateAmount then begin
            ToSalesLine.Validate("Unit Price",FromSalesLine."Unit Price");
            ToSalesLine.Validate("Line Discount %",FromSalesLine."Line Discount %");
            ToSalesLine.Validate(
              "Line Discount Amount",
              ROUND(FromSalesLine."Line Discount Amount",Currency."Amount Rounding Precision"));
            ToSalesLine.Validate(
              "Inv. Discount Amount",
              ROUND(FromSalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
          end;
          ToSalesLine.Validate("Appl.-from Item Entry",FromSalesLine."Appl.-from Item Entry");
          if not CreateToHeader then
            if ToSalesLine."Shipment Date" = 0D then begin
              if ToSalesHeader."Shipment Date" <> 0D then
                ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date"
              else
                ToSalesLine."Shipment Date" := WorkDate;
            end;
        end;

        if MoveNegLines and (ToSalesLine.Type <> ToSalesLine.Type::" ") then begin
          ToSalesLine.Validate(Quantity,-FromSalesLine.Quantity);
          ToSalesLine."Appl.-to Item Entry" := FromSalesLine."Appl.-to Item Entry";
          ToSalesLine."Appl.-from Item Entry" := FromSalesLine."Appl.-from Item Entry";
          ToSalesLine."Job No." := FromSalesLine."Job No.";
          ToSalesLine."Job Task No." := FromSalesLine."Job Task No.";
          ToSalesLine."Job Contract Entry No." := FromSalesLine."Job Contract Entry No.";
        end;

        if (ToSalesHeader."Language Code" <> FromSalesHeader."Language Code") or RecalculateLines then begin
          if TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine,false) then begin
            TransferExtendedText.InsertSalesExtText(ToSalesLine);
            ToSalesLine2.SetRange("Document Type",ToSalesLine."Document Type");
            ToSalesLine2.SetRange("Document No.",ToSalesLine."Document No.");
            ToSalesLine2.FindLast;
            NextLineNo := ToSalesLine2."Line No.";
          end;
        end else
          ToSalesLine."Attached to Line No." :=
            TransferOldExtLines.TransferExtendedText(FromSalesLine."Line No.",NextLineNo,FromSalesLine."Attached to Line No.");

        if not RecalculateLines then begin
          ToSalesLine."Dimension Set ID" := FromSalesLine."Dimension Set ID";
          ToSalesLine."Shortcut Dimension 1 Code" := FromSalesLine."Shortcut Dimension 1 Code";
          ToSalesLine."Shortcut Dimension 2 Code" := FromSalesLine."Shortcut Dimension 2 Code";
        end;

        if CopyThisLine then begin
          ToSalesLine.Insert;
          HandleAsmAttachedToSalesLine(ToSalesLine);
          if ToSalesLine.Reserve = ToSalesLine.Reserve::Always then
            ToSalesLine.AutoReserve;
        end else
          LinesNotCopied := LinesNotCopied + 1;
        exit(true);
    end;

    local procedure UpdateSalesLine(var ToSalesHeader: Record "Sales Header";var ToSalesLine: Record "Sales Line";var FromSalesHeader: Record "Sales Header";var FromSalesLine: Record "Sales Line";var CopyThisLine: Boolean;RecalculateAmount: Boolean;FromSalesDocType: Option;var CopyPostedDeferral: Boolean)
    var
        GLAcc: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        DeferralDocType: Integer;
    begin
        CopyPostedDeferral := false;
        DeferralDocType := DeferralUtilities.GetSalesDeferralDocType;
        if RecalculateLines and not FromSalesLine."System-Created Entry" then begin
          ToSalesLine.Validate(Type,FromSalesLine.Type);
          ToSalesLine.Description := FromSalesLine.Description;
          ToSalesLine.Validate("Description 2",FromSalesLine."Description 2");
          if (FromSalesLine.Type <> 0) and (FromSalesLine."No." <> '') then begin
            if ToSalesLine.Type = ToSalesLine.Type::"G/L Account" then begin
              ToSalesLine."No." := FromSalesLine."No.";
              if GLAcc."No." <> FromSalesLine."No." then
                GLAcc.Get(FromSalesLine."No.");
              CopyThisLine := GLAcc."Direct Posting";
              if CopyThisLine then
                ToSalesLine.Validate("No.",FromSalesLine."No.");
            end else
              ToSalesLine.Validate("No.",FromSalesLine."No.");
            ToSalesLine.Validate("Variant Code",FromSalesLine."Variant Code");
            ToSalesLine.Validate("Location Code",FromSalesLine."Location Code");
            ToSalesLine.Validate("Unit of Measure",FromSalesLine."Unit of Measure");
            ToSalesLine.Validate("Unit of Measure Code",FromSalesLine."Unit of Measure Code");
            ToSalesLine.Validate(Quantity,FromSalesLine.Quantity);

            if not (FromSalesLine.Type in [FromSalesLine.Type::Item,FromSalesLine.Type::Resource]) then begin
              if (FromSalesHeader."Currency Code" <> ToSalesHeader."Currency Code") or
                 (FromSalesHeader."Prices Including VAT" <> ToSalesHeader."Prices Including VAT")
              then begin
                ToSalesLine."Unit Price" := 0;
                ToSalesLine."Line Discount %" := 0;
              end else begin
                ToSalesLine.Validate("Unit Price",FromSalesLine."Unit Price");
                ToSalesLine.Validate("Line Discount %",FromSalesLine."Line Discount %");
              end;
              if ToSalesLine.Quantity <> 0 then
                ToSalesLine.Validate("Line Discount Amount",FromSalesLine."Line Discount Amount");
            end;
            ToSalesLine.Validate("Work Type Code",FromSalesLine."Work Type Code");
            if (ToSalesLine."Document Type" = ToSalesLine."document type"::Order) and
               (FromSalesLine."Purchasing Code" <> '')
            then
              ToSalesLine.Validate("Purchasing Code",FromSalesLine."Purchasing Code");
          end;
          if (FromSalesLine.Type = FromSalesLine.Type::" ") and (FromSalesLine."No." <> '') then
            ToSalesLine.Validate("No.",FromSalesLine."No.");
          if IsDeferralToBeCopied(DeferralDocType,ToSalesLine."Document Type",FromSalesDocType) then
            ToSalesLine.Validate("Deferral Code",FromSalesLine."Deferral Code");
        end else begin
          SetDefaultValuesToSalesLine(ToSalesLine,ToSalesHeader,FromSalesLine."VAT Difference");
          if IsDeferralToBeCopied(DeferralDocType,ToSalesLine."Document Type",FromSalesDocType) then
            if IsDeferralPosted(DeferralDocType,FromSalesDocType) then
              CopyPostedDeferral := true
            else
              ToSalesLine."Returns Deferral Start Date" :=
                CopyDeferrals(DeferralDocType,FromSalesLine."Document Type",FromSalesLine."Document No.",
                  FromSalesLine."Line No.",ToSalesLine."Document Type",ToSalesLine."Document No.",ToSalesLine."Line No.")
          else
            if IsDeferralToBeDefaulted(DeferralDocType,ToSalesLine."Document Type",FromSalesDocType) then
              InitSalesDeferralCode(ToSalesLine);

          if ToSalesLine."Document Type" <> ToSalesLine."document type"::Order then begin
            ToSalesLine."Drop Shipment" := false;
            ToSalesLine."Special Order" := false;
          end;
          if RecalculateAmount and (FromSalesLine."Appl.-from Item Entry" = 0) then begin
            if (ToSalesLine.Type <> ToSalesLine.Type::" ") and (ToSalesLine."No." <> '') then begin
              ToSalesLine.Validate("Line Discount %",FromSalesLine."Line Discount %");
              ToSalesLine.Validate(
                "Inv. Discount Amount",ROUND(FromSalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
            end;
            ToSalesLine.Validate("Unit Cost (LCY)",FromSalesLine."Unit Cost (LCY)");
          end;
          if VATPostingSetup.Get(ToSalesLine."VAT Bus. Posting Group",ToSalesLine."VAT Prod. Posting Group") then
            ToSalesLine."VAT Identifier" := VATPostingSetup."VAT Identifier";

          ToSalesLine.UpdateWithWarehouseShip;
          if (ToSalesLine.Type = ToSalesLine.Type::Item) and (ToSalesLine."No." <> '') then begin
            GetItem(ToSalesLine."No.");
            if (Item."Costing Method" = Item."costing method"::Standard) and not ToSalesLine.IsShipment then
              ToSalesLine.GetUnitCost;

            if Item.Reserve = Item.Reserve::Optional then
              ToSalesLine.Reserve := ToSalesHeader.Reserve
            else
              ToSalesLine.Reserve := Item.Reserve;
            if ToSalesLine.Reserve = ToSalesLine.Reserve::Always then
              if ToSalesHeader."Shipment Date" <> 0D then
                ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date"
              else
                ToSalesLine."Shipment Date" := WorkDate;
          end;
        end;
    end;

    local procedure HandleAsmAttachedToSalesLine(var ToSalesLine: Record "Sales Line")
    var
        Item: Record Item;
    begin
        with ToSalesLine do begin
          if Type <> Type::Item then
            exit;
          if not ("Document Type" in ["document type"::Quote,"document type"::Order,"document type"::"Blanket Order"]) then
            exit;
        end;
        if AsmHdrExistsForFromDocLine then begin
          ToSalesLine."Qty. to Assemble to Order" := QtyToAsmToOrder;
          ToSalesLine."Qty. to Asm. to Order (Base)" := QtyToAsmToOrderBase;
          ToSalesLine.Modify;
          CopyAsmOrderToAsmOrder(TempAsmHeader,TempAsmLine,ToSalesLine,GetAsmOrderType(ToSalesLine."Document Type"),'',true);
        end else begin
          Item.Get(ToSalesLine."No.");
          if (Item."Assembly Policy" = Item."assembly policy"::"Assemble-to-Order") and
             (Item."Replenishment System" = Item."replenishment system"::Assembly)
          then begin
            ToSalesLine.Validate("Qty. to Assemble to Order",ToSalesLine.Quantity);
            ToSalesLine.Modify;
          end;
        end;
    end;

    local procedure CopyPurchLine(var ToPurchHeader: Record "Purchase Header";var ToPurchLine: Record "Purchase Line";var FromPurchHeader: Record "Purchase Header";var FromPurchLine: Record "Purchase Line";var NextLineNo: Integer;var LinesNotCopied: Integer;RecalculateAmount: Boolean;FromPurchDocType: Option;var CopyPostedDeferral: Boolean): Boolean
    var
        ToPurchLine2: Record "Purchase Line";
        RoundingLineInserted: Boolean;
        CopyThisLine: Boolean;
        InvDiscountAmount: Decimal;
    begin
        CopyThisLine := true;

        CheckPurchRounding(FromPurchLine,RoundingLineInserted);

        if ((ToPurchHeader."Language Code" <> FromPurchHeader."Language Code") or RecalculateLines) and
           (FromPurchLine."Attached to Line No." <> 0) or
           FromPurchLine."Prepayment Line" or RoundingLineInserted
        then
          exit(false);

        if RecalculateLines and not FromPurchLine."System-Created Entry" then
          ToPurchLine.Init
        else begin
          ToPurchLine := FromPurchLine;
          ToPurchLine."Returns Deferral Start Date" := 0D;
          if ToPurchHeader."Document Type" in [ToPurchHeader."document type"::Quote,ToPurchHeader."document type"::"Blanket Order"] then
            ToPurchLine."Deferral Code" := '';
          if MoveNegLines and (ToPurchLine.Type <> ToPurchLine.Type::" ") then begin
            ToPurchLine.Amount := -ToPurchLine.Amount;
            ToPurchLine."Amount Including VAT" := -ToPurchLine."Amount Including VAT";
          end
        end;

        if (not RecalculateLines) and (ToPurchLine."No." <> '') then
          ToPurchLine.TestField("VAT Bus. Posting Group",ToPurchHeader."VAT Bus. Posting Group");

        NextLineNo := NextLineNo + 10000;
        ToPurchLine."Document Type" := ToPurchHeader."Document Type";
        ToPurchLine."Document No." := ToPurchHeader."No.";
        ToPurchLine."Line No." := NextLineNo;
        ToPurchLine.Validate("Currency Code",FromPurchHeader."Currency Code");
        if (ToPurchLine.Type <> ToPurchLine.Type::" ") and
           ((ToPurchLine.Amount = 0) or
            (ToPurchHeader."Prices Including VAT" <> FromPurchHeader."Prices Including VAT") or
            (ToPurchHeader."Currency Factor" <> FromPurchHeader."Currency Factor"))
        then begin
          InvDiscountAmount := ToPurchLine."Inv. Discount Amount";
          ToPurchLine.Validate("Line Discount %");
          ToPurchLine.Validate("Inv. Discount Amount",InvDiscountAmount);
        end;

        UpdatePurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine,
          CopyThisLine,RecalculateAmount,FromPurchDocType,CopyPostedDeferral);
        ToPurchLine.CheckLocationOnWMS;

        if ExactCostRevMandatory and
           (FromPurchLine.Type = FromPurchLine.Type::Item) and
           (FromPurchLine."Appl.-to Item Entry" <> 0) and
           not MoveNegLines
        then begin
          if RecalculateAmount then begin
            ToPurchLine.Validate("Direct Unit Cost",FromPurchLine."Direct Unit Cost");
            ToPurchLine.Validate("Line Discount %",FromPurchLine."Line Discount %");
            ToPurchLine.Validate(
              "Line Discount Amount",
              ROUND(FromPurchLine."Line Discount Amount",Currency."Amount Rounding Precision"));
            ToPurchLine.Validate(
              "Inv. Discount Amount",
              ROUND(FromPurchLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
          end;
          ToPurchLine.Validate("Appl.-to Item Entry",FromPurchLine."Appl.-to Item Entry");
          if not CreateToHeader then
            if ToPurchLine."Expected Receipt Date" = 0D then begin
              if ToPurchHeader."Expected Receipt Date" <> 0D then
                ToPurchLine."Expected Receipt Date" := ToPurchHeader."Expected Receipt Date"
              else
                ToPurchLine."Expected Receipt Date" := WorkDate;
            end;
        end;

        if MoveNegLines and (ToPurchLine.Type <> ToPurchLine.Type::" ") then begin
          ToPurchLine.Validate(Quantity,-FromPurchLine.Quantity);
          ToPurchLine."Appl.-to Item Entry" := FromPurchLine."Appl.-to Item Entry"
        end;

        if (ToPurchHeader."Language Code" <> FromPurchHeader."Language Code") or RecalculateLines then begin
          if TransferExtendedText.PurchCheckIfAnyExtText(ToPurchLine,false) then begin
            TransferExtendedText.InsertPurchExtText(ToPurchLine);
            ToPurchLine2.SetRange("Document Type",ToPurchLine."Document Type");
            ToPurchLine2.SetRange("Document No.",ToPurchLine."Document No.");
            ToPurchLine2.FindLast;
            NextLineNo := ToPurchLine2."Line No.";
          end;
        end else
          ToPurchLine."Attached to Line No." :=
            TransferOldExtLines.TransferExtendedText(
              FromPurchLine."Line No.",
              NextLineNo,
              FromPurchLine."Attached to Line No.");

        ToPurchLine.Validate("Job No.",FromPurchLine."Job No.");
        ToPurchLine.Validate("Job Task No.",FromPurchLine."Job Task No.");
        ToPurchLine.Validate("Job Line Type",FromPurchLine."Job Line Type");

        if not RecalculateLines then begin
          ToPurchLine."Dimension Set ID" := FromPurchLine."Dimension Set ID";
          ToPurchLine."Shortcut Dimension 1 Code" := FromPurchLine."Shortcut Dimension 1 Code";
          ToPurchLine."Shortcut Dimension 2 Code" := FromPurchLine."Shortcut Dimension 2 Code";
        end;

        if CopyThisLine then
          ToPurchLine.Insert
        else
          LinesNotCopied := LinesNotCopied + 1;
        exit(true);
    end;

    local procedure UpdatePurchLine(var ToPurchHeader: Record "Purchase Header";var ToPurchLine: Record "Purchase Line";var FromPurchHeader: Record "Purchase Header";var FromPurchLine: Record "Purchase Line";var CopyThisLine: Boolean;RecalculateAmount: Boolean;FromPurchDocType: Option;var CopyPostedDeferral: Boolean)
    var
        GLAcc: Record "G/L Account";
        VATPostingSetup: Record "VAT Posting Setup";
        DeferralDocType: Integer;
    begin
        CopyPostedDeferral := false;
        DeferralDocType := DeferralUtilities.GetPurchDeferralDocType;
        if RecalculateLines and not FromPurchLine."System-Created Entry" then begin
          ToPurchLine.Validate(Type,FromPurchLine.Type);
          ToPurchLine.Description := FromPurchLine.Description;
          ToPurchLine.Validate("Description 2",FromPurchLine."Description 2");
          if (FromPurchLine.Type <> 0) and (FromPurchLine."No." <> '') then begin
            if ToPurchLine.Type = ToPurchLine.Type::"G/L Account" then begin
              ToPurchLine."No." := FromPurchLine."No.";
              if GLAcc."No." <> FromPurchLine."No." then
                GLAcc.Get(FromPurchLine."No.");
              CopyThisLine := GLAcc."Direct Posting";
              if CopyThisLine then
                ToPurchLine.Validate("No.",FromPurchLine."No.");
            end else
              ToPurchLine.Validate("No.",FromPurchLine."No.");
            ToPurchLine.Validate("Variant Code",FromPurchLine."Variant Code");
            ToPurchLine.Validate("Location Code",FromPurchLine."Location Code");
            ToPurchLine.Validate("Unit of Measure",FromPurchLine."Unit of Measure");
            ToPurchLine.Validate("Unit of Measure Code",FromPurchLine."Unit of Measure Code");
            ToPurchLine.Validate(Quantity,FromPurchLine.Quantity);
            if FromPurchLine.Type <> FromPurchLine.Type::Item then begin
              ToPurchHeader.TestField("Currency Code",FromPurchHeader."Currency Code");
              ToPurchLine.Validate("Direct Unit Cost",FromPurchLine."Direct Unit Cost");
              ToPurchLine.Validate("Line Discount %",FromPurchLine."Line Discount %");
              if ToPurchLine.Quantity <> 0 then
                ToPurchLine.Validate("Line Discount Amount",FromPurchLine."Line Discount Amount");
            end;
            if (ToPurchLine."Document Type" = ToPurchLine."document type"::Order) and
               (FromPurchLine."Purchasing Code" <> '') and not FromPurchLine."Drop Shipment" and
               not FromPurchLine."Special Order"
            then
              ToPurchLine.Validate("Purchasing Code",FromPurchLine."Purchasing Code");
          end;
          if (FromPurchLine.Type = FromPurchLine.Type::" ") and (FromPurchLine."No." <> '') then
            ToPurchLine.Validate("No.",FromPurchLine."No.");
          if IsDeferralToBeCopied(DeferralDocType,ToPurchLine."Document Type",FromPurchDocType) then
            ToPurchLine.Validate("Deferral Code",FromPurchLine."Deferral Code");
        end else begin
          SetDefaultValuesToPurchLine(ToPurchLine,ToPurchHeader,FromPurchLine."VAT Difference");
          if IsDeferralToBeCopied(DeferralDocType,ToPurchLine."Document Type",FromPurchDocType) then
            if IsDeferralPosted(DeferralDocType,FromPurchDocType) then
              CopyPostedDeferral := true
            else
              ToPurchLine."Returns Deferral Start Date" :=
                CopyDeferrals(DeferralDocType,FromPurchLine."Document Type",FromPurchLine."Document No.",
                  FromPurchLine."Line No.",ToPurchLine."Document Type",ToPurchLine."Document No.",ToPurchLine."Line No.")
          else
            if IsDeferralToBeDefaulted(DeferralDocType,ToPurchLine."Document Type",FromPurchDocType) then
              InitPurchDeferralCode(ToPurchLine);

          if FromPurchLine."Drop Shipment" or FromPurchLine."Special Order" then
            ToPurchLine."Purchasing Code" := '';
          ToPurchLine."Drop Shipment" := false;
          ToPurchLine."Special Order" := false;
          if VATPostingSetup.Get(ToPurchLine."VAT Bus. Posting Group",ToPurchLine."VAT Prod. Posting Group") then
            ToPurchLine."VAT Identifier" := VATPostingSetup."VAT Identifier";

          CopyDocLines(RecalculateAmount,ToPurchLine,FromPurchLine);

          ToPurchLine.UpdateWithWarehouseReceive;
          ToPurchLine."Pay-to Vendor No." := ToPurchHeader."Pay-to Vendor No.";
        end;
    end;

    local procedure CheckPurchRounding(FromPurchLine: Record "Purchase Line";var RoundingLineInserted: Boolean)
    var
        PurchSetup: Record "Purchases & Payables Setup";
        Vendor: Record Vendor;
        VendorPostingGroup: Record "Vendor Posting Group";
    begin
        if (FromPurchLine.Type <> FromPurchLine.Type::"G/L Account") or (FromPurchLine."No." = '') then
          exit;
        PurchSetup.Get;
        if PurchSetup."Invoice Rounding" then begin
          Vendor.Get(FromPurchLine."Pay-to Vendor No.");
          VendorPostingGroup.Get(Vendor."Vendor Posting Group");
          VendorPostingGroup.TestField("Invoice Rounding Account");
          RoundingLineInserted := FromPurchLine."No." = VendorPostingGroup."Invoice Rounding Account";
        end;
    end;

    local procedure CheckSalesRounding(FromSalesLine: Record "Sales Line";var RoundingLineInserted: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        Customer: Record Customer;
        CustomerPostingGroup: Record "Customer Posting Group";
    begin
        if (FromSalesLine.Type <> FromSalesLine.Type::"G/L Account") or (FromSalesLine."No." = '') then
          exit;
        SalesSetup.Get;
        if SalesSetup."Invoice Rounding" then begin
          Customer.Get(FromSalesLine."Bill-to Customer No.");
          CustomerPostingGroup.Get(Customer."Customer Posting Group");
          CustomerPostingGroup.TestField("Invoice Rounding Account");
          RoundingLineInserted := FromSalesLine."No." = CustomerPostingGroup."Invoice Rounding Account";
        end;
    end;

    local procedure CopyFromSalesDocAssgntToLine(var ToSalesLine: Record "Sales Line";FromSalesLine: Record "Sales Line";var ItemChargeAssgntNextLineNo: Integer)
    var
        FromItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        ToItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
    begin
        with FromSalesLine do begin
          FromItemChargeAssgntSales.Reset;
          FromItemChargeAssgntSales.SetRange("Document Type","Document Type");
          FromItemChargeAssgntSales.SetRange("Document No.","Document No.");
          FromItemChargeAssgntSales.SetRange("Document Line No.","Line No.");
          FromItemChargeAssgntSales.SetFilter(
            "Applies-to Doc. Type",'<>%1',"Document Type");
          if FromItemChargeAssgntSales.Find('-') then
            repeat
              ToItemChargeAssgntSales.Copy(FromItemChargeAssgntSales);
              ToItemChargeAssgntSales."Document Type" := ToSalesLine."Document Type";
              ToItemChargeAssgntSales."Document No." := ToSalesLine."Document No.";
              ToItemChargeAssgntSales."Document Line No." := ToSalesLine."Line No.";
              AssignItemChargeSales.InsertItemChargeAssgnt(
                ToItemChargeAssgntSales,ToItemChargeAssgntSales."Applies-to Doc. Type",
                ToItemChargeAssgntSales."Applies-to Doc. No.",ToItemChargeAssgntSales."Applies-to Doc. Line No.",
                ToItemChargeAssgntSales."Item No.",ToItemChargeAssgntSales.Description,ItemChargeAssgntNextLineNo);
            until FromItemChargeAssgntSales.Next = 0;
        end;
    end;

    local procedure CopyFromPurchDocAssgntToLine(var ToPurchLine: Record "Purchase Line";FromPurchLine: Record "Purchase Line";var ItemChargeAssgntNextLineNo: Integer)
    var
        FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        ToItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
    begin
        with FromPurchLine do begin
          FromItemChargeAssgntPurch.Reset;
          FromItemChargeAssgntPurch.SetRange("Document Type","Document Type");
          FromItemChargeAssgntPurch.SetRange("Document No.","Document No.");
          FromItemChargeAssgntPurch.SetRange("Document Line No.","Line No.");
          FromItemChargeAssgntPurch.SetFilter(
            "Applies-to Doc. Type",'<>%1',"Document Type");
          if FromItemChargeAssgntPurch.Find('-') then
            repeat
              ToItemChargeAssgntPurch.Copy(FromItemChargeAssgntPurch);
              ToItemChargeAssgntPurch."Document Type" := ToPurchLine."Document Type";
              ToItemChargeAssgntPurch."Document No." := ToPurchLine."Document No.";
              ToItemChargeAssgntPurch."Document Line No." := ToPurchLine."Line No.";
              AssignItemChargePurch.InsertItemChargeAssgnt(
                ToItemChargeAssgntPurch,ToItemChargeAssgntPurch."Applies-to Doc. Type",
                ToItemChargeAssgntPurch."Applies-to Doc. No.",ToItemChargeAssgntPurch."Applies-to Doc. Line No.",
                ToItemChargeAssgntPurch."Item No.",ToItemChargeAssgntPurch.Description,ItemChargeAssgntNextLineNo);
            until FromItemChargeAssgntPurch.Next = 0;
        end;
    end;

    local procedure WarnSalesInvoicePmtDisc(var ToSalesHeader: Record "Sales Header";var FromSalesHeader: Record "Sales Header";FromDocType: Option;FromDocNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if HideDialog then
          exit;

        if IncludeHeader and
           (ToSalesHeader."Document Type" in
            [ToSalesHeader."document type"::"Return Order",ToSalesHeader."document type"::"Credit Memo"])
        then begin
          CustLedgEntry.SetCurrentkey("Document No.");
          CustLedgEntry.SetRange("Document Type",FromSalesHeader."document type"::Invoice);
          CustLedgEntry.SetRange("Document No.",FromDocNo);
          if CustLedgEntry.FindFirst then begin
            if (CustLedgEntry."Pmt. Disc. Given (LCY)" <> 0) and
               (CustLedgEntry."Journal Batch Name" = '')
            then
              Message(Text006,SelectStr(FromDocType,Text007),FromDocNo);
          end;
        end;

        if IncludeHeader and
           (ToSalesHeader."Document Type" in
            [ToSalesHeader."document type"::Invoice,ToSalesHeader."document type"::Order,
             ToSalesHeader."document type"::Quote,ToSalesHeader."document type"::"Blanket Order"]) and
           (FromDocType = 9)
        then begin
          CustLedgEntry.SetCurrentkey("Document No.");
          CustLedgEntry.SetRange("Document Type",FromSalesHeader."document type"::"Credit Memo");
          CustLedgEntry.SetRange("Document No.",FromDocNo);
          if CustLedgEntry.FindFirst then begin
            if (CustLedgEntry."Pmt. Disc. Given (LCY)" <> 0) and
               (CustLedgEntry."Journal Batch Name" = '')
            then
              Message(Text006,SelectStr(FromDocType - 1,Text007),FromDocNo);
          end;
        end;
    end;

    local procedure WarnPurchInvoicePmtDisc(var ToPurchHeader: Record "Purchase Header";var FromPurchHeader: Record "Purchase Header";FromDocType: Option;FromDocNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        if HideDialog then
          exit;

        if IncludeHeader and
           (ToPurchHeader."Document Type" in
            [ToPurchHeader."document type"::"Return Order",ToPurchHeader."document type"::"Credit Memo"])
        then begin
          VendLedgEntry.SetCurrentkey("Document No.");
          VendLedgEntry.SetRange("Document Type",FromPurchHeader."document type"::Invoice);
          VendLedgEntry.SetRange("Document No.",FromDocNo);
          if VendLedgEntry.FindFirst then begin
            if (VendLedgEntry."Pmt. Disc. Rcd.(LCY)" <> 0) and
               (VendLedgEntry."Journal Batch Name" = '')
            then
              Message(Text009,SelectStr(FromDocType,Text007),FromDocNo);
          end;
        end;

        if IncludeHeader and
           (ToPurchHeader."Document Type" in
            [ToPurchHeader."document type"::Invoice,ToPurchHeader."document type"::Order,
             ToPurchHeader."document type"::Quote,ToPurchHeader."document type"::"Blanket Order"]) and
           (FromDocType = 9)
        then begin
          VendLedgEntry.SetCurrentkey("Document No.");
          VendLedgEntry.SetRange("Document Type",FromPurchHeader."document type"::"Credit Memo");
          VendLedgEntry.SetRange("Document No.",FromDocNo);
          if VendLedgEntry.FindFirst then begin
            if (VendLedgEntry."Pmt. Disc. Rcd.(LCY)" <> 0) and
               (VendLedgEntry."Journal Batch Name" = '')
            then
              Message(Text006,SelectStr(FromDocType - 1,Text007),FromDocNo);
          end;
        end;
    end;

    local procedure CheckCopyFromSalesHeaderAvail(FromSalesHeader: Record "Sales Header";ToSalesHeader: Record "Sales Header")
    var
        FromSalesLine: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
    begin
        with ToSalesHeader do
          if "Document Type" in ["document type"::Order,"document type"::Invoice] then begin
            FromSalesLine.SetRange("Document Type",FromSalesHeader."Document Type");
            FromSalesLine.SetRange("Document No.",FromSalesHeader."No.");
            FromSalesLine.SetRange(Type,FromSalesLine.Type::Item);
            FromSalesLine.SetFilter("No.",'<>%1','');
            if FromSalesLine.Find('-') then
              repeat
                if FromSalesLine.Quantity > 0 then begin
                  ToSalesLine."No." := FromSalesLine."No.";
                  ToSalesLine."Variant Code" := FromSalesLine."Variant Code";
                  ToSalesLine."Location Code" := FromSalesLine."Location Code";
                  ToSalesLine."Bin Code" := FromSalesLine."Bin Code";
                  ToSalesLine."Unit of Measure Code" := FromSalesLine."Unit of Measure Code";
                  ToSalesLine."Qty. per Unit of Measure" := FromSalesLine."Qty. per Unit of Measure";
                  ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity;
                  if "Document Type" = "document type"::Order then
                    ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity - FromSalesLine."Qty. to Assemble to Order";
                  ToSalesLine."Qty. to Assemble to Order" := 0;
                  ToSalesLine."Drop Shipment" := FromSalesLine."Drop Shipment";
                  CheckItemAvailable(ToSalesHeader,ToSalesLine);

                  if "Document Type" = "document type"::Order then begin
                    ToSalesLine."Outstanding Quantity" := FromSalesLine.Quantity;
                    ToSalesLine."Qty. to Assemble to Order" := FromSalesLine."Qty. to Assemble to Order";
                    CheckATOItemAvailable(FromSalesLine,ToSalesLine);
                  end;
                end;
              until FromSalesLine.Next = 0;
          end;
    end;

    local procedure CheckCopyFromSalesShptAvail(FromSalesShptHeader: Record "Sales Shipment Header";ToSalesHeader: Record "Sales Header")
    var
        FromSalesShptLine: Record "Sales Shipment Line";
        ToSalesLine: Record "Sales Line";
        FromPostedAsmHeader: Record "Posted Assembly Header";
    begin
        if not (ToSalesHeader."Document Type" in [ToSalesHeader."document type"::Order,ToSalesHeader."document type"::Invoice]) then
          exit;

        with ToSalesLine do begin
          FromSalesShptLine.SetRange("Document No.",FromSalesShptHeader."No.");
          FromSalesShptLine.SetRange(Type,FromSalesShptLine.Type::Item);
          FromSalesShptLine.SetFilter("No.",'<>%1','');
          if FromSalesShptLine.Find('-') then
            repeat
              if FromSalesShptLine.Quantity > 0 then begin
                "No." := FromSalesShptLine."No.";
                "Variant Code" := FromSalesShptLine."Variant Code";
                "Location Code" := FromSalesShptLine."Location Code";
                "Bin Code" := FromSalesShptLine."Bin Code";
                "Unit of Measure Code" := FromSalesShptLine."Unit of Measure Code";
                "Qty. per Unit of Measure" := FromSalesShptLine."Qty. per Unit of Measure";
                "Outstanding Quantity" := FromSalesShptLine.Quantity;

                if "Document Type" = "document type"::Order then
                  if FromSalesShptLine.AsmToShipmentExists(FromPostedAsmHeader) then
                    "Outstanding Quantity" := FromSalesShptLine.Quantity - FromPostedAsmHeader.Quantity;
                "Qty. to Assemble to Order" := 0;
                "Drop Shipment" := FromSalesShptLine."Drop Shipment";
                CheckItemAvailable(ToSalesHeader,ToSalesLine);

                if "Document Type" = "document type"::Order then
                  if FromSalesShptLine.AsmToShipmentExists(FromPostedAsmHeader) then begin
                    "Qty. to Assemble to Order" := FromPostedAsmHeader.Quantity;
                    CheckPostedATOItemAvailable(FromSalesShptLine,ToSalesLine);
                  end;
              end;
            until FromSalesShptLine.Next = 0;
        end;
    end;

    local procedure CheckCopyFromSalesInvoiceAvail(FromSalesInvHeader: Record "Sales Invoice Header";ToSalesHeader: Record "Sales Header")
    var
        FromSalesInvLine: Record "Sales Invoice Line";
        ToSalesLine: Record "Sales Line";
    begin
        if not (ToSalesHeader."Document Type" in [ToSalesHeader."document type"::Order,ToSalesHeader."document type"::Invoice]) then
          exit;

        with ToSalesLine do begin
          FromSalesInvLine.SetRange("Document No.",FromSalesInvHeader."No.");
          FromSalesInvLine.SetRange(Type,FromSalesInvLine.Type::Item);
          FromSalesInvLine.SetFilter("No.",'<>%1','');
          FromSalesInvLine.SetRange("Prepayment Line",false);
          if FromSalesInvLine.Find('-') then
            repeat
              if FromSalesInvLine.Quantity > 0 then begin
                "No." := FromSalesInvLine."No.";
                "Variant Code" := FromSalesInvLine."Variant Code";
                "Location Code" := FromSalesInvLine."Location Code";
                "Bin Code" := FromSalesInvLine."Bin Code";
                "Unit of Measure Code" := FromSalesInvLine."Unit of Measure Code";
                "Qty. per Unit of Measure" := FromSalesInvLine."Qty. per Unit of Measure";
                "Outstanding Quantity" := FromSalesInvLine.Quantity;
                "Drop Shipment" := FromSalesInvLine."Drop Shipment";
                CheckItemAvailable(ToSalesHeader,ToSalesLine);
              end;
            until FromSalesInvLine.Next = 0;
        end;
    end;

    local procedure CheckCopyFromSalesRetRcptAvail(FromReturnRcptHeader: Record "Return Receipt Header";ToSalesHeader: Record "Sales Header")
    var
        FromReturnRcptLine: Record "Return Receipt Line";
        ToSalesLine: Record "Sales Line";
    begin
        if not (ToSalesHeader."Document Type" in [ToSalesHeader."document type"::Order,ToSalesHeader."document type"::Invoice]) then
          exit;

        with ToSalesLine do begin
          FromReturnRcptLine.SetRange("Document No.",FromReturnRcptHeader."No.");
          FromReturnRcptLine.SetRange(Type,FromReturnRcptLine.Type::Item);
          FromReturnRcptLine.SetFilter("No.",'<>%1','');
          if FromReturnRcptLine.Find('-') then
            repeat
              if FromReturnRcptLine.Quantity > 0 then begin
                "No." := FromReturnRcptLine."No.";
                "Variant Code" := FromReturnRcptLine."Variant Code";
                "Location Code" := FromReturnRcptLine."Location Code";
                "Bin Code" := FromReturnRcptLine."Bin Code";
                "Unit of Measure Code" := FromReturnRcptLine."Unit of Measure Code";
                "Qty. per Unit of Measure" := FromReturnRcptLine."Qty. per Unit of Measure";
                "Outstanding Quantity" := FromReturnRcptLine.Quantity;
                "Drop Shipment" := false;
                CheckItemAvailable(ToSalesHeader,ToSalesLine);
              end;
            until FromReturnRcptLine.Next = 0;
        end;
    end;

    local procedure CheckCopyFromSalesCrMemoAvail(FromSalesCrMemoHeader: Record "Sales Cr.Memo Header";ToSalesHeader: Record "Sales Header")
    var
        FromSalesCrMemoLine: Record "Sales Cr.Memo Line";
        ToSalesLine: Record "Sales Line";
    begin
        if not (ToSalesHeader."Document Type" in [ToSalesHeader."document type"::Order,ToSalesHeader."document type"::Invoice]) then
          exit;

        with ToSalesLine do begin
          FromSalesCrMemoLine.SetRange("Document No.",FromSalesCrMemoHeader."No.");
          FromSalesCrMemoLine.SetRange(Type,FromSalesCrMemoLine.Type::Item);
          FromSalesCrMemoLine.SetFilter("No.",'<>%1','');
          FromSalesCrMemoLine.SetRange("Prepayment Line",false);
          if FromSalesCrMemoLine.Find('-') then
            repeat
              if FromSalesCrMemoLine.Quantity > 0 then begin
                "No." := FromSalesCrMemoLine."No.";
                "Variant Code" := FromSalesCrMemoLine."Variant Code";
                "Location Code" := FromSalesCrMemoLine."Location Code";
                "Bin Code" := FromSalesCrMemoLine."Bin Code";
                "Unit of Measure Code" := FromSalesCrMemoLine."Unit of Measure Code";
                "Qty. per Unit of Measure" := FromSalesCrMemoLine."Qty. per Unit of Measure";
                "Outstanding Quantity" := FromSalesCrMemoLine.Quantity;
                "Drop Shipment" := false;
                CheckItemAvailable(ToSalesHeader,ToSalesLine);
              end;
            until FromSalesCrMemoLine.Next = 0;
        end;
    end;

    local procedure CheckItemAvailable(var ToSalesHeader: Record "Sales Header";var ToSalesLine: Record "Sales Line")
    begin
        if HideDialog then
          exit;

        ToSalesLine."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine."Document No." := ToSalesHeader."No.";
        ToSalesLine.Type := ToSalesLine.Type::Item;
        ToSalesLine."Purchase Order No." := '';
        ToSalesLine."Purch. Order Line No." := 0;
        ToSalesLine."Drop Shipment" :=
          not RecalculateLines and ToSalesLine."Drop Shipment" and
          (ToSalesHeader."Document Type" = ToSalesHeader."document type"::Order);

        if ToSalesLine."Shipment Date" = 0D then begin
          if ToSalesHeader."Shipment Date" <> 0D then
            ToSalesLine.Validate("Shipment Date",ToSalesHeader."Shipment Date")
          else
            ToSalesLine.Validate("Shipment Date",WorkDate);
        end;

        if ItemCheckAvail.SalesLineCheck(ToSalesLine) then
          ItemCheckAvail.RaiseUpdateInterruptedError;
    end;

    local procedure CheckATOItemAvailable(var FromSalesLine: Record "Sales Line";ToSalesLine: Record "Sales Line")
    var
        ATOLink: Record "Assemble-to-Order Link";
        AsmHeader: Record "Assembly Header";
        TempAsmHeader: Record "Assembly Header" temporary;
        TempAsmLine: Record "Assembly Line" temporary;
    begin
        if HideDialog then
          exit;

        if ATOLink.ATOCopyCheckAvailShowWarning(
             AsmHeader,ToSalesLine,TempAsmHeader,TempAsmLine,
             not FromSalesLine.AsmToOrderExists(AsmHeader))
        then
          if ItemCheckAvail.ShowAsmWarningYesNo(TempAsmHeader,TempAsmLine) then
            ItemCheckAvail.RaiseUpdateInterruptedError;
    end;

    local procedure CheckPostedATOItemAvailable(var FromSalesShptLine: Record "Sales Shipment Line";ToSalesLine: Record "Sales Line")
    var
        ATOLink: Record "Assemble-to-Order Link";
        PostedAsmHeader: Record "Posted Assembly Header";
        TempAsmHeader: Record "Assembly Header" temporary;
        TempAsmLine: Record "Assembly Line" temporary;
    begin
        if HideDialog then
          exit;

        if ATOLink.PstdATOCopyCheckAvailShowWarn(
             PostedAsmHeader,ToSalesLine,TempAsmHeader,TempAsmLine,
             not FromSalesShptLine.AsmToShipmentExists(PostedAsmHeader))
        then
          if ItemCheckAvail.ShowAsmWarningYesNo(TempAsmHeader,TempAsmLine) then
            ItemCheckAvail.RaiseUpdateInterruptedError;
    end;


    procedure CopyServContractLines(ToServContractHeader: Record "Service Contract Header";FromDocType: Option;FromDocNo: Code[20];var FromServContractLine: Record "Service Contract Line") AllLinesCopied: Boolean
    var
        ExistingServContractLine: Record "Service Contract Line";
        LineNo: Integer;
    begin
        if FromDocNo = '' then
          Error(Text000);

        ExistingServContractLine.LockTable;
        ExistingServContractLine.Reset;
        ExistingServContractLine.SetRange("Contract Type",ToServContractHeader."Contract Type");
        ExistingServContractLine.SetRange("Contract No.",ToServContractHeader."Contract No.");
        if ExistingServContractLine.FindLast then
          LineNo := ExistingServContractLine."Line No." + 10000
        else
          LineNo := 10000;

        AllLinesCopied := true;
        FromServContractLine.Reset;
        FromServContractLine.SetRange("Contract Type",FromDocType);
        FromServContractLine.SetRange("Contract No.",FromDocNo);
        if FromServContractLine.Find('-') then
          repeat
            if not ProcessServContractLine(
                 ToServContractHeader,
                 FromServContractLine,
                 LineNo)
            then begin
              AllLinesCopied := false;
              FromServContractLine.Mark(true)
            end else
              LineNo := LineNo + 10000
          until FromServContractLine.Next = 0;
    end;


    procedure ServContractHeaderDocType(DocType: Option): Integer
    var
        ServContractHeader: Record "Service Contract Header";
    begin
        case DocType of
          Servdoctype::Quote:
            exit(ServContractHeader."contract type"::Quote);
          Servdoctype::Contract:
            exit(ServContractHeader."contract type"::Contract);
        end;
    end;

    local procedure ProcessServContractLine(ToServContractHeader: Record "Service Contract Header";var FromServContractLine: Record "Service Contract Line";LineNo: Integer): Boolean
    var
        ToServContractLine: Record "Service Contract Line";
        ExistingServContractLine: Record "Service Contract Line";
        ServItem: Record "Service Item";
    begin
        if FromServContractLine."Service Item No." <> '' then begin
          ServItem.Get(FromServContractLine."Service Item No.");
          if ServItem."Customer No." <> ToServContractHeader."Customer No." then
            exit(false);

          ExistingServContractLine.Reset;
          ExistingServContractLine.SetCurrentkey("Service Item No.","Contract Status");
          ExistingServContractLine.SetRange("Service Item No.",FromServContractLine."Service Item No.");
          ExistingServContractLine.SetRange("Contract Type",ToServContractHeader."Contract Type");
          ExistingServContractLine.SetRange("Contract No.",ToServContractHeader."Contract No.");
          if not ExistingServContractLine.IsEmpty then
            exit(false);
        end;

        ToServContractLine := FromServContractLine;
        ToServContractLine."Last Planned Service Date" := 0D;
        ToServContractLine."Last Service Date" := 0D;
        ToServContractLine."Last Preventive Maint. Date" := 0D;
        ToServContractLine."Invoiced to Date" := 0D;
        ToServContractLine."Contract Type" := ToServContractHeader."Contract Type";
        ToServContractLine."Contract No." := ToServContractHeader."Contract No.";
        ToServContractLine."Line No." := LineNo;
        ToServContractLine."New Line" := true;
        ToServContractLine.Credited := false;
        ToServContractLine.SetupNewLine;
        ToServContractLine.Insert(true);
        exit(true);
    end;


    procedure CopySalesShptLinesToDoc(ToSalesHeader: Record "Sales Header";var FromSalesShptLine: Record "Sales Shipment Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
        FromSalesLineBuf: Record "Sales Line" temporary;
        FromSalesShptHeader: Record "Sales Shipment Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToSalesHeader."Currency Code");
        OpenWindow;

        with FromSalesShptLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              if FromSalesShptHeader."No." <> "Document No." then begin
                FromSalesShptHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromSalesHeader.TransferFields(FromSalesShptHeader);
              FillExactCostRevLink :=
                IsSalesFillExactCostRevLink(ToSalesHeader,0,FromSalesHeader."Currency Code");
              FromSalesLine.TransferFields(FromSalesShptLine);
              FromSalesLine."Appl.-from Item Entry" := 0;

              if "Document No." <> OldDocNo then begin
                OldDocNo := "Document No.";
                InsertDocNoLine := true;
              end;

              SplitLine := true;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              if not SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntry,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,true)
              then
                if CopyItemTrkg then
                  SplitLine :=
                    SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,true)
                else
                  SplitLine := false;

              if not SplitLine then begin
                FromSalesLineBuf := FromSalesLine;
                CopyLine := true;
              end else
                CopyLine := FromSalesLineBuf.FindSet and FillExactCostRevLink;

              Window.Update(1,FromLineCounter);
              if CopyLine then begin
                NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                AsmHdrExistsForFromDocLine := AsmToShipmentExists(PostedAsmHeader);
                InitAsmCopyHandling(true);
                if AsmHdrExistsForFromDocLine then begin
                  QtyToAsmToOrder := Quantity;
                  QtyToAsmToOrderBase := "Quantity (Base)";
                  GenerateAsmDataFromPosted(PostedAsmHeader,ToSalesHeader."Document Type");
                end;
                if InsertDocNoLine then begin
                  InsertOldSalesDocNoLine(ToSalesHeader,"Document No.",1,NextLineNo);
                  InsertDocNoLine := false;
                end;
                repeat
                  ToLineCounter := ToLineCounter + 1;
                  if IsTimeForUpdate then
                    Window.Update(2,ToLineCounter);
                  if CopySalesLine(
                       ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLineBuf,NextLineNo,LinesNotCopied,
                       false,DeferralTypeForSalesDoc(Salesdoctype::"Posted Shipment"),CopyPostedDeferral)
                  then
                    if CopyItemTrkg then begin
                      if SplitLine then
                        ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                          TempItemTrkgEntry,TempTrkgItemLedgEntry,false,FromSalesLineBuf."Document No.",FromSalesLineBuf."Line No.")
                      else
                        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                      ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                        TempTrkgItemLedgEntry,ToSalesLine,
                        FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                        FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",true);
                    end;
                until FromSalesLineBuf.Next = 0;
              end;
            until Next = 0;

        Window.Close;
    end;


    procedure CopySalesInvLinesToDoc(ToSalesHeader: Record "Sales Header";var FromSalesInvLine: Record "Sales Invoice Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        FromSalesLine2: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
        FromSalesLineBuf: Record "Sales Line" temporary;
        FromSalesInvHeader: Record "Sales Invoice Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldInvDocNo: Code[20];
        OldShptDocNo: Code[20];
        NextLineNo: Integer;
        SalesCombDocLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        SalesInvLineCount: Integer;
        SalesLineCount: Integer;
        BufferCount: Integer;
        FirstLineShipped: Boolean;
        FirstLineText: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToSalesHeader."Currency Code");
        FromSalesLineBuf.Reset;
        FromSalesLineBuf.DeleteAll;
        TempItemTrkgEntry.Reset;
        TempItemTrkgEntry.DeleteAll;
        OpenWindow;
        InitAsmCopyHandling(true);
        TempSalesInvLine.DeleteAll;

        // Fill sales line buffer
        SalesInvLineCount := 0;
        FirstLineText := false;
        with FromSalesInvLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              SetTempSalesInvLine(FromSalesInvLine,TempSalesInvLine,SalesInvLineCount,NextLineNo,FirstLineText);
              if FromSalesInvHeader."No." <> "Document No." then begin
                FromSalesInvHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromSalesInvHeader.TestField("Prices Including VAT",ToSalesHeader."Prices Including VAT");
              FromSalesHeader.TransferFields(FromSalesInvHeader);
              FillExactCostRevLink := IsSalesFillExactCostRevLink(ToSalesHeader,1,FromSalesHeader."Currency Code");
              FromSalesLine.TransferFields(FromSalesInvLine);
              FromSalesLine."Appl.-from Item Entry" := 0;
              // Reuse fields to buffer invoice line information
              FromSalesLine."Shipment No." := "Document No.";
              FromSalesLine."Shipment Line No." := 0;
              FromSalesLine."Return Receipt No." := '';
              FromSalesLine."Return Receipt Line No." := "Line No.";

              SplitLine := true;
              GetItemLedgEntries(ItemLedgEntryBuf,true);
              if not SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntryBuf,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,false)
              then
                if CopyItemTrkg then
                  SplitLine := SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,false)
                else
                  SplitLine := false;

              if not SplitLine then
                CopySalesLinesToBuffer(
                  FromSalesHeader,FromSalesLine,FromSalesLine2,FromSalesLineBuf,ToSalesHeader,"Document No.",NextLineNo);
            until Next = 0;

        // Create sales line from buffer
        Window.Update(1,FromLineCounter);
        BufferCount := 0;
        FirstLineShipped := true;
        with FromSalesLineBuf do begin
          // Sorting according to Sales Line Document No.,Line No.
          SetCurrentkey("Document Type","Document No.","Line No.");
          SalesLineCount := 0;
          if FindSet then
            repeat
              if Type = Type::Item then
                SalesLineCount += 1;
            until Next = 0;
          if FindSet then begin
            NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
            repeat
              ToLineCounter := ToLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(2,ToLineCounter);
              if "Shipment No." <> OldInvDocNo then begin
                OldInvDocNo := "Shipment No.";
                OldShptDocNo := '';
                InsertOldSalesDocNoLine(ToSalesHeader,OldInvDocNo,2,NextLineNo);
              end;
              CheckFirstLineShipped("Document No.","Shipment Line No.",SalesCombDocLineNo,NextLineNo,FirstLineShipped);
              if ("Document No." <> OldShptDocNo) and ("Shipment Line No." > 0) then begin
                if FirstLineShipped then
                  SalesCombDocLineNo := NextLineNo;
                OldShptDocNo := "Document No.";
                InsertOldSalesCombDocNoLine(ToSalesHeader,OldInvDocNo,OldShptDocNo,SalesCombDocLineNo,true);
                NextLineNo := NextLineNo + 10000;
                FirstLineShipped := true;
              end;

              InitFromSalesLine2(FromSalesLine2,FromSalesLineBuf);
              AsmHdrExistsForFromDocLine := false;
              if Type = Type::Item then begin
                BufferCount += 1;
                AsmHdrExistsForFromDocLine := RetrieveSalesInvLine(FromSalesLine2,BufferCount,SalesLineCount = SalesInvLineCount);
                InitAsmCopyHandling(true);
                if AsmHdrExistsForFromDocLine then begin
                  AsmHdrExistsForFromDocLine := GetAsmDataFromSalesInvLine(ToSalesHeader."Document Type");
                  if AsmHdrExistsForFromDocLine then begin
                    QtyToAsmToOrder := TempSalesInvLine.Quantity;
                    QtyToAsmToOrderBase := TempSalesInvLine.Quantity * TempSalesInvLine."Qty. per Unit of Measure";
                  end;
                end;
              end;
              if CopySalesLine(ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLine2,NextLineNo,LinesNotCopied,
                   "Return Receipt No." = '',DeferralTypeForSalesDoc(Salesdoctype::"Posted Invoice"),CopyPostedDeferral)
              then begin
                if CopyPostedDeferral then
                  CopySalesPostedDeferrals(ToSalesLine,DeferralUtilities.GetSalesDeferralDocType,
                    DeferralTypeForSalesDoc(Salesdoctype::"Posted Invoice"),"Shipment No.","Return Receipt Line No.",
                    ToSalesLine."Document Type",ToSalesLine."Document No.",ToSalesLine."Line No.");
                FromSalesInvLine.Get("Shipment No.","Return Receipt Line No.");

                // copy item tracking
                if (Type = Type::Item) and (Quantity <> 0) and SalesDocCanReceiveTracking(ToSalesHeader) then begin
                  FromSalesInvLine."Document No." := OldInvDocNo;
                  FromSalesInvLine."Line No." := "Return Receipt Line No.";
                  FromSalesInvLine.GetItemLedgEntries(ItemLedgEntryBuf,true);
                  if IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) then begin
                    if MoveNegLines or not ExactCostRevMandatory then
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                    else
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,false,"Document No.","Line No.");

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(TempTrkgItemLedgEntry,ToSalesLine,
                      FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                      FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",false);
                  end;
                end;
              end;
            until Next = 0;
          end;
        end;
        Window.Close;
    end;


    procedure CopySalesCrMemoLinesToDoc(ToSalesHeader: Record "Sales Header";var FromSalesCrMemoLine: Record "Sales Cr.Memo Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        FromSalesLine2: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
        FromSalesLineBuf: Record "Sales Line" temporary;
        FromSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldCrMemoDocNo: Code[20];
        OldReturnRcptDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToSalesHeader."Currency Code");
        FromSalesLineBuf.Reset;
        FromSalesLineBuf.DeleteAll;
        TempItemTrkgEntry.Reset;
        TempItemTrkgEntry.DeleteAll;
        OpenWindow;

        // Fill sales line buffer
        with FromSalesCrMemoLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              if FromSalesCrMemoHeader."No." <> "Document No." then begin
                FromSalesCrMemoHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromSalesHeader.TransferFields(FromSalesCrMemoHeader);
              FillExactCostRevLink :=
                IsSalesFillExactCostRevLink(ToSalesHeader,3,FromSalesHeader."Currency Code");
              FromSalesLine.TransferFields(FromSalesCrMemoLine);
              FromSalesLine."Appl.-from Item Entry" := 0;
              // Reuse fields to buffer credit memo line information
              FromSalesLine."Shipment No." := "Document No.";
              FromSalesLine."Shipment Line No." := 0;
              FromSalesLine."Return Receipt No." := '';
              FromSalesLine."Return Receipt Line No." := "Line No.";

              SplitLine := true;
              GetItemLedgEntries(ItemLedgEntryBuf,true);
              if not SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntryBuf,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,false)
              then
                if CopyItemTrkg then
                  SplitLine :=
                    SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,false)
                else
                  SplitLine := false;

              if not SplitLine then
                CopySalesLinesToBuffer(
                  FromSalesHeader,FromSalesLine,FromSalesLine2,FromSalesLineBuf,ToSalesHeader,"Document No.",NextLineNo);
            until Next = 0;

        // Create sales line from buffer
        Window.Update(1,FromLineCounter);
        with FromSalesLineBuf do begin
          // Sorting according to Sales Line Document No.,Line No.
          SetCurrentkey("Document Type","Document No.","Line No.");
          if FindSet then begin
            NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
            repeat
              ToLineCounter := ToLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(2,ToLineCounter);
              if "Shipment No." <> OldCrMemoDocNo then begin
                OldCrMemoDocNo := "Shipment No.";
                OldReturnRcptDocNo := '';
                InsertOldSalesDocNoLine(ToSalesHeader,OldCrMemoDocNo,4,NextLineNo);
              end;
              if ("Document No." <> OldReturnRcptDocNo) and ("Shipment Line No." > 0) then begin
                OldReturnRcptDocNo := "Document No.";
                InsertOldSalesCombDocNoLine(ToSalesHeader,OldCrMemoDocNo,OldReturnRcptDocNo,NextLineNo,false);
              end;

              // Empty buffer fields
              FromSalesLine2 := FromSalesLineBuf;
              FromSalesLine2."Shipment No." := '';
              FromSalesLine2."Shipment Line No." := 0;
              FromSalesLine2."Return Receipt No." := '';
              FromSalesLine2."Return Receipt Line No." := 0;
              if CopySalesLine(
                   ToSalesHeader,ToSalesLine,FromSalesHeader,
                   FromSalesLine2,NextLineNo,LinesNotCopied,"Return Receipt No." = '',
                   DeferralTypeForSalesDoc(Salesdoctype::"Posted Credit Memo"),CopyPostedDeferral)
              then begin
                if CopyPostedDeferral then
                  CopySalesPostedDeferrals(ToSalesLine,DeferralUtilities.GetSalesDeferralDocType,
                    DeferralTypeForSalesDoc(Salesdoctype::"Posted Credit Memo"),"Shipment No." ,
                    "Return Receipt Line No.",ToSalesLine."Document Type",ToSalesLine."Document No.",ToSalesLine."Line No.");
                FromSalesCrMemoLine.Get("Shipment No.","Return Receipt Line No.");

                // copy item tracking
                if (Type = Type::Item) and (Quantity <> 0) then begin
                  FromSalesCrMemoLine."Document No." := OldCrMemoDocNo;
                  FromSalesCrMemoLine."Line No." := "Return Receipt Line No.";
                  FromSalesCrMemoLine.GetItemLedgEntries(ItemLedgEntryBuf,true);
                  if IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) then begin
                    if MoveNegLines or not ExactCostRevMandatory then
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                    else
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,false,"Document No.","Line No.");

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                      TempTrkgItemLedgEntry,ToSalesLine,
                      FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                      FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",false);
                  end;
                end;
              end;
            until Next = 0;
          end;
        end;

        Window.Close;
    end;


    procedure CopySalesReturnRcptLinesToDoc(ToSalesHeader: Record "Sales Header";var FromReturnRcptLine: Record "Return Receipt Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesHeader: Record "Sales Header";
        FromSalesLine: Record "Sales Line";
        ToSalesLine: Record "Sales Line";
        FromSalesLineBuf: Record "Sales Line" temporary;
        FromReturnRcptHeader: Record "Return Receipt Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToSalesHeader."Currency Code");
        OpenWindow;

        with FromReturnRcptLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              if FromReturnRcptHeader."No." <> "Document No." then begin
                FromReturnRcptHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromSalesHeader.TransferFields(FromReturnRcptHeader);
              FillExactCostRevLink :=
                IsSalesFillExactCostRevLink(ToSalesHeader,2,FromSalesHeader."Currency Code");
              FromSalesLine.TransferFields(FromReturnRcptLine);
              FromSalesLine."Appl.-from Item Entry" := 0;

              if "Document No." <> OldDocNo then begin
                OldDocNo := "Document No.";
                InsertDocNoLine := true;
              end;

              SplitLine := true;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              if not SplitPstdSalesLinesPerILE(
                   ToSalesHeader,FromSalesHeader,ItemLedgEntry,FromSalesLineBuf,
                   FromSalesLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,true)
              then
                if CopyItemTrkg then
                  SplitLine :=
                    SplitSalesDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromSalesLineBuf,
                      FromSalesLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,true)
                else
                  SplitLine := false;

              if not SplitLine then begin
                FromSalesLineBuf := FromSalesLine;
                CopyLine := true;
              end else
                CopyLine := FromSalesLineBuf.FindSet and FillExactCostRevLink;

              Window.Update(1,FromLineCounter);
              if CopyLine then begin
                NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                if InsertDocNoLine then begin
                  InsertOldSalesDocNoLine(ToSalesHeader,"Document No.",3,NextLineNo);
                  InsertDocNoLine := false;
                end;
                repeat
                  ToLineCounter := ToLineCounter + 1;
                  if IsTimeForUpdate then
                    Window.Update(2,ToLineCounter);
                  if CopySalesLine(
                       ToSalesHeader,ToSalesLine,FromSalesHeader,FromSalesLineBuf,NextLineNo,LinesNotCopied,
                       false,DeferralTypeForSalesDoc(Salesdoctype::"Posted Return Receipt"),CopyPostedDeferral)
                  then
                    if CopyItemTrkg then begin
                      if SplitLine then
                        ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                          TempItemTrkgEntry,TempTrkgItemLedgEntry,false,FromSalesLineBuf."Document No.",FromSalesLineBuf."Line No.")
                      else
                        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                      ItemTrackingMgt.CopyItemLedgEntryTrkgToSalesLn(
                        TempTrkgItemLedgEntry,ToSalesLine,
                        FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                        FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT",true);
                    end;
                until FromSalesLineBuf.Next = 0
              end;
            until Next = 0;

        Window.Close;
    end;

    local procedure CopySalesLinesToBuffer(FromSalesHeader: Record "Sales Header";FromSalesLine: Record "Sales Line";var FromSalesLine2: Record "Sales Line";var TempSalesLineBuf: Record "Sales Line" temporary;ToSalesHeader: Record "Sales Header";DocNo: Code[20];var NextLineNo: Integer)
    begin
        FromSalesLine2 := TempSalesLineBuf;
        TempSalesLineBuf := FromSalesLine;
        TempSalesLineBuf."Document No." := FromSalesLine2."Document No.";
        TempSalesLineBuf."Shipment Line No." := FromSalesLine2."Shipment Line No.";
        NextLineNo := NextLineNo + 10000;
        if not IsRecalculateAmount(
             FromSalesHeader."Currency Code",ToSalesHeader."Currency Code",
             FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT")
        then
          TempSalesLineBuf."Return Receipt No." := DocNo;
        ReCalcSalesLine(FromSalesHeader,ToSalesHeader,TempSalesLineBuf);
        TempSalesLineBuf.Insert;
    end;

    local procedure SplitPstdSalesLinesPerILE(ToSalesHeader: Record "Sales Header";FromSalesHeader: Record "Sales Header";var ItemLedgEntry: Record "Item Ledger Entry";var FromSalesLineBuf: Record "Sales Line";FromSalesLine: Record "Sales Line";var NextLineNo: Integer;var CopyItemTrkg: Boolean;var MissingExCostRevLink: Boolean;FillExactCostRevLink: Boolean;FromShptOrRcpt: Boolean): Boolean
    var
        OrgQtyBase: Decimal;
    begin
        if FromShptOrRcpt then begin
          FromSalesLineBuf.Reset;
          FromSalesLineBuf.DeleteAll;
        end else
          FromSalesLineBuf.Init;

        CopyItemTrkg := false;

        if (FromSalesLine.Type <> FromSalesLine.Type::Item) or (FromSalesLine.Quantity = 0) then
          exit(false);
        if IsCopyItemTrkg(ItemLedgEntry,CopyItemTrkg,FillExactCostRevLink) or
           not FillExactCostRevLink or MoveNegLines or
           not ExactCostRevMandatory
        then
          exit(false);

        with ItemLedgEntry do begin
          FindSet;
          if Quantity >= 0 then begin
            FromSalesLineBuf."Document No." := "Document No.";
            if GetSalesDocType(ItemLedgEntry) in
               [FromSalesLineBuf."document type"::Order,FromSalesLineBuf."document type"::"Return Order"]
            then
              FromSalesLineBuf."Shipment Line No." := 1;
            exit(false);
          end;
          OrgQtyBase := FromSalesLine."Quantity (Base)";
          repeat
            if "Shipped Qty. Not Returned" = 0 then
              LinesApplied := true;

            if "Shipped Qty. Not Returned" < 0 then begin
              FromSalesLineBuf := FromSalesLine;

              if -"Shipped Qty. Not Returned" < Abs(FromSalesLine."Quantity (Base)") then begin
                if FromSalesLine."Quantity (Base)" > 0 then
                  FromSalesLineBuf."Quantity (Base)" := -"Shipped Qty. Not Returned"
                else
                  FromSalesLineBuf."Quantity (Base)" := "Shipped Qty. Not Returned";
                if FromSalesLineBuf."Qty. per Unit of Measure" = 0 then
                  FromSalesLineBuf.Quantity := FromSalesLineBuf."Quantity (Base)"
                else
                  FromSalesLineBuf.Quantity :=
                    ROUND(FromSalesLineBuf."Quantity (Base)" / FromSalesLineBuf."Qty. per Unit of Measure",0.00001);
              end;
              FromSalesLine."Quantity (Base)" := FromSalesLine."Quantity (Base)" - FromSalesLineBuf."Quantity (Base)";
              FromSalesLine.Quantity := FromSalesLine.Quantity - FromSalesLineBuf.Quantity;
              FromSalesLineBuf."Appl.-from Item Entry" := "Entry No.";
              NextLineNo := NextLineNo + 1;
              FromSalesLineBuf."Line No." := NextLineNo;
              NextLineNo := NextLineNo + 1;
              FromSalesLineBuf."Document No." := "Document No.";
              if GetSalesDocType(ItemLedgEntry) in
                 [FromSalesLineBuf."document type"::Order,FromSalesLineBuf."document type"::"Return Order"]
              then
                FromSalesLineBuf."Shipment Line No." := 1;

              if not FromShptOrRcpt then
                UpdateRevSalesLineAmount(
                  FromSalesLineBuf,OrgQtyBase,
                  FromSalesHeader."Prices Including VAT",ToSalesHeader."Prices Including VAT");

              FromSalesLineBuf.Insert;
            end;
          until (Next = 0) or (FromSalesLine."Quantity (Base)" = 0);

          if (FromSalesLine."Quantity (Base)" <> 0) and FillExactCostRevLink then
            MissingExCostRevLink := true;
          CheckUnappliedLines(LinesApplied,MissingExCostRevLink);
        end;
        exit(true);
    end;

    local procedure SplitSalesDocLinesPerItemTrkg(var ItemLedgEntry: Record "Item Ledger Entry";var TempItemTrkgEntry: Record "Reservation Entry" temporary;var FromSalesLineBuf: Record "Sales Line";FromSalesLine: Record "Sales Line";var NextLineNo: Integer;var NextItemTrkgEntryNo: Integer;var MissingExCostRevLink: Boolean;FromShptOrRcpt: Boolean): Boolean
    var
        SalesLineBuf: array [2] of Record "Sales Line" temporary;
        ReversibleQtyBase: Decimal;
        SignFactor: Integer;
        i: Integer;
    begin
        if FromShptOrRcpt then begin
          FromSalesLineBuf.Reset;
          FromSalesLineBuf.DeleteAll;
          TempItemTrkgEntry.Reset;
          TempItemTrkgEntry.DeleteAll;
        end else
          FromSalesLineBuf.Init;

        if MoveNegLines or not ExactCostRevMandatory then
          exit(false);

        if FromSalesLine."Quantity (Base)" < 0 then
          SignFactor := -1
        else
          SignFactor := 1;

        with ItemLedgEntry do begin
          SetCurrentkey("Document No.","Document Type","Document Line No.");
          FindSet;
          repeat
            SalesLineBuf[1] := FromSalesLine;
            SalesLineBuf[1]."Line No." := NextLineNo;
            SalesLineBuf[1]."Quantity (Base)" := 0;
            SalesLineBuf[1].Quantity := 0;
            SalesLineBuf[1]."Document No." := "Document No.";
            if GetSalesDocType(ItemLedgEntry) in
               [SalesLineBuf[1]."document type"::Order,SalesLineBuf[1]."document type"::"Return Order"]
            then
              SalesLineBuf[1]."Shipment Line No." := 1;
            SalesLineBuf[2] := SalesLineBuf[1];
            SalesLineBuf[2]."Line No." := SalesLineBuf[2]."Line No." + 1;

            if not FromShptOrRcpt then begin
              SetRange("Document No.","Document No.");
              SetRange("Document Type","Document Type");
              SetRange("Document Line No.","Document Line No.");
            end;
            repeat
              i := 1;
              if not Positive then
                "Shipped Qty. Not Returned" :=
                  "Shipped Qty. Not Returned" -
                  CalcDistributedQty(TempItemTrkgEntry,ItemLedgEntry,SalesLineBuf[2]."Line No." + 1);

              if "Document Type" in ["document type"::"Sales Return Receipt","document type"::"Sales Credit Memo"] then
                if "Remaining Quantity" < FromSalesLine."Quantity (Base)" * SignFactor then
                  ReversibleQtyBase := "Remaining Quantity" * SignFactor
                else
                  ReversibleQtyBase := FromSalesLine."Quantity (Base)"
              else
                if -"Shipped Qty. Not Returned" < FromSalesLine."Quantity (Base)" * SignFactor then
                  ReversibleQtyBase := -"Shipped Qty. Not Returned" * SignFactor
                else
                  ReversibleQtyBase := FromSalesLine."Quantity (Base)";

              if ReversibleQtyBase <> 0 then begin
                if not Positive then
                  if IsSplitItemLedgEntry(ItemLedgEntry) then
                    i := 2;

                SalesLineBuf[i]."Quantity (Base)" := SalesLineBuf[i]."Quantity (Base)" + ReversibleQtyBase;
                if SalesLineBuf[i]."Qty. per Unit of Measure" = 0 then
                  SalesLineBuf[i].Quantity := SalesLineBuf[i]."Quantity (Base)"
                else
                  SalesLineBuf[i].Quantity :=
                    ROUND(SalesLineBuf[i]."Quantity (Base)" / SalesLineBuf[i]."Qty. per Unit of Measure",0.00001);
                FromSalesLine."Quantity (Base)" := FromSalesLine."Quantity (Base)" - ReversibleQtyBase;
                // Fill buffer with exact cost reversing link
                InsertTempItemTrkgEntry(
                  ItemLedgEntry,TempItemTrkgEntry,-Abs(ReversibleQtyBase),
                  SalesLineBuf[i]."Line No.",NextItemTrkgEntryNo,true);
              end;
            until (Next = 0) or (FromSalesLine."Quantity (Base)" = 0);

            for i := 1 to 2 do
              if SalesLineBuf[i]."Quantity (Base)" <> 0 then begin
                FromSalesLineBuf := SalesLineBuf[i];
                FromSalesLineBuf.Insert;
                NextLineNo := SalesLineBuf[i]."Line No." + 1;
              end;

            if not FromShptOrRcpt then begin
              SetRange("Document No.");
              SetRange("Document Type");
              SetRange("Document Line No.");
            end;
          until (Next = 0) or FromShptOrRcpt;

          if (FromSalesLine."Quantity (Base)" <> 0) and not Positive and TempItemTrkgEntry.IsEmpty then
            MissingExCostRevLink := true;
        end;

        exit(true);
    end;


    procedure CopyPurchRcptLinesToDoc(ToPurchHeader: Record "Purchase Header";var FromPurchRcptLine: Record "Purch. Rcpt. Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromPurchRcptHeader: Record "Purch. Rcpt. Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        FillExactCostRevLink: Boolean;
        SplitLine: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToPurchHeader."Currency Code");
        OpenWindow;

        with FromPurchRcptLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              if FromPurchRcptHeader."No." <> "Document No." then begin
                FromPurchRcptHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromPurchHeader.TransferFields(FromPurchRcptHeader);
              FillExactCostRevLink :=
                IsPurchFillExactCostRevLink(ToPurchHeader,0,FromPurchHeader."Currency Code");
              FromPurchLine.TransferFields(FromPurchRcptLine);
              FromPurchLine."Appl.-to Item Entry" := 0;

              if "Document No." <> OldDocNo then begin
                OldDocNo := "Document No.";
                InsertDocNoLine := true;
              end;

              SplitLine := true;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              if not SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntry,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,true)
              then
                if CopyItemTrkg then
                  SplitLine :=
                    SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,true)
                else
                  SplitLine := false;

              if not SplitLine then begin
                FromPurchLineBuf := FromPurchLine;
                CopyLine := true;
              end else
                CopyLine := FromPurchLineBuf.FindSet and FillExactCostRevLink;

              Window.Update(1,FromLineCounter);
              if CopyLine then begin
                NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
                if InsertDocNoLine then begin
                  InsertOldPurchDocNoLine(ToPurchHeader,"Document No.",1,NextLineNo);
                  InsertDocNoLine := false;
                end;
                repeat
                  ToLineCounter := ToLineCounter + 1;
                  if IsTimeForUpdate then
                    Window.Update(2,ToLineCounter);
                  if FromPurchLine."Prod. Order No." <> '' then
                    FromPurchLine."Quantity (Base)" := 0;
                  if CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLineBuf,NextLineNo,LinesNotCopied,
                       false,DeferralTypeForPurchDoc(Purchdoctype::"Posted Receipt"),CopyPostedDeferral)
                  then
                    if CopyItemTrkg then begin
                      if SplitLine then
                        ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                          TempItemTrkgEntry,TempTrkgItemLedgEntry,true,FromPurchLineBuf."Document No.",FromPurchLineBuf."Line No.")
                      else
                        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                      ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                        TempTrkgItemLedgEntry,ToPurchLine,
                        FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                        FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",true);
                    end;
                until FromPurchLineBuf.Next = 0
              end;
            until Next = 0;

        Window.Close;
    end;


    procedure CopyPurchInvLinesToDoc(ToPurchHeader: Record "Purchase Header";var FromPurchInvLine: Record "Purch. Inv. Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        FromPurchLine2: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromPurchInvHeader: Record "Purch. Inv. Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldInvDocNo: Code[20];
        OldRcptDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToPurchHeader."Currency Code");
        FromPurchLineBuf.Reset;
        FromPurchLineBuf.DeleteAll;
        TempItemTrkgEntry.Reset;
        TempItemTrkgEntry.DeleteAll;
        OpenWindow;

        // Fill purchase line buffer
        with FromPurchInvLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              if FromPurchInvHeader."No." <> "Document No." then begin
                FromPurchInvHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromPurchInvHeader.TestField("Prices Including VAT",ToPurchHeader."Prices Including VAT");
              FromPurchHeader.TransferFields(FromPurchInvHeader);
              FillExactCostRevLink := IsPurchFillExactCostRevLink(ToPurchHeader,1,FromPurchHeader."Currency Code");
              FromPurchLine.TransferFields(FromPurchInvLine);
              FromPurchLine."Appl.-to Item Entry" := 0;
              // Reuse fields to buffer invoice line information
              FromPurchLine."Receipt No." := "Document No.";
              FromPurchLine."Receipt Line No." := 0;
              FromPurchLine."Return Shipment No." := '';
              FromPurchLine."Return Shipment Line No." := "Line No.";

              SplitLine := true;
              GetItemLedgEntries(ItemLedgEntryBuf,true);
              if not SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntryBuf,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,false)
              then
                if CopyItemTrkg then
                  SplitLine := SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,false)
                else
                  SplitLine := false;

              if not SplitLine then
                CopyPurchLinesToBuffer(
                  FromPurchHeader,FromPurchLine,FromPurchLine2,FromPurchLineBuf,ToPurchHeader,"Document No.",NextLineNo);
            until Next = 0;

        // Create purchase line from buffer
        Window.Update(1,FromLineCounter);
        with FromPurchLineBuf do begin
          // Sorting according to Purchase Line Document No.,Line No.
          SetCurrentkey("Document Type","Document No.","Line No.");
          if FindSet then begin
            NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
            repeat
              ToLineCounter := ToLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(2,ToLineCounter);
              if "Receipt No." <> OldInvDocNo then begin
                OldInvDocNo := "Receipt No.";
                OldRcptDocNo := '';
                InsertOldPurchDocNoLine(ToPurchHeader,OldInvDocNo,2,NextLineNo);
              end;
              if "Document No." <> OldRcptDocNo then begin
                OldRcptDocNo := "Document No.";
                InsertOldPurchCombDocNoLine(ToPurchHeader,OldInvDocNo,OldRcptDocNo,NextLineNo,true);
              end;

              // Empty buffer fields
              FromPurchLine2 := FromPurchLineBuf;
              FromPurchLine2."Receipt No." := '';
              FromPurchLine2."Receipt Line No." := 0;
              FromPurchLine2."Return Shipment No." := '';
              FromPurchLine2."Return Shipment Line No." := 0;

              if CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine2,NextLineNo,LinesNotCopied,
                   "Return Shipment No." = '',DeferralTypeForPurchDoc(Purchdoctype::"Posted Invoice"),CopyPostedDeferral)
              then begin
                if CopyPostedDeferral then
                  CopyPurchPostedDeferrals(ToPurchLine,DeferralUtilities.GetPurchDeferralDocType,
                    DeferralTypeForPurchDoc(Purchdoctype::"Posted Invoice"),"Receipt No.",
                    "Return Shipment Line No.",ToPurchLine."Document Type",ToPurchLine."Document No.",ToPurchLine."Line No.");
                FromPurchInvLine.Get("Receipt No.","Return Shipment Line No.");

                // copy item tracking
                if (Type = Type::Item) and (Quantity <> 0) and ("Prod. Order No." = '') and
                   PurchaseDocCanReceiveTracking(ToPurchHeader)
                then begin
                  FromPurchInvLine."Document No." := OldInvDocNo;
                  FromPurchInvLine."Line No." := "Return Shipment Line No.";
                  FromPurchInvLine.GetItemLedgEntries(ItemLedgEntryBuf,true);
                  if IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) then begin
                    if "Job No." <> '' then
                      ItemLedgEntryBuf.SetFilter("Entry Type",'<> %1',ItemLedgEntryBuf."entry type"::"Negative Adjmt.");
                    if MoveNegLines or not ExactCostRevMandatory then
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                    else
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,true,"Document No.","Line No.");

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(TempTrkgItemLedgEntry,ToPurchLine,
                      FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                      FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",false);
                  end;
                end;
              end;
            until Next = 0;
          end;
        end;

        Window.Close;
    end;


    procedure CopyPurchCrMemoLinesToDoc(ToPurchHeader: Record "Purchase Header";var FromPurchCrMemoLine: Record "Purch. Cr. Memo Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        FromPurchLine2: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromPurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldCrMemoDocNo: Code[20];
        OldReturnShptDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToPurchHeader."Currency Code");
        FromPurchLineBuf.Reset;
        FromPurchLineBuf.DeleteAll;
        TempItemTrkgEntry.Reset;
        TempItemTrkgEntry.DeleteAll;
        OpenWindow;

        // Fill purchase line buffer
        with FromPurchCrMemoLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              if FromPurchCrMemoHeader."No." <> "Document No." then begin
                FromPurchCrMemoHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromPurchHeader.TransferFields(FromPurchCrMemoHeader);
              FillExactCostRevLink :=
                IsPurchFillExactCostRevLink(ToPurchHeader,3,FromPurchHeader."Currency Code");
              FromPurchLine.TransferFields(FromPurchCrMemoLine);
              FromPurchLine."Appl.-to Item Entry" := 0;
              // Reuse fields to buffer credit memo line information
              FromPurchLine."Receipt No." := "Document No.";
              FromPurchLine."Receipt Line No." := 0;
              FromPurchLine."Return Shipment No." := '';
              FromPurchLine."Return Shipment Line No." := "Line No.";

              SplitLine := true;
              GetItemLedgEntries(ItemLedgEntryBuf,true);
              if not SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntryBuf,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,false)
              then
                if CopyItemTrkg then
                  SplitLine :=
                    SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntryBuf,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,false)
                else
                  SplitLine := false;

              if not SplitLine then
                CopyPurchLinesToBuffer(
                  FromPurchHeader,FromPurchLine,FromPurchLine2,FromPurchLineBuf,ToPurchHeader,"Document No.",NextLineNo);
            until Next = 0;

        // Create purchase line from buffer
        Window.Update(1,FromLineCounter);
        with FromPurchLineBuf do begin
          // Sorting according to Purchase Line Document No.,Line No.
          SetCurrentkey("Document Type","Document No.","Line No.");
          if FindSet then begin
            NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
            repeat
              ToLineCounter := ToLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(2,ToLineCounter);
              if "Receipt No." <> OldCrMemoDocNo then begin
                OldCrMemoDocNo := "Receipt No.";
                OldReturnShptDocNo := '';
                InsertOldPurchDocNoLine(ToPurchHeader,OldCrMemoDocNo,4,NextLineNo);
              end;
              if "Document No." <> OldReturnShptDocNo then begin
                OldReturnShptDocNo := "Document No.";
                InsertOldPurchCombDocNoLine(ToPurchHeader,OldCrMemoDocNo,OldReturnShptDocNo,NextLineNo,false);
              end;

              // Empty buffer fields
              FromPurchLine2 := FromPurchLineBuf;
              FromPurchLine2."Receipt No." := '';
              FromPurchLine2."Receipt Line No." := 0;
              FromPurchLine2."Return Shipment No." := '';
              FromPurchLine2."Return Shipment Line No." := 0;

              if CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLine2,NextLineNo,LinesNotCopied,
                   "Return Shipment No." = '',DeferralTypeForPurchDoc(Purchdoctype::"Posted Credit Memo"),CopyPostedDeferral)
              then begin
                if CopyPostedDeferral then
                  CopyPurchPostedDeferrals(ToPurchLine,DeferralUtilities.GetPurchDeferralDocType,
                    DeferralTypeForPurchDoc(Purchdoctype::"Posted Credit Memo"),"Receipt No.",
                    "Return Shipment Line No.",ToPurchLine."Document Type",ToPurchLine."Document No.",ToPurchLine."Line No.");
                FromPurchCrMemoLine.Get("Receipt No.","Return Shipment Line No.");

                // copy item tracking
                if (Type = Type::Item) and (Quantity <> 0) and ("Prod. Order No." = '') then begin
                  FromPurchCrMemoLine."Document No." := OldCrMemoDocNo;
                  FromPurchCrMemoLine."Line No." := "Return Shipment Line No.";
                  FromPurchCrMemoLine.GetItemLedgEntries(ItemLedgEntryBuf,true);
                  if IsCopyItemTrkg(ItemLedgEntryBuf,CopyItemTrkg,FillExactCostRevLink) then begin
                    if "Job No." <> '' then
                      ItemLedgEntryBuf.SetFilter("Entry Type",'<> %1',ItemLedgEntryBuf."entry type"::"Negative Adjmt.");
                    if MoveNegLines or not ExactCostRevMandatory then
                      ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntryBuf)
                    else
                      ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                        TempItemTrkgEntry,TempTrkgItemLedgEntry,true,"Document No.","Line No.");

                    ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                      TempTrkgItemLedgEntry,ToPurchLine,
                      FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                      FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",false);
                  end;
                end;
              end;
            until Next = 0;
          end;
        end;

        Window.Close;
    end;


    procedure CopyPurchReturnShptLinesToDoc(ToPurchHeader: Record "Purchase Header";var FromReturnShptLine: Record "Return Shipment Line";var LinesNotCopied: Integer;var MissingExCostRevLink: Boolean)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromPurchHeader: Record "Purchase Header";
        FromPurchLine: Record "Purchase Line";
        ToPurchLine: Record "Purchase Line";
        FromPurchLineBuf: Record "Purchase Line" temporary;
        FromReturnShptHeader: Record "Return Shipment Header";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        OldDocNo: Code[20];
        NextLineNo: Integer;
        NextItemTrkgEntryNo: Integer;
        FromLineCounter: Integer;
        ToLineCounter: Integer;
        CopyItemTrkg: Boolean;
        SplitLine: Boolean;
        FillExactCostRevLink: Boolean;
        CopyLine: Boolean;
        InsertDocNoLine: Boolean;
    begin
        MissingExCostRevLink := false;
        InitCurrency(ToPurchHeader."Currency Code");
        OpenWindow;

        with FromReturnShptLine do
          if FindSet then
            repeat
              FromLineCounter := FromLineCounter + 1;
              if IsTimeForUpdate then
                Window.Update(1,FromLineCounter);
              if FromReturnShptHeader."No." <> "Document No." then begin
                FromReturnShptHeader.Get("Document No.");
                TransferOldExtLines.ClearLineNumbers;
              end;
              FromPurchHeader.TransferFields(FromReturnShptHeader);
              FillExactCostRevLink :=
                IsPurchFillExactCostRevLink(ToPurchHeader,2,FromPurchHeader."Currency Code");
              FromPurchLine.TransferFields(FromReturnShptLine);
              FromPurchLine."Appl.-to Item Entry" := 0;

              if "Document No." <> OldDocNo then begin
                OldDocNo := "Document No.";
                InsertDocNoLine := true;
              end;

              SplitLine := true;
              FilterPstdDocLnItemLedgEntries(ItemLedgEntry);
              if not SplitPstdPurchLinesPerILE(
                   ToPurchHeader,FromPurchHeader,ItemLedgEntry,FromPurchLineBuf,
                   FromPurchLine,NextLineNo,CopyItemTrkg,MissingExCostRevLink,FillExactCostRevLink,true)
              then
                if CopyItemTrkg then
                  SplitLine :=
                    SplitPurchDocLinesPerItemTrkg(
                      ItemLedgEntry,TempItemTrkgEntry,FromPurchLineBuf,
                      FromPurchLine,NextLineNo,NextItemTrkgEntryNo,MissingExCostRevLink,true)
                else
                  SplitLine := false;

              if not SplitLine then begin
                FromPurchLineBuf := FromPurchLine;
                CopyLine := true;
              end else
                CopyLine := FromPurchLineBuf.FindSet and FillExactCostRevLink;

              Window.Update(1,FromLineCounter);
              if CopyLine then begin
                NextLineNo := GetLastToPurchLineNo(ToPurchHeader);
                if InsertDocNoLine then begin
                  InsertOldPurchDocNoLine(ToPurchHeader,"Document No.",3,NextLineNo);
                  InsertDocNoLine := false;
                end;
                repeat
                  ToLineCounter := ToLineCounter + 1;
                  if IsTimeForUpdate then
                    Window.Update(2,ToLineCounter);
                  if CopyPurchLine(ToPurchHeader,ToPurchLine,FromPurchHeader,FromPurchLineBuf,NextLineNo,LinesNotCopied,
                       false,DeferralTypeForPurchDoc(Purchdoctype::"Posted Return Shipment"),CopyPostedDeferral)
                  then
                    if CopyItemTrkg then begin
                      if SplitLine then
                        ItemTrackingDocMgt.CollectItemTrkgPerPostedDocLine(
                          TempItemTrkgEntry,TempTrkgItemLedgEntry,true,FromPurchLineBuf."Document No.",FromPurchLineBuf."Line No.")
                      else
                        ItemTrackingDocMgt.CopyItemLedgerEntriesToTemp(TempTrkgItemLedgEntry,ItemLedgEntry);

                      ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
                        TempTrkgItemLedgEntry,ToPurchLine,
                        FillExactCostRevLink and ExactCostRevMandatory,MissingExCostRevLink,
                        FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT",true);
                    end;
                until FromPurchLineBuf.Next = 0
              end;
            until Next = 0;

        Window.Close;
    end;

    local procedure CopyPurchLinesToBuffer(FromPurchHeader: Record "Purchase Header";FromPurchLine: Record "Purchase Line";var FromPurchLine2: Record "Purchase Line";var TempPurchLineBuf: Record "Purchase Line" temporary;ToPurchHeader: Record "Purchase Header";DocNo: Code[20];var NextLineNo: Integer)
    begin
        FromPurchLine2 := TempPurchLineBuf;
        TempPurchLineBuf := FromPurchLine;
        TempPurchLineBuf."Document No." := FromPurchLine2."Document No.";
        TempPurchLineBuf."Receipt Line No." := FromPurchLine2."Receipt Line No.";
        TempPurchLineBuf."Line No." := NextLineNo;
        NextLineNo := NextLineNo + 10000;
        if not IsRecalculateAmount(
             FromPurchHeader."Currency Code",ToPurchHeader."Currency Code",
             FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT")
        then
          TempPurchLineBuf."Return Shipment No." := DocNo;
        ReCalcPurchLine(FromPurchHeader,ToPurchHeader,TempPurchLineBuf);
        TempPurchLineBuf.Insert;
    end;

    local procedure SplitPstdPurchLinesPerILE(ToPurchHeader: Record "Purchase Header";FromPurchHeader: Record "Purchase Header";var ItemLedgEntry: Record "Item Ledger Entry";var FromPurchLineBuf: Record "Purchase Line";FromPurchLine: Record "Purchase Line";var NextLineNo: Integer;var CopyItemTrkg: Boolean;var MissingExCostRevLink: Boolean;FillExactCostRevLink: Boolean;FromShptOrRcpt: Boolean): Boolean
    var
        Item: Record Item;
        ApplyRec: Record "Item Application Entry";
        OrgQtyBase: Decimal;
    begin
        if FromShptOrRcpt then begin
          FromPurchLineBuf.Reset;
          FromPurchLineBuf.DeleteAll;
        end else
          FromPurchLineBuf.Init;

        CopyItemTrkg := false;

        if (FromPurchLine.Type <> FromPurchLine.Type::Item) or (FromPurchLine.Quantity = 0) or (FromPurchLine."Prod. Order No." <> '')
        then
          exit(false);

        Item.Get(FromPurchLine."No.");
        if Item.Type = Item.Type::Service then
          exit(false);

        if IsCopyItemTrkg(ItemLedgEntry,CopyItemTrkg,FillExactCostRevLink) or
           not FillExactCostRevLink or MoveNegLines or
           not ExactCostRevMandatory
        then
          exit(false);

        if FromPurchLine."Job No." <> '' then
          exit(false);

        with ItemLedgEntry do begin
          FindSet;
          if Quantity <= 0 then begin
            FromPurchLineBuf."Document No." := "Document No.";
            if GetPurchDocType(ItemLedgEntry) in
               [FromPurchLineBuf."document type"::Order,FromPurchLineBuf."document type"::"Return Order"]
            then
              FromPurchLineBuf."Receipt Line No." := 1;
            exit(false);
          end;
          OrgQtyBase := FromPurchLine."Quantity (Base)";
          repeat
            if not ApplyFully then begin
              ApplyRec.AppliedOutbndEntryExists("Entry No.",false,false);
              if ApplyRec.Find('-') then
                SkippedLine := SkippedLine or ApplyRec.Find('-');
            end;
            if ApplyFully then begin
              ApplyRec.AppliedOutbndEntryExists("Entry No.",false,false);
              if ApplyRec.Find('-') then
                repeat
                  SomeAreFixed := SomeAreFixed or ApplyRec.Fixed;
                until ApplyRec.Next = 0;
            end;

            if AskApply and ("Item Tracking" = "item tracking"::None) then
              if not ("Remaining Quantity" > 0) or ("Item Tracking" <> "item tracking"::None) then
                ConfirmApply;
            if AskApply then
              if "Remaining Quantity" < Abs(FromPurchLine."Quantity (Base)") then
                ConfirmApply;
            if ("Remaining Quantity" > 0) or ApplyFully then begin
              FromPurchLineBuf := FromPurchLine;
              if "Remaining Quantity" < Abs(FromPurchLine."Quantity (Base)") then
                if not ApplyFully then begin
                  if FromPurchLine."Quantity (Base)" > 0 then
                    FromPurchLineBuf."Quantity (Base)" := "Remaining Quantity"
                  else
                    FromPurchLineBuf."Quantity (Base)" := -"Remaining Quantity";
                  ConvertFromBase(
                    FromPurchLineBuf.Quantity,FromPurchLineBuf."Quantity (Base)",FromPurchLineBuf."Qty. per Unit of Measure");
                end else begin
                  ReappDone := true;
                  FromPurchLineBuf."Quantity (Base)" := Sign(Quantity) * Quantity - ApplyRec.Returned("Entry No.");
                  ConvertFromBase(
                    FromPurchLineBuf.Quantity,FromPurchLineBuf."Quantity (Base)",FromPurchLineBuf."Qty. per Unit of Measure");
                end;
              FromPurchLine."Quantity (Base)" := FromPurchLine."Quantity (Base)" - FromPurchLineBuf."Quantity (Base)";
              FromPurchLine.Quantity := FromPurchLine.Quantity - FromPurchLineBuf.Quantity;
              FromPurchLineBuf."Appl.-to Item Entry" := "Entry No.";
              FromPurchLineBuf."Line No." := NextLineNo;
              NextLineNo := NextLineNo + 1;
              FromPurchLineBuf."Document No." := "Document No.";
              if GetPurchDocType(ItemLedgEntry) in
                 [FromPurchLineBuf."document type"::Order,FromPurchLineBuf."document type"::"Return Order"]
              then
                FromPurchLineBuf."Receipt Line No." := 1;

              if not FromShptOrRcpt then
                UpdateRevPurchLineAmount(
                  FromPurchLineBuf,OrgQtyBase,
                  FromPurchHeader."Prices Including VAT",ToPurchHeader."Prices Including VAT");
              if FromPurchLineBuf.Quantity <> 0 then
                FromPurchLineBuf.Insert
              else
                SkippedLine := true;
            end else
              if "Remaining Quantity" = 0 then
                SkippedLine := true;
          until (Next = 0) or (FromPurchLine."Quantity (Base)" = 0);

          if (FromPurchLine."Quantity (Base)" <> 0) and FillExactCostRevLink then
            MissingExCostRevLink := true;
        end;
        CheckUnappliedLines(SkippedLine,MissingExCostRevLink);

        exit(true);
    end;

    local procedure SplitPurchDocLinesPerItemTrkg(var ItemLedgEntry: Record "Item Ledger Entry";var TempItemTrkgEntry: Record "Reservation Entry" temporary;var FromPurchLineBuf: Record "Purchase Line";FromPurchLine: Record "Purchase Line";var NextLineNo: Integer;var NextItemTrkgEntryNo: Integer;var MissingExCostRevLink: Boolean;FromShptOrRcpt: Boolean): Boolean
    var
        PurchLineBuf: array [2] of Record "Purchase Line" temporary;
        ApplyRec: Record "Item Application Entry";
        RemainingQtyBase: Decimal;
        SignFactor: Integer;
        i: Integer;
    begin
        if FromShptOrRcpt then begin
          FromPurchLineBuf.Reset;
          FromPurchLineBuf.DeleteAll;
          TempItemTrkgEntry.Reset;
          TempItemTrkgEntry.DeleteAll;
        end else
          FromPurchLineBuf.Init;

        if MoveNegLines or not ExactCostRevMandatory then
          exit(false);

        if FromPurchLine."Quantity (Base)" < 0 then
          SignFactor := -1
        else
          SignFactor := 1;

        with ItemLedgEntry do begin
          SetCurrentkey("Document No.","Document Type","Document Line No.");
          FindSet;
          repeat
            PurchLineBuf[1] := FromPurchLine;
            PurchLineBuf[1]."Line No." := NextLineNo;
            PurchLineBuf[1]."Quantity (Base)" := 0;
            PurchLineBuf[1].Quantity := 0;
            PurchLineBuf[1]."Document No." := "Document No.";
            if GetPurchDocType(ItemLedgEntry) in
               [PurchLineBuf[1]."document type"::Order,PurchLineBuf[1]."document type"::"Return Order"]
            then
              PurchLineBuf[1]."Receipt Line No." := 1;
            PurchLineBuf[2] := PurchLineBuf[1];
            PurchLineBuf[2]."Line No." := PurchLineBuf[2]."Line No." + 1;

            if not FromShptOrRcpt then begin
              SetRange("Document No.","Document No.");
              SetRange("Document Type","Document Type");
              SetRange("Document Line No.","Document Line No.");
            end;
            repeat
              i := 1;
              if Positive then
                "Remaining Quantity" :=
                  "Remaining Quantity" -
                  CalcDistributedQty(TempItemTrkgEntry,ItemLedgEntry,PurchLineBuf[2]."Line No." + 1);

              if "Document Type" in ["document type"::"Purchase Return Shipment","document type"::"Purchase Credit Memo"] then
                if -"Shipped Qty. Not Returned" < FromPurchLine."Quantity (Base)" * SignFactor then
                  RemainingQtyBase := -"Shipped Qty. Not Returned" * SignFactor
                else
                  RemainingQtyBase := FromPurchLine."Quantity (Base)"
              else
                if "Remaining Quantity" < FromPurchLine."Quantity (Base)" * SignFactor then begin
                  if ("Item Tracking" = "item tracking"::None) and AskApply then
                    ConfirmApply;
                  if (not ApplyFully) or ("Item Tracking" <> "item tracking"::None) then
                    RemainingQtyBase := GetQtyOfPurchILENotShipped("Entry No.") * SignFactor
                  else
                    RemainingQtyBase := FromPurchLine."Quantity (Base)" - ApplyRec.Returned("Entry No.");
                end else
                  RemainingQtyBase := FromPurchLine."Quantity (Base)";

              if RemainingQtyBase <> 0 then begin
                if Positive then
                  if IsSplitItemLedgEntry(ItemLedgEntry) then
                    i := 2;

                PurchLineBuf[i]."Quantity (Base)" := PurchLineBuf[i]."Quantity (Base)" + RemainingQtyBase;
                if PurchLineBuf[i]."Qty. per Unit of Measure" = 0 then
                  PurchLineBuf[i].Quantity := PurchLineBuf[i]."Quantity (Base)"
                else
                  PurchLineBuf[i].Quantity :=
                    ROUND(PurchLineBuf[i]."Quantity (Base)" / PurchLineBuf[i]."Qty. per Unit of Measure",0.00001);
                FromPurchLine."Quantity (Base)" := FromPurchLine."Quantity (Base)" - RemainingQtyBase;
                // Fill buffer with exact cost reversing link for remaining quantity
                if "Document Type" in ["document type"::"Purchase Return Shipment","document type"::"Purchase Credit Memo"] then
                  InsertTempItemTrkgEntry(
                    ItemLedgEntry,TempItemTrkgEntry,-Abs(RemainingQtyBase),
                    PurchLineBuf[i]."Line No.",NextItemTrkgEntryNo,true)
                else
                  InsertTempItemTrkgEntry(
                    ItemLedgEntry,TempItemTrkgEntry,Abs(RemainingQtyBase),
                    PurchLineBuf[i]."Line No.",NextItemTrkgEntryNo,true);
              end;
            until (Next = 0) or (FromPurchLine."Quantity (Base)" = 0);

            for i := 1 to 2 do
              if PurchLineBuf[i]."Quantity (Base)" <> 0 then begin
                FromPurchLineBuf := PurchLineBuf[i];
                FromPurchLineBuf.Insert;
                NextLineNo := PurchLineBuf[i]."Line No." + 1;
              end;

            if not FromShptOrRcpt then begin
              SetRange("Document No.");
              SetRange("Document Type");
              SetRange("Document Line No.");
            end;
          until (Next = 0) or FromShptOrRcpt;
          if (FromPurchLine."Quantity (Base)" <> 0) and Positive and TempItemTrkgEntry.IsEmpty then
            MissingExCostRevLink := true;
        end;

        exit(true);
    end;

    local procedure CalcDistributedQty(var TempItemTrkgEntry: Record "Reservation Entry" temporary;ItemLedgEntry: Record "Item Ledger Entry";NextLineNo: Integer): Decimal
    begin
        with ItemLedgEntry do begin
          TempItemTrkgEntry.Reset;
          TempItemTrkgEntry.SetCurrentkey("Source ID","Source Ref. No.");
          TempItemTrkgEntry.SetRange("Source ID","Document No.");
          TempItemTrkgEntry.SetFilter("Source Ref. No.",'<%1',NextLineNo);
          TempItemTrkgEntry.SetRange("Item Ledger Entry No.","Entry No.");
          TempItemTrkgEntry.CalcSums("Quantity (Base)");
          TempItemTrkgEntry.Reset;
          exit(TempItemTrkgEntry."Quantity (Base)");
        end;
    end;

    local procedure IsSplitItemLedgEntry(OrgItemLedgEntry: Record "Item Ledger Entry"): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        with OrgItemLedgEntry do begin
          ItemLedgEntry.SetCurrentkey("Document No.");
          ItemLedgEntry.SetRange("Document No.","Document No.");
          ItemLedgEntry.SetRange("Document Type","Document Type");
          ItemLedgEntry.SetRange("Document Line No.","Document Line No.");
          ItemLedgEntry.SetRange("Lot No.","Lot No.");
          ItemLedgEntry.SetRange("Serial No.","Serial No.");
          ItemLedgEntry.SetFilter("Entry No.",'<%1',"Entry No.");
          exit(not ItemLedgEntry.IsEmpty);
        end;
    end;

    local procedure IsCopyItemTrkg(var ItemLedgEntry: Record "Item Ledger Entry";var CopyItemTrkg: Boolean;FillExactCostRevLink: Boolean): Boolean
    begin
        with ItemLedgEntry do begin
          if IsEmpty then
            exit(true);
          SetFilter("Lot No.",'<>''''');
          if not IsEmpty then begin
            if FillExactCostRevLink then
              CopyItemTrkg := true;
            exit(true);
          end;
          SetRange("Lot No.");
          SetFilter("Serial No.",'<>''''');
          if not IsEmpty then begin
            if FillExactCostRevLink then
              CopyItemTrkg := true;
            exit(true);
          end;
          SetRange("Serial No.");
        end;
        exit(false);
    end;

    local procedure InsertTempItemTrkgEntry(ItemLedgEntry: Record "Item Ledger Entry";var TempItemTrkgEntry: Record "Reservation Entry";QtyBase: Decimal;DocLineNo: Integer;var NextEntryNo: Integer;FillExactCostRevLink: Boolean)
    begin
        if QtyBase = 0 then
          exit;

        with ItemLedgEntry do begin
          TempItemTrkgEntry.Init;
          TempItemTrkgEntry."Entry No." := NextEntryNo;
          NextEntryNo := NextEntryNo + 1;
          if not FillExactCostRevLink then
            TempItemTrkgEntry."Reservation Status" := TempItemTrkgEntry."reservation status"::Prospect;
          TempItemTrkgEntry."Source ID" := "Document No.";
          TempItemTrkgEntry."Source Ref. No." := DocLineNo;
          TempItemTrkgEntry."Item Ledger Entry No." := "Entry No.";
          TempItemTrkgEntry."Quantity (Base)" := QtyBase;
          TempItemTrkgEntry.Insert;
        end;
    end;

    local procedure GetLastToSalesLineNo(ToSalesHeader: Record "Sales Header"): Decimal
    var
        ToSalesLine: Record "Sales Line";
    begin
        ToSalesLine.LockTable;
        ToSalesLine.SetRange("Document Type",ToSalesHeader."Document Type");
        ToSalesLine.SetRange("Document No.",ToSalesHeader."No.");
        if ToSalesLine.FindLast then
          exit(ToSalesLine."Line No.");
        exit(0);
    end;

    local procedure GetLastToPurchLineNo(ToPurchHeader: Record "Purchase Header"): Decimal
    var
        ToPurchLine: Record "Purchase Line";
    begin
        ToPurchLine.LockTable;
        ToPurchLine.SetRange("Document Type",ToPurchHeader."Document Type");
        ToPurchLine.SetRange("Document No.",ToPurchHeader."No.");
        if ToPurchLine.FindLast then
          exit(ToPurchLine."Line No.");
        exit(0);
    end;

    local procedure InsertOldSalesDocNoLine(ToSalesHeader: Record "Sales Header";OldDocNo: Code[20];OldDocType: Integer;var NextLineNo: Integer)
    var
        ToSalesLine2: Record "Sales Line";
        GlobalLanguageID: Integer;
    begin
        if SkipCopyFromDescription then
          exit;

        GlobalLanguageID := SetLanguageByCode(ToSalesHeader."Language Code");

        NextLineNo := NextLineNo + 10000;
        ToSalesLine2.Init;
        ToSalesLine2."Line No." := NextLineNo;
        ToSalesLine2."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine2."Document No." := ToSalesHeader."No.";
        if InsertCancellationLine then
          ToSalesLine2.Description := StrSubstNo(CrMemoCancellationMsg,OldDocNo)
        else
          ToSalesLine2.Description := StrSubstNo(Text015,SelectStr(OldDocType,Text013),OldDocNo);

        ToSalesLine2.Insert;

        SetLanguageByID(GlobalLanguageID);
    end;

    local procedure InsertOldSalesCombDocNoLine(ToSalesHeader: Record "Sales Header";OldDocNo: Code[20];OldDocNo2: Code[20];var NextLineNo: Integer;CopyFromInvoice: Boolean)
    var
        ToSalesLine2: Record "Sales Line";
        GlobalLanguageID: Integer;
    begin
        GlobalLanguageID := SetLanguageByCode(ToSalesHeader."Language Code");

        NextLineNo := NextLineNo + 10000;
        ToSalesLine2.Init;
        ToSalesLine2."Line No." := NextLineNo;
        ToSalesLine2."Document Type" := ToSalesHeader."Document Type";
        ToSalesLine2."Document No." := ToSalesHeader."No.";
        if CopyFromInvoice then
          ToSalesLine2.Description :=
            StrSubstNo(
              Text018,
              CopyStr(SelectStr(1,Text016) + OldDocNo,1,23),
              CopyStr(SelectStr(2,Text016) + OldDocNo2,1,23))
        else
          ToSalesLine2.Description :=
            StrSubstNo(
              Text018,
              CopyStr(SelectStr(3,Text016) + OldDocNo,1,23),
              CopyStr(SelectStr(4,Text016) + OldDocNo2,1,23));
        ToSalesLine2.Insert;

        SetLanguageByID(GlobalLanguageID);
    end;

    local procedure InsertOldPurchDocNoLine(ToPurchHeader: Record "Purchase Header";OldDocNo: Code[20];OldDocType: Integer;var NextLineNo: Integer)
    var
        ToPurchLine2: Record "Purchase Line";
        GlobalLanguageID: Integer;
    begin
        if SkipCopyFromDescription then
          exit;

        GlobalLanguageID := SetLanguageByCode(ToPurchHeader."Language Code");

        NextLineNo := NextLineNo + 10000;
        ToPurchLine2.Init;
        ToPurchLine2."Line No." := NextLineNo;
        ToPurchLine2."Document Type" := ToPurchHeader."Document Type";
        ToPurchLine2."Document No." := ToPurchHeader."No.";
        if InsertCancellationLine then
          ToPurchLine2.Description := StrSubstNo(CrMemoCancellationMsg,OldDocNo)
        else
          ToPurchLine2.Description := StrSubstNo(Text015,SelectStr(OldDocType,Text014),OldDocNo);
        ToPurchLine2.Insert;

        SetLanguageByID(GlobalLanguageID);
    end;

    local procedure InsertOldPurchCombDocNoLine(ToPurchHeader: Record "Purchase Header";OldDocNo: Code[20];OldDocNo2: Code[20];var NextLineNo: Integer;CopyFromInvoice: Boolean)
    var
        ToPurchLine2: Record "Purchase Line";
        GlobalLanguageID: Integer;
    begin
        GlobalLanguageID := SetLanguageByCode(ToPurchHeader."Language Code");

        NextLineNo := NextLineNo + 10000;
        ToPurchLine2.Init;
        ToPurchLine2."Line No." := NextLineNo;
        ToPurchLine2."Document Type" := ToPurchHeader."Document Type";
        ToPurchLine2."Document No." := ToPurchHeader."No.";
        if CopyFromInvoice then
          ToPurchLine2.Description :=
            StrSubstNo(
              Text018,
              CopyStr(SelectStr(1,Text017) + OldDocNo,1,23),
              CopyStr(SelectStr(2,Text017) + OldDocNo2,1,23))
        else
          ToPurchLine2.Description :=
            StrSubstNo(
              Text018,
              CopyStr(SelectStr(3,Text017) + OldDocNo,1,23),
              CopyStr(SelectStr(4,Text017) + OldDocNo2,1,23));
        ToPurchLine2.Insert;

        SetLanguageByID(GlobalLanguageID);
    end;


    procedure IsSalesFillExactCostRevLink(ToSalesHeader: Record "Sales Header";FromDocType: Option "Sales Shipment","Sales Invoice","Sales Return Receipt","Sales Credit Memo";CurrencyCode: Code[10]): Boolean
    begin
        with ToSalesHeader do
          case FromDocType of
            Fromdoctype::"Sales Shipment":
              exit("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]);
            Fromdoctype::"Sales Invoice":
              exit(
                ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]) and
                ("Currency Code" = CurrencyCode));
            Fromdoctype::"Sales Return Receipt":
              exit("Document Type" in ["document type"::Order,"document type"::Invoice]);
            Fromdoctype::"Sales Credit Memo":
              exit(
                ("Document Type" in ["document type"::Order,"document type"::Invoice]) and
                ("Currency Code" = CurrencyCode));
          end;
        exit(false);
    end;


    procedure IsPurchFillExactCostRevLink(ToPurchHeader: Record "Purchase Header";FromDocType: Option "Purchase Receipt","Purchase Invoice","Purchase Return Shipment","Purchase Credit Memo";CurrencyCode: Code[10]): Boolean
    begin
        with ToPurchHeader do
          case FromDocType of
            Fromdoctype::"Purchase Receipt":
              exit("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]);
            Fromdoctype::"Purchase Invoice":
              exit(
                ("Document Type" in ["document type"::"Return Order","document type"::"Credit Memo"]) and
                ("Currency Code" = CurrencyCode));
            Fromdoctype::"Purchase Return Shipment":
              exit("Document Type" in ["document type"::Order,"document type"::Invoice]);
            Fromdoctype::"Purchase Credit Memo":
              exit(
                ("Document Type" in ["document type"::Order,"document type"::Invoice]) and
                ("Currency Code" = CurrencyCode));
          end;
        exit(false);
    end;

    local procedure GetSalesDocType(ItemLedgEntry: Record "Item Ledger Entry"): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        with ItemLedgEntry do
          case "Document Type" of
            "document type"::"Sales Shipment":
              exit(SalesLine."document type"::Order);
            "document type"::"Sales Invoice":
              exit(SalesLine."document type"::Invoice);
            "document type"::"Sales Credit Memo":
              exit(SalesLine."document type"::"Credit Memo");
            "document type"::"Sales Return Receipt":
              exit(SalesLine."document type"::"Return Order");
          end;
    end;

    local procedure GetPurchDocType(ItemLedgEntry: Record "Item Ledger Entry"): Integer
    var
        PurchLine: Record "Purchase Line";
    begin
        with ItemLedgEntry do
          case "Document Type" of
            "document type"::"Purchase Receipt":
              exit(PurchLine."document type"::Order);
            "document type"::"Purchase Invoice":
              exit(PurchLine."document type"::Invoice);
            "document type"::"Purchase Credit Memo":
              exit(PurchLine."document type"::"Credit Memo");
            "document type"::"Purchase Return Shipment":
              exit(PurchLine."document type"::"Return Order");
          end;
    end;

    local procedure GetItem(ItemNo: Code[20])
    begin
        if ItemNo <> Item."No." then
          if not Item.Get(ItemNo) then
            Item.Init;
    end;

    local procedure CalcVAT(var Value: Decimal;VATPercentage: Decimal;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean;RndgPrecision: Decimal)
    begin
        if (ToPricesInclVAT = FromPricesInclVAT) or (Value = 0) then
          exit;

        if ToPricesInclVAT then
          Value := ROUND(Value * (100 + VATPercentage) / 100,RndgPrecision)
        else
          Value := ROUND(Value * 100 / (100 + VATPercentage),RndgPrecision);
    end;

    local procedure ReCalcSalesLine(FromSalesHeader: Record "Sales Header";ToSalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        SalesLineAmount: Decimal;
    begin
        with ToSalesHeader do begin
          if not IsRecalculateAmount(
               FromSalesHeader."Currency Code","Currency Code",
               FromSalesHeader."Prices Including VAT","Prices Including VAT")
          then
            exit;

          if FromSalesHeader."Currency Code" <> "Currency Code" then begin
            if SalesLine.Quantity <> 0 then
              SalesLineAmount := SalesLine."Unit Price" * SalesLine.Quantity
            else
              SalesLineAmount := SalesLine."Unit Price";
            if FromSalesHeader."Currency Code" <> '' then begin
              SalesLineAmount :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                  FromSalesHeader."Posting Date",FromSalesHeader."Currency Code",
                  SalesLineAmount,FromSalesHeader."Currency Factor");
              SalesLine."Line Discount Amount" :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                  FromSalesHeader."Posting Date",FromSalesHeader."Currency Code",
                  SalesLine."Line Discount Amount",FromSalesHeader."Currency Factor");
              SalesLine."Inv. Discount Amount" :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                  FromSalesHeader."Posting Date",FromSalesHeader."Currency Code",
                  SalesLine."Inv. Discount Amount",FromSalesHeader."Currency Factor");
            end;

            if "Currency Code" <> '' then begin
              SalesLineAmount :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",SalesLineAmount,"Currency Factor");
              SalesLine."Line Discount Amount" :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",SalesLine."Line Discount Amount","Currency Factor");
              SalesLine."Inv. Discount Amount" :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",SalesLine."Inv. Discount Amount","Currency Factor");
            end;
          end;

          SalesLine."Currency Code" := "Currency Code";
          if SalesLine.Quantity <> 0 then begin
            SalesLineAmount := ROUND(SalesLineAmount,Currency."Amount Rounding Precision");
            SalesLine."Unit Price" := ROUND(SalesLineAmount / SalesLine.Quantity,Currency."Unit-Amount Rounding Precision");
          end else
            SalesLine."Unit Price" := ROUND(SalesLineAmount,Currency."Unit-Amount Rounding Precision");
          SalesLine."Line Discount Amount" := ROUND(SalesLine."Line Discount Amount",Currency."Amount Rounding Precision");
          SalesLine."Inv. Discount Amount" := ROUND(SalesLine."Inv. Discount Amount",Currency."Amount Rounding Precision");

          CalcVAT(
            SalesLine."Unit Price",SalesLine."VAT %",FromSalesHeader."Prices Including VAT",
            "Prices Including VAT",Currency."Unit-Amount Rounding Precision");
          CalcVAT(
            SalesLine."Line Discount Amount",SalesLine."VAT %",FromSalesHeader."Prices Including VAT",
            "Prices Including VAT",Currency."Amount Rounding Precision");
          CalcVAT(
            SalesLine."Inv. Discount Amount",SalesLine."VAT %",FromSalesHeader."Prices Including VAT",
            "Prices Including VAT",Currency."Amount Rounding Precision");
        end;
    end;

    local procedure ReCalcPurchLine(FromPurchHeader: Record "Purchase Header";ToPurchHeader: Record "Purchase Header";var PurchLine: Record "Purchase Line")
    var
        CurrExchRate: Record "Currency Exchange Rate";
        PurchLineAmount: Decimal;
    begin
        with ToPurchHeader do begin
          if not IsRecalculateAmount(
               FromPurchHeader."Currency Code","Currency Code",
               FromPurchHeader."Prices Including VAT","Prices Including VAT")
          then
            exit;

          if FromPurchHeader."Currency Code" <> "Currency Code" then begin
            if PurchLine.Quantity <> 0 then
              PurchLineAmount := PurchLine."Direct Unit Cost" * PurchLine.Quantity
            else
              PurchLineAmount := PurchLine."Direct Unit Cost";
            if FromPurchHeader."Currency Code" <> '' then begin
              PurchLineAmount :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                  FromPurchHeader."Posting Date",FromPurchHeader."Currency Code",
                  PurchLineAmount,FromPurchHeader."Currency Factor");
              PurchLine."Line Discount Amount" :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                  FromPurchHeader."Posting Date",FromPurchHeader."Currency Code",
                  PurchLine."Line Discount Amount",FromPurchHeader."Currency Factor");
              PurchLine."Inv. Discount Amount" :=
                CurrExchRate.ExchangeAmtFCYToLCY(
                  FromPurchHeader."Posting Date",FromPurchHeader."Currency Code",
                  PurchLine."Inv. Discount Amount",FromPurchHeader."Currency Factor");
            end;

            if "Currency Code" <> '' then begin
              PurchLineAmount :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",PurchLineAmount,"Currency Factor");
              PurchLine."Line Discount Amount" :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",PurchLine."Line Discount Amount","Currency Factor");
              PurchLine."Inv. Discount Amount" :=
                CurrExchRate.ExchangeAmtLCYToFCY(
                  "Posting Date","Currency Code",PurchLine."Inv. Discount Amount","Currency Factor");
            end;
          end;

          PurchLine."Currency Code" := "Currency Code";
          if PurchLine.Quantity <> 0 then begin
            PurchLineAmount := ROUND(PurchLineAmount,Currency."Amount Rounding Precision");
            PurchLine."Direct Unit Cost" := ROUND(PurchLineAmount / PurchLine.Quantity,Currency."Unit-Amount Rounding Precision");
          end else
            PurchLine."Direct Unit Cost" := ROUND(PurchLineAmount,Currency."Unit-Amount Rounding Precision");
          PurchLine."Line Discount Amount" := ROUND(PurchLine."Line Discount Amount",Currency."Amount Rounding Precision");
          PurchLine."Inv. Discount Amount" := ROUND(PurchLine."Inv. Discount Amount",Currency."Amount Rounding Precision");

          CalcVAT(
            PurchLine."Direct Unit Cost",PurchLine."VAT %",FromPurchHeader."Prices Including VAT",
            "Prices Including VAT",Currency."Unit-Amount Rounding Precision");
          CalcVAT(
            PurchLine."Line Discount Amount",PurchLine."VAT %",FromPurchHeader."Prices Including VAT",
            "Prices Including VAT",Currency."Amount Rounding Precision");
          CalcVAT(
            PurchLine."Inv. Discount Amount",PurchLine."VAT %",FromPurchHeader."Prices Including VAT",
            "Prices Including VAT",Currency."Amount Rounding Precision");
        end;
    end;

    local procedure IsRecalculateAmount(FromCurrencyCode: Code[10];ToCurrencyCode: Code[10];FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean): Boolean
    begin
        exit(
          (FromCurrencyCode <> ToCurrencyCode) or
          (FromPricesInclVAT <> ToPricesInclVAT));
    end;

    local procedure UpdateRevSalesLineAmount(var SalesLine: Record "Sales Line";OrgQtyBase: Decimal;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean)
    var
        Amount: Decimal;
    begin
        if (OrgQtyBase = 0) or (SalesLine.Quantity = 0) or
           ((FromPricesInclVAT = ToPricesInclVAT) and (OrgQtyBase = SalesLine."Quantity (Base)"))
        then
          exit;

        Amount := SalesLine.Quantity * SalesLine."Unit Price";
        CalcVAT(
          Amount,SalesLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
        SalesLine."Unit Price" := Amount / SalesLine.Quantity;
        SalesLine."Line Discount Amount" :=
          ROUND(
            ROUND(SalesLine.Quantity * SalesLine."Unit Price",Currency."Amount Rounding Precision") *
            SalesLine."Line Discount %" / 100,
            Currency."Amount Rounding Precision");
        Amount :=
          ROUND(SalesLine."Inv. Discount Amount" / OrgQtyBase * SalesLine."Quantity (Base)",Currency."Amount Rounding Precision");
        CalcVAT(
          Amount,SalesLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
        SalesLine."Inv. Discount Amount" := Amount;
    end;


    procedure CalculateRevSalesLineAmount(var SalesLine: Record "Sales Line";OrgQtyBase: Decimal;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean)
    var
        UnitPrice: Decimal;
        LineDiscAmt: Decimal;
        InvDiscAmt: Decimal;
    begin
        UpdateRevSalesLineAmount(SalesLine,OrgQtyBase,FromPricesInclVAT,ToPricesInclVAT);

        UnitPrice := SalesLine."Unit Price";
        LineDiscAmt := SalesLine."Line Discount Amount";
        InvDiscAmt := SalesLine."Inv. Discount Amount";

        SalesLine.Validate("Unit Price",UnitPrice);
        SalesLine.Validate("Line Discount Amount",LineDiscAmt);
        SalesLine.Validate("Inv. Discount Amount",InvDiscAmt);
    end;

    local procedure UpdateRevPurchLineAmount(var PurchLine: Record "Purchase Line";OrgQtyBase: Decimal;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean)
    var
        Amount: Decimal;
    begin
        if (OrgQtyBase = 0) or (PurchLine.Quantity = 0) or
           ((FromPricesInclVAT = ToPricesInclVAT) and (OrgQtyBase = PurchLine."Quantity (Base)"))
        then
          exit;

        Amount := PurchLine.Quantity * PurchLine."Direct Unit Cost";
        CalcVAT(
          Amount,PurchLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
        PurchLine."Direct Unit Cost" := Amount / PurchLine.Quantity;
        PurchLine."Line Discount Amount" :=
          ROUND(
            ROUND(PurchLine.Quantity * PurchLine."Direct Unit Cost",Currency."Amount Rounding Precision") *
            PurchLine."Line Discount %" / 100,
            Currency."Amount Rounding Precision");
        Amount :=
          ROUND(PurchLine."Inv. Discount Amount" / OrgQtyBase * PurchLine."Quantity (Base)",Currency."Amount Rounding Precision");
        CalcVAT(
          Amount,PurchLine."VAT %",FromPricesInclVAT,ToPricesInclVAT,Currency."Amount Rounding Precision");
        PurchLine."Inv. Discount Amount" := Amount;
    end;


    procedure CalculateRevPurchLineAmount(var PurchLine: Record "Purchase Line";OrgQtyBase: Decimal;FromPricesInclVAT: Boolean;ToPricesInclVAT: Boolean)
    var
        DirectUnitCost: Decimal;
        LineDiscAmt: Decimal;
        InvDiscAmt: Decimal;
    begin
        UpdateRevPurchLineAmount(PurchLine,OrgQtyBase,FromPricesInclVAT,ToPricesInclVAT);

        DirectUnitCost := PurchLine."Direct Unit Cost";
        LineDiscAmt := PurchLine."Line Discount Amount";
        InvDiscAmt := PurchLine."Inv. Discount Amount";

        PurchLine.Validate("Direct Unit Cost",DirectUnitCost);
        PurchLine.Validate("Line Discount Amount",LineDiscAmt);
        PurchLine.Validate("Inv. Discount Amount",InvDiscAmt);
    end;

    local procedure InitCurrency(CurrencyCode: Code[10])
    begin
        if CurrencyCode <> '' then
          Currency.Get(CurrencyCode)
        else
          Currency.InitRoundingPrecision;

        Currency.TestField("Unit-Amount Rounding Precision");
        Currency.TestField("Amount Rounding Precision");
    end;

    local procedure OpenWindow()
    begin
        Window.Open(
          Text022 +
          Text023 +
          Text024);
        WindowUpdateDateTime := CurrentDatetime;
    end;

    local procedure IsTimeForUpdate(): Boolean
    begin
        if CurrentDatetime - WindowUpdateDateTime >= 1000 then begin
          WindowUpdateDateTime := CurrentDatetime;
          exit(true);
        end;
        exit(false);
    end;

    local procedure ConfirmApply()
    begin
        AskApply := false;
        ApplyFully := false;
    end;

    local procedure ConvertFromBase(var Quantity: Decimal;QuantityBase: Decimal;QtyPerUOM: Decimal)
    begin
        if QtyPerUOM = 0 then
          Quantity := QuantityBase
        else
          Quantity :=
            ROUND(QuantityBase / QtyPerUOM,0.00001);
    end;

    local procedure Sign(Quantity: Decimal): Decimal
    begin
        if Quantity < 0 then
          exit(-1);
        exit(1);
    end;


    procedure ShowMessageReapply(OriginalQuantity: Boolean)
    var
        Text: Text[1024];
    begin
        Text := '';
        if SkippedLine then
          Text := Text029;
        if OriginalQuantity and ReappDone then
          if Text = '' then
            Text := Text025;
        if SomeAreFixed then
          Message(Text031);
        if Text <> '' then
          Message(Text);
    end;

    local procedure LinkJobPlanningLine(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        JobPlanningLine: Record "Job Planning Line";
        JobPlanningLineInvoice: Record "Job Planning Line Invoice";
    begin
        JobPlanningLine.SetCurrentkey("Job Contract Entry No.");
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        repeat
          JobPlanningLine.SetRange("Job Contract Entry No.",SalesLine."Job Contract Entry No.");
          if JobPlanningLine.FindFirst then begin
            JobPlanningLineInvoice."Job No." := JobPlanningLine."Job No.";
            JobPlanningLineInvoice."Job Task No." := JobPlanningLine."Job Task No.";
            JobPlanningLineInvoice."Job Planning Line No." := JobPlanningLine."Line No.";
            case SalesHeader."Document Type" of
              SalesHeader."document type"::Invoice:
                begin
                  JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."document type"::Invoice;
                  JobPlanningLineInvoice."Quantity Transferred" := SalesLine.Quantity;
                end;
              SalesHeader."document type"::"Credit Memo":
                begin
                  JobPlanningLineInvoice."Document Type" := JobPlanningLineInvoice."document type"::"Credit Memo";
                  JobPlanningLineInvoice."Quantity Transferred" := -SalesLine.Quantity;
                end;
              else
                exit;
            end;
            JobPlanningLineInvoice."Document No." := SalesHeader."No.";
            JobPlanningLineInvoice."Line No." := SalesLine."Line No.";
            JobPlanningLineInvoice."Transferred Date" := SalesHeader."Posting Date";
            JobPlanningLineInvoice.Insert;

            JobPlanningLine.UpdateQtyToTransfer;
            JobPlanningLine.Modify;
          end;
        until SalesLine.Next = 0;
    end;

    local procedure GetQtyOfPurchILENotShipped(ItemLedgerEntryNo: Integer): Decimal
    var
        ItemApplicationEntry: Record "Item Application Entry";
        ItemLedgerEntryLocal: Record "Item Ledger Entry";
        QtyNotShipped: Decimal;
    begin
        QtyNotShipped := 0;
        with ItemApplicationEntry do begin
          Reset;
          SetCurrentkey("Inbound Item Entry No.","Outbound Item Entry No.");
          SetRange("Inbound Item Entry No.",ItemLedgerEntryNo);
          SetRange("Outbound Item Entry No.",0);
          if not FindFirst then
            exit(QtyNotShipped);
          QtyNotShipped := Quantity;
          SetFilter("Outbound Item Entry No.",'<>0');
          if not FindSet(false,false) then
            exit(QtyNotShipped);
          repeat
            ItemLedgerEntryLocal.Get("Outbound Item Entry No.");
            if (ItemLedgerEntryLocal."Entry Type" in
                [ItemLedgerEntryLocal."entry type"::Sale,
                 ItemLedgerEntryLocal."entry type"::Purchase]) or
               ((ItemLedgerEntryLocal."Entry Type" in
                 [ItemLedgerEntryLocal."entry type"::"Positive Adjmt.",ItemLedgerEntryLocal."entry type"::"Negative Adjmt."]) and
                (ItemLedgerEntryLocal."Job No." = ''))
            then
              QtyNotShipped += Quantity;
          until Next = 0;
        end;
        exit(QtyNotShipped);
    end;

    local procedure CopyAsmOrderToAsmOrder(var TempFromAsmHeader: Record "Assembly Header" temporary;var TempFromAsmLine: Record "Assembly Line" temporary;ToSalesLine: Record "Sales Line";ToAsmHeaderDocType: Integer;ToAsmHeaderDocNo: Code[20];InclAsmHeader: Boolean)
    var
        FromAsmHeader: Record "Assembly Header";
        ToAsmHeader: Record "Assembly Header";
        TempToAsmHeader: Record "Assembly Header" temporary;
        AssembleToOrderLink: Record "Assemble-to-Order Link";
        ToAsmLine: Record "Assembly Line";
        BasicAsmOrderCopy: Boolean;
    begin
        if ToAsmHeaderDocType = -1 then
          exit;
        BasicAsmOrderCopy := ToAsmHeaderDocNo <> '';
        if BasicAsmOrderCopy then
          ToAsmHeader.Get(ToAsmHeaderDocType,ToAsmHeaderDocNo)
        else begin
          if ToSalesLine.AsmToOrderExists(FromAsmHeader) then
            exit;
          Clear(ToAsmHeader);
          AssembleToOrderLink.InsertAsmHeader(ToAsmHeader,ToAsmHeaderDocType,'');
          InclAsmHeader := true;
        end;

        if InclAsmHeader then begin
          if BasicAsmOrderCopy then begin
            TempToAsmHeader := ToAsmHeader;
            TempToAsmHeader.Insert;
            ProcessToAsmHeader(TempToAsmHeader,TempFromAsmHeader,ToSalesLine,true,true); // Basic, Availabilitycheck
            CheckAsmOrderAvailability(TempToAsmHeader,TempFromAsmLine,ToSalesLine);
          end;
          ProcessToAsmHeader(ToAsmHeader,TempFromAsmHeader,ToSalesLine,BasicAsmOrderCopy,false);
        end else
          if BasicAsmOrderCopy then
            CheckAsmOrderAvailability(ToAsmHeader,TempFromAsmLine,ToSalesLine);
        CreateToAsmLines(ToAsmHeader,TempFromAsmLine,ToAsmLine,ToSalesLine,BasicAsmOrderCopy,false);
        if not BasicAsmOrderCopy then
          with AssembleToOrderLink do begin
            "Assembly Document Type" := ToAsmHeader."Document Type";
            "Assembly Document No." := ToAsmHeader."No.";
            Type := Type::Sale;
            "Document Type" := ToSalesLine."Document Type";
            "Document No." := ToSalesLine."Document No.";
            "Document Line No." := ToSalesLine."Line No.";
            Insert;
            if ToSalesLine."Document Type" = ToSalesLine."document type"::Order then begin
              if ToSalesLine."Shipment Date" = 0D then begin
                ToSalesLine."Shipment Date" := ToAsmHeader."Due Date";
                ToSalesLine.Modify;
              end;
              ReserveAsmToSale(ToSalesLine,ToSalesLine.Quantity,ToSalesLine."Quantity (Base)");
            end;
          end;

        ToAsmHeader.ShowDueDateBeforeWorkDateMsg;
    end;


    procedure CopyAsmHeaderToAsmHeader(FromAsmHeader: Record "Assembly Header";ToAsmHeader: Record "Assembly Header";IncludeHeader: Boolean)
    var
        EmptyToSalesLine: Record "Sales Line";
    begin
        InitialToAsmHeaderCheck(ToAsmHeader,IncludeHeader);
        GenerateAsmDataFromNonPosted(FromAsmHeader);
        Clear(EmptyToSalesLine);
        EmptyToSalesLine.Init;
        CopyAsmOrderToAsmOrder(TempAsmHeader,TempAsmLine,EmptyToSalesLine,ToAsmHeader."Document Type",ToAsmHeader."No.",IncludeHeader);
    end;


    procedure CopyPostedAsmHeaderToAsmHeader(PostedAsmHeader: Record "Posted Assembly Header";ToAsmHeader: Record "Assembly Header";IncludeHeader: Boolean)
    var
        EmptyToSalesLine: Record "Sales Line";
    begin
        InitialToAsmHeaderCheck(ToAsmHeader,IncludeHeader);
        GenerateAsmDataFromPosted(PostedAsmHeader,0);
        Clear(EmptyToSalesLine);
        EmptyToSalesLine.Init;
        CopyAsmOrderToAsmOrder(TempAsmHeader,TempAsmLine,EmptyToSalesLine,ToAsmHeader."Document Type",ToAsmHeader."No.",IncludeHeader);
    end;

    local procedure GenerateAsmDataFromNonPosted(AsmHeader: Record "Assembly Header")
    var
        AsmLine: Record "Assembly Line";
    begin
        InitAsmCopyHandling(false);
        TempAsmHeader := AsmHeader;
        TempAsmHeader.Insert;
        AsmLine.SetRange("Document Type",AsmHeader."Document Type");
        AsmLine.SetRange("Document No.",AsmHeader."No.");
        if AsmLine.FindSet then
          repeat
            TempAsmLine := AsmLine;
            TempAsmLine.Insert;
          until AsmLine.Next = 0;
    end;

    local procedure GenerateAsmDataFromPosted(PostedAsmHeader: Record "Posted Assembly Header";DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order")
    var
        PostedAsmLine: Record "Posted Assembly Line";
    begin
        InitAsmCopyHandling(false);
        TempAsmHeader.TransferFields(PostedAsmHeader);
        case DocType of
          Doctype::Quote:
            TempAsmHeader."Document Type" := TempAsmHeader."document type"::Quote;
          Doctype::Order:
            TempAsmHeader."Document Type" := TempAsmHeader."document type"::Order;
          Doctype::"Blanket Order":
            TempAsmHeader."Document Type" := TempAsmHeader."document type"::"Blanket Order";
          else
            exit;
        end;
        TempAsmHeader.Insert;
        PostedAsmLine.SetRange("Document No.",PostedAsmHeader."No.");
        if PostedAsmLine.FindSet then
          repeat
            TempAsmLine.TransferFields(PostedAsmLine);
            TempAsmLine."Document No." := TempAsmHeader."No.";
            TempAsmLine."Cost Amount" := PostedAsmLine.Quantity * PostedAsmLine."Unit Cost";
            TempAsmLine.Insert;
          until PostedAsmLine.Next = 0;
    end;

    local procedure GetAsmDataFromSalesInvLine(DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"): Boolean
    var
        ValueEntry: Record "Value Entry";
        ValueEntry2: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesShipmentLine: Record "Sales Shipment Line";
    begin
        Clear(PostedAsmHeader);
        if TempSalesInvLine.Type <> TempSalesInvLine.Type::Item then
          exit(false);
        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.",TempSalesInvLine."Document No.");
        ValueEntry.SetRange("Document Type",ValueEntry."document type"::"Sales Invoice");
        ValueEntry.SetRange("Document Line No.",TempSalesInvLine."Line No.");
        if not ValueEntry.FindFirst then
          exit(false);
        if not ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.") then
          exit(false);
        if ItemLedgerEntry."Document Type" <> ItemLedgerEntry."document type"::"Sales Shipment" then
          exit(false);
        SalesShipmentLine.Get(ItemLedgerEntry."Document No.",ItemLedgerEntry."Document Line No.");
        if not SalesShipmentLine.AsmToShipmentExists(PostedAsmHeader) then
          exit(false);
        if ValueEntry.Count > 1 then begin
          ValueEntry2.Copy(ValueEntry);
          ValueEntry2.SetFilter("Item Ledger Entry No.",'<>%1',ValueEntry."Item Ledger Entry No.");
          if not ValueEntry2.IsEmpty then
            Error(Text032,TempSalesInvLine."Document No.");
        end;
        GenerateAsmDataFromPosted(PostedAsmHeader,DocType);
        exit(true);
    end;


    procedure InitAsmCopyHandling(ResetQuantities: Boolean)
    begin
        if ResetQuantities then begin
          QtyToAsmToOrder := 0;
          QtyToAsmToOrderBase := 0;
        end;
        TempAsmHeader.DeleteAll;
        TempAsmLine.DeleteAll;
    end;

    local procedure RetrieveSalesInvLine(SalesLine: Record "Sales Line";PosNo: Integer;LineCountsEqual: Boolean): Boolean
    begin
        if not LineCountsEqual then
          exit(false);
        TempSalesInvLine.FindSet;
        if PosNo > 1 then
          TempSalesInvLine.Next(PosNo - 1);
        exit((SalesLine.Type = TempSalesInvLine.Type) and (SalesLine."No." = TempSalesInvLine."No."));
    end;


    procedure InitialToAsmHeaderCheck(ToAsmHeader: Record "Assembly Header";IncludeHeader: Boolean)
    begin
        ToAsmHeader.TestField("No.");
        if IncludeHeader then begin
          ToAsmHeader.TestField("Item No.",'');
          ToAsmHeader.TestField(Quantity,0);
        end else begin
          ToAsmHeader.TestField("Item No.");
          ToAsmHeader.TestField(Quantity);
        end;
    end;

    local procedure GetAsmOrderType(SalesLineDocType: Option Quote,"Order",,,"Blanket Order"): Integer
    begin
        if SalesLineDocType in [Saleslinedoctype::Quote,Saleslinedoctype::Order,Saleslinedoctype::"Blanket Order"] then
          exit(SalesLineDocType);
        exit(-1);
    end;

    local procedure ProcessToAsmHeader(var ToAsmHeader: Record "Assembly Header";TempFromAsmHeader: Record "Assembly Header" temporary;ToSalesLine: Record "Sales Line";BasicAsmOrderCopy: Boolean;AvailabilityCheck: Boolean)
    begin
        with ToAsmHeader do begin
          if AvailabilityCheck then begin
            "Item No." := TempFromAsmHeader."Item No.";
            "Location Code" := TempFromAsmHeader."Location Code";
            "Variant Code" := TempFromAsmHeader."Variant Code";
            "Unit of Measure Code" := TempFromAsmHeader."Unit of Measure Code";
          end else begin
            Validate("Item No.",TempFromAsmHeader."Item No.");
            Validate("Location Code",TempFromAsmHeader."Location Code");
            Validate("Variant Code",TempFromAsmHeader."Variant Code");
            Validate("Unit of Measure Code",TempFromAsmHeader."Unit of Measure Code");
          end;
          if BasicAsmOrderCopy then begin
            Validate("Due Date",TempFromAsmHeader."Due Date");
            Quantity := TempFromAsmHeader.Quantity;
            "Quantity (Base)" := TempFromAsmHeader."Quantity (Base)";
          end else begin
            if ToSalesLine."Shipment Date" <> 0D then
              Validate("Due Date",ToSalesLine."Shipment Date");
            Quantity := QtyToAsmToOrder;
            "Quantity (Base)" := QtyToAsmToOrderBase;
          end;
          "Unit Cost" := TempFromAsmHeader."Unit Cost";
          RoundQty(Quantity);
          RoundQty("Quantity (Base)");
          "Cost Amount" := ROUND(Quantity * "Unit Cost");
          InitRemainingQty;
          InitQtyToAssemble;
          if not AvailabilityCheck then begin
            Validate("Quantity to Assemble");
            Validate("Planning Flexibility",TempFromAsmHeader."Planning Flexibility");
          end;
          Modify;
        end;
    end;

    local procedure CreateToAsmLines(ToAsmHeader: Record "Assembly Header";var FromAsmLine: Record "Assembly Line";var ToAssemblyLine: Record "Assembly Line";ToSalesLine: Record "Sales Line";BasicAsmOrderCopy: Boolean;AvailabilityCheck: Boolean)
    var
        AssemblyLineMgt: Codeunit "Assembly Line Management";
        UOMMgt: Codeunit "Unit of Measure Management";
    begin
        if FromAsmLine.FindSet then
          repeat
            ToAssemblyLine.Init;
            ToAssemblyLine."Document Type" := ToAsmHeader."Document Type";
            ToAssemblyLine."Document No." := ToAsmHeader."No.";
            ToAssemblyLine."Line No." := AssemblyLineMgt.GetNextAsmLineNo(ToAssemblyLine,AvailabilityCheck);
            ToAssemblyLine.Insert(not AvailabilityCheck);
            if AvailabilityCheck then begin
              ToAssemblyLine.Type := FromAsmLine.Type;
              ToAssemblyLine."No." := FromAsmLine."No.";
              ToAssemblyLine."Resource Usage Type" := FromAsmLine."Resource Usage Type";
              ToAssemblyLine."Unit of Measure Code" := FromAsmLine."Unit of Measure Code";
              ToAssemblyLine."Quantity per" := FromAsmLine."Quantity per";
              ToAssemblyLine.Quantity := GetAppliedQuantityForAsmLine(BasicAsmOrderCopy,ToAsmHeader,FromAsmLine,ToSalesLine);
            end else begin
              ToAssemblyLine.Validate(Type,FromAsmLine.Type);
              ToAssemblyLine.Validate("No.",FromAsmLine."No.");
              ToAssemblyLine.Validate("Resource Usage Type",FromAsmLine."Resource Usage Type");
              ToAssemblyLine.Validate("Unit of Measure Code",FromAsmLine."Unit of Measure Code");
              if ToAssemblyLine.Type <> ToAssemblyLine.Type::" " then
                ToAssemblyLine.Validate("Quantity per",FromAsmLine."Quantity per");
              ToAssemblyLine.Validate(Quantity,GetAppliedQuantityForAsmLine(BasicAsmOrderCopy,ToAsmHeader,FromAsmLine,ToSalesLine));
            end;
            ToAssemblyLine.ValidateDueDate(ToAsmHeader,ToAsmHeader."Starting Date",false);
            ToAssemblyLine.ValidateLeadTimeOffset(ToAsmHeader,FromAsmLine."Lead-Time Offset",false);
            ToAssemblyLine.Description := FromAsmLine.Description;
            ToAssemblyLine."Description 2" := FromAsmLine."Description 2";
            ToAssemblyLine.Position := FromAsmLine.Position;
            ToAssemblyLine."Position 2" := FromAsmLine."Position 2";
            ToAssemblyLine."Position 3" := FromAsmLine."Position 3";
            if ToAssemblyLine.Type <> ToAssemblyLine.Type::" " then begin
              ToAssemblyLine.Validate("Unit Cost",FromAsmLine."Unit Cost");
              if AvailabilityCheck then begin
                with ToAssemblyLine do begin
                  "Quantity (Base)" := UOMMgt.CalcBaseQty(Quantity,"Qty. per Unit of Measure");
                  "Remaining Quantity" := "Quantity (Base)";
                  "Quantity to Consume" := ToAsmHeader."Quantity to Assemble" * FromAsmLine."Quantity per";
                  "Quantity to Consume (Base)" := UOMMgt.CalcBaseQty("Quantity to Consume","Qty. per Unit of Measure");
                end;
              end else
                ToAssemblyLine.Validate("Quantity to Consume",ToAsmHeader."Quantity to Assemble" * FromAsmLine."Quantity per");
            end;
            if ToAssemblyLine.Type = ToAssemblyLine.Type::Item then
              if AvailabilityCheck then begin
                ToAssemblyLine."Location Code" := FromAsmLine."Location Code";
                ToAssemblyLine."Variant Code" := FromAsmLine."Variant Code";
              end else begin
                ToAssemblyLine.Validate("Location Code",FromAsmLine."Location Code");
                ToAssemblyLine.Validate("Variant Code",FromAsmLine."Variant Code");
              end;
            ToAssemblyLine.Modify(not AvailabilityCheck);
          until FromAsmLine.Next = 0;
    end;

    local procedure CheckAsmOrderAvailability(ToAsmHeader: Record "Assembly Header";var FromAsmLine: Record "Assembly Line";ToSalesLine: Record "Sales Line")
    var
        TempToAsmHeader: Record "Assembly Header" temporary;
        TempToAsmLine: Record "Assembly Line" temporary;
        AsmLineOnDestinationOrder: Record "Assembly Line";
        AssemblyLineMgt: Codeunit "Assembly Line Management";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        LineNo: Integer;
    begin
        TempToAsmHeader := ToAsmHeader;
        TempToAsmHeader.Insert;
        CreateToAsmLines(TempToAsmHeader,FromAsmLine,TempToAsmLine,ToSalesLine,true,true);
        if TempToAsmLine.FindLast then
          LineNo := TempToAsmLine."Line No.";
        Clear(TempToAsmLine);
        with AsmLineOnDestinationOrder do begin
          SetRange("Document Type",ToAsmHeader."Document Type");
          SetRange("Document No.",ToAsmHeader."No.");
          SetRange(Type,Type::Item);
        end;
        if AsmLineOnDestinationOrder.FindSet then
          repeat
            TempToAsmLine := AsmLineOnDestinationOrder;
            LineNo += 10000;
            TempToAsmLine."Line No." := LineNo;
            TempToAsmLine.Insert;
          until AsmLineOnDestinationOrder.Next = 0;
        if AssemblyLineMgt.ShowAvailability(false,TempToAsmHeader,TempToAsmLine) then
          ItemCheckAvail.RaiseUpdateInterruptedError;
        TempToAsmLine.DeleteAll;
    end;

    local procedure GetAppliedQuantityForAsmLine(BasicAsmOrderCopy: Boolean;ToAsmHeader: Record "Assembly Header";TempFromAsmLine: Record "Assembly Line" temporary;ToSalesLine: Record "Sales Line"): Decimal
    begin
        if BasicAsmOrderCopy then
          exit(ToAsmHeader.Quantity * TempFromAsmLine."Quantity per");
        case ToSalesLine."Document Type" of
          ToSalesLine."document type"::Order:
            exit(ToSalesLine."Qty. to Assemble to Order" * TempFromAsmLine."Quantity per");
          ToSalesLine."document type"::Quote,
          ToSalesLine."document type"::"Blanket Order":
            exit(ToSalesLine.Quantity * TempFromAsmLine."Quantity per");
        end;
    end;

    local procedure CopyDocLines(RecalculateAmount: Boolean;ToPurchLine: Record "Purchase Line";var FromPurchLine: Record "Purchase Line")
    begin
        if not RecalculateAmount then
          exit;
        if (ToPurchLine.Type <> ToPurchLine.Type::" ") and (ToPurchLine."No." <> '') then begin
          ToPurchLine.Validate("Line Discount %",FromPurchLine."Line Discount %");
          ToPurchLine.Validate(
            "Inv. Discount Amount",
            ROUND(FromPurchLine."Inv. Discount Amount",Currency."Amount Rounding Precision"));
        end;
    end;

    local procedure CheckCreditLimit(FromSalesHeader: Record "Sales Header";ToSalesHeader: Record "Sales Header")
    begin
        if SkipTestCreditLimit then
          exit;

        if IncludeHeader then
          CustCheckCreditLimit.SalesHeaderCheck(FromSalesHeader)
        else
          CustCheckCreditLimit.SalesHeaderCheck(ToSalesHeader);
    end;

    local procedure CheckUnappliedLines(SkippedLine: Boolean;var MissingExCostRevLink: Boolean)
    begin
        if SkippedLine and MissingExCostRevLink then begin
          if not WarningDone then
            Message(Text030);
          MissingExCostRevLink := false;
          WarningDone := true;
        end;
    end;

    local procedure SetDefaultValuesToSalesLine(var ToSalesLine: Record "Sales Line";ToSalesHeader: Record "Sales Header";VATDifference: Decimal)
    begin
        if ToSalesLine."Document Type" <> ToSalesLine."document type"::Order then begin
          ToSalesLine."Prepayment %" := 0;
          ToSalesLine."Prepayment VAT %" := 0;
          ToSalesLine."Prepmt. VAT Calc. Type" := 0;
          ToSalesLine."Prepayment VAT Identifier" := '';
          ToSalesLine."Prepayment VAT %" := 0;
          ToSalesLine."Prepayment Tax Group Code" := '';
          ToSalesLine."Prepmt. Line Amount" := 0;
          ToSalesLine."Prepmt. Amt. Incl. VAT" := 0;
        end;
        ToSalesLine."Prepmt. Amt. Inv." := 0;
        ToSalesLine."Prepmt. Amount Inv. (LCY)" := 0;
        ToSalesLine."Prepayment Amount" := 0;
        ToSalesLine."Prepmt. VAT Base Amt." := 0;
        ToSalesLine."Prepmt Amt to Deduct" := 0;
        ToSalesLine."Prepmt Amt Deducted" := 0;
        ToSalesLine."Prepmt. Amount Inv. Incl. VAT" := 0;
        ToSalesLine."Prepayment VAT Difference" := 0;
        ToSalesLine."Prepmt VAT Diff. to Deduct" := 0;
        ToSalesLine."Prepmt VAT Diff. Deducted" := 0;
        ToSalesLine."Prepmt. Amt. Incl. VAT" := 0;
        ToSalesLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
        ToSalesLine."Quantity Shipped" := 0;
        ToSalesLine."Qty. Shipped (Base)" := 0;
        ToSalesLine."Return Qty. Received" := 0;
        ToSalesLine."Return Qty. Received (Base)" := 0;
        ToSalesLine."Quantity Invoiced" := 0;
        ToSalesLine."Qty. Invoiced (Base)" := 0;
        ToSalesLine."Reserved Quantity" := 0;
        ToSalesLine."Reserved Qty. (Base)" := 0;
        ToSalesLine."Qty. to Ship" := 0;
        ToSalesLine."Qty. to Ship (Base)" := 0;
        ToSalesLine."Return Qty. to Receive" := 0;
        ToSalesLine."Return Qty. to Receive (Base)" := 0;
        ToSalesLine."Qty. to Invoice" := 0;
        ToSalesLine."Qty. to Invoice (Base)" := 0;
        ToSalesLine."Qty. Shipped Not Invoiced" := 0;
        ToSalesLine."Return Qty. Rcd. Not Invd." := 0;
        ToSalesLine."Shipped Not Invoiced" := 0;
        ToSalesLine."Return Rcd. Not Invd." := 0;
        ToSalesLine."Qty. Shipped Not Invd. (Base)" := 0;
        ToSalesLine."Ret. Qty. Rcd. Not Invd.(Base)" := 0;
        ToSalesLine."Shipped Not Invoiced (LCY)" := 0;
        ToSalesLine."Return Rcd. Not Invd. (LCY)" := 0;
        ToSalesLine."Job No." := '';
        ToSalesLine."Job Task No." := '';
        ToSalesLine."Job Contract Entry No." := 0;
        if ToSalesLine."Document Type" in
           [ToSalesLine."document type"::"Blanket Order",
            ToSalesLine."document type"::"Credit Memo",
            ToSalesLine."document type"::"Return Order"]
        then begin
          ToSalesLine."Blanket Order No." := '';
          ToSalesLine."Blanket Order Line No." := 0;
        end;
        ToSalesLine.InitOutstanding;
        if ToSalesLine."Document Type" in
           [ToSalesLine."document type"::"Return Order",ToSalesLine."document type"::"Credit Memo"]
        then
          ToSalesLine.InitQtyToReceive
        else
          ToSalesLine.InitQtyToShip;
        ToSalesLine."VAT Difference" := VATDifference;
        ToSalesLine."Shipment No." := '';
        ToSalesLine."Shipment Line No." := 0;
        if not CreateToHeader and RecalculateLines then
          ToSalesLine."Shipment Date" := ToSalesHeader."Shipment Date";
        ToSalesLine."Appl.-from Item Entry" := 0;
        ToSalesLine."Appl.-to Item Entry" := 0;

        ToSalesLine."Purchase Order No." := '';
        ToSalesLine."Purch. Order Line No." := 0;
        ToSalesLine."Special Order Purchase No." := '';
        ToSalesLine."Special Order Purch. Line No." := 0;
    end;

    local procedure SetDefaultValuesToPurchLine(var ToPurchLine: Record "Purchase Line";ToPurchHeader: Record "Purchase Header";VATDifference: Decimal)
    begin
        if ToPurchLine."Document Type" <> ToPurchLine."document type"::Order then begin
          ToPurchLine."Prepayment %" := 0;
          ToPurchLine."Prepayment VAT %" := 0;
          ToPurchLine."Prepmt. VAT Calc. Type" := 0;
          ToPurchLine."Prepayment VAT Identifier" := '';
          ToPurchLine."Prepayment VAT %" := 0;
          ToPurchLine."Prepayment Tax Group Code" := '';
          ToPurchLine."Prepmt. Line Amount" := 0;
          ToPurchLine."Prepmt. Amt. Incl. VAT" := 0;
        end;
        ToPurchLine."Prepmt. Amt. Inv." := 0;
        ToPurchLine."Prepmt. Amount Inv. (LCY)" := 0;
        ToPurchLine."Prepayment Amount" := 0;
        ToPurchLine."Prepmt. VAT Base Amt." := 0;
        ToPurchLine."Prepmt Amt to Deduct" := 0;
        ToPurchLine."Prepmt Amt Deducted" := 0;
        ToPurchLine."Prepmt. Amount Inv. Incl. VAT" := 0;
        ToPurchLine."Prepayment VAT Difference" := 0;
        ToPurchLine."Prepmt VAT Diff. to Deduct" := 0;
        ToPurchLine."Prepmt VAT Diff. Deducted" := 0;
        ToPurchLine."Prepmt. Amt. Incl. VAT" := 0;
        ToPurchLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
        ToPurchLine."Quantity Received" := 0;
        ToPurchLine."Qty. Received (Base)" := 0;
        ToPurchLine."Return Qty. Shipped" := 0;
        ToPurchLine."Return Qty. Shipped (Base)" := 0;
        ToPurchLine."Quantity Invoiced" := 0;
        ToPurchLine."Qty. Invoiced (Base)" := 0;
        ToPurchLine."Reserved Quantity" := 0;
        ToPurchLine."Reserved Qty. (Base)" := 0;
        ToPurchLine."Qty. Rcd. Not Invoiced" := 0;
        ToPurchLine."Qty. Rcd. Not Invoiced (Base)" := 0;
        ToPurchLine."Return Qty. Shipped Not Invd." := 0;
        ToPurchLine."Ret. Qty. Shpd Not Invd.(Base)" := 0;
        ToPurchLine."Qty. to Receive" := 0;
        ToPurchLine."Qty. to Receive (Base)" := 0;
        ToPurchLine."Return Qty. to Ship" := 0;
        ToPurchLine."Return Qty. to Ship (Base)" := 0;
        ToPurchLine."Qty. to Invoice" := 0;
        ToPurchLine."Qty. to Invoice (Base)" := 0;
        ToPurchLine."Amt. Rcd. Not Invoiced" := 0;
        ToPurchLine."Amt. Rcd. Not Invoiced (LCY)" := 0;
        ToPurchLine."Return Shpd. Not Invd." := 0;
        ToPurchLine."Return Shpd. Not Invd. (LCY)" := 0;
        if ToPurchLine."Document Type" in
           [ToPurchLine."document type"::"Blanket Order",
            ToPurchLine."document type"::"Credit Memo",
            ToPurchLine."document type"::"Return Order"]
        then begin
          ToPurchLine."Blanket Order No." := '';
          ToPurchLine."Blanket Order Line No." := 0;
        end;

        ToPurchLine.InitOutstanding;
        if ToPurchLine."Document Type" in
           [ToPurchLine."document type"::"Return Order",ToPurchLine."document type"::"Credit Memo"]
        then
          ToPurchLine.InitQtyToShip
        else
          ToPurchLine.InitQtyToReceive;
        ToPurchLine."VAT Difference" := VATDifference;
        ToPurchLine."Receipt No." := '';
        ToPurchLine."Receipt Line No." := 0;
        if not CreateToHeader then
          ToPurchLine."Expected Receipt Date" := ToPurchHeader."Expected Receipt Date";
        ToPurchLine."Appl.-to Item Entry" := 0;

        ToPurchLine."Sales Order No." := '';
        ToPurchLine."Sales Order Line No." := 0;
        ToPurchLine."Special Order Sales No." := '';
        ToPurchLine."Special Order Sales Line No." := 0;
    end;

    local procedure CopyItemTrackingEntries(SalesLine: Record "Sales Line";var PurchLine: Record "Purchase Line";SalesPricesIncludingVAT: Boolean;PurchPricesIncludingVAT: Boolean)
    var
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        TrackingSpecification: Record "Tracking Specification";
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        MissingExCostRevLink: Boolean;
    begin
        FindTrackingEntries(
          TempItemLedgerEntry,Database::"Sales Line",TrackingSpecification."source subtype"::"5",
          SalesLine."Document No.",'',0,SalesLine."Line No.",SalesLine."No.");
        ItemTrackingMgt.CopyItemLedgEntryTrkgToPurchLn(
          TempItemLedgerEntry,PurchLine,false,MissingExCostRevLink,
          SalesPricesIncludingVAT,PurchPricesIncludingVAT,true);
    end;

    local procedure FindTrackingEntries(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary;Type: Integer;Subtype: Integer;ID: Code[20];BatchName: Code[10];ProdOrderLine: Integer;RefNo: Integer;ItemNo: Code[20])
    var
        TrackingSpecification: Record "Tracking Specification";
    begin
        with TrackingSpecification do begin
          SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
            "Source Prod. Order Line","Source Ref. No.");
          SetRange("Source ID",ID);
          SetRange("Source Ref. No.",RefNo);
          SetRange("Source Type",Type);
          SetRange("Source Subtype",Subtype);
          SetRange("Source Batch Name",BatchName);
          SetRange("Source Prod. Order Line",ProdOrderLine);
          SetRange("Item No.",ItemNo);
          if FindSet then
            repeat
              AddItemLedgerEntry(TempItemLedgerEntry,"Lot No.","Serial No.","Entry No.");
            until Next = 0;
        end;
    end;

    local procedure AddItemLedgerEntry(var TempItemLedgerEntry: Record "Item Ledger Entry" temporary;LotNo: Code[20];SerialNo: Code[20];EntryNo: Integer)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if (LotNo = '') and (SerialNo = '') then
          exit;

        if not ItemLedgerEntry.Get(EntryNo) then
          exit;

        TempItemLedgerEntry := ItemLedgerEntry;
        if TempItemLedgerEntry.Insert then;
    end;

    local procedure CopyFieldsFromOldSalesHeader(var ToSalesHeader: Record "Sales Header";OldSalesHeader: Record "Sales Header")
    begin
        with ToSalesHeader do begin
          "No. Series" := OldSalesHeader."No. Series";
          "Posting Description" := OldSalesHeader."Posting Description";
          "Posting No." := OldSalesHeader."Posting No.";
          "Posting No. Series" := OldSalesHeader."Posting No. Series";
          "Shipping No." := OldSalesHeader."Shipping No.";
          "Shipping No. Series" := OldSalesHeader."Shipping No. Series";
          "Return Receipt No." := OldSalesHeader."Return Receipt No.";
          "Return Receipt No. Series" := OldSalesHeader."Return Receipt No. Series";
          "Prepayment No. Series" := OldSalesHeader."Prepayment No. Series";
          "Prepayment No." := OldSalesHeader."Prepayment No.";
          "Prepmt. Posting Description" := OldSalesHeader."Prepmt. Posting Description";
          "Prepmt. Cr. Memo No. Series" := OldSalesHeader."Prepmt. Cr. Memo No. Series";
          "Prepmt. Cr. Memo No." := OldSalesHeader."Prepmt. Cr. Memo No.";
          "Prepmt. Posting Description" := OldSalesHeader."Prepmt. Posting Description";
        end
    end;

    local procedure CopyFieldsFromOldPurchHeader(var ToPurchHeader: Record "Purchase Header";OldPurchHeader: Record "Purchase Header")
    begin
        with ToPurchHeader do begin
          "No. Series" := OldPurchHeader."No. Series";
          "Posting Description" := OldPurchHeader."Posting Description";
          "Posting No." := OldPurchHeader."Posting No.";
          "Posting No. Series" := OldPurchHeader."Posting No. Series";
          "Receiving No." := OldPurchHeader."Receiving No.";
          "Receiving No. Series" := OldPurchHeader."Receiving No. Series";
          "Return Shipment No." := OldPurchHeader."Return Shipment No.";
          "Return Shipment No. Series" := OldPurchHeader."Return Shipment No. Series";
          "Prepayment No. Series" := OldPurchHeader."Prepayment No. Series";
          "Prepayment No." := OldPurchHeader."Prepayment No.";
          "Prepmt. Posting Description" := OldPurchHeader."Prepmt. Posting Description";
          "Prepmt. Cr. Memo No. Series" := OldPurchHeader."Prepmt. Cr. Memo No. Series";
          "Prepmt. Cr. Memo No." := OldPurchHeader."Prepmt. Cr. Memo No.";
          "Prepmt. Posting Description" := OldPurchHeader."Prepmt. Posting Description";
        end;
    end;

    local procedure CheckFromSalesHeader(SalesHeaderFrom: Record "Sales Header";SalesHeaderTo: Record "Sales Header")
    begin
        with SalesHeaderTo do begin
          SalesHeaderFrom.TestField("Sell-to Customer No.","Sell-to Customer No.");
          SalesHeaderFrom.TestField("Bill-to Customer No.","Bill-to Customer No.");
          SalesHeaderFrom.TestField("Customer Posting Group","Customer Posting Group");
          SalesHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          SalesHeaderFrom.TestField("Currency Code","Currency Code");
          SalesHeaderFrom.TestField("Prices Including VAT","Prices Including VAT");
        end;
    end;

    local procedure CheckFromSalesShptHeader(SalesShipmentHeaderFrom: Record "Sales Shipment Header";SalesHeaderTo: Record "Sales Header")
    begin
        with SalesHeaderTo do begin
          SalesShipmentHeaderFrom.TestField("Sell-to Customer No.","Sell-to Customer No.");
          SalesShipmentHeaderFrom.TestField("Bill-to Customer No.","Bill-to Customer No.");
          SalesShipmentHeaderFrom.TestField("Customer Posting Group","Customer Posting Group");
          SalesShipmentHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          SalesShipmentHeaderFrom.TestField("Currency Code","Currency Code");
          SalesShipmentHeaderFrom.TestField("Prices Including VAT","Prices Including VAT");
        end;
    end;

    local procedure CheckFromSalesInvHeader(SalesInvoiceHeaderFrom: Record "Sales Invoice Header";SalesHeaderTo: Record "Sales Header")
    begin
        with SalesHeaderTo do begin
          SalesInvoiceHeaderFrom.TestField("Sell-to Customer No.","Sell-to Customer No.");
          SalesInvoiceHeaderFrom.TestField("Bill-to Customer No.","Bill-to Customer No.");
          SalesInvoiceHeaderFrom.TestField("Customer Posting Group","Customer Posting Group");
          SalesInvoiceHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          SalesInvoiceHeaderFrom.TestField("Currency Code","Currency Code");
          SalesInvoiceHeaderFrom.TestField("Prices Including VAT","Prices Including VAT");
        end;
    end;

    local procedure CheckFromSalesReturnRcptHeader(ReturnReceiptHeaderFrom: Record "Return Receipt Header";SalesHeaderTo: Record "Sales Header")
    begin
        with SalesHeaderTo do begin
          ReturnReceiptHeaderFrom.TestField("Sell-to Customer No.","Sell-to Customer No.");
          ReturnReceiptHeaderFrom.TestField("Bill-to Customer No.","Bill-to Customer No.");
          ReturnReceiptHeaderFrom.TestField("Customer Posting Group","Customer Posting Group");
          ReturnReceiptHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          ReturnReceiptHeaderFrom.TestField("Currency Code","Currency Code");
          ReturnReceiptHeaderFrom.TestField("Prices Including VAT","Prices Including VAT");
        end;
    end;

    local procedure CheckFromSalesCrMemoHeader(SalesCrMemoHeaderFrom: Record "Sales Cr.Memo Header";SalesHeaderTo: Record "Sales Header")
    begin
        with SalesHeaderTo do begin
          SalesCrMemoHeaderFrom.TestField("Sell-to Customer No.","Sell-to Customer No.");
          SalesCrMemoHeaderFrom.TestField("Bill-to Customer No.","Bill-to Customer No.");
          SalesCrMemoHeaderFrom.TestField("Customer Posting Group","Customer Posting Group");
          SalesCrMemoHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          SalesCrMemoHeaderFrom.TestField("Currency Code","Currency Code");
          SalesCrMemoHeaderFrom.TestField("Prices Including VAT","Prices Including VAT");
        end;
    end;

    local procedure CheckFromPurchaseHeader(PurchaseHeaderFrom: Record "Purchase Header";PurchaseHeaderTo: Record "Purchase Header")
    begin
        with PurchaseHeaderTo do begin
          PurchaseHeaderFrom.TestField("Buy-from Vendor No.","Buy-from Vendor No.");
          PurchaseHeaderFrom.TestField("Pay-to Vendor No.","Pay-to Vendor No.");
          PurchaseHeaderFrom.TestField("Vendor Posting Group","Vendor Posting Group");
          PurchaseHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          PurchaseHeaderFrom.TestField("Currency Code","Currency Code");
        end;
    end;

    local procedure CheckFromPurchaseRcptHeader(PurchRcptHeaderFrom: Record "Purch. Rcpt. Header";PurchaseHeaderTo: Record "Purchase Header")
    begin
        with PurchaseHeaderTo do begin
          PurchRcptHeaderFrom.TestField("Buy-from Vendor No.","Buy-from Vendor No.");
          PurchRcptHeaderFrom.TestField("Pay-to Vendor No.","Pay-to Vendor No.");
          PurchRcptHeaderFrom.TestField("Vendor Posting Group","Vendor Posting Group");
          PurchRcptHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          PurchRcptHeaderFrom.TestField("Currency Code","Currency Code");
        end;
    end;

    local procedure CheckFromPurchaseInvHeader(PurchInvHeaderFrom: Record "Purch. Inv. Header";PurchaseHeaderTo: Record "Purchase Header")
    begin
        with PurchaseHeaderTo do begin
          PurchInvHeaderFrom.TestField("Buy-from Vendor No.","Buy-from Vendor No.");
          PurchInvHeaderFrom.TestField("Pay-to Vendor No.","Pay-to Vendor No.");
          PurchInvHeaderFrom.TestField("Vendor Posting Group","Vendor Posting Group");
          PurchInvHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          PurchInvHeaderFrom.TestField("Currency Code","Currency Code");
        end;
    end;

    local procedure CheckFromPurchaseReturnShptHeader(ReturnShipmentHeaderFrom: Record "Return Shipment Header";PurchaseHeaderTo: Record "Purchase Header")
    begin
        with PurchaseHeaderTo do begin
          ReturnShipmentHeaderFrom.TestField("Buy-from Vendor No.","Buy-from Vendor No.");
          ReturnShipmentHeaderFrom.TestField("Pay-to Vendor No.","Pay-to Vendor No.");
          ReturnShipmentHeaderFrom.TestField("Vendor Posting Group","Vendor Posting Group");
          ReturnShipmentHeaderFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          ReturnShipmentHeaderFrom.TestField("Currency Code","Currency Code");
        end;
    end;

    local procedure CheckFromPurchaseCrMemoHeader(PurchCrMemoHdrFrom: Record "Purch. Cr. Memo Hdr.";PurchaseHeaderTo: Record "Purchase Header")
    begin
        with PurchaseHeaderTo do begin
          PurchCrMemoHdrFrom.TestField("Buy-from Vendor No.","Buy-from Vendor No.");
          PurchCrMemoHdrFrom.TestField("Pay-to Vendor No.","Pay-to Vendor No.");
          PurchCrMemoHdrFrom.TestField("Vendor Posting Group","Vendor Posting Group");
          PurchCrMemoHdrFrom.TestField("Gen. Bus. Posting Group","Gen. Bus. Posting Group");
          PurchCrMemoHdrFrom.TestField("Currency Code","Currency Code");
        end;
    end;

    local procedure CopyDeferrals(DeferralDocType: Integer;FromDocType: Integer;FromDocNo: Code[20];FromLineNo: Integer;ToDocType: Integer;ToDocNo: Code[20];ToLineNo: Integer) StartDate: Date
    var
        FromDeferralHeader: Record "Deferral Header";
        FromDeferralLine: Record "Deferral Line";
        ToDeferralHeader: Record "Deferral Header";
        ToDeferralLine: Record "Deferral Line";
        SalesCommentLine: Record "Sales Comment Line";
    begin
        StartDate := 0D;
        if FromDeferralHeader.Get(
             DeferralDocType,'','',
             FromDocType,FromDocNo,FromLineNo)
        then begin
          RemoveDefaultDeferralCode(DeferralDocType,ToDocType,ToDocNo,ToLineNo);
          ToDeferralHeader.Init;
          ToDeferralHeader.TransferFields(FromDeferralHeader);
          ToDeferralHeader."Document Type" := ToDocType;
          ToDeferralHeader."Document No." := ToDocNo;
          ToDeferralHeader."Line No." := ToLineNo;
          ToDeferralHeader.Insert;
          FromDeferralLine.SetRange("Deferral Doc. Type",DeferralDocType);
          FromDeferralLine.SetRange("Gen. Jnl. Template Name",'');
          FromDeferralLine.SetRange("Gen. Jnl. Batch Name",'');
          FromDeferralLine.SetRange("Document Type",FromDocType);
          FromDeferralLine.SetRange("Document No.",FromDocNo);
          FromDeferralLine.SetRange("Line No.",FromLineNo);
          if FromDeferralLine.FindSet then
            with ToDeferralLine do
              repeat
                Init;
                TransferFields(FromDeferralLine);
                "Document Type" := ToDocType;
                "Document No." := ToDocNo;
                "Line No." := ToLineNo;
                Insert;
              until FromDeferralLine.Next = 0;
          if ToDocType = SalesCommentLine."document type"::"Return Order" then
            StartDate := FromDeferralHeader."Start Date"
        end;
    end;

    local procedure CopyPostedDeferrals(DeferralDocType: Integer;FromDocType: Integer;FromDocNo: Code[20];FromLineNo: Integer;ToDocType: Integer;ToDocNo: Code[20];ToLineNo: Integer) StartDate: Date
    var
        PostedDeferralHeader: Record "Posted Deferral Header";
        PostedDeferralLine: Record "Posted Deferral Line";
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        SalesCommentLine: Record "Sales Comment Line";
        InitialAmountToDefer: Decimal;
    begin
        StartDate := 0D;
        if PostedDeferralHeader.Get(DeferralDocType,'','',
             FromDocType,FromDocNo,FromLineNo)
        then begin
          RemoveDefaultDeferralCode(DeferralDocType,ToDocType,ToDocNo,ToLineNo);
          InitialAmountToDefer := 0;
          DeferralHeader.Init;
          DeferralHeader.TransferFields(PostedDeferralHeader);
          DeferralHeader."Document Type" := ToDocType;
          DeferralHeader."Document No." := ToDocNo;
          DeferralHeader."Line No." := ToLineNo;
          DeferralHeader.Insert;
          PostedDeferralLine.SetRange("Deferral Doc. Type",DeferralDocType);
          PostedDeferralLine.SetRange("Gen. Jnl. Document No.",'');
          PostedDeferralLine.SetRange("Account No.",'');
          PostedDeferralLine.SetRange("Document Type",FromDocType);
          PostedDeferralLine.SetRange("Document No.",FromDocNo);
          PostedDeferralLine.SetRange("Line No.",FromLineNo);
          if PostedDeferralLine.FindSet then
            with DeferralLine do
              repeat
                Init;
                TransferFields(PostedDeferralLine);
                "Document Type" := ToDocType;
                "Document No." := ToDocNo;
                "Line No." := ToLineNo;
                if PostedDeferralLine."Amount (LCY)" <> 0.0 then
                  InitialAmountToDefer := InitialAmountToDefer + PostedDeferralLine."Amount (LCY)"
                else
                  InitialAmountToDefer := InitialAmountToDefer + PostedDeferralLine.Amount;
                Insert;
              until PostedDeferralLine.Next = 0;
          if ToDocType = SalesCommentLine."document type"::"Return Order" then
            StartDate := PostedDeferralHeader."Start Date";
          if DeferralHeader.Get(DeferralDocType,'','',ToDocType,ToDocNo,ToLineNo) then begin
            DeferralHeader."Initial Amount to Defer" := InitialAmountToDefer;
            DeferralHeader.Modify;
          end;
        end;
    end;

    local procedure IsDeferralToBeCopied(DeferralDocType: Integer;ToDocType: Option;FromDocType: Option): Boolean
    var
        SalesLine: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        PurchLine: Record "Purchase Line";
        PurchCommentLine: Record "Purch. Comment Line";
        DeferralHeader: Record "Deferral Header";
    begin
        if DeferralDocType = DeferralHeader."deferral doc. type"::Sales then
          case ToDocType of
            SalesLine."document type"::Order,
            SalesLine."document type"::Invoice,
            SalesLine."document type"::"Credit Memo",
            SalesLine."document type"::"Return Order":
              case FromDocType of
                SalesCommentLine."document type"::Order,
                SalesCommentLine."document type"::Invoice,
                SalesCommentLine."document type"::"Credit Memo",
                SalesCommentLine."document type"::"Return Order",
                SalesCommentLine."document type"::"Posted Invoice",
                SalesCommentLine."document type"::"Posted Credit Memo":
                  exit(true)
              end;
          end
        else
          if DeferralDocType = DeferralHeader."deferral doc. type"::Purchase then
            case ToDocType of
              PurchLine."document type"::Order,
              PurchLine."document type"::Invoice,
              PurchLine."document type"::"Credit Memo",
              PurchLine."document type"::"Return Order":
                case FromDocType of
                  PurchCommentLine."document type"::Order,
                  PurchCommentLine."document type"::Invoice,
                  PurchCommentLine."document type"::"Credit Memo",
                  PurchCommentLine."document type"::"Return Order",
                  PurchCommentLine."document type"::"Posted Invoice",
                  PurchCommentLine."document type"::"Posted Credit Memo":
                    exit(true)
                end;
            end;

        exit(false);
    end;

    local procedure IsDeferralToBeDefaulted(DeferralDocType: Integer;ToDocType: Option;FromDocType: Option): Boolean
    var
        SalesLine: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        PurchLine: Record "Purchase Line";
        PurchCommentLine: Record "Purch. Comment Line";
        DeferralHeader: Record "Deferral Header";
    begin
        if DeferralDocType = DeferralHeader."deferral doc. type"::Sales then
          case ToDocType of
            SalesLine."document type"::Order,
            SalesLine."document type"::Invoice,
            SalesLine."document type"::"Credit Memo",
            SalesLine."document type"::"Return Order":
              case FromDocType of
                SalesCommentLine."document type"::Quote,
                SalesCommentLine."document type"::"Blanket Order",
                SalesCommentLine."document type"::Shipment,
                SalesCommentLine."document type"::"Posted Return Receipt":
                  exit(true)
              end;
          end
        else
          if DeferralDocType = DeferralHeader."deferral doc. type"::Purchase then
            case ToDocType of
              PurchLine."document type"::Order,
              PurchLine."document type"::Invoice,
              PurchLine."document type"::"Credit Memo",
              PurchLine."document type"::"Return Order":
                case FromDocType of
                  PurchCommentLine."document type"::Quote,
                  PurchCommentLine."document type"::"Blanket Order",
                  PurchCommentLine."document type"::Receipt,
                  PurchCommentLine."document type"::"Posted Return Shipment":
                    exit(true)
                end;
            end;

        exit(false);
    end;

    local procedure IsDeferralPosted(DeferralDocType: Integer;FromDocType: Option): Boolean
    var
        SalesCommentLine: Record "Sales Comment Line";
        PurchCommentLine: Record "Purch. Comment Line";
        DeferralHeader: Record "Deferral Header";
    begin
        if DeferralDocType = DeferralHeader."deferral doc. type"::Sales then
          case FromDocType of
            SalesCommentLine."document type"::Shipment,
            SalesCommentLine."document type"::"Posted Invoice",
            SalesCommentLine."document type"::"Posted Credit Memo",
            SalesCommentLine."document type"::"Posted Return Receipt":
              exit(true);
          end
        else
          if DeferralDocType = DeferralHeader."deferral doc. type"::Purchase then
            case FromDocType of
              PurchCommentLine."document type"::Receipt,
              PurchCommentLine."document type"::"Posted Invoice",
              PurchCommentLine."document type"::"Posted Credit Memo",
              PurchCommentLine."document type"::"Posted Return Shipment":
                exit(true);
            end;

        exit(false);
    end;

    local procedure InitSalesDeferralCode(var ToSalesLine: Record "Sales Line")
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
        Resource: Record Resource;
    begin
        case ToSalesLine."Document Type" of
          ToSalesLine."document type"::Order,
          ToSalesLine."document type"::Invoice,
          ToSalesLine."document type"::"Credit Memo",
          ToSalesLine."document type"::"Return Order":
            case ToSalesLine.Type of
              ToSalesLine.Type::"G/L Account":
                begin
                  GLAccount.Get(ToSalesLine."No.");
                  ToSalesLine.Validate("Deferral Code",GLAccount."Default Deferral Template Code");
                end;
              ToSalesLine.Type::Item:
                begin
                  Item.Get(ToSalesLine."No.");
                  ToSalesLine.Validate("Deferral Code",Item."Default Deferral Template Code");
                end;
              ToSalesLine.Type::Resource:
                begin
                  Resource.Get(ToSalesLine."No.");
                  ToSalesLine.Validate("Deferral Code",Resource."Default Deferral Template Code");
                end;
            end;
        end;
    end;

    local procedure InitFromSalesLine2(var FromSalesLine2: Record "Sales Line";var FromSalesLineBuf: Record "Sales Line")
    begin
        // Empty buffer fields
        FromSalesLine2 := FromSalesLineBuf;
        FromSalesLine2."Shipment No." := '';
        FromSalesLine2."Shipment Line No." := 0;
        FromSalesLine2."Return Receipt No." := '';
        FromSalesLine2."Return Receipt Line No." := 0;
    end;

    local procedure RemoveDefaultDeferralCode(DeferralDocType: Integer;DocType: Integer;DocNo: Code[20];LineNo: Integer)
    var
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
    begin
        if DeferralHeader.Get(DeferralDocType,'','',DocType,DocNo,LineNo) then
          DeferralHeader.Delete;

        DeferralLine.SetRange("Deferral Doc. Type",DeferralDocType);
        DeferralLine.SetRange("Gen. Jnl. Template Name",'');
        DeferralLine.SetRange("Gen. Jnl. Batch Name",'');
        DeferralLine.SetRange("Document Type",DocType);
        DeferralLine.SetRange("Document No.",DocNo);
        DeferralLine.SetRange("Line No.",LineNo);
        DeferralLine.DeleteAll;
    end;


    procedure DeferralTypeForSalesDoc(DocType: Option): Integer
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        case DocType of
          Salesdoctype::Quote:
            exit(SalesCommentLine."document type"::Quote);
          Salesdoctype::"Blanket Order":
            exit(SalesCommentLine."document type"::"Blanket Order");
          Salesdoctype::Order:
            exit(SalesCommentLine."document type"::Order);
          Salesdoctype::Invoice:
            exit(SalesCommentLine."document type"::Invoice);
          Salesdoctype::"Return Order":
            exit(SalesCommentLine."document type"::"Return Order");
          Salesdoctype::"Credit Memo":
            exit(SalesCommentLine."document type"::"Credit Memo");
          Salesdoctype::"Posted Shipment":
            exit(SalesCommentLine."document type"::Shipment);
          Salesdoctype::"Posted Invoice":
            exit(SalesCommentLine."document type"::"Posted Invoice");
          Salesdoctype::"Posted Return Receipt":
            exit(SalesCommentLine."document type"::"Posted Return Receipt");
          Salesdoctype::"Posted Credit Memo":
            exit(SalesCommentLine."document type"::"Posted Credit Memo");
        end;
    end;


    procedure DeferralTypeForPurchDoc(DocType: Option): Integer
    var
        PurchCommentLine: Record "Purch. Comment Line";
    begin
        case DocType of
          Purchdoctype::Quote:
            exit(PurchCommentLine."document type"::Quote);
          Purchdoctype::"Blanket Order":
            exit(PurchCommentLine."document type"::"Blanket Order");
          Purchdoctype::Order:
            exit(PurchCommentLine."document type"::Order);
          Purchdoctype::Invoice:
            exit(PurchCommentLine."document type"::Invoice);
          Purchdoctype::"Return Order":
            exit(PurchCommentLine."document type"::"Return Order");
          Purchdoctype::"Credit Memo":
            exit(PurchCommentLine."document type"::"Credit Memo");
          Purchdoctype::"Posted Receipt":
            exit(PurchCommentLine."document type"::Receipt);
          Purchdoctype::"Posted Invoice":
            exit(PurchCommentLine."document type"::"Posted Invoice");
          Purchdoctype::"Posted Return Shipment":
            exit(PurchCommentLine."document type"::"Posted Return Shipment");
          Purchdoctype::"Posted Credit Memo":
            exit(PurchCommentLine."document type"::"Posted Credit Memo");
        end;
    end;

    local procedure InitPurchDeferralCode(var ToPurchLine: Record "Purchase Line")
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
    begin
        case ToPurchLine."Document Type" of
          ToPurchLine."document type"::Order,
          ToPurchLine."document type"::Invoice,
          ToPurchLine."document type"::"Credit Memo",
          ToPurchLine."document type"::"Return Order":
            case ToPurchLine.Type of
              ToPurchLine.Type::"G/L Account":
                begin
                  GLAccount.Get(ToPurchLine."No.");
                  ToPurchLine.Validate("Deferral Code",GLAccount."Default Deferral Template Code");
                end;
              ToPurchLine.Type::Item:
                begin
                  Item.Get(ToPurchLine."No.");
                  ToPurchLine.Validate("Deferral Code",Item."Default Deferral Template Code");
                end;
            end;
        end;
    end;

    local procedure CopySalesPostedDeferrals(ToSalesLine: Record "Sales Line";DeferralDocType: Integer;FromDocType: Integer;FromDocNo: Code[20];FromLineNo: Integer;ToDocType: Integer;ToDocNo: Code[20];ToLineNo: Integer)
    begin
        ToSalesLine."Returns Deferral Start Date" :=
          CopyPostedDeferrals(DeferralDocType,
            FromDocType,FromDocNo,FromLineNo,
            ToDocType,ToDocNo,ToLineNo);
        ToSalesLine.Modify;
    end;

    local procedure CopyPurchPostedDeferrals(ToPurchaseLine: Record "Purchase Line";DeferralDocType: Integer;FromDocType: Integer;FromDocNo: Code[20];FromLineNo: Integer;ToDocType: Integer;ToDocNo: Code[20];ToLineNo: Integer)
    begin
        ToPurchaseLine."Returns Deferral Start Date" :=
          CopyPostedDeferrals(DeferralDocType,
            FromDocType,FromDocNo,FromLineNo,
            ToDocType,ToDocNo,ToLineNo);
        ToPurchaseLine.Modify;
    end;

    local procedure SalesCalcSalesTaxLines(ToSalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if RecalculateLines then
          SalesLine.CalcSalesTaxLines(ToSalesHeader,SalesLine);
    end;

    local procedure PurchCalcSalesTaxLines(ToPurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        if RecalculateLines then
          PurchaseLine.CalcSalesTaxLines(ToPurchaseHeader,PurchaseLine);
    end;

    local procedure CheckDateOrder(PostingNo: Code[20];PostingNoSeries: Code[10];OldPostingDate: Date;NewPostingDate: Date): Boolean
    var
        NoSeries: Record "No. Series";
    begin
        if IncludeHeader then
          if (PostingNo <> '') and (OldPostingDate <> NewPostingDate) then
            if NoSeries.Get(PostingNoSeries) then
              if NoSeries."Date Order" then
                exit(Confirm(DiffPostDateOrderQst));
        exit(true)
    end;

    local procedure CheckSalesDocItselfCopy(FromSalesHeader: Record "Sales Header";ToSalesHeader: Record "Sales Header")
    begin
        if (FromSalesHeader."Document Type" = ToSalesHeader."Document Type") and
           (FromSalesHeader."No." = ToSalesHeader."No.")
        then
          Error(Text001,ToSalesHeader."Document Type",ToSalesHeader."No.");
    end;

    local procedure CheckPurchDocItselfCopy(FromPurchHeader: Record "Purchase Header";ToPurchHeader: Record "Purchase Header")
    begin
        if (FromPurchHeader."Document Type" = ToPurchHeader."Document Type") and
           (FromPurchHeader."No." = ToPurchHeader."No.")
        then
          Error(Text001,ToPurchHeader."Document Type",ToPurchHeader."No.");
    end;

    local procedure UpdateCustLedgEntry(var ToSalesHeader: Record "Sales Header";FromDocType: Option;FromDocNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentkey("Document No.");
        if FromDocType = Salesdoctype::"Posted Invoice" then
          CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::Invoice)
        else
          CustLedgEntry.SetRange("Document Type",CustLedgEntry."document type"::"Credit Memo");
        CustLedgEntry.SetRange("Document No.",FromDocNo);
        CustLedgEntry.SetRange("Customer No.",ToSalesHeader."Bill-to Customer No.");
        CustLedgEntry.SetRange(Open,true);
        if CustLedgEntry.FindFirst then begin
          if FromDocType = Salesdoctype::"Posted Invoice" then begin
            ToSalesHeader."Applies-to Doc. Type" := ToSalesHeader."applies-to doc. type"::Invoice;
            ToSalesHeader."Applies-to Doc. No." := FromDocNo;
          end else begin
            ToSalesHeader."Applies-to Doc. Type" := ToSalesHeader."applies-to doc. type"::"Credit Memo";
            ToSalesHeader."Applies-to Doc. No." := FromDocNo;
          end;
          CustLedgEntry.CalcFields("Remaining Amount");
          CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
          CustLedgEntry."Accepted Payment Tolerance" := 0;
          CustLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
          Codeunit.Run(Codeunit::"Cust. Entry-Edit",CustLedgEntry);
        end;
    end;


    procedure UpdateVendLedgEntry(var ToPurchHeader: Record "Purchase Header";FromDocType: Option;FromDocNo: Code[20])
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        VendLedgEntry.SetCurrentkey("Document No.");
        if FromDocType = Purchdoctype::"Posted Invoice" then
          VendLedgEntry.SetRange("Document Type",VendLedgEntry."document type"::Invoice)
        else
          VendLedgEntry.SetRange("Document Type",VendLedgEntry."document type"::"Credit Memo");
        VendLedgEntry.SetRange("Document No.",FromDocNo);
        VendLedgEntry.SetRange("Vendor No.",ToPurchHeader."Pay-to Vendor No.");
        VendLedgEntry.SetRange(Open,true);
        if VendLedgEntry.FindFirst then begin
          if FromDocType = Purchdoctype::"Posted Invoice" then begin
            ToPurchHeader."Applies-to Doc. Type" := ToPurchHeader."applies-to doc. type"::Invoice;
            ToPurchHeader."Applies-to Doc. No." := FromDocNo;
          end else begin
            ToPurchHeader."Applies-to Doc. Type" := ToPurchHeader."applies-to doc. type"::"Credit Memo";
            ToPurchHeader."Applies-to Doc. No." := FromDocNo;
          end;
          VendLedgEntry.CalcFields("Remaining Amount");
          VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount";
          VendLedgEntry."Accepted Payment Tolerance" := 0;
          VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
          Codeunit.Run(Codeunit::"Vend. Entry-Edit",VendLedgEntry);
        end;
    end;

    local procedure ExtTxtAttachedToPosSalesLine(SalesHeader: Record "Sales Header";MoveNegLines: Boolean;AttachedToLineNo: Integer): Boolean
    var
        AttachedToSalesLine: Record "Sales Line";
    begin
        if MoveNegLines then
          if AttachedToLineNo <> 0 then
            if AttachedToSalesLine.Get(SalesHeader."Document Type",SalesHeader."No.",AttachedToLineNo) then
              if AttachedToSalesLine.Quantity >= 0 then
                exit(true);

        exit(false);
    end;

    local procedure ExtTxtAttachedToPosPurchLine(PurchHeader: Record "Purchase Header";MoveNegLines: Boolean;AttachedToLineNo: Integer): Boolean
    var
        AttachedToPurchLine: Record "Purchase Line";
    begin
        if MoveNegLines then
          if AttachedToLineNo <> 0 then
            if AttachedToPurchLine.Get(PurchHeader."Document Type",PurchHeader."No.",AttachedToLineNo) then
              if AttachedToPurchLine.Quantity >= 0 then
                exit(true);

        exit(false);
    end;

    local procedure SalesDocCanReceiveTracking(SalesHeader: Record "Sales Header"): Boolean
    begin
        exit(
          (SalesHeader."Document Type" <> SalesHeader."document type"::Quote) and
          (SalesHeader."Document Type" <> SalesHeader."document type"::"Blanket Order"));
    end;

    local procedure PurchaseDocCanReceiveTracking(PurchaseHeader: Record "Purchase Header"): Boolean
    begin
        exit(
          (PurchaseHeader."Document Type" <> PurchaseHeader."document type"::Quote) and
          (PurchaseHeader."Document Type" <> PurchaseHeader."document type"::"Blanket Order"));
    end;

    local procedure CheckFirstLineShipped(DocNo: Code[20];ShipmentLineNo: Integer;var SalesCombDocLineNo: Integer;var NextLineNo: Integer;var FirstLineShipped: Boolean)
    begin
        if (DocNo = '') and (ShipmentLineNo = 0) and FirstLineShipped then begin
          FirstLineShipped := false;
          SalesCombDocLineNo := NextLineNo;
          NextLineNo := NextLineNo + 10000;
        end;
    end;

    local procedure SetTempSalesInvLine(FromSalesInvLine: Record "Sales Invoice Line";var TempSalesInvLine: Record "Sales Invoice Line" temporary;var SalesInvLineCount: Integer;var NextLineNo: Integer;var FirstLineText: Boolean)
    begin
        if FromSalesInvLine.Type = FromSalesInvLine.Type::Item then begin
          SalesInvLineCount += 1;
          TempSalesInvLine := FromSalesInvLine;
          TempSalesInvLine.Insert;
          if FirstLineText then begin
            NextLineNo := NextLineNo + 10000;
            FirstLineText := false;
          end;
        end else
          if FromSalesInvLine.Type = FromSalesInvLine.Type::" " then
            FirstLineText := true;
    end;

    local procedure SetLanguageByCode(LanguageCode: Code[10]) PreviousGlobalLanguageID: Integer
    var
        Language: Record Language;
    begin
        if LanguageCode = '' then
          exit(0);

        PreviousGlobalLanguageID := GlobalLanguage;
        GlobalLanguage(Language.GetLanguageID(LanguageCode));
    end;

    local procedure SetLanguageByID(LanguageID: Integer)
    begin
        if LanguageID <> 0 then
          GlobalLanguage(LanguageID);
    end;

    local procedure InitAndCheckSalesDocuments(FromDocType: Option;FromDocNo: Code[20];var FromSalesHeader: Record "Sales Header";var ToSalesHeader: Record "Sales Header";var FromSalesShipmentHeader: Record "Sales Shipment Header";var FromSalesInvoiceHeader: Record "Sales Invoice Header";var FromReturnReceiptHeader: Record "Return Receipt Header";var FromSalesCrMemoHeader: Record "Sales Cr.Memo Header"): Boolean
    begin
        with ToSalesHeader do
          case FromDocType of
            Salesdoctype::Quote,
            Salesdoctype::"Blanket Order",
            Salesdoctype::Order,
            Salesdoctype::Invoice,
            Salesdoctype::"Return Order",
            Salesdoctype::"Credit Memo":
              begin
                FromSalesHeader.Get(SalesHeaderDocType(FromDocType),FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromSalesHeader."Posting Date")
                then
                  exit(false);
                if MoveNegLines then
                  DeleteSalesLinesWithNegQty(FromSalesHeader,true);
                CheckSalesDocItselfCopy(ToSalesHeader,FromSalesHeader);

                if "Document Type" <= "document type"::Invoice then begin
                  FromSalesHeader.CalcFields("Amount Including VAT");
                  "Amount Including VAT" := FromSalesHeader."Amount Including VAT";
                  CheckCreditLimit(FromSalesHeader,ToSalesHeader);
                end;
                CheckCopyFromSalesHeaderAvail(FromSalesHeader,ToSalesHeader);

                if not IncludeHeader and not RecalculateLines then
                  CheckFromSalesHeader(FromSalesHeader,ToSalesHeader);
              end;
            Salesdoctype::"Posted Shipment":
              begin
                FromSalesShipmentHeader.Get(FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromSalesShipmentHeader."Posting Date")
                then
                  exit(false);
                CheckCopyFromSalesShptAvail(FromSalesShipmentHeader,ToSalesHeader);

                if not IncludeHeader and not RecalculateLines then
                  CheckFromSalesShptHeader(FromSalesShipmentHeader,ToSalesHeader);
              end;
            Salesdoctype::"Posted Invoice":
              begin
                FromSalesInvoiceHeader.Get(FromDocNo);
                FromSalesInvoiceHeader.TestField("Prepayment Invoice",false);
                WarnSalesInvoicePmtDisc(ToSalesHeader,FromSalesHeader,FromDocType,FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromSalesInvoiceHeader."Posting Date")
                then
                  exit(false);
                if "Document Type" <= "document type"::Invoice then begin
                  FromSalesInvoiceHeader.CalcFields("Amount Including VAT");
                  "Amount Including VAT" := FromSalesInvoiceHeader."Amount Including VAT";
                  if IncludeHeader then
                    FromSalesHeader.TransferFields(FromSalesInvoiceHeader);
                  CheckCreditLimit(FromSalesHeader,ToSalesHeader);
                end;
                CheckCopyFromSalesInvoiceAvail(FromSalesInvoiceHeader,ToSalesHeader);

                if not IncludeHeader and not RecalculateLines then
                  CheckFromSalesInvHeader(FromSalesInvoiceHeader,ToSalesHeader);
              end;
            Salesdoctype::"Posted Return Receipt":
              begin
                FromReturnReceiptHeader.Get(FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromReturnReceiptHeader."Posting Date")
                then
                  exit(false);
                CheckCopyFromSalesRetRcptAvail(FromReturnReceiptHeader,ToSalesHeader);

                if not IncludeHeader and not RecalculateLines then
                  CheckFromSalesReturnRcptHeader(FromReturnReceiptHeader,ToSalesHeader);
              end;
            Salesdoctype::"Posted Credit Memo":
              begin
                FromSalesCrMemoHeader.Get(FromDocNo);
                FromSalesCrMemoHeader.TestField("Prepayment Credit Memo",false);
                WarnSalesInvoicePmtDisc(ToSalesHeader,FromSalesHeader,FromDocType,FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromSalesCrMemoHeader."Posting Date")
                then
                  exit(false);
                if "Document Type" <= "document type"::Invoice then begin
                  FromSalesCrMemoHeader.CalcFields("Amount Including VAT");
                  "Amount Including VAT" := FromSalesCrMemoHeader."Amount Including VAT";
                  if IncludeHeader then
                    FromSalesHeader.TransferFields(FromSalesCrMemoHeader);
                  CheckCreditLimit(FromSalesHeader,ToSalesHeader);
                end;
                CheckCopyFromSalesCrMemoAvail(FromSalesCrMemoHeader,ToSalesHeader);

                if not IncludeHeader and not RecalculateLines then
                  CheckFromSalesCrMemoHeader(FromSalesCrMemoHeader,ToSalesHeader);
              end;
          end;

        exit(true);
    end;

    local procedure InitAndCheckPurchaseDocuments(FromDocType: Option;FromDocNo: Code[20];var FromPurchaseHeader: Record "Purchase Header";var ToPurchaseHeader: Record "Purchase Header";var FromPurchRcptHeader: Record "Purch. Rcpt. Header";var FromPurchInvHeader: Record "Purch. Inv. Header";var FromReturnShipmentHeader: Record "Return Shipment Header";var FromPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."): Boolean
    begin
        with ToPurchaseHeader do
          case FromDocType of
            Purchdoctype::Quote,
            Purchdoctype::"Blanket Order",
            Purchdoctype::Order,
            Purchdoctype::Invoice,
            Purchdoctype::"Return Order",
            Purchdoctype::"Credit Memo":
              begin
                FromPurchaseHeader.Get(PurchHeaderDocType(FromDocType),FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromPurchaseHeader."Posting Date")
                then
                  exit(false);
                if MoveNegLines then
                  DeletePurchLinesWithNegQty(FromPurchaseHeader,true);
                CheckPurchDocItselfCopy(ToPurchaseHeader,FromPurchaseHeader);
                if not IncludeHeader and not RecalculateLines then
                  CheckFromPurchaseHeader(FromPurchaseHeader,ToPurchaseHeader);
              end;
            Purchdoctype::"Posted Receipt":
              begin
                FromPurchRcptHeader.Get(FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromPurchRcptHeader."Posting Date")
                then
                  exit(false);
                if not IncludeHeader and not RecalculateLines then
                  CheckFromPurchaseRcptHeader(FromPurchRcptHeader,ToPurchaseHeader);
              end;
            Purchdoctype::"Posted Invoice":
              begin
                FromPurchInvHeader.Get(FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromPurchInvHeader."Posting Date")
                then
                  exit(false);
                FromPurchInvHeader.TestField("Prepayment Invoice",false);
                WarnPurchInvoicePmtDisc(ToPurchaseHeader,FromPurchaseHeader,FromDocType,FromDocNo);
                if not IncludeHeader and not RecalculateLines then
                  CheckFromPurchaseInvHeader(FromPurchInvHeader,ToPurchaseHeader);
              end;
            Purchdoctype::"Posted Return Shipment":
              begin
                FromReturnShipmentHeader.Get(FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromReturnShipmentHeader."Posting Date")
                then
                  exit(false);
                if not IncludeHeader and not RecalculateLines then
                  CheckFromPurchaseReturnShptHeader(FromReturnShipmentHeader,ToPurchaseHeader);
              end;
            Purchdoctype::"Posted Credit Memo":
              begin
                FromPurchCrMemoHdr.Get(FromDocNo);
                if not CheckDateOrder(
                     "Posting No.","Posting No. Series",
                     "Posting Date",FromPurchCrMemoHdr."Posting Date")
                then
                  exit(false);
                FromPurchCrMemoHdr.TestField("Prepayment Credit Memo",false);
                WarnPurchInvoicePmtDisc(ToPurchaseHeader,FromPurchaseHeader,FromDocType,FromDocNo);
                if not IncludeHeader and not RecalculateLines then
                  CheckFromPurchaseCrMemoHeader(FromPurchCrMemoHdr,ToPurchaseHeader);
              end;
          end;

        exit(true);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopySalesDocument(FromDocumentType: Option;FromDocumentNo: Code[20];var ToSalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopyPurchaseDocument(FromDocumentType: Option;FromDocumentNo: Code[20];var ToPurchaseHeader: Record "Purchase Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopySalesDocument(FromDocumentType: Option;FromDocumentNo: Code[20];var ToSalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCopyPurchaseDocument(FromDocumentType: Option;FromDocumentNo: Code[20];var ToPurchaseHeader: Record "Purchase Header")
    begin
    end;
}

