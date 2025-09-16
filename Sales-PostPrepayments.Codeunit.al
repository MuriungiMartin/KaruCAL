#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 442 "Sales-Post Prepayments"
{
    Permissions = TableData "Sales Line"=imd,
                  TableData "Invoice Post. Buffer"=imd,
                  TableData "Sales Invoice Header"=imd,
                  TableData "Sales Invoice Line"=imd,
                  TableData "Sales Cr.Memo Header"=imd,
                  TableData "Sales Cr.Memo Line"=imd,
                  TableData "General Posting Setup"=imd,
                  TableData "Gen. Jnl. Dim. Filter"=imd,
                  TableData "Reservation Worksheet Log"=imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'is not within your range of allowed posting dates';
        GLSetup: Record "General Ledger Setup";
        GenPostingSetup: Record "General Posting Setup";
        Text001: label 'There is nothing to post.';
        Text002: label 'Posting Prepayment Lines   #2######\';
        Text003: label '%1 %2 -> Invoice %3';
        Text004: label 'Posting sales and tax      #3######\';
        Text005: label 'Posting to customers       #4######\';
        Text006: label 'Posting to bal. account    #5######';
        Text007: label 'The combination of dimensions that is used in the document of type %1 with the number %2 is blocked. %3.';
        Text008: label 'The combination of dimensions that is used in the document of type %1 with the number %2, line no. %3 is blocked. %4.';
        Text009: label 'The dimensions that are used in the document of type %1 with the number %2 are not valid. %3.';
        Text010: label 'The dimensions that are used in the document of type %1 with the number %2, line no. %3 are not valid. %4.';
        TempGlobalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer" temporary;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Text011: label '%1 %2 -> Credit Memo %3';
        Text012: label 'Prepayment %1, %2 %3.';
        Text013: label 'It is not possible to assign a prepayment amount of %1 to the sales lines.';
        Text014: label 'Tax Amount';
        Text015: label '%1% Tax';
        Text016: label 'The new prepayment amount must be between %1 and %2.';
        Text017: label 'At least one line must have %1 > 0 to distribute prepayment amount.';
        Text018: label 'must be positive when %1 is not 0';
        Text019: label 'Invoice,Credit Memo';
        SalesLineTax: Record "Sales Line";
        SalesHeaderTax: Record "Sales Header";
        TotalSalesLineLCY: Record "Sales Line";
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLineDocNo1: Code[20];
        GenJnlLineExtDocNo1: Code[20];
        SrcCode1: Code[10];
        GenJnlLineDocType1: Integer;
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        SalesTaxCountry: Option US,CA,,,,,,,,,,,,NoTax;
        TaxOption: Option ,VAT,SalesTax;
        UseDate: Date;
        Currency: Record Currency;
        DimMgt: Codeunit DimensionManagement;
        TaxAmountDifference: Record UnknownRecord10012;
        TempTaxAmt: Decimal;
        SalesAccountNo: Code[10];


    procedure Invoice(var SalesHeader: Record "Sales Header")
    begin
        Code(SalesHeader,0);
    end;


    procedure CreditMemo(var SalesHeader: Record "Sales Header")
    begin
        Code(SalesHeader,1);
    end;

    local procedure "Code"(var SalesHeader2: Record "Sales Header";DocumentType: Option Invoice,"Credit Memo")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SourceCodeSetup: Record "Source Code Setup";
        Cust: Record Customer;
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        TempPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer" temporary;
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer";
        GenJnlLine: Record "Gen. Journal Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TempVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        CustLedgEntry: Record "Cust. Ledger Entry";
        TempSalesLines: Record "Sales Line" temporary;
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Window: Dialog;
        GenJnlLineDocNo: Code[20];
        GenJnlLineExtDocNo: Code[35];
        SrcCode: Code[10];
        PostingNoSeriesCode: Code[10];
        CalcPmtDiscOnCrMemos: Boolean;
        PostingDescription: Text[50];
        GenJnlLineDocType: Integer;
        PrevLineNo: Integer;
        LineCount: Integer;
        PostedDocTabNo: Integer;
        LineNo: Integer;
    begin
        SalesHeader := SalesHeader2;
        GLSetup.Get;
        SalesSetup.Get;
        with SalesHeader do begin
          TestField("Document Type","document type"::Order);
          TestField("Sell-to Customer No.");
          TestField("Bill-to Customer No.");
          TestField("Posting Date");
          TestField("Document Date");
          if GenJnlCheckLine.DateNotAllowed("Posting Date") then
            FieldError("Posting Date",Text000);

          if GLSetup."PAC Environment" <> GLSetup."pac environment"::Disabled then
            TestField("Payment Method Code");

          if not CheckOpenPrepaymentLines(SalesHeader,DocumentType) then
            Error(Text001);

          CheckDim(SalesHeader);
          OnCheckSalesPostRestrictions;
          Cust.Get("Sell-to Customer No.");
          Cust.CheckBlockedCustOnDocs(Cust,PrepmtDocTypeToDocType("Document Type"),false,true);
          if "Bill-to Customer No." <> "Sell-to Customer No." then begin
            Cust.Get("Bill-to Customer No.");
            Cust.CheckBlockedCustOnDocs(Cust,PrepmtDocTypeToDocType("Document Type"),false,true);
          end;

          UpdateDocNos(SalesHeader,DocumentType,GenJnlLineDocNo,PostingNoSeriesCode);

          Window.Open(
            '#1#################################\\' +
            Text002 +
            Text004 +
            Text005 +
            Text006);
          Window.Update(1,StrSubstNo('%1 %2',SelectStr(1 + DocumentType,Text019),"No."));

          SourceCodeSetup.Get;
          SrcCode := SourceCodeSetup.Sales;
          if "Prepmt. Posting Description" <> '' then
            PostingDescription := "Prepmt. Posting Description"
          else
            PostingDescription :=
              CopyStr(
                StrSubstNo(Text012,SelectStr(1 + DocumentType,Text019),"Document Type","No."),
                1,MaxStrLen("Posting Description"));

          // Create posted header
          if SalesSetup."Ext. Doc. No. Mandatory" then
            TestField("External Document No.");
          case DocumentType of
            Documenttype::Invoice:
              begin
                InsertSalesInvHeader(SalesInvHeader,SalesHeader,PostingDescription,GenJnlLineDocNo,SrcCode,PostingNoSeriesCode);
                GenJnlLineDocType := GenJnlLine."document type"::Invoice;
                PostedDocTabNo := Database::"Sales Invoice Header";
                Window.Update(1,StrSubstNo(Text003,"Document Type","No.",SalesInvHeader."No."));
              end;
            Documenttype::"Credit Memo":
              begin
                CalcPmtDiscOnCrMemos := GetCalcPmtDiscOnCrMemos("Prepmt. Payment Terms Code");
                InsertSalesCrMemoHeader(
                  SalesCrMemoHeader,SalesHeader,PostingDescription,GenJnlLineDocNo,SrcCode,PostingNoSeriesCode,
                  CalcPmtDiscOnCrMemos);
                GenJnlLineDocType := GenJnlLine."document type"::"Credit Memo";
                PostedDocTabNo := Database::"Sales Cr.Memo Header";
                Window.Update(1,StrSubstNo(Text011,"Document Type","No.",SalesCrMemoHeader."No."));
              end;
          end;
          if SalesSetup."Copy Comments Order to Invoice" then
            CopyCommentLines("No.",PostedDocTabNo,GenJnlLineDocNo);
          GenJnlLineExtDocNo := "External Document No.";
          // Reverse old lines
          if DocumentType = Documenttype::Invoice then begin
            GetSalesLinesToDeduct(SalesHeader,TempSalesLines);
            if not TempSalesLines.IsEmpty then
              CalcVATAmountLines(SalesHeader,TempSalesLines,TempVATAmountLineDeduct,Documenttype::"Credit Memo");
          end;

          // Create Lines
          TempPrepmtInvLineBuffer.DeleteAll;
          if "Tax Area Code" = '' then begin  // VAT
            CalcVATAmountLines(SalesHeader,SalesLine,TempVATAmountLine,DocumentType);
            TempVATAmountLine.DeductVATAmountLine(TempVATAmountLineDeduct);
            UpdateVATOnLines(SalesHeader,SalesLine,TempVATAmountLine,DocumentType);
          end else begin
            SalesLine.SetSalesHeader(SalesHeader);
            SalesLine.CalcSalesTaxLines(SalesHeader,SalesLine);
            UpdateSalesTaxOnLines(SalesLine,"Prepmt. Include Tax",DocumentType);
          end;
          BuildInvLineBuffer(SalesHeader,SalesLine,DocumentType,TempPrepmtInvLineBuffer,true);
          TempPrepmtInvLineBuffer.Find('-');
          repeat
            LineCount := LineCount + 1;
            Window.Update(2,LineCount);
            if TempPrepmtInvLineBuffer."Line No." <> 0 then
              LineNo := PrevLineNo + TempPrepmtInvLineBuffer."Line No."
            else
              LineNo := PrevLineNo + 10000;
            case DocumentType of
              Documenttype::Invoice:
                begin
                  InsertSalesInvLine(SalesInvHeader,LineNo,TempPrepmtInvLineBuffer);
                  PostedDocTabNo := Database::"Sales Invoice Line";
                end;
              Documenttype::"Credit Memo":
                begin
                  InsertSalesCrMemoLine(SalesCrMemoHeader,LineNo,TempPrepmtInvLineBuffer);
                  PostedDocTabNo := Database::"Sales Cr.Memo Line";
                end;
            end;
            PrevLineNo := LineNo;
            InsertExtendedText(
              PostedDocTabNo,GenJnlLineDocNo,TempPrepmtInvLineBuffer."G/L Account No.","Document Date","Language Code",PrevLineNo);
          until TempPrepmtInvLineBuffer.Next = 0;

          // G/L Posting
          LineCount := 0;
          if not "Compress Prepayment" then
            TempPrepmtInvLineBuffer.CompressBuffer;
          TempPrepmtInvLineBuffer.SetRange(Adjustment,false);
          TempPrepmtInvLineBuffer.FindSet(true);
          repeat
            if DocumentType = Documenttype::Invoice then
              TempPrepmtInvLineBuffer.ReverseAmounts;
            RoundAmounts(SalesHeader,TempPrepmtInvLineBuffer,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY);
            if "Currency Code" = '' then begin
              AdjustInvLineBuffers(SalesHeader,TempPrepmtInvLineBuffer,TotalPrepmtInvLineBuffer,DocumentType);
              TotalPrepmtInvLineBufferLCY := TotalPrepmtInvLineBuffer;
            end else
              AdjustInvLineBuffers(SalesHeader,TempPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,DocumentType);
            TempPrepmtInvLineBuffer.Modify;
          until TempPrepmtInvLineBuffer.Next = 0;

          TempPrepmtInvLineBuffer.Reset;
          TempPrepmtInvLineBuffer.SetCurrentkey(Adjustment);
          TempPrepmtInvLineBuffer.Find('+');
          repeat
            LineCount := LineCount + 1;
            Window.Update(3,LineCount);

            PostPrepmtInvLineBuffer(
              SalesHeader,TempPrepmtInvLineBuffer,DocumentType,PostingDescription,
              GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PostingNoSeriesCode);
          until TempPrepmtInvLineBuffer.Next(-1) = 0;

          // Post customer entry
          Window.Update(4,1);
          PostCustomerEntry(
            SalesHeader,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,DocumentType,PostingDescription,
            GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PostingNoSeriesCode,CalcPmtDiscOnCrMemos);

          // Balancing account
          if "Bal. Account No." <> '' then begin
            Window.Update(5,1);
            CustLedgEntry.FindLast;
            PostBalancingEntry(
              SalesHeader,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferLCY,CustLedgEntry,DocumentType,
              PostingDescription,GenJnlLineDocType,GenJnlLineDocNo,GenJnlLineExtDocNo,SrcCode,PostingNoSeriesCode);
          end;

          // Update lines & header
          UpdateSalesDocument(SalesHeader,SalesLine,DocumentType,GenJnlLineDocNo);
          if Status <> Status::"Pending Prepayment" then
            Status := Status::"Pending Prepayment";
          Modify;
        end;

        SalesHeader2 := SalesHeader;
    end;

    local procedure UpdateDocNos(var SalesHeader: Record "Sales Header";DocumentType: Option Invoice,"Credit Memo";var DocNo: Code[20];var NoSeriesCode: Code[10])
    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
    begin
        with SalesHeader do
          case DocumentType of
            Documenttype::Invoice:
              begin
                TestField("Prepayment Due Date");
                TestField("Prepmt. Cr. Memo No.",'');
                if "Prepayment No." = '' then begin
                  TestField("Prepayment No. Series");
                  "Prepayment No." := NoSeriesMgt.GetNextNo("Prepayment No. Series","Posting Date",true);
                  Modify;
                  Commit;
                end;
                DocNo := "Prepayment No.";
                NoSeriesCode := "Prepayment No. Series";
              end;
            Documenttype::"Credit Memo":
              begin
                TestField("Prepayment No.",'');
                if "Prepmt. Cr. Memo No." = '' then begin
                  TestField("Prepmt. Cr. Memo No. Series");
                  "Prepmt. Cr. Memo No." := NoSeriesMgt.GetNextNo("Prepmt. Cr. Memo No. Series","Posting Date",true);
                  Modify;
                  Commit;
                end;
                DocNo := "Prepmt. Cr. Memo No.";
                NoSeriesCode := "Prepmt. Cr. Memo No. Series";
              end;
          end;
    end;


    procedure CheckOpenPrepaymentLines(SalesHeader: Record "Sales Header";DocumentType: Option) Found: Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        with SalesLine do begin
          ApplyFilter(SalesHeader,DocumentType,SalesLine);
          if Find('-') then
            repeat
              if not Found then
                Found := PrepmtAmount(SalesLine,DocumentType,SalesHeader."Prepmt. Include Tax") <> 0;
              if ("Prepayment VAT Identifier" = '') and ("Prepmt. Amt. Inv." = 0) then begin
                UpdatePrepmtSetupFields;
                Modify;
              end;
            until Next = 0;
        end;
        exit(Found);
    end;

    local procedure RoundAmounts(SalesHeader: Record "Sales Header";var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";var TotalPrepmtInvLineBufLCY: Record "Prepayment Inv. Line Buffer")
    var
        VAT: Boolean;
    begin
        TotalPrepmtInvLineBuf.IncrAmounts(PrepmtInvLineBuf);

        if SalesHeader."Currency Code" <> '' then begin
          VAT := PrepmtInvLineBuf.Amount <> PrepmtInvLineBuf."Amount Incl. VAT";

          PrepmtInvLineBuf."Amount Incl. VAT" :=
            AmountToLCY(
              SalesHeader,TotalPrepmtInvLineBuf."Amount Incl. VAT",TotalPrepmtInvLineBufLCY."Amount Incl. VAT");
          if VAT then
            PrepmtInvLineBuf.Amount :=
              AmountToLCY(
                SalesHeader,TotalPrepmtInvLineBuf.Amount,TotalPrepmtInvLineBufLCY.Amount)
          else
            PrepmtInvLineBuf.Amount := PrepmtInvLineBuf."Amount Incl. VAT";
          PrepmtInvLineBuf."VAT Amount" := PrepmtInvLineBuf."Amount Incl. VAT" - PrepmtInvLineBuf.Amount;
          if PrepmtInvLineBuf."VAT Base Amount" <> 0 then
            PrepmtInvLineBuf."VAT Base Amount" := PrepmtInvLineBuf.Amount;
        end;

        TotalPrepmtInvLineBufLCY.IncrAmounts(PrepmtInvLineBuf);
    end;

    local procedure AmountToLCY(SalesHeader: Record "Sales Header";TotalAmt: Decimal;PrevTotalAmt: Decimal): Decimal
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        CurrExchRate.Init;
        with SalesHeader do
          exit(
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code",TotalAmt,"Currency Factor")) -
            PrevTotalAmt);
    end;

    local procedure BuildInvLineBuffer(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";DocumentType: Option;var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer";UpdateLines: Boolean)
    var
        PrepmtInvBuf2: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtInvLineBufferDummy: Record "Prepayment Inv. Line Buffer";
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        with SalesHeader do begin
          TempGlobalPrepmtInvLineBuf.Reset;
          TempGlobalPrepmtInvLineBuf.DeleteAll;
          SalesSetup.Get;
          ApplyFilter(SalesHeader,DocumentType,SalesLine);
          SalesLine.SetRange("System-Created Entry",false);
          if SalesLine.Find('-') then
            repeat
              if PrepmtAmount(SalesLine,DocumentType,"Prepmt. Include Tax") <> 0 then begin
                if SalesLine.Quantity < 0 then
                  SalesLine.FieldError(Quantity,StrSubstNo(Text018,FieldCaption("Prepayment %")));
                if SalesLine."Unit Price" < 0 then
                  SalesLine.FieldError("Unit Price",StrSubstNo(Text018,FieldCaption("Prepayment %")));

                FillInvLineBuffer(SalesHeader,SalesLine,PrepmtInvBuf2);
                if UpdateLines then
                  TempGlobalPrepmtInvLineBuf.CopyWithLineNo(PrepmtInvBuf2,SalesLine."Line No.");
                PrepmtInvBuf.InsertInvLineBuffer(PrepmtInvBuf2);
                if SalesSetup."Invoice Rounding" then
                  RoundAmounts(
                    SalesHeader,PrepmtInvBuf2,TotalPrepmtInvLineBuffer,TotalPrepmtInvLineBufferDummy);
              end;
            until SalesLine.Next = 0;
          if SalesSetup."Invoice Rounding" then
            if InsertInvoiceRounding(
                 SalesHeader,PrepmtInvBuf2,TotalPrepmtInvLineBuffer,SalesLine."Line No.")
            then
              PrepmtInvBuf.InsertInvLineBuffer(PrepmtInvBuf2);
        end;
    end;


    procedure BuildInvLineBuffer2(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";DocumentType: Option Invoice,"Credit Memo",Statistic;var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer")
    begin
        BuildInvLineBuffer(
          SalesHeader,SalesLine,DocumentType,PrepmtInvBuf,false);
    end;

    local procedure AdjustInvLineBuffers(SalesHeader: Record "Sales Header";var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";DocumentType: Option Invoice,"Credit Memo")
    var
        VATAdjustment: array [2] of Decimal;
        VAT: Option ,Base,Amount;
    begin
        CalcPrepmtAmtInvLCYInLines(SalesHeader,PrepmtInvLineBuf,DocumentType,VATAdjustment);
        if Abs(VATAdjustment[Vat::Base]) > GLSetup."Amount Rounding Precision" then
          InsertCorrInvLineBuffer(PrepmtInvLineBuf,SalesHeader,VATAdjustment[Vat::Base])
        else
          if (VATAdjustment[Vat::Base] <> 0) or (VATAdjustment[Vat::Amount] <> 0) then begin
            PrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
            TotalPrepmtInvLineBuf.AdjustVATBase(VATAdjustment);
          end;
    end;

    local procedure CalcPrepmtAmtInvLCYInLines(SalesHeader: Record "Sales Header";var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";DocumentType: Option Invoice,"Credit Memo";var VATAdjustment: array [2] of Decimal)
    var
        SalesLine: Record "Sales Line";
        PrepmtInvBufAmount: array [2] of Decimal;
        TotalAmount: array [2] of Decimal;
        LineAmount: array [2] of Decimal;
        Ratio: array [2] of Decimal;
        PrepmtAmtReminder: array [2] of Decimal;
        PrepmtAmountRnded: array [2] of Decimal;
        VAT: Option ,Base,Amount;
    begin
        PrepmtInvLineBuf.AmountsToArray(PrepmtInvBufAmount);
        if DocumentType = Documenttype::Invoice then
          ReverseDecArray(PrepmtInvBufAmount);

        TempGlobalPrepmtInvLineBuf.SetFilterOnPKey(PrepmtInvLineBuf);
        TempGlobalPrepmtInvLineBuf.CalcSums(Amount,"Amount Incl. VAT");
        TempGlobalPrepmtInvLineBuf.AmountsToArray(TotalAmount);
        for VAT := Vat::Base to Vat::Amount do
          if TotalAmount[VAT] = 0 then
            Ratio[VAT] := 0
          else
            Ratio[VAT] := PrepmtInvBufAmount[VAT] / TotalAmount[VAT];
        if TempGlobalPrepmtInvLineBuf.FindSet then
          repeat
            TempGlobalPrepmtInvLineBuf.AmountsToArray(LineAmount);
            PrepmtAmountRnded[Vat::Base] := CalcRndedAmount(LineAmount[Vat::Base],Ratio[Vat::Base],PrepmtAmtReminder[Vat::Base]);
            PrepmtAmountRnded[Vat::Amount] := CalcRndedAmount(LineAmount[Vat::Amount],Ratio[Vat::Amount],PrepmtAmtReminder[Vat::Amount]);

            SalesLine.Get(SalesHeader."Document Type",SalesHeader."No.",TempGlobalPrepmtInvLineBuf."Line No.");
            if DocumentType = Documenttype::"Credit Memo" then begin
              VATAdjustment[Vat::Base] :=
                VATAdjustment[Vat::Base] + SalesLine."Prepmt. Amount Inv. (LCY)" - PrepmtAmountRnded[Vat::Base];
              SalesLine."Prepmt. Amount Inv. (LCY)" := 0;
              VATAdjustment[Vat::Amount] :=
                VATAdjustment[Vat::Amount] + SalesLine."Prepmt. VAT Amount Inv. (LCY)" - PrepmtAmountRnded[Vat::Amount];
              SalesLine."Prepmt. VAT Amount Inv. (LCY)" := 0;
            end else begin
              SalesLine."Prepmt. Amount Inv. (LCY)" := SalesLine."Prepmt. Amount Inv. (LCY)" + PrepmtAmountRnded[Vat::Base];
              SalesLine."Prepmt. VAT Amount Inv. (LCY)" := SalesLine."Prepmt. VAT Amount Inv. (LCY)" + PrepmtAmountRnded[Vat::Amount];
            end;
            SalesLine.Modify;
          until TempGlobalPrepmtInvLineBuf.Next = 0;
        TempGlobalPrepmtInvLineBuf.DeleteAll;
    end;

    local procedure CalcRndedAmount(LineAmount: Decimal;Ratio: Decimal;var Reminder: Decimal) RndedAmount: Decimal
    var
        Amount: Decimal;
    begin
        Amount := Reminder + LineAmount * Ratio;
        RndedAmount := ROUND(Amount);
        Reminder := Amount - RndedAmount;
    end;

    local procedure ReverseDecArray(var DecArray: array [2] of Decimal)
    var
        Idx: Integer;
    begin
        for Idx := 1 to ArrayLen(DecArray) do
          DecArray[Idx] := -DecArray[Idx];
    end;

    local procedure InsertCorrInvLineBuffer(var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";SalesHeader: Record "Sales Header";VATBaseAdjustment: Decimal)
    var
        NewPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";
        SavedPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer";
        AdjmtAmountACY: Decimal;
    begin
        SavedPrepmtInvLineBuf := PrepmtInvLineBuf;

        if SalesHeader."Currency Code" = '' then
          AdjmtAmountACY := VATBaseAdjustment
        else
          AdjmtAmountACY := 0;

        NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
          PrepmtInvLineBuf,
          GetPrepmtAccNo(PrepmtInvLineBuf."Gen. Bus. Posting Group",PrepmtInvLineBuf."Gen. Prod. Posting Group"),
          VATBaseAdjustment,AdjmtAmountACY);
        PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);

        NewPrepmtInvLineBuf.FillAdjInvLineBuffer(
          PrepmtInvLineBuf,
          GetCorrBalAccNo(SalesHeader,VATBaseAdjustment > 0),
          -VATBaseAdjustment,-AdjmtAmountACY);
        PrepmtInvLineBuf.InsertInvLineBuffer(NewPrepmtInvLineBuf);

        PrepmtInvLineBuf := SavedPrepmtInvLineBuf;
    end;

    local procedure GetPrepmtAccNo(GenBusPostingGroup: Code[10];GenProdPostingGroup: Code[10]): Code[20]
    begin
        if (GenBusPostingGroup <> GenPostingSetup."Gen. Bus. Posting Group") or
           (GenProdPostingGroup <> GenPostingSetup."Gen. Prod. Posting Group")
        then begin
          GenPostingSetup.Get(GenBusPostingGroup,GenProdPostingGroup);
          GenPostingSetup.TestField("Sales Prepayments Account");
        end;
        exit(GenPostingSetup."Sales Prepayments Account");
    end;


    procedure GetCorrBalAccNo(SalesHeader: Record "Sales Header";PositiveAmount: Boolean): Code[20]
    var
        BalAccNo: Code[20];
    begin
        if SalesHeader."Currency Code" = '' then
          BalAccNo := GetInvRoundingAccNo(SalesHeader."Customer Posting Group")
        else
          BalAccNo := GetGainLossGLAcc(SalesHeader."Currency Code",PositiveAmount);
        exit(BalAccNo);
    end;


    procedure GetInvRoundingAccNo(CustomerPostingGroup: Code[10]): Code[20]
    var
        CustPostingGr: Record "Customer Posting Group";
        GLAcc: Record "G/L Account";
    begin
        CustPostingGr.Get(CustomerPostingGroup);
        CustPostingGr.TestField("Invoice Rounding Account");
        GLAcc.Get(CustPostingGr."Invoice Rounding Account");
        exit(CustPostingGr."Invoice Rounding Account");
    end;

    local procedure GetGainLossGLAcc(CurrencyCode: Code[10];PositiveAmount: Boolean): Code[20]
    var
        Currency: Record Currency;
    begin
        Currency.Get(CurrencyCode);
        if PositiveAmount then begin
          Currency.TestField("Realized Gains Acc.");
          exit(Currency."Realized Gains Acc.");
        end;
        Currency.TestField("Realized Losses Acc.");
        exit(Currency."Realized Losses Acc.");
    end;

    local procedure GetCurrencyAmountRoundingPrecision(CurrencyCode: Code[10]): Decimal
    var
        Currency: Record Currency;
    begin
        Currency.Initialize(CurrencyCode);
        Currency.TestField("Amount Rounding Precision");
        exit(Currency."Amount Rounding Precision");
    end;


    procedure FillInvLineBuffer(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line";var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer")
    begin
        with PrepmtInvBuf do begin
          Init;
          "G/L Account No." := GetPrepmtAccNo(SalesLine."Gen. Bus. Posting Group",SalesLine."Gen. Prod. Posting Group");

          if not SalesHeader."Compress Prepayment" then begin
            "Line No." := SalesLine."Line No.";
            Description := SalesLine.Description;
          end;

          CopyFromSalesLine(SalesLine);
          FillFromGLAcc(SalesHeader."Compress Prepayment");

          SetAmounts(
            SalesLine."Prepayment Amount",SalesLine."Prepmt. Amt. Incl. VAT",SalesLine."Prepayment Amount",
            SalesLine."Prepayment Amount",SalesLine."Prepayment Amount",SalesLine."Prepayment VAT Difference");

          "VAT Amount" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
          "VAT Amount (ACY)" := SalesLine."Prepmt. Amt. Incl. VAT" - SalesLine."Prepayment Amount";
        end;
    end;

    local procedure InsertInvoiceRounding(SalesHeader: Record "Sales Header";var PrepmtInvBuf: Record "Prepayment Inv. Line Buffer";TotalPrepmtInvBuf: Record "Prepayment Inv. Line Buffer";PrevLineNo: Integer): Boolean
    var
        SalesLine: Record "Sales Line";
    begin
        if InitInvoiceRoundingLine(SalesHeader,TotalPrepmtInvBuf."Amount Incl. VAT",SalesLine) then begin
          CreateDimensions(SalesLine);
          with PrepmtInvBuf do begin
            Init;
            "Line No." := PrevLineNo + 10000;
            "Invoice Rounding" := true;
            "G/L Account No." := SalesLine."No.";

            CopyFromSalesLine(SalesLine);
            "Gen. Bus. Posting Group" := SalesHeader."Gen. Bus. Posting Group";
            "VAT Bus. Posting Group" := SalesHeader."VAT Bus. Posting Group";

            SetAmounts(
              SalesLine."Line Amount",SalesLine."Amount Including VAT",SalesLine."Line Amount",
              SalesLine."Prepayment Amount",SalesLine."Line Amount",0);

            "VAT Amount" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
            "VAT Amount (ACY)" := SalesLine."Amount Including VAT" - SalesLine."Line Amount";
          end;
          exit(true);
        end;
    end;

    local procedure InitInvoiceRoundingLine(SalesHeader: Record "Sales Header";TotalAmount: Decimal;var SalesLine: Record "Sales Line"): Boolean
    var
        Currency: Record Currency;
        InvoiceRoundingAmount: Decimal;
    begin
        Currency.Initialize(SalesHeader."Currency Code");
        Currency.TestField("Invoice Rounding Precision");
        InvoiceRoundingAmount :=
          -ROUND(
            TotalAmount -
            ROUND(
              TotalAmount,
              Currency."Invoice Rounding Precision",
              Currency.InvoiceRoundingDirection),
            Currency."Amount Rounding Precision");

        if InvoiceRoundingAmount = 0 then
          exit(false);

        with SalesLine do begin
          SetHideValidationDialog(true);
          "Document Type" := SalesHeader."Document Type";
          "Document No." := SalesHeader."No.";
          "System-Created Entry" := true;
          Type := Type::"G/L Account";
          Validate("No.",GetInvRoundingAccNo(SalesHeader."Customer Posting Group"));
          Validate(Quantity,1);
          if SalesHeader."Prices Including VAT" then
            Validate("Unit Price",InvoiceRoundingAmount)
          else
            Validate(
              "Unit Price",
              ROUND(
                InvoiceRoundingAmount /
                (1 + (1 - SalesHeader."VAT Base Discount %" / 100) * "VAT %" / 100),
                Currency."Amount Rounding Precision"));
          "Prepayment Amount" := "Unit Price";
          Validate("Amount Including VAT",InvoiceRoundingAmount);
        end;
        exit(true);
    end;

    local procedure CopyCommentLines(FromNumber: Code[20];ToDocType: Integer;ToNumber: Code[20])
    var
        SalesCommentLine: Record "Sales Comment Line";
        SalesCommentLine2: Record "Sales Comment Line";
    begin
        with SalesCommentLine do begin
          SetRange("Document Type","document type"::Order);
          SetRange("No.",FromNumber);
          if Find('-') then
            repeat
              SalesCommentLine2 := SalesCommentLine;
              case ToDocType of
                Database::"Sales Invoice Header":
                  SalesCommentLine2."Document Type" :=
                    SalesCommentLine2."document type"::"Posted Invoice";
                Database::"Sales Cr.Memo Header":
                  SalesCommentLine2."Document Type" :=
                    SalesCommentLine2."document type"::"Posted Credit Memo";
              end;
              SalesCommentLine2."No." := ToNumber;
              SalesCommentLine2.Insert;
            until Next = 0;
        end;
    end;

    local procedure InsertExtendedText(TabNo: Integer;DocNo: Code[20];GLAccNo: Code[20];DocDate: Date;LanguageCode: Code[10];var PrevLineNo: Integer)
    var
        TempExtTextLine: Record "Extended Text Line" temporary;
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        TransferExtText: Codeunit "Transfer Extended Text";
        NextLineNo: Integer;
    begin
        TransferExtText.PrepmtGetAnyExtText(GLAccNo,TabNo,DocDate,LanguageCode,TempExtTextLine);
        if TempExtTextLine.Find('-') then begin
          NextLineNo := PrevLineNo + 10000;
          repeat
            case TabNo of
              Database::"Sales Invoice Line":
                begin
                  SalesInvLine.Init;
                  SalesInvLine."Document No." := DocNo;
                  SalesInvLine."Line No." := NextLineNo;
                  SalesInvLine.Description := TempExtTextLine.Text;
                  SalesInvLine.Insert;
                end;
              Database::"Sales Cr.Memo Line":
                begin
                  SalesCrMemoLine.Init;
                  SalesCrMemoLine."Document No." := DocNo;
                  SalesCrMemoLine."Line No." := NextLineNo;
                  SalesCrMemoLine.Description := TempExtTextLine.Text;
                  SalesCrMemoLine.Insert;
                end;
            end;
            PrevLineNo := NextLineNo;
            NextLineNo := NextLineNo + 10000;
          until TempExtTextLine.Next = 0;
        end;
    end;


    procedure UpdateVATOnLines(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var VATAmountLine: Record "VAT Amount Line";DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        TempVATAmountLineRemainder: Record "VAT Amount Line" temporary;
        Currency: Record Currency;
        PrepmtAmt: Decimal;
        NewAmount: Decimal;
        NewAmountIncludingVAT: Decimal;
        NewVATBaseAmount: Decimal;
        VATAmount: Decimal;
        VATDifference: Decimal;
        PrepmtAmtToInvTotal: Decimal;
    begin
        Currency.Initialize(SalesHeader."Currency Code");

        with SalesLine do begin
          ApplyFilter(SalesHeader,DocumentType,SalesLine);
          LockTable;
          CalcSums("Prepmt. Line Amount","Prepmt. Amt. Inv.");
          PrepmtAmtToInvTotal := "Prepmt. Line Amount" - "Prepmt. Amt. Inv.";
          if FindSet then
            repeat
              PrepmtAmt := PrepmtAmount(SalesLine,DocumentType,SalesHeader."Prepmt. Include Tax");
              if PrepmtAmt <> 0 then begin
                VATAmountLine.Get(
                  "Prepayment VAT Identifier",
                  "Prepmt. VAT Calc. Type",
                  "Prepayment Tax Group Code",
                  "Prepayment Tax Area Code",
                  false,
                  PrepmtAmt >= 0);
                if VATAmountLine.Modified then begin
                  if not TempVATAmountLineRemainder.Get(
                       "Prepayment VAT Identifier",
                       "Prepmt. VAT Calc. Type",
                       "Prepayment Tax Group Code",
                       "Prepayment Tax Area Code",
                       false,
                       PrepmtAmt >= 0)
                  then begin
                    TempVATAmountLineRemainder := VATAmountLine;
                    TempVATAmountLineRemainder.Init;
                    TempVATAmountLineRemainder.Insert;
                  end;

                  if SalesHeader."Prices Including VAT" then begin
                    if PrepmtAmt = 0 then begin
                      VATAmount := 0;
                      NewAmountIncludingVAT := 0;
                    end else begin
                      VATAmount :=
                        TempVATAmountLineRemainder."VAT Amount" +
                        VATAmountLine."VAT Amount" * PrepmtAmt / VATAmountLine."Line Amount";
                      NewAmountIncludingVAT :=
                        TempVATAmountLineRemainder."Amount Including VAT" +
                        VATAmountLine."Amount Including VAT" * PrepmtAmt / VATAmountLine."Line Amount";
                    end;
                    NewAmount :=
                      ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision") -
                      ROUND(VATAmount,Currency."Amount Rounding Precision");
                    NewVATBaseAmount :=
                      ROUND(
                        NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                        Currency."Amount Rounding Precision");
                  end else begin
                    if "VAT Calculation Type" = "vat calculation type"::"Full VAT" then begin
                      VATAmount := PrepmtAmt;
                      NewAmount := 0;
                      NewVATBaseAmount := 0;
                    end else begin
                      NewAmount := PrepmtAmt;
                      NewVATBaseAmount :=
                        ROUND(
                          NewAmount * (1 - SalesHeader."VAT Base Discount %" / 100),
                          Currency."Amount Rounding Precision");
                      if VATAmountLine."VAT Base" = 0 then
                        VATAmount := 0
                      else
                        VATAmount :=
                          TempVATAmountLineRemainder."VAT Amount" +
                          VATAmountLine."VAT Amount" * NewAmount / VATAmountLine."VAT Base";
                    end;
                    NewAmountIncludingVAT := NewAmount + ROUND(VATAmount,Currency."Amount Rounding Precision");
                  end;

                  "Prepayment Amount" := NewAmount;
                  "Prepmt. Amt. Incl. VAT" :=
                    ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                  "Prepmt. VAT Base Amt." := NewVATBaseAmount;

                  if (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount") = 0 then
                    VATDifference := 0
                  else
                    if PrepmtAmtToInvTotal = 0 then
                      VATDifference :=
                        VATAmountLine."VAT Difference" * ("Prepmt. Line Amount" - "Prepmt. Amt. Inv.") /
                        (VATAmountLine."Line Amount" - VATAmountLine."Invoice Discount Amount")
                    else
                      VATDifference :=
                        VATAmountLine."VAT Difference" * ("Prepmt. Line Amount" - "Prepmt. Amt. Inv.") /
                        PrepmtAmtToInvTotal;

                  "Prepayment VAT Difference" := ROUND(VATDifference,Currency."Amount Rounding Precision");

                  Modify;

                  TempVATAmountLineRemainder."Amount Including VAT" :=
                    NewAmountIncludingVAT - ROUND(NewAmountIncludingVAT,Currency."Amount Rounding Precision");
                  TempVATAmountLineRemainder."VAT Amount" := VATAmount - NewAmountIncludingVAT + NewAmount;
                  TempVATAmountLineRemainder."VAT Difference" := VATDifference - "Prepayment VAT Difference";
                  TempVATAmountLineRemainder.Modify;
                end;
              end;
            until Next = 0;
        end;
    end;


    procedure CalcVATAmountLines(var SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var VATAmountLine: Record "VAT Amount Line";DocumentType: Option Invoice,"Credit Memo",Statistic)
    var
        Currency: Record Currency;
        NewAmount: Decimal;
        NewPrepmtVATDiffAmt: Decimal;
    begin
        Currency.Initialize(SalesHeader."Currency Code");

        VATAmountLine.DeleteAll;

        with SalesLine do begin
          ApplyFilter(SalesHeader,DocumentType,SalesLine);
          if Find('-') then
            repeat
              NewAmount := PrepmtAmount(SalesLine,DocumentType,SalesHeader."Prepmt. Include Tax");
              if NewAmount <> 0 then begin
                if DocumentType = Documenttype::Invoice then
                  NewAmount := "Prepmt. Line Amount";
                if "Prepmt. VAT Calc. Type" in
                   ["vat calculation type"::"Reverse Charge VAT","vat calculation type"::"Sales Tax"]
                then
                  "VAT %" := 0;
                if not VATAmountLine.Get(
                     "Prepayment VAT Identifier","Prepmt. VAT Calc. Type","Prepayment Tax Group Code","Prepayment Tax Area Code",
                     false,NewAmount >= 0)
                then
                  VATAmountLine.InsertNewLine(
                    "Prepayment VAT Identifier","Prepmt. VAT Calc. Type","Prepayment Tax Group Code","Prepayment Tax Area Code",
                    false,"Prepayment VAT %",NewAmount >= 0,true);

                VATAmountLine."Line Amount" := VATAmountLine."Line Amount" + NewAmount;
                NewPrepmtVATDiffAmt := PrepmtVATDiffAmount(SalesLine,DocumentType);
                if DocumentType = Documenttype::Invoice then
                  NewPrepmtVATDiffAmt := "Prepayment VAT Difference" + "Prepmt VAT Diff. to Deduct" +
                    "Prepmt VAT Diff. Deducted";
                VATAmountLine."VAT Difference" := VATAmountLine."VAT Difference" + NewPrepmtVATDiffAmt;
                VATAmountLine.Modify;
              end;
            until Next = 0;
        end;

        VATAmountLine.UpdateLines(
          NewAmount,Currency,SalesHeader."Currency Factor",SalesHeader."Prices Including VAT",
          SalesHeader."VAT Base Discount %",SalesHeader."Tax Area Code",SalesHeader."Tax Liable",SalesHeader."Posting Date");
    end;


    procedure SumPrepmt(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";var VATAmountLine: Record "VAT Amount Line";var TotalAmount: Decimal;var TotalVATAmount: Decimal;var VATAmountText: Text[30])
    var
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        TotalPrepmtBuf: Record "Prepayment Inv. Line Buffer";
        TotalPrepmtBufLCY: Record "Prepayment Inv. Line Buffer";
        DifVATPct: Boolean;
        PrevVATPct: Decimal;
    begin
        CalcVATAmountLines(SalesHeader,SalesLine,VATAmountLine,2);
        UpdateVATOnLines(SalesHeader,SalesLine,VATAmountLine,2);
        BuildInvLineBuffer(SalesHeader,SalesLine,2,PrepmtInvBuf,false);
        if PrepmtInvBuf.Find('-') then begin
          PrevVATPct := PrepmtInvBuf."VAT %";
          repeat
            RoundAmounts(SalesHeader,PrepmtInvBuf,TotalPrepmtBuf,TotalPrepmtBufLCY);
            if PrepmtInvBuf."VAT %" <> PrevVATPct then
              DifVATPct := true;
          until PrepmtInvBuf.Next = 0;
        end;

        TotalAmount := TotalPrepmtBuf.Amount;
        TotalVATAmount := TotalPrepmtBuf."VAT Amount";
        if DifVATPct or (PrepmtInvBuf."VAT %" = 0) then
          VATAmountText := Text014
        else
          VATAmountText := StrSubstNo(Text015,PrevVATPct);
    end;


    procedure GetSalesLines(SalesHeader: Record "Sales Header";DocumentType: Option Invoice,"Credit Memo",Statistic;var ToSalesLine: Record "Sales Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        FromSalesLine: Record "Sales Line";
        InvRoundingSalesLine: Record "Sales Line";
        TempVATAmountLine: Record "VAT Amount Line" temporary;
        TotalAmt: Decimal;
        NextLineNo: Integer;
    begin
        ApplyFilter(SalesHeader,DocumentType,FromSalesLine);
        if FromSalesLine.Find('-') then begin
          repeat
            ToSalesLine := FromSalesLine;
            ToSalesLine.Insert;
          until FromSalesLine.Next = 0;

          SalesSetup.Get;
          if SalesSetup."Invoice Rounding" then begin
            CalcVATAmountLines(SalesHeader,ToSalesLine,TempVATAmountLine,2);
            UpdateVATOnLines(SalesHeader,ToSalesLine,TempVATAmountLine,2);
            ToSalesLine.CalcSums("Prepmt. Amt. Incl. VAT");
            TotalAmt := ToSalesLine."Prepmt. Amt. Incl. VAT";
            ToSalesLine.FindLast;
            if InitInvoiceRoundingLine(SalesHeader,TotalAmt,InvRoundingSalesLine) then
              with ToSalesLine do begin
                NextLineNo := "Line No." + 1;
                ToSalesLine := InvRoundingSalesLine;
                "Line No." := NextLineNo;

                if DocumentType <> Documenttype::"Credit Memo" then
                  "Prepmt. Line Amount" := "Line Amount"
                else
                  "Prepmt. Amt. Inv." := "Line Amount";
                "Prepmt. VAT Calc. Type" := "VAT Calculation Type";
                "Prepayment VAT Identifier" := "VAT Identifier";
                "Prepayment Tax Group Code" := "Tax Group Code";
                "Prepayment VAT Identifier" := "VAT Identifier";
                "Prepayment Tax Group Code" := "Tax Group Code";
                "Prepayment VAT %" := "VAT %";
                Insert;
              end;
          end;
        end;
    end;

    local procedure CheckDim(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine."Line No." := 0;
        CheckDimValuePosting(SalesHeader,SalesLine);
        CheckDimComb(SalesHeader,SalesLine);

        SalesLine.SetRange("Document Type",SalesHeader."Document Type");
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        SalesLine.SetFilter(Type,'<>%1',SalesLine.Type::" ");
        if SalesLine.Find('-') then
          repeat
            CheckDimComb(SalesHeader,SalesLine);
            CheckDimValuePosting(SalesHeader,SalesLine);
          until SalesLine.Next = 0;
    end;

    local procedure ApplyFilter(SalesHeader: Record "Sales Header";DocumentType: Option Invoice,"Credit Memo",Statistic;var SalesLine: Record "Sales Line")
    begin
        with SalesLine do begin
          Reset;
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          SetFilter(Type,'<>%1',Type::" ");
          if DocumentType in [Documenttype::Invoice,Documenttype::Statistic] then
            SetFilter("Prepmt. Line Amount",'<>0')
          else
            SetFilter("Prepmt. Amt. Inv.",'<>0');
        end;
    end;


    procedure PrepmtAmount(SalesLine: Record "Sales Line";DocumentType: Option Invoice,"Credit Memo",Statistic;IncludeTax: Boolean): Decimal
    var
        PrepmtAmt: Decimal;
    begin
        with SalesLine do begin
          case DocumentType of
            Documenttype::Statistic:
              PrepmtAmt := "Prepmt. Line Amount";
            Documenttype::Invoice:
              PrepmtAmt := "Prepmt. Line Amount" - "Prepmt. Amt. Inv.";
            else
              PrepmtAmt := "Prepmt. Amt. Inv." - "Prepmt Amt Deducted";
          end;
          if IncludeTax then
            PrepmtAmt := CalcAmountIncludingTax(PrepmtAmt);
          exit(PrepmtAmt);
        end;
    end;

    local procedure CheckDimComb(SalesHeader: Record "Sales Header";SalesLine: Record "Sales Line")
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        if SalesLine."Line No." = 0 then
          if not DimMgt.CheckDimIDComb(SalesHeader."Dimension Set ID") then
            Error(Text007,SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimCombErr);

        if SalesLine."Line No." <> 0 then
          if not DimMgt.CheckDimIDComb(SalesLine."Dimension Set ID") then
            Error(Text008,SalesHeader."Document Type",SalesHeader."No.",SalesLine."Line No.",DimMgt.GetDimCombErr);
    end;

    local procedure CheckDimValuePosting(SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line")
    var
        DimMgt: Codeunit DimensionManagement;
        TableIDArr: array [10] of Integer;
        NumberArr: array [10] of Code[20];
    begin
        if SalesLine."Line No." = 0 then begin
          TableIDArr[1] := Database::Customer;
          NumberArr[1] := SalesHeader."Bill-to Customer No.";
          TableIDArr[2] := Database::Job;
          // NumberArr[2] := SalesHeader."Job No.";
          TableIDArr[3] := Database::"Salesperson/Purchaser";
          NumberArr[3] := SalesHeader."Salesperson Code";
          TableIDArr[4] := Database::Campaign;
          NumberArr[4] := SalesHeader."Campaign No.";
          TableIDArr[5] := Database::"Responsibility Center";
          NumberArr[5] := SalesHeader."Responsibility Center";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,SalesHeader."Dimension Set ID") then
            Error(
              Text009,
              SalesHeader."Document Type",SalesHeader."No.",DimMgt.GetDimValuePostingErr);
        end else begin
          TableIDArr[1] := DimMgt.TypeToTableID3(SalesLine.Type);
          NumberArr[1] := SalesLine."No.";
          TableIDArr[2] := Database::Job;
          NumberArr[2] := SalesLine."Job No.";
          if not DimMgt.CheckDimValuePosting(TableIDArr,NumberArr,SalesLine."Dimension Set ID") then
            Error(
              Text010,
              SalesHeader."Document Type",SalesHeader."No.",SalesLine."Line No.",DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure PostPrepmtInvLineBuffer(SalesHeader: Record "Sales Header";PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";DocumentType: Option Invoice,"Credit Memo";PostingDescription: Text[50];DocType: Option;DocNo: Code[20];ExtDocNo: Text[35];SrcCode: Code[10];PostingNoSeriesCode: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
          InitNewLine(
            SalesHeader."Posting Date",SalesHeader."Document Date",PostingDescription,
            PrepmtInvLineBuffer."Global Dimension 1 Code",PrepmtInvLineBuffer."Global Dimension 2 Code",
            PrepmtInvLineBuffer."Dimension Set ID",SalesHeader."Reason Code");

          CopyDocumentFields(DocType,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode);
          CopyFromSalesHeaderPrepmt(SalesHeader);
          CopyFromPrepmtInvoiceBuffer(PrepmtInvLineBuffer);

          if not PrepmtInvLineBuffer.Adjustment then
            "Gen. Posting Type" := "gen. posting type"::Sale;
          Correction :=
            (DocumentType = Documenttype::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";

          RunGenJnlPostLine(GenJnlLine);
        end;
    end;

    local procedure PostCustomerEntry(SalesHeader: Record "Sales Header";TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer";DocumentType: Option Invoice,"Credit Memo";PostingDescription: Text[50];DocType: Option;DocNo: Code[20];ExtDocNo: Text[35];SrcCode: Code[10];PostingNoSeriesCode: Code[10];CalcPmtDisc: Boolean)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
          InitNewLine(
            SalesHeader."Posting Date",SalesHeader."Document Date",PostingDescription,
            SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

          CopyDocumentFields(DocType,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode);

          CopyFromSalesHeaderPrepmtPost(SalesHeader,(DocumentType = Documenttype::Invoice) or CalcPmtDisc);

          Amount := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
          "Source Currency Amount" := -TotalPrepmtInvLineBuffer."Amount Incl. VAT";
          "Amount (LCY)" := -TotalPrepmtInvLineBufferLCY."Amount Incl. VAT";
          "Sales/Purch. (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;
          "Profit (LCY)" := -TotalPrepmtInvLineBufferLCY.Amount;

          Correction := (DocumentType = Documenttype::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure PostBalancingEntry(SalesHeader: Record "Sales Header";TotalPrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer";TotalPrepmtInvLineBufferLCY: Record "Prepayment Inv. Line Buffer";CustLedgEntry: Record "Cust. Ledger Entry";DocumentType: Option Invoice,"Credit Memo";PostingDescription: Text[50];DocType: Option;DocNo: Code[20];ExtDocNo: Text[35];SrcCode: Code[10];PostingNoSeriesCode: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
          InitNewLine(
            SalesHeader."Posting Date",SalesHeader."Document Date",PostingDescription,
            SalesHeader."Shortcut Dimension 1 Code",SalesHeader."Shortcut Dimension 2 Code",
            SalesHeader."Dimension Set ID",SalesHeader."Reason Code");

          if DocType = "document type"::"Credit Memo" then
            CopyDocumentFields("document type"::Refund,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode)
          else
            CopyDocumentFields("document type"::Payment,DocNo,ExtDocNo,SrcCode,PostingNoSeriesCode);

          CopyFromSalesHeaderPrepmtPost(SalesHeader,false);
          if SalesHeader."Bal. Account Type" = SalesHeader."bal. account type"::"Bank Account" then
            "Bal. Account Type" := "bal. account type"::"Bank Account";
          "Bal. Account No." := SalesHeader."Bal. Account No.";

          Amount := TotalPrepmtInvLineBuffer."Amount Incl. VAT" + CustLedgEntry."Remaining Pmt. Disc. Possible";
          "Source Currency Amount" := Amount;
          CustLedgEntry.CalcFields(Amount);
          if CustLedgEntry.Amount = 0 then
            "Amount (LCY)" := TotalPrepmtInvLineBufferLCY."Amount Incl. VAT"
          else
            "Amount (LCY)" :=
              TotalPrepmtInvLineBufferLCY."Amount Incl. VAT" +
              ROUND(
                CustLedgEntry."Remaining Pmt. Disc. Possible" / CustLedgEntry."Adjusted Currency Factor");

          Correction := (DocumentType = Documenttype::"Credit Memo") and GLSetup."Mark Cr. Memos as Corrections";

          "Applies-to Doc. Type" := DocType;
          "Applies-to Doc. No." := DocNo;

          GenJnlPostLine.RunWithCheck(GenJnlLine);
        end;
    end;

    local procedure RunGenJnlPostLine(var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlPostLine.RunWithCheck(GenJnlLine);
    end;


    procedure UpdatePrepmtAmountOnSaleslines(SalesHeader: Record "Sales Header";NewTotalPrepmtAmount: Decimal)
    var
        Currency: Record Currency;
        SalesLine: Record "Sales Line";
        TotalLineAmount: Decimal;
        TotalPrepmtAmount: Decimal;
        TotalPrepmtAmtInv: Decimal;
        LastLineNo: Integer;
    begin
        Currency.Initialize(SalesHeader."Currency Code");

        with SalesLine do begin
          SetRange("Document Type",SalesHeader."Document Type");
          SetRange("Document No.",SalesHeader."No.");
          SetFilter(Type,'<>%1',Type::" ");
          SetFilter("Line Amount",'<>0');
          SetFilter("Prepayment %",'<>0');
          LockTable;
          if Find('-') then
            repeat
              TotalLineAmount := TotalLineAmount + "Line Amount";
              TotalPrepmtAmtInv := TotalPrepmtAmtInv + "Prepmt. Amt. Inv.";
              LastLineNo := "Line No.";
            until Next = 0
          else
            Error(Text017,FieldCaption("Prepayment %"));
          if TotalLineAmount = 0 then
            Error(Text013,NewTotalPrepmtAmount);
          if not (NewTotalPrepmtAmount in [TotalPrepmtAmtInv ..TotalLineAmount]) then
            Error(Text016,TotalPrepmtAmtInv,TotalLineAmount);
          if Find('-') then
            repeat
              if "Line No." <> LastLineNo then
                Validate(
                  "Prepmt. Line Amount",
                  ROUND(
                    NewTotalPrepmtAmount * "Line Amount" / TotalLineAmount,
                    Currency."Amount Rounding Precision"))
              else
                Validate("Prepmt. Line Amount",NewTotalPrepmtAmount - TotalPrepmtAmount);
              TotalPrepmtAmount := TotalPrepmtAmount + "Prepmt. Line Amount";
              Modify;
            until Next = 0;
        end;
    end;

    local procedure CreateDimensions(var SalesLine: Record "Sales Line")
    var
        SourceCodeSetup: Record "Source Code Setup";
        DimMgt: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        SourceCodeSetup.Get;
        TableID[1] := Database::"G/L Account";
        No[1] := SalesLine."No.";
        TableID[2] := Database::Job;
        No[2] := SalesLine."Job No.";
        TableID[3] := Database::"Responsibility Center";
        No[3] := SalesLine."Responsibility Center";
        SalesLine."Shortcut Dimension 1 Code" := '';
        SalesLine."Shortcut Dimension 2 Code" := '';
        SalesLine."Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup.Sales,
            SalesLine."Shortcut Dimension 1 Code",SalesLine."Shortcut Dimension 2 Code",SalesLine."Dimension Set ID",Database::Customer);
    end;

    local procedure PrepmtDocTypeToDocType(DocumentType: Option Invoice,"Credit Memo"): Integer
    begin
        case DocumentType of
          Documenttype::Invoice:
            exit(2);
          Documenttype::"Credit Memo":
            exit(3);
        end;
        exit(2);
    end;


    procedure GetSalesLinesToDeduct(SalesHeader: Record "Sales Header";var SalesLines: Record "Sales Line")
    var
        SalesLine: Record "Sales Line";
    begin
        ApplyFilter(SalesHeader,1,SalesLine);
        if SalesLine.FindSet then
          repeat
            if (PrepmtAmount(SalesLine,0,SalesHeader."Prepmt. Include Tax") <> 0) and
               (PrepmtAmount(SalesLine,1,SalesHeader."Prepmt. Include Tax") <> 0)
            then begin
              SalesLines := SalesLine;
              SalesLines.Insert;
            end;
          until SalesLine.Next = 0;
    end;

    local procedure PrepmtVATDiffAmount(SalesLine: Record "Sales Line";DocumentType: Option Invoice,"Credit Memo",Statistic): Decimal
    begin
        with SalesLine do
          case DocumentType of
            Documenttype::Statistic:
              exit("Prepayment VAT Difference");
            Documenttype::Invoice:
              exit("Prepayment VAT Difference");
            else
              exit("Prepmt VAT Diff. to Deduct");
          end;
    end;


    procedure UpdateSalesTaxOnLines(var SalesLine: Record "Sales Line";IncludeTax: Boolean;DocumentType: Option Invoice,"Credit Memo")
    begin
        with SalesLine do begin
          if FindSet then
            repeat
              "Prepayment Amount" := PrepmtAmount(SalesLine,DocumentType,IncludeTax);
              "Prepmt. Amt. Incl. VAT" := "Prepayment Amount";
              "Prepayment VAT %" := 0;
              Modify;
            until Next = 0;
        end;
    end;

    local procedure UpdateSalesDocument(var SalesHeader: Record "Sales Header";var SalesLine: Record "Sales Line";DocumentType: Option Invoice,"Credit Memo";GenJnlLineDocNo: Code[20])
    begin
        with SalesHeader do begin
          SalesLine.Reset;
          SalesLine.SetRange("Document Type","Document Type");
          SalesLine.SetRange("Document No.","No.");
          if DocumentType = Documenttype::Invoice then begin
            "Last Prepayment No." := GenJnlLineDocNo;
            "Prepayment No." := '';
            SalesLine.SetFilter("Prepmt. Line Amount",'<>0');
            if SalesLine.FindSet(true) then
              repeat
                if SalesLine."Prepmt. Line Amount" <> SalesLine."Prepmt. Amt. Inv." then begin
                  SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt. Line Amount";
                  SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Incl. VAT";
                  SalesLine.CalcPrepaymentToDeduct;
                  SalesLine."Prepmt VAT Diff. to Deduct" :=
                    SalesLine."Prepmt VAT Diff. to Deduct" + SalesLine."Prepayment VAT Difference";
                  SalesLine."Prepayment VAT Difference" := 0;
                  SalesLine.Modify;
                end;
              until SalesLine.Next = 0;
          end else begin
            "Last Prepmt. Cr. Memo No." := GenJnlLineDocNo;
            "Prepmt. Cr. Memo No." := '';
            SalesLine.SetFilter("Prepmt. Amt. Inv.",'<>0');
            if SalesLine.FindSet(true) then
              repeat
                SalesLine."Prepmt. Amt. Inv." := SalesLine."Prepmt Amt Deducted";
                if "Prices Including VAT" then
                  SalesLine."Prepmt. Amount Inv. Incl. VAT" := SalesLine."Prepmt. Amt. Inv."
                else
                  SalesLine."Prepmt. Amount Inv. Incl. VAT" :=
                    ROUND(
                      SalesLine."Prepmt. Amt. Inv." * (100 + SalesLine."Prepayment VAT %") / 100,
                      GetCurrencyAmountRoundingPrecision(SalesLine."Currency Code"));
                SalesLine."Prepmt. Amt. Incl. VAT" := SalesLine."Prepmt. Amount Inv. Incl. VAT";
                SalesLine."Prepayment Amount" := SalesLine."Prepmt. Amt. Inv.";
                SalesLine."Prepmt Amt to Deduct" := 0;
                SalesLine."Prepmt VAT Diff. to Deduct" := 0;
                SalesLine."Prepayment VAT Difference" := 0;
                SalesLine.Modify;
              until SalesLine.Next = 0;
          end;
        end;
    end;

    local procedure InsertSalesInvHeader(var SalesInvHeader: Record "Sales Invoice Header";SalesHeader: Record "Sales Header";PostingDescription: Text[50];GenJnlLineDocNo: Code[20];SrcCode: Code[10];PostingNoSeriesCode: Code[10])
    begin
        with SalesHeader do begin
          SalesInvHeader.Init;
          SalesInvHeader.TransferFields(SalesHeader);
          SalesInvHeader."Posting Description" := PostingDescription;
          SalesInvHeader."Payment Terms Code" := "Prepmt. Payment Terms Code";
          SalesInvHeader."Due Date" := "Prepayment Due Date";
          SalesInvHeader."Pmt. Discount Date" := "Prepmt. Pmt. Discount Date";
          SalesInvHeader."Payment Discount %" := "Prepmt. Payment Discount %";
          SalesInvHeader."No." := GenJnlLineDocNo;
          SalesInvHeader."Pre-Assigned No. Series" := '';
          SalesInvHeader."Source Code" := SrcCode;
          SalesInvHeader."User ID" := UserId;
          SalesInvHeader."No. Printed" := 0;
          SalesInvHeader."Prepayment Invoice" := true;
          SalesInvHeader."Prepayment Order No." := "No.";
          SalesInvHeader."No. Series" := PostingNoSeriesCode;
          SalesInvHeader."Tax Liable" := false;
          SalesInvHeader."Tax Area Code" := '';
          SalesInvHeader.Insert;
        end;
    end;

    local procedure InsertSalesInvLine(SalesInvHeader: Record "Sales Invoice Header";LineNo: Integer;PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        with PrepmtInvLineBuffer do begin
          SalesInvLine.Init;
          SalesInvLine."Document No." := SalesInvHeader."No.";
          SalesInvLine."Line No." := LineNo;
          SalesInvLine."Sell-to Customer No." := SalesInvHeader."Sell-to Customer No.";
          SalesInvLine."Bill-to Customer No." := SalesInvHeader."Bill-to Customer No.";
          SalesInvLine.Type := SalesInvLine.Type::"G/L Account";
          SalesInvLine."No." := "G/L Account No.";
          SalesInvLine."Posting Date" := SalesInvHeader."Posting Date";
          SalesInvLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
          SalesInvLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
          SalesInvLine."Dimension Set ID" := "Dimension Set ID";
          SalesInvLine.Description := Description;
          SalesInvLine.Quantity := 1;
          if SalesInvHeader."Prices Including VAT" then begin
            SalesInvLine."Unit Price" := "Amount Incl. VAT";
            SalesInvLine."Line Amount" := "Amount Incl. VAT";
          end else begin
            SalesInvLine."Unit Price" := Amount;
            SalesInvLine."Line Amount" := Amount;
          end;
          SalesInvLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          SalesInvLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          SalesInvLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
          SalesInvLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
          SalesInvLine."VAT %" := "VAT %";
          SalesInvLine.Amount := Amount;
          SalesInvLine."VAT Difference" := "VAT Difference";
          SalesInvLine."Amount Including VAT" := "Amount Incl. VAT";
          SalesInvLine."VAT Calculation Type" := "VAT Calculation Type";
          SalesInvLine."VAT Base Amount" := "VAT Base Amount";
          SalesInvLine."VAT Identifier" := "VAT Identifier";
          SalesInvLine.Insert;
        end;
    end;

    local procedure InsertSalesCrMemoHeader(var SalesCrMemoHeader: Record "Sales Cr.Memo Header";SalesHeader: Record "Sales Header";PostingDescription: Text[50];GenJnlLineDocNo: Code[20];SrcCode: Code[10];PostingNoSeriesCode: Code[10];CalcPmtDiscOnCrMemos: Boolean)
    begin
        with SalesHeader do begin
          SalesCrMemoHeader.Init;
          SalesCrMemoHeader.TransferFields(SalesHeader);
          SalesCrMemoHeader."Payment Terms Code" := "Prepmt. Payment Terms Code";
          SalesCrMemoHeader."Pmt. Discount Date" := "Prepmt. Pmt. Discount Date";
          SalesCrMemoHeader."Payment Discount %" := "Prepmt. Payment Discount %";
          if ("Prepmt. Payment Terms Code" <> '') and not CalcPmtDiscOnCrMemos then begin
            SalesCrMemoHeader."Payment Discount %" := 0;
            SalesCrMemoHeader."Pmt. Discount Date" := 0D;
          end;
          SalesCrMemoHeader."Posting Description" := PostingDescription;
          SalesCrMemoHeader."Due Date" := "Prepayment Due Date";
          SalesCrMemoHeader."No." := GenJnlLineDocNo;
          SalesCrMemoHeader."Pre-Assigned No. Series" := '';
          SalesCrMemoHeader."Source Code" := SrcCode;
          SalesCrMemoHeader."User ID" := UserId;
          SalesCrMemoHeader."No. Printed" := 0;
          SalesCrMemoHeader."Prepayment Credit Memo" := true;
          SalesCrMemoHeader."Prepayment Order No." := "No.";
          SalesCrMemoHeader.Correction := GLSetup."Mark Cr. Memos as Corrections";
          SalesCrMemoHeader."No. Series" := PostingNoSeriesCode;
          SalesCrMemoHeader."Tax Liable" := false;
          SalesCrMemoHeader."Tax Area Code" := '';
          SalesCrMemoHeader.Insert;
        end;
    end;

    local procedure InsertSalesCrMemoLine(SalesCrMemoHeader: Record "Sales Cr.Memo Header";LineNo: Integer;PrepmtInvLineBuffer: Record "Prepayment Inv. Line Buffer")
    var
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
    begin
        with PrepmtInvLineBuffer do begin
          SalesCrMemoLine.Init;
          SalesCrMemoLine."Document No." := SalesCrMemoHeader."No.";
          SalesCrMemoLine."Line No." := LineNo;
          SalesCrMemoLine."Sell-to Customer No." := SalesCrMemoHeader."Sell-to Customer No.";
          SalesCrMemoLine."Bill-to Customer No." := SalesCrMemoHeader."Bill-to Customer No.";
          SalesCrMemoLine.Type := SalesCrMemoLine.Type::"G/L Account";
          SalesCrMemoLine."No." := "G/L Account No.";
          SalesCrMemoLine."Posting Date" := SalesCrMemoHeader."Posting Date";
          SalesCrMemoLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
          SalesCrMemoLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
          SalesCrMemoLine."Dimension Set ID" := "Dimension Set ID";
          SalesCrMemoLine.Description := Description;
          SalesCrMemoLine.Quantity := 1;
          if SalesCrMemoHeader."Prices Including VAT" then begin
            SalesCrMemoLine."Unit Price" := "Amount Incl. VAT";
            SalesCrMemoLine."Line Amount" := "Amount Incl. VAT";
          end else begin
            SalesCrMemoLine."Unit Price" := Amount;
            SalesCrMemoLine."Line Amount" := Amount;
          end;
          SalesCrMemoLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
          SalesCrMemoLine."Gen. Prod. Posting Group" := "Gen. Prod. Posting Group";
          SalesCrMemoLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
          SalesCrMemoLine."VAT Prod. Posting Group" := "VAT Prod. Posting Group";
          SalesCrMemoLine."VAT %" := "VAT %";
          SalesCrMemoLine.Amount := Amount;
          SalesCrMemoLine."VAT Difference" := "VAT Difference";
          SalesCrMemoLine."Amount Including VAT" := "Amount Incl. VAT";
          SalesCrMemoLine."VAT Calculation Type" := "VAT Calculation Type";
          SalesCrMemoLine."VAT Base Amount" := "VAT Base Amount";
          SalesCrMemoLine."VAT Identifier" := "VAT Identifier";
          SalesCrMemoLine.Insert;
        end;
    end;

    local procedure GetCalcPmtDiscOnCrMemos(PrepmtPmtTermsCode: Code[10]): Boolean
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if PrepmtPmtTermsCode = '' then
          exit(false);
        PaymentTerms.Get(PrepmtPmtTermsCode);
        exit(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
    end;
}

