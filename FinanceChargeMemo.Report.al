#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 118 "Finance Charge Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Finance Charge Memo.rdlc';
    Caption = 'Finance Charge Memo';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Issued Fin. Charge Memo Header";"Issued Fin. Charge Memo Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Finance Charge Memo';
            column(ReportForNavId_119; 119)
            {
            }
            column(No_IssuedFinChrgMemoHdr;"No.")
            {
            }
            column(VATBaseCaption;VATBaseCaptionLbl)
            {
            }
            column(VATPercentageCaption;VATPercentageCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(HomePageCaption;HomePageCaptionLbl)
            {
            }
            column(EmailCaption;EmailCaptionLbl)
            {
            }
            column(DocumentDateCaption;DocumentDateCaptionLbl)
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_120; 120)
                {
                }
                column(PostDate_IssFinChrgMemoHdr;Format("Issued Fin. Charge Memo Header"."Posting Date"))
                {
                }
                column(DueDate_IssFinChrgMemoHdr;Format("Issued Fin. Charge Memo Header"."Due Date"))
                {
                }
                column(No1_IssuedFinChrgMemoHdr;"Issued Fin. Charge Memo Header"."No.")
                {
                }
                column(DocDate_IssFinChrgMemoHdr;Format("Issued Fin. Charge Memo Header"."Document Date"))
                {
                }
                column(YourRef_IssFinChrgMemoHdr;"Issued Fin. Charge Memo Header"."Your Reference")
                {
                }
                column(ReferenceText;ReferenceText)
                {
                }
                column(VATRegNo_IssFinChrgMemoHdr;"Issued Fin. Charge Memo Header"."VAT Registration No.")
                {
                }
                column(VATNoText;VATNoText)
                {
                }
                column(CompanyInfo2Picture;CompanyInfo2.Picture)
                {
                }
                column(CompanyInfoPicture;CompanyInfo3.Picture)
                {
                }
                column(CompanyInfo1Picture;CompanyInfo1.Picture)
                {
                }
                column(CompanyInfoBankAccountNo;CompanyInfo."Bank Account No.")
                {
                }
                column(CustNo_IssFinChrgMemoHdr;"Issued Fin. Charge Memo Header"."Customer No.")
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
                column(CompanyInfoHomePage;CompanyInfo."Home Page")
                {
                }
                column(CompanyInfoEmail;CompanyInfo."E-Mail")
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
                column(PageCaption;StrSubstNo(Text002,''))
                {
                }
                column(TaxIdentificationType_Cust;Format(Cust."Tax Identification Type"))
                {
                }
                column(IssuedFinChargeMemoHeaderPostingDateCaption;Text010)
                {
                }
                column(IssuedFinChargeMemoHeaderDueDateCaption;Text011)
                {
                }
                column(IssuedFinChargeMemoHeaderNoCaption;Text012)
                {
                }
                column(CompanyInfoBankAccountNoCaption;Text013)
                {
                }
                column(CompanyInfoBankNameCaption;Text014)
                {
                }
                column(CompanyInfoGiroNoCaption;Text015)
                {
                }
                column(CompanyInfoVATRegistrationNoCaption;Text016)
                {
                }
                column(CompanyInfoFaxNoCaption;Text017)
                {
                }
                column(CompanyInfoPhoneNoCaption;Text018)
                {
                }
                column(FinanceChargeMemoCaption;Text019)
                {
                }
                column(TaxIdentTypeCaption;Text020)
                {
                }
                column(CustNo_IssFinChrgMemoHdrCaption;"Issued Fin. Charge Memo Header".FieldCaption("Customer No."))
                {
                }
                dataitem(DimensionLoop;"Integer")
                {
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    column(ReportForNavId_121; 121)
                    {
                    }
                    column(DimText;DimText)
                    {
                    }
                    column(Number_DimensionLoop;Number)
                    {
                    }
                    column(HeaderDimensionsCaption;Text021)
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
                dataitem("Issued Fin. Charge Memo Line";"Issued Fin. Charge Memo Line")
                {
                    DataItemLink = "Finance Charge Memo No."=field("No.");
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
                    DataItemTableView = sorting("Finance Charge Memo No.","Line No.");
                    column(ReportForNavId_122; 122)
                    {
                    }
                    column(LineNo_IssFinChrgMemoLine;"Line No.")
                    {
                    }
                    column(StartLineNo;StartLineNo)
                    {
                    }
                    column(TypeInt;TypeInt)
                    {
                    }
                    column(ShowInternalInfo;ShowInternalInfo)
                    {
                    }
                    column(Amount_IssuedFinChrgMemoLine;Amount)
                    {
                        AutoCalcField = true;
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(Description_IssuedFinChrgMemoLine;Description)
                    {
                    }
                    column(DocDate_IssuedFinChrgMemoLine;Format("Document Date"))
                    {
                    }
                    column(DocNo_IssFinChrgMemoLine;"Document No.")
                    {
                    }
                    column(DueDate_IssFinChrgMemoLine;Format("Due Date"))
                    {
                    }
                    column(DocType_IssFinChrgMemoLine;"Document Type")
                    {
                    }
                    column(No_IssuedFinChrgMemoLine;"No.")
                    {
                    }
                    column(TotalAmountExclVAT;Amount + 0)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalText;TotalText)
                    {
                    }
                    column(TotalAmountInclVAT;Amount + "VAT Amount")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Line".GetCurrencyCode;
                        AutoFormatType = 1;
                    }
                    column(TotalInclVATText;TotalInclVATText)
                    {
                    }
                    column(VATAmt_IssFinChrgMemoLine;"VAT Amount")
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(IssuedFinChargeMemoLineDocumentDateCaption;Text022)
                    {
                    }
                    column(IssuedFinChargeMemoLineDueDateCaption;Text023)
                    {
                    }
                    column(IssuedFinChargeMemoLineVATAmountCaption;Text024)
                    {
                    }
                    column(Amount_IssuedFinChrgMemoLineCaption;FieldCaption(Amount))
                    {
                    }
                    column(Description_IssuedFinChrgMemoLineCaption;FieldCaption(Description))
                    {
                    }
                    column(DocNo_IssFinChrgMemoLineCaption;FieldCaption("Document No."))
                    {
                    }
                    column(DocType_IssFinChrgMemoLineCaption;FieldCaption("Document Type"))
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

                        TypeInt := "Issued Fin. Charge Memo Line".Type;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if Find('-') then begin
                          StartLineNo := 0;
                          repeat
                            Continue := Type = Type::" ";
                            if Continue and (Description = '') then
                              StartLineNo := "Line No.";
                          until (Next = 0) or not Continue;
                        end;
                        if Find('+') then begin
                          EndLineNo := "Line No." + 1;
                          repeat
                            Continue := Type = Type::" ";
                            if Continue and (Description = '') then
                              EndLineNo := "Line No.";
                          until (Next(-1) = 0) or not Continue;
                        end;

                        VATAmountLine.DeleteAll;
                        SetFilter("Line No.",'<%1',EndLineNo);
                        CurrReport.CreateTotals(Amount,"VAT Amount");
                    end;
                }
                dataitem(IssuedFinChrgMemoLine2;"Issued Fin. Charge Memo Line")
                {
                    DataItemLink = "Finance Charge Memo No."=field("No.");
                    DataItemLinkReference = "Issued Fin. Charge Memo Header";
                    DataItemTableView = sorting("Finance Charge Memo No.","Line No.");
                    column(ReportForNavId_123; 123)
                    {
                    }
                    column(Desc_IssFinChrgMemoLine2;Description)
                    {
                    }
                    column(LineNo_IssFinChrgMemoLine2;"Line No.")
                    {
                    }

                    trigger OnPreDataItem()
                    begin
                        SetFilter("Line No.",'>=%1',EndLineNo);
                    end;
                }
                dataitem(VATCounter;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_124; 124)
                    {
                    }
                    column(VALVATBaseVALVATAmount;VALVATBase + VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VALVATAmount;VALVATAmount)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VALVATBase;VALVATBase)
                    {
                        AutoFormatExpression = "Issued Fin. Charge Memo Header"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VAT_VATAmountLine;VATAmountLine."VAT %")
                    {
                    }
                    column(VALVATBaseVALVATAmountControl70Caption;Text025)
                    {
                    }
                    column(VATAmountSpecificationCaption;Text026)
                    {
                    }
                    column(VATCaption;Text027)
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
                        SetRange(Number,1,VATAmountLine.Count);
                        CurrReport.CreateTotals(VALVATBase,VALVATAmount,VATAmountLine."Amount Including VAT");
                    end;
                }
                dataitem(VATCounterLCY;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_125; 125)
                    {
                    }
                    column(VALExchRate;VALExchRate)
                    {
                    }
                    column(VALSpecLCYHeader;VALSpecLCYHeader)
                    {
                    }
                    column(VALVATAmountLCY;VALVATAmountLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VALVATBaseLCY;VALVATBaseLCY)
                    {
                        AutoFormatType = 1;
                    }
                    column(VAT1_VATAmountLine;VATAmountLine."VAT %")
                    {
                        DecimalPlaces = 0:5;
                    }
                    column(VATPercentCaption;Text027)
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
                           ("Issued Fin. Charge Memo Header"."Currency Code" = '') or
                           (VATAmountLine.GetTotalVATAmount = 0)
                        then
                          CurrReport.Break;

                        SetRange(Number,1,VATAmountLine.Count);
                        CurrReport.CreateTotals(VALVATBaseLCY,VALVATAmountLCY);

                        if GLSetup."LCY Code" = '' then
                          VALSpecLCYHeader := Text007 + Text008
                        else
                          VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                        CurrExchRate.FindCurrency("Issued Fin. Charge Memo Header"."Posting Date","Issued Fin. Charge Memo Header"."Currency Code",1);
                        CustEntry.SetRange("Customer No.","Issued Fin. Charge Memo Header"."Customer No.");
                        CustEntry.SetRange("Document Type",CustEntry."document type"::"Finance Charge Memo");
                        CustEntry.SetRange("Document No.","Issued Fin. Charge Memo Header"."No.");
                        if CustEntry.FindFirst then begin
                          CustEntry.CalcFields("Amount (LCY)",Amount);
                          CurrFactor := 1 / (CustEntry."Amount (LCY)" / CustEntry.Amount);
                          VALExchRate := StrSubstNo(Text009,ROUND(1 / CurrFactor * 100,0.000001),CurrExchRate."Exchange Rate Amount");
                        end else begin
                          CurrFactor := CurrExchRate.ExchangeRate("Issued Fin. Charge Memo Header"."Posting Date",
                              "Issued Fin. Charge Memo Header"."Currency Code");
                          VALExchRate := StrSubstNo(Text009,CurrExchRate."Relational Exch. Rate Amount",CurrExchRate."Exchange Rate Amount");
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

                FormatAddr.IssuedFinanceChargeMemo(CustAddr,"Issued Fin. Charge Memo Header");
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
                if not CurrReport.Preview then
                  IncrNoPrinted;
                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      19,"No.",0,0,Database::Customer,"Customer No.",'','',"Posting Description",'');

                CalcFields("Additional Fee");
                CustPostingGroup.Get("Customer Posting Group");
                GLAcc.Get(CustPostingGroup."Additional Fee Account");
                VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");

                GLAcc.Get(CustPostingGroup."Interest Account");
                VATPostingSetup.Get("VAT Bus. Posting Group",GLAcc."VAT Prod. Posting Group");
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
                    field(ShowInternalInformation;ShowInternalInfo)
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
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
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

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
          InitLogInteraction;
    end;

    var
        Text000: label 'Total %1';
        Text001: label 'Total %1 Incl. Tax';
        Text002: label 'Page %1';
        GLSetup: Record "General Ledger Setup";
        CompanyInfo: Record "Company Information";
        VATAmountLine: Record "VAT Amount Line" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        Language: Record Language;
        CurrExchRate: Record "Currency Exchange Rate";
        Cust: Record Customer;
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        SegManagement: Codeunit SegManagement;
        FormatAddr: Codeunit "Format Address";
        CustAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        [InDataSet]
        VATNoText: Text[30];
        ReferenceText: Text[35];
        TotalText: Text[50];
        TotalInclVATText: Text[50];
        StartLineNo: Integer;
        EndLineNo: Integer;
        TypeInt: Integer;
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
        Text007: label 'Tax Amount Specification in ';
        Text008: label 'Local Currency';
        Text009: label 'Exchange rate: %1/%2';
        CustEntry: Record "Cust. Ledger Entry";
        VALVATBase: Decimal;
        VALVATAmount: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        Text010: label 'Posting Date';
        Text011: label 'Due Date';
        Text012: label 'Fin. Chrg. Memo No.';
        Text013: label 'Account No.';
        Text014: label 'Bank';
        Text015: label 'Giro No.';
        Text016: label 'Tax Reg. No.';
        Text017: label 'Fax No.';
        Text018: label 'Phone No.';
        Text019: label 'Finance Charge Memo';
        Text020: label 'Tax Ident. Type';
        Text021: label 'Header Dimensions';
        Text022: label 'Document Date';
        Text023: label 'Due Date';
        Text024: label 'Tax Amount';
        Text025: label 'Amount Including Tax';
        Text026: label 'Tax Amount Specification';
        Text027: label 'Tax %';
        VATBaseCaptionLbl: label 'Tax Base';
        VATPercentageCaptionLbl: label 'Tax %';
        TotalCaptionLbl: label 'Total';
        HomePageCaptionLbl: label 'Home Page';
        EmailCaptionLbl: label 'Email';
        DocumentDateCaptionLbl: label 'Document Date';


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(19) <> '';
    end;


    procedure InitializeRequest(NewShowInternalInfo: Boolean;NewLogInteraction: Boolean)
    begin
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
    end;
}

