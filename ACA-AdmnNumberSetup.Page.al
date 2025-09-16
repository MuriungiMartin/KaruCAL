#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68495 "ACA-Admn Number Setup"
{
    PageType = List;
    SourceTable = UnknownTable61371;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Degree;Degree)
                {
                    ApplicationArea = Basic;
                }
                field("Degree Name";"Degree Name")
                {
                    ApplicationArea = Basic;
                }
                field("Programme Prefix";"Programme Prefix")
                {
                    ApplicationArea = Basic;
                }
                field("JAB Prefix";"JAB Prefix")
                {
                    ApplicationArea = Basic;
                }
                field("SSP Prefix";"SSP Prefix")
                {
                    ApplicationArea = Basic;
                }
                field("No. Series";"No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(Year;Year)
                {
                    ApplicationArea = Basic;
                }
                field("Reporting Date";"Reporting Date")
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

