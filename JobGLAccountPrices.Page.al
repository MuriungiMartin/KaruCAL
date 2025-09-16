#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1013 "Job G/L Account Prices"
{
    Caption = 'Job G/L Account Prices';
    PageType = List;
    SourceTable = "Job G/L Account Price";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job that this general ledger price applies to.';
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job task if the general ledger price should only apply to a specific job task.';
                }
                field("G/L Account No.";"G/L Account No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the G/L Account that this price applies to. Choose the field to see the available items.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies tithe code for the sales price currency if the price that you have set up in this line is in a foreign currency. Choose the field to see the available currency codes.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the sales price that applies to this line if an expense posted on this general ledger account should be charged to the customer with a fixed price, regardless of the cost. This price is in the currency specified in the Currency Code field, on this line.';
                }
                field("Unit Cost Factor";"Unit Cost Factor")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost factor, if you have agreed with your customer that he should pay certain expenses by cost value plus a certain percent, to cover your overhead expenses.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a line discount percent that applies to expenses related to this general ledger account. This is useful, for example if you want invoice lines for the job to show a discount percent.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost that normally applies to general ledger expenses for this line. This price is in the currency specified in the Currency Code field, on this line.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the description of the G/L Account No. you have entered in the G/L Account No. field.';
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

