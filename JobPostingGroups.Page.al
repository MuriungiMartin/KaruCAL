#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 211 "Job Posting Groups"
{
    ApplicationArea = Basic;
    Caption = 'Job Posting Groups';
    PageType = List;
    SourceTable = "Job Posting Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a code for this posting group.';
                }
                field("WIP Costs Account";"WIP Costs Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the work in process (WIP) account for the calculated cost of the job WIP for job tasks with this posting group. The account is normally a balance sheet asset account.';
                }
                field("WIP Accrued Costs Account";"WIP Accrued Costs Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an account that accumulates postings when the costs recognized, based on the invoiced value of the job, are greater than the current usage total posted If the WIP method for the job is Cost Value or Cost of Sales. The account is normally a balance sheet accrued expense liability account.';
                }
                field("Job Costs Applied Account";"Job Costs Applied Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the balancing account to WIP Cost Account. The account is normally a contra (or Credit) expense account.';
                }
                field("Item Costs Applied Account";"Item Costs Applied Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the balancing account to the WIP Cost Account.';
                }
                field("Resource Costs Applied Account";"Resource Costs Applied Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the balancing account for the WIP Costs Account field in the Job Posting Groups window.';
                }
                field("G/L Costs Applied Account";"G/L Costs Applied Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the balancing account to the WIP Cost Account.';
                }
                field("Job Costs Adjustment Account";"Job Costs Adjustment Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the balancing account to WIP Accrued Costs account if the work in process (WIP) method for the job is Cost Value or Cost of Sales. The account is normally an expense account.';
                }
                field("G/L Expense Acc. (Contract)";"G/L Expense Acc. (Contract)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the sales account to be used for general ledger expenses in job tasks with this posting group. If left empty, the G/L account entered on the planning line will be used.';
                }
                field("WIP Accrued Sales Account";"WIP Accrued Sales Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an account that will be posted to when the revenue that can be recognized for the job is greater than the current invoiced value for the job if the work in process (WIP) method for the job is Sales Value.';
                }
                field("WIP Invoiced Sales Account";"WIP Invoiced Sales Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the account for the invoiced value, for the job for job tasks, with this posting group. The account is normally a Balance sheet liability account.';
                }
                field("Job Sales Applied Account";"Job Sales Applied Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the balancing account to WIP Invoiced Sales Account. The account is normally a contra (or debit) income account.';
                }
                field("Job Sales Adjustment Account";"Job Sales Adjustment Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the balancing account to the WIP Accrued Sales account if the work in process (WIP) Method for the job is the Sales Value. The account is normally an income account.';
                }
                field("Recognized Costs Account";"Recognized Costs Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the account for recognized costs for the job. The account is normally an expense account.';
                }
                field("Recognized Sales Account";"Recognized Sales Account")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the account for recognized sales (or revenue) for the job. The account is normally an income account.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

