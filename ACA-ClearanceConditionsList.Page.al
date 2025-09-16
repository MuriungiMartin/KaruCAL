#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69072 "ACA-Clearance Conditions List"
{
    PageType = List;
    SourceTable = UnknownTable61759;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Clearance Level Code";"Clearance Level Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Sequence;Sequence)
                {
                    ApplicationArea = Basic;
                }
                field("Condition to Check";"Condition to Check")
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

