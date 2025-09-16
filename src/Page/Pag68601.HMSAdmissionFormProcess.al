#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68601 "HMS Admission Form Process"
{
    PageType = ListPart;
    SourceTable = UnknownTable61427;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Process Code";"Process Code")
                {
                    ApplicationArea = Basic;
                }
                field(Process;Process)
                {
                    ApplicationArea = Basic;
                }
                field(Mandatory;Mandatory)
                {
                    ApplicationArea = Basic;
                }
                field(Performed;Performed)
                {
                    ApplicationArea = Basic;
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Time;Time)
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

