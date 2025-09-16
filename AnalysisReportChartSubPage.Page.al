#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 778 "Analysis Report Chart SubPage"
{
    Caption = 'Analysis Report Chart SubPage';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Analysis Report Chart Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Analysis Line Template Name";"Analysis Line Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Analysis Column Template Name";"Analysis Column Template Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name. This field is intended only for internal use.';
                    Visible = false;
                }
                field("Original Measure Name";"Original Measure Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the analysis report columns or lines that you select to insert in the Analysis Report Chart Setup window.';
                    Visible = false;
                }
                field("Measure Name";"Measure Name")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the analysis report columns or lines that the measures on the y-axis in the specific chart are based on.';
                }
                field("Chart Type";"Chart Type")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how the analysis report values are represented graphically in the specific chart.';
                    Visible = IsMeasure;

                    trigger OnValidate()
                    begin
                        if "Chart Type" = "chart type"::" " then
                          CurrPage.Update;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Edit)
            {
                ApplicationArea = Suite;
                Caption = 'Edit';
                Image = EditLines;
                ToolTip = 'Edit the chart.';

                trigger OnAction()
                var
                    AnalysisReportChartLine: Record "Analysis Report Chart Line";
                    AnalysisReportChartLinePage: Page "Analysis Report Chart Line";
                    AnalysisReportChartMatrix: Page "Analysis Report Chart Matrix";
                begin
                    SetFilters(AnalysisReportChartLine);
                    AnalysisReportChartLine.SetRange("Chart Type");
                    case AnalysisReportChartSetup."Base X-Axis on" of
                      AnalysisReportChartSetup."base x-axis on"::Period:
                        if IsMeasure then begin
                          AnalysisReportChartMatrix.SetFilters(AnalysisReportChartSetup);
                          AnalysisReportChartMatrix.RunModal;
                        end;
                      AnalysisReportChartSetup."base x-axis on"::Line,
                      AnalysisReportChartSetup."base x-axis on"::Column:
                        begin
                          if IsMeasure then
                            AnalysisReportChartLinePage.SetViewAsMeasure(true)
                          else
                            AnalysisReportChartLinePage.SetViewAsMeasure(false);
                          AnalysisReportChartLinePage.SetTableview(AnalysisReportChartLine);
                          AnalysisReportChartLinePage.RunModal;
                        end;
                    end;

                    CurrPage.Update;
                end;
            }
            action(Delete)
            {
                ApplicationArea = Suite;
                Caption = 'Delete';
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                var
                    AnalysisReportChartLine: Record "Analysis Report Chart Line";
                begin
                    CurrPage.SetSelectionFilter(AnalysisReportChartLine);
                    AnalysisReportChartLine.ModifyAll("Chart Type","chart type"::" ");
                    CurrPage.Update;
                end;
            }
            action("Reset to default setup")
            {
                ApplicationArea = Suite;
                Caption = 'Reset to Default Setup';
                Image = Refresh;
                ToolTip = 'Undo your change and return to the default setup.';

                trigger OnAction()
                begin
                    AnalysisReportChartSetup.RefreshLines(false);
                end;
            }
        }
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        SetFilters(Rec);
        exit(FindSet);
    end;

    var
        AnalysisReportChartSetup: Record "Analysis Report Chart Setup";
        IsMeasure: Boolean;


    procedure SetViewAsMeasure(Value: Boolean)
    begin
        IsMeasure := Value;
    end;

    local procedure SetFilters(var AnalysisReportChartLine: Record "Analysis Report Chart Line")
    begin
        with AnalysisReportChartLine do begin
          Reset;
          if IsMeasure then
            AnalysisReportChartSetup.SetLinkToMeasureLines(AnalysisReportChartLine)
          else
            AnalysisReportChartSetup.SetLinkToDimensionLines(AnalysisReportChartLine);
          SetFilter("Chart Type",'<>%1',"chart type"::" ");
        end;
    end;


    procedure SetSetupRec(var NewAnalysisReportChartSetup: Record "Analysis Report Chart Setup")
    begin
        AnalysisReportChartSetup := NewAnalysisReportChartSetup;
    end;
}

