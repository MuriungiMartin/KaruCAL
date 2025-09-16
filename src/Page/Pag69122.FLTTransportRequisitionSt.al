#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69122 "FLT-Transport Requisition St"
{
    PageType = List;
    SourceTable = UnknownTable61802;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee No";"Employee No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
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

