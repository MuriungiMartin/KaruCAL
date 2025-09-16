#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68612 "HMS Referral List"
{
    PageType = List;
    SourceTable = UnknownTable61433;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Treatment no.";"Treatment no.")
                {
                    ApplicationArea = Basic;
                }
                field("Hospital No.";"Hospital No.")
                {
                    ApplicationArea = Basic;
                }
                field("Patient No.";"Patient No.")
                {
                    ApplicationArea = Basic;
                }
                field("Date Referred";"Date Referred")
                {
                    ApplicationArea = Basic;
                }
                field("Referral Reason";"Referral Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Referral Remarks";"Referral Remarks")
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

