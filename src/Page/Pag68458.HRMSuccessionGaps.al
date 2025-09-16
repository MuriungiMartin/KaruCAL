#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68458 "HRM-Succession Gaps"
{
    PageType = Worksheet;
    SourceTable = UnknownTable61495;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                Editable = false;
                field("Time In";"Time In")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Time Out";"Time Out")
                {
                    ApplicationArea = Basic;
                }
                field("Hours Done";"Hours Done")
                {
                    ApplicationArea = Basic;
                }
                field("Approver ID";"Approver ID")
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

