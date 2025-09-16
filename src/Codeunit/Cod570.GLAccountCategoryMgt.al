#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 570 "G/L Account Category Mgt."
{

    trigger OnRun()
    begin
        InitializeAccountCategories;
    end;

    var
        BalanceColumnNameTxt: label 'M-BALANCE', Comment='Max 10 char';
        BalanceColumnDescTxt: label 'Balance', Comment='Max 10 char';
        NetChangeColumnNameTxt: label 'M-NETCHANG', Comment='Max 10 char';
        NetChangeColumnDescTxt: label 'Net Change', Comment='Max 10 char';
        BalanceSheetCodeTxt: label 'M-BALANCE', Comment='Max 10 char';
        BalanceSheetDescTxt: label 'Balance Sheet', Comment='Max 80 chars';
        IncomeStmdCodeTxt: label 'M-INCOME', Comment='Max 10 chars';
        IncomeStmdDescTxt: label 'Income Statement', Comment='Max 80 chars';
        CashFlowCodeTxt: label 'M-CASHFLOW', Comment='Max 10 chars';
        CashFlowDescTxt: label 'Cash Flow Statement', Comment='Max 80 chars';
        RetainedEarnCodeTxt: label 'M-RETAIND', Comment='Max 10 char.';
        RetainedEarnDescTxt: label 'Retained Earnings', Comment='Max 80 chars';
        MissingSetupErr: label 'You must define a %1 in %2 before performing this function.', Comment='%1 = field name, %2 = table name.';
        CurrentAssetsTxt: label 'Current Assets';
        ARTxt: label 'Accounts Receivable';
        CashTxt: label 'Cash';
        PrepaidExpensesTxt: label 'Prepaid Expenses';
        InventoryTxt: label 'Inventory';
        FixedAssetsTxt: label 'Fixed Assets';
        EquipementTxt: label 'Equipment';
        AccumDeprecTxt: label 'Accumulated Depreciation';
        CurrentLiabilitiesTxt: label 'Current Liabilities';
        PayrollLiabilitiesTxt: label 'Payroll Liabilities';
        LongTermLiabilitiesTxt: label 'Long Term Liabilities';
        CommonStockTxt: label 'Common Stock';
        RetEarningsTxt: label 'Retained Earnings';
        DistrToShareholdersTxt: label 'Distributions to Shareholders';
        IncomeServiceTxt: label 'Income, Services';
        IncomeProdSalesTxt: label 'Income, Product Sales';
        IncomeSalesDiscountsTxt: label 'Sales Discounts';
        IncomeSalesReturnsTxt: label 'Sales Returns & Allowances';
        COGSLaborTxt: label 'Labor';
        COGSMaterialsTxt: label 'Materials';
        COGSDiscountsGrantedTxt: label 'Discounts Granted';
        RentExpenseTxt: label 'Rent Expense';
        AdvertisingExpenseTxt: label 'Advertising Expense';
        InterestExpenseTxt: label 'Interest Expense';
        FeesExpenseTxt: label 'Fees Expense';
        InsuranceExpenseTxt: label 'Insurance Expense';
        PayrollExpenseTxt: label 'Payroll Expense';
        BenefitsExpenseTxt: label 'Benefits Expense';
        RepairsTxt: label 'Repairs and Maintenance Expense';
        UtilitiesExpenseTxt: label 'Utilities Expense';
        OtherIncomeExpenseTxt: label 'Other Income & Expenses';
        TaxExpenseTxt: label 'Tax Expense';
        TravelExpenseTxt: label 'Travel Expense';
        VehicleExpensesTxt: label 'Vehicle Expenses';
        BadDebtExpenseTxt: label 'Bad Debt Expense';
        SalariesExpenseTxt: label 'Salaries Expense';
        JobsCostTxt: label 'Jobs Cost';
        IncomeJobsTxt: label 'Income, Jobs';
        JobSalesContraTxt: label 'Job Sales Contra';


    procedure InitializeAccountCategories()
    var
        GLAccountCategory: Record "G/L Account Category";
        GLAccount: Record "G/L Account";
        CategoryID: array [3] of Integer;
    begin
        GLAccount.SetFilter("Account Subcategory Entry No.",'<>0');
        if not GLAccount.IsEmpty then
          if not GLAccountCategory.IsEmpty then
            exit;

        GLAccount.ModifyAll("Account Subcategory Entry No.",0);
        with GLAccountCategory do begin
          DeleteAll;
          CategoryID[1] := AddCategory(0,0,"account category"::Assets,'',true,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Assets,CurrentAssetsTxt,false,0);
          CategoryID[3] :=
            AddCategory(0,CategoryID[2],"account category"::Assets,CashTxt,false,"additional report definition"::"Cash Accounts");
          CategoryID[3] :=
            AddCategory(
              0,CategoryID[2],"account category"::Assets,ARTxt,false,
              "additional report definition"::"Operating Activities");
          CategoryID[3] :=
            AddCategory(
              0,CategoryID[2],"account category"::Assets,PrepaidExpensesTxt,false,
              "additional report definition"::"Operating Activities");
          CategoryID[3] :=
            AddCategory(
              0,CategoryID[2],"account category"::Assets,InventoryTxt,false,
              "additional report definition"::"Operating Activities");
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Assets,FixedAssetsTxt,false,0);
          CategoryID[3] :=
            AddCategory(
              0,CategoryID[2],"account category"::Assets,EquipementTxt,false,
              "additional report definition"::"Investing Activities");
          CategoryID[3] :=
            AddCategory(
              0,CategoryID[2],"account category"::Assets,AccumDeprecTxt,false,
              "additional report definition"::"Investing Activities");
          CategoryID[1] := AddCategory(0,0,"account category"::Liabilities,'',true,0);
          CategoryID[2] :=
            AddCategory(
              0,CategoryID[1],"account category"::Liabilities,CurrentLiabilitiesTxt,false,
              "additional report definition"::"Operating Activities");
          CategoryID[2] :=
            AddCategory(
              0,CategoryID[1],"account category"::Liabilities,PayrollLiabilitiesTxt,false,
              "additional report definition"::"Operating Activities");
          CategoryID[2] :=
            AddCategory(
              0,CategoryID[1],"account category"::Liabilities,LongTermLiabilitiesTxt,false,
              "additional report definition"::"Financing Activities");
          CategoryID[1] := AddCategory(0,0,"account category"::Equity,'',true,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Equity,CommonStockTxt,false,0);
          CategoryID[2] :=
            AddCategory(
              0,CategoryID[1],"account category"::Equity,RetEarningsTxt,false,
              "additional report definition"::"Retained Earnings");
          CategoryID[2] :=
            AddCategory(
              0,CategoryID[1],"account category"::Equity,DistrToShareholdersTxt,false,
              "additional report definition"::"Distribution to Shareholders");
          CategoryID[1] := AddCategory(0,0,"account category"::Income,'',true,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Income,IncomeServiceTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Income,IncomeProdSalesTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Income,IncomeJobsTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Income,IncomeSalesDiscountsTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Income,IncomeSalesReturnsTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Income,JobSalesContraTxt,false,0);
          CategoryID[1] := AddCategory(0,0,"account category"::"Cost of Goods Sold",'',true,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::"Cost of Goods Sold",COGSLaborTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::"Cost of Goods Sold",COGSMaterialsTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::"Cost of Goods Sold",COGSDiscountsGrantedTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::"Cost of Goods Sold",JobsCostTxt,false,0);
          CategoryID[1] := AddCategory(0,0,"account category"::Expense,'',true,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,RentExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,AdvertisingExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,InterestExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,FeesExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,InsuranceExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,PayrollExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,BenefitsExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,SalariesExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,RepairsTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,UtilitiesExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,OtherIncomeExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,TaxExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,TravelExpenseTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,VehicleExpensesTxt,false,0);
          CategoryID[2] := AddCategory(0,CategoryID[1],"account category"::Expense,BadDebtExpenseTxt,false,0);
        end;
    end;


    procedure AddCategory(InsertAfterEntryNo: Integer;ParentEntryNo: Integer;AccountCategory: Option;NewDescription: Text[80];SystemGenerated: Boolean;CashFlowActivity: Option): Integer
    var
        GLAccountCategory: Record "G/L Account Category";
        InsertAfterSequenceNo: Integer;
        InsertBeforeSequenceNo: Integer;
    begin
        if InsertAfterEntryNo <> 0 then begin
          GLAccountCategory.SetCurrentkey("Presentation Order","Sibling Sequence No.");
          if GLAccountCategory.Get(InsertAfterEntryNo) then begin
            InsertAfterSequenceNo := GLAccountCategory."Sibling Sequence No.";
            if GLAccountCategory.Next <> 0 then
              InsertBeforeSequenceNo := GLAccountCategory."Sibling Sequence No.";
          end;
        end;
        GLAccountCategory.Init;
        GLAccountCategory."Entry No." := 0;
        GLAccountCategory."System Generated" := SystemGenerated;
        GLAccountCategory."Parent Entry No." := ParentEntryNo;
        GLAccountCategory.Validate("Account Category",AccountCategory);
        GLAccountCategory.Validate("Additional Report Definition",CashFlowActivity);
        if NewDescription <> '' then
          GLAccountCategory.Description := NewDescription;
        if InsertAfterSequenceNo <> 0 then begin
          if InsertBeforeSequenceNo <> 0 then
            GLAccountCategory."Sibling Sequence No." := (InsertBeforeSequenceNo + InsertAfterSequenceNo) DIV 2
          else
            GLAccountCategory."Sibling Sequence No." := InsertAfterSequenceNo + 10000;
        end;
        GLAccountCategory.Insert(true);
        GLAccountCategory.UpdatePresentationOrder;
        exit(GLAccountCategory."Entry No.");
    end;


    procedure InitializeStandardAccountSchedules()
    var
        GeneralLedgerSetup: Record "General Ledger Setup";
        BalanceColumnName: Code[10];
        NetChangeColumnName: Code[10];
    begin
        if not GeneralLedgerSetup.Get then
          exit;

        BalanceColumnName := CreateUniqueColumnLayoutName(BalanceColumnNameTxt);
        AddColumnLayout(BalanceColumnName,BalanceColumnDescTxt,true);
        NetChangeColumnName := CreateUniqueColumnLayoutName(NetChangeColumnNameTxt);
        AddColumnLayout(NetChangeColumnName,NetChangeColumnDescTxt,false);

        GeneralLedgerSetup."Acc. Sched. for Balance Sheet" := CreateUniqueAccSchedName(BalanceSheetCodeTxt);
        GeneralLedgerSetup."Acc. Sched. for Income Stmt." := CreateUniqueAccSchedName(IncomeStmdCodeTxt);
        GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt" := CreateUniqueAccSchedName(CashFlowCodeTxt);
        GeneralLedgerSetup."Acc. Sched. for Retained Earn." := CreateUniqueAccSchedName(RetainedEarnCodeTxt);
        GeneralLedgerSetup.Modify;

        AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Balance Sheet",BalanceSheetDescTxt,BalanceColumnName);
        AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Income Stmt.",IncomeStmdDescTxt,NetChangeColumnName);
        AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt",CashFlowDescTxt,NetChangeColumnName);
        AddAccountSchedule(GeneralLedgerSetup."Acc. Sched. for Retained Earn.",RetainedEarnDescTxt,NetChangeColumnName);
    end;

    local procedure AddAccountSchedule(NewName: Code[10];NewDescription: Text[80];DefaultColumnName: Code[10])
    var
        AccScheduleName: Record "Acc. Schedule Name";
    begin
        if AccScheduleName.Get(NewName) then
          exit;
        AccScheduleName.Init;
        AccScheduleName.Name := NewName;
        AccScheduleName.Description := NewDescription;
        AccScheduleName."Default Column Layout" := DefaultColumnName;
        AccScheduleName.Insert;
    end;

    local procedure AddColumnLayout(NewName: Code[10];NewDescription: Text[80];IsBalance: Boolean)
    var
        ColumnLayoutName: Record "Column Layout Name";
        ColumnLayout: Record "Column Layout";
    begin
        if ColumnLayoutName.Get(NewName) then
          exit;
        ColumnLayoutName.Init;
        ColumnLayoutName.Name := NewName;
        ColumnLayoutName.Description := NewDescription;
        ColumnLayoutName.Insert;

        ColumnLayout.Init;
        ColumnLayout."Column Layout Name" := NewName;
        ColumnLayout."Line No." := 10000;
        ColumnLayout."Column Header" := CopyStr(NewDescription,1,MaxStrLen(ColumnLayout."Column Header"));
        if IsBalance then
          ColumnLayout."Column Type" := ColumnLayout."column type"::"Balance at Date"
        else
          ColumnLayout."Column Type" := ColumnLayout."column type"::"Net Change";
        ColumnLayout.Insert;
    end;


    procedure GetGLSetup(var GeneralLedgerSetup: Record "General Ledger Setup")
    begin
        GeneralLedgerSetup.Get;
        if AnyAccSchedSetupMissing(GeneralLedgerSetup) then begin
          InitializeStandardAccountSchedules;
          GeneralLedgerSetup.Get;
          if AnyAccSchedSetupMissing(GeneralLedgerSetup) then
            Error(MissingSetupErr,GeneralLedgerSetup.FieldCaption("Acc. Sched. for Balance Sheet"),GeneralLedgerSetup.TableCaption);
          Commit;
          Codeunit.Run(Codeunit::"Categ. Generate Acc. Schedules");
          Commit;
        end;
    end;

    local procedure CreateUniqueAccSchedName(SuggestedName: Code[10]): Code[10]
    var
        AccScheduleName: Record "Acc. Schedule Name";
        i: Integer;
    begin
        while AccScheduleName.Get(SuggestedName) and (i < 1000) do
          SuggestedName := GenerateNextName(SuggestedName,i);
        exit(SuggestedName);
    end;

    local procedure CreateUniqueColumnLayoutName(SuggestedName: Code[10]): Code[10]
    var
        ColumnLayoutName: Record "Column Layout Name";
        i: Integer;
    begin
        while ColumnLayoutName.Get(SuggestedName) and (i < 1000) do
          SuggestedName := GenerateNextName(SuggestedName,i);
        exit(SuggestedName);
    end;

    local procedure GenerateNextName(SuggestedName: Code[10];var i: Integer): Code[10]
    var
        NumPart: Code[3];
    begin
        i += 1;
        NumPart := CopyStr(Format(i),1,MaxStrLen(NumPart));
        exit(CopyStr(SuggestedName,1,MaxStrLen(SuggestedName) - StrLen(NumPart)) + NumPart);
    end;


    procedure RunAccountScheduleReport(AccSchedName: Code[10])
    var
        AccountSchedule: Report "Account Schedule";
    begin
        AccountSchedule.InitAccSched;
        AccountSchedule.SetAccSchedNameNonEditable(AccSchedName);
        AccountSchedule.Run;
    end;

    local procedure AnyAccSchedSetupMissing(var GeneralLedgerSetup: Record "General Ledger Setup"): Boolean
    var
        AccScheduleName: Record "Acc. Schedule Name";
    begin
        if (GeneralLedgerSetup."Acc. Sched. for Balance Sheet" = '') or
           (GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt" = '') or
           (GeneralLedgerSetup."Acc. Sched. for Income Stmt." = '') or
           (GeneralLedgerSetup."Acc. Sched. for Retained Earn." = '')
        then
          exit(true);
        if not AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Balance Sheet") then
          exit(true);
        if not AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt") then
          exit(true);
        if not AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Income Stmt.") then
          exit(true);
        if not AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Retained Earn.") then
          exit(true);
        exit(false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Company-Initialize", 'OnCompanyInitialize', '', false, false)]
    local procedure OnInitializeCompany()
    begin
        InitializeAccountCategories;
        Codeunit.Run(Codeunit::"Categ. Generate Acc. Schedules");
    end;


    procedure GetCurrentAssets(): Text
    begin
        exit(CurrentAssetsTxt);
    end;


    procedure GetAR(): Text
    begin
        exit(ARTxt);
    end;


    procedure GetCash(): Text
    begin
        exit(CashTxt);
    end;


    procedure GetPrepaidExpenses(): Text
    begin
        exit(PrepaidExpensesTxt);
    end;


    procedure GetInventory(): Text
    begin
        exit(InventoryTxt);
    end;


    procedure GetFixedAssets(): Text
    begin
        exit(FixedAssetsTxt);
    end;


    procedure GetEquipment(): Text
    begin
        exit(EquipementTxt);
    end;


    procedure GetAccumDeprec(): Text
    begin
        exit(AccumDeprecTxt);
    end;


    procedure GetCurrentLiabilities(): Text
    begin
        exit(CurrentLiabilitiesTxt);
    end;


    procedure GetPayrollLiabilities(): Text
    begin
        exit(PayrollLiabilitiesTxt);
    end;


    procedure GetLongTermLiabilities(): Text
    begin
        exit(LongTermLiabilitiesTxt);
    end;


    procedure GetCommonStock(): Text
    begin
        exit(CommonStockTxt);
    end;


    procedure GetRetEarnings(): Text
    begin
        exit(RetEarningsTxt);
    end;


    procedure GetDistrToShareholders(): Text
    begin
        exit(DistrToShareholdersTxt);
    end;


    procedure GetIncomeService(): Text
    begin
        exit(IncomeServiceTxt);
    end;


    procedure GetIncomeProdSales(): Text
    begin
        exit(IncomeProdSalesTxt);
    end;


    procedure GetIncomeSalesDiscounts(): Text
    begin
        exit(IncomeSalesDiscountsTxt);
    end;


    procedure GetIncomeSalesReturns(): Text
    begin
        exit(IncomeSalesReturnsTxt);
    end;


    procedure GetCOGSLabor(): Text
    begin
        exit(COGSLaborTxt);
    end;


    procedure GetCOGSMaterials(): Text
    begin
        exit(COGSMaterialsTxt);
    end;


    procedure GetCOGSDiscountsGranted(): Text
    begin
        exit(COGSDiscountsGrantedTxt);
    end;


    procedure GetRentExpense(): Text
    begin
        exit(RentExpenseTxt);
    end;


    procedure GetAdvertisingExpense(): Text
    begin
        exit(AdvertisingExpenseTxt);
    end;


    procedure GetInterestExpense(): Text
    begin
        exit(InterestExpenseTxt);
    end;


    procedure GetFeesExpense(): Text
    begin
        exit(FeesExpenseTxt);
    end;


    procedure GetInsuranceExpense(): Text
    begin
        exit(InsuranceExpenseTxt);
    end;


    procedure GetPayrollExpense(): Text
    begin
        exit(PayrollExpenseTxt);
    end;


    procedure GetBenefitsExpense(): Text
    begin
        exit(BenefitsExpenseTxt);
    end;


    procedure GetRepairsExpense(): Text
    begin
        exit(RepairsTxt);
    end;


    procedure GetUtilitiesExpense(): Text
    begin
        exit(UtilitiesExpenseTxt);
    end;


    procedure GetOtherIncomeExpense(): Text
    begin
        exit(OtherIncomeExpenseTxt);
    end;


    procedure GetTaxExpense(): Text
    begin
        exit(TaxExpenseTxt);
    end;


    procedure GetTravelExpense(): Text
    begin
        exit(TravelExpenseTxt);
    end;


    procedure GetVehicleExpenses(): Text
    begin
        exit(VehicleExpensesTxt);
    end;


    procedure GetBadDebtExpense(): Text
    begin
        exit(BadDebtExpenseTxt);
    end;


    procedure GetSalariesExpense(): Text
    begin
        exit(SalariesExpenseTxt);
    end;


    procedure GetJobsCost(): Text
    begin
        exit(JobsCostTxt);
    end;


    procedure GetIncomeJobs(): Text
    begin
        exit(IncomeJobsTxt);
    end;


    procedure GetJobSalesContra(): Text
    begin
        exit(JobSalesContraTxt);
    end;


    procedure GetAccountCategory(var GLAccountCategory: Record "G/L Account Category";Category: Option)
    begin
        GLAccountCategory.SetRange("Account Category",Category);
        GLAccountCategory.SetRange("Parent Entry No.",0);
        if GLAccountCategory.FindFirst then;
    end;


    procedure GetAccountSubcategory(var GLAccountCategory: Record "G/L Account Category";Category: Option;Description: Text)
    begin
        GLAccountCategory.SetRange("Account Category",Category);
        GLAccountCategory.SetFilter("Parent Entry No.",'<>%1',0);
        GLAccountCategory.SetRange(Description,Description);
        if GLAccountCategory.FindFirst then;
    end;
}

