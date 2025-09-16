#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55503 "FLT-Permissions"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable55503;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic;
                }
                field("Can Set Fuel Prices";"Can Set Fuel Prices")
                {
                    ApplicationArea = Basic;
                }
                field("Can Manage Vehicles";"Can Manage Vehicles")
                {
                    ApplicationArea = Basic;
                }
                field("Can Manage Drivers";"Can Manage Drivers")
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

