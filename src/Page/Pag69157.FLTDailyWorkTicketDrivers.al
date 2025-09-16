#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69157 "FLT-Daily Work Ticket Drivers"
{
    PageType = ListPart;
    SourceTable = UnknownTable61811;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("line No.";"line No.")
                {
                    ApplicationArea = Basic;
                }
                field("Driver No.";"Driver No.")
                {
                    ApplicationArea = Basic;
                }
                field("Driver Name";"Driver Name")
                {
                    ApplicationArea = Basic;
                }
                field("Total Milleage";"Total Milleage")
                {
                    ApplicationArea = Basic;
                }
                field("Total Fuel Consumed";"Total Fuel Consumed")
                {
                    ApplicationArea = Basic;
                }
                field("Ticket No.";"Ticket No.")
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

