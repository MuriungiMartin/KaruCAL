#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68593 "HMS Radiology List"
{
    PageType = List;
    SourceTable = UnknownTable61419;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Radiology No.";"Radiology No.")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Date";"Radiology Date")
                {
                    ApplicationArea = Basic;
                }
                field("Radiology Time";"Radiology Time")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Supervisor ID";"Supervisor ID")
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

