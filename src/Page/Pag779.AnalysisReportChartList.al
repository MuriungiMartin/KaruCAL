#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 779 "Analysis Report Chart List"
{
    Caption = 'Analysis Report Chart List';
    CardPageID = "Analysis Report Chart Setup";
    PageType = List;
    SourceTable = "Analysis Report Chart Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ID. This field is intended only for internal use.';
                    Visible = false;
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the name of the specific chart.';
                }
                field("Analysis Area";"Analysis Area")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the analysis report chart shows values for sales, purchase, or inventory.';
                    Visible = false;
                }
                field("Analysis Report Name";"Analysis Report Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis report that is used to generate the specific chart that is shown in, for example, the Sales Performance window.';
                    Visible = false;
                }
                field("Analysis Line Template Name";"Analysis Line Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis line template that is used to generate the specific chart that is shown in, for example, the Sales Performance window.';
                    Visible = false;
                }
                field("Analysis Column Template Name";"Analysis Column Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis column template that is used to generate the chart that is shown in, for example, the Sales Performance window.';
                    Visible = false;
                }
                field("Base X-Axis on";"Base X-Axis on")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the values from the selected analysis report are displayed in the specific chart.';
                    Visible = false;
                }
                field("Start Date";"Start Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the first date on which analysis report values are included in the chart.';
                }
                field("End Date";"End Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the last date on which analysis report values are included in the chart.';
                }
                field("Period Length";"Period Length")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the length of periods in the chart.';
                    Visible = false;
                }
                field("No. of Periods";"No. of Periods")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many periods are shown in the chart.';
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Start Date" := WorkDate;
    end;
}

