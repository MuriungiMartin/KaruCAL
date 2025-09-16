#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7114 "Run Sales Analysis Line Templ."
{
    Caption = 'Run Sales Analysis Line Templ.';
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
        AnalysisLineTemplate.FilterGroup := 2;
        AnalysisLineTemplate.SetRange("Analysis Area",AnalysisLineTemplate."analysis area"::Sales);
        AnalysisLineTemplate.FilterGroup := 0;
        Page.RunModal(0,AnalysisLineTemplate);
    end;

    var
        AnalysisLineTemplate: Record "Analysis Line Template";
}

