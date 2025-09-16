#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68030 "FLT-Fuel Card"
{
    PageType = List;
    SourceTable = UnknownTable61029;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Reg No.";"Vehicle Reg No.")
                {
                    ApplicationArea = Basic;
                }
                field(Driver;Driver)
                {
                    ApplicationArea = Basic;
                }
                field("Ticket No.";"Ticket No.")
                {
                    ApplicationArea = Basic;
                }
                field("Place of Travel";"Place of Travel")
                {
                    ApplicationArea = Basic;
                }
                field("Odometer Reading";"Odometer Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Litres  Consumed";"Litres  Consumed")
                {
                    ApplicationArea = Basic;
                }
                field("Amount Per Litres";"Amount Per Litres")
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount";"Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Fueling Station";"Fueling Station")
                {
                    ApplicationArea = Basic;
                }
                field("Entered By";"Entered By")
                {
                    ApplicationArea = Basic;
                }
                field("Previous ODO Reading";"Previous ODO Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Fuel Type";"Fuel Type")
                {
                    ApplicationArea = Basic;
                }
                field("Service No.";"Service No.")
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

