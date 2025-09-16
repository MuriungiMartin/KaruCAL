#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68613 "HMS Admission List"
{
    PageType = List;
    SourceTable = UnknownTable61426;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Admission No.";"Admission No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'No.';
                }
                field("Link Type";"Link Type")
                {
                    ApplicationArea = Basic;
                }
                field("Link No.";"Link No.")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                }
                field("Admission Time";"Admission Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Time';
                }
                field(Ward;Ward)
                {
                    ApplicationArea = Basic;
                }
                field(Bed;Bed)
                {
                    ApplicationArea = Basic;
                }
                field(Doctor;Doctor)
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
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

