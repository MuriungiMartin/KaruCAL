#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90021 "FIN-Claims Setup"
{
    ApplicationArea = Basic;
    PageType = Card;
    SourceTable = UnknownTable90020;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Medical Claims No.";"Medical Claims No.")
                {
                    ApplicationArea = Basic;
                }
                field("Claim payment Type";"Claim payment Type")
                {
                    ApplicationArea = Basic;
                }
                field("In-Patient Account";"In-Patient Account")
                {
                    ApplicationArea = Basic;
                }
                field("Out-Patient Account";"Out-Patient Account")
                {
                    ApplicationArea = Basic;
                }
                field("Optical Account";"Optical Account")
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

