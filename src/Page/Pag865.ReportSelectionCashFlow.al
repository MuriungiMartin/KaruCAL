#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 865 "Report Selection - Cash Flow"
{
    ApplicationArea = Basic;
    Caption = 'Report Selection - Cash Flow';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Cash Flow Report Selection";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1002)
            {
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic,Suite;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the report that will be linked to a particular user and/or printer.';
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    LookupPageID = Objects;
                    ToolTip = 'Specifies the name of the report.';
                }
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
}

