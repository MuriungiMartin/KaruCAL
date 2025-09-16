#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69133 "FLT-Setup"
{
    CardPageID = "FLT-Setup Card";
    ModifyAllowed = true;
    PageType = List;
    SourceTable = UnknownTable61800;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transport Req No";"Transport Req No")
                {
                    ApplicationArea = Basic;
                }
                field("Daily Work Ticket";"Daily Work Ticket")
                {
                    ApplicationArea = Basic;
                }
                field("Fuel Register";"Fuel Register")
                {
                    ApplicationArea = Basic;
                }
                field("Maintenance Request";"Maintenance Request")
                {
                    ApplicationArea = Basic;
                }
                field("Rotation Interval";"Rotation Interval")
                {
                    ApplicationArea = Basic;
                }
                field("Fuel Payment Batch No";"Fuel Payment Batch No")
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

