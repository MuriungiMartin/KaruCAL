#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 385 "Report Selection - Bank Acc."
{
    ApplicationArea = Basic;
    Caption = 'Report Selection - Bank Acc.';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(ReportUsage2;ReportUsage2)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Usage';
                OptionCaption = 'Statement,Reconciliation - Test,Check';
                ToolTip = 'Specifies which type of document the report is used for.';

                trigger OnValidate()
                begin
                    SetUsageFilter(true);
                end;
            }
            repeater(Control1)
            {
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.';
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the ID of the report that the program will print.';
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the report.';
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        NewRecord;
    end;

    trigger OnOpenPage()
    begin
        SetUsageFilter(false);
    end;

    var
        ReportUsage2: Option Statement,"Reconciliation - Test",Check;

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
          if Modify then;
        FilterGroup(2);
        SetRange(Usage,Usage::"B.Stmt" + ReportUsage2);
        FilterGroup(0);
        CurrPage.Update;
    end;
}

