#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1707 "Deferral Sched. Arch. Subform"
{
    Caption = 'Deferral Schedule Detail';
    PageType = ListPart;
    SourceTable = "Deferral Line Archive";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a description of the record.';
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the line''s net amount.';
                }
            }
            group(Control8)
            {
                group(Control7)
                {
                    field(TotalDeferral;TotalDeferral)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Total Amount to Defer';
                        Editable = false;
                        Enabled = false;
                        ToolTip = 'Specifies the total amount to defer.';
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateTotal;
    end;

    trigger OnAfterGetRecord()
    begin
        Changed := false;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        UpdateTotal;
    end;

    var
        TotalDeferral: Decimal;
        Changed: Boolean;

    local procedure UpdateTotal()
    begin
        CalcTotal(Rec,TotalDeferral);
    end;

    local procedure CalcTotal(var DeferralLineArchive: Record "Deferral Line Archive";var TotalDeferral: Decimal)
    var
        DeferralLineArchiveTemp: Record "Deferral Line Archive";
        ShowTotalDeferral: Boolean;
    begin
        DeferralLineArchiveTemp.CopyFilters(DeferralLineArchive);
        ShowTotalDeferral := DeferralLineArchiveTemp.CalcSums(Amount);
        if ShowTotalDeferral then
          TotalDeferral := DeferralLineArchiveTemp.Amount;
    end;


    procedure GetChanged(): Boolean
    begin
        exit(Changed);
    end;
}

