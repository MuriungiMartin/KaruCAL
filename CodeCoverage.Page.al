#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9990 "Code Coverage"
{
    ApplicationArea = Basic;
    Caption = 'Code Coverage';
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Worksheet;
    SourceTable = "Code Coverage";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Control22)
            {
                field(ObjectIdFilter;ObjectIdFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Object Id Filter';

                    trigger OnValidate()
                    begin
                        SetFilter("Object ID",ObjectIdFilter);
                        TotalCoveragePercent := CodeCoverageMgt.ObjectsCoverage(Rec,TotalNoofLines,TotalLinesHit) * 100;
                        CurrPage.Update(false);
                    end;
                }
                field(ObjectTypeFilter;ObjectTypeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Object Type Filter';

                    trigger OnValidate()
                    begin
                        SetFilter("Object Type",ObjectTypeFilter);
                        TotalCoveragePercent := CodeCoverageMgt.ObjectsCoverage(Rec,TotalNoofLines,TotalLinesHit);
                        CurrPage.Update(false);
                    end;
                }
                field(RequiredCoverage;RequiredCoveragePercent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Required Coverage %';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(false);
                    end;
                }
                field(TotalNoofLines;TotalNoofLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total # Lines';
                    Editable = false;
                }
                field(TotalCoveragePercent;TotalCoveragePercent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Total Coverage %';
                    DecimalPlaces = 2:2;
                    Editable = false;
                }
            }
            repeater("Object")
            {
                Caption = 'Object';
                Editable = false;
                IndentationColumn = Indent;
                ShowAsTree = true;
                field(CodeLine;CodeLine)
                {
                    ApplicationArea = Basic;
                    Caption = 'Code';
                }
                field(CoveragePercent;CoveragePercent)
                {
                    ApplicationArea = Basic;
                    Caption = 'Coverage %';
                    StyleExpr = CoveragePercentStyle;
                }
                field(LineType;"Line Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Type';
                }
                field(ObjectType;"Object Type")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object Type';
                }
                field(ObjectID;"Object ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Object ID';
                }
                field(LineNo;"Line No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line No.';
                }
                field(NoofLines;NoofLines)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of Lines';
                }
                field("No. of Hits";"No. of Hits")
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of Hits';
                }
                field(LinesHit;LinesHit)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of Hit Lines';
                }
                field(LinesNotHit;LinesNotHit)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. of Skipped Lines';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Start)
            {
                ApplicationArea = Basic;
                Caption = 'Start';
                Enabled = not CodeCoverageRunning;
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CodeCoverageMgt.Start(true);
                    CodeCoverageRunning := true;
                end;
            }
            action(Refresh)
            {
                ApplicationArea = Basic;
                Caption = 'Refresh';
                Enabled = CodeCoverageRunning;
                Image = Refresh;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CodeCoverageMgt.Refresh;
                end;
            }
            action(Stop)
            {
                ApplicationArea = Basic;
                Caption = 'Stop';
                Enabled = CodeCoverageRunning;
                Image = Stop;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CodeCoverageMgt.Stop;
                    TotalCoveragePercent := CodeCoverageMgt.ObjectsCoverage(Rec,TotalNoofLines,TotalLinesHit) * 100;
                    CodeCoverageRunning := false;
                end;
            }
        }
        area(navigation)
        {
            action("Load objects")
            {
                ApplicationArea = Basic;
                Caption = 'Load objects';
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Page.Run(Page::"Code Coverage Object");
                end;
            }
            action("Load country objects")
            {
                ApplicationArea = Basic;
                Caption = 'Load country objects';
                Image = AddContacts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    "Object": Record "Object";
                begin
                    ObjectIdFilter := '10000..99999|1000000..98999999';
                    Object.SetFilter(ID,ObjectIdFilter);
                    CodeCoverageInclude(Object);
                    SetFilter("Object ID",ObjectIdFilter)
                end;
            }
            action(DeleteNonMarked)
            {
                ApplicationArea = Basic;
                Caption = 'Delete Lines for Non-Marked Objects';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    CodeCoverageMgt.CleanupCodeCoverage;
                end;
            }
        }
        area(reporting)
        {
            action("Export to XML")
            {
                ApplicationArea = Basic;
                Caption = 'Export to XML';
                Image = Export;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CodeCoverage: Record "Code Coverage";
                    CodeCoverageSummary: XmlPort "Code Coverage Summary";
                begin
                    CodeCoverage.CopyFilters(Rec);
                    CodeCoverageSummary.SetTableview(CodeCoverage);
                    CodeCoverageSummary.Run;
                end;
            }
            action("Backup/Restore")
            {
                ApplicationArea = Basic;
                Caption = 'Backup/Restore';
                Image = Export;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CodeCoverageDetailed: XmlPort "Code Coverage Detailed";
                begin
                    CodeCoverageDetailed.Run;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        NoofLines := 0;
        LinesHit := 0;
        LinesNotHit := 0;
        Indent := 2;

        CodeLine := Line;

        case "Line Type" of
          "line type"::Object:
            // Sum object coverage
            begin
              CoveragePercent := CodeCoverageMgt.ObjectCoverage(Rec,NoofLines,LinesHit) * 100;
              LinesNotHit := NoofLines - LinesHit;
              Indent := 0
            end;
          "line type"::"Trigger/Function":
            // Sum method coverage
            begin
              CoveragePercent := CodeCoverageMgt.FunctionCoverage(Rec,NoofLines,LinesHit) * 100;
              LinesNotHit := NoofLines - LinesHit;
              Indent := 1
            end
          else begin
            if "No. of Hits" > 0 then
              CoveragePercent := 100
            else
              CoveragePercent := 0;
          end;
        end;

        SetStyles;
    end;

    trigger OnInit()
    begin
        RequiredCoveragePercent := 90;
    end;

    trigger OnOpenPage()
    begin
        CodeCoverageRunning := false;
    end;

    var
        CodeCoverageMgt: Codeunit "Code Coverage Mgt.";
        LinesHit: Integer;
        LinesNotHit: Integer;
        Indent: Integer;
        [InDataSet]
        CodeCoverageRunning: Boolean;
        CodeLine: Text[1024];
        [InDataSet]
        NoofLines: Integer;
        CoveragePercent: Decimal;
        TotalNoofLines: Integer;
        TotalCoveragePercent: Decimal;
        TotalLinesHit: Integer;
        ObjectIdFilter: Text;
        ObjectTypeFilter: Text;
        RequiredCoveragePercent: Integer;
        CoveragePercentStyle: Text;

    local procedure SetStyles()
    begin
        if "Line Type" = "line type"::Empty then
          CoveragePercentStyle := 'Standard'
        else
          if CoveragePercent < RequiredCoveragePercent then
            CoveragePercentStyle := 'Unfavorable'
          else
            CoveragePercentStyle := 'Favorable';
    end;
}

