#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68579 "HMS-Laboratory Request Line"
{
    PageType = ListPart;
    SourceTable = UnknownTable61417;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Laboratory Test Code";"Laboratory Test Code")
                {
                    ApplicationArea = Basic;
                }
                field("Laboratory Test Name";"Laboratory Test Name")
                {
                    ApplicationArea = Basic;
                }
                field("Specimen Code";"Specimen Code")
                {
                    ApplicationArea = Basic;
                }
                field("Specimen Name";"Specimen Name")
                {
                    ApplicationArea = Basic;
                }
                field("Assigned User ID";"Assigned User ID")
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

