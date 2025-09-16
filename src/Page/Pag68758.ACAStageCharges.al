#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68758 "ACA-Stage Charges"
{
    PageType = List;
    SourceTable = UnknownTable61533;

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
                field("Settlement Type";"Settlement Type")
                {
                    ApplicationArea = Basic;
                }
                field(Semester;Semester)
                {
                    ApplicationArea = Basic;
                }
                field("Student Type";"Student Type")
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("Recovered First";"Recovered First")
                {
                    ApplicationArea = Basic;
                }
                field("Recovery Priority";"Recovery Priority")
                {
                    ApplicationArea = Basic;
                }
                field("Distribution (%)";"Distribution (%)")
                {
                    ApplicationArea = Basic;
                }
                field("Distribution Account";"Distribution Account")
                {
                    ApplicationArea = Basic;
                }
                field(Remarks;Remarks)
                {
                    ApplicationArea = Basic;
                }
                field("Programme Code";"Programme Code")
                {
                    ApplicationArea = Basic;
                }
                field("Stage Code";"Stage Code")
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

