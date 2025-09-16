#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 61752 "ACA-Clearance Property Update"
{
    PageType = List;
    SourceTable = UnknownTable61752;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Property Code";"Property Code")
                {
                    ApplicationArea = Basic;
                }
                field("Property Description";"Property Description")
                {
                    ApplicationArea = Basic;
                }
                field("Property Value";"Property Value")
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

