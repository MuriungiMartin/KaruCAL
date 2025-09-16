#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68470 "ACA-Application Form Qualif."
{
    PageType = ListPart;
    SourceTable = UnknownTable61361;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Where Obtained";"Where Obtained")
                {
                    ApplicationArea = Basic;
                }
                field(Qualification;Qualification)
                {
                    ApplicationArea = Basic;
                }
                field(Award;Award)
                {
                    ApplicationArea = Basic;
                }
                field("From Date";"From Date")
                {
                    ApplicationArea = Basic;
                }
                field("To Date";"To Date")
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

