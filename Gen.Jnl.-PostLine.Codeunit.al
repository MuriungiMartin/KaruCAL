#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 12 "Gen. Jnl.-Post Line"
{
    Permissions = TableData "G/L Entry"=imd,
                  TableData "Cust. Ledger Entry"=imd,
                  TableData "Vendor Ledger Entry"=imd,
                  TableData "G/L Register"=imd,
                  TableData "G/L Entry - VAT Entry Link"=rimd,
                  TableData "VAT Entry"=imd,
                  TableData "Bank Account Ledger Entry"=imd,
                  TableData "Check Ledger Entry"=imd,
                  TableData "Detailed Cust. Ledg. Entry"=imd,
                  TableData "Detailed Vendor Ledg. Entry"=imd,
                  TableData "Line Fee Note on Report Hist."=rim,
                  TableData "FA Ledger Entry"=rimd,
                  TableData "FA Register"=imd,
                  TableData "Maintenance Ledger Entry"=rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;
        RunWithCheck(Rec);
    end;

    var
        NeedsRoundingErr: label '%1 needs to be rounded';
        PurchaseAlreadyExistsErr: label 'Purchase %1 %2 already exists for this vendor.', Comment='%1 = Document Type; %2 = Document No.';
        BankPaymentTypeMustNotBeFilledErr: label 'Bank Payment Type must not be filled if Currency Code is different in Gen. Journal Line and Bank Account.';
        DocNoMustBeEnteredErr: label 'Document No. must be entered when Bank Payment Type is %1.';
        CheckAlreadyExistsErr: label 'Check %1 already exists for this Bank Account.';
        GLSetup: Record "General Ledger Setup";
        GlobalGLEntry: Record "G/L Entry";
        TempGLEntryBuf: Record "G/L Entry" temporary;
        TempGLEntryVAT: Record "G/L Entry" temporary;
        GLReg: Record "G/L Register";
        AddCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        VATEntry: Record "VAT Entry";
        TaxDetail: Record "Tax Detail";
        UnrealizedCustLedgEntry: Record "Cust. Ledger Entry";
        UnrealizedVendLedgEntry: Record "Vendor Ledger Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        TempVATEntry: Record "VAT Entry" temporary;
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        TransferCustomFields: Codeunit "Transfer Custom Fields";
        DeferralUtilities: Codeunit "Deferral Utilities";
        DeferralDocType: Option Purchase,Sales,"G/L";
        LastDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        AddCurrencyCode: Code[10];
        GLSourceCode: Code[10];
        LastDocNo: Code[20];
        FiscalYearStartDate: Date;
        CurrencyDate: Date;
        LastDate: Date;
        BalanceCheckAmount: Decimal;
        BalanceCheckAmount2: Decimal;
        BalanceCheckAddCurrAmount: Decimal;
        BalanceCheckAddCurrAmount2: Decimal;
        CurrentBalance: Decimal;
        TotalAddCurrAmount: Decimal;
        TotalAmount: Decimal;
        UnrealizedRemainingAmountCust: Decimal;
        UnrealizedRemainingAmountVend: Decimal;
        AmountRoundingPrecision: Decimal;
        AddCurrGLEntryVATAmt: Decimal;
        CurrencyFactor: Decimal;
        ExpenseAmount: Decimal;
        FirstEntryNo: Integer;
        NextEntryNo: Integer;
        NextVATEntryNo: Integer;
        FirstNewVATEntryNo: Integer;
        NextTransactionNo: Integer;
        NextConnectionNo: Integer;
        NextCheckEntryNo: Integer;
        InsertedTempGLEntryVAT: Integer;
        GLEntryNo: Integer;
        UseCurrFactorOnly: Boolean;
        NonAddCurrCodeOccured: Boolean;
        FADimAlreadyChecked: Boolean;
        ResidualRoundingErr: label 'Residual caused by rounding of %1';
        DimensionUsedErr: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5.', Comment='Comment';
        OverrideDimErr: Boolean;
        JobLine: Boolean;
        CheckUnrealizedCust: Boolean;
        CheckUnrealizedVend: Boolean;
        GLSetupRead: Boolean;
        InvalidPostingDateErr: label '%1 is not within the range of posting dates for your company.', Comment='%1=The date passed in for the posting date.';
        DescriptionMustNotBeBlankErr: label 'When %1 is selected for %2, %3 must have a value.', Comment='%1: Field Omit Default Descr. in Jnl., %2 G/L Account No, %3 Description';
        NoDeferralScheduleErr: label 'You must create a deferral schedule if a deferral template is selected. Line: %1, Deferral Template: %2.', Comment='%1=The line number of the general ledger transaction, %2=The Deferral Template Code';
        ZeroDeferralAmtErr: label 'Deferral amounts cannot be 0. Line: %1, Deferral Template: %2.', Comment='%1=The line number of the general ledger transaction, %2=The Deferral Template Code';
        IsGLRegInserted: Boolean;


    procedure GetGLReg(var NewGLReg: Record "G/L Register")
    begin
        NewGLReg := GLReg;
    end;


    procedure RunWithCheck(var GenJnlLine2: Record "Gen. Journal Line"): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Copy(GenJnlLine2);
        Code(GenJnlLine,true);
        GenJnlLine2 := GenJnlLine;
        exit(GLEntryNo);
    end;


    procedure RunWithoutCheck(var GenJnlLine2: Record "Gen. Journal Line"): Integer
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        GenJnlLine.Copy(GenJnlLine2);
        Code(GenJnlLine,false);
        GenJnlLine2 := GenJnlLine;
        exit(GLEntryNo);
    end;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line";CheckLine: Boolean)
    var
        Balancing: Boolean;
    begin
        GetGLSourceCode;

        with GenJnlLine do begin
          if EmptyLine then begin
            InitLastDocDate(GenJnlLine);
            exit;
          end;

          if CheckLine then begin
            if OverrideDimErr then
              GenJnlCheckLine.SetOverDimErr;
            GenJnlCheckLine.RunCheck(GenJnlLine);
          end;

          AmountRoundingPrecision := InitAmounts(GenJnlLine);

          if "Bill-to/Pay-to No." = '' then
            case true of
              "Account Type" in ["account type"::Customer,"account type"::Vendor]:
                "Bill-to/Pay-to No." := "Account No.";
              "Bal. Account Type" in ["bal. account type"::Customer,"bal. account type"::Vendor]:
                "Bill-to/Pay-to No." := "Bal. Account No.";
            end;
          if "Document Date" = 0D then
            "Document Date" := "Posting Date";
          if "Due Date" = 0D then
            "Due Date" := "Posting Date";

          JobLine := ("Job No." <> '');

          if NextEntryNo = 0 then
            StartPosting(GenJnlLine)
          else
            ContinuePosting(GenJnlLine);

          if "Account No." <> '' then begin
            if ("Bal. Account No." <> '') and
               (not "System-Created Entry") and
               ("Account Type" in
                ["account type"::Customer,
                 "account type"::Vendor,
                 "account type"::"Fixed Asset"])
            then begin
              Codeunit.Run(Codeunit::"Exchange Acc. G/L Journal Line",GenJnlLine);
              Balancing := true;
            end;

            PostGenJnlLine(GenJnlLine,Balancing);
          end;

          if "Bal. Account No." <> '' then begin
            Codeunit.Run(Codeunit::"Exchange Acc. G/L Journal Line",GenJnlLine);
            PostGenJnlLine(GenJnlLine,not Balancing);
          end;

          CheckPostUnrealizedVAT(GenJnlLine,true);

          if "Account No." <> '' then
            if "Account Type" in
               ["account type"::"G/L Account","account type"::Customer,"account type"::Vendor,"account type"::"Bank Account"]
            then
              if ("Deferral Code" <> '') and ("Source Code" = GLSourceCode) then begin
                // Once posting has completed, move the deferral schedule over to Posted Deferral Schedule
                if not Balancing then
                  Codeunit.Run(Codeunit::"Exchange Acc. G/L Journal Line",GenJnlLine);
                DeferralUtilities.CreateScheduleFromGL(GenJnlLine,FirstEntryNo);
              end;

          FinishPosting;
        end;
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line";Balancing: Boolean)
    begin
        with GenJnlLine do
          case "Account Type" of
            "account type"::"G/L Account":
              PostGLAcc(GenJnlLine,Balancing);
            "account type"::Customer:
              PostCust(GenJnlLine,Balancing);
            "account type"::Vendor:
              PostVend(GenJnlLine,Balancing);
            "account type"::"Bank Account":
              PostBankAcc(GenJnlLine,Balancing);
            "account type"::"Fixed Asset":
              PostFixedAsset(GenJnlLine);
            "account type"::"IC Partner":
              PostICPartner(GenJnlLine);
          end;
    end;

    local procedure InitAmounts(var GenJnlLine: Record "Gen. Journal Line"): Decimal
    var
        Currency: Record Currency;
    begin
        with GenJnlLine do begin
          if "Currency Code" = '' then begin
            Currency.InitRoundingPrecision;
            "Amount (LCY)" := Amount;
            "VAT Amount (LCY)" := "VAT Amount";
            "VAT Base Amount (LCY)" := "VAT Base Amount";
          end else begin
            Currency.Get("Currency Code");
            Currency.TestField("Amount Rounding Precision");
            if not "System-Created Entry" then begin
              "Source Currency Code" := "Currency Code";
              "Source Currency Amount" := Amount;
              "Source Curr. VAT Base Amount" := "VAT Base Amount";
              "Source Curr. VAT Amount" := "VAT Amount";
            end;
          end;
          if "Additional-Currency Posting" = "additional-currency posting"::None then begin
            if Amount <> ROUND(Amount,Currency."Amount Rounding Precision") then
              FieldError(
                Amount,
                StrSubstNo(NeedsRoundingErr,Amount));
            if "Amount (LCY)" <> ROUND("Amount (LCY)") then
              FieldError(
                "Amount (LCY)",
                StrSubstNo(NeedsRoundingErr,"Amount (LCY)"));
          end;
          exit(Currency."Amount Rounding Precision");
        end;
    end;

    local procedure InitLastDocDate(GenJnlLine: Record "Gen. Journal Line")
    begin
        with GenJnlLine do begin
          LastDocType := "Document Type";
          LastDocNo := "Document No.";
          LastDate := "Posting Date";
        end;
    end;

    local procedure InitVAT(var GenJnlLine: Record "Gen. Journal Line";var GLEntry: Record "G/L Entry";var VATPostingSetup: Record "VAT Posting Setup")
    var
        LCYCurrency: Record Currency;
        TaxArea: Record "Tax Area";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
    begin
        LCYCurrency.InitRoundingPrecision;
        with GenJnlLine do
          if "Gen. Posting Type" <> 0 then begin // None
            VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group");
            TestField("VAT Calculation Type",VATPostingSetup."VAT Calculation Type");
            case "VAT Posting" of
              "vat posting"::"Automatic VAT Entry":
                begin
                  GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                  case "VAT Calculation Type" of
                    "vat calculation type"::"Normal VAT":
                      if "VAT Difference" <> 0 then begin
                        GLEntry.Amount := "VAT Base Amount (LCY)";
                        GLEntry."VAT Amount" := "Amount (LCY)" - GLEntry.Amount;
                        GLEntry."Additional-Currency Amount" := "Source Curr. VAT Base Amount";
                        if "Source Currency Code" = AddCurrencyCode then
                          AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                        else
                          AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                      end else begin
                        GLEntry."VAT Amount" :=
                          ROUND(
                            "Amount (LCY)" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                            LCYCurrency."Amount Rounding Precision",LCYCurrency.VATRoundingDirection);
                        GLEntry.Amount := "Amount (LCY)" - GLEntry."VAT Amount";
                        if "Source Currency Code" = AddCurrencyCode then
                          AddCurrGLEntryVATAmt :=
                            ROUND(
                              "Source Currency Amount" * VATPostingSetup."VAT %" / (100 + VATPostingSetup."VAT %"),
                              AddCurrency."Amount Rounding Precision",AddCurrency.VATRoundingDirection)
                        else
                          AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                        GLEntry."Additional-Currency Amount" := "Source Currency Amount" - AddCurrGLEntryVATAmt;
                      end;
                    "vat calculation type"::"Reverse Charge VAT":
                      case "Gen. Posting Type" of
                        "gen. posting type"::Purchase:
                          if "VAT Difference" <> 0 then begin
                            GLEntry."VAT Amount" := "VAT Amount (LCY)";
                            if "Source Currency Code" = AddCurrencyCode then
                              AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                            else
                              AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                          end else begin
                            GLEntry."VAT Amount" :=
                              ROUND(
                                GLEntry.Amount * VATPostingSetup."VAT %" / 100,
                                LCYCurrency."Amount Rounding Precision",LCYCurrency.VATRoundingDirection);
                            if "Source Currency Code" = AddCurrencyCode then
                              AddCurrGLEntryVATAmt :=
                                ROUND(
                                  GLEntry."Additional-Currency Amount" * VATPostingSetup."VAT %" / 100,
                                  AddCurrency."Amount Rounding Precision",AddCurrency.VATRoundingDirection)
                            else
                              AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                          end;
                        "gen. posting type"::Sale:
                          begin
                            GLEntry."VAT Amount" := 0;
                            AddCurrGLEntryVATAmt := 0;
                          end;
                      end;
                    "vat calculation type"::"Full VAT":
                      begin
                        case "Gen. Posting Type" of
                          "gen. posting type"::Sale:
                            begin
                              VATPostingSetup.TestField("Sales VAT Account");
                              TestField("Account No.",VATPostingSetup."Sales VAT Account");
                            end;
                          "gen. posting type"::Purchase:
                            begin
                              VATPostingSetup.TestField("Purchase VAT Account");
                              TestField("Account No.",VATPostingSetup."Purchase VAT Account");
                            end;
                        end;
                        GLEntry.Amount := 0;
                        GLEntry."Additional-Currency Amount" := 0;
                        GLEntry."VAT Amount" := "Amount (LCY)";
                        if "Source Currency Code" = AddCurrencyCode then
                          AddCurrGLEntryVATAmt := "Source Currency Amount"
                        else
                          AddCurrGLEntryVATAmt := CalcLCYToAddCurr("Amount (LCY)");
                      end;
                    "vat calculation type"::"Sales Tax":
                      begin
                        if "Tax Area Code" = '' then
                          Clear(TaxArea)
                        else
                          TaxArea.Get("Tax Area Code");
                        if ("Gen. Posting Type" = "gen. posting type"::Purchase) and
                           "Use Tax"
                        then begin
                          if TaxArea."Use External Tax Engine" then
                            GLEntry."VAT Amount" :=
                              ROUND(SalesTaxCalculate.CallExternalTaxEngineForJnl(GenJnlLine,0))
                          else
                            GLEntry."VAT Amount" :=
                              ROUND(
                                SalesTaxCalculate.CalculateTax(
                                  "Tax Area Code","Tax Group Code","Tax Liable",
                                  "Posting Date","Amount (LCY)",Quantity,0));
                          GLEntry.Amount := "Amount (LCY)";
                        end else begin
                          if TaxArea."Use External Tax Engine" then
                            GLEntry.Amount :=
                              ROUND(SalesTaxCalculate.CallExternalTaxEngineForJnl(GenJnlLine,1))
                          else
                            GLEntry.Amount :=
                              ROUND(
                                SalesTaxCalculate.ReverseCalculateTax(
                                  "Tax Area Code","Tax Group Code","Tax Liable",
                                  "Posting Date","Amount (LCY)",Quantity,0));
                          if TaxArea."Use External Tax Engine" then
                            ExpenseAmount :=
                              ROUND(SalesTaxCalculate.CallExternalTaxEngineForJnl(GenJnlLine,2))
                          else
                            ExpenseAmount :=
                              ROUND(
                                SalesTaxCalculate.CalculateExpenseTax(
                                  "Tax Area Code","Tax Group Code","Tax Liable",
                                  "Posting Date",GLEntry.Amount,Quantity,0));
                          GLEntry."VAT Amount" := "Amount (LCY)" - GLEntry.Amount - ExpenseAmount;
                          GLEntry.Amount := GLEntry.Amount + ExpenseAmount
                        end;
                        GLEntry."Additional-Currency Amount" := "Source Currency Amount";
                        if "Source Currency Code" = AddCurrencyCode then
                          AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                        else
                          AddCurrGLEntryVATAmt := CalcLCYToAddCurr(GLEntry."VAT Amount");
                      end;
                  end;
                end;
              "vat posting"::"Manual VAT Entry":
                if "Gen. Posting Type" <> "gen. posting type"::Settlement then begin
                  GLEntry.CopyPostingGroupsFromGenJnlLine(GenJnlLine);
                  GLEntry."VAT Amount" := "VAT Amount (LCY)";
                  if "Source Currency Code" = AddCurrencyCode then
                    AddCurrGLEntryVATAmt := "Source Curr. VAT Amount"
                  else
                    AddCurrGLEntryVATAmt := CalcLCYToAddCurr("VAT Amount (LCY)");
                end;
            end;
          end;
        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(GLEntry.Amount,GLEntry."Additional-Currency Amount",GLEntry."Additional-Currency Amount",true,GenJnlLine);
    end;

    local procedure PostVAT(GenJnlLine: Record "Gen. Journal Line";var GLEntry: Record "G/L Entry";VATPostingSetup: Record "VAT Posting Setup")
    var
        TaxDetail2: Record "Tax Detail";
        SalesTaxCalculate: Codeunit "Sales Tax Calculate";
        VATAmount: Decimal;
        VATAmount2: Decimal;
        VATBase: Decimal;
        VATBase2: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        SrcCurrSalesTaxBaseAmount: Decimal;
        RemSrcCurrVATAmount: Decimal;
        SalesTaxBaseAmount: Decimal;
        TaxDetailFound: Boolean;
    begin
        with GenJnlLine do
          // Post VAT
          // VAT for VAT entry
          case "VAT Calculation Type" of
            "vat calculation type"::"Normal VAT",
            "vat calculation type"::"Reverse Charge VAT",
            "vat calculation type"::"Full VAT":
              begin
                if "VAT Posting" = "vat posting"::"Automatic VAT Entry" then
                  "VAT Base Amount (LCY)" := GLEntry.Amount;
                if "Gen. Posting Type" = "gen. posting type"::Settlement then
                  AddCurrGLEntryVATAmt := "Source Curr. VAT Amount";
                InsertVAT(
                  GenJnlLine,VATPostingSetup,
                  GLEntry.Amount,GLEntry."VAT Amount","VAT Base Amount (LCY)","Source Currency Code",
                  GLEntry."Additional-Currency Amount",AddCurrGLEntryVATAmt,"Source Curr. VAT Base Amount");
                NextConnectionNo := NextConnectionNo + 1;
              end;
            "vat calculation type"::"Sales Tax":
              case "VAT Posting" of
                "vat posting"::"Automatic VAT Entry":
                  begin
                    SalesTaxBaseAmount := GLEntry.Amount - ExpenseAmount;
                    Clear(SalesTaxCalculate);
                    SalesTaxCalculate.InitSalesTaxLines(
                      "Tax Area Code","Tax Group Code","Tax Liable",
                      SalesTaxBaseAmount,Quantity,"Posting Date",GLEntry."VAT Amount");
                    SrcCurrVATAmount := 0;
                    SrcCurrSalesTaxBaseAmount := CalcLCYToAddCurr(SalesTaxBaseAmount);
                    RemSrcCurrVATAmount := AddCurrGLEntryVATAmt;
                    TaxDetailFound := false;
                    while SalesTaxCalculate.GetSalesTaxLine(TaxDetail2,VATAmount,VATBase) do begin
                      RemSrcCurrVATAmount := RemSrcCurrVATAmount - SrcCurrVATAmount;
                      if TaxDetailFound then begin
                        "Tax Jurisdiction Code" := TaxDetail."Tax Jurisdiction Code";
                        InsertVAT(GenJnlLine,VATPostingSetup,
                          SalesTaxBaseAmount,VATAmount2,VATBase2,"Source Currency Code",
                          SrcCurrSalesTaxBaseAmount,SrcCurrVATAmount,SrcCurrVATBase);
                      end;
                      TaxDetailFound := true;
                      TaxDetail := TaxDetail2;
                      VATAmount2 := VATAmount;
                      VATBase2 := VATBase;
                      SrcCurrVATAmount := CalcLCYToAddCurr(VATAmount);
                      SrcCurrVATBase := CalcLCYToAddCurr(VATBase);
                    end;
                    if TaxDetailFound then begin
                      "Tax Jurisdiction Code" := TaxDetail."Tax Jurisdiction Code";
                      InsertVAT(
                        GenJnlLine,VATPostingSetup,
                        SalesTaxBaseAmount,VATAmount2,VATBase2,"Source Currency Code",
                        SrcCurrSalesTaxBaseAmount,RemSrcCurrVATAmount,SrcCurrVATBase);
                    end;
                    InsertSummarizedVAT(GenJnlLine);
                  end;
                "vat posting"::"Manual VAT Entry":
                  begin
                    if "Gen. Posting Type" = "gen. posting type"::Settlement then begin
                      SalesTaxBaseAmount := "VAT Base Amount (LCY)";
                      TaxDetail."Tax Jurisdiction Code" := "Tax Area Code";
                      "Tax Area Code" := '';
                      InsertVAT(
                        GenJnlLine,VATPostingSetup,
                        GLEntry.Amount,GLEntry."VAT Amount","VAT Base Amount (LCY)","Source Currency Code",
                        "Source Curr. VAT Base Amount","Source Curr. VAT Amount","Source Curr. VAT Base Amount");
                    end else begin
                      InsertVAT(
                        GenJnlLine,VATPostingSetup,
                        "VAT Amount (LCY)","VAT Amount (LCY)","VAT Base Amount (LCY)","Source Currency Code",
                        "Source Curr. VAT Amount","Source Curr. VAT Amount","Source Curr. VAT Base Amount");
                      InsertSummarizedVAT(GenJnlLine);
                    end;
                  end;
              end;
          end;
    end;

    local procedure InsertVAT(GenJnlLine: Record "Gen. Journal Line";VATPostingSetup: Record "VAT Posting Setup";GLEntryAmount: Decimal;GLEntryVATAmount: Decimal;GLEntryBaseAmount: Decimal;SrcCurrCode: Code[10];SrcCurrGLEntryAmt: Decimal;SrcCurrGLEntryVATAmt: Decimal;SrcCurrGLEntryBaseAmt: Decimal)
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATAmount: Decimal;
        VATBase: Decimal;
        SrcCurrVATAmount: Decimal;
        SrcCurrVATBase: Decimal;
        VATDifferenceLCY: Decimal;
        SrcCurrVATDifference: Decimal;
        UnrealizedVAT: Boolean;
    begin
        with GenJnlLine do begin
          // Post VAT
          // VAT for VAT entry
          VATEntry.Init;
          VATEntry.CopyFromGenJnlLine(GenJnlLine);
          VATEntry."Entry No." := NextVATEntryNo;
          VATEntry."EU Service" := VATPostingSetup."EU Service";
          VATEntry."Transaction No." := NextTransactionNo;
          VATEntry."Sales Tax Connection No." := NextConnectionNo;
          VATEntry."Tax Exemption No." := "Tax Exemption No.";
          VATEntry."Tax Jurisdiction Code" := "Tax Jurisdiction Code";
          VATEntry."STE Transaction ID" := "STE Transaction ID";
          VATEntry."GST/HST" := "GST/HST";
          if "VAT Calculation Type" = "vat calculation type"::"Sales Tax" then begin
            if "Use Tax" then begin
              GLEntryAmount := -GLEntryAmount;
              GLEntryVATAmount := -GLEntryVATAmount;
              SrcCurrGLEntryAmt := -SrcCurrGLEntryAmt;
              SrcCurrGLEntryVATAmt := -SrcCurrGLEntryVATAmt;
              "VAT Difference" := -"VAT Difference";
              GLEntryBaseAmount := -GLEntryBaseAmount;
              SrcCurrGLEntryBaseAmt := -SrcCurrGLEntryBaseAmt;
            end;
            if "VAT Difference" = 0 then
              VATDifferenceLCY := 0
            else
              if SrcCurrCode = '' then
                VATDifferenceLCY := "VAT Difference"
              else
                VATDifferenceLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Posting Date",SrcCurrCode,"VAT Difference",
                      CurrExchRate.ExchangeRate("Posting Date",SrcCurrCode)));
          end else begin
            if "VAT Difference" = 0 then
              VATDifferenceLCY := 0
            else
              if "Currency Code" = '' then
                VATDifferenceLCY := "VAT Difference"
              else
                VATDifferenceLCY :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      "Posting Date","Currency Code","VAT Difference",
                      CurrExchRate.ExchangeRate("Posting Date","Currency Code")));
          end;

          if "VAT Calculation Type" = "vat calculation type"::"Sales Tax" then begin
            if "Tax Jurisdiction Code" <> '' then
              TaxJurisdiction.Get("Tax Jurisdiction Code");
            if "VAT Posting" = "vat posting"::"Manual VAT Entry" then begin
              TaxDetail.Reset;
              TaxDetail.SetRange("Tax Jurisdiction Code","Tax Jurisdiction Code");
              TaxDetail.SetFilter("Tax Group Code",'%1|%2','',"Tax Group Code");
              TaxDetail.SetRange("Tax Type","Tax Type");
              if "Tax Type" = "tax type"::"Sales and Use Tax" then
                if "Use Tax" then
                  TaxDetail.SetFilter("Tax Type",'%1|%2',TaxDetail."tax type"::"Sales and Use Tax",
                    TaxDetail."tax type"::"Use Tax Only")
                else
                  TaxDetail.SetFilter("Tax Type",'%1|%2',TaxDetail."tax type"::"Sales and Use Tax",
                    TaxDetail."tax type"::"Sales Tax Only");
              TaxDetail.SetRange("Effective Date",0D,"Posting Date");
              if not TaxDetail.FindLast then
                exit;
            end;
            if "Gen. Posting Type" <> "gen. posting type"::Settlement then begin
              VATEntry."Tax Group Used" := TaxDetail."Tax Group Code";
              VATEntry."Tax Type" := TaxDetail."Tax Type";
              VATEntry."Tax on Tax" := TaxDetail."Calculate Tax on Tax";
            end;
            VATEntry."Tax Jurisdiction Code" := TaxDetail."Tax Jurisdiction Code";
          end;

          if AddCurrencyCode <> '' then
            if AddCurrencyCode <> SrcCurrCode then begin
              SrcCurrGLEntryAmt := ExchangeAmtLCYToFCY2(GLEntryAmount);
              SrcCurrGLEntryVATAmt := ExchangeAmtLCYToFCY2(GLEntryVATAmount);
              SrcCurrGLEntryBaseAmt := ExchangeAmtLCYToFCY2(GLEntryBaseAmount);
              SrcCurrVATDifference := ExchangeAmtLCYToFCY2(VATDifferenceLCY);
            end else
              SrcCurrVATDifference := "VAT Difference";

          UnrealizedVAT :=
            (((VATPostingSetup."Unrealized VAT Type" > 0) and
              (VATPostingSetup."VAT Calculation Type" in
               [VATPostingSetup."vat calculation type"::"Normal VAT",
                VATPostingSetup."vat calculation type"::"Reverse Charge VAT",
                VATPostingSetup."vat calculation type"::"Full VAT"])) or
             ((TaxJurisdiction."Unrealized VAT Type" > 0) and
              (VATPostingSetup."VAT Calculation Type" in
               [VATPostingSetup."vat calculation type"::"Sales Tax"]))) and
            IsNotPayment("Document Type");
          if GLSetup."Prepayment Unrealized VAT" and not GLSetup."Unrealized VAT" and
             (VATPostingSetup."Unrealized VAT Type" > 0)
          then
            UnrealizedVAT := Prepayment;

          // VAT for VAT entry
          if "Gen. Posting Type" <> 0 then begin
            case "VAT Posting" of
              "vat posting"::"Automatic VAT Entry":
                begin
                  VATAmount := GLEntryVATAmount;
                  VATBase := GLEntryBaseAmount;
                  SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                  SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                end;
              "vat posting"::"Manual VAT Entry":
                begin
                  if "Gen. Posting Type" = "gen. posting type"::Settlement then begin
                    VATAmount := GLEntryAmount;
                    SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                    VATEntry.Closed := true;
                  end else begin
                    VATAmount := GLEntryVATAmount;
                    SrcCurrVATAmount := SrcCurrGLEntryVATAmt;
                  end;
                  VATBase := GLEntryBaseAmount;
                  SrcCurrVATBase := SrcCurrGLEntryBaseAmt;
                end;
            end;

            if UnrealizedVAT then begin
              VATEntry.Amount := 0;
              VATEntry.Base := 0;
              VATEntry."Unrealized Amount" := VATAmount;
              VATEntry."Unrealized Base" := VATBase;
              VATEntry."Remaining Unrealized Amount" := VATEntry."Unrealized Amount";
              VATEntry."Remaining Unrealized Base" := VATEntry."Unrealized Base";
            end else begin
              VATEntry.Amount := VATAmount;
              VATEntry.Base := VATBase;
              VATEntry."Unrealized Amount" := 0;
              VATEntry."Unrealized Base" := 0;
              VATEntry."Remaining Unrealized Amount" := 0;
              VATEntry."Remaining Unrealized Base" := 0;
            end;

            if AddCurrencyCode = '' then begin
              VATEntry."Additional-Currency Base" := 0;
              VATEntry."Additional-Currency Amount" := 0;
              VATEntry."Add.-Currency Unrealized Amt." := 0;
              VATEntry."Add.-Currency Unrealized Base" := 0;
            end else
              if UnrealizedVAT then begin
                VATEntry."Additional-Currency Base" := 0;
                VATEntry."Additional-Currency Amount" := 0;
                VATEntry."Add.-Currency Unrealized Base" := SrcCurrVATBase;
                VATEntry."Add.-Currency Unrealized Amt." := SrcCurrVATAmount;
              end else begin
                VATEntry."Additional-Currency Base" := SrcCurrVATBase;
                VATEntry."Additional-Currency Amount" := SrcCurrVATAmount;
                VATEntry."Add.-Currency Unrealized Base" := 0;
                VATEntry."Add.-Currency Unrealized Amt." := 0;
              end;
            VATEntry."Add.-Curr. Rem. Unreal. Amount" := VATEntry."Add.-Currency Unrealized Amt.";
            VATEntry."Add.-Curr. Rem. Unreal. Base" := VATEntry."Add.-Currency Unrealized Base";
            VATEntry."VAT Difference" := VATDifferenceLCY;
            VATEntry."Add.-Curr. VAT Difference" := SrcCurrVATDifference;
            TransferCustomFields.GenJnlLineTOTaxEntry(GenJnlLine,VATEntry);

            VATEntry.Insert(true);
            GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.");
            NextVATEntryNo := NextVATEntryNo + 1;
          end;

          // VAT for G/L entry/entries
          if (GLEntryVATAmount <> 0) or
             ((SrcCurrGLEntryVATAmt <> 0) and (SrcCurrCode = AddCurrencyCode))
          then
            case "Gen. Posting Type" of
              "gen. posting type"::Purchase:
                case VATPostingSetup."VAT Calculation Type" of
                  VATPostingSetup."vat calculation type"::"Normal VAT",
                  VATPostingSetup."vat calculation type"::"Full VAT":
                    CreateGLEntry(GenJnlLine,VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                      GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                  VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
                    begin
                      CreateGLEntry(GenJnlLine,VATPostingSetup.GetPurchAccount(UnrealizedVAT),
                        GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                      CreateGLEntry(GenJnlLine,VATPostingSetup.GetRevChargeAccount(UnrealizedVAT),
                        -GLEntryVATAmount,-SrcCurrGLEntryVATAmt,true);
                    end;
                  VATPostingSetup."vat calculation type"::"Sales Tax":
                    if "VAT Posting" = "vat posting"::"Automatic VAT Entry" then begin
                      if "Use Tax" then begin
                        if UnrealizedVAT then begin
                          TaxJurisdiction.TestField("Unreal. Tax Acc. (Purchases)");
                          InitGLEntryVAT(GenJnlLine,TaxJurisdiction."Unreal. Tax Acc. (Purchases)",'',
                            GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                          TaxJurisdiction.TestField("Unreal. Rev. Charge (Purch.)");
                          InitGLEntryVAT(GenJnlLine,TaxJurisdiction."Unreal. Rev. Charge (Purch.)",'',
                            -GLEntryVATAmount,-SrcCurrGLEntryVATAmt,true);
                        end else begin
                          TaxJurisdiction.TestField("Tax Account (Purchases)");
                          InitGLEntryVAT(GenJnlLine,TaxJurisdiction."Tax Account (Purchases)",'',
                            GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                          TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                          InitGLEntryVAT(GenJnlLine,TaxJurisdiction."Reverse Charge (Purchases)",'',
                            -GLEntryVATAmount,-SrcCurrGLEntryVATAmt,true);
                        end;
                      end else begin
                        InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetPurchAccount(UnrealizedVAT),'',
                          GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                      end;
                    end else
                      InitGLEntryVAT(
                        GenJnlLine,"Account No.",'',GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                end;
              "gen. posting type"::Sale:
                case VATPostingSetup."VAT Calculation Type" of
                  VATPostingSetup."vat calculation type"::"Normal VAT",
                  VATPostingSetup."vat calculation type"::"Full VAT":
                    CreateGLEntry(GenJnlLine,VATPostingSetup.GetSalesAccount(UnrealizedVAT),
                      GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                  VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
                    ;
                  VATPostingSetup."vat calculation type"::"Sales Tax":
                    if "VAT Posting" = "vat posting"::"Automatic VAT Entry" then
                      InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetSalesAccount(UnrealizedVAT),'',
                        GLEntryVATAmount,SrcCurrGLEntryVATAmt,true)
                    else // Manual VAT Entry
                      InitGLEntryVAT(GenJnlLine,"Account No.",'',GLEntryVATAmount,SrcCurrGLEntryVATAmt,true);
                end;
            end;
        end;
    end;

    local procedure SummarizeVAT(SummarizeGLEntries: Boolean;GLEntry: Record "G/L Entry")
    var
        InsertedTempVAT: Boolean;
    begin
        InsertedTempVAT := false;
        if SummarizeGLEntries then
          if TempGLEntryVAT.FindSet then
            repeat
              if (TempGLEntryVAT."G/L Account No." = GLEntry."G/L Account No.") and
                 (TempGLEntryVAT."Bal. Account No." = GLEntry."Bal. Account No.")
              then begin
                TempGLEntryVAT.Amount := TempGLEntryVAT.Amount + GLEntry.Amount;
                TempGLEntryVAT."Additional-Currency Amount" :=
                  TempGLEntryVAT."Additional-Currency Amount" + GLEntry."Additional-Currency Amount";
                TempGLEntryVAT.Modify;
                InsertedTempVAT := true;
              end;
            until (TempGLEntryVAT.Next = 0) or InsertedTempVAT;
        if not InsertedTempVAT or not SummarizeGLEntries then begin
          TempGLEntryVAT := GLEntry;
          TempGLEntryVAT."Entry No." :=
            TempGLEntryVAT."Entry No." + InsertedTempGLEntryVAT;
          TempGLEntryVAT.Insert;
          InsertedTempGLEntryVAT := InsertedTempGLEntryVAT + 1;
        end;
    end;

    local procedure InsertSummarizedVAT(GenJnlLine: Record "Gen. Journal Line")
    begin
        if TempGLEntryVAT.FindSet then begin
          repeat
            InsertGLEntry(GenJnlLine,TempGLEntryVAT,true);
          until TempGLEntryVAT.Next = 0;
          TempGLEntryVAT.DeleteAll;
          InsertedTempGLEntryVAT := 0;
        end;
        NextConnectionNo := NextConnectionNo + 1;
    end;

    local procedure PostGLAcc(GenJnlLine: Record "Gen. Journal Line";Balancing: Boolean)
    var
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        with GenJnlLine do begin
          GLAcc.Get("Account No.");
          // G/L entry
          InitGLEntry(GenJnlLine,GLEntry,
            "Account No.","Amount (LCY)",
            "Source Currency Amount",true,"System-Created Entry");
          if not "System-Created Entry" then
            if "Posting Date" = NormalDate("Posting Date") then
              GLAcc.TestField("Direct Posting",true);
          if GLAcc."Omit Default Descr. in Jnl." then
            if DelChr(Description,'=',' ') = '' then
              Error(
                DescriptionMustNotBeBlankErr,
                GLAcc.FieldCaption("Omit Default Descr. in Jnl."),
                GLAcc."No.",
                FieldCaption(Description));
          GLEntry."Gen. Posting Type" := "Gen. Posting Type";
          GLEntry."Bal. Account Type" := "Bal. Account Type";
          GLEntry."Bal. Account No." := "Bal. Account No.";
          GLEntry."No. Series" := "Posting No. Series";
          if "Additional-Currency Posting" =
             "additional-currency posting"::"Additional-Currency Amount Only"
          then begin
            GLEntry."Additional-Currency Amount" := Amount;
            GLEntry.Amount := 0;
          end;
          // Store Entry No. to global variable for return:
          GLEntryNo := GLEntry."Entry No.";
          InitVAT(GenJnlLine,GLEntry,VATPostingSetup);
          if (GLEntry.Amount <> 0) or (GLEntry."Additional-Currency Amount" <> 0) or
             ("VAT Calculation Type" <> "vat calculation type"::"Sales Tax")
          then
            InsertGLEntry(GenJnlLine,GLEntry,true);
          PostJob(GenJnlLine,GLEntry);
          PostVAT(GenJnlLine,GLEntry,VATPostingSetup);
          DeferralPosting("Deferral Code","Source Code","Account No.",GenJnlLine,Balancing);
          OnMoveGenJournalLine(GLEntry.RecordId);
        end;
    end;

    local procedure PostCust(var GenJnlLine: Record "Gen. Journal Line";Balancing: Boolean)
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        Cust: Record Customer;
        CustPostingGr: Record "Customer Posting Group";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ReceivablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
    begin
        with GenJnlLine do begin
          Cust.Get("Account No.");
          Cust.CheckBlockedCustOnJnls(Cust,"Document Type",true);

          if "Posting Group" = '' then begin
            Cust.TestField("Customer Posting Group");
            "Posting Group" := Cust."Customer Posting Group";
          end;
          CustPostingGr.Get("Posting Group");
          ReceivablesAccount := CustPostingGr.GetReceivablesAccount;

          DtldCustLedgEntry.LockTable;
          CustLedgEntry.LockTable;

          InitCustLedgEntry(GenJnlLine,CustLedgEntry);
          TransferCustomFields.GenJnlLineTOCustLedgEntry(GenJnlLine,CustLedgEntry);

          if not Cust."Block Payment Tolerance" then
            CalcPmtTolerancePossible(
              GenJnlLine,CustLedgEntry."Pmt. Discount Date",CustLedgEntry."Pmt. Disc. Tolerance Date",
              CustLedgEntry."Max. Payment Tolerance");

          TempDtldCVLedgEntryBuf.DeleteAll;
          TempDtldCVLedgEntryBuf.Init;
          TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
          TempDtldCVLedgEntryBuf."CV Ledger Entry No." := CustLedgEntry."Entry No.";
          CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
          TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf,CVLedgEntryBuf,true);
          CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
          CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

          CalcPmtDiscPossible(GenJnlLine,CVLedgEntryBuf);

          if "Currency Code" <> '' then begin
            TestField("Currency Factor");
            CVLedgEntryBuf."Original Currency Factor" := "Currency Factor"
          end else
            CVLedgEntryBuf."Original Currency Factor" := 1;
          CVLedgEntryBuf."Adjusted Currency Factor" := CVLedgEntryBuf."Original Currency Factor";

          // Check the document no.
          if "Recurring Method" = 0 then
            if IsNotPayment("Document Type") then begin
              GenJnlCheckLine.CheckSalesDocNoIsNotUsed("Document Type","Document No.");
              CheckSalesExtDocNo(GenJnlLine);
            end;

          // Post application
          ApplyCustLedgEntry(CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Cust);

          // Post customer entry
          CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
          CustLedgEntry."Amount to Apply" := 0;
          CustLedgEntry."Applies-to Doc. No." := '';
          CustLedgEntry.Insert(true);

          // Post detailed customer entries
          DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,CustPostingGr,true);

          // Post Reminder Terms - Note About Line Fee on Report
          LineFeeNoteOnReportHist.Save(CustLedgEntry);

          if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty then
              DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);

          DeferralPosting("Deferral Code","Source Code",ReceivablesAccount,GenJnlLine,Balancing);
          OnMoveGenJournalLine(CustLedgEntry.RecordId);
        end;
    end;

    local procedure PostVend(GenJnlLine: Record "Gen. Journal Line";Balancing: Boolean)
    var
        Vend: Record Vendor;
        VendPostingGr: Record "Vendor Posting Group";
        VendLedgEntry: Record "Vendor Ledger Entry";
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PayablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
    begin
        with GenJnlLine do begin
          Vend.Get("Account No.");
          Vend.CheckBlockedVendOnJnls(Vend,"Document Type",true);

          if "Posting Group" = '' then begin
            Vend.TestField("Vendor Posting Group");
            "Posting Group" := Vend."Vendor Posting Group";
          end;
          VendPostingGr.Get("Posting Group");
          PayablesAccount := VendPostingGr.GetPayablesAccount;

          DtldVendLedgEntry.LockTable;
          VendLedgEntry.LockTable;

          InitVendLedgEntry(GenJnlLine,VendLedgEntry);
          VendLedgEntry."IRS 1099 Code" := "IRS 1099 Code";
          VendLedgEntry."IRS 1099 Amount" := "IRS 1099 Amount";
          TransferCustomFields.GenJnlLineTOVendLedgEntry(GenJnlLine,VendLedgEntry);

          if not Vend."Block Payment Tolerance" then
            CalcPmtTolerancePossible(
              GenJnlLine,VendLedgEntry."Pmt. Discount Date",VendLedgEntry."Pmt. Disc. Tolerance Date",
              VendLedgEntry."Max. Payment Tolerance");

          TempDtldCVLedgEntryBuf.DeleteAll;
          TempDtldCVLedgEntryBuf.Init;
          TempDtldCVLedgEntryBuf.CopyFromGenJnlLine(GenJnlLine);
          TempDtldCVLedgEntryBuf."CV Ledger Entry No." := VendLedgEntry."Entry No.";
          CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
          TempDtldCVLedgEntryBuf.InsertDtldCVLedgEntry(TempDtldCVLedgEntryBuf,CVLedgEntryBuf,true);
          CVLedgEntryBuf.Open := CVLedgEntryBuf."Remaining Amount" <> 0;
          CVLedgEntryBuf.Positive := CVLedgEntryBuf."Remaining Amount" > 0;

          CalcPmtDiscPossible(GenJnlLine,CVLedgEntryBuf);

          if "Currency Code" <> '' then begin
            TestField("Currency Factor");
            CVLedgEntryBuf."Adjusted Currency Factor" := "Currency Factor"
          end else
            CVLedgEntryBuf."Adjusted Currency Factor" := 1;
          CVLedgEntryBuf."Original Currency Factor" := CVLedgEntryBuf."Adjusted Currency Factor";

          // Check the document no.
          if "Recurring Method" = 0 then
            if IsNotPayment("Document Type") then begin
              GenJnlCheckLine.CheckPurchDocNoIsNotUsed("Document Type","Document No.");
              CheckPurchExtDocNo(GenJnlLine);
            end;

          // Post application
          ApplyVendLedgEntry(CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Vend);

          // Post vendor entry
          VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
          VendLedgEntry."Amount to Apply" := 0;
          VendLedgEntry."Applies-to Doc. No." := '';
          VendLedgEntry.Insert(true);

          // Post detailed vendor entries
          DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,VendPostingGr,true);

          if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty then
              DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
          DeferralPosting("Deferral Code","Source Code",PayablesAccount,GenJnlLine,Balancing);
          OnMoveGenJournalLine(VendLedgEntry.RecordId);
        end;
    end;

    local procedure PostBankAcc(GenJnlLine: Record "Gen. Journal Line";Balancing: Boolean)
    var
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        BankAccPostingGr: Record "Bank Account Posting Group";
    begin
        with GenJnlLine do begin
          BankAcc.Get("Account No.");
          BankAcc.TestField(Blocked,false);
          if "Currency Code" = '' then
            BankAcc.TestField("Currency Code",'')
          else
            if BankAcc."Currency Code" <> '' then
              TestField("Currency Code",BankAcc."Currency Code");

          BankAcc.TestField("Bank Acc. Posting Group");
          BankAccPostingGr.Get(BankAcc."Bank Acc. Posting Group");

          BankAccLedgEntry.LockTable;

          InitBankAccLedgEntry(GenJnlLine,BankAccLedgEntry);

          BankAccLedgEntry."Bank Acc. Posting Group" := BankAcc."Bank Acc. Posting Group";
          TransferCustomFields.GenJnlLineTOBankAccLedgEntry(GenJnlLine,BankAccLedgEntry);
          BankAccLedgEntry."Currency Code" := BankAcc."Currency Code";
          if BankAcc."Currency Code" <> '' then
            BankAccLedgEntry.Amount := Amount
          else
            BankAccLedgEntry.Amount := "Amount (LCY)";
          BankAccLedgEntry."Amount (LCY)" := "Amount (LCY)";
          BankAccLedgEntry.Open := Amount <> 0;
          BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
          BankAccLedgEntry.Positive := Amount > 0;
          BankAccLedgEntry.UpdateDebitCredit(Correction);
          BankAccLedgEntry.Insert(true);

          if ((Amount <= 0) and ("Bank Payment Type" = "bank payment type"::"Computer Check") and "Check Printed") or
             (("Bank Payment Type" = "bank payment type"::"Electronic Payment") and "Check Transmitted") or
             ((Amount < 0) and ("Bank Payment Type" = "bank payment type"::"Manual Check"))
          then begin
            if BankAcc."Currency Code" <> "Currency Code" then
              Error(BankPaymentTypeMustNotBeFilledErr);
            case "Bank Payment Type" of
              "bank payment type"::"Computer Check":
                begin
                  TestField("Check Printed",true);
                  CheckLedgEntry.LockTable;
                  CheckLedgEntry.Reset;
                  CheckLedgEntry.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
                  CheckLedgEntry.SetRange("Bank Account No.","Account No.");
                  CheckLedgEntry.SetRange("Entry Status",CheckLedgEntry."entry status"::Printed);
                  CheckLedgEntry.SetRange("Check No.","Document No.");
                  if CheckLedgEntry.FindSet then
                    repeat
                      CheckLedgEntry2 := CheckLedgEntry;
                      CheckLedgEntry2."Entry Status" := CheckLedgEntry2."entry status"::Posted;
                      CheckLedgEntry2."Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
                      CheckLedgEntry2.Modify;
                    until CheckLedgEntry.Next = 0;
                end;
              "bank payment type"::"Electronic Payment":
                begin
                  TestField("Check Transmitted",true);
                  CheckLedgEntry.LockTable;
                  CheckLedgEntry.Reset;
                  CheckLedgEntry.SetCurrentkey("Bank Account No.","Entry Status","Check No.");
                  CheckLedgEntry.SetRange("Bank Account No.","Account No.");
                  CheckLedgEntry.SetFilter("Entry Status",'%1|%2',
                    CheckLedgEntry."entry status"::Transmitted,
                    CheckLedgEntry."entry status"::Printed);
                  CheckLedgEntry.SetRange("Check No.","Document No.");
                  if CheckLedgEntry.Find('-') then
                    repeat
                      CheckLedgEntry2 := CheckLedgEntry;
                      CheckLedgEntry2."Entry Status" := CheckLedgEntry2."entry status"::Posted;
                      CheckLedgEntry2."Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
                      CheckLedgEntry2.Modify;
                    until CheckLedgEntry.Next = 0;
                end;
              "bank payment type"::"Manual Check":
                begin
                  if "Document No." = '' then
                    Error(DocNoMustBeEnteredErr,"Bank Payment Type");
                  CheckLedgEntry.Reset;
                  if NextCheckEntryNo = 0 then begin
                    CheckLedgEntry.LockTable;
                    if CheckLedgEntry.FindLast then
                      NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
                    else
                      NextCheckEntryNo := 1;
                  end;

                  CheckLedgEntry.SetRange("Bank Account No.","Account No.");
                  CheckLedgEntry.SetFilter(
                    "Entry Status",'%1|%2|%3',
                    CheckLedgEntry."entry status"::Printed,
                    CheckLedgEntry."entry status"::Posted,
                    CheckLedgEntry."entry status"::"Financially Voided");
                  CheckLedgEntry.SetRange("Check No.","Document No.");
                  if not CheckLedgEntry.IsEmpty then
                    Error(CheckAlreadyExistsErr,"Document No.");

                  InitCheckLedgEntry(BankAccLedgEntry,CheckLedgEntry);
                  CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."bank payment type"::"Manual Check";
                  if BankAcc."Currency Code" <> '' then
                    CheckLedgEntry.Amount := -Amount
                  else
                    CheckLedgEntry.Amount := -"Amount (LCY)";
                  CheckLedgEntry.Open := (CheckLedgEntry.Amount <> 0);
                  TransferCustomFields.BankAccLedgEntryTOChkLedgEntry(BankAccLedgEntry,CheckLedgEntry);
                  CheckLedgEntry.Insert(true);
                  NextCheckEntryNo := NextCheckEntryNo + 1;
                end;
            end;
          end;

          BankAccPostingGr.TestField("G/L Bank Account No.");
          CreateGLEntryBalAcc(
            GenJnlLine,BankAccPostingGr."G/L Bank Account No.","Amount (LCY)","Source Currency Amount",
            "Bal. Account Type","Bal. Account No.");
          DeferralPosting("Deferral Code","Source Code",BankAccPostingGr."G/L Bank Account No.",GenJnlLine,Balancing);
          OnMoveGenJournalLine(BankAccLedgEntry.RecordId);
        end;
    end;

    local procedure PostFixedAsset(GenJnlLine: Record "Gen. Journal Line")
    var
        GLEntry: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        TempFAGLPostBuf: Record "FA G/L Posting Buffer" temporary;
        FAGLPostBuf: Record "FA G/L Posting Buffer";
        VATPostingSetup: Record "VAT Posting Setup";
        FAJnlPostLine: Codeunit "FA Jnl.-Post Line";
        FAAutomaticEntry: Codeunit "FA Automatic Entry";
        ShortcutDim1Code: Code[20];
        ShortcutDim2Code: Code[20];
        Correction2: Boolean;
        NetDisposalNo: Integer;
        DimensionSetID: Integer;
    begin
        with GenJnlLine do begin
          InitGLEntry(GenJnlLine,GLEntry,'',"Amount (LCY)","Source Currency Amount",true,"System-Created Entry");
          GLEntry."Gen. Posting Type" := "Gen. Posting Type";
          GLEntry."Bal. Account Type" := "Bal. Account Type";
          GLEntry."Bal. Account No." := "Bal. Account No.";
          InitVAT(GenJnlLine,GLEntry,VATPostingSetup);
          GLEntry2 := GLEntry;
          FAJnlPostLine.GenJnlPostLine(
            GenJnlLine,GLEntry2.Amount,GLEntry2."VAT Amount",NextTransactionNo,NextEntryNo,GLReg."No.");
          ShortcutDim1Code := "Shortcut Dimension 1 Code";
          ShortcutDim2Code := "Shortcut Dimension 2 Code";
          DimensionSetID := "Dimension Set ID";
          Correction2 := Correction;
        end;
        with TempFAGLPostBuf do
          if FAJnlPostLine.FindFirstGLAcc(TempFAGLPostBuf) then
            repeat
              GenJnlLine."Shortcut Dimension 1 Code" := "Global Dimension 1 Code";
              GenJnlLine."Shortcut Dimension 2 Code" := "Global Dimension 2 Code";
              GenJnlLine."Dimension Set ID" := "Dimension Set ID";
              GenJnlLine.Correction := Correction;
              FADimAlreadyChecked := "FA Posting Group" <> '';
              CheckDimValueForDisposal(GenJnlLine,"Account No.");
              if "Original General Journal Line" then
                InitGLEntry(GenJnlLine,GLEntry,"Account No.",Amount,GLEntry2."Additional-Currency Amount",true,true)
              else begin
                CheckNonAddCurrCodeOccurred('');
                InitGLEntry(GenJnlLine,GLEntry,"Account No.",Amount,0,false,true);
              end;
              FADimAlreadyChecked := false;
              GLEntry.CopyPostingGroupsFromGLEntry(GLEntry2);
              GLEntry."VAT Amount" := GLEntry2."VAT Amount";
              GLEntry."Bal. Account Type" := GLEntry2."Bal. Account Type";
              GLEntry."Bal. Account No." := GLEntry2."Bal. Account No.";
              GLEntry."FA Entry Type" := "FA Entry Type";
              GLEntry."FA Entry No." := "FA Entry No.";
              if "Net Disposal" then
                NetDisposalNo := NetDisposalNo + 1
              else
                NetDisposalNo := 0;
              if "Automatic Entry" and not "Net Disposal" then
                FAAutomaticEntry.AdjustGLEntry(GLEntry);
              if NetDisposalNo > 1 then
                GLEntry."VAT Amount" := 0;
              if "FA Posting Group" <> '' then begin
                FAGLPostBuf := TempFAGLPostBuf;
                FAGLPostBuf."Entry No." := NextEntryNo;
                FAGLPostBuf.Insert;
              end;
              InsertGLEntry(GenJnlLine,GLEntry,true);
            until FAJnlPostLine.GetNextGLAcc(TempFAGLPostBuf) = 0;
        GenJnlLine."Shortcut Dimension 1 Code" := ShortcutDim1Code;
        GenJnlLine."Shortcut Dimension 2 Code" := ShortcutDim2Code;
        GenJnlLine."Dimension Set ID" := DimensionSetID;
        GenJnlLine.Correction := Correction2;
        GLEntry := GLEntry2;
        TempGLEntryBuf."Entry No." := GLEntry."Entry No."; // Used later in InsertVAT(): GLEntryVATEntryLink.InsertLink(TempGLEntryBuf."Entry No.",VATEntry."Entry No.")
        PostVAT(GenJnlLine,GLEntry,VATPostingSetup);

        FAJnlPostLine.UpdateRegNo(GLReg."No.");
        GenJnlLine.OnMoveGenJournalLine(GLEntry.RecordId);
    end;

    local procedure PostICPartner(GenJnlLine: Record "Gen. Journal Line")
    var
        ICPartner: Record "IC Partner";
        AccountNo: Code[20];
    begin
        with GenJnlLine do begin
          if "Account No." <> ICPartner.Code then
            ICPartner.Get("Account No.");
          if ("Document Type" = "document type"::"Credit Memo") xor (Amount > 0) then begin
            ICPartner.TestField("Receivables Account");
            AccountNo := ICPartner."Receivables Account";
          end else begin
            ICPartner.TestField("Payables Account");
            AccountNo := ICPartner."Payables Account";
          end;

          CreateGLEntryBalAcc(
            GenJnlLine,AccountNo,"Amount (LCY)","Source Currency Amount",
            "Bal. Account Type","Bal. Account No.");
        end;
    end;

    local procedure PostJob(GenJnlLine: Record "Gen. Journal Line";GLEntry: Record "G/L Entry")
    var
        JobPostLine: Codeunit "Job Post-Line";
    begin
        if JobLine then begin
          JobLine := false;
          JobPostLine.PostGenJnlLine(GenJnlLine,GLEntry);
        end;
    end;


    procedure StartPosting(GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        AccountingPeriod: Record "Accounting Period";
    begin
        OnBeforePostGenJnlLine(GenJnlLine);

        with GenJnlLine do begin
          GlobalGLEntry.LockTable;
          if GlobalGLEntry.FindLast then begin
            NextEntryNo := GlobalGLEntry."Entry No." + 1;
            NextTransactionNo := GlobalGLEntry."Transaction No." + 1;
          end else begin
            NextEntryNo := 1;
            NextTransactionNo := 1;
          end;

          InitLastDocDate(GenJnlLine);
          CurrentBalance := 0;

          AccountingPeriod.Reset;
          AccountingPeriod.SetCurrentkey(Closed);
          AccountingPeriod.SetRange(Closed,false);
          AccountingPeriod.FindFirst;
          FiscalYearStartDate := AccountingPeriod."Starting Date";

          GetGLSetup;

          if not GenJnlTemplate.Get("Journal Template Name") then
            GenJnlTemplate.Init;

          VATEntry.LockTable;
          if VATEntry.FindLast then
            NextVATEntryNo := VATEntry."Entry No." + 1
          else
            NextVATEntryNo := 1;
          NextConnectionNo := 1;
          FirstNewVATEntryNo := NextVATEntryNo;

          GLReg.LockTable;
          if GLReg.FindLast then
            GLReg."No." := GLReg."No." + 1
          else
            GLReg."No." := 1;
          GLReg.Init;
          GLReg."From Entry No." := NextEntryNo;
          GLReg."From VAT Entry No." := NextVATEntryNo;
          GLReg."Creation Date" := Today;
          GLReg."Source Code" := "Source Code";
          GLReg."Journal Batch Name" := "Journal Batch Name";
          GLReg."User ID" := UserId;
          IsGLRegInserted := false;

          OnAfterInitGLRegister(GLReg,GenJnlLine);

          GetCurrencyExchRate(GenJnlLine);
          TempGLEntryBuf.DeleteAll;
          CalculateCurrentBalance(
            "Account No.","Bal. Account No.",IncludeVATAmount,"Amount (LCY)","VAT Amount");
        end;
    end;


    procedure ContinuePosting(GenJnlLine: Record "Gen. Journal Line")
    begin
        with GenJnlLine do begin
          if (LastDocType <> "Document Type") or (LastDocNo <> "Document No.") or
             (LastDate <> "Posting Date") or (CurrentBalance = 0) and not "System-Created Entry"
          then begin
            CheckPostUnrealizedVAT(GenJnlLine,false);
            NextTransactionNo := NextTransactionNo + 1;
            InitLastDocDate(GenJnlLine);
            FirstNewVATEntryNo := NextVATEntryNo;
          end;

          GetCurrencyExchRate(GenJnlLine);
          TempGLEntryBuf.DeleteAll;
          CalculateCurrentBalance(
            "Account No.","Bal. Account No.",IncludeVATAmount,"Amount (LCY)","VAT Amount");
        end;
    end;


    procedure FinishPosting()
    var
        CostAccSetup: Record "Cost Accounting Setup";
        TransferGlEntriesToCA: Codeunit "Transfer GL Entries to CA";
        IsTransactionConsistent: Boolean;
    begin
        IsTransactionConsistent :=
          (BalanceCheckAmount = 0) and (BalanceCheckAmount2 = 0) and
          (BalanceCheckAddCurrAmount = 0) and (BalanceCheckAddCurrAmount2 = 0);

        if TempGLEntryBuf.FindSet then begin
          repeat
            GlobalGLEntry := TempGLEntryBuf;
            if AddCurrencyCode = '' then begin
              GlobalGLEntry."Additional-Currency Amount" := 0;
              GlobalGLEntry."Add.-Currency Debit Amount" := 0;
              GlobalGLEntry."Add.-Currency Credit Amount" := 0;
            end;
            GlobalGLEntry."Prior-Year Entry" := GlobalGLEntry."Posting Date" < FiscalYearStartDate;
            GlobalGLEntry.Insert(true);
            OnAfterInsertGlobalGLEntry(GlobalGLEntry);
          until TempGLEntryBuf.Next = 0;

          GLReg."To VAT Entry No." := NextVATEntryNo - 1;
          if (GLReg."From VAT Entry No." = 0) or (GLReg."To VAT Entry No." < GLReg."From VAT Entry No.") then begin
            GLReg."From VAT Entry No." := 0;
            GLReg."To VAT Entry No." := 0;
          end;
          GLReg."To Entry No." := GlobalGLEntry."Entry No.";
          if IsTransactionConsistent then
            if IsGLRegInserted then
              GLReg.Modify
            else begin
              GLReg.Insert;
              IsGLRegInserted := true;
            end;
        end;
        GlobalGLEntry.Consistent(IsTransactionConsistent);

        if CostAccSetup.Get then
          if CostAccSetup."Auto Transfer from G/L" then
            TransferGlEntriesToCA.GetGLEntries;

        FirstEntryNo := 0;
    end;

    local procedure PostUnrealizedVAT(GenJnlLine: Record "Gen. Journal Line")
    begin
        if CheckUnrealizedCust then begin
          CustUnrealizedVAT(GenJnlLine,UnrealizedCustLedgEntry,UnrealizedRemainingAmountCust,0,1,GenJnlLine."Posting Date");
          CheckUnrealizedCust := false;
        end;
        if CheckUnrealizedVend then begin
          VendUnrealizedVAT(GenJnlLine,UnrealizedVendLedgEntry,UnrealizedRemainingAmountVend,0,1,GenJnlLine."Posting Date");
          CheckUnrealizedVend := false;
        end;
    end;

    local procedure CheckPostUnrealizedVAT(GenJnlLine: Record "Gen. Journal Line";CheckCurrentBalance: Boolean)
    begin
        if CheckCurrentBalance and (CurrentBalance = 0) or not CheckCurrentBalance then
          PostUnrealizedVAT(GenJnlLine)
    end;

    local procedure InitGLEntry(GenJnlLine: Record "Gen. Journal Line";var GLEntry: Record "G/L Entry";GLAccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;UseAmountAddCurr: Boolean;SystemCreatedEntry: Boolean)
    var
        GLAcc: Record "G/L Account";
    begin
        if GLAccNo <> '' then begin
          GLAcc.Get(GLAccNo);
          GLAcc.TestField(Blocked,false);
          GLAcc.TestField("Account Type",GLAcc."account type"::Posting);

          // Check the Value Posting field on the G/L Account if it is not checked already in Codeunit 11
          if (not
              ((GLAccNo = GenJnlLine."Account No.") and
               (GenJnlLine."Account Type" = GenJnlLine."account type"::"G/L Account")) or
              ((GLAccNo = GenJnlLine."Bal. Account No.") and
               (GenJnlLine."Bal. Account Type" = GenJnlLine."bal. account type"::"G/L Account"))) and
             not FADimAlreadyChecked
          then
            CheckGLAccDimError(GenJnlLine,GLAccNo);
        end;

        GLEntry.Init;
        GLEntry.CopyFromGenJnlLine(GenJnlLine);
        GLEntry."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;
        GLEntry."GST/HST" := GenJnlLine."GST/HST";
        GLEntry."STE Transaction ID" := GenJnlLine."STE Transaction ID";
        TransferCustomFields.GenJnlLineTOGenLedgEntry(GenJnlLine,GLEntry);
        GLEntry."Additional-Currency Amount" :=
          GLCalcAddCurrency(Amount,AmountAddCurr,GLEntry."Additional-Currency Amount",UseAmountAddCurr,GenJnlLine);
    end;

    local procedure InitGLEntryVAT(GenJnlLine: Record "Gen. Journal Line";AccNo: Code[20];BalAccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;UseAmtAddCurr: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        if UseAmtAddCurr then
          InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,AmountAddCurr,true,true)
        else begin
          InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,false,true);
          GLEntry."Additional-Currency Amount" := AmountAddCurr;
          GLEntry."Bal. Account No." := BalAccNo;
        end;
        SummarizeVAT(GLSetup."Summarize G/L Entries",GLEntry);
    end;

    local procedure InitGLEntryVATCopy(GenJnlLine: Record "Gen. Journal Line";AccNo: Code[20];BalAccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;VATEntry: Record "VAT Entry")
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,false,true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."Bal. Account No." := BalAccNo;
        GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
        SummarizeVAT(GLSetup."Summarize G/L Entries",GLEntry);
    end;


    procedure InsertGLEntry(GenJnlLine: Record "Gen. Journal Line";GLEntry: Record "G/L Entry";CalcAddCurrResiduals: Boolean)
    begin
        with GLEntry do begin
          TestField("G/L Account No.");

          if Amount <> ROUND(Amount) then
            FieldError(
              Amount,
              StrSubstNo(NeedsRoundingErr,Amount));

          UpdateCheckAmounts(
            "Posting Date",Amount,"Additional-Currency Amount",
            BalanceCheckAmount,BalanceCheckAmount2,BalanceCheckAddCurrAmount,BalanceCheckAddCurrAmount2);

          UpdateDebitCredit(GenJnlLine.Correction);
        end;

        TempGLEntryBuf := GLEntry;

        OnBeforeInsertGLEntryBuffer(TempGLEntryBuf,GenJnlLine);

        TempGLEntryBuf.Insert;

        if FirstEntryNo = 0 then
          FirstEntryNo := TempGLEntryBuf."Entry No.";
        NextEntryNo := NextEntryNo + 1;

        if CalcAddCurrResiduals then
          HandleAddCurrResidualGLEntry(GenJnlLine,GLEntry.Amount,GLEntry."Additional-Currency Amount");
    end;

    local procedure CreateGLEntry(GenJnlLine: Record "Gen. Journal Line";AccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;UseAmountAddCurr: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        if UseAmountAddCurr then
          InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,AmountAddCurr,true,true)
        else begin
          InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,false,true);
          GLEntry."Additional-Currency Amount" := AmountAddCurr;
        end;
        InsertGLEntry(GenJnlLine,GLEntry,true);
    end;

    local procedure CreateGLEntryBalAcc(GenJnlLine: Record "Gen. Journal Line";AccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;BalAccType: Option;BalAccNo: Code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,AmountAddCurr,true,true);
        GLEntry."Bal. Account Type" := BalAccType;
        GLEntry."Bal. Account No." := BalAccNo;
        InsertGLEntry(GenJnlLine,GLEntry,true);
        GenJnlLine.OnMoveGenJournalLine(GLEntry.RecordId);
    end;

    local procedure CreateGLEntryGainLoss(GenJnlLine: Record "Gen. Journal Line";AccNo: Code[20];Amount: Decimal;UseAmountAddCurr: Boolean)
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,UseAmountAddCurr,true);
        InsertGLEntry(GenJnlLine,GLEntry,true);
    end;

    local procedure CreateGLEntryVAT(GenJnlLine: Record "Gen. Journal Line";AccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;VATAmount: Decimal;DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer")
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,false,true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf,DtldCVLedgEntryBuf."Gen. Posting Type");
        InsertGLEntry(GenJnlLine,GLEntry,true);
        InsertVATEntriesFromTemp(DtldCVLedgEntryBuf,GLEntry);
    end;

    local procedure CreateGLEntryVATCollectAdj(GenJnlLine: Record "Gen. Journal Line";AccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;VATAmount: Decimal;DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";var AdjAmount: array [4] of Decimal)
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine,GLEntry,AccNo,Amount,0,false,true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry."VAT Amount" := VATAmount;
        GLEntry.CopyPostingGroupsFromDtldCVBuf(DtldCVLedgEntryBuf,DtldCVLedgEntryBuf."Gen. Posting Type");
        InsertGLEntry(GenJnlLine,GLEntry,true);
        CollectAdjustment(AdjAmount,GLEntry.Amount,GLEntry."Additional-Currency Amount");
        InsertVATEntriesFromTemp(DtldCVLedgEntryBuf,GLEntry);
    end;

    local procedure CreateGLEntryFromVATEntry(GenJnlLine: Record "Gen. Journal Line";VATAccNo: Code[20];Amount: Decimal;AmountAddCurr: Decimal;VATEntry: Record "VAT Entry")
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine,GLEntry,VATAccNo,Amount,0,false,true);
        GLEntry."Additional-Currency Amount" := AmountAddCurr;
        GLEntry.CopyPostingGroupsFromVATEntry(VATEntry);
        InsertGLEntry(GenJnlLine,GLEntry,true);
    end;

    local procedure UpdateCheckAmounts(PostingDate: Date;Amount: Decimal;AddCurrAmount: Decimal;var BalanceCheckAmount: Decimal;var BalanceCheckAmount2: Decimal;var BalanceCheckAddCurrAmount: Decimal;var BalanceCheckAddCurrAmount2: Decimal)
    begin
        if PostingDate = NormalDate(PostingDate) then begin
          BalanceCheckAmount :=
            BalanceCheckAmount + Amount * ((PostingDate - 00000101D) MOD 99 + 1);
          BalanceCheckAmount2 :=
            BalanceCheckAmount2 + Amount * ((PostingDate - 00000101D) MOD 98 + 1);
        end else begin
          BalanceCheckAmount :=
            BalanceCheckAmount + Amount * ((NormalDate(PostingDate) - 00000101D + 50) MOD 99 + 1);
          BalanceCheckAmount2 :=
            BalanceCheckAmount2 + Amount * ((NormalDate(PostingDate) - 00000101D + 50) MOD 98 + 1);
        end;

        if AddCurrencyCode <> '' then
          if PostingDate = NormalDate(PostingDate) then begin
            BalanceCheckAddCurrAmount :=
              BalanceCheckAddCurrAmount + AddCurrAmount * ((PostingDate - 00000101D) MOD 99 + 1);
            BalanceCheckAddCurrAmount2 :=
              BalanceCheckAddCurrAmount2 + AddCurrAmount * ((PostingDate - 00000101D) MOD 98 + 1);
          end else begin
            BalanceCheckAddCurrAmount :=
              BalanceCheckAddCurrAmount +
              AddCurrAmount * ((NormalDate(PostingDate) - 00000101D + 50) MOD 99 + 1);
            BalanceCheckAddCurrAmount2 :=
              BalanceCheckAddCurrAmount2 +
              AddCurrAmount * ((NormalDate(PostingDate) - 00000101D + 50) MOD 98 + 1);
          end
        else begin
          BalanceCheckAddCurrAmount := 0;
          BalanceCheckAddCurrAmount2 := 0;
        end;
    end;

    local procedure CalcPmtDiscPossible(GenJnlLine: Record "Gen. Journal Line";var CVLedgEntryBuf: Record "CV Ledger Entry Buffer")
    begin
        with GenJnlLine do
          if "Amount (LCY)" <> 0 then begin
            if (CVLedgEntryBuf."Pmt. Discount Date" >= CVLedgEntryBuf."Posting Date") or
               (CVLedgEntryBuf."Pmt. Discount Date" = 0D)
            then begin
              if GLSetup."Pmt. Disc. Excl. VAT" then begin
                if "Sales/Purch. (LCY)" = 0 then
                  CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
                    ("Amount (LCY)" + TotalVATAmountOnJnlLines(GenJnlLine)) * Amount / "Amount (LCY)"
                else
                  CVLedgEntryBuf."Original Pmt. Disc. Possible" := "Sales/Purch. (LCY)" * Amount / "Amount (LCY)"
              end else
                CVLedgEntryBuf."Original Pmt. Disc. Possible" := Amount;
              CVLedgEntryBuf."Original Pmt. Disc. Possible" :=
                ROUND(
                  CVLedgEntryBuf."Original Pmt. Disc. Possible" * "Payment Discount %" / 100,AmountRoundingPrecision);
            end;
            CVLedgEntryBuf."Remaining Pmt. Disc. Possible" := CVLedgEntryBuf."Original Pmt. Disc. Possible";
          end;
    end;

    local procedure CalcPmtTolerancePossible(GenJnlLine: Record "Gen. Journal Line";PmtDiscountDate: Date;var PmtDiscToleranceDate: Date;var MaxPaymentTolerance: Decimal)
    begin
        with GenJnlLine do
          if "Document Type" in ["document type"::Invoice,"document type"::"Credit Memo"] then begin
            if PmtDiscountDate <> 0D then
              PmtDiscToleranceDate :=
                CalcDate(GLSetup."Payment Discount Grace Period",PmtDiscountDate)
            else
              PmtDiscToleranceDate := PmtDiscountDate;

            case "Account Type" of
              "account type"::Customer:
                PaymentToleranceMgt.CalcMaxPmtTolerance(
                  "Document Type","Currency Code",Amount,"Amount (LCY)",1,MaxPaymentTolerance);
              "account type"::Vendor:
                PaymentToleranceMgt.CalcMaxPmtTolerance(
                  "Document Type","Currency Code",Amount,"Amount (LCY)",-1,MaxPaymentTolerance);
            end;
          end;
    end;

    local procedure CalcPmtTolerance(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";var PmtTolAmtToBeApplied: Decimal;NextTransactionNo: Integer;FirstNewVATEntryNo: Integer)
    var
        PmtTol: Decimal;
        PmtTolLCY: Decimal;
        PmtTolAddCurr: Decimal;
    begin
        if OldCVLedgEntryBuf2."Accepted Payment Tolerance" = 0 then
          exit;

        PmtTol := -OldCVLedgEntryBuf2."Accepted Payment Tolerance";
        PmtTolAmtToBeApplied := PmtTolAmtToBeApplied + PmtTol;
        PmtTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OldCVLedgEntryBuf."Accepted Payment Tolerance" := 0;
        OldCVLedgEntryBuf."Pmt. Tolerance (LCY)" := -PmtTolLCY;

        if NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode then
          PmtTolAddCurr := PmtTol
        else
          PmtTolAddCurr := CalcLCYToAddCurr(PmtTolLCY);

        if not GLSetup."Pmt. Disc. Excl. VAT" and GLSetup."Adjust for Payment Disc." and (PmtTolLCY <> 0) then
          CalcPmtDiscIfAdjVAT(
            NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,PmtTolLCY,PmtTolAddCurr,
            NextTransactionNo,FirstNewVATEntryNo,DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Excl.)");

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."entry type"::"Payment Tolerance",PmtTol,PmtTolLCY,PmtTolAddCurr,0,0,0);
    end;

    local procedure CalcPmtDisc(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";PmtTolAmtToBeApplied: Decimal;ApplnRoundingPrecision: Decimal;NextTransactionNo: Integer;FirstNewVATEntryNo: Integer)
    var
        PmtDisc: Decimal;
        PmtDiscLCY: Decimal;
        PmtDiscAddCurr: Decimal;
        MinimalPossibleLiability: Decimal;
        PaymentExceedsLiability: Boolean;
        ToleratedPaymentExceedsLiability: Boolean;
    begin
        MinimalPossibleLiability := Abs(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible");
        PaymentExceedsLiability := Abs(OldCVLedgEntryBuf2."Amount to Apply") >= MinimalPossibleLiability;
        ToleratedPaymentExceedsLiability := Abs(NewCVLedgEntryBuf."Remaining Amount" + PmtTolAmtToBeApplied) >= MinimalPossibleLiability;

        if (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,true,true) and
            ((OldCVLedgEntryBuf2."Amount to Apply" = 0) or PaymentExceedsLiability) or
            (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,false,false) and
             (OldCVLedgEntryBuf2."Amount to Apply" <> 0) and PaymentExceedsLiability and ToleratedPaymentExceedsLiability))
        then begin
          PmtDisc := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
          PmtDiscLCY :=
            ROUND(
              (NewCVLedgEntryBuf."Original Amount" + PmtDisc) / NewCVLedgEntryBuf."Original Currency Factor") -
            NewCVLedgEntryBuf."Original Amt. (LCY)";

          OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscLCY;

          if (NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode) and (AddCurrencyCode <> '') then
            PmtDiscAddCurr := PmtDisc
          else
            PmtDiscAddCurr := CalcLCYToAddCurr(PmtDiscLCY);

          if not GLSetup."Pmt. Disc. Excl. VAT" and GLSetup."Adjust for Payment Disc." and
             (PmtDiscLCY <> 0)
          then
            CalcPmtDiscIfAdjVAT(
              NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,PmtDiscLCY,PmtDiscAddCurr,
              NextTransactionNo,FirstNewVATEntryNo,DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Excl.)");

          DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
            GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
            DtldCVLedgEntryBuf."entry type"::"Payment Discount",PmtDisc,PmtDiscLCY,PmtDiscAddCurr,0,0,0);
        end;
    end;

    local procedure CalcPmtDiscIfAdjVAT(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";var PmtDiscLCY2: Decimal;var PmtDiscAddCurr2: Decimal;NextTransactionNo: Integer;FirstNewVATEntryNo: Integer;EntryType: Integer)
    var
        VATEntry2: Record "VAT Entry";
        VATPostingSetup: Record "VAT Posting Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
        DtldCVLedgEntryBuf2: Record "Detailed CV Ledg. Entry Buffer";
        OriginalAmountAddCurr: Decimal;
        PmtDiscRounding: Decimal;
        PmtDiscRoundingAddCurr: Decimal;
        PmtDiscFactorLCY: Decimal;
        PmtDiscFactorAddCurr: Decimal;
        VATBase: Decimal;
        VATBaseAddCurr: Decimal;
        VATAmount: Decimal;
        VATAmountAddCurr: Decimal;
        TotalVATAmount: Decimal;
        LastConnectionNo: Integer;
        VATEntryModifier: Integer;
    begin
        if OldCVLedgEntryBuf."Original Amt. (LCY)" = 0 then
          exit;

        if (AddCurrencyCode = '') or (AddCurrencyCode = OldCVLedgEntryBuf."Currency Code") then
          OriginalAmountAddCurr := OldCVLedgEntryBuf.Amount
        else
          OriginalAmountAddCurr := CalcLCYToAddCurr(OldCVLedgEntryBuf."Original Amt. (LCY)");

        PmtDiscRounding := PmtDiscLCY2;
        PmtDiscFactorLCY := PmtDiscLCY2 / OldCVLedgEntryBuf."Original Amt. (LCY)";
        if OriginalAmountAddCurr <> 0 then
          PmtDiscFactorAddCurr := PmtDiscAddCurr2 / OriginalAmountAddCurr
        else
          PmtDiscFactorAddCurr := 0;
        VATEntry2.Reset;
        VATEntry2.SetCurrentkey("Transaction No.");
        VATEntry2.SetRange("Transaction No.",OldCVLedgEntryBuf."Transaction No.");
        if OldCVLedgEntryBuf."Transaction No." = NextTransactionNo then
          VATEntry2.SetRange("Entry No.",0,FirstNewVATEntryNo - 1);
        if VATEntry2.FindSet then begin
          TotalVATAmount := 0;
          LastConnectionNo := 0;
          repeat
            VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
            if VATEntry2."VAT Calculation Type" =
               VATEntry2."vat calculation type"::"Sales Tax"
            then begin
              TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
              VATPostingSetup."Adjust for Payment Discount" :=
                TaxJurisdiction."Adjust for Payment Discount";
            end;
            if VATPostingSetup."Adjust for Payment Discount" then begin
              if LastConnectionNo <> VATEntry2."Sales Tax Connection No." then begin
                if LastConnectionNo <> 0 then begin
                  DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
                  DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
                  DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,false);
                  InsertSummarizedVAT(GenJnlLine);
                end;

                CalcPmtDiscVATBases(VATEntry2,VATBase,VATBaseAddCurr);

                PmtDiscRounding := PmtDiscRounding + VATBase * PmtDiscFactorLCY;
                VATBase := ROUND(PmtDiscRounding - PmtDiscLCY2);
                PmtDiscLCY2 := PmtDiscLCY2 + VATBase;

                PmtDiscRoundingAddCurr := PmtDiscRoundingAddCurr + VATBaseAddCurr * PmtDiscFactorAddCurr;
                VATBaseAddCurr := ROUND(CalcLCYToAddCurr(VATBase),AddCurrency."Amount Rounding Precision");
                PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATBaseAddCurr;

                DtldCVLedgEntryBuf2.Init;
                DtldCVLedgEntryBuf2."Posting Date" := GenJnlLine."Posting Date";
                DtldCVLedgEntryBuf2."Document Type" := GenJnlLine."Document Type";
                DtldCVLedgEntryBuf2."Document No." := GenJnlLine."Document No.";
                DtldCVLedgEntryBuf2.Amount := 0;
                DtldCVLedgEntryBuf2."Amount (LCY)" := -VATBase;
                DtldCVLedgEntryBuf2."Entry Type" := EntryType;
                case EntryType of
                  DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Excl.)":
                    VATEntryModifier := 0;
                  DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Excl.)":
                    VATEntryModifier := 1000000;
                  DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Excl.)":
                    VATEntryModifier := 2000000;
                end;
                DtldCVLedgEntryBuf2.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
                // The total payment discount in currency is posted on the entry made in
                // the function CalcPmtDisc.
                DtldCVLedgEntryBuf2."User ID" := UserId;
                DtldCVLedgEntryBuf2."Additional-Currency Amount" := -VATBaseAddCurr;
                DtldCVLedgEntryBuf2.CopyPostingGroupsFromVATEntry(VATEntry2);
                TotalVATAmount := 0;
                LastConnectionNo := VATEntry2."Sales Tax Connection No.";
              end;

              CalcPmtDiscVATAmounts(
                VATEntry2,VATBase,VATBaseAddCurr,VATAmount,VATAmountAddCurr,
                PmtDiscRounding,PmtDiscFactorLCY,PmtDiscLCY2,PmtDiscAddCurr2);

              TotalVATAmount := TotalVATAmount + VATAmount;

              if (PmtDiscAddCurr2 <> 0) and (PmtDiscLCY2 = 0) then begin
                VATAmountAddCurr := VATAmountAddCurr - PmtDiscAddCurr2;
                PmtDiscAddCurr2 := 0;
              end;

              // Post VAT
              // VAT for VAT entry
              if VATEntry2.Type <> 0 then
                InsertPmtDiscVATForVATEntry(
                  GenJnlLine,TempVATEntry,VATEntry2,VATEntryModifier,
                  VATAmount,VATAmountAddCurr,VATBase,VATBaseAddCurr,
                  PmtDiscFactorLCY,PmtDiscFactorAddCurr);

              // VAT for G/L entry/entries
              InsertPmtDiscVATForGLEntry(
                GenJnlLine,DtldCVLedgEntryBuf,NewCVLedgEntryBuf,VATEntry2,
                VATPostingSetup,TaxJurisdiction,EntryType,VATAmount,VATAmountAddCurr);
            end;
          until VATEntry2.Next = 0;

          if LastConnectionNo <> 0 then begin
            DtldCVLedgEntryBuf := DtldCVLedgEntryBuf2;
            DtldCVLedgEntryBuf."VAT Amount (LCY)" := -TotalVATAmount;
            DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,true);
            InsertSummarizedVAT(GenJnlLine);
          end;
        end;
    end;

    local procedure CalcPmtDiscTolerance(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";NextTransactionNo: Integer;FirstNewVATEntryNo: Integer)
    var
        PmtDiscTol: Decimal;
        PmtDiscTolLCY: Decimal;
        PmtDiscTolAddCurr: Decimal;
    begin
        if not OldCVLedgEntryBuf2."Accepted Pmt. Disc. Tolerance" then
          exit;

        PmtDiscTol := -OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible";
        PmtDiscTolLCY :=
          ROUND(
            (NewCVLedgEntryBuf."Original Amount" + PmtDiscTol) / NewCVLedgEntryBuf."Original Currency Factor") -
          NewCVLedgEntryBuf."Original Amt. (LCY)";

        OldCVLedgEntryBuf."Pmt. Disc. Given (LCY)" := -PmtDiscTolLCY;

        if NewCVLedgEntryBuf."Currency Code" = AddCurrencyCode then
          PmtDiscTolAddCurr := PmtDiscTol
        else
          PmtDiscTolAddCurr := CalcLCYToAddCurr(PmtDiscTolLCY);

        if not GLSetup."Pmt. Disc. Excl. VAT" and GLSetup."Adjust for Payment Disc." and (PmtDiscTolLCY <> 0) then
          CalcPmtDiscIfAdjVAT(
            NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,PmtDiscTolLCY,PmtDiscTolAddCurr,
            NextTransactionNo,FirstNewVATEntryNo,DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Excl.)");

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance",PmtDiscTol,PmtDiscTolLCY,PmtDiscTolAddCurr,0,0,0);
    end;

    local procedure CalcPmtDiscVATBases(VATEntry2: Record "VAT Entry";var VATBase: Decimal;var VATBaseAddCurr: Decimal)
    var
        VATEntry: Record "VAT Entry";
    begin
        case VATEntry2."VAT Calculation Type" of
          VATEntry2."vat calculation type"::"Normal VAT",
          VATEntry2."vat calculation type"::"Reverse Charge VAT",
          VATEntry2."vat calculation type"::"Full VAT":
            begin
              VATBase :=
                VATEntry2.Base + VATEntry2."Unrealized Base";
              VATBaseAddCurr :=
                VATEntry2."Additional-Currency Base" +
                VATEntry2."Add.-Currency Unrealized Base";
            end;
          VATEntry2."vat calculation type"::"Sales Tax":
            begin
              VATEntry.Reset;
              VATEntry.SetCurrentkey("Transaction No.");
              VATEntry.SetRange("Transaction No.",VATEntry2."Transaction No.");
              VATEntry.SetRange("Sales Tax Connection No.",VATEntry2."Sales Tax Connection No.");
              VATEntry := VATEntry2;
              repeat
                if VATEntry.Base < 0 then
                  VATEntry.SetFilter(Base,'>%1',VATEntry.Base)
                else
                  VATEntry.SetFilter(Base,'<%1',VATEntry.Base);
              until not VATEntry.FindLast;
              VATEntry.Reset;
              VATBase :=
                VATEntry.Base + VATEntry."Unrealized Base";
              VATBaseAddCurr :=
                VATEntry."Additional-Currency Base" +
                VATEntry."Add.-Currency Unrealized Base";
            end;
        end;
    end;

    local procedure CalcPmtDiscVATAmounts(VATEntry2: Record "VAT Entry";VATBase: Decimal;VATBaseAddCurr: Decimal;var VATAmount: Decimal;var VATAmountAddCurr: Decimal;var PmtDiscRounding: Decimal;PmtDiscFactorLCY: Decimal;var PmtDiscLCY2: Decimal;var PmtDiscAddCurr2: Decimal)
    begin
        case VATEntry2."VAT Calculation Type" of
          VATEntry2."vat calculation type"::"Normal VAT",
          VATEntry2."vat calculation type"::"Full VAT":
            if (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) or
               (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
            then begin
              if (VATBase = 0) and
                 (VATEntry2."VAT Calculation Type" <> VATEntry2."vat calculation type"::"Full VAT")
              then
                VATAmount := 0
              else begin
                PmtDiscRounding :=
                  PmtDiscRounding +
                  (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
              end;
              if (VATBaseAddCurr = 0) and
                 (VATEntry2."VAT Calculation Type" <> VATEntry2."vat calculation type"::"Full VAT")
              then
                VATAmountAddCurr := 0
              else begin
                VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
                PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
              end;
            end else begin
              VATAmount := 0;
              VATAmountAddCurr := 0;
            end;
          VATEntry2."vat calculation type"::"Reverse Charge VAT":
            begin
              VATAmount :=
                ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
              VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
            end;
          VATEntry2."vat calculation type"::"Sales Tax":
            if (VATEntry2.Type = VATEntry2.Type::Purchase) and VATEntry2."Use Tax" then begin
              VATAmount :=
                ROUND((VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY);
              VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
            end else
              if (VATEntry2.Amount + VATEntry2."Unrealized Amount" <> 0) or
                 (VATEntry2."Additional-Currency Amount" + VATEntry2."Add.-Currency Unrealized Amt." <> 0)
              then begin
                if VATBase = 0 then
                  VATAmount := 0
                else begin
                  PmtDiscRounding :=
                    PmtDiscRounding +
                    (VATEntry2.Amount + VATEntry2."Unrealized Amount") * PmtDiscFactorLCY;
                  VATAmount := ROUND(PmtDiscRounding - PmtDiscLCY2);
                  PmtDiscLCY2 := PmtDiscLCY2 + VATAmount;
                end;

                if VATBaseAddCurr = 0 then
                  VATAmountAddCurr := 0
                else begin
                  VATAmountAddCurr := ROUND(CalcLCYToAddCurr(VATAmount),AddCurrency."Amount Rounding Precision");
                  PmtDiscAddCurr2 := PmtDiscAddCurr2 + VATAmountAddCurr;
                end;
              end else begin
                VATAmount := 0;
                VATAmountAddCurr := 0;
              end;
        end;
    end;

    local procedure InsertPmtDiscVATForVATEntry(GenJnlLine: Record "Gen. Journal Line";var TempVATEntry: Record "VAT Entry" temporary;VATEntry2: Record "VAT Entry";VATEntryModifier: Integer;VATAmount: Decimal;VATAmountAddCurr: Decimal;VATBase: Decimal;VATBaseAddCurr: Decimal;PmtDiscFactorLCY: Decimal;PmtDiscFactorAddCurr: Decimal)
    var
        TempVATEntryNo: Integer;
    begin
        TempVATEntry.Reset;
        TempVATEntry.SetRange("Entry No.",VATEntryModifier,VATEntryModifier + 999999);
        if TempVATEntry.FindLast then
          TempVATEntryNo := TempVATEntry."Entry No." + 1
        else
          TempVATEntryNo := VATEntryModifier + 1;
        TempVATEntry := VATEntry2;
        TempVATEntry."Entry No." := TempVATEntryNo;
        TempVATEntry."Posting Date" := GenJnlLine."Posting Date";
        TempVATEntry."Document No." := GenJnlLine."Document No.";
        TempVATEntry."External Document No." := GenJnlLine."External Document No.";
        TempVATEntry."Document Type" := GenJnlLine."Document Type";
        TempVATEntry."Source Code" := GenJnlLine."Source Code";
        TempVATEntry."Reason Code" := GenJnlLine."Reason Code";
        TempVATEntry."Transaction No." := NextTransactionNo;
        TempVATEntry."Sales Tax Connection No." := NextConnectionNo;
        TempVATEntry."Unrealized Amount" := 0;
        TempVATEntry."Unrealized Base" := 0;
        TempVATEntry."Remaining Unrealized Amount" := 0;
        TempVATEntry."Remaining Unrealized Base" := 0;
        TempVATEntry."User ID" := UserId;
        TempVATEntry."Closed by Entry No." := 0;
        TempVATEntry.Closed := false;
        TempVATEntry."Internal Ref. No." := '';
        TempVATEntry.Amount := VATAmount;
        TempVATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        TempVATEntry."VAT Difference" := 0;
        TempVATEntry."Add.-Curr. VAT Difference" := 0;
        TempVATEntry."Add.-Currency Unrealized Amt." := 0;
        TempVATEntry."Add.-Currency Unrealized Base" := 0;
        if VATEntry2."Tax on Tax" then begin
          TempVATEntry.Base :=
            ROUND((VATEntry2.Base + VATEntry2."Unrealized Base") * PmtDiscFactorLCY);
          TempVATEntry."Additional-Currency Base" :=
            ROUND(
              (VATEntry2."Additional-Currency Base" +
               VATEntry2."Add.-Currency Unrealized Base") * PmtDiscFactorAddCurr,
              AddCurrency."Amount Rounding Precision");
        end else begin
          TempVATEntry.Base := VATBase;
          TempVATEntry."Additional-Currency Base" := VATBaseAddCurr;
        end;

        if AddCurrencyCode = '' then begin
          TempVATEntry."Additional-Currency Base" := 0;
          TempVATEntry."Additional-Currency Amount" := 0;
          TempVATEntry."Add.-Currency Unrealized Amt." := 0;
          TempVATEntry."Add.-Currency Unrealized Base" := 0;
        end;
        TempVATEntry.Insert;
    end;

    local procedure InsertPmtDiscVATForGLEntry(GenJnlLine: Record "Gen. Journal Line";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";VATEntry2: Record "VAT Entry";var VATPostingSetup: Record "VAT Posting Setup";var TaxJurisdiction: Record "Tax Jurisdiction";EntryType: Integer;VATAmount: Decimal;VATAmountAddCurr: Decimal)
    begin
        DtldCVLedgEntryBuf.Init;
        DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(NewCVLedgEntryBuf);
        case EntryType of
          DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Excl.)":
            DtldCVLedgEntryBuf."Entry Type" :=
              DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Adjustment)";
          DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Excl.)":
            DtldCVLedgEntryBuf."Entry Type" :=
              DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Adjustment)";
          DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Excl.)":
            DtldCVLedgEntryBuf."Entry Type" :=
              DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Adjustment)";
        end;
        DtldCVLedgEntryBuf."Posting Date" := GenJnlLine."Posting Date";
        DtldCVLedgEntryBuf."Document Type" := GenJnlLine."Document Type";
        DtldCVLedgEntryBuf."Document No." := GenJnlLine."Document No.";
        DtldCVLedgEntryBuf.Amount := 0;
        DtldCVLedgEntryBuf."VAT Bus. Posting Group" := VATEntry2."VAT Bus. Posting Group";
        DtldCVLedgEntryBuf."VAT Prod. Posting Group" := VATEntry2."VAT Prod. Posting Group";
        DtldCVLedgEntryBuf."Tax Jurisdiction Code" := VATEntry2."Tax Jurisdiction Code";
        // The total payment discount in currency is posted on the entry made in
        // the function CalcPmtDisc.
        DtldCVLedgEntryBuf."User ID" := UserId;
        DtldCVLedgEntryBuf."Use Additional-Currency Amount" := true;

        case VATEntry2.Type of
          VATEntry2.Type::Purchase:
            case VATEntry2."VAT Calculation Type" of
              VATEntry2."vat calculation type"::"Normal VAT",
              VATEntry2."vat calculation type"::"Full VAT":
                begin
                  InitGLEntryVAT(GenJnlLine,VATPostingSetup.GetPurchAccount(false),'',
                    VATAmount,VATAmountAddCurr,false);
                  DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                  DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                  DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,true);
                end;
              VATEntry2."vat calculation type"::"Reverse Charge VAT":
                begin
                  InitGLEntryVAT(GenJnlLine,VATPostingSetup.GetPurchAccount(false),'',
                    VATAmount,VATAmountAddCurr,false);
                  InitGLEntryVAT(GenJnlLine,VATPostingSetup.GetRevChargeAccount(false),'',
                    -VATAmount,-VATAmountAddCurr,false);
                end;
              VATEntry2."vat calculation type"::"Sales Tax":
                if VATEntry2."Use Tax" then begin
                  InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetPurchAccount(false),'',
                    VATAmount,VATAmountAddCurr,false);
                  InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetRevChargeAccount(false),'',
                    -VATAmount,-VATAmountAddCurr,false);
                end else begin
                  InitGLEntryVAT(GenJnlLine,TaxJurisdiction.GetPurchAccount(false),'',
                    VATAmount,VATAmountAddCurr,false);
                  DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                  DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                  DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,true);
                end;
            end;
          VATEntry2.Type::Sale:
            case VATEntry2."VAT Calculation Type" of
              VATEntry2."vat calculation type"::"Normal VAT",
              VATEntry2."vat calculation type"::"Full VAT":
                begin
                  InitGLEntryVAT(
                    GenJnlLine,VATPostingSetup.GetSalesAccount(false),'',
                    VATAmount,VATAmountAddCurr,false);
                  DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                  DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                  DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,true);
                end;
              VATEntry2."vat calculation type"::"Reverse Charge VAT":
                ;
              VATEntry2."vat calculation type"::"Sales Tax":
                begin
                  InitGLEntryVAT(
                    GenJnlLine,TaxJurisdiction.GetSalesAccount(false),'',
                    VATAmount,VATAmountAddCurr,false);
                  DtldCVLedgEntryBuf."Amount (LCY)" := -VATAmount;
                  DtldCVLedgEntryBuf."Additional-Currency Amount" := -VATAmountAddCurr;
                  DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,NewCVLedgEntryBuf,true);
                end;
            end;
        end;
    end;

    local procedure CalcCurrencyApplnRounding(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";ApplnRoundingPrecision: Decimal)
    var
        ApplnRounding: Decimal;
        ApplnRoundingLCY: Decimal;
    begin
        if ((NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."document type"::Payment) and
            (NewCVLedgEntryBuf."Document Type" <> NewCVLedgEntryBuf."document type"::Refund)) or
           (NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf."Currency Code")
        then
          exit;

        ApplnRounding := -(NewCVLedgEntryBuf."Remaining Amount" + OldCVLedgEntryBuf."Remaining Amount");
        ApplnRoundingLCY := ROUND(ApplnRounding / NewCVLedgEntryBuf."Adjusted Currency Factor");

        if (ApplnRounding = 0) or (Abs(ApplnRounding) > ApplnRoundingPrecision) then
          exit;

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."entry type"::"Appln. Rounding",ApplnRounding,ApplnRoundingLCY,ApplnRounding,0,0,0);
    end;

    local procedure FindAmtForAppln(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";var AppliedAmount: Decimal;var AppliedAmountLCY: Decimal;var OldAppliedAmount: Decimal;ApplnRoundingPrecision: Decimal)
    begin
        if OldCVLedgEntryBuf2.GetFilter(Positive) <> '' then begin
          if OldCVLedgEntryBuf2."Amount to Apply" <> 0 then begin
            if (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,false,false) and
                (Abs(OldCVLedgEntryBuf2."Amount to Apply") >=
                 Abs(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")))
            then
              AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount"
            else
              AppliedAmount := -OldCVLedgEntryBuf2."Amount to Apply"
          end else
            AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
        end else begin
          if OldCVLedgEntryBuf2."Amount to Apply" <> 0 then
            if (PaymentToleranceMgt.CheckCalcPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf2,ApplnRoundingPrecision,false,false) and
                (Abs(OldCVLedgEntryBuf2."Amount to Apply") >=
                 Abs(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible")) and
                (Abs(NewCVLedgEntryBuf."Remaining Amount") >=
                 Abs(
                   ABSMin(
                     OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Remaining Pmt. Disc. Possible",
                     OldCVLedgEntryBuf2."Amount to Apply")))) or
               OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance"
            then begin
              AppliedAmount := -OldCVLedgEntryBuf2."Remaining Amount";
              OldCVLedgEntryBuf."Accepted Pmt. Disc. Tolerance" := false;
            end else
              AppliedAmount := GetAppliedAmountFromBuffers(NewCVLedgEntryBuf,OldCVLedgEntryBuf2)
          else
            AppliedAmount := ABSMin(NewCVLedgEntryBuf."Remaining Amount",-OldCVLedgEntryBuf2."Remaining Amount");
        end;

        if (Abs(OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply") < ApplnRoundingPrecision) and
           (ApplnRoundingPrecision <> 0) and
           (OldCVLedgEntryBuf2."Amount to Apply" <> 0)
        then
          AppliedAmount := AppliedAmount - (OldCVLedgEntryBuf2."Remaining Amount" - OldCVLedgEntryBuf2."Amount to Apply");

        if NewCVLedgEntryBuf."Currency Code" = OldCVLedgEntryBuf2."Currency Code" then begin
          AppliedAmountLCY := ROUND(AppliedAmount / OldCVLedgEntryBuf."Original Currency Factor");
          OldAppliedAmount := AppliedAmount;
        end else begin
          // Management of posting in multiple currencies
          if AppliedAmount = -OldCVLedgEntryBuf2."Remaining Amount" then
            OldAppliedAmount := -OldCVLedgEntryBuf."Remaining Amount"
          else
            OldAppliedAmount :=
              CurrExchRate.ExchangeAmount(
                AppliedAmount,NewCVLedgEntryBuf."Currency Code",
                OldCVLedgEntryBuf2."Currency Code",NewCVLedgEntryBuf."Posting Date");

          if NewCVLedgEntryBuf."Currency Code" <> '' then
            // Post the realized gain or loss on the NewCVLedgEntryBuf
            AppliedAmountLCY := ROUND(OldAppliedAmount / OldCVLedgEntryBuf."Original Currency Factor")
          else
            // Post the realized gain or loss on the OldCVLedgEntryBuf
            AppliedAmountLCY := ROUND(AppliedAmount / NewCVLedgEntryBuf."Original Currency Factor");
        end;
    end;

    local procedure CalcCurrencyUnrealizedGainLoss(var CVLedgEntryBuf: Record "CV Ledger Entry Buffer";var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;GenJnlLine: Record "Gen. Journal Line";AppliedAmount: Decimal;RemainingAmountBeforeAppln: Decimal)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        UnRealizedGainLossLCY: Decimal;
    begin
        if (CVLedgEntryBuf."Currency Code" = '') or (RemainingAmountBeforeAppln = 0) then
          exit;

        // Calculate Unrealized GainLoss
        if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then
          UnRealizedGainLossLCY :=
            ROUND(
              DtldCustLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
              Abs(AppliedAmount / RemainingAmountBeforeAppln))
        else
          UnRealizedGainLossLCY :=
            ROUND(
              DtldVendLedgEntry.GetUnrealizedGainLossAmount(CVLedgEntryBuf."Entry No.") *
              Abs(AppliedAmount / RemainingAmountBeforeAppln));

        if UnRealizedGainLossLCY <> 0 then
          if UnRealizedGainLossLCY < 0 then
            TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
              GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
              TempDtldCVLedgEntryBuf."entry type"::"Unrealized Loss",0,-UnRealizedGainLossLCY,0,0,0,0)
          else
            TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
              GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
              TempDtldCVLedgEntryBuf."entry type"::"Unrealized Gain",0,-UnRealizedGainLossLCY,0,0,0,0);
    end;

    local procedure CalcCurrencyRealizedGainLoss(var CVLedgEntryBuf: Record "CV Ledger Entry Buffer";var TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;GenJnlLine: Record "Gen. Journal Line";AppliedAmount: Decimal;AppliedAmountLCY: Decimal;var VATRealizedGainLossLCY: Decimal)
    var
        RealizedGainLossLCY: Decimal;
    begin
        if CVLedgEntryBuf."Currency Code" = '' then
          exit;

        // Calculate Realized GainLoss
        RealizedGainLossLCY :=
          AppliedAmountLCY - ROUND(AppliedAmount / CVLedgEntryBuf."Original Currency Factor");
        if RealizedGainLossLCY <> 0 then begin
          if RealizedGainLossLCY < 0 then
            TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
              GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
              TempDtldCVLedgEntryBuf."entry type"::"Realized Loss",0,RealizedGainLossLCY,0,0,0,0)
          else
            TempDtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
              GenJnlLine,CVLedgEntryBuf,TempDtldCVLedgEntryBuf,
              TempDtldCVLedgEntryBuf."entry type"::"Realized Gain",0,RealizedGainLossLCY,0,0,0,0);
          VATRealizedGainLossLCY := RealizedGainLossLCY;
        end;
    end;

    local procedure CalcApplication(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";AppliedAmount: Decimal;AppliedAmountLCY: Decimal;OldAppliedAmount: Decimal;PrevNewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";PrevOldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var AllApplied: Boolean)
    begin
        if AppliedAmount = 0 then
          exit;

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine,OldCVLedgEntryBuf,DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."entry type"::Application,OldAppliedAmount,AppliedAmountLCY,0,
          NewCVLedgEntryBuf."Entry No.",PrevOldCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
          PrevOldCVLedgEntryBuf."Max. Payment Tolerance");

        OldCVLedgEntryBuf.Open := OldCVLedgEntryBuf."Remaining Amount" <> 0;
        if not OldCVLedgEntryBuf.Open then
          OldCVLedgEntryBuf.SetClosedFields(
            NewCVLedgEntryBuf."Entry No.",GenJnlLine."Posting Date",
            -OldAppliedAmount,-AppliedAmountLCY,NewCVLedgEntryBuf."Currency Code",-AppliedAmount)
        else
          AllApplied := false;

        DtldCVLedgEntryBuf.InitDtldCVLedgEntryBuf(
          GenJnlLine,NewCVLedgEntryBuf,DtldCVLedgEntryBuf,
          DtldCVLedgEntryBuf."entry type"::Application,-AppliedAmount,-AppliedAmountLCY,0,
          NewCVLedgEntryBuf."Entry No.",PrevNewCVLedgEntryBuf."Remaining Pmt. Disc. Possible",
          PrevNewCVLedgEntryBuf."Max. Payment Tolerance");

        NewCVLedgEntryBuf.Open := NewCVLedgEntryBuf."Remaining Amount" <> 0;
        if not NewCVLedgEntryBuf.Open and not AllApplied then
          NewCVLedgEntryBuf.SetClosedFields(
            OldCVLedgEntryBuf."Entry No.",GenJnlLine."Posting Date",
            AppliedAmount,AppliedAmountLCY,OldCVLedgEntryBuf."Currency Code",OldAppliedAmount);
    end;

    local procedure CalcAmtLCYAdjustment(var CVLedgEntryBuf: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line")
    var
        AdjustedAmountLCY: Decimal;
    begin
        if CVLedgEntryBuf."Currency Code" = '' then
          exit;

        AdjustedAmountLCY :=
          ROUND(CVLedgEntryBuf."Remaining Amount" / CVLedgEntryBuf."Adjusted Currency Factor");

        if AdjustedAmountLCY <> CVLedgEntryBuf."Remaining Amt. (LCY)" then begin
          DtldCVLedgEntryBuf.InitFromGenJnlLine(GenJnlLine);
          DtldCVLedgEntryBuf.CopyFromCVLedgEntryBuf(CVLedgEntryBuf);
          DtldCVLedgEntryBuf."Entry Type" :=
            DtldCVLedgEntryBuf."entry type"::"Correction of Remaining Amount";
          DtldCVLedgEntryBuf."Amount (LCY)" := AdjustedAmountLCY - CVLedgEntryBuf."Remaining Amt. (LCY)";
          DtldCVLedgEntryBuf.InsertDtldCVLedgEntry(DtldCVLedgEntryBuf,CVLedgEntryBuf,false);
        end;
    end;

    local procedure InitBankAccLedgEntry(GenJnlLine: Record "Gen. Journal Line";var BankAccLedgEntry: Record "Bank Account Ledger Entry")
    begin
        BankAccLedgEntry.Init;
        BankAccLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        BankAccLedgEntry."Entry No." := NextEntryNo;
        BankAccLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure InitCheckLedgEntry(BankAccLedgEntry: Record "Bank Account Ledger Entry";var CheckLedgEntry: Record "Check Ledger Entry")
    begin
        CheckLedgEntry.Init;
        CheckLedgEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
        CheckLedgEntry."Entry No." := NextCheckEntryNo;
    end;

    local procedure InitCustLedgEntry(GenJnlLine: Record "Gen. Journal Line";var CustLedgEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgEntry.Init;
        CustLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        CustLedgEntry."Entry No." := NextEntryNo;
        CustLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure InitVendLedgEntry(GenJnlLine: Record "Gen. Journal Line";var VendLedgEntry: Record "Vendor Ledger Entry")
    begin
        VendLedgEntry.Init;
        VendLedgEntry.CopyFromGenJnlLine(GenJnlLine);
        VendLedgEntry."Entry No." := NextEntryNo;
        VendLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure InsertDtldCustLedgEntry(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";Offset: Integer)
    begin
        with DtldCustLedgEntry do begin
          Init;
          TransferFields(DtldCVLedgEntryBuf);
          "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
          "Journal Batch Name" := GenJnlLine."Journal Batch Name";
          "Reason Code" := GenJnlLine."Reason Code";
          "Source Code" := GenJnlLine."Source Code";
          "Transaction No." := NextTransactionNo;
          UpdateDebitCredit(GenJnlLine.Correction);
          Insert(true);
        end;
    end;

    local procedure InsertDtldVendLedgEntry(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";Offset: Integer)
    begin
        with DtldVendLedgEntry do begin
          Init;
          TransferFields(DtldCVLedgEntryBuf);
          "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
          "Journal Batch Name" := GenJnlLine."Journal Batch Name";
          "Reason Code" := GenJnlLine."Reason Code";
          "Source Code" := GenJnlLine."Source Code";
          "Transaction No." := NextTransactionNo;
          UpdateDebitCredit(GenJnlLine.Correction);
          Insert(true);
        end;
    end;

    local procedure ApplyCustLedgEntry(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";Cust: Record Customer)
    var
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        NewCustLedgEntry: Record "Cust. Ledger Entry";
        NewCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";
        TempOldCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
        VATRealizedGainLossLCY: Decimal;
    begin
        if NewCVLedgEntryBuf."Amount to Apply" = 0 then
          exit;

        AllApplied := true;
        if (GenJnlLine."Applies-to Doc. No." = '') and (GenJnlLine."Applies-to ID" = '') and
           not
           ((Cust."Application Method" = Cust."application method"::"Apply to Oldest") and
            GenJnlLine."Allow Application")
        then
          exit;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        if not PrepareTempCustLedgEntry(GenJnlLine,NewCVLedgEntryBuf,TempOldCustLedgEntry,Cust,ApplyingDate) then
          exit;

        GenJnlLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        repeat
          TempOldCustLedgEntry.CalcFields(
            Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
            "Original Amount","Original Amt. (LCY)");
          TempOldCustLedgEntry.Copyfilter(Positive,OldCVLedgEntryBuf.Positive);
          OldCVLedgEntryBuf.CopyFromCustLedgEntry(TempOldCustLedgEntry);

          PostApply(
            GenJnlLine,DtldCVLedgEntryBuf,OldCVLedgEntryBuf,NewCVLedgEntryBuf,NewCVLedgEntryBuf2,
            Cust."Block Payment Tolerance",AllApplied,AppliedAmount,PmtTolAmtToBeApplied,VATRealizedGainLossLCY);

          if not OldCVLedgEntryBuf.Open then begin
            UpdateCalcInterest(OldCVLedgEntryBuf);
            UpdateCalcInterest2(OldCVLedgEntryBuf,NewCVLedgEntryBuf);
          end;

          TempOldCustLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
          OldCustLedgEntry := TempOldCustLedgEntry;
          OldCustLedgEntry."Applies-to ID" := '';
          OldCustLedgEntry."Amount to Apply" := 0;
          OldCustLedgEntry.Modify;

          if GLSetup."Unrealized VAT" or
             (GLSetup."Prepayment Unrealized VAT" and TempOldCustLedgEntry.Prepayment)
          then
            if IsNotPayment(TempOldCustLedgEntry."Document Type") then begin
              TempOldCustLedgEntry.RecalculateAmounts(
                NewCVLedgEntryBuf."Currency Code",TempOldCustLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date");
              CustUnrealizedVAT(
                GenJnlLine,
                TempOldCustLedgEntry,
                CurrExchRate.ExchangeAmount(
                  AppliedAmount,NewCVLedgEntryBuf."Currency Code",
                  TempOldCustLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date"),
                VATRealizedGainLossLCY,NewCVLedgEntryBuf."Adjusted Currency Factor",NewCVLedgEntryBuf."Posting Date");
            end;

          TempOldCustLedgEntry.Delete;

          // Find the next old entry for application of the new entry
          if GenJnlLine."Applies-to Doc. No." <> '' then
            Completed := true
          else
            if TempOldCustLedgEntry.GetFilter(Positive) <> '' then
              if TempOldCustLedgEntry.Next = 1 then
                Completed := false
              else begin
                TempOldCustLedgEntry.SetRange(Positive);
                TempOldCustLedgEntry.Find('-');
                TempOldCustLedgEntry.CalcFields("Remaining Amount");
                Completed := TempOldCustLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
              end
            else
              if NewCVLedgEntryBuf.Open then
                Completed := TempOldCustLedgEntry.Next = 0
              else
                Completed := true;
        until Completed;

        DtldCVLedgEntryBuf.SetCurrentkey("CV Ledger Entry No.","Entry Type");
        DtldCVLedgEntryBuf.SetRange("CV Ledger Entry No.",NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SetRange(
          "Entry Type",
          DtldCVLedgEntryBuf."entry type"::Application);
        DtldCVLedgEntryBuf.CalcSums("Amount (LCY)",Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,DtldCVLedgEntryBuf.Amount,NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;

        if not NewCVLedgEntryBuf.Open then
          UpdateCalcInterest(NewCVLedgEntryBuf);

        if GLSetup."Unrealized VAT" or
           (GLSetup."Prepayment Unrealized VAT" and NewCVLedgEntryBuf.Prepayment)
        then
          if IsNotPayment(NewCVLedgEntryBuf."Document Type") and
             (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
          then begin
            NewCustLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
            CheckUnrealizedCust := true;
            UnrealizedCustLedgEntry := NewCustLedgEntry;
            UnrealizedCustLedgEntry.CalcFields("Amount (LCY)","Original Amt. (LCY)");
            UnrealizedRemainingAmountCust := NewCustLedgEntry."Remaining Amount" - NewRemainingAmtBeforeAppln;
          end;
    end;


    procedure CustPostApplyCustLedgEntry(var GenJnlLinePostApply: Record "Gen. Journal Line";var CustLedgEntryPostApply: Record "Cust. Ledger Entry")
    var
        Cust: Record Customer;
        CustPostingGr: Record "Customer Posting Group";
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        GenJnlLine: Record "Gen. Journal Line";
        DtldLedgEntryInserted: Boolean;
    begin
        GenJnlLine := GenJnlLinePostApply;
        CustLedgEntry.TransferFields(CustLedgEntryPostApply);
        with GenJnlLine do begin
          "Source Currency Code" := CustLedgEntryPostApply."Currency Code";
          "Applies-to ID" := CustLedgEntryPostApply."Applies-to ID";

          GenJnlCheckLine.RunCheck(GenJnlLine);

          if NextEntryNo = 0 then
            StartPosting(GenJnlLine)
          else
            ContinuePosting(GenJnlLine);

          Cust.Get(CustLedgEntry."Customer No.");
          Cust.CheckBlockedCustOnJnls(Cust,"Document Type",true);

          if "Posting Group" = '' then begin
            Cust.TestField("Customer Posting Group");
            "Posting Group" := Cust."Customer Posting Group";
          end;
          CustPostingGr.Get("Posting Group");
          CustPostingGr.GetReceivablesAccount;

          DtldCustLedgEntry.LockTable;
          CustLedgEntry.LockTable;

          // Post the application
          CustLedgEntry.CalcFields(
            Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
            "Original Amount","Original Amt. (LCY)");
          CVLedgEntryBuf.CopyFromCustLedgEntry(CustLedgEntry);
          ApplyCustLedgEntry(CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Cust);
          CustLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
          CustLedgEntry.Modify;

          // Post the Dtld customer entry
          DtldLedgEntryInserted := PostDtldCustLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,CustPostingGr,false);

          CheckPostUnrealizedVAT(GenJnlLine,true);

          if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty then
              DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);
          FinishPosting;
        end;
    end;

    local procedure PrepareTempCustLedgEntry(GenJnlLine: Record "Gen. Journal Line";var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var TempOldCustLedgEntry: Record "Cust. Ledger Entry" temporary;Cust: Record Customer;var ApplyingDate: Date): Boolean
    var
        OldCustLedgEntry: Record "Cust. Ledger Entry";
        SalesSetup: Record "Sales & Receivables Setup";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        RemainingAmount: Decimal;
    begin
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
          // Find the entry to be applied to
          OldCustLedgEntry.Reset;
          OldCustLedgEntry.SetCurrentkey("Document No.");
          OldCustLedgEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
          OldCustLedgEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
          OldCustLedgEntry.SetRange("Customer No.",NewCVLedgEntryBuf."CV No.");
          OldCustLedgEntry.SetRange(Open,true);

          OldCustLedgEntry.FindFirst;
          OldCustLedgEntry.TestField(Positive,not NewCVLedgEntryBuf.Positive);
          if OldCustLedgEntry."Posting Date" > ApplyingDate then
            ApplyingDate := OldCustLedgEntry."Posting Date";
          GenJnlApply.CheckAgainstApplnCurrency(
            NewCVLedgEntryBuf."Currency Code",OldCustLedgEntry."Currency Code",GenJnlLine."account type"::Customer,true);
          TempOldCustLedgEntry := OldCustLedgEntry;
          TempOldCustLedgEntry.Insert;
        end else begin
          // Find the first old entry (Invoice) which the new entry (Payment) should apply to
          OldCustLedgEntry.Reset;
          OldCustLedgEntry.SetCurrentkey("Customer No.","Applies-to ID",Open,Positive,"Due Date");
          TempOldCustLedgEntry.SetCurrentkey("Customer No.","Applies-to ID",Open,Positive,"Due Date");
          OldCustLedgEntry.SetRange("Customer No.",NewCVLedgEntryBuf."CV No.");
          OldCustLedgEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");
          OldCustLedgEntry.SetRange(Open,true);
          OldCustLedgEntry.SetFilter("Entry No.",'<>%1',NewCVLedgEntryBuf."Entry No.");
          if not (Cust."Application Method" = Cust."application method"::"Apply to Oldest") then
            OldCustLedgEntry.SetFilter("Amount to Apply",'<>%1',0);

          if Cust."Application Method" = Cust."application method"::"Apply to Oldest" then
            OldCustLedgEntry.SetFilter("Posting Date",'..%1',GenJnlLine."Posting Date");

          // Check Cust Ledger Entry and add to Temp.
          SalesSetup.Get;
          if SalesSetup."Appln. between Currencies" = SalesSetup."appln. between currencies"::None then
            OldCustLedgEntry.SetRange("Currency Code",NewCVLedgEntryBuf."Currency Code");
          if OldCustLedgEntry.FindSet(false,false) then
            repeat
              if GenJnlApply.CheckAgainstApplnCurrency(
                   NewCVLedgEntryBuf."Currency Code",OldCustLedgEntry."Currency Code",GenJnlLine."account type"::Customer,false)
              then begin
                if (OldCustLedgEntry."Posting Date" > ApplyingDate) and (OldCustLedgEntry."Applies-to ID" <> '') then
                  ApplyingDate := OldCustLedgEntry."Posting Date";
                TempOldCustLedgEntry := OldCustLedgEntry;
                TempOldCustLedgEntry.Insert;
              end;
            until OldCustLedgEntry.Next = 0;

          TempOldCustLedgEntry.SetRange(Positive,NewCVLedgEntryBuf."Remaining Amount" > 0);

          if TempOldCustLedgEntry.Find('-') then begin
            RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
            TempOldCustLedgEntry.SetRange(Positive);
            TempOldCustLedgEntry.Find('-');
            repeat
              TempOldCustLedgEntry.CalcFields("Remaining Amount");
              TempOldCustLedgEntry.RecalculateAmounts(
                TempOldCustLedgEntry."Currency Code",NewCVLedgEntryBuf."Currency Code",NewCVLedgEntryBuf."Posting Date");
              if PaymentToleranceMgt.CheckCalcPmtDiscCVCust(NewCVLedgEntryBuf,TempOldCustLedgEntry,0,false,false) then
                TempOldCustLedgEntry."Remaining Amount" -= TempOldCustLedgEntry."Remaining Pmt. Disc. Possible";
              RemainingAmount += TempOldCustLedgEntry."Remaining Amount";
            until TempOldCustLedgEntry.Next = 0;
            TempOldCustLedgEntry.SetRange(Positive,RemainingAmount < 0);
          end else
            TempOldCustLedgEntry.SetRange(Positive);

          exit(TempOldCustLedgEntry.Find('-'));
        end;
        exit(true);
    end;

    local procedure PostDtldCustLedgEntries(GenJnlLine: Record "Gen. Journal Line";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";CustPostingGr: Record "Customer Posting Group";LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean
    var
        TempInvPostBuf: Record "Invoice Post. Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DimMgt: Codeunit DimensionManagement;
        AdjAmount: array [4] of Decimal;
        DtldCustLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    begin
        if GenJnlLine."Account Type" <> GenJnlLine."account type"::Customer then
          exit;

        if DtldCustLedgEntry.FindLast then
          DtldCustLedgEntryNoOffset := DtldCustLedgEntry."Entry No."
        else
          DtldCustLedgEntryNoOffset := 0;

        DtldCVLedgEntryBuf.Reset;
        if DtldCVLedgEntryBuf.FindSet then begin
          if LedgEntryInserted then begin
            SaveEntryNo := NextEntryNo;
            NextEntryNo := NextEntryNo + 1;
          end;
          repeat
            InsertDtldCustLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,DtldCustLedgEntry,DtldCustLedgEntryNoOffset);

            DimMgt.UpdateGenJnlLineDimFromCustLedgEntry(GenJnlLine,DtldCustLedgEntry);
            UpdateTotalAmounts(
              TempInvPostBuf,GenJnlLine."Dimension Set ID",
              DtldCVLedgEntryBuf."Amount (LCY)",DtldCVLedgEntryBuf."Additional-Currency Amount");

            // Post automatic entries.
            if ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) or
                (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) or
               ((AddCurrencyCode <> '') and (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
            then
              PostDtldCustLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,AdjAmount);
          until DtldCVLedgEntryBuf.Next = 0;
        end;

        CreateGLEntriesForTotalAmounts(
          GenJnlLine,TempInvPostBuf,AdjAmount,SaveEntryNo,CustPostingGr.GetReceivablesAccount,LedgEntryInserted);

        DtldLedgEntryInserted := not DtldCVLedgEntryBuf.IsEmpty;
        DtldCVLedgEntryBuf.DeleteAll;
    end;

    local procedure PostDtldCustLedgEntry(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";CustPostingGr: Record "Customer Posting Group";var AdjAmount: array [4] of Decimal)
    var
        AccNo: Code[20];
    begin
        AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,0,false);
        PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,false);
    end;

    local procedure PostDtldCustLedgEntryUnapply(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";CustPostingGr: Record "Customer Posting Group";OriginalTransactionNo: Integer)
    var
        AdjAmount: array [4] of Decimal;
        AccNo: Code[20];
    begin
        if (DtldCVLedgEntryBuf."Amount (LCY)" = 0) and
           (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) and
           ((AddCurrencyCode = '') or (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
        then
          exit;

        AccNo := GetDtldCustLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,OriginalTransactionNo,true);
        DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."gen. posting type"::Sale;
        PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,true);
    end;

    local procedure GetDtldCustLedgEntryAccNo(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";CustPostingGr: Record "Customer Posting Group";OriginalTransactionNo: Integer;Unapply: Boolean): Code[20]
    var
        GenPostingSetup: Record "General Posting Setup";
        Currency: Record Currency;
        AmountCondition: Boolean;
    begin
        with DtldCVLedgEntryBuf do begin
          AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf,Unapply);
          case "Entry Type" of
            "entry type"::"Initial Entry":
              ;
            "entry type"::Application:
              ;
            "entry type"::"Unrealized Loss",
            "entry type"::"Unrealized Gain",
            "entry type"::"Realized Loss",
            "entry type"::"Realized Gain":
              begin
                GetCurrency(Currency,"Currency Code");
                CheckNonAddCurrCodeOccurred(Currency.Code);
                exit(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
              end;
            "entry type"::"Payment Discount":
              exit(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
            "entry type"::"Payment Discount (VAT Excl.)":
              begin
                TestField("Gen. Prod. Posting Group");
                GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                exit(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
              end;
            "entry type"::"Appln. Rounding":
              exit(CustPostingGr.GetApplRoundingAccount(AmountCondition));
            "entry type"::"Correction of Remaining Amount":
              exit(CustPostingGr.GetRoundingAccount(AmountCondition));
            "entry type"::"Payment Discount Tolerance":
              case GLSetup."Pmt. Disc. Tolerance Posting" of
                GLSetup."pmt. disc. tolerance posting"::"Payment Tolerance Accounts":
                  exit(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                GLSetup."pmt. disc. tolerance posting"::"Payment Discount Accounts":
                  exit(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
              end;
            "entry type"::"Payment Tolerance":
              case GLSetup."Payment Tolerance Posting" of
                GLSetup."payment tolerance posting"::"Payment Tolerance Accounts":
                  exit(CustPostingGr.GetPmtToleranceAccount(AmountCondition));
                GLSetup."payment tolerance posting"::"Payment Discount Accounts":
                  exit(CustPostingGr.GetPmtDiscountAccount(AmountCondition));
              end;
            "entry type"::"Payment Tolerance (VAT Excl.)":
              begin
                TestField("Gen. Prod. Posting Group");
                GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                case GLSetup."Payment Tolerance Posting" of
                  GLSetup."payment tolerance posting"::"Payment Tolerance Accounts":
                    exit(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                  GLSetup."payment tolerance posting"::"Payment Discount Accounts":
                    exit(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                end;
              end;
            "entry type"::"Payment Discount Tolerance (VAT Excl.)":
              begin
                GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                case GLSetup."Pmt. Disc. Tolerance Posting" of
                  GLSetup."pmt. disc. tolerance posting"::"Payment Tolerance Accounts":
                    exit(GenPostingSetup.GetSalesPmtToleranceAccount(AmountCondition));
                  GLSetup."pmt. disc. tolerance posting"::"Payment Discount Accounts":
                    exit(GenPostingSetup.GetSalesPmtDiscountAccount(AmountCondition));
                end;
              end;
            "entry type"::"Payment Discount (VAT Adjustment)",
            "entry type"::"Payment Tolerance (VAT Adjustment)",
            "entry type"::"Payment Discount Tolerance (VAT Adjustment)":
              if Unapply then
                PostDtldCustVATAdjustment(GenJnlLine,DtldCVLedgEntryBuf,OriginalTransactionNo);
            else
              FieldError("Entry Type");
          end;
        end;
    end;

    local procedure CustUnrealizedVAT(GenJnlLine: Record "Gen. Journal Line";var CustLedgEntry2: Record "Cust. Ledger Entry";SettledAmount: Decimal;GainLossLCY: Decimal;CurrencyFactor: Decimal;PostingDate: Date)
    var
        VATEntry2: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATPostingSetup: Record "VAT Posting Setup";
        GLEntry: Record "G/L Entry";
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        SalesVATAccount: Code[20];
        SalesVATUnrealAccount: Code[20];
        LastConnectionNo: Integer;
        RealizedPart: Decimal;
        RealizedVATAmount: Decimal;
        RealizedVATBase: Decimal;
        RealizedVATAmountAddCurr: Decimal;
        RealizedVATBaseAddCurr: Decimal;
        Currency: Record Currency;
        VATBaseFCY: Decimal;
        VATAmountFCY: Decimal;
        VATAmountCash: Decimal;
        VATBaseCash: Decimal;
    begin
        CustLedgEntry2.CalcFields("Amount (LCY)","Original Amt. (LCY)");
        PaidAmount := CustLedgEntry2."Amount (LCY)" - CustLedgEntry2."Remaining Amt. (LCY)";
        VATEntry2.Reset;
        VATEntry2.SetCurrentkey("Transaction No.");
        VATEntry2.SetRange("Transaction No.",CustLedgEntry2."Transaction No.");
        if VATEntry2.FindSet then
          repeat
            VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
            if VATEntry2."VAT Calculation Type" = VATEntry2."vat calculation type" :: "Sales Tax" then begin
              TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
              CalculateFirstLastAmount(TaxJurisdiction."Unrealized VAT Type", VATEntry2."Remaining Unrealized Amount",TotalUnrealVATAmountLast,TotalUnrealVATAmountFirst);
            end else
              CalculateFirstLastAmount(VATPostingSetup."Unrealized VAT Type", VATEntry2."Remaining Unrealized Amount",TotalUnrealVATAmountLast,TotalUnrealVATAmountFirst);
          until VATEntry2.Next = 0;
        if VATEntry2.FindSet then begin
          LastConnectionNo := 0;
          repeat
            VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
            if LastConnectionNo <> VATEntry2."Sales Tax Connection No." then begin
              InsertSummarizedVAT(GenJnlLine);
              LastConnectionNo := VATEntry2."Sales Tax Connection No.";
            end;

            VATPart :=
              VATEntry2.GetUnrealizedVATPart(
                ROUND(SettledAmount / CustLedgEntry2.GetOriginalCurrencyFactor),
                PaidAmount,
                CustLedgEntry2."Original Amt. (LCY)",
                TotalUnrealVATAmountFirst,
                TotalUnrealVATAmountLast,
                CustLedgEntry2."Original Amt. (LCY)");

            if VATPart > 0 then begin
              case VATEntry2."VAT Calculation Type" of
                VATEntry2."vat calculation type"::"Normal VAT",
                VATEntry2."vat calculation type"::"Reverse Charge VAT",
                VATEntry2."vat calculation type"::"Full VAT":
                  begin
                    SalesVATAccount := VATPostingSetup.GetSalesAccount(false);
                    SalesVATUnrealAccount := VATPostingSetup.GetSalesAccount(true);
                  end;
                VATEntry2."vat calculation type"::"Sales Tax":
                  begin
                    TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
                    SalesVATAccount := TaxJurisdiction.GetSalesAccount(false);
                    SalesVATUnrealAccount := TaxJurisdiction.GetSalesAccount(true);
                  end;
              end;

              if VATPart = 1 then begin
                VATAmount := VATEntry2."Remaining Unrealized Amount";
                VATBase := VATEntry2."Remaining Unrealized Base";
                VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
              end else begin
                if (VATPostingSetup."Unrealized VAT Type" <> VATPostingSetup."unrealized vat type"::"Cash Basis") then begin
                  VATAmount := ROUND(VATEntry2."Remaining Unrealized Amount" * VATPart,GLSetup."Amount Rounding Precision");
                  VATBase := ROUND(VATEntry2."Remaining Unrealized Base" * VATPart,GLSetup."Amount Rounding Precision");
                  VATAmountAddCurr :=
                    ROUND(
                      VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                      AddCurrency."Amount Rounding Precision");
                  VATBaseAddCurr :=
                    ROUND(
                      VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                      AddCurrency."Amount Rounding Precision");
                end else begin
                  VATAmount := ROUND(VATEntry2."Unrealized Amount" * VATPart,GLSetup."Amount Rounding Precision");
                  VATBase := ROUND(VATEntry2."Unrealized Base" * VATPart,GLSetup."Amount Rounding Precision");
                  VATAmountAddCurr :=
                    ROUND(
                      VATEntry2."Add.-Currency Unrealized Amt." * VATPart,
                      AddCurrency."Amount Rounding Precision");
                  VATBaseAddCurr :=
                    ROUND(
                      VATEntry2."Add.-Currency Unrealized Base" * VATPart,
                      AddCurrency."Amount Rounding Precision");
                end;
              end;

              // what is LCY value of VAT and VAT Base at posting date (cash basis)
              if (VATPostingSetup."Unrealized VAT Type" = VATPostingSetup."unrealized vat type"::"Cash Basis") and
                 (GainLossLCY <> 0)
              then begin
                if CurrencyFactor = 1 then // LCY to FCY application
                  CurrencyFactor := CurrExchRate.ExchangeRate(PostingDate,CustLedgEntry2."Currency Code");
                VATBaseFCY := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      PostingDate,CustLedgEntry2."Currency Code",VATBase,CustLedgEntry2."Original Currency Factor"));
                VATBaseCash :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PostingDate,CustLedgEntry2."Currency Code",VATBaseFCY,CurrencyFactor));
                VATAmountFCY := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      PostingDate,CustLedgEntry2."Currency Code",VATAmount,CustLedgEntry2."Original Currency Factor"));
                VATAmountCash :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PostingDate,CustLedgEntry2."Currency Code",VATAmountFCY,CurrencyFactor));
              end else
                RealizedPart := 1;
              RealizedVATAmount := 0;
              RealizedVATBase := 0;
              RealizedVATAmountAddCurr := 0;
              RealizedVATBaseAddCurr := 0;
              if (GainLossLCY <> 0) and (CustLedgEntry2."Currency Code" <> '') and
                 (VATPostingSetup."Unrealized VAT Type" = VATPostingSetup."unrealized vat type"::"Cash Basis")
              then begin
                RealizedVATAmount := -(VATAmount - VATAmountCash);
                RealizedVATBase := -(VATBase - VATBaseCash);
              end;

              InitGLEntryVAT(
                GenJnlLine,SalesVATUnrealAccount,SalesVATAccount,-VATAmount,-VATAmountAddCurr,false);
              InitGLEntryVATCopy(
                GenJnlLine,SalesVATAccount,SalesVATUnrealAccount,VATAmount + RealizedVATAmount,VATAmountAddCurr + RealizedVATAmountAddCurr,VATEntry2);

              if (GainLossLCY <> 0) and (CustLedgEntry2."Currency Code" <> '') and
                 (VATPostingSetup."Unrealized VAT Type" = VATPostingSetup."unrealized vat type"::"Cash Basis")
              then begin
                Currency.Get(CustLedgEntry2."Currency Code");
                case CustLedgEntry2."Document Type" of
                  CustLedgEntry2."document type"::"Credit Memo":
                    begin
                      if GainLossLCY > 0 then begin
                        Currency.TestField("Realized Losses Acc.");
                        InitGLEntry(GenJnlLine,GLEntry,
                          Currency."Realized Losses Acc.",-RealizedVATAmount,0,false,true);
                        GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                      end else begin
                        Currency.TestField("Realized Gains Acc.");
                        InitGLEntry(GenJnlLine,GLEntry,
                          Currency."Realized Gains Acc.",-RealizedVATAmount,0,false,true);
                        GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                      end;
                    end;
                  else
                    if GainLossLCY < 0 then begin
                      Currency.TestField("Realized Losses Acc.");
                      InitGLEntry(GenJnlLine,GLEntry,
                        Currency."Realized Losses Acc.",-RealizedVATAmount,0,false,true);
                      GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                    end else begin
                      Currency.TestField("Realized Gains Acc.");
                      InitGLEntry(GenJnlLine,GLEntry,
                        Currency."Realized Gains Acc.",-RealizedVATAmount,0,false,true);
                      GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                    end;
                end;
                GLEntry.CopyPostingGroupsFromVATEntry(VATEntry2);
                SummarizeVAT(GLSetup."Summarize G/L Entries",GLEntry);
              end;

              PostUnrealVATEntry(GenJnlLine,VATEntry2,VATAmount,VATBase,VATAmountAddCurr,VATBaseAddCurr);
            end;
          until VATEntry2.Next = 0;

          InsertSummarizedVAT(GenJnlLine);
        end;
    end;

    local procedure ApplyVendLedgEntry(var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GenJnlLine: Record "Gen. Journal Line";Vend: Record Vendor)
    var
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        NewVendLedgEntry: Record "Vendor Ledger Entry";
        NewCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";
        TempOldVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        Completed: Boolean;
        AppliedAmount: Decimal;
        NewRemainingAmtBeforeAppln: Decimal;
        ApplyingDate: Date;
        PmtTolAmtToBeApplied: Decimal;
        AllApplied: Boolean;
        VATRealizedGainLossLCY: Decimal;
    begin
        if NewCVLedgEntryBuf."Amount to Apply" = 0 then
          exit;
        if (NewCVLedgEntryBuf."Amount to Apply" = 0) and
           (NewCVLedgEntryBuf."Applies-to ID" = '') and
           (NewCVLedgEntryBuf."Applies-to Doc. No." = '')
        then

        AllApplied := true;
        if (GenJnlLine."Applies-to Doc. No." = '') and (GenJnlLine."Applies-to ID" = '') and
           not
           ((Vend."Application Method" = Vend."application method"::"Apply to Oldest") and
            GenJnlLine."Allow Application")
        then
          exit;

        PmtTolAmtToBeApplied := 0;
        NewRemainingAmtBeforeAppln := NewCVLedgEntryBuf."Remaining Amount";
        NewCVLedgEntryBuf2 := NewCVLedgEntryBuf;

        ApplyingDate := GenJnlLine."Posting Date";

        if not PrepareTempVendLedgEntry(GenJnlLine,NewCVLedgEntryBuf,TempOldVendLedgEntry,Vend,ApplyingDate) then
          exit;

        GenJnlLine."Posting Date" := ApplyingDate;
        // Apply the new entry (Payment) to the old entries (Invoices) one at a time
        repeat
          TempOldVendLedgEntry.CalcFields(
            Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
            "Original Amount","Original Amt. (LCY)");
          OldCVLedgEntryBuf.CopyFromVendLedgEntry(TempOldVendLedgEntry);
          TempOldVendLedgEntry.Copyfilter(Positive,OldCVLedgEntryBuf.Positive);

          PostApply(
            GenJnlLine,DtldCVLedgEntryBuf,OldCVLedgEntryBuf,NewCVLedgEntryBuf,NewCVLedgEntryBuf2,
            Vend."Block Payment Tolerance",AllApplied,AppliedAmount,PmtTolAmtToBeApplied,VATRealizedGainLossLCY);

          // Update the Old Entry
          TempOldVendLedgEntry.CopyFromCVLedgEntryBuffer(OldCVLedgEntryBuf);
          OldVendLedgEntry := TempOldVendLedgEntry;
          OldVendLedgEntry."Applies-to ID" := '';
          OldVendLedgEntry."Amount to Apply" := 0;
          OldVendLedgEntry.Modify;

          if GLSetup."Unrealized VAT" or
             (GLSetup."Prepayment Unrealized VAT" and TempOldVendLedgEntry.Prepayment)
          then
            if IsNotPayment(TempOldVendLedgEntry."Document Type") then begin
              TempOldVendLedgEntry.RecalculateAmounts(
                NewCVLedgEntryBuf."Currency Code",TempOldVendLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date");
              VendUnrealizedVAT(
                GenJnlLine,
                TempOldVendLedgEntry,
                CurrExchRate.ExchangeAmount(
                  AppliedAmount,NewCVLedgEntryBuf."Currency Code",
                  TempOldVendLedgEntry."Currency Code",NewCVLedgEntryBuf."Posting Date"),
                VATRealizedGainLossLCY,NewCVLedgEntryBuf."Adjusted Currency Factor",NewCVLedgEntryBuf."Posting Date");
            end;

          TempOldVendLedgEntry.Delete;

          // Find the next old entry to apply to the new entry
          if GenJnlLine."Applies-to Doc. No." <> '' then
            Completed := true
          else
            if TempOldVendLedgEntry.GetFilter(Positive) <> '' then
              if TempOldVendLedgEntry.Next = 1 then
                Completed := false
              else begin
                TempOldVendLedgEntry.SetRange(Positive);
                TempOldVendLedgEntry.Find('-');
                TempOldVendLedgEntry.CalcFields("Remaining Amount");
                Completed := TempOldVendLedgEntry."Remaining Amount" * NewCVLedgEntryBuf."Remaining Amount" >= 0;
              end
            else
              if NewCVLedgEntryBuf.Open then
                Completed := TempOldVendLedgEntry.Next = 0
              else
                Completed := true;
        until Completed;

        DtldCVLedgEntryBuf.SetCurrentkey("CV Ledger Entry No.","Entry Type");
        DtldCVLedgEntryBuf.SetRange("CV Ledger Entry No.",NewCVLedgEntryBuf."Entry No.");
        DtldCVLedgEntryBuf.SetRange(
          "Entry Type",
          DtldCVLedgEntryBuf."entry type"::Application);
        DtldCVLedgEntryBuf.CalcSums("Amount (LCY)",Amount);

        CalcCurrencyUnrealizedGainLoss(
          NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,DtldCVLedgEntryBuf.Amount,NewRemainingAmtBeforeAppln);

        CalcAmtLCYAdjustment(NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine);

        NewCVLedgEntryBuf."Applies-to ID" := '';
        NewCVLedgEntryBuf."Amount to Apply" := 0;

        if GLSetup."Unrealized VAT" or
           (GLSetup."Prepayment Unrealized VAT" and NewCVLedgEntryBuf.Prepayment)
        then
          if IsNotPayment(NewCVLedgEntryBuf."Document Type") and
             (NewRemainingAmtBeforeAppln - NewCVLedgEntryBuf."Remaining Amount" <> 0)
          then begin
            NewVendLedgEntry.CopyFromCVLedgEntryBuffer(NewCVLedgEntryBuf);
            CheckUnrealizedVend := true;
            UnrealizedVendLedgEntry := NewVendLedgEntry;
            UnrealizedVendLedgEntry.CalcFields("Amount (LCY)","Original Amt. (LCY)");
            UnrealizedRemainingAmountVend := -(NewRemainingAmtBeforeAppln - NewVendLedgEntry."Remaining Amount");
          end;
    end;


    procedure VendPostApplyVendLedgEntry(var GenJnlLinePostApply: Record "Gen. Journal Line";var VendLedgEntryPostApply: Record "Vendor Ledger Entry")
    var
        Vend: Record Vendor;
        VendPostingGr: Record "Vendor Posting Group";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        GenJnlLine: Record "Gen. Journal Line";
        DtldLedgEntryInserted: Boolean;
    begin
        GenJnlLine := GenJnlLinePostApply;
        VendLedgEntry.TransferFields(VendLedgEntryPostApply);
        with GenJnlLine do begin
          "Source Currency Code" := VendLedgEntryPostApply."Currency Code";
          "Applies-to ID" := VendLedgEntryPostApply."Applies-to ID";

          GenJnlCheckLine.RunCheck(GenJnlLine);

          if NextEntryNo = 0 then
            StartPosting(GenJnlLine)
          else
            ContinuePosting(GenJnlLine);

          Vend.Get(VendLedgEntry."Vendor No.");
          Vend.CheckBlockedVendOnJnls(Vend,"Document Type",true);

          if "Posting Group" = '' then begin
            Vend.TestField("Vendor Posting Group");
            "Posting Group" := Vend."Vendor Posting Group";
          end;
          VendPostingGr.Get("Posting Group");
          VendPostingGr.GetPayablesAccount;

          DtldVendLedgEntry.LockTable;
          VendLedgEntry.LockTable;

          // Post the application
          VendLedgEntry.CalcFields(
            Amount,"Amount (LCY)","Remaining Amount","Remaining Amt. (LCY)",
            "Original Amount","Original Amt. (LCY)");
          CVLedgEntryBuf.CopyFromVendLedgEntry(VendLedgEntry);
          ApplyVendLedgEntry(
            CVLedgEntryBuf,TempDtldCVLedgEntryBuf,GenJnlLine,Vend);
          VendLedgEntry.CopyFromCVLedgEntryBuffer(CVLedgEntryBuf);
          VendLedgEntry.Modify(true);

          // Post Dtld vendor entry
          DtldLedgEntryInserted := PostDtldVendLedgEntries(GenJnlLine,TempDtldCVLedgEntryBuf,VendPostingGr,false);

          CheckPostUnrealizedVAT(GenJnlLine,true);

          if DtldLedgEntryInserted then
            if IsTempGLEntryBufEmpty then
              DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);

          FinishPosting;
        end;
    end;

    local procedure PrepareTempVendLedgEntry(GenJnlLine: Record "Gen. Journal Line";var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var TempOldVendLedgEntry: Record "Vendor Ledger Entry" temporary;Vend: Record Vendor;var ApplyingDate: Date): Boolean
    var
        OldVendLedgEntry: Record "Vendor Ledger Entry";
        PurchSetup: Record "Purchases & Payables Setup";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        RemainingAmount: Decimal;
    begin
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
          // Find the entry to be applied to
          OldVendLedgEntry.Reset;
          OldVendLedgEntry.SetCurrentkey("Document No.");
          OldVendLedgEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
          OldVendLedgEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
          OldVendLedgEntry.SetRange("Vendor No.",NewCVLedgEntryBuf."CV No.");
          OldVendLedgEntry.SetRange(Open,true);
          OldVendLedgEntry.FindFirst;
          OldVendLedgEntry.TestField(Positive,not NewCVLedgEntryBuf.Positive);
          if OldVendLedgEntry."Posting Date" > ApplyingDate then
            ApplyingDate := OldVendLedgEntry."Posting Date";
          GenJnlApply.CheckAgainstApplnCurrency(
            NewCVLedgEntryBuf."Currency Code",OldVendLedgEntry."Currency Code",GenJnlLine."account type"::Vendor,true);
          TempOldVendLedgEntry := OldVendLedgEntry;
          TempOldVendLedgEntry.Insert;
        end else begin
          // Find the first old entry (Invoice) which the new entry (Payment) should apply to
          OldVendLedgEntry.Reset;
          OldVendLedgEntry.SetCurrentkey("Vendor No.","Applies-to ID",Open,Positive,"Due Date");
          TempOldVendLedgEntry.SetCurrentkey("Vendor No.","Applies-to ID",Open,Positive,"Due Date");
          OldVendLedgEntry.SetRange("Vendor No.",NewCVLedgEntryBuf."CV No.");
          OldVendLedgEntry.SetRange("Applies-to ID",GenJnlLine."Applies-to ID");
          OldVendLedgEntry.SetRange(Open,true);
          OldVendLedgEntry.SetFilter("Entry No.",'<>%1',NewCVLedgEntryBuf."Entry No.");
          if not (Vend."Application Method" = Vend."application method"::"Apply to Oldest") then
            OldVendLedgEntry.SetFilter("Amount to Apply",'<>%1',0);

          if Vend."Application Method" = Vend."application method"::"Apply to Oldest" then
            OldVendLedgEntry.SetFilter("Posting Date",'..%1',GenJnlLine."Posting Date");

          // Check and Move Ledger Entries to Temp
          PurchSetup.Get;
          if PurchSetup."Appln. between Currencies" = PurchSetup."appln. between currencies"::None then
            OldVendLedgEntry.SetRange("Currency Code",NewCVLedgEntryBuf."Currency Code");
          if OldVendLedgEntry.FindSet(false,false) then
            repeat
              if GenJnlApply.CheckAgainstApplnCurrency(
                   NewCVLedgEntryBuf."Currency Code",OldVendLedgEntry."Currency Code",GenJnlLine."account type"::Vendor,false)
              then begin
                if (OldVendLedgEntry."Posting Date" > ApplyingDate) and (OldVendLedgEntry."Applies-to ID" <> '') then
                  ApplyingDate := OldVendLedgEntry."Posting Date";
                TempOldVendLedgEntry := OldVendLedgEntry;
                TempOldVendLedgEntry.Insert;
              end;
            until OldVendLedgEntry.Next = 0;

          TempOldVendLedgEntry.SetRange(Positive,NewCVLedgEntryBuf."Remaining Amount" > 0);

          if TempOldVendLedgEntry.Find('-') then begin
            RemainingAmount := NewCVLedgEntryBuf."Remaining Amount";
            TempOldVendLedgEntry.SetRange(Positive);
            TempOldVendLedgEntry.Find('-');
            repeat
              TempOldVendLedgEntry.CalcFields("Remaining Amount");
              TempOldVendLedgEntry.RecalculateAmounts(
                TempOldVendLedgEntry."Currency Code",NewCVLedgEntryBuf."Currency Code",NewCVLedgEntryBuf."Posting Date");
              if PaymentToleranceMgt.CheckCalcPmtDiscCVVend(NewCVLedgEntryBuf,TempOldVendLedgEntry,0,false,false) then
                TempOldVendLedgEntry."Remaining Amount" -= TempOldVendLedgEntry."Remaining Pmt. Disc. Possible";
              RemainingAmount += TempOldVendLedgEntry."Remaining Amount";
            until TempOldVendLedgEntry.Next = 0;
            TempOldVendLedgEntry.SetRange(Positive,RemainingAmount < 0);
          end else
            TempOldVendLedgEntry.SetRange(Positive);
          exit(TempOldVendLedgEntry.Find('-'));
        end;
        exit(true);
    end;

    local procedure PostDtldVendLedgEntries(GenJnlLine: Record "Gen. Journal Line";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";VendPostingGr: Record "Vendor Posting Group";LedgEntryInserted: Boolean) DtldLedgEntryInserted: Boolean
    var
        TempInvPostBuf: Record "Invoice Post. Buffer" temporary;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        DimMgt: Codeunit DimensionManagement;
        AdjAmount: array [4] of Decimal;
        DtldVendLedgEntryNoOffset: Integer;
        SaveEntryNo: Integer;
    begin
        if GenJnlLine."Account Type" <> GenJnlLine."account type"::Vendor then
          exit;

        if DtldVendLedgEntry.FindLast then
          DtldVendLedgEntryNoOffset := DtldVendLedgEntry."Entry No."
        else
          DtldVendLedgEntryNoOffset := 0;

        DtldCVLedgEntryBuf.Reset;
        if DtldCVLedgEntryBuf.FindSet then begin
          if LedgEntryInserted then begin
            SaveEntryNo := NextEntryNo;
            NextEntryNo := NextEntryNo + 1;
          end;
          repeat
            InsertDtldVendLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,DtldVendLedgEntry,DtldVendLedgEntryNoOffset);

            DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(GenJnlLine,DtldVendLedgEntry);
            UpdateTotalAmounts(
              TempInvPostBuf,GenJnlLine."Dimension Set ID",
              DtldCVLedgEntryBuf."Amount (LCY)",DtldCVLedgEntryBuf."Additional-Currency Amount");

            // Post automatic entries.
            if ((DtldCVLedgEntryBuf."Amount (LCY)" <> 0) or
                (DtldCVLedgEntryBuf."VAT Amount (LCY)" <> 0)) or
               ((AddCurrencyCode <> '') and (DtldCVLedgEntryBuf."Additional-Currency Amount" <> 0))
            then
              PostDtldVendLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,AdjAmount);
          until DtldCVLedgEntryBuf.Next = 0;
        end;

        CreateGLEntriesForTotalAmounts(
          GenJnlLine,TempInvPostBuf,AdjAmount,SaveEntryNo,VendPostingGr.GetPayablesAccount,LedgEntryInserted);

        DtldLedgEntryInserted := not DtldCVLedgEntryBuf.IsEmpty;
        DtldCVLedgEntryBuf.DeleteAll;
    end;

    local procedure PostDtldVendLedgEntry(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";VendPostingGr: Record "Vendor Posting Group";var AdjAmount: array [4] of Decimal)
    var
        AccNo: Code[20];
    begin
        AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,0,false);
        PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,false);
    end;

    local procedure PostDtldVendLedgEntryUnapply(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";VendPostingGr: Record "Vendor Posting Group";OriginalTransactionNo: Integer)
    var
        AccNo: Code[20];
        AdjAmount: array [4] of Decimal;
    begin
        if (DtldCVLedgEntryBuf."Amount (LCY)" = 0) and
           (DtldCVLedgEntryBuf."VAT Amount (LCY)" = 0) and
           ((AddCurrencyCode = '') or (DtldCVLedgEntryBuf."Additional-Currency Amount" = 0))
        then
          exit;

        AccNo := GetDtldVendLedgEntryAccNo(GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,OriginalTransactionNo,true);
        DtldCVLedgEntryBuf."Gen. Posting Type" := DtldCVLedgEntryBuf."gen. posting type"::Purchase;
        PostDtldCVLedgEntry(GenJnlLine,DtldCVLedgEntryBuf,AccNo,AdjAmount,true);
    end;

    local procedure GetDtldVendLedgEntryAccNo(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";VendPostingGr: Record "Vendor Posting Group";OriginalTransactionNo: Integer;Unapply: Boolean): Code[20]
    var
        Currency: Record Currency;
        GenPostingSetup: Record "General Posting Setup";
        AmountCondition: Boolean;
    begin
        with DtldCVLedgEntryBuf do begin
          AmountCondition := IsDebitAmount(DtldCVLedgEntryBuf,Unapply);
          case "Entry Type" of
            "entry type"::"Initial Entry":
              ;
            "entry type"::Application:
              ;
            "entry type"::"Unrealized Loss",
            "entry type"::"Unrealized Gain",
            "entry type"::"Realized Loss",
            "entry type"::"Realized Gain":
              begin
                GetCurrency(Currency,"Currency Code");
                CheckNonAddCurrCodeOccurred(Currency.Code);
                exit(Currency.GetGainLossAccount(DtldCVLedgEntryBuf));
              end;
            "entry type"::"Payment Discount":
              exit(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
            "entry type"::"Payment Discount (VAT Excl.)":
              begin
                GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                exit(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
              end;
            "entry type"::"Appln. Rounding":
              exit(VendPostingGr.GetApplRoundingAccount(AmountCondition));
            "entry type"::"Correction of Remaining Amount":
              exit(VendPostingGr.GetRoundingAccount(AmountCondition));
            "entry type"::"Payment Discount Tolerance":
              case GLSetup."Pmt. Disc. Tolerance Posting" of
                GLSetup."pmt. disc. tolerance posting"::"Payment Tolerance Accounts":
                  exit(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
                GLSetup."pmt. disc. tolerance posting"::"Payment Discount Accounts":
                  exit(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
              end;
            "entry type"::"Payment Tolerance":
              case GLSetup."Payment Tolerance Posting" of
                GLSetup."payment tolerance posting"::"Payment Tolerance Accounts":
                  exit(VendPostingGr.GetPmtToleranceAccount(AmountCondition));
                GLSetup."payment tolerance posting"::"Payment Discount Accounts":
                  exit(VendPostingGr.GetPmtDiscountAccount(AmountCondition));
              end;
            "entry type"::"Payment Tolerance (VAT Excl.)":
              begin
                GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                case GLSetup."Payment Tolerance Posting" of
                  GLSetup."payment tolerance posting"::"Payment Tolerance Accounts":
                    exit(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                  GLSetup."payment tolerance posting"::"Payment Discount Accounts":
                    exit(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                end;
              end;
            "entry type"::"Payment Discount Tolerance (VAT Excl.)":
              begin
                GenPostingSetup.Get("Gen. Bus. Posting Group","Gen. Prod. Posting Group");
                case GLSetup."Pmt. Disc. Tolerance Posting" of
                  GLSetup."pmt. disc. tolerance posting"::"Payment Tolerance Accounts":
                    exit(GenPostingSetup.GetPurchPmtToleranceAccount(AmountCondition));
                  GLSetup."pmt. disc. tolerance posting"::"Payment Discount Accounts":
                    exit(GenPostingSetup.GetPurchPmtDiscountAccount(AmountCondition));
                end;
              end;
            "entry type"::"Payment Discount (VAT Adjustment)",
            "entry type"::"Payment Tolerance (VAT Adjustment)",
            "entry type"::"Payment Discount Tolerance (VAT Adjustment)":
              if Unapply then
                PostDtldVendVATAdjustment(GenJnlLine,DtldCVLedgEntryBuf,OriginalTransactionNo);
            else
              FieldError("Entry Type");
          end;
        end;
    end;

    local procedure PostDtldCVLedgEntry(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";AccNo: Code[20];var AdjAmount: array [4] of Decimal;Unapply: Boolean)
    begin
        with DtldCVLedgEntryBuf do
          case "Entry Type" of
            "entry type"::"Initial Entry":
              ;
            "entry type"::Application:
              ;
            "entry type"::"Unrealized Loss",
            "entry type"::"Unrealized Gain",
            "entry type"::"Realized Loss",
            "entry type"::"Realized Gain":
              begin
                CreateGLEntryGainLoss(GenJnlLine,AccNo,-"Amount (LCY)","Currency Code" = AddCurrencyCode);
                if not Unapply then
                  CollectAdjustment(AdjAmount,-"Amount (LCY)",0);
              end;
            "entry type"::"Payment Discount",
            "entry type"::"Payment Tolerance",
            "entry type"::"Payment Discount Tolerance":
              begin
                CreateGLEntry(GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",false);
                if not Unapply then
                  CollectAdjustment(AdjAmount,-"Amount (LCY)",-"Additional-Currency Amount");
              end;
            "entry type"::"Payment Discount (VAT Excl.)",
            "entry type"::"Payment Tolerance (VAT Excl.)",
            "entry type"::"Payment Discount Tolerance (VAT Excl.)":
              begin
                if not Unapply then
                  CreateGLEntryVATCollectAdj(
                    GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",-"VAT Amount (LCY)",DtldCVLedgEntryBuf,
                    AdjAmount)
                else
                  CreateGLEntryVAT(
                    GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",-"VAT Amount (LCY)",DtldCVLedgEntryBuf);
              end;
            "entry type"::"Appln. Rounding":
              if "Amount (LCY)" <> 0 then begin
                CreateGLEntry(GenJnlLine,AccNo,-"Amount (LCY)",-"Additional-Currency Amount",true);
                if not Unapply then
                  CollectAdjustment(AdjAmount,-"Amount (LCY)",-"Additional-Currency Amount");
              end;
            "entry type"::"Correction of Remaining Amount":
              if "Amount (LCY)" <> 0 then begin
                CreateGLEntry(GenJnlLine,AccNo,-"Amount (LCY)",0,false);
                if not Unapply then
                  CollectAdjustment(AdjAmount,-"Amount (LCY)",0);
              end;
            "entry type"::"Payment Discount (VAT Adjustment)",
            "entry type"::"Payment Tolerance (VAT Adjustment)",
            "entry type"::"Payment Discount Tolerance (VAT Adjustment)":
              ;
            else
              FieldError("Entry Type");
          end;
    end;

    local procedure PostDtldCustVATAdjustment(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";OriginalTransactionNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        with DtldCVLedgEntryBuf do begin
          FindVATEntry(VATEntry,OriginalTransactionNo);

          case VATPostingSetup."VAT Calculation Type" of
            VATPostingSetup."vat calculation type"::"Normal VAT",
            VATPostingSetup."vat calculation type"::"Full VAT":
              begin
                VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group");
                VATPostingSetup.TestField("VAT Calculation Type",VATEntry."VAT Calculation Type");
                CreateGLEntry(
                  GenJnlLine,VATPostingSetup.GetSalesAccount(false),-"Amount (LCY)",-"Additional-Currency Amount",false);
              end;
            VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
              ;
            VATPostingSetup."vat calculation type"::"Sales Tax":
              begin
                TestField("Tax Jurisdiction Code");
                TaxJurisdiction.Get("Tax Jurisdiction Code");
                CreateGLEntry(
                  GenJnlLine,TaxJurisdiction.GetPurchAccount(false),-"Amount (LCY)",-"Additional-Currency Amount",false);
              end;
          end;
        end;
    end;

    local procedure PostDtldVendVATAdjustment(GenJnlLine: Record "Gen. Journal Line";DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";OriginalTransactionNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        with DtldCVLedgEntryBuf do begin
          FindVATEntry(VATEntry,OriginalTransactionNo);

          case VATPostingSetup."VAT Calculation Type" of
            VATPostingSetup."vat calculation type"::"Normal VAT",
            VATPostingSetup."vat calculation type"::"Full VAT":
              begin
                VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group");
                VATPostingSetup.TestField("VAT Calculation Type",VATEntry."VAT Calculation Type");
                CreateGLEntry(
                  GenJnlLine,VATPostingSetup.GetPurchAccount(false),-"Amount (LCY)",-"Additional-Currency Amount",false);
              end;
            VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
              begin
                VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group");
                VATPostingSetup.TestField("VAT Calculation Type",VATEntry."VAT Calculation Type");
                CreateGLEntry(
                  GenJnlLine,VATPostingSetup.GetPurchAccount(false),-"Amount (LCY)",-"Additional-Currency Amount",false);
                CreateGLEntry(
                  GenJnlLine,VATPostingSetup.GetRevChargeAccount(false),"Amount (LCY)","Additional-Currency Amount",false);
              end;
            VATPostingSetup."vat calculation type"::"Sales Tax":
              begin
                TaxJurisdiction.Get("Tax Jurisdiction Code");
                if "Use Tax" then begin
                  CreateGLEntry(
                    GenJnlLine,TaxJurisdiction.GetPurchAccount(false),-"Amount (LCY)",-"Additional-Currency Amount",false);
                  CreateGLEntry(
                    GenJnlLine,TaxJurisdiction.GetRevChargeAccount(false),"Amount (LCY)","Additional-Currency Amount",false);
                end else
                  CreateGLEntry(
                    GenJnlLine,TaxJurisdiction.GetPurchAccount(false),-"Amount (LCY)",-"Additional-Currency Amount",false);
              end;
          end;
        end;
    end;

    local procedure VendUnrealizedVAT(GenJnlLine: Record "Gen. Journal Line";var VendLedgEntry2: Record "Vendor Ledger Entry";SettledAmount: Decimal;GainLossLCY: Decimal;CurrencyFactor: Decimal;PostingDate: Date)
    var
        VATEntry2: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        VATPostingSetup: Record "VAT Posting Setup";
        GLEntry: Record "G/L Entry";
        VATPart: Decimal;
        VATAmount: Decimal;
        VATBase: Decimal;
        VATAmountAddCurr: Decimal;
        VATBaseAddCurr: Decimal;
        PaidAmount: Decimal;
        TotalUnrealVATAmountFirst: Decimal;
        TotalUnrealVATAmountLast: Decimal;
        PurchVATAccount: Code[20];
        PurchVATUnrealAccount: Code[20];
        PurchReverseAccount: Code[20];
        PurchReverseUnrealAccount: Code[20];
        LastConnectionNo: Integer;
        RealizedPart: Decimal;
        RealizedVATAmount: Decimal;
        RealizedVATBase: Decimal;
        RealizedVATAmountAddCurr: Decimal;
        RealizedVATBaseAddCurr: Decimal;
        Currency: Record Currency;
        VATBaseFCY: Decimal;
        VATAmountFCY: Decimal;
        VATAmountCash: Decimal;
        VATBaseCash: Decimal;
    begin
        VATEntry2.Reset;
        VATEntry2.SetCurrentkey("Transaction No.");
        VATEntry2.SetRange("Transaction No.",VendLedgEntry2."Transaction No.");
        VendLedgEntry2.CalcFields("Amount (LCY)","Original Amt. (LCY)");
        PaidAmount := -VendLedgEntry2."Amount (LCY)" + VendLedgEntry2."Remaining Amt. (LCY)";
        if VATEntry2.FindSet then
          repeat
            VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
            if VATPostingSetup."Unrealized VAT Type" in
               [VATPostingSetup."unrealized vat type"::Last,VATPostingSetup."unrealized vat type"::"Last (Fully Paid)"]
            then
              TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - VATEntry2."Remaining Unrealized Amount";
            if VATPostingSetup."Unrealized VAT Type" in
               [VATPostingSetup."unrealized vat type"::First,VATPostingSetup."unrealized vat type"::"First (Fully Paid)"]
            then
              TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - VATEntry2."Remaining Unrealized Amount";
          until VATEntry2.Next = 0;
        if VATEntry2.FindSet then begin
          LastConnectionNo := 0;
          repeat
            VATPostingSetup.Get(VATEntry2."VAT Bus. Posting Group",VATEntry2."VAT Prod. Posting Group");
            if LastConnectionNo <> VATEntry2."Sales Tax Connection No." then begin
              InsertSummarizedVAT(GenJnlLine);
              LastConnectionNo := VATEntry2."Sales Tax Connection No.";
            end;

            VATPart :=
              VATEntry2.GetUnrealizedVATPart(
                ROUND(SettledAmount / VendLedgEntry2.GetOriginalCurrencyFactor),
                PaidAmount,
                VendLedgEntry2."Original Amt. (LCY)",
                TotalUnrealVATAmountFirst,
                TotalUnrealVATAmountLast,
                VendLedgEntry2."Original Amt. (LCY)");

            if VATPart > 0 then begin
              case VATEntry2."VAT Calculation Type" of
                VATEntry2."vat calculation type"::"Normal VAT",
                VATEntry2."vat calculation type"::"Full VAT":
                  begin
                    PurchVATAccount := VATPostingSetup.GetPurchAccount(false);
                    PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(true);
                  end;
                VATEntry2."vat calculation type"::"Reverse Charge VAT":
                  begin
                    PurchVATAccount := VATPostingSetup.GetPurchAccount(false);
                    PurchVATUnrealAccount := VATPostingSetup.GetPurchAccount(true);
                    PurchReverseAccount := VATPostingSetup.GetRevChargeAccount(false);
                    PurchReverseUnrealAccount := VATPostingSetup.GetRevChargeAccount(true);
                  end;
                VATEntry2."vat calculation type"::"Sales Tax":
                  if (VATEntry2.Type = VATEntry2.Type::Purchase) and VATEntry2."Use Tax" then begin
                    TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
                    PurchVATAccount := TaxJurisdiction.GetPurchAccount(false);
                    PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(true);
                    PurchReverseAccount := TaxJurisdiction.GetRevChargeAccount(false);
                    PurchReverseUnrealAccount := TaxJurisdiction.GetRevChargeAccount(true);
                  end else begin
                    TaxJurisdiction.Get(VATEntry2."Tax Jurisdiction Code");
                    PurchVATAccount := TaxJurisdiction.GetPurchAccount(false);
                    PurchVATUnrealAccount := TaxJurisdiction.GetPurchAccount(true);
                  end;
              end;

              if VATPart = 1 then begin
                VATAmount := VATEntry2."Remaining Unrealized Amount";
                VATBase := VATEntry2."Remaining Unrealized Base";
                VATAmountAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Amount";
                VATBaseAddCurr := VATEntry2."Add.-Curr. Rem. Unreal. Base";
              end else begin
                if (VATPostingSetup."Unrealized VAT Type" <> VATPostingSetup."unrealized vat type"::"Cash Basis") then begin
                  VATAmount := ROUND(VATEntry2."Remaining Unrealized Amount" * VATPart,GLSetup."Amount Rounding Precision");
                  VATBase := ROUND(VATEntry2."Remaining Unrealized Base" * VATPart,GLSetup."Amount Rounding Precision");
                  VATAmountAddCurr :=
                    ROUND(
                      VATEntry2."Add.-Curr. Rem. Unreal. Amount" * VATPart,
                      AddCurrency."Amount Rounding Precision");
                  VATBaseAddCurr :=
                    ROUND(
                      VATEntry2."Add.-Curr. Rem. Unreal. Base" * VATPart,
                      AddCurrency."Amount Rounding Precision");
                  end else begin
                    VATAmount := ROUND(VATEntry2."Unrealized Amount" * VATPart,GLSetup."Amount Rounding Precision");
                    VATBase := ROUND(VATEntry2."Unrealized Base" * VATPart,GLSetup."Amount Rounding Precision");
                    VATAmountAddCurr :=
                      ROUND(
                        VATEntry2."Add.-Currency Unrealized Amt." * VATPart,
                        AddCurrency."Amount Rounding Precision");
                    VATBaseAddCurr :=
                      ROUND(
                        VATEntry2."Add.-Currency Unrealized Base" * VATPart,
                        AddCurrency."Amount Rounding Precision");
                  end;
              end;

              // what is LCY value of VAT and VAT Base at posting date (cash basis)
              if (VATPostingSetup."Unrealized VAT Type" = VATPostingSetup."unrealized vat type"::"Cash Basis") and
                 (GainLossLCY <> 0)
              then begin
                if CurrencyFactor = 1 then // LCY to FCY application
                  CurrencyFactor := CurrExchRate.ExchangeRate(PostingDate,VendLedgEntry2."Currency Code");
                VATBaseFCY := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      PostingDate,VendLedgEntry2."Currency Code",VATBase,VendLedgEntry2."Original Currency Factor"));
                VATBaseCash :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PostingDate,VendLedgEntry2."Currency Code",VATBaseFCY,CurrencyFactor));
                VATAmountFCY := ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      PostingDate,VendLedgEntry2."Currency Code",VATAmount,VendLedgEntry2."Original Currency Factor"));
                VATAmountCash :=
                  ROUND(
                    CurrExchRate.ExchangeAmtFCYToLCY(
                      PostingDate,VendLedgEntry2."Currency Code",VATAmountFCY,CurrencyFactor));
              end else
                RealizedPart := 1;

              RealizedVATAmount := 0;
              RealizedVATBase := 0;
              RealizedVATAmountAddCurr := 0;
              RealizedVATBaseAddCurr := 0;
              if (GainLossLCY <> 0) and (VendLedgEntry2."Currency Code" <> '') and
                 (VATPostingSetup."Unrealized VAT Type" = VATPostingSetup."unrealized vat type"::"Cash Basis")
              then begin
                RealizedVATAmount := -(VATAmount - VATAmountCash);
                RealizedVATBase := -(VATBase - VATBaseCash);
                RealizedVATAmountAddCurr :=
                  ROUND(
                    VATAmountAddCurr * RealizedPart,
                    AddCurrency."Amount Rounding Precision");
                RealizedVATBaseAddCurr :=
                  ROUND(
                    VATBaseAddCurr * RealizedPart,
                    AddCurrency."Amount Rounding Precision");
              end;

              InitGLEntryVAT(
                GenJnlLine,PurchVATUnrealAccount,PurchVATAccount,-VATAmount,-VATAmountAddCurr,false);
              InitGLEntryVATCopy(
                GenJnlLine,PurchVATAccount,PurchVATUnrealAccount,
                VATAmount + RealizedVATAmount,VATAmountAddCurr + RealizedVATAmountAddCurr,VATEntry2);

              if (GainLossLCY <> 0) and (VendLedgEntry2."Currency Code" <> '') and
                 (VATPostingSetup."Unrealized VAT Type" = VATPostingSetup."unrealized vat type"::"Cash Basis")
              then begin
                Currency.Get(VendLedgEntry2."Currency Code");
                case VendLedgEntry2."Document Type" of
                  VendLedgEntry2."document type"::"Credit Memo":
                    begin
                      if GainLossLCY > 0 then begin
                        Currency.TestField("Realized Losses Acc.");
                        InitGLEntry(GenJnlLine,GLEntry,
                          Currency."Realized Losses Acc.",-RealizedVATAmount,0,false,true);
                        GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                      end else begin
                        Currency.TestField("Realized Gains Acc.");
                        InitGLEntry(GenJnlLine,GLEntry,
                          Currency."Realized Gains Acc.",-RealizedVATAmount,0,false,true);
                        GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                      end;
                    end;
                  else
                    if GainLossLCY < 0 then begin
                      Currency.TestField("Realized Losses Acc.");
                      InitGLEntry(GenJnlLine,GLEntry,
                        Currency."Realized Losses Acc.",-RealizedVATAmount,0,false,true);
                      GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                    end else begin
                      Currency.TestField("Realized Gains Acc.");
                      InitGLEntry(GenJnlLine,GLEntry,
                        Currency."Realized Gains Acc.",-RealizedVATAmount,0,false,true);
                      GLEntry."Additional-Currency Amount" := -RealizedVATAmountAddCurr;
                    end;
                end;
                GLEntry.CopyPostingGroupsFromVATEntry(VATEntry2);
                SummarizeVAT(GLSetup."Summarize G/L Entries",GLEntry);
              end;

              if (VATEntry2."VAT Calculation Type" =
                  VATEntry2."vat calculation type"::"Reverse Charge VAT") or
                 ((VATEntry2."VAT Calculation Type" =
                   VATEntry2."vat calculation type"::"Sales Tax") and
                  (VATEntry2.Type = VATEntry2.Type::Purchase) and VATEntry2."Use Tax")
              then begin
                InitGLEntryVAT(
                  GenJnlLine,PurchReverseUnrealAccount,PurchReverseAccount,VATAmount,VATAmountAddCurr,false);
                InitGLEntryVATCopy(
                  GenJnlLine,PurchReverseAccount,PurchReverseUnrealAccount,-VATAmount,-VATAmountAddCurr,VATEntry2);
              end;

              PostUnrealVATEntry(GenJnlLine,VATEntry2,VATAmount,VATBase,VATAmountAddCurr,VATBaseAddCurr);
            end;
          until VATEntry2.Next = 0;

          InsertSummarizedVAT(GenJnlLine);
        end;
    end;

    local procedure PostUnrealVATEntry(GenJnlLine: Record "Gen. Journal Line";var VATEntry2: Record "VAT Entry";VATAmount: Decimal;VATBase: Decimal;VATAmountAddCurr: Decimal;VATBaseAddCurr: Decimal)
    begin
        VATEntry.LockTable;
        VATEntry := VATEntry2;
        VATEntry."Entry No." := NextVATEntryNo;
        VATEntry."Posting Date" := GenJnlLine."Posting Date";
        VATEntry."Document No." := GenJnlLine."Document No.";
        VATEntry."External Document No." := GenJnlLine."External Document No.";
        VATEntry."Document Type" := GenJnlLine."Document Type";
        VATEntry.Amount := VATAmount;
        VATEntry.Base := VATBase;
        VATEntry."Additional-Currency Amount" := VATAmountAddCurr;
        VATEntry."Additional-Currency Base" := VATBaseAddCurr;
        VATEntry.SetUnrealAmountsToZero;
        VATEntry."User ID" := UserId;
        VATEntry."Source Code" := GenJnlLine."Source Code";
        VATEntry."Reason Code" := GenJnlLine."Reason Code";
        VATEntry."Closed by Entry No." := 0;
        VATEntry.Closed := false;
        VATEntry."Transaction No." := NextTransactionNo;
        VATEntry."Sales Tax Connection No." := NextConnectionNo;
        VATEntry."Unrealized VAT Entry No." := VATEntry2."Entry No.";
        VATEntry.Insert(true);
        NextVATEntryNo := NextVATEntryNo + 1;

        VATEntry2."Remaining Unrealized Amount" :=
          VATEntry2."Remaining Unrealized Amount" - VATEntry.Amount;
        VATEntry2."Remaining Unrealized Base" :=
          VATEntry2."Remaining Unrealized Base" - VATEntry.Base;
        VATEntry2."Add.-Curr. Rem. Unreal. Amount" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Amount" - VATEntry."Additional-Currency Amount";
        VATEntry2."Add.-Curr. Rem. Unreal. Base" :=
          VATEntry2."Add.-Curr. Rem. Unreal. Base" - VATEntry."Additional-Currency Base";
        VATEntry2.Modify;
    end;

    local procedure PostApply(GenJnlLine: Record "Gen. Journal Line";var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";var OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";var NewCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";BlockPaymentTolerance: Boolean;AllApplied: Boolean;var AppliedAmount: Decimal;var PmtTolAmtToBeApplied: Decimal;var VATRealizedGainLossLCY: Decimal)
    var
        OldCVLedgEntryBuf2: Record "CV Ledger Entry Buffer";
        OldCVLedgEntryBuf3: Record "CV Ledger Entry Buffer";
        OldRemainingAmtBeforeAppln: Decimal;
        ApplnRoundingPrecision: Decimal;
        AppliedAmountLCY: Decimal;
        OldAppliedAmount: Decimal;
        RealizedGainLossLCY: Decimal;
    begin
        OldRemainingAmtBeforeAppln := OldCVLedgEntryBuf."Remaining Amount";
        OldCVLedgEntryBuf3 := OldCVLedgEntryBuf;

        // Management of posting in multiple currencies
        OldCVLedgEntryBuf2 := OldCVLedgEntryBuf;
        OldCVLedgEntryBuf.Copyfilter(Positive,OldCVLedgEntryBuf2.Positive);
        ApplnRoundingPrecision := GetApplnRoundPrecision(NewCVLedgEntryBuf,OldCVLedgEntryBuf);

        OldCVLedgEntryBuf2.RecalculateAmounts(
          OldCVLedgEntryBuf2."Currency Code",NewCVLedgEntryBuf."Currency Code",NewCVLedgEntryBuf."Posting Date");

        if not BlockPaymentTolerance then
          CalcPmtTolerance(
            NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,
            PmtTolAmtToBeApplied,NextTransactionNo,FirstNewVATEntryNo);

        CalcPmtDisc(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,
          PmtTolAmtToBeApplied,ApplnRoundingPrecision,NextTransactionNo,FirstNewVATEntryNo);

        if not BlockPaymentTolerance then
          CalcPmtDiscTolerance(
            NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,GenJnlLine,
            NextTransactionNo,FirstNewVATEntryNo);

        CalcCurrencyApplnRounding(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf2,DtldCVLedgEntryBuf,
          GenJnlLine,ApplnRoundingPrecision);

        FindAmtForAppln(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,
          AppliedAmount,AppliedAmountLCY,OldAppliedAmount,ApplnRoundingPrecision);

        CalcCurrencyUnrealizedGainLoss(
          OldCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,-OldAppliedAmount,OldRemainingAmtBeforeAppln);

        CalcCurrencyRealizedGainLoss(
          NewCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,AppliedAmount,AppliedAmountLCY,RealizedGainLossLCY);
        VATRealizedGainLossLCY := RealizedGainLossLCY;

        CalcCurrencyRealizedGainLoss(
          OldCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine,-OldAppliedAmount,-AppliedAmountLCY,RealizedGainLossLCY);
        VATRealizedGainLossLCY := RealizedGainLossLCY;

        CalcApplication(
          NewCVLedgEntryBuf,OldCVLedgEntryBuf,DtldCVLedgEntryBuf,
          GenJnlLine,AppliedAmount,AppliedAmountLCY,OldAppliedAmount,
          NewCVLedgEntryBuf2,OldCVLedgEntryBuf3,AllApplied);

        PaymentToleranceMgt.CalcRemainingPmtDisc(NewCVLedgEntryBuf,OldCVLedgEntryBuf,OldCVLedgEntryBuf2,GLSetup);

        CalcAmtLCYAdjustment(OldCVLedgEntryBuf,DtldCVLedgEntryBuf,GenJnlLine);
    end;


    procedure UnapplyCustLedgEntry(GenJnlLine2: Record "Gen. Journal Line";DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        Cust: Record Customer;
        CustPostingGr: Record "Customer Posting Group";
        GenJnlLine: Record "Gen. Journal Line";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";
        VATEntry: Record "VAT Entry";
        TempVATEntry2: Record "VAT Entry" temporary;
        CurrencyLCY: Record Currency;
        TempInvPostBuf: Record "Invoice Post. Buffer" temporary;
        DimMgt: Codeunit DimensionManagement;
        AdjAmount: array [4] of Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
    begin
        GenJnlLine.TransferFields(GenJnlLine2);
        if GenJnlLine."Document Date" = 0D then
          GenJnlLine."Document Date" := GenJnlLine."Posting Date";

        if NextEntryNo = 0 then
          StartPosting(GenJnlLine)
        else
          ContinuePosting(GenJnlLine);

        ReadGLSetup(GLSetup);

        Cust.Get(DtldCustLedgEntry."Customer No.");
        Cust.CheckBlockedCustOnJnls(Cust,GenJnlLine2."document type"::Payment,true);
        CustPostingGr.Get(GenJnlLine."Posting Group");
        CustPostingGr.GetReceivablesAccount;

        VATEntry.LockTable;
        DtldCustLedgEntry.LockTable;
        CustLedgEntry.LockTable;

        DtldCustLedgEntry.TestField("Entry Type",DtldCustLedgEntry."entry type"::Application);

        DtldCustLedgEntry2.Reset;
        DtldCustLedgEntry2.FindLast;
        NextDtldLedgEntryNo := DtldCustLedgEntry2."Entry No." + 1;
        if DtldCustLedgEntry."Transaction No." = 0 then begin
          DtldCustLedgEntry2.SetCurrentkey("Application No.","Customer No.","Entry Type");
          DtldCustLedgEntry2.SetRange("Application No.",DtldCustLedgEntry."Application No.");
        end else begin
          DtldCustLedgEntry2.SetCurrentkey("Transaction No.","Customer No.","Entry Type");
          DtldCustLedgEntry2.SetRange("Transaction No.",DtldCustLedgEntry."Transaction No.");
        end;
        DtldCustLedgEntry2.SetRange("Customer No.",DtldCustLedgEntry."Customer No.");
        DtldCustLedgEntry2.SetFilter("Entry Type",'>%1',DtldCustLedgEntry."entry type"::"Initial Entry");
        if DtldCustLedgEntry."Transaction No." <> 0 then begin
          UnapplyVATEntries := false;
          DtldCustLedgEntry2.FindSet;
          repeat
            DtldCustLedgEntry2.TestField(Unapplied,false);
            if IsVATAdjustment(DtldCustLedgEntry2."Entry Type") then
              UnapplyVATEntries := true
          until DtldCustLedgEntry2.Next = 0;

          PostUnapply(
            GenJnlLine,VATEntry,VATEntry.Type::Sale,
            DtldCustLedgEntry."Customer No.",DtldCustLedgEntry."Transaction No.",UnapplyVATEntries,TempVATEntry);

          DtldCustLedgEntry2.FindSet;
          repeat
            DtldCVLedgEntryBuf.Init;
            DtldCVLedgEntryBuf.TransferFields(DtldCustLedgEntry2);
            ProcessTempVATEntry(DtldCVLedgEntryBuf,TempVATEntry);
          until DtldCustLedgEntry2.Next = 0;
        end;

        // Look one more time
        DtldCustLedgEntry2.FindSet;
        TempInvPostBuf.DeleteAll;
        repeat
          DtldCustLedgEntry2.TestField(Unapplied,false);
          DimMgt.UpdateGenJnlLineDimFromCustLedgEntry(GenJnlLine,DtldCustLedgEntry2);
          InsertDtldCustLedgEntryUnapply(GenJnlLine,NewDtldCustLedgEntry,DtldCustLedgEntry2,NextDtldLedgEntryNo);

          DtldCVLedgEntryBuf.Init;
          DtldCVLedgEntryBuf.TransferFields(NewDtldCustLedgEntry);
          SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
          CurrencyLCY.InitRoundingPrecision;

          if (DtldCustLedgEntry2."Transaction No." <> 0) and IsVATExcluded(DtldCustLedgEntry2."Entry Type") then begin
            UnapplyExcludedVAT(
              TempVATEntry2,DtldCustLedgEntry2."Transaction No.",DtldCustLedgEntry2."VAT Bus. Posting Group",
              DtldCustLedgEntry2."VAT Prod. Posting Group",DtldCustLedgEntry2."Gen. Prod. Posting Group");
            DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
              CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)",TempVATEntry2,CurrencyLCY);
          end;
          UpdateTotalAmounts(
            TempInvPostBuf,GenJnlLine."Dimension Set ID",DtldCVLedgEntryBuf."Amount (LCY)",
            DtldCVLedgEntryBuf."Additional-Currency Amount");

          if not (DtldCVLedgEntryBuf."Entry Type" in [
                                                      DtldCVLedgEntryBuf."entry type"::"Initial Entry",
                                                      DtldCVLedgEntryBuf."entry type"::Application])
          then
            CollectAdjustment(AdjAmount,
              -DtldCVLedgEntryBuf."Amount (LCY)",-DtldCVLedgEntryBuf."Additional-Currency Amount");

          PostDtldCustLedgEntryUnapply(
            GenJnlLine,DtldCVLedgEntryBuf,CustPostingGr,DtldCustLedgEntry2."Transaction No.");

          DtldCustLedgEntry2.Unapplied := true;
          DtldCustLedgEntry2."Unapplied by Entry No." := NewDtldCustLedgEntry."Entry No.";
          DtldCustLedgEntry2.Modify;

          UpdateCustLedgEntry(DtldCustLedgEntry2);
        until DtldCustLedgEntry2.Next = 0;

        CreateGLEntriesForTotalAmountsUnapply(GenJnlLine,TempInvPostBuf,CustPostingGr.GetReceivablesAccount);

        if IsTempGLEntryBufEmpty then
          DtldCustLedgEntry.SetZeroTransNo(NextTransactionNo);
        CheckPostUnrealizedVAT(GenJnlLine,true);
        FinishPosting;
    end;


    procedure UnapplyVendLedgEntry(GenJnlLine2: Record "Gen. Journal Line";DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        Vend: Record Vendor;
        VendPostingGr: Record "Vendor Posting Group";
        GenJnlLine: Record "Gen. Journal Line";
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";
        VATEntry: Record "VAT Entry";
        TempVATEntry2: Record "VAT Entry" temporary;
        CurrencyLCY: Record Currency;
        TempInvPostBuf: Record "Invoice Post. Buffer" temporary;
        DimMgt: Codeunit DimensionManagement;
        AdjAmount: array [4] of Decimal;
        NextDtldLedgEntryNo: Integer;
        UnapplyVATEntries: Boolean;
    begin
        GenJnlLine.TransferFields(GenJnlLine2);
        if GenJnlLine."Document Date" = 0D then
          GenJnlLine."Document Date" := GenJnlLine."Posting Date";

        if NextEntryNo = 0 then
          StartPosting(GenJnlLine)
        else
          ContinuePosting(GenJnlLine);

        ReadGLSetup(GLSetup);

        Vend.Get(DtldVendLedgEntry."Vendor No.");
        Vend.CheckBlockedVendOnJnls(Vend,GenJnlLine2."document type"::Payment,true);
        VendPostingGr.Get(GenJnlLine."Posting Group");
        VendPostingGr.GetPayablesAccount;

        VATEntry.LockTable;
        DtldVendLedgEntry.LockTable;
        VendLedgEntry.LockTable;

        DtldVendLedgEntry.TestField("Entry Type",DtldVendLedgEntry."entry type"::Application);

        DtldVendLedgEntry2.Reset;
        DtldVendLedgEntry2.FindLast;
        NextDtldLedgEntryNo := DtldVendLedgEntry2."Entry No." + 1;
        if DtldVendLedgEntry."Transaction No." = 0 then begin
          DtldVendLedgEntry2.SetCurrentkey("Application No.","Vendor No.","Entry Type");
          DtldVendLedgEntry2.SetRange("Application No.",DtldVendLedgEntry."Application No.");
        end else begin
          DtldVendLedgEntry2.SetCurrentkey("Transaction No.","Vendor No.","Entry Type");
          DtldVendLedgEntry2.SetRange("Transaction No.",DtldVendLedgEntry."Transaction No.");
        end;
        DtldVendLedgEntry2.SetRange("Vendor No.",DtldVendLedgEntry."Vendor No.");
        DtldVendLedgEntry2.SetFilter("Entry Type",'>%1',DtldVendLedgEntry."entry type"::"Initial Entry");
        if DtldVendLedgEntry."Transaction No." <> 0 then begin
          UnapplyVATEntries := false;
          DtldVendLedgEntry2.FindSet;
          repeat
            DtldVendLedgEntry2.TestField(Unapplied,false);
            if IsVATAdjustment(DtldVendLedgEntry2."Entry Type") then
              UnapplyVATEntries := true
          until DtldVendLedgEntry2.Next = 0;

          PostUnapply(
            GenJnlLine,VATEntry,VATEntry.Type::Purchase,
            DtldVendLedgEntry."Vendor No.",DtldVendLedgEntry."Transaction No.",UnapplyVATEntries,TempVATEntry);

          DtldVendLedgEntry2.FindSet;
          repeat
            DtldCVLedgEntryBuf.Init;
            DtldCVLedgEntryBuf.TransferFields(DtldVendLedgEntry2);
            ProcessTempVATEntry(DtldCVLedgEntryBuf,TempVATEntry);
          until DtldVendLedgEntry2.Next = 0;
        end;

        // Look one more time
        DtldVendLedgEntry2.FindSet;
        TempInvPostBuf.DeleteAll;
        repeat
          DtldVendLedgEntry2.TestField(Unapplied,false);
          DimMgt.UpdateGenJnlLineDimFromVendLedgEntry(GenJnlLine,DtldVendLedgEntry2);
          InsertDtldVendLedgEntryUnapply(GenJnlLine,NewDtldVendLedgEntry,DtldVendLedgEntry2,NextDtldLedgEntryNo);

          DtldCVLedgEntryBuf.Init;
          DtldCVLedgEntryBuf.TransferFields(NewDtldVendLedgEntry);
          SetAddCurrForUnapplication(DtldCVLedgEntryBuf);
          CurrencyLCY.InitRoundingPrecision;

          if (DtldVendLedgEntry2."Transaction No." <> 0) and IsVATExcluded(DtldVendLedgEntry2."Entry Type") then begin
            UnapplyExcludedVAT(
              TempVATEntry2,DtldVendLedgEntry2."Transaction No.",DtldVendLedgEntry2."VAT Bus. Posting Group",
              DtldVendLedgEntry2."VAT Prod. Posting Group",DtldVendLedgEntry2."Gen. Prod. Posting Group");
            DtldCVLedgEntryBuf."VAT Amount (LCY)" :=
              CalcVATAmountFromVATEntry(DtldCVLedgEntryBuf."Amount (LCY)",TempVATEntry2,CurrencyLCY);
          end;
          UpdateTotalAmounts(
            TempInvPostBuf,GenJnlLine."Dimension Set ID",DtldCVLedgEntryBuf."Amount (LCY)",
            DtldCVLedgEntryBuf."Additional-Currency Amount");

          if not (DtldCVLedgEntryBuf."Entry Type" in [
                                                      DtldCVLedgEntryBuf."entry type"::"Initial Entry",
                                                      DtldCVLedgEntryBuf."entry type"::Application])
          then
            CollectAdjustment(AdjAmount,
              -DtldCVLedgEntryBuf."Amount (LCY)",-DtldCVLedgEntryBuf."Additional-Currency Amount");

          PostDtldVendLedgEntryUnapply(
            GenJnlLine,DtldCVLedgEntryBuf,VendPostingGr,DtldVendLedgEntry2."Transaction No.");

          DtldVendLedgEntry2.Unapplied := true;
          DtldVendLedgEntry2."Unapplied by Entry No." := NewDtldVendLedgEntry."Entry No.";
          DtldVendLedgEntry2.Modify;

          UpdateVendLedgEntry(DtldVendLedgEntry2);
        until DtldVendLedgEntry2.Next = 0;

        CreateGLEntriesForTotalAmountsUnapply(GenJnlLine,TempInvPostBuf,VendPostingGr.GetPayablesAccount);

        if IsTempGLEntryBufEmpty then
          DtldVendLedgEntry.SetZeroTransNo(NextTransactionNo);
        CheckPostUnrealizedVAT(GenJnlLine,true);
        FinishPosting;
    end;

    local procedure UnapplyExcludedVAT(var TempVATEntry: Record "VAT Entry" temporary;TransactionNo: Integer;VATBusPostingGroup: Code[10];VATProdPostingGroup: Code[10];GenProdPostingGroup: Code[10])
    begin
        TempVATEntry.SetRange("VAT Bus. Posting Group",VATBusPostingGroup);
        TempVATEntry.SetRange("VAT Prod. Posting Group",VATProdPostingGroup);
        TempVATEntry.SetRange("Gen. Prod. Posting Group",GenProdPostingGroup);
        if not TempVATEntry.FindFirst then begin
          TempVATEntry.Reset;
          if TempVATEntry.FindLast then
            TempVATEntry."Entry No." := TempVATEntry."Entry No." + 1
          else
            TempVATEntry."Entry No." := 1;
          TempVATEntry.Init;
          TempVATEntry."VAT Bus. Posting Group" := VATBusPostingGroup;
          TempVATEntry."VAT Prod. Posting Group" := VATProdPostingGroup;
          TempVATEntry."Gen. Prod. Posting Group" := GenProdPostingGroup;
          VATEntry.SetCurrentkey("Transaction No.");
          VATEntry.SetRange("Transaction No.",TransactionNo);
          VATEntry.SetRange("VAT Bus. Posting Group",VATBusPostingGroup);
          VATEntry.SetRange("VAT Prod. Posting Group",VATProdPostingGroup);
          VATEntry.SetRange("Gen. Prod. Posting Group",GenProdPostingGroup);
          if VATEntry.FindSet then
            repeat
              if VATEntry."Unrealized VAT Entry No." = 0 then begin
                TempVATEntry.Base := TempVATEntry.Base + VATEntry.Base;
                TempVATEntry.Amount := TempVATEntry.Amount + VATEntry.Amount;
              end;
            until VATEntry.Next = 0;
          Clear(VATEntry);
          TempVATEntry.Insert;
        end;
    end;

    local procedure PostUnrealVATByUnapply(GenJnlLine: Record "Gen. Journal Line";VATPostingSetup: Record "VAT Posting Setup";VATEntry: Record "VAT Entry";NewVATEntry: Record "VAT Entry")
    var
        VATEntry2: Record "VAT Entry";
        AmountAddCurr: Decimal;
    begin
        AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date",VATEntry.Amount);
        CreateGLEntry(
          GenJnlLine,GetPostingAccountNo(VATPostingSetup,VATEntry,true),VATEntry.Amount,AmountAddCurr,false);
        CreateGLEntryFromVATEntry(
          GenJnlLine,GetPostingAccountNo(VATPostingSetup,VATEntry,false),-VATEntry.Amount,-AmountAddCurr,VATEntry);

        with VATEntry2 do begin
          Get(VATEntry."Unrealized VAT Entry No.");
          "Remaining Unrealized Amount" := "Remaining Unrealized Amount" - NewVATEntry.Amount;
          "Remaining Unrealized Base" := "Remaining Unrealized Base" - NewVATEntry.Base;
          "Add.-Curr. Rem. Unreal. Amount" :=
            "Add.-Curr. Rem. Unreal. Amount" - NewVATEntry."Additional-Currency Amount";
          "Add.-Curr. Rem. Unreal. Base" :=
            "Add.-Curr. Rem. Unreal. Base" - NewVATEntry."Additional-Currency Base";
          Modify;
        end;
    end;

    local procedure PostPmtDiscountVATByUnapply(GenJnlLine: Record "Gen. Journal Line";ReverseChargeVATAccNo: Code[20];VATAccNo: Code[20];VATEntry: Record "VAT Entry")
    var
        AmountAddCurr: Decimal;
    begin
        AmountAddCurr := CalcAddCurrForUnapplication(VATEntry."Posting Date",VATEntry.Amount);
        CreateGLEntry(GenJnlLine,ReverseChargeVATAccNo,VATEntry.Amount,AmountAddCurr,false);
        CreateGLEntry(GenJnlLine,VATAccNo,-VATEntry.Amount,-AmountAddCurr,false);
    end;

    local procedure PostUnapply(GenJnlLine: Record "Gen. Journal Line";var VATEntry: Record "VAT Entry";VATEntryType: Option;BilltoPaytoNo: Code[20];TransactionNo: Integer;var UnapplyVATEntries: Boolean;var TempVATEntry: Record "VAT Entry" temporary)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        VATEntry2: Record "VAT Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        AccNo: Code[20];
        TempVATEntryNo: Integer;
    begin
        TempVATEntryNo := 1;
        VATEntry.SetCurrentkey(Type,"Bill-to/Pay-to No.","Transaction No.");
        VATEntry.SetRange(Type,VATEntryType);
        VATEntry.SetRange("Bill-to/Pay-to No.",BilltoPaytoNo);
        VATEntry.SetRange("Transaction No.",TransactionNo);
        if VATEntry.FindSet then begin
          VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group");
          if VATPostingSetup."Adjust for Payment Discount" and not IsNotPayment(VATEntry."Document Type") and
             (VATPostingSetup."VAT Calculation Type" = VATPostingSetup."vat calculation type"::"Reverse Charge VAT")
          then
            UnapplyVATEntries := true;
          repeat
            if UnapplyVATEntries or (VATEntry."Unrealized VAT Entry No." <> 0) then begin
              InsertTempVATEntry(GenJnlLine,VATEntry,TempVATEntryNo,TempVATEntry);
              if VATEntry."Unrealized VAT Entry No." <> 0 then begin
                VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group",VATEntry."VAT Prod. Posting Group");
                if VATPostingSetup."VAT Calculation Type" in
                   [VATPostingSetup."vat calculation type"::"Normal VAT",
                    VATPostingSetup."vat calculation type"::"Full VAT"]
                then
                  PostUnrealVATByUnapply(GenJnlLine,VATPostingSetup,VATEntry,TempVATEntry)
                else
                  if VATPostingSetup."VAT Calculation Type" = VATPostingSetup."vat calculation type"::"Reverse Charge VAT" then begin
                    PostUnrealVATByUnapply(GenJnlLine,VATPostingSetup,VATEntry,TempVATEntry);
                    CreateGLEntry(
                      GenJnlLine,VATPostingSetup.GetRevChargeAccount(true),
                      -VATEntry.Amount,CalcAddCurrForUnapplication(VATEntry."Posting Date",-VATEntry.Amount),false);
                    CreateGLEntry(
                      GenJnlLine,VATPostingSetup.GetRevChargeAccount(false),
                      VATEntry.Amount,CalcAddCurrForUnapplication(VATEntry."Posting Date",VATEntry.Amount),false);
                  end else
                    PostUnrealVATByUnapply(GenJnlLine,VATPostingSetup,VATEntry,TempVATEntry);
                VATEntry2 := TempVATEntry;
                VATEntry2."Entry No." := NextVATEntryNo;
                VATEntry2.Insert;
                if VATEntry2."Unrealized VAT Entry No." = 0 then
                  GLEntryVATEntryLink.InsertLink(NextEntryNo,VATEntry2."Entry No.");
                TempVATEntry.Delete;
                IncrNextVATEntryNo;
              end;

              if VATPostingSetup."Adjust for Payment Discount" and not IsNotPayment(VATEntry."Document Type") and
                 (VATPostingSetup."VAT Calculation Type" =
                  VATPostingSetup."vat calculation type"::"Reverse Charge VAT") and
                 (VATEntry."Unrealized VAT Entry No." = 0)
              then begin
                case VATEntryType of
                  VATEntry.Type::Sale:
                    AccNo := VATPostingSetup.GetSalesAccount(false);
                  VATEntry.Type::Purchase:
                    AccNo := VATPostingSetup.GetPurchAccount(false);
                end;
                PostPmtDiscountVATByUnapply(GenJnlLine,VATPostingSetup.GetRevChargeAccount(false),AccNo,VATEntry);
              end;
            end;
          until VATEntry.Next = 0;
        end;
    end;

    local procedure CalcAddCurrForUnapplication(Date: Date;Amt: Decimal): Decimal
    var
        AddCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if AddCurrencyCode = '' then
          exit;

        AddCurrency.Get(AddCurrencyCode);
        AddCurrency.TestField("Amount Rounding Precision");

        exit(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              Date,AddCurrencyCode,Amt,CurrExchRate.ExchangeRate(Date,AddCurrencyCode)),
            AddCurrency."Amount Rounding Precision"));
    end;

    local procedure CalcVATAmountFromVATEntry(AmountLCY: Decimal;var VATEntry: Record "VAT Entry";CurrencyLCY: Record Currency) VATAmountLCY: Decimal
    begin
        with VATEntry do
          if (AmountLCY = Base) or (Base = 0) then begin
            VATAmountLCY := Amount;
            Delete;
          end else begin
            VATAmountLCY :=
              ROUND(
                Amount * AmountLCY / Base,
                CurrencyLCY."Amount Rounding Precision",
                CurrencyLCY.VATRoundingDirection);
            Base := Base - AmountLCY;
            Amount := Amount - VATAmountLCY;
            Modify;
          end;
    end;

    local procedure InsertDtldCustLedgEntryUnapply(GenJnlLine: Record "Gen. Journal Line";var NewDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";OldDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";var NextDtldLedgEntryNo: Integer)
    begin
        NewDtldCustLedgEntry := OldDtldCustLedgEntry;
        with NewDtldCustLedgEntry do begin
          "Entry No." := NextDtldLedgEntryNo;
          "Posting Date" := GenJnlLine."Posting Date";
          "Transaction No." := NextTransactionNo;
          "Application No." := 0;
          Amount := -OldDtldCustLedgEntry.Amount;
          "Amount (LCY)" := -OldDtldCustLedgEntry."Amount (LCY)";
          "Debit Amount" := -OldDtldCustLedgEntry."Debit Amount";
          "Credit Amount" := -OldDtldCustLedgEntry."Credit Amount";
          "Debit Amount (LCY)" := -OldDtldCustLedgEntry."Debit Amount (LCY)";
          "Credit Amount (LCY)" := -OldDtldCustLedgEntry."Credit Amount (LCY)";
          Unapplied := true;
          "Unapplied by Entry No." := OldDtldCustLedgEntry."Entry No.";
          "Document No." := GenJnlLine."Document No.";
          "Source Code" := GenJnlLine."Source Code";
          "User ID" := UserId;
          Insert(true);
        end;
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    end;

    local procedure InsertDtldVendLedgEntryUnapply(GenJnlLine: Record "Gen. Journal Line";var NewDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";OldDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";var NextDtldLedgEntryNo: Integer)
    begin
        NewDtldVendLedgEntry := OldDtldVendLedgEntry;
        with NewDtldVendLedgEntry do begin
          "Entry No." := NextDtldLedgEntryNo;
          "Posting Date" := GenJnlLine."Posting Date";
          "Transaction No." := NextTransactionNo;
          "Application No." := 0;
          Amount := -OldDtldVendLedgEntry.Amount;
          "Amount (LCY)" := -OldDtldVendLedgEntry."Amount (LCY)";
          "Debit Amount" := -OldDtldVendLedgEntry."Debit Amount";
          "Credit Amount" := -OldDtldVendLedgEntry."Credit Amount";
          "Debit Amount (LCY)" := -OldDtldVendLedgEntry."Debit Amount (LCY)";
          "Credit Amount (LCY)" := -OldDtldVendLedgEntry."Credit Amount (LCY)";
          Unapplied := true;
          "Unapplied by Entry No." := OldDtldVendLedgEntry."Entry No.";
          "Document No." := GenJnlLine."Document No.";
          "Source Code" := GenJnlLine."Source Code";
          "User ID" := UserId;
          Insert(true);
        end;
        NextDtldLedgEntryNo := NextDtldLedgEntryNo + 1;
    end;

    local procedure InsertTempVATEntry(GenJnlLine: Record "Gen. Journal Line";VATEntry: Record "VAT Entry";var TempVATEntryNo: Integer;var TempVATEntry: Record "VAT Entry" temporary)
    begin
        TempVATEntry := VATEntry;
        with TempVATEntry do begin
          "Entry No." := TempVATEntryNo;
          TempVATEntryNo := TempVATEntryNo + 1;
          "Closed by Entry No." := 0;
          Closed := false;
          CopyAmountsFromVATEntry(VATEntry,true);
          "Posting Date" := GenJnlLine."Posting Date";
          "Document No." := GenJnlLine."Document No.";
          "User ID" := UserId;
          "Transaction No." := NextTransactionNo;
          Insert;
        end;
    end;

    local procedure ProcessTempVATEntry(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";var TempVATEntry: Record "VAT Entry" temporary)
    var
        VATEntrySaved: Record "VAT Entry";
        VATBaseSum: array [3] of Decimal;
        DeductedVATBase: Decimal;
        EntryNoBegin: array [3] of Integer;
        i: Integer;
    begin
        if not (DtldCVLedgEntryBuf."Entry Type" in
                [DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Excl.)",
                 DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Excl.)",
                 DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Excl.)"])
        then
          exit;

        DeductedVATBase := 0;
        TempVATEntry.Reset;
        TempVATEntry.SetRange("Entry No.",0,999999);
        TempVATEntry.SetRange("Gen. Bus. Posting Group",DtldCVLedgEntryBuf."Gen. Bus. Posting Group");
        TempVATEntry.SetRange("Gen. Prod. Posting Group",DtldCVLedgEntryBuf."Gen. Prod. Posting Group");
        TempVATEntry.SetRange("VAT Bus. Posting Group",DtldCVLedgEntryBuf."VAT Bus. Posting Group");
        TempVATEntry.SetRange("VAT Prod. Posting Group",DtldCVLedgEntryBuf."VAT Prod. Posting Group");
        if TempVATEntry.FindSet then
          repeat
            case true of
              VATBaseSum[3] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                i := 4;
              VATBaseSum[2] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                i := 3;
              VATBaseSum[1] + TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                i := 2;
              TempVATEntry.Base = DtldCVLedgEntryBuf."Amount (LCY)" - DeductedVATBase:
                i := 1;
              else
                i := 0;
            end;
            if i > 0 then begin
              TempVATEntry.Reset;
              if i > 1 then begin
                if EntryNoBegin[i - 1] < TempVATEntry."Entry No." then
                  TempVATEntry.SetRange("Entry No.",EntryNoBegin[i - 1],TempVATEntry."Entry No.")
                else
                  TempVATEntry.SetRange("Entry No.",TempVATEntry."Entry No.",EntryNoBegin[i - 1]);
              end else
                TempVATEntry.SetRange("Entry No.",TempVATEntry."Entry No.");
              TempVATEntry.FindSet;
              repeat
                VATEntrySaved := TempVATEntry;
                case DtldCVLedgEntryBuf."Entry Type" of
                  DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Excl.)":
                    TempVATEntry.Rename(TempVATEntry."Entry No." + 2000000);
                  DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Excl.)":
                    TempVATEntry.Rename(TempVATEntry."Entry No." + 1000000);
                end;
                TempVATEntry := VATEntrySaved;
                DeductedVATBase += TempVATEntry.Base;
              until TempVATEntry.Next = 0;
              for i := 1 to 3 do begin
                VATBaseSum[i] := 0;
                EntryNoBegin[i] := 0;
              end;
              TempVATEntry.SetRange("Entry No.",0,999999);
            end else begin
              VATBaseSum[3] += TempVATEntry.Base;
              VATBaseSum[2] := VATBaseSum[1] + TempVATEntry.Base;
              VATBaseSum[1] := TempVATEntry.Base;
              if EntryNoBegin[3] > 0 then
                EntryNoBegin[3] := TempVATEntry."Entry No.";
              EntryNoBegin[2] := EntryNoBegin[1];
              EntryNoBegin[1] := TempVATEntry."Entry No.";
            end;
          until TempVATEntry.Next = 0;
    end;

    local procedure UpdateCustLedgEntry(DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."entry type"::Application then
          exit;

        CustLedgEntry.Get(DtldCustLedgEntry."Cust. Ledger Entry No.");
        CustLedgEntry."Remaining Pmt. Disc. Possible" := DtldCustLedgEntry."Remaining Pmt. Disc. Possible";
        CustLedgEntry."Max. Payment Tolerance" := DtldCustLedgEntry."Max. Payment Tolerance";
        CustLedgEntry."Accepted Payment Tolerance" := 0;
        if not CustLedgEntry.Open then begin
          CustLedgEntry.Open := true;
          CustLedgEntry."Closed by Entry No." := 0;
          CustLedgEntry."Closed at Date" := 0D;
          CustLedgEntry."Closed by Amount" := 0;
          CustLedgEntry."Closed by Amount (LCY)" := 0;
          CustLedgEntry."Closed by Currency Code" := '';
          CustLedgEntry."Closed by Currency Amount" := 0;
          CustLedgEntry."Pmt. Disc. Given (LCY)" := 0;
          CustLedgEntry."Pmt. Tolerance (LCY)" := 0;
          CustLedgEntry."Calculate Interest" := false;
        end;
        CustLedgEntry.Modify;
    end;

    local procedure UpdateVendLedgEntry(DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    var
        VendLedgEntry: Record "Vendor Ledger Entry";
    begin
        if DtldVendLedgEntry."Entry Type" <> DtldVendLedgEntry."entry type"::Application then
          exit;

        VendLedgEntry.Get(DtldVendLedgEntry."Vendor Ledger Entry No.");
        VendLedgEntry."Remaining Pmt. Disc. Possible" := DtldVendLedgEntry."Remaining Pmt. Disc. Possible";
        VendLedgEntry."Max. Payment Tolerance" := DtldVendLedgEntry."Max. Payment Tolerance";
        VendLedgEntry."Accepted Payment Tolerance" := 0;
        if not VendLedgEntry.Open then begin
          VendLedgEntry.Open := true;
          VendLedgEntry."Closed by Entry No." := 0;
          VendLedgEntry."Closed at Date" := 0D;
          VendLedgEntry."Closed by Amount" := 0;
          VendLedgEntry."Closed by Amount (LCY)" := 0;
          VendLedgEntry."Closed by Currency Code" := '';
          VendLedgEntry."Closed by Currency Amount" := 0;
          VendLedgEntry."Pmt. Disc. Rcd.(LCY)" := 0;
          VendLedgEntry."Pmt. Tolerance (LCY)" := 0;
        end;
        VendLedgEntry.Modify;
    end;

    local procedure UpdateCalcInterest(var CVLedgEntryBuf: Record "CV Ledger Entry Buffer")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        CVLedgEntryBuf2: Record "CV Ledger Entry Buffer";
    begin
        with CVLedgEntryBuf do begin
          if CustLedgEntry.Get("Closed by Entry No.") then begin
            CVLedgEntryBuf2.TransferFields(CustLedgEntry);
            UpdateCalcInterest2(CVLedgEntryBuf,CVLedgEntryBuf2);
          end;
          CustLedgEntry.SetCurrentkey("Closed by Entry No.");
          CustLedgEntry.SetRange("Closed by Entry No.","Entry No.");
          if CustLedgEntry.FindSet then
            repeat
              CVLedgEntryBuf2.TransferFields(CustLedgEntry);
              UpdateCalcInterest2(CVLedgEntryBuf,CVLedgEntryBuf2);
            until CustLedgEntry.Next = 0;
        end;
    end;

    local procedure UpdateCalcInterest2(var CVLedgEntryBuf: Record "CV Ledger Entry Buffer";var CVLedgEntryBuf2: Record "CV Ledger Entry Buffer")
    begin
        with CVLedgEntryBuf do
          if "Due Date" < CVLedgEntryBuf2."Document Date" then
            "Calculate Interest" := true;
    end;

    local procedure GLCalcAddCurrency(Amount: Decimal;AddCurrAmount: Decimal;OldAddCurrAmount: Decimal;UseAddCurrAmount: Boolean;GenJnlLine: Record "Gen. Journal Line"): Decimal
    begin
        if (AddCurrencyCode <> '') and
           (GenJnlLine."Additional-Currency Posting" = GenJnlLine."additional-currency posting"::None)
        then begin
          if (GenJnlLine."Source Currency Code" = AddCurrencyCode) and UseAddCurrAmount then
            exit(AddCurrAmount);

          exit(ExchangeAmtLCYToFCY2(Amount));
        end;
        exit(OldAddCurrAmount);
    end;

    local procedure HandleAddCurrResidualGLEntry(GenJnlLine: Record "Gen. Journal Line";Amount: Decimal;AmountAddCurr: Decimal)
    var
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
    begin
        if AddCurrencyCode = '' then
          exit;

        TotalAddCurrAmount := TotalAddCurrAmount + AmountAddCurr;
        TotalAmount := TotalAmount + Amount;

        if (GenJnlLine."Additional-Currency Posting" = GenJnlLine."additional-currency posting"::None) and
           (TotalAmount = 0) and (TotalAddCurrAmount <> 0) and
           CheckNonAddCurrCodeOccurred(GenJnlLine."Source Currency Code")
        then begin
          GLEntry.Init;
          GLEntry.CopyFromGenJnlLine(GenJnlLine);
          GLEntry."External Document No." := '';
          GLEntry.Description :=
            CopyStr(
              StrSubstNo(
                ResidualRoundingErr,
                GLEntry.FieldCaption("Additional-Currency Amount")),
              1,MaxStrLen(GLEntry.Description));
          GLEntry."Source Type" := 0;
          GLEntry."Source No." := '';
          GLEntry."Job No." := '';
          GLEntry.Quantity := 0;
          GLEntry."Entry No." := NextEntryNo;
          GLEntry."Transaction No." := NextTransactionNo;
          if TotalAddCurrAmount < 0 then
            GLEntry."G/L Account No." := AddCurrency."Residual Losses Account"
          else
            GLEntry."G/L Account No." := AddCurrency."Residual Gains Account";
          GLEntry.Amount := 0;
          GLEntry."System-Created Entry" := true;
          GLEntry."Additional-Currency Amount" := -TotalAddCurrAmount;
          GLAcc.Get(GLEntry."G/L Account No.");
          GLAcc.TestField(Blocked,false);
          GLAcc.TestField("Account Type",GLAcc."account type"::Posting);
          InsertGLEntry(GenJnlLine,GLEntry,false);

          CheckGLAccDimError(GenJnlLine,GLEntry."G/L Account No.");

          TotalAddCurrAmount := 0;
        end;
    end;

    local procedure CalcLCYToAddCurr(AmountLCY: Decimal): Decimal
    begin
        if AddCurrencyCode = '' then
          exit;

        exit(ExchangeAmtLCYToFCY2(AmountLCY));
    end;

    local procedure GetCurrencyExchRate(GenJnlLine: Record "Gen. Journal Line")
    var
        NewCurrencyDate: Date;
    begin
        if AddCurrencyCode = '' then
          exit;

        AddCurrency.Get(AddCurrencyCode);
        AddCurrency.TestField("Amount Rounding Precision");
        AddCurrency.TestField("Residual Gains Account");
        AddCurrency.TestField("Residual Losses Account");

        NewCurrencyDate := GenJnlLine."Posting Date";
        if GenJnlLine."Reversing Entry" then
          NewCurrencyDate := NewCurrencyDate - 1;
        if (NewCurrencyDate <> CurrencyDate) or
           UseCurrFactorOnly
        then begin
          UseCurrFactorOnly := false;
          CurrencyDate := NewCurrencyDate;
          CurrencyFactor :=
            CurrExchRate.ExchangeRate(CurrencyDate,AddCurrencyCode);
        end;
        if (GenJnlLine."FA Add.-Currency Factor" <> 0) and
           (GenJnlLine."FA Add.-Currency Factor" <> CurrencyFactor)
        then begin
          UseCurrFactorOnly := true;
          CurrencyDate := 0D;
          CurrencyFactor := GenJnlLine."FA Add.-Currency Factor";
        end;
    end;

    local procedure ExchangeAmtLCYToFCY2(Amount: Decimal): Decimal
    begin
        if UseCurrFactorOnly then
          exit(
            ROUND(
              CurrExchRate.ExchangeAmtLCYToFCYOnlyFactor(Amount,CurrencyFactor),
              AddCurrency."Amount Rounding Precision"));
        exit(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              CurrencyDate,AddCurrencyCode,Amount,CurrencyFactor),
            AddCurrency."Amount Rounding Precision"));
    end;

    local procedure CheckNonAddCurrCodeOccurred(CurrencyCode: Code[10]): Boolean
    begin
        NonAddCurrCodeOccured :=
          NonAddCurrCodeOccured or (AddCurrencyCode <> CurrencyCode);
        exit(NonAddCurrCodeOccured);
    end;

    local procedure TotalVATAmountOnJnlLines(GenJnlLine: Record "Gen. Journal Line") TotalVATAmount: Decimal
    var
        GenJnlLine2: Record "Gen. Journal Line";
    begin
        with GenJnlLine2 do begin
          SetRange("Source Code",GenJnlLine."Source Code");
          SetRange("Document No.",GenJnlLine."Document No.");
          SetRange("Posting Date",GenJnlLine."Posting Date");
          if FindSet then
            repeat
              TotalVATAmount += "VAT Amount (LCY)" - "Bal. VAT Amount (LCY)";
            until Next = 0;
        end;
        exit(TotalVATAmount);
    end;


    procedure SetGLRegReverse(var ReverseGLReg: Record "G/L Register")
    begin
        GLReg.Reversed := true;
        ReverseGLReg := GLReg;
    end;

    local procedure InsertVATEntriesFromTemp(var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";GLEntry: Record "G/L Entry")
    var
        Complete: Boolean;
        LinkedAmount: Decimal;
        FirstEntryNo: Integer;
        LastEntryNo: Integer;
    begin
        TempVATEntry.Reset;
        TempVATEntry.SetRange("Gen. Bus. Posting Group",GLEntry."Gen. Bus. Posting Group");
        TempVATEntry.SetRange("Gen. Prod. Posting Group",GLEntry."Gen. Prod. Posting Group");
        TempVATEntry.SetRange("VAT Bus. Posting Group",GLEntry."VAT Bus. Posting Group");
        TempVATEntry.SetRange("VAT Prod. Posting Group",GLEntry."VAT Prod. Posting Group");
        case DtldCVLedgEntryBuf."Entry Type" of
          DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Excl.)":
            begin
              FirstEntryNo := 0;
              LastEntryNo := 999999;
            end;
          DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Excl.)":
            begin
              FirstEntryNo := 1000000;
              LastEntryNo := 1999999;
            end;
          DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Excl.)":
            begin
              FirstEntryNo := 2000000;
              LastEntryNo := 2999999;
            end;
        end;
        TempVATEntry.SetRange("Entry No.",FirstEntryNo,LastEntryNo);
        if TempVATEntry.FindSet then
          repeat
            VATEntry := TempVATEntry;
            VATEntry."Entry No." := NextVATEntryNo;
            VATEntry.Insert(true);
            NextVATEntryNo := NextVATEntryNo + 1;
            if VATEntry."Unrealized VAT Entry No." = 0 then
              GLEntryVATEntryLink.InsertLink(GLEntry."Entry No.",VATEntry."Entry No.");
            if VATEntry."VAT Calculation Type" = VATEntry."vat calculation type"::"Full VAT" then begin
              LinkedAmount += VATEntry.Amount;
              Complete := LinkedAmount = -DtldCVLedgEntryBuf."VAT Amount (LCY)";
            end else begin
              LinkedAmount += VATEntry.Base;
              Complete := LinkedAmount = -DtldCVLedgEntryBuf."Amount (LCY)";
            end;
            LastEntryNo := TempVATEntry."Entry No.";
          until Complete or (TempVATEntry.Next = 0);

        TempVATEntry.SetRange("Entry No.",FirstEntryNo,LastEntryNo);
        TempVATEntry.DeleteAll;
    end;

    local procedure ABSMin(Decimal1: Decimal;Decimal2: Decimal): Decimal
    begin
        if Abs(Decimal1) < Abs(Decimal2) then
          exit(Decimal1);
        exit(Decimal2);
    end;


    procedure ABSMax(Decimal1: Decimal;Decimal2: Decimal): Decimal
    begin
        if Abs(Decimal1) > Abs(Decimal2) then
          exit(Decimal1);
        exit(Decimal2);
    end;

    local procedure GetApplnRoundPrecision(NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer"): Decimal
    var
        ApplnCurrency: Record Currency;
        CurrencyCode: Code[10];
    begin
        if NewCVLedgEntryBuf."Currency Code" <> '' then
          CurrencyCode := NewCVLedgEntryBuf."Currency Code"
        else
          CurrencyCode := OldCVLedgEntryBuf."Currency Code";
        if CurrencyCode = '' then
          exit(0);
        ApplnCurrency.Get(CurrencyCode);
        if ApplnCurrency."Appln. Rounding Precision" <> 0 then
          exit(ApplnCurrency."Appln. Rounding Precision");
        exit(GLSetup."Appln. Rounding Precision");
    end;

    local procedure GetGLSetup()
    begin
        if GLSetupRead then
          exit;

        GLSetup.Get;
        GLSetupRead := true;

        AddCurrencyCode := GLSetup."Additional Reporting Currency";
    end;

    local procedure ReadGLSetup(var NewGLSetup: Record "General Ledger Setup")
    begin
        NewGLSetup := GLSetup;
    end;

    local procedure CheckSalesExtDocNo(GenJnlLine: Record "Gen. Journal Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if not SalesSetup."Ext. Doc. No. Mandatory" then
          exit;

        if GenJnlLine."Document Type" in
           [GenJnlLine."document type"::Invoice,
            GenJnlLine."document type"::"Credit Memo",
            GenJnlLine."document type"::Payment,
            GenJnlLine."document type"::Refund,
            GenJnlLine."document type"::" "]
        then
          GenJnlLine.TestField("External Document No.");
    end;

    local procedure CheckPurchExtDocNo(GenJnlLine: Record "Gen. Journal Line")
    var
        PurchSetup: Record "Purchases & Payables Setup";
        OldVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        PurchSetup.Get;
        if not (PurchSetup."Ext. Doc. No. Mandatory" or (GenJnlLine."External Document No." <> '')) then
          exit;

        GenJnlLine.TestField("External Document No.");
        OldVendLedgEntry.Reset;
        OldVendLedgEntry.SetRange("External Document No.",GenJnlLine."External Document No.");
        OldVendLedgEntry.SetRange("Document Type",GenJnlLine."Document Type");
        OldVendLedgEntry.SetRange("Vendor No.",GenJnlLine."Account No.");
        OldVendLedgEntry.SetRange(Reversed,false);
        if not OldVendLedgEntry.IsEmpty then
          Error(
            PurchaseAlreadyExistsErr,
            GenJnlLine."Document Type",GenJnlLine."External Document No.");
    end;

    local procedure CheckDimValueForDisposal(GenJnlLine: Record "Gen. Journal Line";AccountNo: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        AccNo: array [10] of Code[20];
    begin
        if ((GenJnlLine.Amount = 0) or (GenJnlLine."Amount (LCY)" = 0)) and
           (GenJnlLine."FA Posting Type" = GenJnlLine."fa posting type"::Disposal)
        then begin
          TableID[1] := DimMgt.TypeToTableID1(GenJnlLine."account type"::"G/L Account");
          AccNo[1] := AccountNo;
          if not DimMgt.CheckDimValuePosting(TableID,AccNo,GenJnlLine."Dimension Set ID") then
            Error(DimMgt.GetDimValuePostingErr);
        end;
    end;


    procedure SetOverDimErr()
    begin
        OverrideDimErr := true;
    end;

    local procedure CheckGLAccDimError(GenJnlLine: Record "Gen. Journal Line";GLAccNo: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        AccNo: array [10] of Code[20];
    begin
        if (GenJnlLine.Amount = 0) and (GenJnlLine."Amount (LCY)" = 0) then
          exit;

        TableID[1] := Database::"G/L Account";
        AccNo[1] := GLAccNo;
        if DimMgt.CheckDimValuePosting(TableID,AccNo,GenJnlLine."Dimension Set ID") then
          exit;

        if GenJnlLine."Line No." <> 0 then
          Error(
            DimensionUsedErr,
            GenJnlLine.TableCaption,GenJnlLine."Journal Template Name",
            GenJnlLine."Journal Batch Name",GenJnlLine."Line No.",
            DimMgt.GetDimValuePostingErr);

        Error(DimMgt.GetDimValuePostingErr);
    end;

    local procedure CalculateCurrentBalance(AccountNo: Code[20];BalAccountNo: Code[20];InclVATAmount: Boolean;AmountLCY: Decimal;VATAmount: Decimal)
    begin
        if (AccountNo <> '') and (BalAccountNo <> '') then
          exit;

        if AccountNo = BalAccountNo then
          exit;

        if not InclVATAmount then
          VATAmount := 0;

        if BalAccountNo <> '' then
          CurrentBalance -= AmountLCY + VATAmount
        else
          CurrentBalance += AmountLCY + VATAmount;
    end;

    local procedure GetCurrency(var Currency: Record Currency;CurrencyCode: Code[10])
    begin
        if Currency.Code <> CurrencyCode then begin
          if CurrencyCode = '' then
            Clear(Currency)
          else
            Currency.Get(CurrencyCode);
        end;
    end;

    local procedure CollectAdjustment(var AdjAmount: array [4] of Decimal;Amount: Decimal;AmountAddCurr: Decimal)
    var
        Offset: Integer;
    begin
        Offset := GetAdjAmountOffset(Amount,AmountAddCurr);
        AdjAmount[Offset] += Amount;
        AdjAmount[Offset + 1] += AmountAddCurr;
    end;

    local procedure HandleDtldAdjustment(GenJnlLine: Record "Gen. Journal Line";var GLEntry: Record "G/L Entry";AdjAmount: array [4] of Decimal;TotalAmountLCY: Decimal;TotalAmountAddCurr: Decimal;GLAccNo: Code[20])
    begin
        if not PostDtldAdjustment(
             GenJnlLine,GLEntry,AdjAmount,
             TotalAmountLCY,TotalAmountAddCurr,GLAccNo,
             GetAdjAmountOffset(TotalAmountLCY,TotalAmountAddCurr))
        then
          InitGLEntry(GenJnlLine,GLEntry,GLAccNo,TotalAmountLCY,TotalAmountAddCurr,true,true);
    end;

    local procedure PostDtldAdjustment(GenJnlLine: Record "Gen. Journal Line";var GLEntry: Record "G/L Entry";AdjAmount: array [4] of Decimal;TotalAmountLCY: Decimal;TotalAmountAddCurr: Decimal;GLAcc: Code[20];ArrayIndex: Integer): Boolean
    begin
        if (GenJnlLine."Bal. Account No." <> '') and
           ((AdjAmount[ArrayIndex] <> 0) or (AdjAmount[ArrayIndex + 1] <> 0)) and
           ((TotalAmountLCY + AdjAmount[ArrayIndex] <> 0) or (TotalAmountAddCurr + AdjAmount[ArrayIndex + 1] <> 0))
        then begin
          CreateGLEntryBalAcc(
            GenJnlLine,GLAcc,-AdjAmount[ArrayIndex],-AdjAmount[ArrayIndex + 1],
            GenJnlLine."Bal. Account Type",GenJnlLine."Bal. Account No.");
          InitGLEntry(GenJnlLine,GLEntry,
            GLAcc,TotalAmountLCY + AdjAmount[ArrayIndex],
            TotalAmountAddCurr + AdjAmount[ArrayIndex + 1],true,true);
          AdjAmount[ArrayIndex] := 0;
          AdjAmount[ArrayIndex + 1] := 0;
          exit(true);
        end;

        exit(false);
    end;

    local procedure GetAdjAmountOffset(Amount: Decimal;AmountACY: Decimal): Integer
    begin
        if (Amount > 0) or (Amount = 0) and (AmountACY > 0) then
          exit(1);
        exit(3);
    end;


    procedure GetNextEntryNo(): Integer
    begin
        exit(NextEntryNo);
    end;


    procedure GetNextTransactionNo(): Integer
    begin
        exit(NextTransactionNo);
    end;


    procedure GetNextVATEntryNo(): Integer
    begin
        exit(NextVATEntryNo);
    end;


    procedure IncrNextVATEntryNo()
    begin
        NextVATEntryNo := NextVATEntryNo + 1;
    end;

    local procedure IsNotPayment(DocumentType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund): Boolean
    begin
        exit(DocumentType in [Documenttype::Invoice,
                              Documenttype::"Credit Memo",
                              Documenttype::"Finance Charge Memo",
                              Documenttype::Reminder]);
    end;

    local procedure IsTempGLEntryBufEmpty(): Boolean
    begin
        exit(TempGLEntryBuf.IsEmpty);
    end;

    local procedure IsVATAdjustment(EntryType: Option): Boolean
    var
        DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";
    begin
        exit(EntryType in [DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Adjustment)",
                           DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Adjustment)",
                           DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Adjustment)"]);
    end;

    local procedure IsVATExcluded(EntryType: Option): Boolean
    var
        DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";
    begin
        exit(EntryType in [DtldCVLedgEntryBuf."entry type"::"Payment Discount (VAT Excl.)",
                           DtldCVLedgEntryBuf."entry type"::"Payment Tolerance (VAT Excl.)",
                           DtldCVLedgEntryBuf."entry type"::"Payment Discount Tolerance (VAT Excl.)"]);
    end;


    procedure CalculateFirstLastAmount(UnRealizedVatType: Option " ",Percentage,First,Last,"First (Fully Paid)","Last (Fully Paid)","Cash Basis";RemainingUnrealizedAmount: Decimal;var TotalUnrealVATAmountLast: Decimal;var TotalUnrealVATAmountFirst: Decimal)
    begin
        if UnRealizedVatType in
           [Unrealizedvattype::Last,Unrealizedvattype::"Last (Fully Paid)"]
        then
          TotalUnrealVATAmountLast := TotalUnrealVATAmountLast - RemainingUnrealizedAmount;
        if UnRealizedVatType in
          [Unrealizedvattype::First,Unrealizedvattype::"First (Fully Paid)"]
        then
          TotalUnrealVATAmountFirst := TotalUnrealVATAmountFirst - RemainingUnrealizedAmount;
    end;

    local procedure UpdateGLEntryNo(var GLEntryNo: Integer;var SavedEntryNo: Integer)
    begin
        if SavedEntryNo <> 0 then begin
          GLEntryNo := SavedEntryNo;
          NextEntryNo := NextEntryNo - 1;
          SavedEntryNo := 0;
        end;
    end;

    local procedure UpdateTotalAmounts(var TempInvPostBuf: Record "Invoice Post. Buffer" temporary;DimSetID: Integer;AmountToCollect: Decimal;AmountACYToCollect: Decimal)
    begin
        with TempInvPostBuf do begin
          SetRange("Dimension Set ID",DimSetID);
          if FindFirst then begin
            Amount += AmountToCollect;
            "Amount (ACY)" += AmountACYToCollect;
            Modify;
          end else begin
            Init;
            "Dimension Set ID" := DimSetID;
            Amount := AmountToCollect;
            "Amount (ACY)" := AmountACYToCollect;
            Insert;
          end;
        end;
    end;

    local procedure CreateGLEntriesForTotalAmountsUnapply(GenJnlLine: Record "Gen. Journal Line";var TempInvPostBuf: Record "Invoice Post. Buffer" temporary;Account: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        with TempInvPostBuf do begin
          SetRange("Dimension Set ID");
          if FindSet then
            repeat
              if (Amount <> 0) or
                 ("Amount (ACY)" <> 0) and (GLSetup."Additional Reporting Currency" <> '')
              then begin
                DimMgt.UpdateGenJnlLineDim(GenJnlLine,"Dimension Set ID");
                CreateGLEntry(GenJnlLine,Account,Amount,"Amount (ACY)",true);
              end;
            until Next = 0;
        end;
    end;

    local procedure CreateGLEntriesForTotalAmounts(GenJnlLine: Record "Gen. Journal Line";var InvPostBuf: Record "Invoice Post. Buffer";AdjAmountBuf: array [4] of Decimal;SavedEntryNo: Integer;GLAccNo: Code[20];LedgEntryInserted: Boolean)
    var
        DimMgt: Codeunit DimensionManagement;
        GLEntryInserted: Boolean;
    begin
        GLEntryInserted := false;

        with InvPostBuf do begin
          Reset;
          if FindSet then
            repeat
              if (Amount <> 0) or ("Amount (ACY)" <> 0) and (AddCurrencyCode <> '') then begin
                DimMgt.UpdateGenJnlLineDim(GenJnlLine,"Dimension Set ID");
                CreateGLEntryForTotalAmounts(GenJnlLine,Amount,"Amount (ACY)",AdjAmountBuf,SavedEntryNo,GLAccNo);
                GLEntryInserted := true;
              end;
            until Next = 0;
        end;

        if not GLEntryInserted and LedgEntryInserted then
          CreateGLEntryForTotalAmounts(GenJnlLine,0,0,AdjAmountBuf,SavedEntryNo,GLAccNo);
    end;

    local procedure CreateGLEntryForTotalAmounts(GenJnlLine: Record "Gen. Journal Line";Amount: Decimal;AmountACY: Decimal;AdjAmountBuf: array [4] of Decimal;var SavedEntryNo: Integer;GLAccNo: Code[20])
    var
        GLEntry: Record "G/L Entry";
    begin
        HandleDtldAdjustment(GenJnlLine,GLEntry,AdjAmountBuf,Amount,AmountACY,GLAccNo);
        GLEntry."Bal. Account Type" := GenJnlLine."Bal. Account Type";
        GLEntry."Bal. Account No." := GenJnlLine."Bal. Account No.";
        UpdateGLEntryNo(GLEntry."Entry No.",SavedEntryNo);
        InsertGLEntry(GenJnlLine,GLEntry,true);
    end;

    local procedure SetAddCurrForUnapplication(var DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer")
    begin
        with DtldCVLedgEntryBuf do
          if not ("Entry Type" in ["entry type"::Application,"entry type"::"Unrealized Loss",
                                   "entry type"::"Unrealized Gain","entry type"::"Realized Loss",
                                   "entry type"::"Realized Gain","entry type"::"Correction of Remaining Amount"])
          then
            if ("Entry Type" = "entry type"::"Appln. Rounding") or
               ((AddCurrencyCode <> '') and (AddCurrencyCode = "Currency Code"))
            then
              "Additional-Currency Amount" := Amount
            else
              "Additional-Currency Amount" := CalcAddCurrForUnapplication("Posting Date","Amount (LCY)");
    end;

    local procedure GetAppliedAmountFromBuffers(NewCVLedgEntryBuf: Record "CV Ledger Entry Buffer";OldCVLedgEntryBuf: Record "CV Ledger Entry Buffer"): Decimal
    begin
        if (((NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."document type"::Payment) and
             (OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."document type"::"Credit Memo")) or
            ((NewCVLedgEntryBuf."Document Type" = NewCVLedgEntryBuf."document type"::Refund) and
             (OldCVLedgEntryBuf."Document Type" = OldCVLedgEntryBuf."document type"::Invoice))) and
           (Abs(NewCVLedgEntryBuf."Remaining Amount") < Abs(OldCVLedgEntryBuf."Amount to Apply"))
        then
          exit(ABSMax(NewCVLedgEntryBuf."Remaining Amount",-OldCVLedgEntryBuf."Amount to Apply"));
        exit(ABSMin(NewCVLedgEntryBuf."Remaining Amount",-OldCVLedgEntryBuf."Amount to Apply"));
    end;

    local procedure PostDeferral(var GenJournalLine: Record "Gen. Journal Line";AccountNumber: Code[20])
    var
        DeferralTemplate: Record "Deferral Template";
        DeferralHeader: Record "Deferral Header";
        DeferralLine: Record "Deferral Line";
        GLEntry: Record "G/L Entry";
        CurrExchRate: Record "Currency Exchange Rate";
        DeferralUtilities: Codeunit "Deferral Utilities";
        PerPostDate: Date;
        PeriodicCount: Integer;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        EmptyDeferralLine: Boolean;
    begin
        with GenJournalLine do begin
          if "Source Type" in ["source type"::Vendor,"source type"::Customer] then
            // Purchasing and Sales, respectively
            // We can create these types directly from the GL window, need to make sure we don't already have a deferral schedule
            // created for this GL Trx before handing it off to sales/purchasing subsystem
            if "Source Code" <> GLSourceCode then begin
              PostDeferralPostBuffer(GenJournalLine);
              exit;
            end;

          if DeferralHeader.Get(Deferraldoctype::"G/L","Journal Template Name","Journal Batch Name",0,'',"Line No.") then begin
            EmptyDeferralLine := false;
            // Get the range of detail records for this schedule
            DeferralLine.SetRange("Deferral Doc. Type",Deferraldoctype::"G/L");
            DeferralLine.SetRange("Gen. Jnl. Template Name","Journal Template Name");
            DeferralLine.SetRange("Gen. Jnl. Batch Name","Journal Batch Name");
            DeferralLine.SetRange("Document Type",0);
            DeferralLine.SetRange("Document No.",'');
            DeferralLine.SetRange("Line No.","Line No.");
            if DeferralLine.FindSet then
              repeat
                if DeferralLine.Amount = 0.0 then
                  EmptyDeferralLine := true;
              until (DeferralLine.Next = 0) or EmptyDeferralLine;
            if EmptyDeferralLine then
              Error(ZeroDeferralAmtErr,"Line No.","Deferral Code");
            DeferralHeader."Amount to Defer (LCY)" :=
              ROUND(CurrExchRate.ExchangeAmtFCYToLCY("Posting Date","Currency Code",
                  DeferralHeader."Amount to Defer","Currency Factor"));
            DeferralHeader.Modify;
          end;

          DeferralUtilities.RoundDeferralAmount(
            DeferralHeader,
            "Currency Code","Currency Factor","Posting Date",AmtToDefer,AmtToDeferACY);

          DeferralTemplate.Get("Deferral Code");
          DeferralTemplate.TestField("Deferral Account");
          DeferralTemplate.TestField("Deferral %");

          // Get the Deferral Header table so we know the amount to defer...
          // Assume straight GL posting
          if DeferralHeader.Get(Deferraldoctype::"G/L","Journal Template Name","Journal Batch Name",0,'',"Line No.") then begin
            // Get the range of detail records for this schedule
            DeferralLine.SetRange("Deferral Doc. Type",Deferraldoctype::"G/L");
            DeferralLine.SetRange("Gen. Jnl. Template Name","Journal Template Name");
            DeferralLine.SetRange("Gen. Jnl. Batch Name","Journal Batch Name");
            DeferralLine.SetRange("Document Type",0);
            DeferralLine.SetRange("Document No.",'');
            DeferralLine.SetRange("Line No.","Line No.");
          end else
            Error(NoDeferralScheduleErr,"Line No.","Deferral Code");

          InitGLEntry(GenJournalLine,GLEntry,
            AccountNumber,
            -DeferralHeader."Amount to Defer (LCY)",
            -DeferralHeader."Amount to Defer",true,true);
          GLEntry.Description := DeferralTemplate.Description;
          InsertGLEntry(GenJournalLine,GLEntry,true);

          InitGLEntry(GenJournalLine,GLEntry,
            DeferralTemplate."Deferral Account",
            DeferralHeader."Amount to Defer (LCY)",
            DeferralHeader."Amount to Defer",true,true);
          GLEntry.Description := DeferralTemplate.Description;
          InsertGLEntry(GenJournalLine,GLEntry,true);

          // Here we want to get the Deferral Details table range and loop through them...
          if DeferralLine.FindSet then begin
            PeriodicCount := 1;
            repeat
              PerPostDate := DeferralLine."Posting Date";
              if GenJnlCheckLine.DateNotAllowed(PerPostDate) then
                Error(InvalidPostingDateErr,PerPostDate);

              InitGLEntry(GenJournalLine,GLEntry,AccountNumber,DeferralLine."Amount (LCY)",
                DeferralLine.Amount,
                true,true);
              GLEntry."Posting Date" := PerPostDate;
              GLEntry.Description := DeferralLine.Description;
              InsertGLEntry(GenJournalLine,GLEntry,true);

              InitGLEntry(GenJournalLine,GLEntry,
                DeferralTemplate."Deferral Account",-DeferralLine."Amount (LCY)",
                -DeferralLine.Amount,
                true,true);
              GLEntry."Posting Date" := PerPostDate;
              GLEntry.Description := DeferralLine.Description;
              InsertGLEntry(GenJournalLine,GLEntry,true);
              PeriodicCount := PeriodicCount + 1;
            until DeferralLine.Next = 0;
          end else
            Error(NoDeferralScheduleErr,"Line No.","Deferral Code");
        end;
    end;

    local procedure PostDeferralPostBuffer(GenJournalLine: Record "Gen. Journal Line")
    var
        DeferralPostBuffer: Record "Deferral Post. Buffer";
        GLEntry: Record "G/L Entry";
        PostDate: Date;
    begin
        with GenJournalLine do begin
          if "Source Type" = "source type"::Customer then
            DeferralDocType := Deferraldoctype::Sales
          else
            DeferralDocType := Deferraldoctype::Purchase;

          DeferralPostBuffer.SetRange("Deferral Doc. Type",DeferralDocType);
          DeferralPostBuffer.SetRange("Document No.","Document No.");
          DeferralPostBuffer.SetRange("Deferral Line No.","Deferral Line No.");

          if DeferralPostBuffer.FindSet then begin
            repeat
              PostDate := DeferralPostBuffer."Posting Date";
              if GenJnlCheckLine.DateNotAllowed(PostDate) then
                Error(InvalidPostingDateErr,PostDate);

              // When no sales/purch amount is entered, the offset was already posted
              if (DeferralPostBuffer."Sales/Purch Amount" <> 0) or (DeferralPostBuffer."Sales/Purch Amount (LCY)" <> 0) then begin
                InitGLEntry(GenJournalLine,GLEntry,DeferralPostBuffer."G/L Account",
                  DeferralPostBuffer."Sales/Purch Amount (LCY)",
                  DeferralPostBuffer."Sales/Purch Amount",
                  true,true);
                GLEntry."Posting Date" := PostDate;
                GLEntry.Description := DeferralPostBuffer.Description;
                GLEntry.CopyFromDeferralPostBuffer(DeferralPostBuffer);
                InsertGLEntry(GenJournalLine,GLEntry,true);
              end;

              InitGLEntry(GenJournalLine,GLEntry,
                DeferralPostBuffer."Deferral Account",
                -DeferralPostBuffer."Amount (LCY)",
                -DeferralPostBuffer.Amount,
                true,true);
              GLEntry."Posting Date" := PostDate;
              GLEntry.Description := DeferralPostBuffer.Description;
              InsertGLEntry(GenJournalLine,GLEntry,true);
            until DeferralPostBuffer.Next = 0;
            DeferralPostBuffer.DeleteAll;
          end;
        end;
    end;


    procedure RemoveDeferralSchedule(GenJournalLine: Record "Gen. Journal Line")
    var
        DeferralUtilities: Codeunit "Deferral Utilities";
        DeferralDocType: Option Purchase,Sales,"G/L";
    begin
        // Removing deferral schedule after all deferrals for this line have been posted successfully
        with GenJournalLine do
          DeferralUtilities.DeferralCodeOnDelete(
            Deferraldoctype::"G/L",
            "Journal Template Name",
            "Journal Batch Name",0,'',"Line No.");
    end;

    local procedure GetGLSourceCode()
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.Get;
        GLSourceCode := SourceCodeSetup."General Journal";
    end;

    local procedure DeferralPosting(DeferralCode: Code[10];SourceCode: Code[10];AccountNo: Code[20];var GenJournalLine: Record "Gen. Journal Line";Balancing: Boolean)
    begin
        if DeferralCode <> '' then
          // Sales and purchasing could have negative amounts, so check for them first...
          if SourceCode <> GLSourceCode then
            PostDeferralPostBuffer(GenJournalLine)
          else
            // Pure GL trx, only post deferrals if it is not a balancing entry
            if not Balancing then
              PostDeferral(GenJournalLine,AccountNo);
    end;

    local procedure GetPostingAccountNo(VATPostingSetup: Record "VAT Posting Setup";VATEntry: Record "VAT Entry";UnrealizedVAT: Boolean): Code[20]
    var
        TaxJurisdiction: Record "Tax Jurisdiction";
    begin
        if VATPostingSetup."VAT Calculation Type" = VATPostingSetup."vat calculation type"::"Sales Tax" then begin
          VATEntry.TestField("Tax Jurisdiction Code");
          TaxJurisdiction.Get(VATEntry."Tax Jurisdiction Code");
          case VATEntry.Type of
            VATEntry.Type::Sale:
              exit(TaxJurisdiction.GetSalesAccount(UnrealizedVAT));
            VATEntry.Type::Purchase:
              exit(TaxJurisdiction.GetPurchAccount(UnrealizedVAT));
          end;
        end;

        case VATEntry.Type of
          VATEntry.Type::Sale:
            exit(VATPostingSetup.GetSalesAccount(UnrealizedVAT));
          VATEntry.Type::Purchase:
            exit(VATPostingSetup.GetPurchAccount(UnrealizedVAT));
        end;
    end;

    local procedure IsDebitAmount(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer";Unapply: Boolean): Boolean
    var
        VATPostingSetup: Record "VAT Posting Setup";
        VATAmountCondition: Boolean;
        EntryAmount: Decimal;
    begin
        with DtldCVLedgEntryBuf do begin
          VATAmountCondition :=
            "Entry Type" in ["entry type"::"Payment Discount (VAT Excl.)","entry type"::"Payment Tolerance (VAT Excl.)",
                             "entry type"::"Payment Discount Tolerance (VAT Excl.)"];
          if VATAmountCondition then begin
            VATPostingSetup.Get("VAT Bus. Posting Group","VAT Prod. Posting Group");
            VATAmountCondition := VATPostingSetup."VAT Calculation Type" = VATPostingSetup."vat calculation type"::"Full VAT";
          end;
          if VATAmountCondition then
            EntryAmount := "VAT Amount (LCY)"
          else
            EntryAmount := "Amount (LCY)";
          if Unapply then
            exit(EntryAmount > 0);
          exit(EntryAmount <= 0);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitGLRegister(var GLRegister: Record "G/L Register";var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertGlobalGLEntry(var GLEntry: Record "G/L Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertGLEntryBuffer(var TempGLEntryBuf: Record "G/L Entry" temporary;var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}

