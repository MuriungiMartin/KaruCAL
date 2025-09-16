#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1012 "Job Item Prices"
{
    Caption = 'Job Item Prices';
    PageType = List;
    SourceTable = "Job Item Price";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job that this item price applies to.';
                }
                field("Job Task No.";"Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the job task if the item price should only apply to a specific job task.';
                }
                field("Item No.";"Item No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the item that this price applies to. Choose the field to see the available items.';
                }
                field("Variant Code";"Variant Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the variant code if the price that you are setting up should apply to a specific variant of the item.';
                    Visible = false;
                }
                field("Unit of Measure Code";"Unit of Measure Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit of measure code if the price that you are setting up should apply to a specific unit of measure.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the default currency code that is defined for a job. Job item prices will only be used if the currency code for the job item is the same as the currency code set for the job.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the job-specific sales price that applies to this line. This price is in the currency that is represented by the code in the Currency Code field for this line. You can set the unit price to zero if you have agreed with your customer that usage of a certain item is non-chargeable. However, it is recommended that you set the discount to 100% instead.';
                }
                field("Unit Cost Factor";"Unit Cost Factor")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the unit cost factor, if you have agreed with your customer that he should pay certain item usage by cost value plus a certain percent value to cover your overhead expenses.';
                }
                field("Line Discount %";"Line Discount %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a job-specific line discount percent that applies to this line. This is useful, for example, if you want invoice lines for the job to show a discount percent.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the description of the item you have entered in the Item No. field.';
                }
                field("Apply Job Discount";"Apply Job Discount")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the check box for this field if the job-specific discount percent for this item should apply to the job. The default line discount for the line that is defined is included when job entries are created, but you can modify this value.';
                    Visible = false;
                }
                field("Apply Job Price";"Apply Job Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the job-specific price or unit cost factor for this item should apply to the job. The default job price that is defined is included when job-related entries are created, but you can modify this value.';
                    Visible = false;
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

