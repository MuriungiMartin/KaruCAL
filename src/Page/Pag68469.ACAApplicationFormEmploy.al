#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68469 "ACA-Application Form Employ."
{
    PageType = ListPart;
    SourceTable = UnknownTable61360;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(From;From)
                {
                    ApplicationArea = Basic;
                }
                field("To";"To")
                {
                    ApplicationArea = Basic;
                }
                field(Organisation;Organisation)
                {
                    ApplicationArea = Basic;
                }
                field("Job Title";"Job Title")
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

