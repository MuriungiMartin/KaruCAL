#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 225 "Gen. Jnl.-Apply"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GenJnlLine.Copy(Rec);

        with GenJnlLine do begin
          GetCurrency;
          if "Bal. Account Type" in
             ["bal. account type"::Customer,"bal. account type"::Vendor]
          then begin
            AccType := "Bal. Account Type";
            AccNo := "Bal. Account No.";
          end else begin
            AccType := "Account Type";
            AccNo := "Account No.";
          end;
          case AccType of
            Acctype::Customer:
              begin
                CustLedgEntry.SetCurrentkey("Customer No.",Open,Positive);
                CustLedgEntry.SetRange("Customer No.",AccNo);
                CustLedgEntry.SetRange(Open,true);
                if "Applies-to ID" = '' then
                  "Applies-to ID" := "Document No.";
                if "Applies-to ID" = '' then
                  Error(
                    Text000,
                    FieldCaption("Document No."),FieldCaption("Applies-to ID"));
                ApplyCustEntries.SetGenJnlLine(GenJnlLine,FieldNo("Applies-to ID"));
                ApplyCustEntries.SetRecord(CustLedgEntry);
                ApplyCustEntries.SetTableview(CustLedgEntry);
                ApplyCustEntries.LookupMode(true);
                OK := ApplyCustEntries.RunModal = Action::LookupOK;
                Clear(ApplyCustEntries);
                if not OK then
                  exit;
                CustLedgEntry.Reset;
                CustLedgEntry.SetCurrentkey("Customer No.",Open,Positive);
                CustLedgEntry.SetRange("Customer No.",AccNo);
                CustLedgEntry.SetRange(Open,true);
                CustLedgEntry.SetRange("Applies-to ID","Applies-to ID");
                if CustLedgEntry.Find('-') then begin
                  CurrencyCode2 := CustLedgEntry."Currency Code";
                  if Amount = 0 then begin
                    repeat
                      PaymentToleranceMgt.DelPmtTolApllnDocNo(GenJnlLine,CustLedgEntry."Document No.");
                      CheckAgainstApplnCurrency(CurrencyCode2,CustLedgEntry."Currency Code",Acctype::Customer,true);
                      CustLedgEntry.CalcFields("Remaining Amount");
                      CustLedgEntry."Remaining Amount" :=
                        CurrExchRate.ExchangeAmount(
                          CustLedgEntry."Remaining Amount",
                          CustLedgEntry."Currency Code","Currency Code","Posting Date");
                      CustLedgEntry."Remaining Amount" :=
                        ROUND(CustLedgEntry."Remaining Amount",Currency."Amount Rounding Precision");
                      CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                        CurrExchRate.ExchangeAmount(
                          CustLedgEntry."Remaining Pmt. Disc. Possible",
                          CustLedgEntry."Currency Code","Currency Code","Posting Date");
                      CustLedgEntry."Remaining Pmt. Disc. Possible" :=
                        ROUND(CustLedgEntry."Remaining Pmt. Disc. Possible",Currency."Amount Rounding Precision");
                      CustLedgEntry."Amount to Apply" :=
                        CurrExchRate.ExchangeAmount(
                          CustLedgEntry."Amount to Apply",
                          CustLedgEntry."Currency Code","Currency Code","Posting Date");
                      CustLedgEntry."Amount to Apply" :=
                        ROUND(CustLedgEntry."Amount to Apply",Currency."Amount Rounding Precision");

                      if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlCust(Rec,CustLedgEntry,0,false) and
                         (Abs(CustLedgEntry."Amount to Apply") >=
                          Abs(CustLedgEntry."Remaining Amount" - CustLedgEntry."Remaining Pmt. Disc. Possible"))
                      then
                        Amount := Amount - (CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible")
                      else
                        Amount := Amount - CustLedgEntry."Amount to Apply";
                    until CustLedgEntry.Next = 0;
                    if ("Bal. Account Type" = "bal. account type"::Customer) or
                       ("Bal. Account Type" = "bal. account type"::Vendor)
                    then
                      Amount := -Amount;
                    Validate(Amount);
                  end else
                    repeat
                      CheckAgainstApplnCurrency(CurrencyCode2,CustLedgEntry."Currency Code",Acctype::Customer,true);
                    until CustLedgEntry.Next = 0;
                  if "Currency Code" <> CurrencyCode2 then
                    if Amount = 0 then begin
                      if not
                         Confirm(
                           Text001 +
                           Text002,true,
                           FieldCaption("Currency Code"),TableCaption,"Currency Code",
                           CustLedgEntry."Currency Code")
                      then
                        Error(Text003);
                      "Currency Code" := CustLedgEntry."Currency Code"
                    end else
                      CheckAgainstApplnCurrency("Currency Code",CustLedgEntry."Currency Code",Acctype::Customer,true);
                  "Applies-to Doc. Type" := 0;
                  "Applies-to Doc. No." := '';
                end else
                  "Applies-to ID" := '';
                Modify;
                // Check Payment Tolerance
                if  Rec.Amount <> 0 then
                  if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then
                    exit;
              end;
            Acctype::Vendor:
              begin
                VendLedgEntry.SetCurrentkey("Vendor No.",Open,Positive);
                VendLedgEntry.SetRange("Vendor No.",AccNo);
                VendLedgEntry.SetRange(Open,true);
                if "Applies-to ID" = '' then
                  "Applies-to ID" := "Document No.";
                if "Applies-to ID" = '' then
                  Error(
                    Text000,
                    FieldCaption("Document No."),FieldCaption("Applies-to ID"));
                ApplyVendEntries.SetGenJnlLine(GenJnlLine,FieldNo("Applies-to ID"));
                ApplyVendEntries.SetRecord(VendLedgEntry);
                ApplyVendEntries.SetTableview(VendLedgEntry);
                ApplyVendEntries.LookupMode(true);
                OK := ApplyVendEntries.RunModal = Action::LookupOK;
                Clear(ApplyVendEntries);
                if not OK then
                  exit;
                VendLedgEntry.Reset;
                VendLedgEntry.SetCurrentkey("Vendor No.",Open,Positive);
                VendLedgEntry.SetRange("Vendor No.",AccNo);
                VendLedgEntry.SetRange(Open,true);
                VendLedgEntry.SetRange("Applies-to ID","Applies-to ID");
                if VendLedgEntry.Find('-') then begin
                  CurrencyCode2 := VendLedgEntry."Currency Code";
                  if Amount = 0 then begin
                    repeat
                      PaymentToleranceMgt.DelPmtTolApllnDocNo(GenJnlLine,VendLedgEntry."Document No.");
                      CheckAgainstApplnCurrency(CurrencyCode2,VendLedgEntry."Currency Code",Acctype::Vendor,true);
                      VendLedgEntry.CalcFields("Remaining Amount");
                      VendLedgEntry."Remaining Amount" :=
                        CurrExchRate.ExchangeAmount(
                          VendLedgEntry."Remaining Amount",
                          VendLedgEntry."Currency Code","Currency Code","Posting Date");
                      VendLedgEntry."Remaining Amount" :=
                        ROUND(VendLedgEntry."Remaining Amount",Currency."Amount Rounding Precision");
                      VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                        CurrExchRate.ExchangeAmount(
                          VendLedgEntry."Remaining Pmt. Disc. Possible",
                          VendLedgEntry."Currency Code","Currency Code","Posting Date");
                      VendLedgEntry."Remaining Pmt. Disc. Possible" :=
                        ROUND(VendLedgEntry."Remaining Pmt. Disc. Possible",Currency."Amount Rounding Precision");
                      VendLedgEntry."Amount to Apply" :=
                        CurrExchRate.ExchangeAmount(
                          VendLedgEntry."Amount to Apply",
                          VendLedgEntry."Currency Code","Currency Code","Posting Date");
                      VendLedgEntry."Amount to Apply" :=
                        ROUND(VendLedgEntry."Amount to Apply",Currency."Amount Rounding Precision");

                      if PaymentToleranceMgt.CheckCalcPmtDiscGenJnlVend(Rec,VendLedgEntry,0,false) and
                         (Abs(VendLedgEntry."Amount to Apply") >=
                          Abs(VendLedgEntry."Remaining Amount" - VendLedgEntry."Remaining Pmt. Disc. Possible"))
                      then
                        Amount := Amount - (VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible")
                      else
                        Amount := Amount - VendLedgEntry."Amount to Apply";

                    until VendLedgEntry.Next = 0;
                    if ("Bal. Account Type" = "bal. account type"::Customer) or
                       ("Bal. Account Type" = "bal. account type"::Vendor)
                    then
                      Amount := -Amount;
                    Validate(Amount);
                  end else
                    repeat
                      CheckAgainstApplnCurrency(CurrencyCode2,VendLedgEntry."Currency Code",Acctype::Vendor,true);
                    until VendLedgEntry.Next = 0;
                  if "Currency Code" <> CurrencyCode2 then
                    if Amount = 0 then begin
                      if not
                         Confirm(
                           Text001 +
                           Text002,true,
                           FieldCaption("Currency Code"),TableCaption,"Currency Code",
                           VendLedgEntry."Currency Code")
                      then
                        Error(Text003);
                      "Currency Code" := VendLedgEntry."Currency Code"
                    end else
                      CheckAgainstApplnCurrency("Currency Code",VendLedgEntry."Currency Code",Acctype::Vendor,true);
                  "Applies-to Doc. Type" := 0;
                  "Applies-to Doc. No." := '';
                end else
                  "Applies-to ID" := '';
                Modify;
                // Check Payment Tolerance
                if  Rec.Amount <> 0 then
                  if not PaymentToleranceMgt.PmtTolGenJnl(GenJnlLine) then
                    exit;
              end;
            else
              Error(
                Text005,
                FieldCaption("Account Type"),FieldCaption("Bal. Account Type"));
          end;
        end;

        Rec := GenJnlLine;
    end;

    var
        Text000: label 'You must specify %1 or %2.';
        Text001: label 'The %1 in the %2 will be changed from %3 to %4.\';
        Text002: label 'Do you wish to continue?';
        Text003: label 'The update has been interrupted to respect the warning.';
        Text005: label 'The %1 or %2 must be Customer or Vendor.';
        Text006: label 'All entries in one application must be in the same currency.';
        Text007: label 'All entries in one application must be in the same currency or one or more of the EMU currencies. ';
        GenJnlLine: Record "Gen. Journal Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendLedgEntry: Record "Vendor Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        ApplyCustEntries: Page "Apply Customer Entries";
        ApplyVendEntries: Page "Apply Vendor Entries";
        AccNo: Code[20];
        CurrencyCode2: Code[10];
        OK: Boolean;
        AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";


    procedure CheckAgainstApplnCurrency(ApplnCurrencyCode: Code[10];CompareCurrencyCode: Code[10];AccType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset";Message: Boolean): Boolean
    var
        Currency: Record Currency;
        Currency2: Record Currency;
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        CurrencyAppln: Option No,EMU,All;
    begin
        if ApplnCurrencyCode = CompareCurrencyCode then
          exit(true);

        case AccType of
          Acctype::Customer:
            begin
              SalesSetup.Get;
              CurrencyAppln := SalesSetup."Appln. between Currencies";
              case CurrencyAppln of
                Currencyappln::No:
                  begin
                    if ApplnCurrencyCode <> CompareCurrencyCode then
                      if Message then
                        Error(Text006)
                      else
                        exit(false);
                  end;
                Currencyappln::EMU:
                  begin
                    GLSetup.Get;
                    if not Currency.Get(ApplnCurrencyCode) then
                      Currency."EMU Currency" := GLSetup."EMU Currency";
                    if not Currency2.Get(CompareCurrencyCode) then
                      Currency2."EMU Currency" := GLSetup."EMU Currency";
                    if not Currency."EMU Currency" or not Currency2."EMU Currency" then
                      if Message then
                        Error(Text007)
                      else
                        exit(false);
                  end;
              end;
            end;
          Acctype::Vendor:
            begin
              PurchSetup.Get;
              CurrencyAppln := PurchSetup."Appln. between Currencies";
              case CurrencyAppln of
                Currencyappln::No:
                  begin
                    if ApplnCurrencyCode <> CompareCurrencyCode then
                      if Message then
                        Error(Text006)
                      else
                        exit(false);
                  end;
                Currencyappln::EMU:
                  begin
                    GLSetup.Get;
                    if not Currency.Get(ApplnCurrencyCode) then
                      Currency."EMU Currency" := GLSetup."EMU Currency";
                    if not Currency2.Get(CompareCurrencyCode) then
                      Currency2."EMU Currency" := GLSetup."EMU Currency";
                    if not Currency."EMU Currency" or not Currency2."EMU Currency" then
                      if Message then
                        Error(Text007)
                      else
                        exit(false);
                  end;
              end;
            end;
        end;

        exit(true);
    end;

    local procedure GetCurrency()
    begin
        with GenJnlLine do begin
          if "Currency Code" = '' then
            Currency.InitRoundingPrecision
          else begin
            Currency.Get("Currency Code");
            Currency.TestField("Amount Rounding Precision");
          end;
        end;
    end;
}

