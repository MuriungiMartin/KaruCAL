#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1126 "Cost Acctg. Statement"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cost Acctg. Statement.rdlc';
    Caption = 'Cost Acctg. Statement';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Cost Type";"Cost Type")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Cost Classification",Type,"Date Filter","Cost Center Filter","Cost Object Filter";
            column(ReportForNavId_2867; 2867)
            {
            }
            column(StrsubstnodatePeriodtxt;StrSubstNo(Text000,PeriodTxt))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(CostTypeTableCaptFilter;TableCaption + ': ' + CostTypeFilter)
            {
            }
            column(NetChange;-"Net Change")
            {
            }
            column(NetChange_CostType;"Net Change")
            {
            }
            column(PadstrIndentation2Name;PadStr('',Indentation * 2) + Name)
            {
            }
            column(No_CostType;"No.")
            {
            }
            column(LineType;LineType)
            {
            }
            column(BlankLine;"Blank Line")
            {
            }
            column(PageGroupNo;PageGroupNo)
            {
            }
            column(AddCurrNetChange_CostType;"Add. Currency Net Change")
            {
            }
            column(ShowAddCurr;ShowAddCurr)
            {
            }
            column(AddCurrencyNetChange;-"Add. Currency Net Change")
            {
            }
            column(AddRepCurr_GLSetup;GLSetup."Additional Reporting Currency")
            {
            }
            column(LcyCode_GLSetup;GLSetup."LCY Code")
            {
            }
            column(AllAmountAre;AllAmountAreLbl)
            {
            }
            column(CAProfitLossStatementCaption;CAProfitLossStatementCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(NetChangeCaption;NetChangeCaptionLbl)
            {
            }
            column(CostTypeNetChangeCaption;CostTypeNetChangeCaptionLbl)
            {
            }
            column(PADSTRIndentation2NameCaption;PADSTRIndentation2NameCaptionLbl)
            {
            }
            column(CostTypeNoCaption;CostTypeNoCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CalcFields("Net Change");
                CalcFields("Add. Currency Net Change");

                if NewPage then begin
                  PageGroupNo := PageGroupNo + 1;
                  NewPage := false;
                end;
                NewPage := "New Page";

                LineType := Type;
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
                PageGroupNo := 1;
                NewPage := false;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Control2)
                {
                    field(ShowAmountsInAddRepCurrency;ShowAddCurr)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amounts in Additional Currency';
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
        CostTypeFilter := "Cost Type".GetFilters;
        PeriodTxt := "Cost Type".GetFilter("Date Filter");
    end;

    var
        Text000: label 'Date Filter: %1';
        GLSetup: Record "General Ledger Setup";
        CostTypeFilter: Text;
        PeriodTxt: Text;
        PageGroupNo: Integer;
        NewPage: Boolean;
        LineType: Integer;
        ShowAddCurr: Boolean;
        AllAmountAreLbl: label 'All amounts are in';
        CAProfitLossStatementCaptionLbl: label 'Cost Acctg. Statement';
        CurrReportPageNoCaptionLbl: label 'Page';
        NetChangeCaptionLbl: label 'Net Change Credit';
        CostTypeNetChangeCaptionLbl: label 'Net Change Debit';
        PADSTRIndentation2NameCaptionLbl: label 'Name';
        CostTypeNoCaptionLbl: label 'Cost Type';
}

