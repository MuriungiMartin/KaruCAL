#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69117 "FLT-Driver Vehicle Card"
{
    PageType = List;
    SourceTable = UnknownTable61797;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Driver;Driver)
                {
                    ApplicationArea = Basic;
                }
                field("Driver Name";"Driver Name")
                {
                    ApplicationArea = Basic;
                }
                field("License Number";"License Number")
                {
                    ApplicationArea = Basic;
                }
                field("License Expiry";"License Expiry")
                {
                    ApplicationArea = Basic;
                }
                field(Vehicle;Vehicle)
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Make";"Vehicle Make")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Model";"Vehicle Model")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Registration No.";"Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                }
                field("To Date";"To Date")
                {
                    ApplicationArea = Basic;
                }
                field("Rotation No";"Rotation No")
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

