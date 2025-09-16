#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77738 Tables
{
    PageType = List;
    SourceTable = "Table Permission Buffer";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Session ID";"Session ID")
                {
                    ApplicationArea = Basic;
                }
                field("Object Type";"Object Type")
                {
                    ApplicationArea = Basic;
                }
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic;
                }
                field("Object Name";"Object Name")
                {
                    ApplicationArea = Basic;
                }
                field("Read Permission";"Read Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Insert Permission";"Insert Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Modify Permission";"Modify Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Delete Permission";"Delete Permission")
                {
                    ApplicationArea = Basic;
                }
                field("Execute Permission";"Execute Permission")
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

