#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68725 "HRM-Proffessional Membership"
{
    PageType = List;
    SourceTable = UnknownTable61194;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Membership No";"Membership No")
                {
                    ApplicationArea = Basic;
                }
                field("Name of Body";"Name of Body")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Membership";"Date of Membership")
                {
                    ApplicationArea = Basic;
                }
                field("Membership Status";"Membership Status")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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

