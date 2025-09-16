#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68051 "HRM-Emp. Beneficiaries Lists"
{
    PageType = List;
    SourceTable = UnknownTable61324;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No";"Entry No")
                {
                    ApplicationArea = Basic;
                }
                field("Employee Code";"Employee Code")
                {
                    ApplicationArea = Basic;
                }
                field(Relationship;Relationship)
                {
                    ApplicationArea = Basic;
                }
                field(SurName;SurName)
                {
                    ApplicationArea = Basic;
                }
                field("Other Names";"Other Names")
                {
                    ApplicationArea = Basic;
                }
                field("ID No/Passport No";"ID No/Passport No")
                {
                    ApplicationArea = Basic;
                }
                field("Office Tel No";"Office Tel No")
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

