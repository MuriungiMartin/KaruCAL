#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9376 "Analysis Report Sale"
{
    ApplicationArea = Basic;
    Caption = 'Analysis Report Sale';
    PageType = List;
    SourceTable = "Analysis Report Name";
    SourceTableView = where("Analysis Area"=const(Sales));
    UsageCategory = ReportsandAnalysis;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the analysis report name.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the analysis report description.';
                }
                field("Analysis Line Template Name";"Analysis Line Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the analysis line template name for this analysis report.';
                }
                field("Analysis Column Template Name";"Analysis Column Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the column template name for this analysis report.';
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
        area(processing)
        {
            action(EditAnalysisReport)
            {
                ApplicationArea = Basic;
                Caption = 'Edit Analysis Report';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                ShortCutKey = 'Return';
                ToolTip = 'Open the window for the analysis report.';

                trigger OnAction()
                var
                    SalesAnalysisReport: Page "Sales Analysis Report";
                begin
                    SalesAnalysisReport.SetReportName(Name);
                    SalesAnalysisReport.Run;
                end;
            }
        }
    }
}

