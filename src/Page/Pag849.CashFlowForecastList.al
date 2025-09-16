#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 849 "Cash Flow Forecast List"
{
    ApplicationArea = Basic;
    Caption = 'Cash Flow Forecast List';
    CardPageID = "Cash Flow Forecast Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Cash Flow Forecast";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1000)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the number of the record.';
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an additional name for the cash flow for searching purposes.';
                    Visible = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a description of the cash flow forecast.';
                }
                field("Description 2";"Description 2")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies an additional description of a forecast.';
                }
                field(ShowInChart;GetShowInChart)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Show In Chart on Role Center';
                }
                field("Consider Discount";"Consider Discount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you want to include the cash discounts that are assigned in entries and documents in cash flow forecast.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the date that the forecast was created.';
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user who created the forecast.';
                }
                field("Manual Payments To";"Manual Payments To")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a starting date to which manual payments should be included in cash flow forecast.';
                    Visible = false;
                }
                field(Comment;Comment)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the comment for the record.';
                    Visible = false;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that was used to assign the cash flow forecast.';
                    Visible = false;
                }
                field("Manual Payments From";"Manual Payments From")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a starting date from which manual payments should be included in cash flow forecast.';
                    Visible = false;
                }
                field("G/L Budget From";"G/L Budget From")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the starting date from which you want to use the budget values from the general ledger in the cash flow forecast.';
                    Visible = false;
                }
                field("G/L Budget To";"G/L Budget To")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last date to which you want to use the budget values from the general ledger in the cash flow forecast.';
                    Visible = false;
                }
                field("Consider CF Payment Terms";"Consider CF Payment Terms")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you want to use cash flow payment terms for cash flow forecast. Cash flow payment terms overrule the standard payment terms that you have defined for customers, vendors, and orders. They also overrule the payment terms that you have manually entered on entries or documents.';
                    Visible = false;
                }
                field("Consider Pmt. Disc. Tol. Date";"Consider Pmt. Disc. Tol. Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the payment discount tolerance date is considered when the cash flow date is calculated. If the check box is cleared, the due date or payment discount date from the customer and vendor ledger entries and the sales order or purchase order are used.';
                    Visible = false;
                }
                field("Consider Pmt. Tol. Amount";"Consider Pmt. Tol. Amount")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if the payment tolerance amounts from the posted customer and vendor ledger entries are used in the cash flow forecast. If the check box is cleared, the amount without any payment tolerance amount from the customer and vendor ledger entries are used.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1905906307;"CF Forecast Statistics FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No.");
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("Cash Flow Forecast")
            {
                Caption = 'Cash Flow Forecast';
                Image = CashFlow;
                action("E&ntries")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'E&ntries';
                    Image = Entries;
                    RunObject = Page "Cash Flow Forecast Entries";
                    RunPageLink = "Cash Flow Forecast No."=field("No.");
                    ShortCutKey = 'Ctrl+F7';
                }
                action(Statistics)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Cash Flow Forecast Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Cash Flow Comment";
                    RunPageLink = "Table Name"=const("Cash Flow Forecast"),
                                  "No."=field("No.");
                }
                separator(Action1023)
                {
                    Caption = '';
                }
                action("CF &Availability by Periods")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'CF &Availability by Periods';
                    Image = ShowMatrix;
                    RunObject = Page "CF Availability by Periods";
                    RunPageLink = "No."=field("No.");
                }
            }
        }
        area(processing)
        {
            action(CashFlowWorksheet)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Cash Flow Worksheet';
                Image = Worksheet2;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cash Flow Worksheet";
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action(CashFlowDateList)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Cash Flow &Date List';
                    Ellipsis = true;
                    Image = "Report";
                    Promoted = true;
                    PromotedCategory = "Report";

                    trigger OnAction()
                    var
                        CashFlowForecast: Record "Cash Flow Forecast";
                    begin
                        CurrPage.SetSelectionFilter(CashFlowForecast);
                        CashFlowForecast.PrintRecords;
                    end;
                }
            }
        }
    }


    procedure SetSelection(var CashFlowAcc: Record "Cash Flow Account")
    begin
        CurrPage.SetSelectionFilter(CashFlowAcc);
    end;


    procedure GetSelectionFilter(): Text
    var
        CashFlowForecast: Record "Cash Flow Forecast";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(CashFlowForecast);
        exit(SelectionFilterManagement.GetSelectionFilterForCashFlow(CashFlowForecast));
    end;
}

