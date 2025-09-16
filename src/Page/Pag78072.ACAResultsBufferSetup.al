#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78072 "ACA-Results Buffer Setup"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable78072;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Results/Buffer Presidence";"Results/Buffer Presidence")
                {
                    ApplicationArea = Basic;
                }
                field("Auto-post When Balance is zero";"Auto-post When Balance is zero")
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

