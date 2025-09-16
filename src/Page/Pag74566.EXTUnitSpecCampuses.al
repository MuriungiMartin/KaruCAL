#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 74566 "EXT-Unit Spec. Campuses"
{
    Caption = 'Unit Specific Campuses';
    PageType = List;
    SourceTable = UnknownTable74564;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Campus Code";"Campus Code")
                {
                    ApplicationArea = Basic;
                }
                field("Constraint Category";"Constraint Category")
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

