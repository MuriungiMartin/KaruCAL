#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 11 "Gen. Jnl.-Check Line"
{
    Permissions = TableData "General Posting Setup"=rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        GLSetup.Get;
        RunCheck(Rec);
    end;

    var
        Text000: label 'can only be a closing date for G/L entries';
        Text001: label 'is not within your range of allowed posting dates';
        Text002: label '%1 or %2 must be G/L Account or Bank Account.';
        Text003: label 'must have the same sign as %1';
        Text004: label 'You must not specify %1 when %2 is %3.';
        Text005: label '%1 + %2 must be %3.';
        Text006: label '%1 + %2 must be -%3.';
        Text007: label 'must be positive';
        Text008: label 'must be negative';
        Text009: label 'must have a different sign than %1';
        Text010: label '%1 %2 and %3 %4 is not allowed.';
        Text011: label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text012: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        CostAccSetup: Record "Cost Accounting Setup";
        DimMgt: Codeunit DimensionManagement;
        CostAccMgt: Codeunit "Cost Account Mgt";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        GenJnlTemplateFound: Boolean;
        OverrideDimErr: Boolean;
        SalesDocAlreadyExistsErr: label 'Sales %1 %2 already exists.', Comment='%1 = Document Type; %2 = Document No.';
        PurchDocAlreadyExistsErr: label 'Purchase %1 %2 already exists.', Comment='%1 = Document Type; %2 = Document No.';


    procedure RunCheck(var GenJnlLine: Record "Gen. Journal Line")
    var
        ICGLAcount: Record "IC G/L Account";
    begin
        with GenJnlLine do begin
          if EmptyLine then
            exit;

          if not GenJnlTemplateFound then begin
            if GenJnlTemplate.Get("Journal Template Name") then;
            GenJnlTemplateFound := true;
          end;

          CheckDates(GenJnlLine);

          TestField("Document No.");

          if ("Account Type" in
              ["account type"::Customer,
               "account type"::Vendor,
               "account type"::"Fixed Asset",
               "account type"::"IC Partner"]) and
             ("Bal. Account Type" in
              ["bal. account type"::Customer,
               "bal. account type"::Vendor,
               "bal. account type"::"Fixed Asset",
               "bal. account type"::"IC Partner"])
          then
            Error(
              Text002,
              FieldCaption("Account Type"),FieldCaption("Bal. Account Type"));

          if "Bal. Account No." = '' then
            TestField("Account No.");

          if ("Account No." <> '') and
             not "System-Created Entry" and
             not "Allow Zero-Amount Posting" and
             ("Account Type" <> "account type"::"Fixed Asset")
          then
            TestField(Amount);

          if ((Amount < 0) xor ("Amount (LCY)" < 0)) and (Amount <> 0) and ("Amount (LCY)" <> 0) then
            FieldError("Amount (LCY)",StrSubstNo(Text003,FieldCaption(Amount)));

          if ("Account Type" = "account type"::"G/L Account") and
             ("Bal. Account Type" = "bal. account type"::"G/L Account")
          then
            TestField("Applies-to Doc. No.",'');

          if ("Recurring Method" in
              ["recurring method"::"B  Balance","recurring method"::"RB Reversing Balance"]) and
             ("Currency Code" <> '')
          then
            Error(
              Text004,
              FieldCaption("Currency Code"),FieldCaption("Recurring Method"),"Recurring Method");

          if "Account No." <> '' then
            CheckAccountNo(GenJnlLine);

          if "Bal. Account No." <> '' then
            CheckBalAccountNo(GenJnlLine);

          if "IC Partner G/L Acc. No." <> '' then
            if ICGLAcount.Get("IC Partner G/L Acc. No.") then
              ICGLAcount.TestField(Blocked,false);

          if (("Account Type" = "account type"::"G/L Account") and
              ("Bal. Account Type" = "bal. account type"::"G/L Account")) or
             (("Document Type" <> "document type"::Invoice) and
              (not
               (("Document Type" = "document type"::"Credit Memo") and
                CalcPmtDiscOnCrMemos("Payment Terms Code"))))
          then begin
            TestField("Pmt. Discount Date",0D);
            TestField("Payment Discount %",0);
          end;

          if (("Account Type" = "account type"::"G/L Account") and
              ("Bal. Account Type" = "bal. account type"::"G/L Account")) or
             ("Applies-to Doc. No." <> '')
          then
            TestField("Applies-to ID",'');

          if ("Account Type" <> "account type"::"Bank Account") and
             ("Bal. Account Type" <> "bal. account type"::"Bank Account")
          then
            TestField("Bank Payment Type","bank payment type"::" ");

          if ("Account Type" = "account type"::"Fixed Asset") or
             ("Bal. Account Type" = "bal. account type"::"Fixed Asset")
          then
            Codeunit.Run(Codeunit::"FA Jnl.-Check Line",GenJnlLine);

          if ("Account Type" <> "account type"::"Fixed Asset") and
             ("Bal. Account Type" <> "bal. account type"::"Fixed Asset")
          then begin
            TestField("Depreciation Book Code",'');
            TestField("FA Posting Type",0);
          end;

          if OverrideDimErr then
            exit;

          CheckDimensions(GenJnlLine);
        end;

        if CostAccSetup.Get then
          CostAccMgt.CheckValidCCAndCOInGLEntry(GenJnlLine."Dimension Set ID");

        OnAfterCheckGenJnlLine(GenJnlLine);
    end;

    local procedure CalcPmtDiscOnCrMemos(PaymentTermsCode: Code[10]): Boolean
    var
        PaymentTerms: Record "Payment Terms";
    begin
        if PaymentTermsCode <> '' then begin
          PaymentTerms.Get(PaymentTermsCode);
          exit(PaymentTerms."Calc. Pmt. Disc. on Cr. Memos");
        end;
    end;


    procedure DateNotAllowed(PostingDate: Date): Boolean
    begin
        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
          if UserId <> '' then
            if UserSetup.Get(UserId) then begin
              AllowPostingFrom := UserSetup."Allow Posting From";
              AllowPostingTo := UserSetup."Allow Posting To";
            end;
          if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            GLSetup.Get;
            AllowPostingFrom := GLSetup."Allow Posting From";
            AllowPostingTo := GLSetup."Allow Posting To";
          end;
          if AllowPostingTo = 0D then
            AllowPostingTo := Dmy2date(31,12,9999);
        end;
        exit((PostingDate < AllowPostingFrom) or (PostingDate > AllowPostingTo));
    end;

    local procedure ErrorIfPositiveAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJnlLine.Amount > 0 then
          GenJnlLine.FieldError(Amount,Text008);
    end;

    local procedure ErrorIfNegativeAmt(GenJnlLine: Record "Gen. Journal Line")
    begin
        if GenJnlLine.Amount < 0 then
          GenJnlLine.FieldError(Amount,Text007);
    end;


    procedure SetOverDimErr()
    begin
        OverrideDimErr := true;
    end;

    local procedure CheckDates(GenJnlLine: Record "Gen. Journal Line")
    var
        AccountingPeriod: Record "Accounting Period";
    begin
        with GenJnlLine do begin
          TestField("Posting Date");
          if "Posting Date" <> NormalDate("Posting Date") then begin
            if ("Account Type" <> "account type"::"G/L Account") or
               ("Bal. Account Type" <> "bal. account type"::"G/L Account")
            then
              FieldError("Posting Date",Text000);
            AccountingPeriod.Get(NormalDate("Posting Date") + 1);
            AccountingPeriod.TestField("New Fiscal Year",true);
            AccountingPeriod.TestField("Date Locked",true);
          end;

          if DateNotAllowed("Posting Date") then
            FieldError("Posting Date",Text001);

          if "Document Date" <> 0D then
            if ("Document Date" <> NormalDate("Document Date")) and
               (("Account Type" <> "account type"::"G/L Account") or
                ("Bal. Account Type" <> "bal. account type"::"G/L Account"))
            then
              FieldError("Document Date",Text000);
        end;
    end;

    local procedure CheckAccountNo(GenJnlLine: Record "Gen. Journal Line")
    var
        ICPartner: Record "IC Partner";
    begin
        with GenJnlLine do
          case "Account Type" of
            "account type"::"G/L Account":
              begin
                if ("Gen. Bus. Posting Group" <> '') or ("Gen. Prod. Posting Group" <> '') or
                   ("VAT Bus. Posting Group" <> '') or ("VAT Prod. Posting Group" <> '')
                then
                  TestField("Gen. Posting Type");
                if ("Gen. Posting Type" <> "gen. posting type"::" ") and
                   ("VAT Posting" = "vat posting"::"Automatic VAT Entry")
                then begin
                  if "VAT Amount" + "VAT Base Amount" <> Amount then
                    Error(
                      Text005,FieldCaption("VAT Amount"),FieldCaption("VAT Base Amount"),
                      FieldCaption(Amount));
                  if "Currency Code" <> '' then
                    if "VAT Amount (LCY)" + "VAT Base Amount (LCY)" <> "Amount (LCY)" then
                      Error(
                        Text005,FieldCaption("VAT Amount (LCY)"),
                        FieldCaption("VAT Base Amount (LCY)"),FieldCaption("Amount (LCY)"));
                end;
              end;
            "account type"::Customer,"account type"::Vendor:
              begin
                TestField("Gen. Posting Type",0);
                TestField("Gen. Bus. Posting Group",'');
                TestField("Gen. Prod. Posting Group",'');
                TestField("VAT Bus. Posting Group",'');
                TestField("VAT Prod. Posting Group",'');

                if (("Account Type" = "account type"::Customer) and
                    ("Bal. Gen. Posting Type" = "bal. gen. posting type"::Purchase)) or
                   (("Account Type" = "account type"::Vendor) and
                    ("Bal. Gen. Posting Type" = "bal. gen. posting type"::Sale))
                then
                  Error(
                    StrSubstNo(
                      Text010,
                      FieldCaption("Account Type"),"Account Type",
                      FieldCaption("Bal. Gen. Posting Type"),"Bal. Gen. Posting Type"));

                CheckDocType(GenJnlLine);

                if not "System-Created Entry" and
                   (((Amount < 0) xor ("Sales/Purch. (LCY)" < 0)) and (Amount <> 0) and ("Sales/Purch. (LCY)" <> 0))
                then
                  FieldError("Sales/Purch. (LCY)",StrSubstNo(Text003,FieldCaption(Amount)));
                TestField("Job No.",'');

                CheckICPartner("Account Type","Account No.","Document Type");
              end;
            "account type"::"Bank Account":
              begin
                TestField("Gen. Posting Type",0);
                TestField("Gen. Bus. Posting Group",'');
                TestField("Gen. Prod. Posting Group",'');
                TestField("VAT Bus. Posting Group",'');
                TestField("VAT Prod. Posting Group",'');
                TestField("Job No.",'');
                if (Amount < 0) and ("Bank Payment Type" = "bank payment type"::"Computer Check") then
                  TestField("Check Printed",true);
                if "Bank Payment Type" = "bank payment type"::"Electronic Payment" then begin
                  TestField("Check Exported",true);
                  TestField("Check Transmitted",true);
                end;
              end;
            "account type"::"IC Partner":
              begin
                ICPartner.Get("Account No.");
                ICPartner.CheckICPartner;
                if "Journal Template Name" <> '' then
                  if GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany then
                    FieldError("Account Type");
              end;
          end;
    end;

    local procedure CheckBalAccountNo(GenJnlLine: Record "Gen. Journal Line")
    var
        ICPartner: Record "IC Partner";
    begin
        with GenJnlLine do
          case "Bal. Account Type" of
            "bal. account type"::"G/L Account":
              begin
                if (("Bal. Gen. Bus. Posting Group" <> '') or ("Bal. Gen. Prod. Posting Group" <> '') or
                   ("Bal. VAT Bus. Posting Group" <> '') or ("Bal. VAT Prod. Posting Group" <> '')) and
                   GLSetup."VAT in Use"
                then
                  TestField("Bal. Gen. Posting Type");
                if ("Bal. Gen. Posting Type" <> "bal. gen. posting type"::" ") and
                   ("VAT Posting" = "vat posting"::"Automatic VAT Entry")
                then begin
                  if "Bal. VAT Amount" + "Bal. VAT Base Amount" <> -Amount then
                    Error(
                      Text006,FieldCaption("Bal. VAT Amount"),FieldCaption("Bal. VAT Base Amount"),
                      FieldCaption(Amount));
                  if "Currency Code" <> '' then
                    if "Bal. VAT Amount (LCY)" + "Bal. VAT Base Amount (LCY)" <> -"Amount (LCY)" then
                      Error(
                        Text006,FieldCaption("Bal. VAT Amount (LCY)"),
                        FieldCaption("Bal. VAT Base Amount (LCY)"),FieldCaption("Amount (LCY)"));
                end;
              end;
            "bal. account type"::Customer,"bal. account type"::Vendor:
              begin
                TestField("Bal. Gen. Posting Type",0);
                TestField("Bal. Gen. Bus. Posting Group",'');
                TestField("Bal. Gen. Prod. Posting Group",'');
                TestField("Bal. VAT Bus. Posting Group",'');
                TestField("Bal. VAT Prod. Posting Group",'');

                if (("Bal. Account Type" = "bal. account type"::Customer) and
                    ("Gen. Posting Type" = "gen. posting type"::Purchase)) or
                   (("Bal. Account Type" = "bal. account type"::Vendor) and
                    ("Gen. Posting Type" = "gen. posting type"::Sale))
                then
                  Error(
                    StrSubstNo(
                      Text010,
                      FieldCaption("Bal. Account Type"),"Bal. Account Type",
                      FieldCaption("Gen. Posting Type"),"Gen. Posting Type"));

                CheckBalDocType(GenJnlLine);

                if ((Amount > 0) xor ("Sales/Purch. (LCY)" < 0)) and (Amount <> 0) and ("Sales/Purch. (LCY)" <> 0) then
                  FieldError("Sales/Purch. (LCY)",StrSubstNo(Text009,FieldCaption(Amount)));
                TestField("Job No.",'');

                CheckICPartner("Bal. Account Type","Bal. Account No.","Document Type");
              end;
            "bal. account type"::"Bank Account":
              begin
                TestField("Bal. Gen. Posting Type",0);
                TestField("Bal. Gen. Bus. Posting Group",'');
                TestField("Bal. Gen. Prod. Posting Group",'');
                TestField("Bal. VAT Bus. Posting Group",'');
                TestField("Bal. VAT Prod. Posting Group",'');
                if (Amount > 0) and ("Bank Payment Type" = "bank payment type"::"Computer Check") then
                  TestField("Check Printed",true);
                if "Bank Payment Type" = "bank payment type"::"Electronic Payment" then begin
                  TestField("Check Exported",true);
                  TestField("Check Transmitted",true);
                end;
              end;
            "bal. account type"::"IC Partner":
              begin
                ICPartner.Get("Bal. Account No.");
                ICPartner.CheckICPartner;
                if GenJnlTemplate.Type <> GenJnlTemplate.Type::Intercompany then
                  FieldError("Bal. Account Type");
              end;
          end;
    end;


    procedure CheckSalesDocNoIsNotUsed(DocType: Option;DocNo: Code[20])
    var
        OldCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        OldCustLedgEntry.SetRange("Document No.",DocNo);
        OldCustLedgEntry.SetRange("Document Type",DocType);
        if OldCustLedgEntry.FindFirst then
          Error(SalesDocAlreadyExistsErr,OldCustLedgEntry."Document Type",DocNo);
    end;


    procedure CheckPurchDocNoIsNotUsed(DocType: Option;DocNo: Code[20])
    var
        OldVendLedgEntry: Record "Vendor Ledger Entry";
    begin
        OldVendLedgEntry.SetRange("Document No.",DocNo);
        OldVendLedgEntry.SetRange("Document Type",DocType);
        if OldVendLedgEntry.FindFirst then
          Error(PurchDocAlreadyExistsErr,OldVendLedgEntry."Document Type",DocNo);
    end;

    local procedure CheckDocType(GenJnlLine: Record "Gen. Journal Line")
    var
        IsPayment: Boolean;
    begin
        with GenJnlLine do
          if "Document Type" <> 0 then begin
            IsPayment := "Document Type" in ["document type"::Payment,"document type"::"Credit Memo"];
            if IsPayment xor (("Account Type" = "account type"::Customer) or IsVendorPaymentToCrMemo(GenJnlLine)) then
              ErrorIfNegativeAmt(GenJnlLine)
            else
              ErrorIfPositiveAmt(GenJnlLine);
          end;
    end;

    local procedure CheckBalDocType(GenJnlLine: Record "Gen. Journal Line")
    var
        IsPayment: Boolean;
    begin
        with GenJnlLine do
          if "Document Type" <> 0 then begin
            IsPayment := "Document Type" in ["document type"::Payment,"document type"::"Credit Memo"];
            if IsPayment = ("Bal. Account Type" = "bal. account type"::Customer) then
              ErrorIfNegativeAmt(GenJnlLine)
            else
              ErrorIfPositiveAmt(GenJnlLine);
          end;
    end;

    local procedure CheckICPartner(AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";AccountNo: Code[20];DocumentType: Option)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        ICPartner: Record "IC Partner";
    begin
        case AccountType of
          Accounttype::Customer:
            if Customer.Get(AccountNo) then begin
              Customer.CheckBlockedCustOnJnls(Customer,DocumentType,true);
              if (Customer."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                 ICPartner.Get(Customer."IC Partner Code")
              then
                ICPartner.CheckICPartnerIndirect(Format(AccountType),AccountNo);
            end;
          Accounttype::Vendor:
            if Vendor.Get(AccountNo) then begin
              Vendor.CheckBlockedVendOnJnls(Vendor,DocumentType,true);
              if (Vendor."IC Partner Code" <> '') and (GenJnlTemplate.Type = GenJnlTemplate.Type::Intercompany) and
                 ICPartner.Get(Vendor."IC Partner Code")
              then
                ICPartner.CheckICPartnerIndirect(Format(AccountType),AccountNo);
            end;
        end;
    end;

    local procedure CheckDimensions(GenJnlLine: Record "Gen. Journal Line")
    var
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        with GenJnlLine do begin
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            ThrowGenJnlLineError(GenJnlLine,Text011,DimMgt.GetDimCombErr);

          TableID[1] := DimMgt.TypeToTableID1("Account Type");
          No[1] := "Account No.";
          TableID[2] := DimMgt.TypeToTableID1("Bal. Account Type");
          No[2] := "Bal. Account No.";
          TableID[3] := Database::Job;
          No[3] := "Job No.";
          TableID[4] := Database::"Salesperson/Purchaser";
          No[4] := "Salespers./Purch. Code";
          TableID[5] := Database::Campaign;
          No[5] := "Campaign No.";
          if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
            ThrowGenJnlLineError(GenJnlLine,Text012,DimMgt.GetDimValuePostingErr);
        end;
    end;

    local procedure IsVendorPaymentToCrMemo(GenJournalLine: Record "Gen. Journal Line"): Boolean
    var
        GenJournalTemplate: Record "Gen. Journal Template";
    begin
        with GenJournalLine do begin
          if ("Account Type" = "account type"::Vendor) and
             ("Document Type" = "document type"::Payment) and
             ("Applies-to Doc. Type" = "applies-to doc. type"::"Credit Memo") and
             ("Applies-to Doc. No." <> '')
          then begin
            GenJournalTemplate.Get("Journal Template Name");
            exit(GenJournalTemplate.Type = GenJournalTemplate.Type::Payments);
          end;
          exit(false);
        end;
    end;

    local procedure ThrowGenJnlLineError(GenJournalLine: Record "Gen. Journal Line";ErrorTemplate: Text;ErrorText: Text)
    begin
        with GenJournalLine do
          if "Line No." <> 0 then
            Error(
              ErrorTemplate,
              TableCaption,"Journal Template Name","Journal Batch Name","Line No.",
              ErrorText);
        Error(ErrorText);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    begin
    end;
}

