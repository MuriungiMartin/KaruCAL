#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68986 "HRM-Training Partcipants"
{
    PageType = List;
    SourceTable = UnknownTable61249;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Training Code";"Training Code")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field("Employee name";"Employee name")
                {
                    ApplicationArea = Basic;
                }
                field(Objectives;Objectives)
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

