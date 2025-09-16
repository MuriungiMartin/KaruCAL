#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68223 "FIN-Financial Periods"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable61738;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Code";"Period Code")
                {
                    ApplicationArea = Basic;
                }
                field("Period Name";"Period Name")
                {
                    ApplicationArea = Basic;
                }
                field("Current Period";"Current Period")
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

