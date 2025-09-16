#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 436 "Acc. Sched. BarChart DrillDown"
{
    TableNo = "Bar Chart Buffer";

    trigger OnRun()
    begin
        AccSchedLine."Schedule Name" := DelChr(CopyStr(Tag,1,10),'>');
        case "Series No." of
          1:
            Evaluate(AccSchedLine."Line No.",DelChr(CopyStr(Tag,11,8),'>'));
          2:
            Evaluate(AccSchedLine."Line No.",DelChr(CopyStr(Tag,19,8),'>'));
          3:
            Evaluate(AccSchedLine."Line No.",DelChr(CopyStr(Tag,27,8),'>'));
        end;
        AccSchedLine.Find;
        ColumnLayout."Column Layout Name" := DelChr(CopyStr(Tag,35,10),'>');
        Evaluate(ColumnLayout."Line No.",DelChr(CopyStr(Tag,45,8),'>'));
        ColumnLayout.Find;
        s := DelChr(CopyStr(Tag,53,20),'>');
        if s <> '' then
          AccSchedLine.SetFilter("Date Filter",s);
        s := DelChr(CopyStr(Tag,73,10),'>');
        if s <> '' then
          AccSchedLine.SetFilter("G/L Budget Filter",s);
        s := DelChr(CopyStr(Tag,83,42),'>');
        if s <> '' then
          AccSchedLine.SetFilter("Dimension 1 Filter",s);
        s := DelChr(CopyStr(Tag,125,42),'>');
        if s <> '' then
          AccSchedLine.SetFilter("Dimension 2 Filter",s);
        s := DelChr(CopyStr(Tag,167,42),'>');
        if s <> '' then
          AccSchedLine.SetFilter("Dimension 3 Filter",s);
        s := DelChr(CopyStr(Tag,209,42),'>');
        if s <> '' then
          AccSchedLine.SetFilter("Dimension 4 Filter",s);

        AccSchedManagement.CheckAnalysisView(AccSchedLine."Schedule Name",ColumnLayout."Column Layout Name",true);
        if AccSchedManagement.CalcCell(AccSchedLine,ColumnLayout,false) = 0 then; // init codeunit

        if ColumnLayout."Column Type" = ColumnLayout."column type"::Formula then
          Message(Text002,ColumnLayout.Formula)
        else
          with AccSchedLine do
            if "Totaling Type" in ["totaling type"::Formula,"totaling type"::"Set Base For Percent"] then
              Message(Text003,Totaling)
            else
              if Totaling <> '' then begin
                Copyfilter("Business Unit Filter",GLAcc."Business Unit Filter");
                Copyfilter("G/L Budget Filter",GLAcc."Budget Filter");
                AccSchedManagement.SetGLAccRowFilters(GLAcc,AccSchedLine);
                AccSchedManagement.SetGLAccColumnFilters(GLAcc,AccSchedLine,ColumnLayout);
                AccSchedName.Get("Schedule Name");
                if AccSchedName."Analysis View Name" = '' then begin
                  Copyfilter("Dimension 1 Filter",GLAcc."Global Dimension 1 Filter");
                  Copyfilter("Dimension 2 Filter",GLAcc."Global Dimension 2 Filter");
                  Copyfilter("Business Unit Filter",GLAcc."Business Unit Filter");
                  GLAcc.FilterGroup(2);
                  GLAcc.SetFilter("Global Dimension 1 Filter",AccSchedManagement.GetDimTotalingFilter(1,"Dimension 1 Totaling"));
                  GLAcc.SetFilter("Global Dimension 2 Filter",AccSchedManagement.GetDimTotalingFilter(2,"Dimension 2 Totaling"));
                  GLAcc.FilterGroup(8);
                  GLAcc.SetFilter(
                    "Global Dimension 1 Filter",AccSchedManagement.GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                  GLAcc.SetFilter(
                    "Global Dimension 2 Filter",AccSchedManagement.GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                  GLAcc.SetFilter("Business Unit Filter",ColumnLayout."Business Unit Totaling");
                  GLAcc.FilterGroup(0);
                  Page.Run(Page::"Chart of Accounts (G/L)",GLAcc)
                end else begin
                  GLAcc.Copyfilter("Date Filter",GLAccAnalysisView."Date Filter");
                  GLAcc.Copyfilter("Budget Filter",GLAccAnalysisView."Budget Filter");
                  GLAcc.Copyfilter("Business Unit Filter",GLAccAnalysisView."Business Unit Filter");
                  GLAccAnalysisView.SetRange("Analysis View Filter",AccSchedName."Analysis View Name");
                  Copyfilter("Dimension 1 Filter",GLAccAnalysisView."Dimension 1 Filter");
                  Copyfilter("Dimension 2 Filter",GLAccAnalysisView."Dimension 2 Filter");
                  Copyfilter("Dimension 3 Filter",GLAccAnalysisView."Dimension 3 Filter");
                  Copyfilter("Dimension 4 Filter",GLAccAnalysisView."Dimension 4 Filter");
                  GLAccAnalysisView.FilterGroup(2);
                  GLAccAnalysisView.SetFilter("Dimension 1 Filter",AccSchedManagement.GetDimTotalingFilter(1,"Dimension 1 Totaling"));
                  GLAccAnalysisView.SetFilter("Dimension 2 Filter",AccSchedManagement.GetDimTotalingFilter(2,"Dimension 2 Totaling"));
                  GLAccAnalysisView.SetFilter("Dimension 3 Filter",AccSchedManagement.GetDimTotalingFilter(3,"Dimension 3 Totaling"));
                  GLAccAnalysisView.SetFilter("Dimension 4 Filter",AccSchedManagement.GetDimTotalingFilter(4,"Dimension 4 Totaling"));
                  GLAccAnalysisView.FilterGroup(8);
                  GLAccAnalysisView.SetFilter(
                    "Dimension 1 Filter",
                    AccSchedManagement.GetDimTotalingFilter(1,ColumnLayout."Dimension 1 Totaling"));
                  GLAccAnalysisView.SetFilter(
                    "Dimension 2 Filter",
                    AccSchedManagement.GetDimTotalingFilter(2,ColumnLayout."Dimension 2 Totaling"));
                  GLAccAnalysisView.SetFilter(
                    "Dimension 3 Filter",
                    AccSchedManagement.GetDimTotalingFilter(3,ColumnLayout."Dimension 3 Totaling"));
                  GLAccAnalysisView.SetFilter(
                    "Dimension 4 Filter",
                    AccSchedManagement.GetDimTotalingFilter(4,ColumnLayout."Dimension 4 Totaling"));
                  GLAccAnalysisView.SetFilter("Business Unit Filter",ColumnLayout."Business Unit Totaling");
                  GLAccAnalysisView.FilterGroup(0);
                  Clear(ChartofAccAnalysisView);
                  ChartofAccAnalysisView.InsertTempGLAccAnalysisViews(GLAcc);
                  ChartofAccAnalysisView.SetTableview(GLAccAnalysisView);
                  ChartofAccAnalysisView.Run;
                end;
              end;
    end;

    var
        AccSchedLine: Record "Acc. Schedule Line";
        GLAcc: Record "G/L Account";
        GLAccAnalysisView: Record "G/L Account (Analysis View)";
        ColumnLayout: Record "Column Layout";
        AccSchedName: Record "Acc. Schedule Name";
        AccSchedManagement: Codeunit AccSchedManagement;
        ChartofAccAnalysisView: Page "Chart of Accs. (Analysis View)";
        Text002: label 'Column formula: %1';
        Text003: label 'Row formula: %1';
        s: Text[50];
}

