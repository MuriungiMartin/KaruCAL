#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68633 "HMS Drug Interaction Line"
{
    PageType = ListPart;
    SourceTable = UnknownTable61438;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field("Drug No. 1";"Drug No. 1")
                {
                    ApplicationArea = Basic;
                }
                field("Drug Name 1";"Drug Name 1")
                {
                    ApplicationArea = Basic;
                }
                field("Not Compatible";"Not Compatible")
                {
                    ApplicationArea = Basic;
                }
                field("Alert Remarks";"Alert Remarks")
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

