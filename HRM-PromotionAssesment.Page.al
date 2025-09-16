#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68413 "HRM-Promotion Assesment"
{
    PageType = ListPart;
    SourceTable = UnknownTable61312;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field(Date;Date)
                {
                    ApplicationArea = Basic;
                }
                field(Position;Position)
                {
                    ApplicationArea = Basic;
                }
                field(Level;Level)
                {
                    ApplicationArea = Basic;
                }
                field("Contract Type";"Contract Type")
                {
                    ApplicationArea = Basic;
                }
                field(Approved;Approved)
                {
                    ApplicationArea = Basic;
                }
                field("Approval Date";"Approval Date")
                {
                    ApplicationArea = Basic;
                }
                field("Date Re-Assigned";"Date Re-Assigned")
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

