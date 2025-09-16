#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1030 "Job Cost Factbox"
{
    Caption = 'Job Details';
    Editable = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = Job;

    layout
    {
        area(content)
        {
            field("No.";"No.")
            {
                ApplicationArea = Jobs;
                Caption = 'Job No.';
                ToolTip = 'Specifies the job number.';

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            group("Budget Cost")
            {
                Caption = 'Budget Cost';
                field(PlaceHolderLbl;PlaceHolderLbl)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies nothing.';
                    Visible = false;
                }
                field(ScheduleCostLCY;CL[1])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource';
                    Editable = false;
                    ToolTip = 'Specifies the total budgeted cost of resources associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowPlanningLine(1,1,true);
                    end;
                }
                field(ScheduleCostLCYItem;CL[2])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Item';
                    Editable = false;
                    ToolTip = 'Specifies the total budgeted cost of items associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowPlanningLine(1,2,true);
                    end;
                }
                field(ScheduleCostLCYGLAcc;CL[3])
                {
                    ApplicationArea = Jobs;
                    Caption = 'G/L Account';
                    Editable = false;
                    ToolTip = 'Specifies the total budgeted cost of general journal entries associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowPlanningLine(1,3,true);
                    end;
                }
                field(ScheduleCostLCYTotal;CL[4])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total budget cost of a job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowPlanningLine(1,0,true);
                    end;
                }
            }
            group("Actual Cost")
            {
                Caption = 'Actual Cost';
                field(Control9;PlaceHolderLbl)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies nothing.';
                    Visible = false;
                }
                field(UsageCostLCY;CL[5])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of resources associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,1,true);
                    end;
                }
                field(UsageCostLCYItem;CL[6])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Item';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of items associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,2,true);
                    end;
                }
                field(UsageCostLCYGLAcc;CL[7])
                {
                    ApplicationArea = Jobs;
                    Caption = 'G/L Account';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of general journal entries associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,3,true);
                    end;
                }
                field(UsageCostLCYTotal;CL[8])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total costs used for a job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,0,true);
                    end;
                }
            }
            group("Billable Price")
            {
                Caption = 'Billable Price';
                field(Control16;PlaceHolderLbl)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies nothing.';
                    Visible = false;
                }
                field(BillablePriceLCY;PL[9])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of resources associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,1,true);
                    end;
                }
                field(BillablePriceLCYItem;PL[10])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Item';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of items associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,2,true);
                    end;
                }
                field(BillablePriceLCYGLAcc;PL[11])
                {
                    ApplicationArea = Jobs;
                    Caption = 'G/L Account';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of general journal entries associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,3,true);
                    end;
                }
                field(BillablePriceLCYTotal;PL[12])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total costs used for a job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,0,true);
                    end;
                }
            }
            group("Invoiced Price")
            {
                Caption = 'Invoiced Price';
                field(Control22;PlaceHolderLbl)
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    Enabled = false;
                    ToolTip = 'Specifies nothing.';
                    Visible = false;
                }
                field(InvoicedPriceLCY;PL[13])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of resources associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,1,true);
                    end;
                }
                field(InvoicedPriceLCYItem;PL[14])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Item';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of items associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,2,true);
                    end;
                }
                field(InvoicedPriceLCYGLAcc;PL[15])
                {
                    ApplicationArea = Jobs;
                    Caption = 'G/L Account';
                    Editable = false;
                    ToolTip = 'Specifies the total usage cost of general journal entries associated with this job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,3,true);
                    end;
                }
                field(InvoicedPriceLCYTotal;PL[16])
                {
                    ApplicationArea = Jobs;
                    Caption = 'Total';
                    Editable = false;
                    Style = Strong;
                    StyleExpr = true;
                    ToolTip = 'Specifies the total costs used for a job.';

                    trigger OnDrillDown()
                    begin
                        JobCalcStatistics.ShowLedgEntry(1,0,true);
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        Clear(JobCalcStatistics);
        JobCalcStatistics.JobCalculateCommonFilters(Rec);
        JobCalcStatistics.CalculateAmounts;
        JobCalcStatistics.GetLCYCostAmounts(CL);
        JobCalcStatistics.GetLCYPriceAmounts(PL);
    end;

    var
        JobCalcStatistics: Codeunit "Job Calculate Statistics";
        PlaceHolderLbl: label 'Placeholder';
        CL: array [16] of Decimal;
        PL: array [16] of Decimal;

    local procedure ShowDetails()
    begin
        Page.Run(Page::"Job Card",Rec);
    end;
}

