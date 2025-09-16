#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68028 "FLT-Vehicle Movement"
{
    PageType = Card;
    SourceTable = UnknownTable61027;

    layout
    {
        area(content)
        {
            group(General)
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
                field("Vehicle Type";"Vehicle Type")
                {
                    ApplicationArea = Basic;
                }
                field("Ticket No";"Ticket No")
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Station Code";"Station Code")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Location";"Vehicle Location")
                {
                    ApplicationArea = Basic;
                }
                field("Dispatched By";"Dispatched By")
                {
                    ApplicationArea = Basic;
                }
                field("Dispatch Date";"Dispatch Date")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field("Closed On";"Closed On")
                {
                    ApplicationArea = Basic;
                }
                field("Closed By";"Closed By")
                {
                    ApplicationArea = Basic;
                }
                field("Dispatch Type";"Dispatch Type")
                {
                    ApplicationArea = Basic;
                }
                field("Current ODO Reading";"Current ODO Reading")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Type";"Requisition Type")
                {
                    ApplicationArea = Basic;
                }
                part(Control1102755007;"FLT-Vehicle Movement Lines")
                {
                    SubPageLink = "No."=field("No.");
                }
            }
        }
    }

    actions
    {
    }
}

