#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77706 "Venue Setup List"
{
    PageType = List;
    SourceTable = UnknownTable77706;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Venue Code";"Venue Code")
                {
                    ApplicationArea = Basic;
                }
                field("Venue Description";"Venue Description")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                }
                field(Capacity;Capacity)
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Book Id";"Book Id")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked From Date";"Booked From Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked To Date";"Booked To Date")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked From Time";"Booked From Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked To Time";"Booked To Time")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked Department";"Booked Department")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked Department Name";"Booked Department Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked By Name";"Booked By Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Booked By Phone";"Booked By Phone")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }
}

