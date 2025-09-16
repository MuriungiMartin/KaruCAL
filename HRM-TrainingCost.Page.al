#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68987 "HRM-Training Cost"
{
    PageType = List;
    SourceTable = UnknownTable61248;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Training Id";"Training Id")
                {
                    ApplicationArea = Basic;
                }
                field("Training Cost Item";"Training Cost Item")
                {
                    ApplicationArea = Basic;
                }
                field(Cost;Cost)
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

