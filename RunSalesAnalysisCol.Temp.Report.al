#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7117 "Run Sales Analysis Col. Temp."
{
    Caption = 'Run Sales Analysis Col. Temp.';
    ProcessingOnly = true;
    UsageCategory = Administration;
    UseRequestPage = false;

    dataset
    {
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        AnalysisColumnTemplate.FilterGroup := 2;
        AnalysisColumnTemplate.SetRange("Analysis Area",AnalysisColumnTemplate."analysis area"::Sales);
        AnalysisColumnTemplate.FilterGroup := 0;
        Page.RunModal(0,AnalysisColumnTemplate);
    end;

    var
        AnalysisColumnTemplate: Record "Analysis Column Template";
}

