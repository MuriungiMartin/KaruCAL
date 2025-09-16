#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 20 "Calc. and Post VAT Settlement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Calc. and Post VAT Settlement.rdlc';
    Caption = 'Calc. and Post Tax Settlement';
    Permissions = TableData "VAT Entry"=imd;
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("VAT Posting Setup";"VAT Posting Setup")
        {
            DataItemTableView = sorting("VAT Bus. Posting Group","VAT Prod. Posting Group");
            RequestFilterFields = "VAT Bus. Posting Group","VAT Prod. Posting Group";
            column(ReportForNavId_1756; 1756)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(PeriodVATDateFilter;StrSubstNo(Text005,VATDateFilter))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(PostSettlement;PostSettlement)
            {
            }
            column(PostingDate;Format(PostingDate))
            {
            }
            column(DocNo;DocNo)
            {
            }
            column(GLAccSettleNo;GLAccSettle."No.")
            {
            }
            column(UseAmtsInAddCurr;UseAmtsInAddCurr)
            {
            }
            column(PrintVATEntries;PrintVATEntries)
            {
            }
            column(VATPostingSetupCaption;TableCaption + ': ' + VATPostingSetupFilter)
            {
            }
            column(VATPostingSetupFilter;VATPostingSetupFilter)
            {
            }
            column(HeaderText;HeaderText)
            {
            }
            column(VATAmount;VATAmount)
            {
                AutoFormatExpression = GetCurrency;
                AutoFormatType = 1;
            }
            column(VATAmountAddCurr;VATAmountAddCurr)
            {
                AutoFormatExpression = GetCurrency;
                AutoFormatType = 1;
            }
            column(CalcandPostVATSettlementCaption;CalcandPostVATSettlementCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(TestReportnotpostedCaption;TestReportnotpostedCaptionLbl)
            {
            }
            column(DocNoCaption;DocNoCaptionLbl)
            {
            }
            column(SettlementAccCaption;SettlementAccCaptionLbl)
            {
            }
            column(DocumentTypeCaption;DocumentTypeCaptionLbl)
            {
            }
            column(UserIDCaption;UserIDCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(DocumentNoCaption;"VAT Entry".FieldCaption("Document No."))
            {
            }
            column(TypeCaption;"VAT Entry".FieldCaption(Type))
            {
            }
            column(BaseCaption;"VAT Entry".FieldCaption(Base))
            {
            }
            column(AmountCaption;"VAT Entry".FieldCaption(Amount))
            {
            }
            column(UnrealizedBaseCaption;"VAT Entry".FieldCaption("Unrealized Base"))
            {
            }
            column(UnrealizedAmountCaption;"VAT Entry".FieldCaption("Unrealized Amount"))
            {
            }
            column(VATCalculationCaption;"VAT Entry".FieldCaption("VAT Calculation Type"))
            {
            }
            column(BilltoPaytoNoCaption;"VAT Entry".FieldCaption("Bill-to/Pay-to No."))
            {
            }
            column(EntryNoCaption;"VAT Entry".FieldCaption("Entry No."))
            {
            }
            column(PostingDateCaption;PostingDateCaptionLbl)
            {
            }
            dataitem("Closing G/L and VAT Entry";"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_8188; 8188)
                {
                }
                column(VATBusPstGr_VATPostSetup;"VAT Posting Setup"."VAT Bus. Posting Group")
                {
                }
                column(VATPrdPstGr_VATPostSetup;"VAT Posting Setup"."VAT Prod. Posting Group")
                {
                }
                column(VATEntryGetFilterType;VATEntry.GetFilter(Type))
                {
                }
                column(VATEntryGetFiltTaxJurisCd;VATEntry.GetFilter("Tax Jurisdiction Code"))
                {
                }
                column(VATEntryGetFilterUseTax;VATEntry.GetFilter("Use Tax"))
                {
                }
                dataitem("VAT Entry";"VAT Entry")
                {
                    DataItemTableView = sorting(Type,Closed) where(Closed=const(false),Type=filter(Purchase|Sale));
                    column(ReportForNavId_7612; 7612)
                    {
                    }
                    column(PostingDate_VATEntry;Format("Posting Date"))
                    {
                    }
                    column(DocumentNo_VATEntry;"Document No.")
                    {
                        IncludeCaption = false;
                    }
                    column(DocumentType_VATEntry;"Document Type")
                    {
                    }
                    column(Type_VATEntry;Type)
                    {
                        IncludeCaption = false;
                    }
                    column(Base_VATEntry;Base)
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(Amount_VATEntry;Amount)
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(VATCalcType_VATEntry;"VAT Calculation Type")
                    {
                    }
                    column(BilltoPaytoNo_VATEntry;"Bill-to/Pay-to No.")
                    {
                    }
                    column(EntryNo_VATEntry;"Entry No.")
                    {
                    }
                    column(UserID_VATEntry;"User ID")
                    {
                    }
                    column(UnrealizedAmount_VATEntry;"Unrealized Amount")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(UnrealizedBase_VATEntry;"Unrealized Base")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(AddCurrUnrlzdAmt_VATEntry;"Add.-Currency Unrealized Amt.")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(AddCurrUnrlzdBas_VATEntry;"Add.-Currency Unrealized Base")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(AdditionlCurrAmt_VATEntry;"Additional-Currency Amount")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(AdditinlCurrBase_VATEntry;"Additional-Currency Base")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if not PrintVATEntries then
                          CurrReport.Skip;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CopyFilters(VATEntry);
                    end;
                }
                dataitem("Close VAT Entries";"Integer")
                {
                    DataItemTableView = sorting(Number);
                    MaxIteration = 1;
                    column(ReportForNavId_3370; 3370)
                    {
                    }
                    column(PostingDate1;Format(PostingDate))
                    {
                    }
                    column(GenJnlLineDocumentNo;GenJnlLine."Document No.")
                    {
                    }
                    column(GenJnlLineVATBaseAmount;GenJnlLine."VAT Base Amount")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(GenJnlLineVATAmount;GenJnlLine."VAT Amount")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(GenJnlLnVATCalcType;Format(GenJnlLine."VAT Calculation Type"))
                    {
                    }
                    column(NextVATEntryNo;NextVATEntryNo)
                    {
                    }
                    column(GenJnlLnSrcCurrVATAmount;GenJnlLine."Source Curr. VAT Amount")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(GenJnlLnSrcCurrVATBaseAmt;GenJnlLine."Source Curr. VAT Base Amount")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(GenJnlLine2Amount;GenJnlLine2.Amount)
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(GenJnlLine2DocumentNo;GenJnlLine2."Document No.")
                    {
                    }
                    column(ReversingEntry;ReversingEntry)
                    {
                    }
                    column(GenJnlLn2SrcCurrencyAmt;GenJnlLine2."Source Currency Amount")
                    {
                        AutoFormatExpression = GetCurrency;
                        AutoFormatType = 1;
                    }
                    column(SettlementCaption;SettlementCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        // Calculate amount and base
                        VATEntry.CalcSums(
                          Base,Amount,
                          "Additional-Currency Base","Additional-Currency Amount");

                        ReversingEntry := false;
                        // Balancing entries to VAT accounts
                        Clear(GenJnlLine);
                        GenJnlLine."System-Created Entry" := true;
                        GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";
                        case VATType of
                          VATEntry.Type::Purchase:
                            GenJnlLine.Description :=
                              DelChr(
                                StrSubstNo(
                                  Text007,
                                  "VAT Posting Setup"."VAT Bus. Posting Group",
                                  "VAT Posting Setup"."VAT Prod. Posting Group"),
                                '>');
                          VATEntry.Type::Sale:
                            GenJnlLine.Description :=
                              DelChr(
                                StrSubstNo(
                                  Text008,
                                  "VAT Posting Setup"."VAT Bus. Posting Group",
                                  "VAT Posting Setup"."VAT Prod. Posting Group"),
                                '>');
                        end;
                        GenJnlLine."VAT Bus. Posting Group" := "VAT Posting Setup"."VAT Bus. Posting Group";
                        GenJnlLine."VAT Prod. Posting Group" := "VAT Posting Setup"."VAT Prod. Posting Group";
                        GenJnlLine."VAT Calculation Type" := "VAT Posting Setup"."VAT Calculation Type";
                        GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::Settlement;
                        GenJnlLine."Posting Date" := PostingDate;
                        GenJnlLine."Document Type" := 0;
                        GenJnlLine."Document No." := DocNo;
                        GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                        GenJnlLine."VAT Posting" := GenJnlLine."vat posting"::"Manual VAT Entry";
                        case "VAT Posting Setup"."VAT Calculation Type" of
                          "VAT Posting Setup"."vat calculation type"::"Normal VAT",
                          "VAT Posting Setup"."vat calculation type"::"Full VAT":
                            begin
                              case VATType of
                                VATEntry.Type::Purchase:
                                  begin
                                    "VAT Posting Setup".TestField("Purchase VAT Account");
                                    GenJnlLine."Account No." := "VAT Posting Setup"."Purchase VAT Account";
                                  end;
                                VATEntry.Type::Sale:
                                  begin
                                    "VAT Posting Setup".TestField("Sales VAT Account");
                                    GenJnlLine."Account No." := "VAT Posting Setup"."Sales VAT Account";
                                  end;
                              end;
                              CopyAmounts(GenJnlLine,VATEntry);
                              if PostSettlement then
                                PostGenJnlLine(GenJnlLine);
                              VATAmount := VATAmount + VATEntry.Amount;
                              VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                            end;
                          "VAT Posting Setup"."vat calculation type"::"Reverse Charge VAT":
                            case VATType of
                              VATEntry.Type::Purchase:
                                begin
                                  "VAT Posting Setup".TestField("Purchase VAT Account");
                                  GenJnlLine."Account No." := "VAT Posting Setup"."Purchase VAT Account";
                                  CopyAmounts(GenJnlLine,VATEntry);
                                  if PostSettlement then
                                    PostGenJnlLine(GenJnlLine);

                                  "VAT Posting Setup".TestField("Reverse Chrg. VAT Acc.");
                                  CreateGenJnlLine(GenJnlLine2,"VAT Posting Setup"."Reverse Chrg. VAT Acc.");
                                  if PostSettlement then
                                    PostGenJnlLine(GenJnlLine2);
                                  ReversingEntry := true;
                                end;
                              VATEntry.Type::Sale:
                                begin
                                  "VAT Posting Setup".TestField("Sales VAT Account");
                                  GenJnlLine."Account No." := "VAT Posting Setup"."Sales VAT Account";
                                  CopyAmounts(GenJnlLine,VATEntry);
                                  if PostSettlement then
                                    PostGenJnlLine(GenJnlLine);
                                end;
                            end;
                          "VAT Posting Setup"."vat calculation type"::"Sales Tax":
                            begin
                              TaxJurisdiction.Get(VATEntry."Tax Jurisdiction Code");
                              GenJnlLine."Tax Area Code" := TaxJurisdiction.Code;
                              GenJnlLine."Use Tax" := VATEntry."Use Tax";
                              case VATType of
                                VATEntry.Type::Purchase:
                                  if VATEntry."Use Tax" then begin
                                    TaxJurisdiction.TestField("Tax Account (Purchases)");
                                    GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                                    CopyAmounts(GenJnlLine,VATEntry);
                                    if PostSettlement then
                                      PostGenJnlLine(GenJnlLine);

                                    TaxJurisdiction.TestField("Reverse Charge (Purchases)");
                                    CreateGenJnlLine(GenJnlLine2,TaxJurisdiction."Reverse Charge (Purchases)");
                                    GenJnlLine2."Tax Area Code" := TaxJurisdiction.Code;
                                    GenJnlLine2."Use Tax" := VATEntry."Use Tax";
                                    if PostSettlement then
                                      PostGenJnlLine(GenJnlLine2);
                                    ReversingEntry := true;
                                  end else begin
                                    TaxJurisdiction.TestField("Tax Account (Purchases)");
                                    GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Purchases)";
                                    CopyAmounts(GenJnlLine,VATEntry);
                                    if PostSettlement then
                                      PostGenJnlLine(GenJnlLine);
                                    VATAmount := VATAmount + VATEntry.Amount;
                                    VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                  end;
                                VATEntry.Type::Sale:
                                  begin
                                    TaxJurisdiction.TestField("Tax Account (Sales)");
                                    GenJnlLine."Account No." := TaxJurisdiction."Tax Account (Sales)";
                                    CopyAmounts(GenJnlLine,VATEntry);
                                    if PostSettlement then
                                      PostGenJnlLine(GenJnlLine);
                                    VATAmount := VATAmount + VATEntry.Amount;
                                    VATAmountAddCurr := VATAmountAddCurr + VATEntry."Additional-Currency Amount";
                                  end;
                              end;
                            end;
                        end;
                        NextVATEntryNo := NextVATEntryNo + 1;

                        // Close current VAT entries
                        if PostSettlement then begin
                          VATEntry.ModifyAll("Closed by Entry No.",NextVATEntryNo);
                          VATEntry.ModifyAll(Closed,true);
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    VATEntry.Reset;
                    if not
                       VATEntry.SetCurrentkey(
                         Type,Closed,"VAT Bus. Posting Group","VAT Prod. Posting Group","Posting Date")
                    then
                      VATEntry.SetCurrentkey(
                        Type,Closed,"Tax Jurisdiction Code","Use Tax","Posting Date");
                    VATEntry.SetRange(Type,VATType);
                    VATEntry.SetRange(Closed,false);
                    VATEntry.SetFilter("Posting Date",VATDateFilter);
                    VATEntry.SetRange("VAT Bus. Posting Group","VAT Posting Setup"."VAT Bus. Posting Group");
                    VATEntry.SetRange("VAT Prod. Posting Group","VAT Posting Setup"."VAT Prod. Posting Group");

                    case "VAT Posting Setup"."VAT Calculation Type" of
                      "VAT Posting Setup"."vat calculation type"::"Normal VAT",
                      "VAT Posting Setup"."vat calculation type"::"Reverse Charge VAT",
                      "VAT Posting Setup"."vat calculation type"::"Full VAT":
                        begin
                          if FindFirstEntry then begin
                            if not VATEntry.Find('-') then
                              repeat
                                VATType := VATType + 1;
                                VATEntry.SetRange(Type,VATType);
                              until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                            FindFirstEntry := false;
                          end else begin
                            if VATEntry.Next = 0 then
                              repeat
                                VATType := VATType + 1;
                                VATEntry.SetRange(Type,VATType);
                              until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                          end;
                          if VATType < VATEntry.Type::Settlement then
                            VATEntry.Find('+');
                        end;
                      "VAT Posting Setup"."vat calculation type"::"Sales Tax":
                        begin
                          if FindFirstEntry then begin
                            if not VATEntry.Find('-') then
                              repeat
                                VATType := VATType + 1;
                                VATEntry.SetRange(Type,VATType);
                              until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                            FindFirstEntry := false;
                          end else begin
                            VATEntry.SetRange("Tax Jurisdiction Code");
                            VATEntry.SetRange("Use Tax");
                            if VATEntry.Next = 0 then
                              repeat
                                VATType := VATType + 1;
                                VATEntry.SetRange(Type,VATType);
                              until (VATType = VATEntry.Type::Settlement) or VATEntry.Find('-');
                          end;
                          if VATType < VATEntry.Type::Settlement then begin
                            VATEntry.SetRange("Tax Jurisdiction Code",VATEntry."Tax Jurisdiction Code");
                            VATEntry.SetRange("Use Tax",VATEntry."Use Tax");
                            VATEntry.Find('+');
                          end;
                        end;
                    end;

                    if VATType = VATEntry.Type::Settlement then
                      CurrReport.Break;
                end;

                trigger OnPreDataItem()
                begin
                    VATType := VATEntry.Type::Purchase;
                    FindFirstEntry := true;
                end;
            }

            trigger OnPostDataItem()
            begin
                // Post to settlement account
                if VATAmount <> 0 then begin
                  GenJnlLine.Init;
                  GenJnlLine."System-Created Entry" := true;
                  GenJnlLine."Account Type" := GenJnlLine."account type"::"G/L Account";

                  GLAccSettle.TestField("Gen. Posting Type",GenJnlLine."gen. posting type"::" ");
                  GLAccSettle.TestField("VAT Bus. Posting Group",'');
                  GLAccSettle.TestField("VAT Prod. Posting Group",'');
                  if VATPostingSetup.Get(GLAccSettle."VAT Bus. Posting Group",GLAccSettle."VAT Prod. Posting Group") then
                    VATPostingSetup.TestField("VAT %",0);
                  GLAccSettle.TestField("Gen. Bus. Posting Group",'');
                  GLAccSettle.TestField("Gen. Prod. Posting Group",'');

                  GenJnlLine.Validate("Account No.",GLAccSettle."No.");
                  GenJnlLine."Posting Date" := PostingDate;
                  GenJnlLine."Document Type" := 0;
                  GenJnlLine."Document No." := DocNo;
                  GenJnlLine.Description := Text004;
                  GenJnlLine.Amount := VATAmount;
                  GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
                  GenJnlLine."Source Currency Amount" := VATAmountAddCurr;
                  GenJnlLine."Source Code" := SourceCodeSetup."VAT Settlement";
                  GenJnlLine."VAT Posting" := GenJnlLine."vat posting"::"Manual VAT Entry";
                  if PostSettlement then
                    PostGenJnlLine(GenJnlLine);
                end;
            end;

            trigger OnPreDataItem()
            begin
                GLEntry.LockTable; // Avoid deadlock with function 12
                if GLEntry.FindLast then;
                VATEntry.LockTable;
                VATEntry.Reset;
                if VATEntry.Find('+') then
                  NextVATEntryNo := VATEntry."Entry No.";

                SourceCodeSetup.Get;
                GLSetup.Get;
                VATAmount := 0;
                VATAmountAddCurr := 0;

                if UseAmtsInAddCurr then
                  HeaderText := StrSubstNo(Text006,GLSetup."Additional Reporting Currency")
                else begin
                  GLSetup.TestField("LCY Code");
                  HeaderText := StrSubstNo(Text006,GLSetup."LCY Code");
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;
        ShowFilter = false;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(StartingDate;EntrdStartDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndDateReq;EndDateReq)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(PostingDt;PostingDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Posting Date';
                        ToolTip = 'Specifies the date for the posting of this batch job. By default, the  working date is entered, but you can change it.';
                    }
                    field(DocumentNo;DocNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Document No.';
                        ToolTip = 'Specifies the number of the document that is processed by the report or batch job.';
                    }
                    field(SettlementAcc;GLAccSettle."No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Settlement Account';
                        TableRelation = "G/L Account";
                        ToolTip = 'Specifies the G/L account that the Tax settlement is posted to.';

                        trigger OnValidate()
                        begin
                            if GLAccSettle."No." <> '' then begin
                              GLAccSettle.Find;
                              GLAccSettle.CheckGLAcc;
                            end;
                        end;
                    }
                    field(ShowVATEntries;PrintVATEntries)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Tax Entries';
                        ToolTip = 'Specifies that the individual Tax entries are included in the report.';
                    }
                    field(Post;PostSettlement)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Post';
                        ToolTip = 'Specifies that the Tax settlement will be posted to the general ledger when you run the batch job.';
                    }
                    field(AmtsinAddReportingCurr;UseAmtsInAddCurr)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Show Amounts in Add. Reporting Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if the reported amounts are shown in the additional reporting currency.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if PostingDate = 0D then
          Error(Text000);
        if DocNo = '' then
          Error(Text001);
        if GLAccSettle."No." = '' then
          Error(Text002);
        GLAccSettle.Find;

        if PostSettlement and not Initialized then
          if not Confirm(Text003,false) then
            CurrReport.Quit;

        VATPostingSetupFilter := "VAT Posting Setup".GetFilters;
        if EndDateReq = 0D then
          VATEntry.SetFilter("Posting Date",'%1..',EntrdStartDate)
        else
          VATEntry.SetRange("Posting Date",EntrdStartDate,EndDateReq);
        VATDateFilter := VATEntry.GetFilter("Posting Date");
        Clear(GenJnlPostLine);
    end;

    var
        Text000: label 'Enter the posting date.';
        Text001: label 'Enter the document no.';
        Text002: label 'Enter the settlement account.';
        Text003: label 'Do you want to calculate and post the VAT Settlement?';
        Text004: label 'VAT Settlement';
        Text005: label 'Period: %1';
        Text006: label 'All amounts are in %1.';
        Text007: label 'Purchase VAT settlement: #1######## #2########';
        Text008: label 'Sales VAT settlement  :  #1######## #2########';
        GLAccSettle: Record "G/L Account";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        GLEntry: Record "G/L Entry";
        VATEntry: Record "VAT Entry";
        TaxJurisdiction: Record "Tax Jurisdiction";
        GLSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        EntrdStartDate: Date;
        EndDateReq: Date;
        PrintVATEntries: Boolean;
        NextVATEntryNo: Integer;
        PostingDate: Date;
        DocNo: Code[20];
        VATType: Integer;
        VATAmount: Decimal;
        VATAmountAddCurr: Decimal;
        PostSettlement: Boolean;
        FindFirstEntry: Boolean;
        ReversingEntry: Boolean;
        Initialized: Boolean;
        VATPostingSetupFilter: Text;
        VATDateFilter: Text;
        UseAmtsInAddCurr: Boolean;
        HeaderText: Text[30];
        CalcandPostVATSettlementCaptionLbl: label 'Calc. and Post Tax Settlement';
        PageCaptionLbl: label 'Page';
        TestReportnotpostedCaptionLbl: label 'Test Report (Not Posted)';
        DocNoCaptionLbl: label 'Document No.';
        SettlementAccCaptionLbl: label 'Settlement Account';
        DocumentTypeCaptionLbl: label 'Document Type';
        UserIDCaptionLbl: label 'User ID';
        TotalCaptionLbl: label 'Total';
        PostingDateCaptionLbl: label 'Posting Date';
        SettlementCaptionLbl: label 'Settlement';


    procedure InitializeRequest(NewStartDate: Date;NewEndDate: Date;NewPostingDate: Date;NewDocNo: Code[20];NewSettlementAcc: Code[20];ShowVATEntries: Boolean;Post: Boolean)
    begin
        EntrdStartDate := NewStartDate;
        EndDateReq := NewEndDate;
        PostingDate := NewPostingDate;
        DocNo := NewDocNo;
        GLAccSettle."No." := NewSettlementAcc;
        PrintVATEntries := ShowVATEntries;
        PostSettlement := Post;
        Initialized := true;
    end;


    procedure InitializeRequest2(NewUseAmtsInAddCurr: Boolean)
    begin
        UseAmtsInAddCurr := NewUseAmtsInAddCurr;
    end;

    local procedure GetCurrency(): Code[10]
    begin
        if UseAmtsInAddCurr then
          exit(GLSetup."Additional Reporting Currency");

        exit('');
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line")
    var
        DimMgt: Codeunit DimensionManagement;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
    begin
        TableID[1] := Database::"G/L Account";
        TableID[2] := Database::"G/L Account";
        No[1] := GenJnlLine."Account No.";
        No[2] := GenJnlLine."Bal. Account No.";
        GenJnlLine."Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,GenJnlLine."Source Code",
            GenJnlLine."Shortcut Dimension 1 Code",GenJnlLine."Shortcut Dimension 2 Code",0,0);
        GenJnlPostLine.Run(GenJnlLine);
    end;


    procedure SetInitialized(Initialize: Boolean)
    begin
        Initialized := Initialize;
    end;

    local procedure CopyAmounts(var GenJournalLine: Record "Gen. Journal Line";VATEntry: Record "VAT Entry")
    begin
        with GenJournalLine do begin
          Amount := -VATEntry.Amount;
          "VAT Amount" := -VATEntry.Amount;
          "VAT Base Amount" := -VATEntry.Base;
          "Source Currency Code" := GLSetup."Additional Reporting Currency";
          "Source Currency Amount" := -VATEntry."Additional-Currency Amount";
          "Source Curr. VAT Amount" := -VATEntry."Additional-Currency Amount";
          "Source Curr. VAT Base Amount" := -VATEntry."Additional-Currency Base";
        end;
    end;

    local procedure CreateGenJnlLine(var GenJnlLine2: Record "Gen. Journal Line";AccountNo: Code[20])
    begin
        Clear(GenJnlLine2);
        GenJnlLine2."System-Created Entry" := true;
        GenJnlLine2."Account Type" := GenJnlLine2."account type"::"G/L Account";
        GenJnlLine2.Description := GenJnlLine.Description;
        GenJnlLine2."Posting Date" := PostingDate;
        GenJnlLine2."Document Type" := 0;
        GenJnlLine2."Document No." := DocNo;
        GenJnlLine2."Source Code" := SourceCodeSetup."VAT Settlement";
        GenJnlLine2."VAT Posting" := GenJnlLine2."vat posting"::"Manual VAT Entry";
        GenJnlLine2."Account No." := AccountNo;
        GenJnlLine2.Amount := VATEntry.Amount;
        GenJnlLine2."Source Currency Code" := GLSetup."Additional Reporting Currency";
        GenJnlLine2."Source Currency Amount" := VATEntry."Additional-Currency Amount";
    end;
}

