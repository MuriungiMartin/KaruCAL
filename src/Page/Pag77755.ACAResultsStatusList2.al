#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77755 "ACA-Results Status List2"
{
    PageType = List;
    SourceTable = UnknownTable61739;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Summary Page Caption";"Summary Page Caption")
                {
                    ApplicationArea = Basic;
                }
                field("Include Failed Units Headers";"Include Failed Units Headers")
                {
                    ApplicationArea = Basic;
                }
                field("Allowed Occurances";"Allowed Occurances")
                {
                    ApplicationArea = Basic;
                }
                field("Alternate Rubrics";"Alternate Rubrics")
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

