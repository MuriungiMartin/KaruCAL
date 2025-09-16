#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 116 Statement
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Statement.rdlc';
    Caption = 'Statement';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer;Customer)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name","Print Statements","Currency Filter";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(No_Cust;"No.")
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                PrintOnlyIfDetail = true;
                column(ReportForNavId_5444; 5444)
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
                column(CustAddr1;CustAddr[1])
                {
                }
                column(CompanyAddr1;CompanyAddr[1])
                {
                }
                column(CustAddr2;CustAddr[2])
                {
                }
                column(CompanyAddr2;CompanyAddr[2])
                {
                }
                column(CustAddr3;CustAddr[3])
                {
                }
                column(CompanyAddr3;CompanyAddr[3])
                {
                }
                column(CustAddr4;CustAddr[4])
                {
                }
                column(CompanyAddr4;CompanyAddr[4])
                {
                }
                column(CustAddr5;CustAddr[5])
                {
                }
                column(PhoneNo_CompanyInfo;CompanyInfo."Phone No.")
                {
                }
                column(CustAddr6;CustAddr[6])
                {
                }
                column(CompanyInfoEmail;CompanyInfo."E-Mail")
                {
                }
                column(CompanyInfoHomePage;CompanyInfo."Home Page")
                {
                }
                column(VATRegNo_CompanyInfo;CompanyInfo."VAT Registration No.")
                {
                }
                column(GiroNo_CompanyInfo;CompanyInfo."Giro No.")
                {
                }
                column(BankName_CompanyInfo;CompanyInfo."Bank Name")
                {
                }
                column(BankAccNo_CompanyInfo;CompanyInfo."Bank Account No.")
                {
                }
                column(No1_Cust;Customer."No.")
                {
                }
                column(TodayFormatted;Format(Today))
                {
                }
                column(StartDate;Format(StartDate))
                {
                }
                column(EndDate;Format(EndDate))
                {
                }
                column(LastStatmntNo_Cust;Format(Customer."Last Statement No."))
                {
                    DecimalPlaces = 0:0;
                }
                column(CustAddr7;CustAddr[7])
                {
                }
                column(CustAddr8;CustAddr[8])
                {
                }
                column(CompanyAddr7;CompanyAddr[7])
                {
                }
                column(CompanyAddr8;CompanyAddr[8])
                {
                }
                column(StatementCaption;StatementCaptionLbl)
                {
                }
                column(PhoneNo_CompanyInfoCaption;PhoneNo_CompanyInfoCaptionLbl)
                {
                }
                column(VATRegNo_CompanyInfoCaption;VATRegNo_CompanyInfoCaptionLbl)
                {
                }
                column(GiroNo_CompanyInfoCaption;GiroNo_CompanyInfoCaptionLbl)
                {
                }
                column(BankName_CompanyInfoCaption;BankName_CompanyInfoCaptionLbl)
                {
                }
                column(BankAccNo_CompanyInfoCaption;BankAccNo_CompanyInfoCaptionLbl)
                {
                }
                column(No1_CustCaption;No1_CustCaptionLbl)
                {
                }
                column(StartDateCaption;StartDateCaptionLbl)
                {
                }
                column(EndDateCaption;EndDateCaptionLbl)
                {
                }
                column(LastStatmntNo_CustCaption;LastStatmntNo_CustCaptionLbl)
                {
                }
                column(PostDate_DtldCustLedgEntriesCaption;PostDate_DtldCustLedgEntriesCaptionLbl)
                {
                }
                column(DocNo_DtldCustLedgEntriesCaption;DtldCustLedgEntries.FieldCaption("Document No."))
                {
                }
                column(Desc_CustLedgEntry2Caption;CustLedgEntry2.FieldCaption(Description))
                {
                }
                column(DueDate_CustLedgEntry2Caption;DueDate_CustLedgEntry2CaptionLbl)
                {
                }
                column(RemainAmtCustLedgEntry2Caption;CustLedgEntry2.FieldCaption("Remaining Amount"))
                {
                }
                column(CustBalanceCaption;CustBalanceCaptionLbl)
                {
                }
                column(OriginalAmt_CustLedgEntry2Caption;CustLedgEntry2.FieldCaption("Original Amount"))
                {
                }
                column(CompanyInfoHomepageCaption;CompanyInfoHomepageCaptionLbl)
                {
                }
                column(CompanyInfoEmailCaption;CompanyInfoEmailCaptionLbl)
                {
                }
                column(DocDateCaption;DocDateCaptionLbl)
                {
                }
                column(Total_Caption2;Total_CaptionLbl)
                {
                }
                column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
                {
                }
                dataitem(CurrencyLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    PrintOnlyIfDetail = true;
                    column(ReportForNavId_6523; 6523)
                    {
                    }
                    dataitem(CustLedgEntryHdr;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_4414; 4414)
                        {
                        }
                        column(Currency2Code_CustLedgEntryHdr;StrSubstNo(Text001,CurrencyCode3))
                        {
                        }
                        column(StartBalance;StartBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(CurrencyCode3;CurrencyCode3)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdr;CustBalance)
                        {
                        }
                        column(PrintLine;PrintLine)
                        {
                        }
                        column(DtldCustLedgEntryType;Format(DtldCustLedgEntries."Entry Type",0,2))
                        {
                        }
                        column(EntriesExists;EntriesExists)
                        {
                        }
                        column(IsNewCustCurrencyGroup;IsNewCustCurrencyGroup)
                        {
                        }
                        dataitem(DtldCustLedgEntries;"Detailed Cust. Ledg. Entry")
                        {
                            DataItemTableView = sorting("Customer No.","Posting Date","Entry Type","Currency Code");
                            column(ReportForNavId_9366; 9366)
                            {
                            }
                            column(PostDate_DtldCustLedgEntries;Format("Posting Date"))
                            {
                            }
                            column(DocNo_DtldCustLedgEntries;"Document No.")
                            {
                            }
                            column(Description;Description)
                            {
                            }
                            column(DueDate_DtldCustLedgEntries;Format(DueDate))
                            {
                            }
                            column(CurrCode_DtldCustLedgEntries;"Currency Code")
                            {
                            }
                            column(Amt_DtldCustLedgEntries;Amount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(RemainAmt_DtldCustLedgEntries;RemainingAmount)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(CustBalance;CustBalance)
                            {
                                AutoFormatExpression = "Currency Code";
                                AutoFormatType = 1;
                            }
                            column(Currency2Code;Currency2.Code)
                            {
                            }

                            trigger OnAfterGetRecord()
                            var
                                CustLedgerEntry: Record "Cust. Ledger Entry";
                            begin
                                if SkipReversedUnapplied(DtldCustLedgEntries) or (Amount = 0) then
                                  CurrReport.Skip;
                                RemainingAmount := 0;
                                PrintLine := true;
                                case "Entry Type" of
                                  "entry type"::"Initial Entry":
                                    begin
                                      CustLedgerEntry.Get("Cust. Ledger Entry No.");
                                      Description := CustLedgerEntry.Description;
                                      DueDate := CustLedgerEntry."Due Date";
                                      CustLedgerEntry.SetRange("Date Filter",0D,EndDate);
                                      CustLedgerEntry.CalcFields("Remaining Amount");
                                      RemainingAmount := CustLedgerEntry."Remaining Amount";
                                    end;
                                  "entry type"::Application:
                                    begin
                                      DtldCustLedgEntries2.SetCurrentkey("Customer No.","Posting Date","Entry Type");
                                      DtldCustLedgEntries2.SetRange("Customer No.","Customer No.");
                                      DtldCustLedgEntries2.SetRange("Posting Date","Posting Date");
                                      DtldCustLedgEntries2.SetRange("Entry Type","entry type"::Application);
                                      DtldCustLedgEntries2.SetRange("Transaction No.","Transaction No.");
                                      DtldCustLedgEntries2.SetFilter("Currency Code",'<>%1',"Currency Code");
                                      if not DtldCustLedgEntries2.IsEmpty then begin
                                        Description := Text005;
                                        DueDate := 0D;
                                      end else
                                        PrintLine := false;
                                    end;
                                  "entry type"::"Payment Discount",
                                  "entry type"::"Payment Discount (VAT Excl.)",
                                  "entry type"::"Payment Discount (VAT Adjustment)",
                                  "entry type"::"Payment Discount Tolerance",
                                  "entry type"::"Payment Discount Tolerance (VAT Excl.)",
                                  "entry type"::"Payment Discount Tolerance (VAT Adjustment)":
                                    begin
                                      Description := Text006;
                                      DueDate := 0D;
                                    end;
                                  "entry type"::"Payment Tolerance",
                                  "entry type"::"Payment Tolerance (VAT Excl.)",
                                  "entry type"::"Payment Tolerance (VAT Adjustment)":
                                    begin
                                      Description := Text014;
                                      DueDate := 0D;
                                    end;
                                  "entry type"::"Appln. Rounding",
                                  "entry type"::"Correction of Remaining Amount":
                                    begin
                                      Description := Text007;
                                      DueDate := 0D;
                                    end;
                                end;

                                if PrintLine then begin
                                  CustBalance := CustBalance + Amount;
                                  IsNewCustCurrencyGroup := IsFirstPrintLine;
                                  IsFirstPrintLine := false;
                                end;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange("Customer No.",Customer."No.");
                                SetRange("Posting Date",StartDate,EndDate);
                                SetRange("Currency Code",Currency2.Code);

                                if Currency2.Code = '' then begin
                                  GLSetup.TestField("LCY Code");
                                  CurrencyCode3 := GLSetup."LCY Code"
                                end else
                                  CurrencyCode3 := Currency2.Code;

                                IsFirstPrintLine := true;
                            end;
                        }
                    }
                    dataitem(CustLedgEntryFooter;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_7720; 7720)
                        {
                        }
                        column(CurrencyCode3_CustLedgEntryFooter;CurrencyCode3)
                        {
                        }
                        column(Total_Caption;Total_CaptionLbl)
                        {
                        }
                        column(CustBalance_CustLedgEntryHdrFooter;CustBalance)
                        {
                            AutoFormatExpression = Currency2.Code;
                            AutoFormatType = 1;
                        }
                        column(EntriesExistsl_CustLedgEntryFooterCaption;EntriesExists)
                        {
                        }
                    }
                    dataitem(CustLedgEntry2;"Cust. Ledger Entry")
                    {
                        DataItemLink = "Customer No."=field("No.");
                        DataItemLinkReference = Customer;
                        DataItemTableView = sorting("Customer No.",Open,Positive,"Due Date");
                        column(ReportForNavId_9065; 9065)
                        {
                        }
                        column(OverDueEntries;StrSubstNo(Text002,Currency2.Code))
                        {
                        }
                        column(RemainAmt_CustLedgEntry2;"Remaining Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PostDate_CustLedgEntry2;Format("Posting Date"))
                        {
                        }
                        column(DocNo_CustLedgEntry2;"Document No.")
                        {
                        }
                        column(Desc_CustLedgEntry2;Description)
                        {
                        }
                        column(DueDate_CustLedgEntry2;Format("Due Date"))
                        {
                        }
                        column(OriginalAmt_CustLedgEntry2;"Original Amount")
                        {
                            AutoFormatExpression = "Currency Code";
                        }
                        column(CurrCode_CustLedgEntry2;"Currency Code")
                        {
                        }
                        column(PrintEntriesDue;PrintEntriesDue)
                        {
                        }
                        column(Currency2Code_CustLedgEntry2;Currency2.Code)
                        {
                        }
                        column(CurrencyCode3_CustLedgEntry2;CurrencyCode3)
                        {
                        }
                        column(CustNo_CustLedgEntry2;"Customer No.")
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            CustLedgEntry: Record "Cust. Ledger Entry";
                        begin
                            if IncludeAgingBand then
                              if ("Posting Date" > EndDate) and ("Due Date" >= EndDate) then
                                CurrReport.Skip;
                            CustLedgEntry := CustLedgEntry2;
                            CustLedgEntry.SetRange("Date Filter",0D,EndDate);
                            CustLedgEntry.CalcFields("Remaining Amount");
                            "Remaining Amount" := CustLedgEntry."Remaining Amount";
                            if CustLedgEntry."Remaining Amount" = 0 then
                              CurrReport.Skip;

                            if IncludeAgingBand and ("Posting Date" <= EndDate) then
                              UpdateBuffer(Currency2.Code,GetDate("Posting Date","Due Date"),"Remaining Amount");
                            if "Due Date" >= EndDate then
                              CurrReport.Skip;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals("Remaining Amount");
                            if not IncludeAgingBand then
                              SetRange("Due Date",0D,EndDate - 1);
                            SetRange("Currency Code",Currency2.Code);
                            if (not PrintEntriesDue) and (not IncludeAgingBand) then
                              CurrReport.Break;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        CustLedgerEntry: Record "Cust. Ledger Entry";
                    begin
                        if Number = 1 then
                          Currency2.FindFirst;

                        repeat
                          if not IsFirstLoop then
                            IsFirstLoop := true
                          else
                            if Currency2.Next = 0 then
                              CurrReport.Break;
                          CustLedgerEntry.SetRange("Customer No.",Customer."No.");
                          CustLedgerEntry.SetRange("Posting Date",0D,EndDate);
                          CustLedgerEntry.SetRange("Currency Code",Currency2.Code);
                          EntriesExists := not CustLedgerEntry.IsEmpty;
                        until EntriesExists;
                        Cust2 := Customer;
                        Cust2.SetRange("Date Filter",0D,StartDate - 1);
                        Cust2.SetRange("Currency Filter",Currency2.Code);
                        Cust2.CalcFields("Net Change");
                        StartBalance := Cust2."Net Change";
                        CustBalance := Cust2."Net Change";
                    end;

                    trigger OnPreDataItem()
                    begin
                        Customer.Copyfilter("Currency Filter",Currency2.Code);
                    end;
                }
                dataitem(AgingBandLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=filter(1..));
                    column(ReportForNavId_1154; 1154)
                    {
                    }
                    column(AgingDate1;Format(AgingDate[1] + 1))
                    {
                    }
                    column(AgingDate2;Format(AgingDate[2]))
                    {
                    }
                    column(AgingDate21;Format(AgingDate[2] + 1))
                    {
                    }
                    column(AgingDate3;Format(AgingDate[3]))
                    {
                    }
                    column(AgingDate31;Format(AgingDate[3] + 1))
                    {
                    }
                    column(AgingDate4;Format(AgingDate[4]))
                    {
                    }
                    column(AgingBandEndingDate;StrSubstNo(Text011,AgingBandEndingDate,PeriodLength,SelectStr(DateChoice + 1,Text013)))
                    {
                    }
                    column(AgingDate41;Format(AgingDate[4] + 1))
                    {
                    }
                    column(AgingDate5;Format(AgingDate[5]))
                    {
                    }
                    column(AgingBandBufCol1Amt;AgingBandBuf."Column 1 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol2Amt;AgingBandBuf."Column 2 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol3Amt;AgingBandBuf."Column 3 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol4Amt;AgingBandBuf."Column 4 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandBufCol5Amt;AgingBandBuf."Column 5 Amt.")
                    {
                        AutoFormatExpression = AgingBandBuf."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(AgingBandCurrencyCode;AgingBandCurrencyCode)
                    {
                    }
                    column(beforeCaption;beforeCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                          if not AgingBandBuf.Find('-') then
                            CurrReport.Break;
                        end else
                          if AgingBandBuf.Next = 0 then
                            CurrReport.Break;
                        AgingBandCurrencyCode := AgingBandBuf."Currency Code";
                        if AgingBandCurrencyCode = '' then
                          AgingBandCurrencyCode := GLSetup."LCY Code";
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not IncludeAgingBand then
                          CurrReport.Break;
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                CustLedgerEntry: Record "Cust. Ledger Entry";
            begin
                if FirstCustomerPrinted then begin
                  Clear(CompanyInfo.Picture);
                  Clear(CompanyInfo1.Picture);
                  Clear(CompanyInfo2.Picture);
                  Clear(CompanyInfo3.Picture);
                end;
                FirstCustomerPrinted := true;
                AgingBandBuf.DeleteAll;
                CurrReport.Language := Language.GetLanguageID("Language Code");
                PrintLine := false;
                Cust2 := Customer;
                Copyfilter("Currency Filter",Currency2.Code);
                if PrintAllHavingBal then begin
                  if Currency2.Find('-') then
                    repeat
                      Cust2.SetRange("Date Filter",0D,EndDate);
                      Cust2.SetRange("Currency Filter",Currency2.Code);
                      Cust2.CalcFields("Net Change");
                      PrintLine := Cust2."Net Change" <> 0;
                    until (Currency2.Next = 0) or PrintLine;
                end;
                if (not PrintLine) and PrintAllHavingEntry then begin
                  CustLedgerEntry.SetRange("Customer No.","No.");
                  CustLedgerEntry.SetRange("Posting Date",StartDate,EndDate);
                  Copyfilter("Currency Filter",CustLedgerEntry."Currency Code");
                  PrintLine := not CustLedgerEntry.IsEmpty;
                end;
                if not PrintLine then
                  CurrReport.Skip;

                // If we have any line that's flagged for printing, set output flag
                OutputGenerated := true;

                FormatAddr.Customer(CustAddr,Customer);
                CurrReport.PageNo := 1;

                if not CurrReport.Preview then begin
                  LockTable;
                  Find;
                  "Last Statement No." := "Last Statement No." + 1;
                  Modify;
                  Commit;
                end else
                  "Last Statement No." := "Last Statement No." + 1;

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      7,Format("Last Statement No."),0,0,Database::Customer,"No.","Salesperson Code",'',
                      Text003 + Format("Last Statement No."),'');
                IsFirstLoop := false;
            end;

            trigger OnPreDataItem()
            begin
                VerifyDates;
                AgingBandEndingDate := EndDate;
                CalcAgingBandDates;

                CompanyInfo.Get;
                FormatAddr.Company(CompanyAddr,CompanyInfo);

                Currency2.Code := '';
                Currency2.Insert;
                Copyfilter("Currency Filter",Currency.Code);
                if Currency.Find('-') then
                  repeat
                    Currency2 := Currency;
                    Currency2.Insert;
                  until Currency.Next = 0;
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
                    field("Start Date";StartDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Start Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field("End Date";EndDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'End Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(ShowOverdueEntries;PrintEntriesDue)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Overdue Entries';
                        ToolTip = 'Specifies if you want overdue entries to be shown separately for each currency.';
                    }
                    group(Include)
                    {
                        Caption = 'Include';
                        field(IncludeAllCustomerswithLE;PrintAllHavingEntry)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Include All Customers with Ledger Entries';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have ledger entries at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                if not PrintAllHavingEntry then
                                  PrintAllHavingBal := true;
                            end;
                        }
                        field(IncludeAllCustomerswithBalance;PrintAllHavingBal)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Include All Customers with a Balance';
                            MultiLine = true;
                            ToolTip = 'Specifies if you want entries displayed for customers that have a balance at the end of the selected period.';

                            trigger OnValidate()
                            begin
                                if not PrintAllHavingBal then
                                  PrintAllHavingEntry := true;
                            end;
                        }
                        field(IncludeReversedEntries;PrintReversedEntries)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Include Reversed Entries';
                            ToolTip = 'Specifies if you want to include reversed entries in the report.';
                        }
                        field(IncludeUnappliedEntries;PrintUnappliedEntries)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Include Unapplied Entries';
                            ToolTip = 'Specifies if you want to include unapplied entries in the report.';
                        }
                    }
                    group("Aging Band")
                    {
                        Caption = 'Aging Band';
                        field(IncludeAgingBand;IncludeAgingBand)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Include Aging Band';
                            ToolTip = 'Specifies if you want an aging band to be included in the document. If you place a check mark here, you must also fill in the Aging Band Period Length and Aging Band by fields.';
                        }
                        field(AgingBandPeriodLengt;PeriodLength)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Aging Band Period Length';
                            ToolTip = 'Specifies the length of each of the four periods in the aging band, for example, enter "1M" for one month. The most recent period will end on the last day of the period in the Date Filter field.';
                        }
                        field(AgingBandby;DateChoice)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Aging Band by';
                            OptionCaption = 'Due Date,Posting Date';
                            ToolTip = 'Specifies if the aging band will be calculated from the due date or from the posting date.';
                        }
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with the contact are logged.';
                    }
                }
                group("Output Options")
                {
                    Caption = 'Output Options';
                    field(ReportOutput;SupportedOutputMethod)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Report Output';
                        OptionCaption = 'Print,Preview,PDF,Email,Excel,XML';
                        ToolTip = 'Specifies the output of the scheduled report, such as PDF or Word.';

                        trigger OnValidate()
                        var
                            CustomLayoutReporting: Codeunit "Custom Layout Reporting";
                        begin
                            ShowPrintRemaining := (SupportedOutputMethod = Supportedoutputmethod::Email);

                            case SupportedOutputMethod of
                              Supportedoutputmethod::Print:
                                ChosenOutputMethod := CustomLayoutReporting.GetPrintOption;
                              Supportedoutputmethod::Preview:
                                ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption;
                              Supportedoutputmethod::Pdf:
                                ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
                              Supportedoutputmethod::Email:
                                ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
                              Supportedoutputmethod::Excel:
                                ChosenOutputMethod := CustomLayoutReporting.GetExcelOption;
                              Supportedoutputmethod::Xml:
                                ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
                            end;
                        end;
                    }
                    field(ChosenOutput;ChosenOutputMethod)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Chosen Output';
                        Visible = false;
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintRemaining;
                        field(PrintMissingAddresses;PrintRemaining)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Print remaining statements';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            InitRequestPageDataInternal;
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
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Center:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Right:
            begin
              CompanyInfo3.Get;
              CompanyInfo3.CalcFields(Picture);
            end;
        end;

        OutputGenerated := false;
        LogInteractionEnable := true;
    end;

    trigger OnPostReport()
    begin
        if not OutputGenerated then
          Error(NoOutputErr);
    end;

    trigger OnPreReport()
    begin
        InitRequestPageDataInternal;
    end;

    var
        Text001: label 'Entries %1';
        Text002: label 'Overdue Entries %1';
        Text003: label 'Statement ';
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        Cust2: Record Customer;
        Currency: Record Currency;
        Currency2: Record Currency temporary;
        Language: Record Language;
        DtldCustLedgEntries2: Record "Detailed Cust. Ledg. Entry";
        AgingBandBuf: Record "Aging Band Buffer" temporary;
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        PrintAllHavingEntry: Boolean;
        PrintAllHavingBal: Boolean;
        PrintEntriesDue: Boolean;
        PrintUnappliedEntries: Boolean;
        PrintReversedEntries: Boolean;
        PrintLine: Boolean;
        LogInteraction: Boolean;
        EntriesExists: Boolean;
        StartDate: Date;
        EndDate: Date;
        DueDate: Date;
        CustAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        Description: Text[50];
        StartBalance: Decimal;
        CustBalance: Decimal;
        RemainingAmount: Decimal;
        CurrencyCode3: Code[10];
        Text005: label 'Multicurrency Application';
        Text006: label 'Payment Discount';
        Text007: label 'Rounding';
        PeriodLength: DateFormula;
        PeriodLength2: DateFormula;
        DateChoice: Option "Due Date","Posting Date";
        AgingDate: array [5] of Date;
        Text008: label 'You must specify the Aging Band Period Length.';
        AgingBandEndingDate: Date;
        Text010: label 'You must specify Aging Band Ending Date.';
        Text011: label 'Aged Summary by %1 (%2 by %3)';
        IncludeAgingBand: Boolean;
        Text012: label 'Period Length is out of range.';
        AgingBandCurrencyCode: Code[20];
        Text013: label 'Due Date,Posting Date';
        Text014: label 'Application Writeoffs';
        [InDataSet]
        LogInteractionEnable: Boolean;
        Text036: label '-%1', Comment='Negating the period length: %1 is the period length';
        StatementCaptionLbl: label 'Statement';
        PhoneNo_CompanyInfoCaptionLbl: label 'Phone No.';
        VATRegNo_CompanyInfoCaptionLbl: label 'Tax Registration No.';
        GiroNo_CompanyInfoCaptionLbl: label 'Giro No.';
        BankName_CompanyInfoCaptionLbl: label 'Bank';
        BankAccNo_CompanyInfoCaptionLbl: label 'Account No.';
        No1_CustCaptionLbl: label 'Customer No.';
        StartDateCaptionLbl: label 'Starting Date';
        EndDateCaptionLbl: label 'Ending Date';
        LastStatmntNo_CustCaptionLbl: label 'Statement No.';
        PostDate_DtldCustLedgEntriesCaptionLbl: label 'Posting Date';
        DueDate_CustLedgEntry2CaptionLbl: label 'Due Date';
        CustBalanceCaptionLbl: label 'Balance';
        beforeCaptionLbl: label '..before';
        isInitialized: Boolean;
        CompanyInfoHomepageCaptionLbl: label 'Home Page';
        CompanyInfoEmailCaptionLbl: label 'Email';
        DocDateCaptionLbl: label 'Document Date';
        Total_CaptionLbl: label 'Total';
        BlankStartDateErr: label 'Start Date must have a value.';
        BlankEndDateErr: label 'End Date must have a value.';
        StartDateLaterTheEndDateErr: label 'Start date must be earlier than End date.';
        IsFirstLoop: Boolean;
        CurrReportPageNoCaptionLbl: label 'Page';
        IsFirstPrintLine: Boolean;
        IsNewCustCurrencyGroup: Boolean;
        SupportedOutputMethod: Option Print,Preview,Pdf,Email,Excel,Xml;
        ChosenOutputMethod: Integer;
        PrintRemaining: Boolean;
        [InDataSet]
        ShowPrintRemaining: Boolean;
        FirstCustomerPrinted: Boolean;
        OutputGenerated: Boolean;
        NoOutputErr: label 'No data was returned for the report using the selected data filters.';

    local procedure GetDate(PostingDate: Date;DueDate: Date): Date
    begin
        if DateChoice = Datechoice::"Posting Date" then
          exit(PostingDate);

        exit(DueDate);
    end;

    local procedure CalcAgingBandDates()
    begin
        if not IncludeAgingBand then
          exit;
        if AgingBandEndingDate = 0D then
          Error(Text010);
        if Format(PeriodLength) = '' then
          Error(Text008);
        Evaluate(PeriodLength2,StrSubstNo(Text036,PeriodLength));
        AgingDate[5] := AgingBandEndingDate;
        AgingDate[4] := CalcDate(PeriodLength2,AgingDate[5]);
        AgingDate[3] := CalcDate(PeriodLength2,AgingDate[4]);
        AgingDate[2] := CalcDate(PeriodLength2,AgingDate[3]);
        AgingDate[1] := CalcDate(PeriodLength2,AgingDate[2]);
        if AgingDate[2] <= AgingDate[1] then
          Error(Text012);
    end;

    local procedure UpdateBuffer(CurrencyCode: Code[10];Date: Date;Amount: Decimal)
    var
        I: Integer;
        GoOn: Boolean;
    begin
        AgingBandBuf.Init;
        AgingBandBuf."Currency Code" := CurrencyCode;
        if not AgingBandBuf.Find then
          AgingBandBuf.Insert;
        I := 1;
        GoOn := true;
        while (I <= 5) and GoOn do begin
          if Date <= AgingDate[I] then
            if I = 1 then begin
              AgingBandBuf."Column 1 Amt." := AgingBandBuf."Column 1 Amt." + Amount;
              GoOn := false;
            end;
          if Date <= AgingDate[I] then
            if I = 2 then begin
              AgingBandBuf."Column 2 Amt." := AgingBandBuf."Column 2 Amt." + Amount;
              GoOn := false;
            end;
          if Date <= AgingDate[I] then
            if I = 3 then begin
              AgingBandBuf."Column 3 Amt." := AgingBandBuf."Column 3 Amt." + Amount;
              GoOn := false;
            end;
          if Date <= AgingDate[I] then
            if I = 4 then begin
              AgingBandBuf."Column 4 Amt." := AgingBandBuf."Column 4 Amt." + Amount;
              GoOn := false;
            end;
          if Date <= AgingDate[I] then
            if I = 5 then begin
              AgingBandBuf."Column 5 Amt." := AgingBandBuf."Column 5 Amt." + Amount;
              GoOn := false;
            end;
          I := I + 1;
        end;
        AgingBandBuf.Modify;
    end;


    procedure SkipReversedUnapplied(var DtldCustLedgEntries: Record "Detailed Cust. Ledg. Entry"): Boolean
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        if PrintReversedEntries and PrintUnappliedEntries then
          exit(false);
        if not PrintUnappliedEntries then
          if DtldCustLedgEntries.Unapplied then
            exit(true);
        if not PrintReversedEntries then begin
          CustLedgEntry.Get(DtldCustLedgEntries."Cust. Ledger Entry No.");
          if CustLedgEntry.Reversed then
            exit(true);
        end;
        exit(false);
    end;


    procedure InitializeRequest(NewPrintEntriesDue: Boolean;NewPrintAllHavingEntry: Boolean;NewPrintAllHavingBal: Boolean;NewPrintReversedEntries: Boolean;NewPrintUnappliedEntries: Boolean;NewIncludeAgingBand: Boolean;NewPeriodLength: Text[30];NewDateChoice: Option;NewLogInteraction: Boolean;NewStartDate: Date;NewEndDate: Date)
    begin
        InitRequestPageDataInternal;

        PrintEntriesDue := NewPrintEntriesDue;
        PrintAllHavingEntry := NewPrintAllHavingEntry;
        PrintAllHavingBal := NewPrintAllHavingBal;
        PrintReversedEntries := NewPrintReversedEntries;
        PrintUnappliedEntries := NewPrintUnappliedEntries;
        IncludeAgingBand := NewIncludeAgingBand;
        Evaluate(PeriodLength,NewPeriodLength);
        DateChoice := NewDateChoice;
        LogInteraction := NewLogInteraction;
        StartDate := NewStartDate;
        EndDate := NewEndDate;
    end;


    procedure InitRequestPageDataInternal()
    begin
        if isInitialized then
          exit;

        isInitialized := true;

        if (not PrintAllHavingEntry) and (not PrintAllHavingBal) then
          PrintAllHavingBal := true;

        LogInteraction := SegManagement.FindInteractTmplCode(7) <> '';
        LogInteractionEnable := LogInteraction;

        if Format(PeriodLength) = '' then
          Evaluate(PeriodLength,'<1M+CM>');

        ShowPrintRemaining := (SupportedOutputMethod = Supportedoutputmethod::Email);
    end;

    local procedure VerifyDates()
    begin
        if StartDate = 0D then
          Error(BlankStartDateErr);
        if EndDate = 0D then
          Error(BlankEndDateErr);
        if StartDate > EndDate then
          Error(StartDateLaterTheEndDateErr);
    end;
}

