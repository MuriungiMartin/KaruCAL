#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5932 "Report Selection - Service"
{
    ApplicationArea = Basic;
    Caption = 'Report Selection - Service';
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
                OptionCaption = 'Quote,Order,Invoice,Credit Memo,Contract Quote,Contract,Service Document - Test,Shipment';

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
                }
                field("Report ID";"Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                }
                field("Report Caption";"Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    LookupPageID = Objects;
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
        ReportUsage2: Option Quote,"Order",Invoice,"Credit Memo","Contract Quote",Contract,"Service Document - Test",Shipment;

    local procedure SetUsageFilter(ModifyRec: Boolean)
    begin
        if ModifyRec then
          if Modify then;
        FilterGroup(2);
        case ReportUsage2 of
          Reportusage2::Quote:
            SetRange(Usage,Usage::"SM.Quote");
          Reportusage2::Order:
            SetRange(Usage,Usage::"SM.Order");
          Reportusage2::Shipment:
            SetRange(Usage,Usage::"SM.Shipment");
          Reportusage2::Invoice:
            SetRange(Usage,Usage::"SM.Invoice");
          Reportusage2::"Credit Memo":
            SetRange(Usage,Usage::"SM.Credit Memo");
          Reportusage2::"Contract Quote":
            SetRange(Usage,Usage::"SM.Contract Quote");
          Reportusage2::Contract:
            SetRange(Usage,Usage::"SM.Contract");
          Reportusage2::"Service Document - Test":
            SetRange(Usage,Usage::"SM.Test");
        end;
        FilterGroup(0);
        CurrPage.Update;
    end;
}

