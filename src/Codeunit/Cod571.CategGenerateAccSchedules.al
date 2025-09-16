#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 571 "Categ. Generate Acc. Schedules"
{

    trigger OnRun()
    begin
        CreateBalanceSheet;
        CreateIncomeStatement;
        CreateCashFlowStatement;
        CreateRetainedEarningsStatement;
    end;

    var
        TotalingTxt: label 'Total %1', Comment='%1 = Account category, e.g. Assets';
        Totaling2Txt: label 'Total %1 & %2', Comment='%1 and %2 = Account category, e.g. Assets';
        GrossProfitTxt: label 'Gross Profit';
        GeneralLedgerSetup: Record "General Ledger Setup";
        NetIncomeTxt: label 'Net Income';
        AdjustmentsTxt: label 'Adjustments to reconcile Net Income to net cash provided by operations:';
        NetCashProviededTxt: label 'Net Cash Provided by %1', Comment='%1=Operating Activities or Investing Activities';
        NetCashIncreaseTxt: label 'Net Cash Increase for the Period';
        CashAtPeriodStartTxt: label 'Cash at Beginning of the Period';
        CashAtPeriodEndTxt: label 'Cash at End of the Period';
        DistribToShareholdersTxt: label 'Distributions to Shareholders';
        RetainedEarningsPrimoTxt: label 'Retained Earnings, Period Start';
        RetainedEarningsUltimoTxt: label 'Retained Earnings, Period End';

    local procedure CreateBalanceSheet()
    var
        AccScheduleName: Record "Acc. Schedule Name";
        AccScheduleLine: Record "Acc. Schedule Line";
        GLAccountCategory: Record "G/L Account Category";
        GLAccountCategoryMgt: Codeunit "G/L Account Category Mgt.";
        RowNo: Integer;
        LiabilitiesRowNo: Code[10];
        EquityRowNo: Code[10];
    begin
        GLAccountCategoryMgt.GetGLSetup(GeneralLedgerSetup);
        GeneralLedgerSetup.TestField("Acc. Sched. for Balance Sheet");
        AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Balance Sheet");
        AccScheduleLine.SetRange("Schedule Name",AccScheduleName.Name);
        AccScheduleLine.DeleteAll;
        AccScheduleLine."Schedule Name" := AccScheduleName.Name;

        AddAccSchedLineGroup(AccScheduleLine,RowNo,GLAccountCategory."account category"::Assets);
        AddBlankLine(AccScheduleLine,RowNo);
        AddAccSchedLineGroup(AccScheduleLine,RowNo,GLAccountCategory."account category"::Liabilities);
        LiabilitiesRowNo := AccScheduleLine."Row No.";
        AddBlankLine(AccScheduleLine,RowNo);
        AddAccSchedLineGroup(AccScheduleLine,RowNo,GLAccountCategory."account category"::Equity);
        EquityRowNo := AccScheduleLine."Row No.";
        AddBlankLine(AccScheduleLine,RowNo);
        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,
          StrSubstNo(Totaling2Txt,GLAccountCategory."account category"::Liabilities,GLAccountCategory."account category"::Equity),
          StrSubstNo('%1+%2',LiabilitiesRowNo,EquityRowNo),
          true,true,true,0);
    end;

    local procedure CreateIncomeStatement()
    var
        AccScheduleName: Record "Acc. Schedule Name";
        AccScheduleLine: Record "Acc. Schedule Line";
        GLAccountCategory: Record "G/L Account Category";
        GLAccountCategoryMgt: Codeunit "G/L Account Category Mgt.";
        RowNo: Integer;
        TurnoverRownNo: Integer;
        COGSRowNo: Integer;
        GrossProfitRowNo: Integer;
        ExpensesRowNo: Integer;
    begin
        GLAccountCategoryMgt.GetGLSetup(GeneralLedgerSetup);
        GeneralLedgerSetup.TestField("Acc. Sched. for Income Stmt.");
        AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Income Stmt.");
        AccScheduleLine.SetRange("Schedule Name",AccScheduleName.Name);
        AccScheduleLine.DeleteAll;
        AccScheduleLine."Schedule Name" := AccScheduleName.Name;

        AddAccSchedLineGroup(AccScheduleLine,RowNo,GLAccountCategory."account category"::Income);
        TurnoverRownNo := RowNo;
        AddBlankLine(AccScheduleLine,RowNo);
        AddAccSchedLineGroup(AccScheduleLine,RowNo,GLAccountCategory."account category"::"Cost of Goods Sold");
        COGSRowNo := RowNo;
        AddBlankLine(AccScheduleLine,RowNo);
        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,GrossProfitTxt,
          StrSubstNo('%1+%2',FormatRowNo(TurnoverRownNo,true),FormatRowNo(COGSRowNo,true)),
          true,false,true,0);
        GrossProfitRowNo := RowNo;
        AddBlankLine(AccScheduleLine,RowNo);
        AddAccSchedLineGroup(AccScheduleLine,RowNo,GLAccountCategory."account category"::Expense);
        ExpensesRowNo := RowNo;
        AddBlankLine(AccScheduleLine,RowNo);
        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,NetIncomeTxt,
          StrSubstNo('%1+%2',FormatRowNo(GrossProfitRowNo,true),FormatRowNo(ExpensesRowNo,true)),
          true,true,true,0);
    end;

    local procedure CreateCashFlowStatement()
    var
        AccScheduleName: Record "Acc. Schedule Name";
        AccScheduleLine: Record "Acc. Schedule Line";
        GLAccountCategory: Record "G/L Account Category";
        GLAccountCategoryMgt: Codeunit "G/L Account Category Mgt.";
        RowNo: Integer;
        OperatingActRowNo: Code[10];
        InvestingActRowNo: Code[10];
        FinancingActRowNo: Code[10];
        NetCashIncreaseRowNo: Code[10];
        CashBeginningRowNo: Code[10];
    begin
        GLAccountCategoryMgt.GetGLSetup(GeneralLedgerSetup);
        GeneralLedgerSetup.TestField("Acc. Sched. for Cash Flow Stmt");
        AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Cash Flow Stmt");
        AccScheduleLine.SetRange("Schedule Name",AccScheduleName.Name);
        AccScheduleLine.DeleteAll;
        AccScheduleLine."Schedule Name" := AccScheduleName.Name;

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          Format(GLAccountCategory."additional report definition"::"Operating Activities"),'',true,false,true,0);
        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          NetIncomeTxt,GetIncomeStmtAccFilter,false,false,true,0);
        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          AdjustmentsTxt,'',false,false,false,0);

        CreateCashFlowActivityPart(AccScheduleLine,RowNo,GLAccountCategory."additional report definition"::"Operating Activities",false);
        OperatingActRowNo := AccScheduleLine."Row No.";

        AddBlankLine(AccScheduleLine,RowNo);

        CreateCashFlowActivityPart(AccScheduleLine,RowNo,GLAccountCategory."additional report definition"::"Investing Activities",true);
        InvestingActRowNo := AccScheduleLine."Row No.";

        AddBlankLine(AccScheduleLine,RowNo);

        CreateCashFlowActivityPart(AccScheduleLine,RowNo,GLAccountCategory."additional report definition"::"Financing Activities",true);
        FinancingActRowNo := AccScheduleLine."Row No.";

        AddBlankLine(AccScheduleLine,RowNo);

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,
          NetCashIncreaseTxt,
          StrSubstNo('%1+%2+%3',OperatingActRowNo,InvestingActRowNo,FinancingActRowNo),
          false,false,false,0);
        NetCashIncreaseRowNo := AccScheduleLine."Row No.";

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          CashAtPeriodStartTxt,
          GetAccFilterForReportingDefinition(GLAccountCategory."additional report definition"::"Cash Accounts"),
          false,true,false,0);
        AccScheduleLine."Row Type" := AccScheduleLine."row type"::"Beginning Balance";
        AccScheduleLine.Modify;
        CashBeginningRowNo := AccScheduleLine."Row No.";

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,
          CashAtPeriodEndTxt,
          StrSubstNo('%1+%2',NetCashIncreaseRowNo,CashBeginningRowNo),
          true,true,false,0);
    end;

    local procedure CreateCashFlowActivityPart(var AccScheduleLine: Record "Acc. Schedule Line";var RowNo: Integer;AddReportDef: Option;IncludeHeader: Boolean)
    var
        GLAccountCategory: Record "G/L Account Category";
        FirstRangeRowNo: Integer;
    begin
        GLAccountCategory."Additional Report Definition" := AddReportDef;
        if IncludeHeader then
          AddAccShedLine(
            AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
            Format(GLAccountCategory."Additional Report Definition"),'',true,false,false,0);

        FirstRangeRowNo := RowNo;
        if AddReportDef = GLAccountCategory."additional report definition"::"Financing Activities" then
          GLAccountCategory.SetFilter(
            "Additional Report Definition",'%1|%2',
            GLAccountCategory."additional report definition"::"Financing Activities",
            GLAccountCategory."additional report definition"::"Distribution to Shareholders")
        else
          GLAccountCategory.SetRange("Additional Report Definition",AddReportDef);
        if GLAccountCategory.FindSet then begin
          repeat
            AddAccShedLine(
              AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
              GLAccountCategory.Description,GLAccountCategory.GetTotaling,false,false,false,1);
          until GLAccountCategory.Next = 0;
          // Last line in group should be underlined
          AccScheduleLine.Underline := true;
          AccScheduleLine.Modify;

          AddAccShedLine(
            AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,
            StrSubstNo(NetCashProviededTxt,GLAccountCategory."Additional Report Definition"),
            StrSubstNo('%1..%2',FormatRowNo(FirstRangeRowNo,false),FormatRowNo(RowNo,false)),
            true,false,false,0);
        end;
    end;

    local procedure CreateRetainedEarningsStatement()
    var
        AccScheduleName: Record "Acc. Schedule Name";
        AccScheduleLine: Record "Acc. Schedule Line";
        GLAccountCategory: Record "G/L Account Category";
        GLAccountCategoryMgt: Codeunit "G/L Account Category Mgt.";
        RowNo: Integer;
        RetainedEarningsPrimoRowNo: Code[10];
        GrossRetainedEarningsRowNo: Code[10];
        DistributionRowNo: Code[10];
    begin
        GLAccountCategoryMgt.GetGLSetup(GeneralLedgerSetup);
        GeneralLedgerSetup.TestField("Acc. Sched. for Retained Earn.");
        AccScheduleName.Get(GeneralLedgerSetup."Acc. Sched. for Retained Earn.");
        AccScheduleLine.SetRange("Schedule Name",AccScheduleName.Name);
        AccScheduleLine.DeleteAll;
        AccScheduleLine."Schedule Name" := AccScheduleName.Name;

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          RetainedEarningsPrimoTxt,
          GetAccFilterForReportingDefinition(GLAccountCategory."additional report definition"::"Retained Earnings"),
          false,false,true,0);
        AccScheduleLine."Row Type" := AccScheduleLine."row type"::"Beginning Balance";
        AccScheduleLine.Modify;
        RetainedEarningsPrimoRowNo := AccScheduleLine."Row No.";

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          NetIncomeTxt,GetIncomeStmtAccFilter,false,true,true,0);

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,
          '',
          StrSubstNo('%1+%2',RetainedEarningsPrimoRowNo,AccScheduleLine."Row No."),
          false,false,true,0);
        GrossRetainedEarningsRowNo := AccScheduleLine."Row No.";

        AddBlankLine(AccScheduleLine,RowNo);

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          DistribToShareholdersTxt,
          GetAccFilterForReportingDefinition(GLAccountCategory."additional report definition"::"Distribution to Shareholders"),
          false,false,false,0);
        DistributionRowNo := AccScheduleLine."Row No.";

        AddBlankLine(AccScheduleLine,RowNo);
        AccScheduleLine.Underline := true;
        AccScheduleLine.Modify;

        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,
          RetainedEarningsUltimoTxt,
          StrSubstNo('%1-%2',GrossRetainedEarningsRowNo,DistributionRowNo),
          true,true,true,0);
        AccScheduleLine."Row Type" := AccScheduleLine."row type"::"Balance at Date";
        AccScheduleLine.Modify;
    end;

    local procedure AddAccSchedLineGroup(var AccScheduleLine: Record "Acc. Schedule Line";var RowNo: Integer;Category: Option)
    var
        GLAccountCategory: Record "G/L Account Category";
    begin
        GLAccountCategory.SetRange("Account Category",Category);
        GLAccountCategory.SetRange(Indentation,0);
        GLAccountCategory.SetAutocalcFields("Has Children");
        GLAccountCategory.SetCurrentkey("Presentation Order");
        if GLAccountCategory.FindSet then
          repeat
            AddAccSchedLinesDetail(AccScheduleLine,RowNo,GLAccountCategory,0);
          until GLAccountCategory.Next = 0;
    end;

    local procedure AddAccSchedLinesDetail(var AccScheduleLine: Record "Acc. Schedule Line";var RowNo: Integer;ParentGLAccountCategory: Record "G/L Account Category";Indentation: Integer)
    var
        GLAccountCategory: Record "G/L Account Category";
        FromRowNo: Integer;
        TotalingFilter: Text;
    begin
        if ParentGLAccountCategory."Has Children" then begin
          AddAccShedLine(
            AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
            ParentGLAccountCategory.Description,ParentGLAccountCategory.GetTotaling,true,false,
            not ParentGLAccountCategory.PositiveNormalBalance,Indentation);
          FromRowNo := RowNo;
          GLAccountCategory.SetRange("Parent Entry No.",ParentGLAccountCategory."Entry No.");
          GLAccountCategory.SetCurrentkey("Presentation Order");
          GLAccountCategory.SetAutocalcFields("Has Children");
          if GLAccountCategory.FindSet then
            repeat
              AddAccSchedLinesDetail(AccScheduleLine,RowNo,GLAccountCategory,Indentation + 1);
            until GLAccountCategory.Next = 0;
          AddAccShedLine(
            AccScheduleLine,RowNo,AccScheduleLine."totaling type"::Formula,
            StrSubstNo(TotalingTxt,ParentGLAccountCategory.Description),
            StrSubstNo('%1..%2',FormatRowNo(FromRowNo,false),FormatRowNo(RowNo,false)),true,false,
            not ParentGLAccountCategory.PositiveNormalBalance,Indentation);
        end else begin
          // Retained Earnings element of Equity must include non-closed income statement.
          TotalingFilter := ParentGLAccountCategory.GetTotaling;
          if ParentGLAccountCategory."Additional Report Definition" =
             ParentGLAccountCategory."additional report definition"::"Retained Earnings"
          then begin
            if TotalingFilter <> '' then
              TotalingFilter += '|';
            TotalingFilter += GetIncomeStmtAccFilter;
          end;

          AddAccShedLine(
            AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
            ParentGLAccountCategory.Description,CopyStr(TotalingFilter,1,250),
            Indentation = 0,false,not ParentGLAccountCategory.PositiveNormalBalance,Indentation);
          AccScheduleLine.Show := AccScheduleLine.Show::"If Any Column Not Zero";
          AccScheduleLine.Modify;
        end;
    end;

    local procedure AddAccShedLine(var AccScheduleLine: Record "Acc. Schedule Line";var RowNo: Integer;TotalingType: Option;Description: Text[80];Totaling: Text[250];Bold: Boolean;Underline: Boolean;ShowOppositeSign: Boolean;Indentation: Integer)
    begin
        if AccScheduleLine.FindLast then;
        AccScheduleLine.Init;
        AccScheduleLine."Line No." += 10000;
        RowNo += 1;
        AccScheduleLine."Row No." := FormatRowNo(RowNo,TotalingType = AccScheduleLine."totaling type"::Formula);
        AccScheduleLine."Totaling Type" := TotalingType;
        AccScheduleLine.Description := Description;
        AccScheduleLine.Totaling := Totaling;
        AccScheduleLine."Show Opposite Sign" := ShowOppositeSign;
        AccScheduleLine.Bold := Bold;
        AccScheduleLine.Underline := Underline;
        AccScheduleLine.Indentation := Indentation;
        AccScheduleLine.Insert;
    end;

    local procedure FormatRowNo(RowNo: Integer;AddPrefix: Boolean): Text[5]
    var
        Prefix: Text[1];
    begin
        if AddPrefix then
          Prefix := 'F'
        else
          Prefix := 'P';
        exit(Prefix + CopyStr(Format(10000 + RowNo),2,4));
    end;

    local procedure AddBlankLine(var AccScheduleLine: Record "Acc. Schedule Line";var RowNo: Integer)
    begin
        AddAccShedLine(
          AccScheduleLine,RowNo,AccScheduleLine."totaling type"::"Posting Accounts",
          '','',false,false,false,0);
    end;

    local procedure GetAccFilterForReportingDefinition(AdditionalReportingDefinition: Option): Text[250]
    var
        GLAccountCategory: Record "G/L Account Category";
        Totaling: Text;
        AccFilter: Text;
    begin
        GLAccountCategory.SetRange("Additional Report Definition",AdditionalReportingDefinition);
        if GLAccountCategory.FindSet then
          repeat
            Totaling := GLAccountCategory.GetTotaling;
            if (AccFilter <> '') and (Totaling <> '') then
              AccFilter += '|';
            AccFilter += Totaling;
          until GLAccountCategory.Next = 0;
        exit(CopyStr(AccFilter,1,250));
    end;

    local procedure GetIncomeStmtAccFilter(): Text[250]
    var
        GLAccount: Record "G/L Account";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        GLAccount.Reset;
        GLAccount.SetRange("Income/Balance",GLAccount."income/balance"::"Income Statement");
        exit(CopyStr(SelectionFilterManagement.GetSelectionFilterForGLAccount(GLAccount),1,250));
    end;
}

