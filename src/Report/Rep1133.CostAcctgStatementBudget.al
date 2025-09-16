#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1133 "Cost Acctg. Statement/Budget"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Acctg. StatementBudget.rdlc';
    Caption = 'Cost Acctg. Statement/Budget';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cost Type";"Cost Type")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Budget Filter","Date Filter","Cost Center Filter","Cost Object Filter",Type,"Cost Classification";
            column(ReportForNavId_2867; 2867)
            {
            }
            column(DateFilterTxt;DateFilterTxt)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(CcFilterTxt;CCFilterTxt)
            {
            }
            column(BudFilterTxt;BudFilterTxt)
            {
            }
            column(CoFilterTxt;COFilterTxt)
            {
            }
            column(NetChange;-"Net Change")
            {
            }
            column(NetChange_CostType;"Net Change")
            {
            }
            column(NameIndented;PadStr('',Indentation * 2) + Name)
            {
            }
            column(No_CostType;"No.")
            {
            }
            column(BudPct;BudPct)
            {
            }
            column(BudgetAmount_CostType;"Budget Amount")
            {
            }
            column(BlankLine_CostType;"Blank Line")
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(CostTypeLineType1;CostTypeLineType)
            {
            }
            column(CostAcctgStmtBudgetCaption;CostAcctgStmtBudgetCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(BudgetAmountCaption;BudgetAmountCaptionLbl)
            {
            }
            column(PercentageOfCaption;PercentageOfCaptionLbl)
            {
            }
            column(CreditCaption;CreditCaptionLbl)
            {
            }
            column(CostTypeCreditCaption;CostTypeCreditCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(CostTypeCaption;CostTypeCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change","Budget Amount");

                if SuppressZeroLines and ("Net Change" = 0) and ("Budget Amount" = 0) then
                  CurrReport.Skip;

                if "Budget Amount" = 0 then
                  BudPct := 0
                else
                  BudPct := "Net Change" / "Budget Amount" * 100;

                PageGroupNo := NextPageGroupNo;
                if "New Page" then
                  NextPageGroupNo := PageGroupNo + 1;
                CostTypeLineType := Type;
            end;

            trigger OnPreDataItem()
            begin
                PageGroupNo := 1;
                NextPageGroupNo := 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(SuppressZeroLines;SuppressZeroLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Suppress lines without amount';
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
        DateFilterTxt := Text000 + "Cost Type".GetFilter("Date Filter");
        BudFilterTxt := Text001 + "Cost Type".GetFilter("Budget Filter");

        if "Cost Type".GetFilter("Cost Center Filter") <> '' then
          CCFilterTxt := Text002 + "Cost Type".GetFilter("Cost Center Filter");

        if "Cost Type".GetFilter("Cost Object Filter") <> '' then
          COFilterTxt := Text003 + "Cost Type".GetFilter("Cost Object Filter");
    end;

    var
        Text000: label 'Date Filter: ';
        Text001: label 'Budget Name: ';
        Text002: label 'Cost Center Filter: ';
        Text003: label 'Cost Object Filter: ';
        SuppressZeroLines: Boolean;
        BudFilterTxt: Text;
        DateFilterTxt: Text;
        BudPct: Decimal;
        CCFilterTxt: Text;
        COFilterTxt: Text;
        PageGroupNo: Integer;
        NextPageGroupNo: Integer;
        CostTypeLineType: Integer;
        CostAcctgStmtBudgetCaptionLbl: label 'Cost Acctg. Statement/Budget';
        PageCaptionLbl: label 'Page';
        BudgetAmountCaptionLbl: label 'Budget Amount';
        PercentageOfCaptionLbl: label '% of';
        CreditCaptionLbl: label 'Credit';
        CostTypeCreditCaptionLbl: label 'Debit';
        NameCaptionLbl: label 'Name';
        CostTypeCaptionLbl: label 'Cost Type';
}

