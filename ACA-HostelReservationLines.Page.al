#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68127 "ACA-Hostel Reservation Lines"
{
    PageType = ListPart;
    SourceTable = "ACA-Hostel Reservation Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Hostel No";"Hostel No")
                {
                    ApplicationArea = Basic;
                }
                field("Room No";"Room No")
                {
                    ApplicationArea = Basic;
                }
                field("Space No";"Space No")
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

