#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 7112 "Analysis Line Templates"
{
    Caption = 'Analysis Line Templates';
    DataCaptionFields = "Analysis Area";
    PageType = List;
    SourceTable = "Analysis Line Template";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis line template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the analysis line template.';
                }
                field("Default Column Template Name";"Default Column Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the column template name that you have set up for this analysis report.';
                    Visible = false;
                }
                field("Item Analysis View Code";"Item Analysis View Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the analysis view that the analysis report is based on.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemAnalysisView: Record "Item Analysis View";
                    begin
                        ItemAnalysisView.FilterGroup := 2;
                        ItemAnalysisView.SetRange("Analysis Area","Analysis Area");
                        ItemAnalysisView.FilterGroup := 0;
                        ItemAnalysisView."Analysis Area" := "Analysis Area";
                        ItemAnalysisView.Code := Text;
                        if Page.RunModal(0,ItemAnalysisView) = Action::LookupOK then begin
                          Text := ItemAnalysisView.Code;
                          exit(true);
                        end;
                    end;
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
            action(Lines)
            {
                ApplicationArea = Basic;
                Caption = '&Lines';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Specifies the lines in the analysis view that shows data.';

                trigger OnAction()
                var
                    AnalysisLine: Record "Analysis Line";
                    AnalysisReportMngt: Codeunit "Analysis Report Management";
                begin
                    AnalysisLine.FilterGroup := 2;
                    AnalysisLine.SetRange("Analysis Area","Analysis Area");
                    AnalysisLine.FilterGroup := 0;
                    AnalysisReportMngt.OpenAnalysisLinesForm(AnalysisLine,Name);
                end;
            }
        }
    }
}

