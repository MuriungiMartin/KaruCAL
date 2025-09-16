#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77388 "Category Funding Sources"
{
    PageType = List;
    SourceTable = UnknownTable77388;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Funding Source Code";"Funding Source Code")
                {
                    ApplicationArea = Basic;
                }
                field("Funding %";"Funding %")
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

