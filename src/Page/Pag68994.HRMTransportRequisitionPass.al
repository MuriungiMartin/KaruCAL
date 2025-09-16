#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68994 "HRM-Transport Requisition Pass"
{
    PageType = List;
    SaveValues = false;
    SourceTable = UnknownTable61256;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Requisition No";"Requisition No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Passenger/s Full Name/s";"Passenger/s Full Name/s")
                {
                    ApplicationArea = Basic;
                }
                field(From;From)
                {
                    ApplicationArea = Basic;
                }
                field("To";"To")
                {
                    ApplicationArea = Basic;
                }
                field(Dept;Dept)
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

