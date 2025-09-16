#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 65204 "Lect Load Central Setup"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable65204;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Part-Time Charge";"Part-Time Charge")
                {
                    ApplicationArea = Basic;
                }
                field(Type;Type)
                {
                    ApplicationArea = Basic;
                }
                field("Part-Time Expenses Account";"Part-Time Expenses Account")
                {
                    ApplicationArea = Basic;
                }
                field("Payment Type";"Payment Type")
                {
                    ApplicationArea = Basic;
                }
                field("Vendor Posting Group";"Vendor Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field("Gen. Bus. Posting Group";"Gen. Bus. Posting Group")
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

