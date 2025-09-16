#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68607 "HMS Admission Discharge List"
{
    PageType = List;
    SourceTable = UnknownTable61431;

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
                }
                field("Discharge Date";"Discharge Date")
                {
                    ApplicationArea = Basic;
                    Caption = 'Date';
                }
                field("Discharge Time";"Discharge Time")
                {
                    ApplicationArea = Basic;
                    Caption = 'Time';
                }
                field("Ward No.";"Ward No.")
                {
                    ApplicationArea = Basic;
                }
                field("Bed No.";"Bed No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Admission";"Date of Admission")
                {
                    ApplicationArea = Basic;
                }
                field("Time Of Admission";"Time Of Admission")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Doctor ID";"Doctor ID")
                {
                    ApplicationArea = Basic;
                }
                field("Nurse ID";"Nurse ID")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
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

