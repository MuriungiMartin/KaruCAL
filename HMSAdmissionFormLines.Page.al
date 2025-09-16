#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68599 "HMS Admission Form Lines"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
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
                }
                field(Ward;Ward)
                {
                    ApplicationArea = Basic;
                }
                field(Bed;Bed)
                {
                    ApplicationArea = Basic;
                }
                field("Admission Date";"Admission Date")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Time";"Admission Time")
                {
                    ApplicationArea = Basic;
                }
                field("Admission Area";"Admission Area")
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

