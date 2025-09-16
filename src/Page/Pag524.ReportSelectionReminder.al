#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 524 "Report Selection - Reminder"
{
    ApplicationArea = Basic;
    Caption = 'Report Selection - Reminder';
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
                ApplicationArea = Basic;
                Caption = 'Usage';
                OptionCaption = 'Reminder,Fin. Charge,Reminder Test,Fin. Charge Test';

                trigger OnValidate()
                begin
                    SetUsageFilter(true);
                end;
            }
            repeater(Control1)
            {
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a number that indicates where this report is in the printing order.';
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the ID of the report that will print.';
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    LookupPageID = Objects;
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
        ReportUsage2: Option Reminder,"Fin. Charge","Reminder Test","Fin. Charge Test";

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
          if Modify then;
        FilterGroup(2);
        case ReportUsage2 of
          Reportusage2::Reminder:
            SetRange(Usage,Usage::Reminder);
          Reportusage2::"Fin. Charge":
            SetRange(Usage,Usage::"Fin.Charge");
          Reportusage2::"Reminder Test":
            SetRange(Usage,Usage::"Rem.Test");
          Reportusage2::"Fin. Charge Test":
            SetRange(Usage,Usage::"F.C.Test");
        end;
        FilterGroup(0);
        CurrPage.Update;
    end;
}

