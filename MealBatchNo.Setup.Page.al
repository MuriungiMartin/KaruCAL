#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99915 "Meal Batch No. Setup"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable99907;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Product Class";"Product Class")
                {
                    ApplicationArea = Basic;
                }
                field("Batch No. Series";"Batch No. Series")
                {
                    ApplicationArea = Basic;
                }
                field("Expiration computation";"Expiration computation")
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

