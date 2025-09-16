#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69192 "Aca-Graduating Groups"
{
    PageType = List;
    SourceTable = "ACA-Graduation Groups";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Graduation Group";"Graduation Group")
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

