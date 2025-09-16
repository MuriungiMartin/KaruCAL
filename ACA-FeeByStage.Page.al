#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68748 "ACA-Fee By Stage"
{
    PageType = CardPart;
    SourceTable = UnknownTable61523;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                }
                field("Settlemet Type";"Settlemet Type")
                {
                    ApplicationArea = Basic;
                }
                field("Seq.";"Seq.")
                {
                    ApplicationArea = Basic;
                }
                field("Break Down";"Break Down")
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

