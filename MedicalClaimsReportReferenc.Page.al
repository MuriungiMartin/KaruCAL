#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99918 "Medical Claims Report Referenc"
{
    PageType = List;
    SourceTable = UnknownTable99257;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(InCount;InCount)
                {
                    ApplicationArea = Basic;
                }
                field("PV Category";"PV Category")
                {
                    ApplicationArea = Basic;
                }
                field("Medical Claim";"Medical Claim")
                {
                    ApplicationArea = Basic;
                }
                field("is a Medical Claim";"is a Medical Claim")
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

