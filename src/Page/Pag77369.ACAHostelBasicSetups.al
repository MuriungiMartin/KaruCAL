#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77369 "ACA-Hostel Basic Setups"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "ACA-Hostel Basic Setups";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Current Academic Year";"Current Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Current Semester";"Current Semester")
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

