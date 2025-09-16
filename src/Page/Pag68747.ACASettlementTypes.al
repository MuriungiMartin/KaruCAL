#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68747 "ACA-Settlement Types"
{
    PageType = List;
    SourceTable = UnknownTable61522;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Tuition G/L Account";"Tuition G/L Account")
                {
                    ApplicationArea = Basic;
                }
                field("Reg. No Prefix";"Reg. No Prefix")
                {
                    ApplicationArea = Basic;
                }
                field(Installments;Installments)
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

