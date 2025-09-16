#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 90040 "Tuition Fee Tagging"
{
    PageType = List;
    SourceTable = UnknownTable90027;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Document No";"Document No")
                {
                    ApplicationArea = Basic;
                }
                field("Student No.";"Student No.")
                {
                    ApplicationArea = Basic;
                }
                field("Student Name";"Student Name")
                {
                    ApplicationArea = Basic;
                }
                field("Posting Date";"Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = Basic;
                }
                field("G/l Tagge During Billing";"G/l Tagge During Billing")
                {
                    ApplicationArea = Basic;
                }
                field("G/l to be Tagged";"G/l to be Tagged")
                {
                    ApplicationArea = Basic;
                }
                field(Modified;Modified)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(UpdateLedgers)
            {
                ApplicationArea = Basic;
                RunObject = Report "Laboratory Requests Report";
            }
        }
    }
}

