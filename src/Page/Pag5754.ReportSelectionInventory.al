#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5754 "Report Selection - Inventory"
{
    ApplicationArea = Basic;
    Caption = 'Report Selection - Inventory';
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
                OptionCaption = 'Transfer Order,Transfer Shipment,Transfer Receipt,Inventory Period Test,Assembly Order,Posted Assembly Order';
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
        ReportUsage2: Option "Transfer Order","Transfer Shipment","Transfer Receipt","Inventory Period Test","Assembly Order","Posted Assembly Order";

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
          if Modify then;
        FilterGroup(2);
        case ReportUsage2 of
          Reportusage2::"Transfer Order":
            SetRange(Usage,Usage::Inv1);
          Reportusage2::"Transfer Shipment":
            SetRange(Usage,Usage::Inv2);
          Reportusage2::"Transfer Receipt":
            SetRange(Usage,Usage::Inv3);
          Reportusage2::"Inventory Period Test":
            SetRange(Usage,Usage::"Invt. Period Test");
          Reportusage2::"Assembly Order":
            SetRange(Usage,Usage::"Asm. Order");
          Reportusage2::"Posted Assembly Order":
            SetRange(Usage,Usage::"P.Assembly Order");
        end;
        FilterGroup(0);
        CurrPage.Update;
    end;
}

