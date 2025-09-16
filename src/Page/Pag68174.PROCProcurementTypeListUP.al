#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68174 "PROC-Procurement Type List UP"
{
    DeleteAllowed = false;
    Editable = false;
    PageType = List;
    SourceTable = UnknownTable61726;

    layout
    {
        area(content)
        {
            repeater(Control1102756000)
            {
                field("Procurement Code";"Procurement Code")
                {
                    ApplicationArea = Basic;
                }
                field("Procurement Type";"Procurement Type")
                {
                    ApplicationArea = Basic;
                }
                field("Procurement Amount Type";"Procurement Amount Type")
                {
                    ApplicationArea = Basic;
                }
                field("Min. Amount";"Min. Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Max Amount";"Max Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Fixed Amount";"Fixed Amount")
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

