#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 55504 "FLT-Fuel Types"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable55504;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Fuel Type";"Fuel Type")
                {
                    ApplicationArea = Basic;
                }
                field("Current Price";"Current Price")
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

