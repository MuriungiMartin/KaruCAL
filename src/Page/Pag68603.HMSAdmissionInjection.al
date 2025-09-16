#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68603 "HMS Admission Injection"
{
    PageType = ListPart;
    SourceTable = UnknownTable61429;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Time;Time)
                {
                    ApplicationArea = Basic;
                }
                field("Injection Code";"Injection Code")
                {
                    ApplicationArea = Basic;
                }
                field("Injection Name";"Injection Name")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
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

