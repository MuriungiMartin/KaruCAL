#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 840 "Suggest Worksheet Lines"
{
    Caption = 'Suggest Worksheet Lines';
    Permissions = TableData "Dimension Set ID Filter Line"=rimd,
                  TableData "Cash Flow Forecast Entry"=rimd;
    ProcessingOnly = true;

    dataset
    {
        dataitem("Cash Flow Forecast";"Cash Flow Forecast")
        {
            DataItemTableView = sorting("No.") order(ascending);
            column(ReportForNavId_8965; 8965)
            {
            }
            dataitem("Cash Flow Account";"Cash Flow Account")
            {
                DataItemTableView = sorting("No.") order(ascending) where("G/L Integration"=filter(Balance|Both),"G/L Account Filter"=filter(<>''));
                column(ReportForNavId_6780; 6780)
                {
                }

                trigger OnAfterGetRecord()
                var
                    GLAcc: Record "G/L Account";
                    TempGLAccount: Record "G/L Account" temporary;
                begin
                    GLAcc.SetFilter("No.","G/L Account Filter");

                    GetSubPostingGLAccounts(GLAcc,TempGLAccount);

                    if TempGLAccount.FindSet then
                      repeat
                        TempGLAccount.CalcFields(Balance);

                        Window.Update(2,Text004);
                        Window.Update(3,TempGLAccount."No.");
                        InsertCFLineForGLAccount(TempGLAccount);
                      until TempGLAccount.Next = 0;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Liquid Funds"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemTableView = sorting(Open,"Due Date") order(ascending) where(Open=const(true),"Remaining Amount"=filter(<>0));
                column(ReportForNavId_8503; 8503)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,Text005);
                    Window.Update(3,"Entry No.");

                    if "Customer No." <> '' then
                      Customer.Get("Customer No.")
                    else
                      Customer.Init;

                    CalcFields("Remaining Amt. (LCY)","Remaining Amount");

                    InsertCFLineForCustLedgerEntry;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::Receivables] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
            {
                DataItemTableView = sorting(Open,"Due Date") order(ascending) where(Open=const(true),"Remaining Amount"=filter(<>0));
                column(ReportForNavId_4114; 4114)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,Text006);
                    Window.Update(3,"Entry No.");

                    if "Vendor No." <> '' then
                      Vendor.Get("Vendor No.")
                    else
                      Vendor.Init;

                    CalcFields("Remaining Amt. (LCY)","Remaining Amount");

                    InsertCFLineForVendorLedgEntry;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::Payables] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemTableView = sorting("Document Type","Document No.","Line No.") order(ascending) where("Document Type"=const(Order));
                column(ReportForNavId_6547; 6547)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,Text007);
                    Window.Update(3,"Document No.");

                    PurchHeader.Get("Document Type","Document No.");
                    if PurchHeader."Buy-from Vendor No." <> '' then
                      Vendor.Get(PurchHeader."Pay-to Vendor No.")
                    else
                      Vendor.Init;

                    InsertCFLineForPurchaseLine;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Purchase Order"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    if not ApplicationAreaSetup.IsSuiteEnabled and not ApplicationAreaSetup.IsAllDisabled then
                      CurrReport.Break;
                end;
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemTableView = sorting("Document Type","Document No.","Line No.") order(ascending) where("Document Type"=const(Order));
                column(ReportForNavId_2844; 2844)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,Text008);
                    Window.Update(3,"Document No.");

                    SalesHeader.Get("Document Type","Document No.");
                    if SalesHeader."Sell-to Customer No." <> '' then
                      Customer.Get(SalesHeader."Bill-to Customer No.")
                    else
                      Customer.Init;

                    InsertCFLineForSalesLine;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Sales Order"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem(InvestmentFixedAsset;"Fixed Asset")
            {
                DataItemTableView = sorting("No.") where("Budgeted Asset"=const(true));
                column(ReportForNavId_8549; 8549)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if FADeprBook.Get("No.",FASetup."Default Depr. Book") then begin
                      FADeprBook.CalcFields("Acquisition Cost");

                      Window.Update(2,Text009);
                      Window.Update(3,"No.");

                      InsertCFLineForInvestmentFixAs;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Budgeted Fixed Asset"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    FASetup.Get;
                end;
            }
            dataitem(SaleFixedAsset;"Fixed Asset")
            {
                DataItemTableView = sorting("No.") where("Budgeted Asset"=const(false));
                column(ReportForNavId_1713; 1713)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if FADeprBook.Get("No.",FASetup."Default Depr. Book") then
                      if (FADeprBook."Disposal Date" = 0D) and
                         (FADeprBook."Projected Disposal Date" <> 0D) and
                         (FADeprBook."Projected Proceeds on Disposal" <> 0)
                      then begin
                        Window.Update(2,Text010);
                        Window.Update(3,"No.");

                        InsertCFLineForSaleFixedAsset;
                      end;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Sale of Fixed Asset"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    FASetup.Get;
                end;
            }
            dataitem("Cash Flow Manual Expense";"Cash Flow Manual Expense")
            {
                DataItemTableView = sorting(Code) order(ascending);
                column(ReportForNavId_5017; 5017)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,Text011);
                    Window.Update(3,Code);

                    InsertCFLineForManualExpens;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Cash Flow Manual Expense"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem("Cash Flow Manual Revenue";"Cash Flow Manual Revenue")
            {
                DataItemTableView = sorting(Code) order(ascending);
                column(ReportForNavId_4269; 4269)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,Text012);
                    Window.Update(3,Code);

                    InsertCFLineForManualRevenue;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Cash Flow Manual Revenue"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem(CFAccountForBudget;"Cash Flow Account")
            {
                DataItemTableView = sorting("No.") order(ascending) where("G/L Integration"=filter(Budget|Both),"G/L Account Filter"=filter(<>''));
                column(ReportForNavId_5339; 5339)
                {
                }

                trigger OnAfterGetRecord()
                var
                    GLAcc: Record "G/L Account";
                begin
                    GLAcc.SetFilter("No.","G/L Account Filter");
                    if GLAcc.FindSet then
                      repeat
                        Window.Update(2,Text031);
                        Window.Update(3,GLAcc."No.");

                        GLBudgEntry.SetRange("Budget Name",GLBudgName);
                        GLBudgEntry.SetRange("G/L Account No.",GLAcc."No.");
                        GLBudgEntry.SetRange(Date,"Cash Flow Forecast"."G/L Budget From","Cash Flow Forecast"."G/L Budget To");
                        if GLBudgEntry.FindSet then
                          repeat
                            InsertCFLineForGLBudget(GLAcc);
                          until GLBudgEntry.Next = 0;
                      until GLAcc.Next = 0;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"G/L Budget"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem("Service Line";"Service Line")
            {
                DataItemTableView = sorting("Document Type","Document No.","Line No.") where("Document Type"=const(Order));
                column(ReportForNavId_6560; 6560)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,Text032);
                    Window.Update(3,"Document No.");

                    ServiceHeader.Get("Document Type","Document No.");
                    if ServiceHeader."Bill-to Customer No." <> '' then
                      Customer.Get(ServiceHeader."Bill-to Customer No.")
                    else
                      Customer.Init;

                    InsertCFLineForServiceLine;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::"Service Orders"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;
                end;
            }
            dataitem("Job Planning Line";"Job Planning Line")
            {
                DataItemTableView = sorting("Job No.","Planning Date","Document No.");
                column(ReportForNavId_1; 1)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Window.Update(2,JobsMsg);
                    Window.Update(3,"Job No.");

                    if not ("Line Type" in ["line type"::Billable,"line type"::"Both Budget and Billable"]) then
                      exit;

                    InsertCFLineForJobPlanningLine;
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::Job] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    if not ApplicationAreaSetup.IsJobsEnabled and not ApplicationAreaSetup.IsAllDisabled then
                      CurrReport.Break;
                end;
            }
            dataitem("Purchase Header";"Purchase Header")
            {
                DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
                column(ReportForNavId_3; 3)
                {
                }

                trigger OnAfterGetRecord()
                var
                    PurchaseOrder: Page "Purchase Order";
                begin
                    Window.Update(2,PurchaseOrder.Caption);
                    Window.Update(3,"No.");

                    InsertCFLineForTax(Database::"Purchase Header");
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::Tax] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    if not ApplicationAreaSetup.IsSuiteEnabled and not ApplicationAreaSetup.IsAllDisabled then
                      CurrReport.Break;

                    CashFlowManagement.SetViewOnPurchaseHeaderForTaxCalc("Purchase Header",DummyDate);
                end;
            }
            dataitem("Sales Header";"Sales Header")
            {
                DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
                column(ReportForNavId_4; 4)
                {
                }

                trigger OnAfterGetRecord()
                var
                    SalesOrder: Page "Sales Order";
                begin
                    Window.Update(2,SalesOrder.Caption);
                    Window.Update(3,"No.");

                    InsertCFLineForTax(Database::"Sales Header");
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::Tax] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    CashFlowManagement.SetViewOnSalesHeaderForTaxCalc("Sales Header",DummyDate);
                end;
            }
            dataitem("VAT Entry";"VAT Entry")
            {
                column(ReportForNavId_2; 2)
                {
                }

                trigger OnAfterGetRecord()
                var
                    VATEntries: Page "VAT Entries";
                begin
                    Window.Update(2,VATEntries.Caption);
                    Window.Update(3,"Entry No.");

                    InsertCFLineForTax(Database::"VAT Entry");
                end;

                trigger OnPreDataItem()
                begin
                    if not ConsiderSource[Sourcetype::Tax] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    CashFlowManagement.SetViewOnVATEntryForTaxCalc("VAT Entry",DummyDate);
                end;
            }
            dataitem("Cortana Intelligence";"Cortana Intelligence")
            {
                column(ReportForNavId_5; 5)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    InsertCFLineForCortanaIntelligenceForecast(Database::"Cortana Intelligence");
                end;

                trigger OnPreDataItem()
                var
                    CashFlowForecastHandler: Codeunit "Cash Flow Forecast Handler";
                begin
                    if not ConsiderSource[Sourcetype::"Cortana Intelligence"] then
                      CurrReport.Break;

                    if not ReadPermission then
                      CurrReport.Break;

                    if not CashFlowForecastHandler.CalculateForecast then
                      CurrReport.Break;

                    SetRange(Type,Type::Forecast,Type::Correction);
                    if FindSet then;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1,"No.");
            end;

            trigger OnPostDataItem()
            var
                TempCashFlowForecast: Record "Cash Flow Forecast" temporary;
            begin
                InsertWorksheetLines(TempCashFlowForecast);
                DeleteEntries(TempCashFlowForecast);
                if NeedsManualPmtUpdate then
                  Message(ManualPmtRevExpNeedsUpdateMsg,TempCashFlowForecast."No.");
            end;

            trigger OnPreDataItem()
            begin
                SetRange("No.",CashFlowNo);
                LineNo := 0;
                NeedsManualPmtUpdate := false;
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
                    field(CashFlowNo;CashFlowNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Cash Flow Forecast';
                        TableRelation = "Cash Flow Forecast";
                        ToolTip = 'Specifies the cash flow forecast for which you want to make the calculation.';
                    }
                    group("Source Types to Include:")
                    {
                        Caption = 'Source Types to Include:';
                        field("ConsiderSource[SourceType::""Liquid Funds""]";ConsiderSource[Sourcetype::"Liquid Funds"])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Liquid Funds';
                            ToolTip = 'Specifies if you want to transfer the balances of the general ledger accounts that are defined as liquid funds.';
                        }
                        field("ConsiderSource[SourceType::Receivables]";ConsiderSource[Sourcetype::Receivables])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Receivables';
                            ToolTip = 'Specifies if you want to include open customer ledger entries in the cash flow forecast.';
                        }
                        field("ConsiderSource[SourceType::""Sales Order""]";ConsiderSource[Sourcetype::"Sales Order"])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Sales Orders';
                            ToolTip = 'Specifies if you want to include sales orders in the cash flow forecast.';
                        }
                        field("ConsiderSource[SourceType::""Service Orders""]";ConsiderSource[Sourcetype::"Service Orders"])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Service Orders';
                        }
                        field("ConsiderSource[SourceType::""Sale of Fixed Asset""]";ConsiderSource[Sourcetype::"Sale of Fixed Asset"])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Fixed Assets Disposal';
                        }
                        field("ConsiderSource[SourceType::""Cash Flow Manual Revenue""]";ConsiderSource[Sourcetype::"Cash Flow Manual Revenue"])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Cash Flow Manual Revenues';
                            ToolTip = 'Specifies if manual revenues in the cash flow forecast are included.';
                        }
                        field("ConsiderSource[SourceType::Payables]";ConsiderSource[Sourcetype::Payables])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Payables';
                            ToolTip = 'Specifies if you want to include open vendor ledger entries in the cash flow forecast.';
                        }
                        field("ConsiderSource[SourceType::""Purchase Order""]";ConsiderSource[Sourcetype::"Purchase Order"])
                        {
                            ApplicationArea = Basic;
                            Caption = 'Purchase Orders';
                        }
                        field("ConsiderSource[SourceType::""Budgeted Fixed Asset""]";ConsiderSource[Sourcetype::"Budgeted Fixed Asset"])
                        {
                            ApplicationArea = FixedAssets;
                            Caption = 'Fixed Assets Budget';
                        }
                        field("ConsiderSource[SourceType::""Cash Flow Manual Expense""]";ConsiderSource[Sourcetype::"Cash Flow Manual Expense"])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Cash Flow Manual Expenses';
                            ToolTip = 'Specifies if manual expenses in the cash flow forecast are included.';
                        }
                        field("ConsiderSource[SourceType::""G/L Budget""]";ConsiderSource[Sourcetype::"G/L Budget"])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'G/L Budget';
                            ToolTip = 'Specifies if the budget entries of the marked general ledger accounts in the cash flow forecast are included.';
                        }
                        field(GLBudgName;GLBudgName)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'G/L Budget Name';
                            TableRelation = "G/L Budget Name";
                            ToolTip = 'Specifies the name of the general ledger budget if you have selected G/L budget.';
                        }
                        field("ConsiderSource[SourceType::Job]";ConsiderSource[Sourcetype::Job])
                        {
                            ApplicationArea = Jobs;
                            Caption = 'Jobs';
                            ToolTip = 'Specifies if you want to include jobs in the cash flow forecast.';
                        }
                        field("ConsiderSource[SourceType::Tax]";ConsiderSource[Sourcetype::Tax])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Taxes';
                            ToolTip = 'Specifies if you want to include tax information in the cash flow forecast.';
                        }
                        field("ConsiderSource[SourceType::""Cortana Intelligence""]";ConsiderSource[Sourcetype::"Cortana Intelligence"])
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Cortana Intelligence Forecast';
                            ToolTip = 'Specifies whether to include Cortana Intelligence in the cash flow forecast.';
                        }
                    }
                    field(Summarized;Summarized)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Group by Document Type';
                        ToolTip = 'Specifies if the information is groups by sales orders, purchase orders, and service orders.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        var
            CFManualExpense: Record "Cash Flow Manual Expense";
            CFManualRevenue: Record "Cash Flow Manual Revenue";
            GLBudgetEntry: Record "G/L Budget Entry";
            GLAcc: Record "G/L Account";
        begin
            if ConsiderSource[Sourcetype::"Liquid Funds"] then
              ConsiderSource[Sourcetype::"Liquid Funds"] := GLAcc.ReadPermission;
            if ConsiderSource[Sourcetype::Receivables] then
              ConsiderSource[Sourcetype::Receivables] := "Cust. Ledger Entry".ReadPermission;
            if ConsiderSource[Sourcetype::Payables] then
              ConsiderSource[Sourcetype::Payables] := "Vendor Ledger Entry".ReadPermission;
            if ConsiderSource[Sourcetype::"Purchase Order"] then
              ConsiderSource[Sourcetype::"Purchase Order"] := "Purchase Line".ReadPermission;
            if ConsiderSource[Sourcetype::"Sales Order"] then
              ConsiderSource[Sourcetype::"Sales Order"] := "Sales Line".ReadPermission;
            if ConsiderSource[Sourcetype::"Cash Flow Manual Expense"] then
              ConsiderSource[Sourcetype::"Cash Flow Manual Expense"] := CFManualExpense.ReadPermission;
            if ConsiderSource[Sourcetype::"Cash Flow Manual Revenue"] then
              ConsiderSource[Sourcetype::"Cash Flow Manual Revenue"] := CFManualRevenue.ReadPermission;
            if ConsiderSource[Sourcetype::"Budgeted Fixed Asset"] then
              ConsiderSource[Sourcetype::"Budgeted Fixed Asset"] := InvestmentFixedAsset.ReadPermission;
            if ConsiderSource[Sourcetype::"Sale of Fixed Asset"] then
              ConsiderSource[Sourcetype::"Sale of Fixed Asset"] := SaleFixedAsset.ReadPermission;
            if ConsiderSource[Sourcetype::"G/L Budget"] then
              ConsiderSource[Sourcetype::"G/L Budget"] := GLBudgetEntry.ReadPermission;
            if ConsiderSource[Sourcetype::"Service Orders"] then
              ConsiderSource[Sourcetype::"Service Orders"] := "Service Line".ReadPermission;
            if ConsiderSource[Sourcetype::Job] then
              ConsiderSource[Sourcetype::Job] := "Job Planning Line".ReadPermission;
            if ConsiderSource[Sourcetype::Tax] then
              ConsiderSource[Sourcetype::Tax] := "Sales Header".ReadPermission and
                "Purchase Header".ReadPermission and "VAT Entry".ReadPermission;
            if ConsiderSource[Sourcetype::"Cortana Intelligence"] then
              ConsiderSource[Sourcetype::"Cortana Intelligence"] := "Cortana Intelligence".ReadPermission;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if CashFlowNo = '' then
          Error(Text000);

        if not SelectionCashFlowForecast.Get(CashFlowNo) then
          Error(Text001);

        if NoOptionsChosen then
          Error(Text002,CashFlowNo);

        CFSetup.Get;
        GLSetup.Get;

        Window.Open(
          Text003 +
          Text033 +
          Text034);

        Window.Update(1,"Cash Flow Forecast"."No.");
    end;

    var
        Text000: label 'You must choose a cash flow forecast.';
        Text001: label 'Choose a valid cash flow forecast.';
        Text002: label 'Choose one option for filling the cash flow forecast no. %1.';
        Text003: label 'Cash Flow Forecast No.      #1##########\\';
        Text004: label 'Liquid Funds';
        Text005: label 'Receivables';
        Text006: label 'Payables';
        Text007: label 'Purchase Orders';
        Text008: label 'Sales Orders';
        Text009: label 'Fixed Assets Budget';
        Text010: label 'Fixed Assets Disposal';
        Text011: label 'Cash Flow Manual Expenses';
        Text012: label 'Cash Flow Manual Revenues';
        Text013: label '%1 Balance=%2';
        Text025: label '%1 %2 %3';
        Text027: label '%1 AC= %2';
        Text028: label 'Cash Flow Manual Expenses %1';
        Text029: label 'Cash Flow Manual Revenues %1';
        Text030: label '%1 Budget %2 ';
        Text031: label 'G/L Budget';
        Text032: label 'Service Orders';
        Text033: label 'Search for                  #2####################\';
        Text034: label 'Record found                #3####################';
        ApplicationAreaSetup: Record "Application Area Setup";
        CFSetup: Record "Cash Flow Setup";
        SelectionCashFlowForecast: Record "Cash Flow Forecast";
        TempCFWorksheetLine: Record "Cash Flow Worksheet Line" temporary;
        CFWorksheetLine2: Record "Cash Flow Worksheet Line";
        Customer: Record Customer;
        Vendor: Record Vendor;
        PurchHeader: Record "Purchase Header";
        SalesHeader: Record "Sales Header";
        ServiceHeader: Record "Service Header";
        FASetup: Record "FA Setup";
        FADeprBook: Record "FA Depreciation Book";
        GLBudgEntry: Record "G/L Budget Entry";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        CashFlowManagement: Codeunit "Cash Flow Management";
        Window: Dialog;
        ConsiderSource: array [16] of Boolean;
        SourceType: Option ,Receivables,Payables,"Liquid Funds","Cash Flow Manual Expense","Cash Flow Manual Revenue","Sales Order","Purchase Order","Budgeted Fixed Asset","Sale of Fixed Asset","Service Orders","G/L Budget",,,Job,Tax,"Cortana Intelligence";
        CashFlowNo: Code[20];
        LineNo: Integer;
        DateLastExecution: Date;
        ExecutionDate: Date;
        GLBudgName: Code[10];
        TotalAmt: Decimal;
        MultiSalesLines: Boolean;
        Summarized: Boolean;
        NeedsManualPmtUpdate: Boolean;
        ManualPmtRevExpNeedsUpdateMsg: label 'There are one or more Cash Flow Manual Revenues/Expenses with a Recurring Frequency.\But the Recurring Frequency cannot be applied because the Manual Payments To date in Cash Flow Forecast %1 is empty.\Fill in this date in order to get multiple lines.';
        JobsMsg: label 'Jobs';
        PostedSalesDocumentDescriptionTxt: label 'Posted Sales %1 - %2 %3', Comment='%1 = Source Document Type (e.g. Invoice), %2 = Due Date, %3 = Source Name (e.g. Customer Name). Example: Posted Sales Invoice - 04-05-18 The Cannon Group PLC';
        PostedPurchaseDocumentDescriptionTxt: label 'Posted Purchase %1 - %2 %3', Comment='%1 = Source Document Type (e.g. Invoice), %2 = Due Date, %3 = Source Name (e.g. Vendor Name). Example: Posted Purchase Invoice - 04-05-18 The Cannon Group PLC';
        SalesDocumentDescriptionTxt: label 'Sales %1 - %2 %3', Comment='%1 = Source Document Type (e.g. Invoice), %2 = Due Date, %3 = Source Name (e.g. Customer Name). Example: Sales Invoice - 04-05-18 The Cannon Group PLC';
        PurchaseDocumentDescriptionTxt: label 'Purchase %1 - %2 %3', Comment='%1 = Source Document Type (e.g. Invoice), %2 = Due Date, %3 = Source Name (e.g. Vendor Name). Example: Purchase Invoice - 04-05-18 The Cannon Group PLC';
        ServiceDocumentDescriptionTxt: label 'Service %1 - %2 %3', Comment='%1 = Source Document Type (e.g. Invoice), %2 = Due Date, %3 = Source Name (e.g. Customer Name). Example: Service Invoice - 04-05-18 The Cannon Group PLC';
        TaxForMsg: label 'Taxes from %1', Comment='%1 = The description of the source tyoe based on which taxes are calculated.';
        DummyDate: Date;
        TaxLastSourceTableNumProcessed: Integer;
        TaxLastPayableDateProcessed: Date;
        CortanaForecastDescriptionTxt: label 'Predicted %1 for the period starting from %2 with precision of +/-  %3.', Comment='%1 =RECEIVABLES or PAYABLES, %2 = Date; %3 Percentage';
        CortanaCorrectionDescriptionTxt: label 'Correction due to posted %1', Comment='%1 = SALES ORDERS or PURCHASE ORDERS';
        CortanaOrdersCorrectionDescriptionTxt: label 'Correction due to %1', Comment='%1 = SALES or PURCHASE';
        XRECEIVABLESTxt: label 'RECEIVABLES', Comment='{locked}';
        XPAYABLESTxt: label 'PAYABLES', Comment='{locked}';
        XPAYABLESCORRECTIONTxt: label 'Payables Correction';
        XRECEIVABLESCORRECTIONTxt: label 'Receivables Correction';
        XSALESORDERSTxt: label 'Sales Orders';
        XPURCHORDERSTxt: label 'Purchase Orders';

    local procedure InsertConditionMet(): Boolean
    begin
        exit(TempCFWorksheetLine."Amount (LCY)" <> 0);
    end;

    local procedure InsertTempCFWorksheetLine(MaxPmtTolerance: Decimal)
    begin
        with TempCFWorksheetLine do begin
          LineNo := LineNo + 100;
          TransferFields(CFWorksheetLine2);
          "Cash Flow Forecast No." := "Cash Flow Forecast"."No.";
          "Line No." := LineNo;

          CalculateCFAmountAndCFDate;
          SetCashFlowDate(TempCFWorksheetLine,"Cash Flow Date");

          if Abs("Amount (LCY)") < Abs(MaxPmtTolerance) then
            "Amount (LCY)" := 0
          else
            "Amount (LCY)" := "Amount (LCY)" - MaxPmtTolerance;

          if InsertConditionMet then
            Insert
        end;
    end;

    local procedure InsertWorksheetLines(var TempCashFlowForecast: Record "Cash Flow Forecast" temporary)
    var
        CFWorksheetLine: Record "Cash Flow Worksheet Line";
        LastCFForecastNo: Code[20];
    begin
        CFWorksheetLine.LockTable;

        CFWorksheetLine.Reset;
        CFWorksheetLine.DeleteAll;

        TempCFWorksheetLine.Reset;
        TempCFWorksheetLine.SetCurrentkey("Cash Flow Forecast No.");
        if TempCFWorksheetLine.FindSet then
          repeat
            CFWorksheetLine := TempCFWorksheetLine;
            CFWorksheetLine.Insert(true);

            if LastCFForecastNo <> CFWorksheetLine."Cash Flow Forecast No." then begin
              TempCashFlowForecast."No." := CFWorksheetLine."Cash Flow Forecast No.";
              TempCashFlowForecast.Insert;
              LastCFForecastNo := CFWorksheetLine."Cash Flow Forecast No.";
            end;
          until TempCFWorksheetLine.Next = 0;

        TempCFWorksheetLine.DeleteAll;
    end;

    local procedure DeleteEntries(var TempCashFlowForecast: Record "Cash Flow Forecast" temporary)
    var
        CFForecastEntry: Record "Cash Flow Forecast Entry";
    begin
        TempCashFlowForecast.Reset;
        if TempCashFlowForecast.FindSet then begin
          CFForecastEntry.LockTable;
          CFForecastEntry.Reset;
          repeat
            CFForecastEntry.SetRange("Cash Flow Forecast No.",TempCashFlowForecast."No.");
            CFForecastEntry.DeleteAll;
          until TempCashFlowForecast.Next = 0;
        end;
        TempCashFlowForecast.DeleteAll;
    end;

    local procedure InsertCFLineForGLAccount(GLAcc: Record "G/L Account")
    begin
        with CFWorksheetLine2 do begin
          Init;
          "Source Type" := "source type"::"Liquid Funds";
          "Source No." := GLAcc."No.";
          "Document No." := GLAcc."No.";
          "Cash Flow Account No." := "Cash Flow Account"."No.";
          Description :=
            CopyStr(
              StrSubstNo(Text013,GLAcc.Name,Format(GLAcc.Balance)),
              1,MaxStrLen(Description));
          SetCashFlowDate(CFWorksheetLine2,WorkDate);
          "Amount (LCY)" := GLAcc.Balance;
          "Shortcut Dimension 2 Code" := GLAcc."Global Dimension 2 Code";
          "Shortcut Dimension 1 Code" := GLAcc."Global Dimension 1 Code";
          MoveDefualtDimToJnlLineDim(Database::"G/L Account",GLAcc."No.","Dimension Set ID");
          InsertTempCFWorksheetLine(0);
        end;
    end;

    local procedure InsertCFLineForCustLedgerEntry()
    var
        MaxPmtTolerance: Decimal;
    begin
        with CFWorksheetLine2 do begin
          Init;
          "Source Type" := "source type"::Receivables;
          "Source No." := "Cust. Ledger Entry"."Document No.";
          "Document Type" := "Cust. Ledger Entry"."Document Type";
          "Document Date" := "Cust. Ledger Entry"."Document Date";
          "Shortcut Dimension 2 Code" := "Cust. Ledger Entry"."Global Dimension 2 Code";
          "Shortcut Dimension 1 Code" := "Cust. Ledger Entry"."Global Dimension 1 Code";
          "Dimension Set ID" := "Cust. Ledger Entry"."Dimension Set ID";
          "Cash Flow Account No." := CFSetup."Receivables CF Account No.";
          Description := CopyStr(
              StrSubstNo(PostedSalesDocumentDescriptionTxt,
                Format("Document Type"),
                Format("Cust. Ledger Entry"."Due Date"),
                Customer.Name),
              1,MaxStrLen(Description));
          "Document No." := "Cust. Ledger Entry"."Document No.";
          SetCashFlowDate(CFWorksheetLine2,"Cust. Ledger Entry"."Due Date");
          "Amount (LCY)" := "Cust. Ledger Entry"."Remaining Amt. (LCY)";
          "Pmt. Discount Date" := "Cust. Ledger Entry"."Pmt. Discount Date";
          "Pmt. Disc. Tolerance Date" := "Cust. Ledger Entry"."Pmt. Disc. Tolerance Date";

          if "Cust. Ledger Entry"."Currency Code" <> '' then
            Currency.Get("Cust. Ledger Entry"."Currency Code")
          else
            Currency.InitRoundingPrecision;

          "Payment Discount" := ROUND("Cust. Ledger Entry"."Remaining Pmt. Disc. Possible" /
              "Cust. Ledger Entry"."Adjusted Currency Factor",Currency."Amount Rounding Precision");

          if "Cash Flow Forecast"."Consider Pmt. Tol. Amount" then
            MaxPmtTolerance := ROUND("Cust. Ledger Entry"."Max. Payment Tolerance" /
                "Cust. Ledger Entry"."Adjusted Currency Factor",Currency."Amount Rounding Precision")
          else
            MaxPmtTolerance := 0;

          if "Cash Flow Forecast"."Consider CF Payment Terms" and (Customer."Cash Flow Payment Terms Code" <> '') then
            "Payment Terms Code" := Customer."Cash Flow Payment Terms Code"
          else
            "Payment Terms Code" := '';

          InsertTempCFWorksheetLine(MaxPmtTolerance);
        end;
    end;

    local procedure InsertCFLineForVendorLedgEntry()
    var
        MaxPmtTolerance: Decimal;
    begin
        with CFWorksheetLine2 do begin
          Init;
          "Source Type" := "source type"::Payables;
          "Source No." := "Vendor Ledger Entry"."Document No.";
          "Document Type" := "Vendor Ledger Entry"."Document Type";
          "Document Date" := "Vendor Ledger Entry"."Document Date";
          "Shortcut Dimension 2 Code" := "Vendor Ledger Entry"."Global Dimension 2 Code";
          "Shortcut Dimension 1 Code" := "Vendor Ledger Entry"."Global Dimension 1 Code";
          "Dimension Set ID" := "Vendor Ledger Entry"."Dimension Set ID";
          "Cash Flow Account No." := CFSetup."Payables CF Account No.";
          Description := CopyStr(
              StrSubstNo(PostedPurchaseDocumentDescriptionTxt,
                Format("Document Type"),
                Format("Vendor Ledger Entry"."Due Date"),
                Vendor.Name),
              1,MaxStrLen(Description));
          SetCashFlowDate(CFWorksheetLine2,"Vendor Ledger Entry"."Due Date");
          "Document No." := "Vendor Ledger Entry"."Document No.";
          "Amount (LCY)" := "Vendor Ledger Entry"."Remaining Amt. (LCY)";
          "Pmt. Discount Date" := "Vendor Ledger Entry"."Pmt. Discount Date";
          "Pmt. Disc. Tolerance Date" := "Vendor Ledger Entry"."Pmt. Disc. Tolerance Date";

          if "Vendor Ledger Entry"."Currency Code" <> '' then
            Currency.Get("Vendor Ledger Entry"."Currency Code")
          else
            Currency.InitRoundingPrecision;

          "Payment Discount" := ROUND("Vendor Ledger Entry"."Remaining Pmt. Disc. Possible" /
              "Vendor Ledger Entry"."Adjusted Currency Factor",Currency."Amount Rounding Precision");

          if "Cash Flow Forecast"."Consider Pmt. Tol. Amount" then
            MaxPmtTolerance := ROUND("Vendor Ledger Entry"."Max. Payment Tolerance" /
                "Vendor Ledger Entry"."Adjusted Currency Factor",Currency."Amount Rounding Precision")
          else
            MaxPmtTolerance := 0;

          if "Cash Flow Forecast"."Consider CF Payment Terms" and (Vendor."Cash Flow Payment Terms Code" <> '') then
            "Payment Terms Code" := Vendor."Cash Flow Payment Terms Code"
          else
            "Payment Terms Code" := '';

          InsertTempCFWorksheetLine(MaxPmtTolerance);
        end;
    end;

    local procedure InsertCFLineForPurchaseLine()
    var
        PurchLine2: Record "Purchase Line";
    begin
        PurchLine2 := "Purchase Line";
        if Summarized and (PurchLine2.Next <> 0) and (PurchLine2."Buy-from Vendor No." <> '') and
           (PurchLine2."Document No." = "Purchase Line"."Document No.")
        then begin
          TotalAmt += CalculateLineAmountForPurchaseLine(PurchHeader,"Purchase Line");
          MultiSalesLines := true;
        end else
          with CFWorksheetLine2 do begin
            Init;
            "Source Type" := "source type"::"Purchase Orders";
            "Source No." := "Purchase Line"."Document No.";
            "Document Type" := "document type"::Invoice;
            "Document Date" := PurchHeader."Document Date";
            "Shortcut Dimension 1 Code" := PurchHeader."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := PurchHeader."Shortcut Dimension 2 Code";
            "Dimension Set ID" := PurchHeader."Dimension Set ID";
            "Cash Flow Account No." := CFSetup."Purch. Order CF Account No.";
            Description :=
              CopyStr(
                StrSubstNo(
                  PurchaseDocumentDescriptionTxt,
                  PurchHeader."Document Type",
                  Format(PurchHeader."Order Date"),
                  PurchHeader."Buy-from Vendor Name"),
                1,MaxStrLen(Description));
            SetCashFlowDate(CFWorksheetLine2,PurchHeader."Due Date");
            "Document No." := "Purchase Line"."Document No.";
            "Amount (LCY)" := CalculateLineAmountForPurchaseLine(PurchHeader,"Purchase Line");

            if Summarized and MultiSalesLines then begin
              "Amount (LCY)" := "Amount (LCY)" + TotalAmt;
              MultiSalesLines := false;
              TotalAmt := 0;
            end;

            if "Cash Flow Forecast"."Consider CF Payment Terms" and (Vendor."Cash Flow Payment Terms Code" <> '') then
              "Payment Terms Code" := Vendor."Cash Flow Payment Terms Code"
            else
              "Payment Terms Code" := PurchHeader."Payment Terms Code";

            InsertTempCFWorksheetLine(0);
          end;
    end;

    local procedure InsertCFLineForSalesLine()
    var
        SalesLine2: Record "Sales Line";
    begin
        SalesLine2 := "Sales Line";
        if Summarized and (SalesLine2.Next <> 0) and (SalesLine2."Sell-to Customer No." <> '') and
           (SalesLine2."Document No." = "Sales Line"."Document No.")
        then begin
          TotalAmt += CalculateLineAmountForSalesLine(SalesHeader,"Sales Line");
          MultiSalesLines := true;
        end else
          with CFWorksheetLine2 do begin
            Init;
            "Document Type" := "document type"::Invoice;
            "Document Date" := SalesHeader."Document Date";
            "Source Type" := "source type"::"Sales Orders";
            "Source No." := "Sales Line"."Document No.";
            "Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
            "Dimension Set ID" := SalesHeader."Dimension Set ID";
            "Cash Flow Account No." := CFSetup."Sales Order CF Account No.";
            Description :=
              CopyStr(
                StrSubstNo(
                  SalesDocumentDescriptionTxt,
                  SalesHeader."Document Type",
                  Format(SalesHeader."Order Date"),
                  SalesHeader."Sell-to Customer Name"),
                1,MaxStrLen(Description));
            SetCashFlowDate(CFWorksheetLine2,SalesHeader."Due Date");
            "Document No." := "Sales Line"."Document No.";
            "Amount (LCY)" := CalculateLineAmountForSalesLine(SalesHeader,"Sales Line");

            if Summarized and MultiSalesLines then begin
              "Amount (LCY)" := "Amount (LCY)" + TotalAmt;
              MultiSalesLines := false;
              TotalAmt := 0;
            end;

            if "Cash Flow Forecast"."Consider CF Payment Terms" and (Customer."Cash Flow Payment Terms Code" <> '') then
              "Payment Terms Code" := Customer."Cash Flow Payment Terms Code"
            else
              "Payment Terms Code" := SalesHeader."Payment Terms Code";

            InsertTempCFWorksheetLine(0);
          end;
    end;

    local procedure InsertCFLineForInvestmentFixAs()
    begin
        with CFWorksheetLine2 do begin
          Init;
          "Source Type" := "source type"::"Fixed Assets Budget";
          "Source No." := InvestmentFixedAsset."No.";
          "Document No." := InvestmentFixedAsset."No.";
          "Cash Flow Account No." := CFSetup."FA Budget CF Account No.";
          Description :=
            CopyStr(
              StrSubstNo(
                Text027,InvestmentFixedAsset."No.",Format(-FADeprBook."Acquisition Cost")),
              1,MaxStrLen(Description));
          SetCashFlowDate(CFWorksheetLine2,FADeprBook."Acquisition Date");
          "Amount (LCY)" := -FADeprBook."Acquisition Cost";
          "Shortcut Dimension 2 Code" := InvestmentFixedAsset."Global Dimension 2 Code";
          "Shortcut Dimension 1 Code" := InvestmentFixedAsset."Global Dimension 1 Code";
          MoveDefualtDimToJnlLineDim(Database::"Fixed Asset",InvestmentFixedAsset."No.","Dimension Set ID");
          InsertTempCFWorksheetLine(0);
        end;
    end;

    local procedure InsertCFLineForSaleFixedAsset()
    begin
        with CFWorksheetLine2 do begin
          Init;
          "Source Type" := "source type"::"Fixed Assets Disposal";
          "Source No." := SaleFixedAsset."No.";
          "Document No." := SaleFixedAsset."No.";
          "Cash Flow Account No." := CFSetup."FA Disposal CF Account No.";
          Description :=
            CopyStr(
              StrSubstNo(
                Text027,SaleFixedAsset."No.",Format(FADeprBook."Projected Proceeds on Disposal")),
              1,MaxStrLen(Description));
          SetCashFlowDate(CFWorksheetLine2,FADeprBook."Projected Disposal Date");
          "Amount (LCY)" := FADeprBook."Projected Proceeds on Disposal" ;
          "Shortcut Dimension 2 Code" := SaleFixedAsset."Global Dimension 2 Code";
          "Shortcut Dimension 1 Code" := SaleFixedAsset."Global Dimension 1 Code";
          MoveDefualtDimToJnlLineDim(Database::"Fixed Asset",SaleFixedAsset."No.","Dimension Set ID");
          InsertTempCFWorksheetLine(0);
        end;
    end;

    local procedure InsertCFLineForManualExpens()
    begin
        with CFWorksheetLine2 do begin
          "Cash Flow Manual Expense".TestField("Starting Date");
          Init;
          "Source Type" := "source type"::"Cash Flow Manual Expense";
          "Source No." := "Cash Flow Manual Expense".Code;
          "Document No." := "Cash Flow Manual Expense".Code;
          "Cash Flow Account No." := "Cash Flow Manual Expense"."Cash Flow Account No.";
          "Shortcut Dimension 1 Code" := "Cash Flow Manual Expense"."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code" := "Cash Flow Manual Expense"."Global Dimension 2 Code";
          MoveDefualtDimToJnlLineDim(Database::"Cash Flow Manual Expense","Cash Flow Manual Expense".Code,"Dimension Set ID");
          Description := CopyStr(StrSubstNo(Text028,"Cash Flow Manual Expense".Description),1,MaxStrLen(Description));
          DateLastExecution := "Cash Flow Forecast"."Manual Payments To";
          if ("Cash Flow Manual Expense"."Ending Date" <> 0D) and
             ("Cash Flow Manual Expense"."Ending Date" < "Cash Flow Forecast"."Manual Payments To")
          then
            DateLastExecution := "Cash Flow Manual Expense"."Ending Date";
          ExecutionDate := "Cash Flow Manual Expense"."Starting Date";
          if Format("Cash Flow Manual Expense"."Recurring Frequency") <> '' then begin
            if DateLastExecution = 0D then begin
              NeedsManualPmtUpdate := true;
              InsertManualData(
                ExecutionDate,"Cash Flow Forecast",-"Cash Flow Manual Expense".Amount);
            end else
              while ExecutionDate <= DateLastExecution do begin
                InsertManualData(
                  ExecutionDate,"Cash Flow Forecast",-"Cash Flow Manual Expense".Amount);
                ExecutionDate := CalcDate("Cash Flow Manual Expense"."Recurring Frequency",ExecutionDate);
              end;
          end else
            InsertManualData(ExecutionDate,"Cash Flow Forecast",-"Cash Flow Manual Expense".Amount);
        end;
    end;

    local procedure InsertCFLineForManualRevenue()
    begin
        with CFWorksheetLine2 do begin
          "Cash Flow Manual Revenue".TestField("Starting Date");
          Init;
          "Source Type" := "source type"::"Cash Flow Manual Revenue";
          "Source No." := "Cash Flow Manual Revenue".Code;
          "Document No." := "Cash Flow Manual Revenue".Code;
          "Cash Flow Account No." := "Cash Flow Manual Revenue"."Cash Flow Account No.";
          "Shortcut Dimension 1 Code" := "Cash Flow Manual Revenue"."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code" := "Cash Flow Manual Revenue"."Global Dimension 2 Code";
          MoveDefualtDimToJnlLineDim(Database::"Cash Flow Manual Revenue","Cash Flow Manual Revenue".Code,"Dimension Set ID");
          Description := CopyStr(StrSubstNo(Text029,"Cash Flow Manual Revenue".Description),1,MaxStrLen(Description));
          DateLastExecution := "Cash Flow Forecast"."Manual Payments To";
          if ("Cash Flow Manual Revenue"."Ending Date" <> 0D) and
             ("Cash Flow Manual Revenue"."Ending Date" < "Cash Flow Forecast"."Manual Payments To")
          then
            DateLastExecution := "Cash Flow Manual Revenue"."Ending Date";
          ExecutionDate := "Cash Flow Manual Revenue"."Starting Date";
          if Format("Cash Flow Manual Revenue"."Recurring Frequency") <> '' then begin
            if DateLastExecution = 0D then begin
              NeedsManualPmtUpdate := true;
              InsertManualData(
                ExecutionDate,"Cash Flow Forecast","Cash Flow Manual Revenue".Amount);
            end else
              while ExecutionDate <= DateLastExecution do begin
                InsertManualData(
                  ExecutionDate,"Cash Flow Forecast","Cash Flow Manual Revenue".Amount);
                ExecutionDate := CalcDate("Cash Flow Manual Revenue"."Recurring Frequency",ExecutionDate);
              end;
          end else
            InsertManualData(ExecutionDate,"Cash Flow Forecast","Cash Flow Manual Revenue".Amount);
        end;
    end;

    local procedure InsertCFLineForGLBudget(GLAcc: Record "G/L Account")
    begin
        with CFWorksheetLine2 do begin
          Init;
          "Source Type" := "source type"::"G/L Budget";
          "Source No." := GLAcc."No.";
          "G/L Budget Name" := GLBudgEntry."Budget Name";
          "Document No." := Format(GLBudgEntry."Entry No.");
          "Cash Flow Account No." := CFAccountForBudget."No.";
          Description :=
            CopyStr(
              StrSubstNo(
                Text030,GLAcc.Name,Format(GLBudgEntry.Description)),
              1,MaxStrLen(Description));
          SetCashFlowDate(CFWorksheetLine2,GLBudgEntry.Date);
          "Amount (LCY)" := -GLBudgEntry.Amount;
          "Shortcut Dimension 1 Code" := GLBudgEntry."Global Dimension 1 Code";
          "Shortcut Dimension 2 Code" := GLBudgEntry."Global Dimension 2 Code";
          "Dimension Set ID" := GLBudgEntry."Dimension Set ID";
          InsertTempCFWorksheetLine(0);
        end;
    end;

    local procedure InsertCFLineForServiceLine()
    var
        ServiceLine2: Record "Service Line";
    begin
        ServiceLine2 := "Service Line";
        if Summarized and (ServiceLine2.Next <> 0) and (ServiceLine2."Customer No." <> '') and
           (ServiceLine2."Document No." = "Service Line"."Document No.")
        then begin
          TotalAmt += CalculateLineAmountForServiceLine("Service Line");

          MultiSalesLines := true;
        end else
          with CFWorksheetLine2 do begin
            Init;
            "Source Type" := "source type"::"Service Orders";
            "Source No." := "Service Line"."Document No.";
            "Document Type" := "document type"::Invoice;
            "Document Date" := ServiceHeader."Document Date";
            "Shortcut Dimension 1 Code" := ServiceHeader."Shortcut Dimension 1 Code";
            "Shortcut Dimension 2 Code" := ServiceHeader."Shortcut Dimension 2 Code";
            "Dimension Set ID" := ServiceHeader."Dimension Set ID";
            "Cash Flow Account No." := CFSetup."Service CF Account No.";
            Description :=
              CopyStr(
                StrSubstNo(
                  ServiceDocumentDescriptionTxt,
                  ServiceHeader."Document Type",
                  ServiceHeader.Name,
                  Format(ServiceHeader."Order Date")),
                1,MaxStrLen(Description));
            SetCashFlowDate(CFWorksheetLine2,ServiceHeader."Due Date");
            "Document No." := "Service Line"."Document No.";
            "Amount (LCY)" := CalculateLineAmountForServiceLine("Service Line");

            if Summarized and MultiSalesLines then begin
              "Amount (LCY)" := "Amount (LCY)" + TotalAmt;
              MultiSalesLines := false;
              TotalAmt := 0;
            end;

            if "Cash Flow Forecast"."Consider CF Payment Terms" and (Customer."Cash Flow Payment Terms Code" <> '') then
              "Payment Terms Code" := Customer."Cash Flow Payment Terms Code"
            else
              "Payment Terms Code" := ServiceHeader."Payment Terms Code";

            InsertTempCFWorksheetLine(0);
          end;
    end;

    local procedure InsertCFLineForJobPlanningLine()
    var
        JobPlanningLine2: Record "Job Planning Line";
        Job: Record Job;
        InsertConditionHasBeenMetAlready: Boolean;
    begin
        JobPlanningLine2 := "Job Planning Line";
        if Summarized and (JobPlanningLine2.Next <> 0) and
           (JobPlanningLine2."Job Task No." = "Job Planning Line"."Job Task No.")
        then begin
          TotalAmt += GetJobPlanningAmountForCFLine("Job Planning Line");

          MultiSalesLines := true;
        end else
          if (TempCFWorksheetLine."Source Type" = TempCFWorksheetLine."source type"::Job) and
             ("Job Planning Line"."Job No." = TempCFWorksheetLine."Source No.") and
             ("Job Planning Line"."Planning Date" = TempCFWorksheetLine."Document Date") and
             ("Job Planning Line"."Document No." = TempCFWorksheetLine."Document No.")
          then begin
            InsertConditionHasBeenMetAlready := InsertConditionMet;
            TempCFWorksheetLine."Amount (LCY)" += GetJobPlanningAmountForCFLine("Job Planning Line");
            InsertOrModifyCFLine(InsertConditionHasBeenMetAlready);
          end else
            with CFWorksheetLine2 do begin
              Init;
              "Source Type" := "source type"::Job;
              "Source No." := "Job Planning Line"."Job No.";
              "Document Type" := "document type"::Invoice;
              "Document Date" := "Job Planning Line"."Planning Date";

              Job.Get("Job Planning Line"."Job No.");
              "Shortcut Dimension 1 Code" := Job."Global Dimension 1 Code";
              "Shortcut Dimension 2 Code" := Job."Global Dimension 2 Code";
              "Cash Flow Account No." := CFSetup."Job CF Account No.";
              Description :=
                CopyStr(
                  StrSubstNo(
                    Text025,
                    Job.TableCaption,
                    Job.Description,
                    Format("Job Planning Line"."Document Date")),
                  1,MaxStrLen(Description));
              SetCashFlowDate(CFWorksheetLine2,"Job Planning Line"."Planning Date");
              "Document No." := "Job Planning Line"."Document No.";
              "Amount (LCY)" := GetJobPlanningAmountForCFLine("Job Planning Line");

              if Summarized and MultiSalesLines then begin
                "Amount (LCY)" := "Amount (LCY)" + TotalAmt;
                MultiSalesLines := false;
                TotalAmt := 0;
              end;

              InsertTempCFWorksheetLine(0);
            end;
    end;

    local procedure InsertCFLineForTax(SourceTableNum: Integer)
    var
        TaxPayableDate: Date;
        SourceNo: Code[20];
        InsertConditionHasBeenMetAlready: Boolean;
    begin
        TaxPayableDate := GetTaxPayableDateFromSource(SourceTableNum);
        if IsDateBeforeStartOfCurrentPeriod(TaxPayableDate) or HasTaxBeenPaidOn(TaxPayableDate) then
          exit;
        SourceNo := Format(SourceTableNum);
        if Summarized and (TaxLastSourceTableNumProcessed <> SourceTableNum) and
           (TaxLastPayableDateProcessed <> TaxPayableDate)
        then begin
          TotalAmt += GetTaxAmountFromSource(SourceTableNum);
          MultiSalesLines := true;
        end else
          if (TempCFWorksheetLine."Source Type" = TempCFWorksheetLine."source type"::Tax) and
             (TempCFWorksheetLine."Source No." = SourceNo) and
             (TempCFWorksheetLine."Document Date" = TaxPayableDate)
          then begin
            InsertConditionHasBeenMetAlready := InsertConditionMet;
            TempCFWorksheetLine."Amount (LCY)" += GetTaxAmountFromSource(SourceTableNum);
            InsertOrModifyCFLine(InsertConditionHasBeenMetAlready);
          end else
            with CFWorksheetLine2 do begin
              Init;
              "Source Type" := "source type"::Tax;
              "Source No." := SourceNo;
              "Document Type" := "document type"::" ";
              "Document Date" := TaxPayableDate;

              "Shortcut Dimension 1 Code" := '';
              "Shortcut Dimension 2 Code" := '';
              "Cash Flow Account No." := CFSetup."Tax CF Account No.";
              Description := GetDescriptionForTaxCashFlowLine(SourceTableNum);
              SetCashFlowDate(CFWorksheetLine2,"Document Date");
              "Document No." := '';
              "Amount (LCY)" := GetTaxAmountFromSource(SourceTableNum);

              if Summarized and MultiSalesLines and (TaxLastSourceTableNumProcessed = SourceTableNum) then begin
                "Amount (LCY)" := "Amount (LCY)" + TotalAmt;
                MultiSalesLines := false;
                TotalAmt := 0;
              end;

              InsertTempCFWorksheetLine(0);
            end;

        TaxLastSourceTableNumProcessed := SourceTableNum;
        TaxLastPayableDateProcessed := TaxPayableDate;
    end;

    local procedure InsertCFLineForCortanaIntelligenceForecast(SourceTableNum: Integer)
    begin
        if "Cortana Intelligence"."Delta %" > CFSetup."Variance %" then
          exit;

        with CFWorksheetLine2 do begin
          Init;
          "Source Type" := "source type"::"Cortana Intelligence";
          "Source No." := Format(SourceTableNum);
          "Document Type" := "document type"::" ";
          "Document Date" := "Cortana Intelligence"."Period Start";
          SetCashFlowDate(CFWorksheetLine2,"Document Date");
          "Amount (LCY)" := "Cortana Intelligence".Amount;

          case "Cortana Intelligence"."Group Id" of
            XRECEIVABLESTxt:
              begin
                "Cash Flow Account No." := CFSetup."Receivables CF Account No.";
                Description :=
                  StrSubstNo(
                    CortanaForecastDescriptionTxt,XRECEIVABLESTxt,"Cortana Intelligence"."Period Start",
                    ROUND("Cortana Intelligence".Delta));
              end;
            XPAYABLESTxt:
              begin
                "Cash Flow Account No." := CFSetup."Payables CF Account No.";
                Description :=
                  StrSubstNo(
                    CortanaForecastDescriptionTxt,XPAYABLESTxt,"Cortana Intelligence"."Period Start",
                    ROUND("Cortana Intelligence".Delta));
              end;
            XPAYABLESCORRECTIONTxt:
              if ConsiderSource["source type"::Payables] then begin
                "Cash Flow Account No." := CFSetup."Payables CF Account No.";
                Description := StrSubstNo(CortanaCorrectionDescriptionTxt,XPAYABLESTxt);
              end else
                exit;
            XRECEIVABLESCORRECTIONTxt:
              if ConsiderSource["source type"::Receivables] then begin
                "Cash Flow Account No." := CFSetup."Receivables CF Account No.";
                Description := StrSubstNo(CortanaCorrectionDescriptionTxt,XRECEIVABLESTxt)
              end else
                exit;
            XPURCHORDERSTxt:
              if ConsiderSource["source type"::"Purchase Orders"] then begin
                "Cash Flow Account No." := CFSetup."Purch. Order CF Account No.";
                Description := StrSubstNo(CortanaOrdersCorrectionDescriptionTxt,XPURCHORDERSTxt)
              end else
                exit;
            XSALESORDERSTxt:
              if ConsiderSource["source type"::"Sales Orders"] then begin
                "Cash Flow Account No." := CFSetup."Sales Order CF Account No.";
                Description := StrSubstNo(CortanaOrdersCorrectionDescriptionTxt,XSALESORDERSTxt)
              end else
                exit;
          end;
        end;

        InsertTempCFWorksheetLine(0);
    end;

    local procedure InsertOrModifyCFLine(InsertConditionHasBeenMetAlready: Boolean)
    begin
        CFWorksheetLine2."Amount (LCY)" += TempCFWorksheetLine."Amount (LCY)";
        if InsertConditionHasBeenMetAlready then
          TempCFWorksheetLine.Modify
        else
          InsertTempCFWorksheetLine(0);
    end;

    local procedure GetSubPostingGLAccounts(var GLAccount: Record "G/L Account";var TempGLAccount: Record "G/L Account" temporary)
    var
        SubGLAccount: Record "G/L Account";
    begin
        if not GLAccount.FindSet then
          exit;

        repeat
          case GLAccount."Account Type" of
            GLAccount."account type"::Posting:
              begin
                TempGLAccount.Init;
                TempGLAccount.TransferFields(GLAccount);
                if TempGLAccount.Insert then;
              end;
            GLAccount."account type"::"End-Total",
            GLAccount."account type"::Total:
              begin
                SubGLAccount.SetFilter("No.",GLAccount.Totaling);
                SubGLAccount.FilterGroup := 2;
                SubGLAccount.SetFilter("No.",'<>%1',GLAccount."No.");
                GetSubPostingGLAccounts(SubGLAccount,TempGLAccount);
              end;
          end;
        until GLAccount.Next = 0;
    end;

    local procedure SetCashFlowDate(var CashFlowWorksheetLine: Record "Cash Flow Worksheet Line";CashFlowDate: Date)
    begin
        CashFlowWorksheetLine."Cash Flow Date" := CashFlowDate;
        if CashFlowDate < WorkDate then begin
          if SelectionCashFlowForecast."Overdue CF Dates to Work Date" then
            CashFlowWorksheetLine."Cash Flow Date" := WorkDate;
          CashFlowWorksheetLine.Overdue := true;
        end
    end;

    local procedure CalculateLineAmountForPurchaseLine(PurchHeader2: Record "Purchase Header";PurchaseLine: Record "Purchase Line"): Decimal
    var
        PrepmtAmtInvLCY: Decimal;
    begin
        if PurchHeader2."Currency Code" <> '' then begin
          Currency.Get(PurchHeader2."Currency Code");
          PrepmtAmtInvLCY :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                PurchHeader2."Posting Date",PurchHeader2."Currency Code",
                PurchaseLine."Prepmt. Amt. Inv.",PurchHeader2."Currency Factor"),
              Currency."Amount Rounding Precision");
        end else
          PrepmtAmtInvLCY := PurchaseLine."Prepmt. Amt. Inv.";

        Currency.InitRoundingPrecision;
        if PurchHeader2."Prices Including VAT" then
          exit(-(GetPurchaseAmountForCFLine(PurchaseLine) - PrepmtAmtInvLCY));
        exit(
          -(GetPurchaseAmountForCFLine(PurchaseLine) -
            (PrepmtAmtInvLCY +
             ROUND(PrepmtAmtInvLCY * PurchaseLine."VAT %" / 100,Currency."Amount Rounding Precision",Currency.VATRoundingDirection))));
    end;

    local procedure CalculateLineAmountForSalesLine(SalesHeader2: Record "Sales Header";SalesLine: Record "Sales Line"): Decimal
    var
        PrepmtAmtInvLCY: Decimal;
    begin
        if SalesHeader2."Currency Code" <> '' then begin
          Currency.Get(SalesHeader2."Currency Code");
          PrepmtAmtInvLCY :=
            ROUND(
              CurrExchRate.ExchangeAmtFCYToLCY(
                SalesHeader2."Posting Date",SalesHeader2."Currency Code",
                SalesLine."Prepmt. Amt. Inv.",SalesHeader2."Currency Factor"),
              Currency."Amount Rounding Precision");
        end else
          PrepmtAmtInvLCY := SalesLine."Prepmt. Amt. Inv.";

        Currency.InitRoundingPrecision;
        if SalesHeader2."Prices Including VAT" then
          exit(GetSalesAmountForCFLine(SalesLine) - PrepmtAmtInvLCY);
        exit(
          GetSalesAmountForCFLine(SalesLine) -
          (PrepmtAmtInvLCY +
           ROUND(PrepmtAmtInvLCY * SalesLine."VAT %" / 100,Currency."Amount Rounding Precision",Currency.VATRoundingDirection)));
    end;

    local procedure CalculateLineAmountForServiceLine(ServiceLine: Record "Service Line"): Decimal
    begin
        exit(GetServiceAmountForCFLine(ServiceLine));
    end;

    local procedure NoOptionsChosen(): Boolean
    var
        SourceType: Integer;
    begin
        for SourceType := 1 to ArrayLen(ConsiderSource) do
          if ConsiderSource[SourceType] then
            exit(false);
        exit(true);
    end;


    procedure InitializeRequest(NewConsiderSource: array [16] of Boolean;CFNo: Code[20];NewGLBudgetName: Code[10];GroupByDocumentType: Boolean)
    begin
        CopyArray(ConsiderSource,NewConsiderSource,1);
        CashFlowNo := CFNo;
        GLBudgName := NewGLBudgetName;
        Summarized := GroupByDocumentType;
    end;

    local procedure InsertManualData(ExecutionDate: Date;CashFlowForecast: Record "Cash Flow Forecast";ManualAmount: Decimal)
    begin
        if ((CashFlowForecast."Manual Payments From" <> 0D) and
            (ExecutionDate < CashFlowForecast."Manual Payments From")) or
           ((CashFlowForecast."Manual Payments To" <> 0D) and
            (ExecutionDate > CashFlowForecast."Manual Payments To"))
        then
          exit;

        with CFWorksheetLine2 do begin
          SetCashFlowDate(CFWorksheetLine2,ExecutionDate);
          "Amount (LCY)" := ManualAmount;
          InsertTempCFWorksheetLine(0);
        end;
    end;

    local procedure GetPurchaseAmountForCFLine(PurchaseLine: Record "Purchase Line"): Decimal
    begin
        exit(PurchaseLine."Outstanding Amount (LCY)" + PurchaseLine."Amt. Rcd. Not Invoiced (LCY)");
    end;

    local procedure GetSalesAmountForCFLine(SalesLine: Record "Sales Line"): Decimal
    begin
        exit(SalesLine."Outstanding Amount (LCY)" + SalesLine."Shipped Not Invoiced (LCY)");
    end;

    local procedure GetServiceAmountForCFLine(ServiceLine: Record "Service Line"): Decimal
    begin
        exit(ServiceLine."Outstanding Amount (LCY)" + ServiceLine."Shipped Not Invoiced (LCY)");
    end;

    local procedure GetJobPlanningAmountForCFLine(JobPlanningLine: Record "Job Planning Line"): Decimal
    begin
        JobPlanningLine.CalcFields("Invoiced Amount (LCY)");
        exit(JobPlanningLine."Line Amount (LCY)" - JobPlanningLine."Invoiced Amount (LCY)");
    end;

    local procedure GetTaxPayableDateFromSource(SourceTableNum: Integer): Date
    var
        CashFlowSetup: Record "Cash Flow Setup";
        DocumentDate: Date;
    begin
        case SourceTableNum of
          Database::"Sales Header":
            DocumentDate := "Sales Header"."Document Date";
          Database::"Purchase Header":
            DocumentDate := "Purchase Header"."Document Date";
          Database::"VAT Entry":
            DocumentDate := "VAT Entry"."Document Date";
        end;

        exit(CashFlowSetup.GetTaxPaymentDueDate(DocumentDate));
    end;

    local procedure HasTaxBeenPaidOn(PaymentDate: Date): Boolean
    var
        CashFlowSetup: Record "Cash Flow Setup";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        TaxPaymentStartDate: Date;
        BalanceAccountType: Option;
    begin
        TaxPaymentStartDate := CashFlowSetup.GetTaxPaymentStartDate(PaymentDate);
        case CashFlowSetup."Tax Bal. Account Type" of
          CashFlowSetup."tax bal. account type"::" ":
            exit(false);
          CashFlowSetup."tax bal. account type"::Vendor:
            BalanceAccountType := BankAccountLedgerEntry."bal. account type"::Vendor;
          CashFlowSetup."tax bal. account type"::"G/L Account":
            BalanceAccountType := BankAccountLedgerEntry."bal. account type"::"G/L Account";
        end;
        BankAccountLedgerEntry.SetRange("Bal. Account Type",BalanceAccountType);
        BankAccountLedgerEntry.SetFilter("Posting Date",'%1..%2',TaxPaymentStartDate,PaymentDate);
        BankAccountLedgerEntry.SetRange("Bal. Account No.",CashFlowSetup."Tax Bal. Account No.");
        exit(not BankAccountLedgerEntry.IsEmpty);
    end;

    local procedure GetDescriptionForTaxCashFlowLine(SourceTableNum: Integer): Text[250]
    var
        PurchaseOrders: Page "Purchase Orders";
        SalesOrders: Page "Sales Orders";
        VATEntries: Page "VAT Entries";
    begin
        case SourceTableNum of
          Database::"Purchase Header":
            exit(StrSubstNo(TaxForMsg,PurchaseOrders.Caption));
          Database::"Sales Header":
            exit(StrSubstNo(TaxForMsg,SalesOrders.Caption));
          Database::"VAT Entry":
            exit(StrSubstNo(TaxForMsg,VATEntries.Caption));
        end;
    end;

    local procedure GetTaxAmountFromSource(SourceTableNum: Integer): Decimal
    var
        CashFlowManagement: Codeunit "Cash Flow Management";
    begin
        case SourceTableNum of
          Database::"Sales Header":
            exit(CashFlowManagement.GetTaxAmountFromSalesOrder("Sales Header"));
          Database::"Purchase Header":
            exit(CashFlowManagement.GetTaxAmountFromPurchaseOrder("Purchase Header"));
          Database::"VAT Entry":
            exit("VAT Entry".Amount);
        end;
    end;

    local procedure IsDateBeforeStartOfCurrentPeriod(Date: Date): Boolean
    var
        CashFlowSetup: Record "Cash Flow Setup";
    begin
        exit(Date < CashFlowSetup.GetCurrentPeriodStartDate);
    end;
}

