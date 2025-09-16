#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77711 "Venue Booking Permissions"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable77710;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Id";"User Id")
                {
                    ApplicationArea = Basic;
                }
                field("Can Edit/Create Venues";"Can Edit/Create Venues")
                {
                    ApplicationArea = Basic;
                }
                field("Can Approve Booking";"Can Approve Booking")
                {
                    ApplicationArea = Basic;
                }
                field("Can Edit Pending Bookings";"Can Edit Pending Bookings")
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

