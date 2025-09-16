#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7113 "Analysis Column Templates"
{
    Caption = 'Analysis Column Templates';
    DataCaptionFields = "Analysis Area";
    PageType = List;
    SourceTable = "Analysis Column Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis column template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the analysis column template.';
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
            action(Columns)
            {
                ApplicationArea = Basic;
                Caption = '&Columns';
                Image = Column;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Species the columns on which the analysis view shows data.';

                trigger OnAction()
                var
                    AnalysisLine: Record "Analysis Line";
                    AnalysisReportMgt: Codeunit "Analysis Report Management";
                begin
                    AnalysisLine.FilterGroup := 2;
                    AnalysisLine.SetRange("Analysis Area",GetRangemax("Analysis Area"));
                    AnalysisLine.FilterGroup := 0;
                    AnalysisReportMgt.OpenAnalysisColumnsForm(AnalysisLine,Name);
                end;
            }
        }
    }
}

