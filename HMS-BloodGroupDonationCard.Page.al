#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68551 "HMS-Blood Group Donation Card"
{
    PageType = Card;
    SourceTable = UnknownTable61401;

    layout
    {
        area(content)
        {
            repeater(Control1102760000)
            {
                field(Donor;Donor)
                {
                    ApplicationArea = Basic;
                }
                field(Recipient;Recipient)
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

