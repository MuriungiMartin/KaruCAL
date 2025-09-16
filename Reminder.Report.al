#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 117 Reminder
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Reminder.rdlc';
    Caption = 'Reminder';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Issued Reminder Header";"Issued Reminder Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Reminder';
            column(ReportForNavId_5612; 5612)
            {
            }
            column(No_IssuedReminderHeader;"No.")
            {
            }
            column(CompanyInfoHomePageCaption;CompanyInfoHomePageCaptionLbl)
            {
            }
            column(CompanyInfoEmailCaption;CompanyInfoEmailCaptionLbl)
            {
            }
            column(DocDateCaption;DocDateCaptionLbl)
            {
            }
            column(VATAmtCaption;VATAmtCaptionLbl)
            {
            }
            column(AmtInclVATCaption;AmtInclVATCaptionLbl)
            {
            }
            column(VATBaseCaption;VATBaseCaptionLbl)
            {
            }
            column(VATPercentageCaption;VATPercentageCaptionLbl)
            {
            }
            column(VATAmtSpecificationCaption;VATAmtSpecificationCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(DueDate_IssuedReminderHeader;Format("Issued Reminder Header"."Due Date"))
                {
                }
                column(PostingDate_IssuedReminderHeader;Format("Issued Reminder Header"."Posting Date"))
                {
                }
                column(No1_IssuedReminderHeader;"Issued Reminder Header"."No.")
                {
                }
                column(YourReference_IssuedReminderHeader;"Issued Reminder Header"."Your Reference")
                {
                }
                column(ReferenceTxt;ReferenceText)
                {
                }
                column(VATRegNo_IssuedReminderHeader;"Issued Reminder Header"."VAT Registration No.")
                {
                }
                column(VATNoTxt;VATNoText)
                {
                }
                column(DocDate_IssuedReminderHeader;Format("Issued Reminder Header"."Document Date"))
                {
                }
                column(CustNo_IssuedReminderHeader;"Issued Reminder Header"."Customer No.")
                {
                }
                column(CompanyInfoBankAccNo;CompanyInfo."Bank Account No.")
                {
                }
                column(CompanyInfo1Picture;CompanyInfo1.Picture)
                {
                }
                column(CompanyInfo2Picture;CompanyInfo2.Picture)
                {
                }
                column(CompanyInfo3Picture;CompanyInfo3.Picture)
                {
                }
                column(CompanyInfoHomePage;CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoEmail;CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoBankName;CompanyInfo."Bank Name")
                {
                }
                column(CompanyInfoGiroNo;CompanyInfo."Giro No.")
                {
                }
                column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
                {
                }
                column(CustAddr8;CustAddr[8])
                {
                }
                column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                {
                }
                column(CustAddr7;CustAddr[7])
                {
                }
                column(CustAddr6;CustAddr[6])
                {
                }
                column(CompanyAddr6;CompanyAddr[6])
                {
                }
                column(CustAddr5;CustAddr[5])
                {
                }
                column(CompanyAddr5;CompanyAddr[5])
                {
                }
                column(CustAddr4;CustAddr[4])
                {
                }
                column(CompanyAddr4;CompanyAddr[4])
                {
                }
                column(CustAddr3;CustAddr[3])
                {
                }
                column(CompanyAddr3;CompanyAddr[3])
                {
                }
                column(CustAddr2;CustAddr[2])
                {
                }
                column(CompanyAddr2;CompanyAddr[2])
                {
                }
                column(CustAddr1;CustAddr[1])
                {
                }
                column(CompanyAddr1;CompanyAddr[1])
                {
                }
                column(TxtPage;TxtPageLbl)
                {
                }
                column(CustTaxIdentificationType;Format(Cust."Tax Identification Type"))
                {
                }
                column(DueDateCaption;DueDateCaptionLbl)
                {
                }
                column(PostingDateCaption;PostingDateCaptionLbl)
                {
                }
                column(ReminderNoCaption;ReminderNoCaptionLbl)
                {
                }
                column(CompanyInfoBankAccNoCaption;CompanyInfoBankAccNoCaptionLbl)
                {
                }
                column(CompanyInfoBankNameCaption;CompanyInfoBankNameCaptionLbl)
                {
                }
                column(CompanyInfoGiroNoCaption;CompanyInfoGiroNoCaptionLbl)
                {
                }
                column(CompanyInfoVATRegNoCaption;CompanyInfoVATRegNoCaptionLbl)
                {
                }
                column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                {
                }
                column(ReminderCaption;ReminderCaptionLbl)
                {
                }
                column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                {
                }
                column(CustNo_IssuedReminderHeaderCaption;"Issued Reminder Header".FieldCaption("Customer No."))
                {
                }
                dataitem(DimensionLoop;"Integer")
                {
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    column(ReportForNavId_9775; 9775)
                    {
                    }
                    column(DimText_DimensionLoop;DimText)
                    {
                    }
                    column(No;Number)
                    {
                    }
                    column(HdrDimensionsCaption;HdrDimensionsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                          if not DimSetEntry.FindSet then
                            CurrReport.Break;
                        end else
                          if not Continue then
                            CurrReport.Break;

                        Clear(DimText);
                        Continue := false;
                        repeat
                          OldDimText := DimText;
                          if DimText = '' then
                            DimText := StrSubstNo('%1 - %2',DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code")
                          else
                            DimText :=
                              StrSubstNo(
                                '%1; %2 - %3',DimText,
                                DimSetEntry."Dimension Code",DimSetEntry."Dimension Value Code");
                          if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                            DimText := OldDimText;
                            Continue := true;
                            exit;
                          end;
                        until DimSetEntry.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowInternalInfo then
                          CurrReport.Break;
                    end;
                }
                dataitem("Issued Reminder Line";"Issued Reminder Line")
                {
                    DataItemLink = "Reminder No."=field("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = sorting("Reminder No.","Line No.");
                    column(ReportForNavId_8784; 8784)
                    {
                    }
                    column(RemainingAmt_IssuedReminderLine;"Remaining Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(Desc_IssuedReminderLine;Description)
                    {
                    }
                    column(Type;Format("Issued Reminder Line".Type,0,2))
                    {
                    }
                    column(DocDate_IssuedReminderLine;Format("Document Date"))
                    {
                    }
                    column(DocNo_IssuedReminderLine;"Document No.")
                    {
                    }
                    column(DocNoCaption_IssuedReminderLine;FieldCaption("Document No."))
                    {
                    }
                    column(DueDate_IssuedReminderLine;Format("Due Date"))
                    {
                    }
                    column(OriginalAmt_IssuedReminderLine;"Original Amount")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(DocumentType_IssuedReminderLine;"Document Type")
                    {
                    }
                    column(No_IssuedReminderLine;"No.")
                    {
                    }
                    column(ShowInternalInfo;ShowInternalInfo)
                    {
                    }
                    column(NNCInterestAmt;NNC_InterestAmount)
                    {
                    }
                    column(TotalTxt;TotalText)
                    {
                    }
                    column(NNCTotal;NNC_Total)
                    {
                    }
                    column(TotalInclVATTxt;TotalInclVATText)
                    {
                    }
                    column(NNCVATAmt;NNC_VATAmount)
                    {
                    }
                    column(NNCTotalInclVAT;NNC_TotalInclVAT)
                    {
                    }
                    column(TotalVATAmt;TotalVATAmount)
                    {
                    }
                    column(ReminderNo_IssuedReminderLine;"Reminder No.")
                    {
                    }
                    column(InterestAmtCaption;InterestAmtCaptionLbl)
                    {
                    }
                    column(RemainingAmt_IssuedReminderLineCaption;FieldCaption("Remaining Amount"))
                    {
                    }
                    column(DocNo_IssuedReminderLineCaption;FieldCaption("Document No."))
                    {
                    }
                    column(OriginalAmt_IssuedReminderLineCaption;FieldCaption("Original Amount"))
                    {
                    }
                    column(DocumentType_IssuedReminderLineCaption;FieldCaption("Document Type"))
                    {
                    }
                    column(Interest;Interest)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.Init;
                        VATAmountLine."VAT Identifier" := "VAT Identifier";
                        VATAmountLine."VAT Calculation Type" := "VAT Calculation Type";
                        VATAmountLine."Tax Group Code" := "Tax Group Code";
                        VATAmountLine."VAT %" := "VAT %";
                        VATAmountLine."VAT Base" := Amount;
                        VATAmountLine."VAT Amount" := "VAT Amount";
                        VATAmountLine."Amount Including VAT" := Amount + "VAT Amount";
                        VATAmountLine.InsertLine;

                        case Type of
                          Type::"G/L Account":
                            "Remaining Amount" := Amount;
                          Type::"Line Fee":
                            "Remaining Amount" := Amount;
                          Type::"Customer Ledger Entry":
                            ReminderInterestAmount := Amount;
                        end;

                        NNC_InterestAmountTotal += ReminderInterestAmount;
                        NNC_RemainingAmountTotal += "Remaining Amount";
                        NNC_VATAmountTotal += "VAT Amount";

                        NNC_InterestAmount := (NNC_InterestAmountTotal + NNC_VATAmountTotal + "Issued Reminder Header"."Additional Fee" -
                                               AddFeeInclVAT + "Issued Reminder Header"."Add. Fee per Line" - AddFeePerLineInclVAT) /
                          (VATInterest / 100 + 1);
                        NNC_Total := NNC_RemainingAmountTotal + NNC_InterestAmountTotal;
                        NNC_VATAmount := NNC_VATAmountTotal;
                        NNC_TotalInclVAT := NNC_RemainingAmountTotal + NNC_InterestAmountTotal + NNC_VATAmountTotal;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if FindLast then begin
                          EndLineNo := "Line No." + 1;
                          repeat
                            Continue :=
                              not ShowNotDueAmounts and
                              ("No. of Reminders" = 0) and ((Type = Type::"Customer Ledger Entry") or (Type = Type::"Line Fee")) or (Type = Type::" ");
                            if Continue then
                              EndLineNo := "Line No.";
                          until (Next(-1) = 0) or not Continue;
                        end;

                        VATAmountLine.DeleteAll;
                        SetFilter("Line No.",'<%1',EndLineNo);
                        CurrReport.CreateTotals("Remaining Amount","VAT Amount",ReminderInterestAmount);
                    end;
                }
                dataitem(IssuedReminderLine2;"Issued Reminder Line")
                {
                    DataItemLink = "Reminder No."=field("No.");
                    DataItemLinkReference = "Issued Reminder Header";
                    DataItemTableView = sorting("Reminder No.","Line No.");
                    column(ReportForNavId_9207; 9207)
                    {
                    }
                    column(Desc_IssuedReminderLine2;Description)
                    {
                    }
                    column(LineNo_IssuedReminderLine2;"Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Line No.",'>=%1',EndLineNo);
                        if not ShowNotDueAmounts then begin
                          SetFilter(Type,'<>%1',Type::" ");
                          if FindFirst then
                            if "Line No." > EndLineNo then begin
                              SetRange(Type);
                              SetRange("Line No.",EndLineNo,"Line No." - 1); // find "Open Entries Not Due" line
                              if FindLast then
                                SetRange("Line No.",EndLineNo,"Line No." - 1);
                            end;
                          SetRange(Type);
                        end;
                    end;
                }
                dataitem(VATCounter;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_6558; 6558)
                    {
                    }
                    column(VATAmtLineAmtInclVAT;VATAmountLine."Amount Including VAT")
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATAmt;VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATBase;VALVATBase)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseVALVATAmt;VALVATBase + VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Reminder Line".GetCurrencyCodeFromHeader;
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVAT_VATCounter;VATAmountLine."VAT %")
                    {
                    }
                    column(VALVATBaseCaption;VALVATBaseCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(Number);
                        VALVATBase := VATAmountLine."Amount Including VAT" / (1 + VATAmountLine."VAT %" / 100);
                        VALVATAmount := VATAmountLine."Amount Including VAT" - VALVATBase;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if VATAmountLine.GetTotalVATAmount = 0 then
                          CurrReport.Break;

                        SetRange(Number,1,VATAmountLine.Count);

                        VALVATBase := 0;
                        VALVATAmount := 0;
                    end;
                }
                dataitem(VATCounterLCY;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_2038; 2038)
                    {
                    }
                    column(VALExchRate;VALExchRate)
                    {
                    }
                    column(VALSpecLCYHeader;VALSpecLCYHeader)
                    {
                    }
                    column(VALVATAmtLCY;VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseLCY;VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVAT_VATCounterLCY;VATAmountLine."VAT %")
                    {
                        DecimalPlaces = 0:5;
                    }
                    column(VALVATBaseLCYCaption;VALVATBaseLCYCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(Number);

                        VALVATBaseLCY := ROUND(VATAmountLine."Amount Including VAT" / (1 + VATAmountLine."VAT %" / 100) / CurrFactor);
                        VALVATAmountLCY := ROUND(VATAmountLine."Amount Including VAT" / CurrFactor - VALVATBaseLCY);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if (not GLSetup."Print VAT specification in LCY") or
                           ("Issued Reminder Header"."Currency Code" = '') or
                           (VATAmountLine.GetTotalVATAmount = 0)
                        then
                          CurrReport.Break;

                        SetRange(Number,1,VATAmountLine.Count);

                        VALVATBaseLCY := 0;
                        VALVATAmountLCY := 0;

                        if GLSetup."LCY Code" = '' then
                          VALSpecLCYHeader := Text011 + Text012
                        else
                          VALSpecLCYHeader := Text011 + Format(GLSetup."LCY Code");

                        CurrExchRate.FindCurrency("Issued Reminder Header"."Posting Date","Issued Reminder Header"."Currency Code",1);
                        CustEntry.SetRange("Customer No.","Issued Reminder Header"."Customer No.");
                        CustEntry.SetRange("Document Type",CustEntry."document type"::Reminder);
                        CustEntry.SetRange("Document No.","Issued Reminder Header"."No.");
                        if CustEntry.FindFirst then begin
                          CustEntry.CalcFields("Amount (LCY)",Amount);
                          CurrFactor := 1 / (CustEntry."Amount (LCY)" / CustEntry.Amount);
                          VALExchRate := StrSubstNo(Text013,ROUND(1 / CurrFactor * 100,0.000001),CurrExchRate."Exchange Rate Amount");
                        end else begin
                          CurrFactor := CurrExchRate.ExchangeRate("Issued Reminder Header"."Posting Date","Issued Reminder Header"."Currency Code");
                          VALExchRate := StrSubstNo(Text013,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
                        end;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                GLAcc: Record "G/L Account";
                CustPostingGroup: Record "Customer Posting Group";
                VATPostingSetup: Record "VAT Posting Setup";
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                DimSetEntry.SetRange("Dimension Set ID","Dimension Set ID");

                FormatAddr.IssuedReminder(CustAddr,"Issued Reminder Header");
                if not Cust.Get("Customer No.") then
                  Clear(Cust);

                if "Your Reference" = '' then
                  ReferenceText := ''
                else
                  ReferenceText := FieldCaption("Your Reference");
                if "VAT Registration No." = '' then
                  VATNoText := ''
                else
                  VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                  GLSetup.TestField("LCY Code");
                  TotalText := StrSubstNo(Text000,GLSetup."LCY Code");
                  TotalInclVATText := StrSubstNo(Text001,GLSetup."LCY Code");
                end else begin
                  TotalText := StrSubstNo(Text000,"Currency Code");
                  TotalInclVATText := StrSubstNo(Text001,"Currency Code");
                end;
                CurrReport.PageNo := 1;
                if not CurrReport.Preview then begin
                  if LogInteraction then
                    SegManagement.LogDocument(
                      8,"No.",0,0,Database::Customer,"Customer No.",'','',"Posting Description",'');
                  IncrNoPrinted;
                end;
                CalcFields("Additional Fee");
                CustPostingGroup.Get("Customer Posting Group");
                if GLAcc.Get(CustPostingGroup."Additional Fee Account") then begin
                  VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
                  AddFeeInclVAT := "Additional Fee" * (1 + VATPostingSetup."VAT %" / 100);
                end else
                  AddFeeInclVAT := "Additional Fee";

                CalcFields("Add. Fee per Line");
                AddFeePerLineInclVAT := "Add. Fee per Line" + CalculateLineFeeVATAmount;

                CalcFields("Interest Amount","VAT Amount");
                if ("Interest Amount" <> 0) and ("VAT Amount" <> 0) then begin
                  GLAcc.Get(CustPostingGroup."Interest Account");
                  VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
                  VATInterest := VATPostingSetup."VAT %";
                  Interest :=
                    ("Interest Amount" +
                     "VAT Amount" + "Additional Fee" - AddFeeInclVAT + "Add. Fee per Line" - AddFeePerLineInclVAT) / (VATInterest / 100 + 1);
                end else begin
                  Interest := "Interest Amount";
                  VATInterest := 0;
                end;

                TotalVATAmount := "VAT Amount";
                NNC_InterestAmountTotal := 0;
                NNC_RemainingAmountTotal := 0;
                NNC_VATAmountTotal := 0;
                NNC_InterestAmount := 0;
                NNC_Total := 0;
                NNC_VATAmount := 0;
                NNC_TotalInclVAT := 0;
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr,CompanyInfo);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowInternalInfo;ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field(ShowNotDueAmounts;ShowNotDueAmounts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Not Due Amounts';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(8) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::"No Logo":
            ;
          SalesSetup."logo position on documents"::Left:
            begin
              CompanyInfo3.Get;
              CompanyInfo3.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Center:
            begin
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Right:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
        end;
    end;

    var
        Text000: label 'Total %1';
        Text001: label 'Total %1 Incl. Tax';
        CustEntry: Record "Cust. Ledger Entry";
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        CustAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        VATNoText: Text[30];
        ReferenceText: Text[35];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        ReminderInterestAmount: Decimal;
        EndLineNo: Integer;
        Continue: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        LogInteraction: Boolean;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        CurrFactor: Decimal;
        Text011: label 'Tax Amount Specification in ';
        Text012: label 'Local Currency';
        Text013: label 'Exchange rate: %1/%2';
        AddFeeInclVAT: Decimal;
        AddFeePerLineInclVAT: Decimal;
        TotalVATAmount: Decimal;
        VATInterest: Decimal;
        Interest: Decimal;
        VALVATBase: Decimal;
        VALVATAmount: Decimal;
        NNC_InterestAmount: Decimal;
        NNC_Total: Decimal;
        NNC_VATAmount: Decimal;
        NNC_TotalInclVAT: Decimal;
        NNC_InterestAmountTotal: Decimal;
        NNC_RemainingAmountTotal: Decimal;
        NNC_VATAmountTotal: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        ShowNotDueAmounts: Boolean;
        TxtPageLbl: label 'Page';
        DueDateCaptionLbl: label 'Due Date';
        PostingDateCaptionLbl: label 'Posting Date';
        ReminderNoCaptionLbl: label 'Reminder No.';
        CompanyInfoBankAccNoCaptionLbl: label 'Account No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoVATRegNoCaptionLbl: label 'Tax Registration No.';
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        ReminderCaptionLbl: label 'Reminder';
        TaxIdentTypeCaptionLbl: label 'Tax Identification Type';
        HdrDimensionsCaptionLbl: label 'Header Dimensions';
        InterestAmtCaptionLbl: label 'Interest Amount';
        VALVATBaseCaptionLbl: label 'Continued';
        VALVATBaseLCYCaptionLbl: label 'Continued';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyInfoEmailCaptionLbl: label 'E-Mail';
        DocDateCaptionLbl: label 'Document Date';
        VATAmtCaptionLbl: label 'Tax Amount';
        AmtInclVATCaptionLbl: label 'Amount Including Tax';
        VATBaseCaptionLbl: label 'Tax Base';
        VATPercentageCaptionLbl: label 'Tax %';
        VATAmtSpecificationCaptionLbl: label 'Tax Amount Specification';
        TotalCaptionLbl: label 'Total';
}

