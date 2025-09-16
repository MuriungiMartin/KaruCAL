#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68703 "ELECT Candidate Line"
{
    PageType = List;
    SourceTable = UnknownTable61462;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field("Position Name";"Position Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Confirmed;Confirmed)
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
}

