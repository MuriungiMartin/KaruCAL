#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68615 "HMS Observation SubForm"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = UnknownTable61404;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                Editable = false;
                field("Observation No.";"Observation No.")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Type";"Observation Type")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Date";"Observation Date")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Time";"Observation Time")
                {
                    ApplicationArea = Basic;
                }
                field("Observation Remarks";"Observation Remarks")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
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
}

