#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68594 "HMS Laboratory List"
{
    CardPageID = "HMS-Laboratory Form Test";
    PageType = List;
    SourceTable = UnknownTable61416;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Laboratory No.";"Laboratory No.")
                {
                    ApplicationArea = Basic;
                }
                field("Link Type";"Link Type")
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Date";"Laboratory Date")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Time";"Laboratory Time")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Scheduled Date";"Scheduled Date")
                {
                    ApplicationArea = Basic;
                }
                field("Scheduled Time";"Scheduled Time")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor ID";"Supervisor ID")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

