#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 99301 "Clearance Lists"
{
    PageType = List;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                }
                field(Name;Name)
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Status";"Clearance Status")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Initiated by";"Clearance Initiated by")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Initiated Date";"Clearance Initiated Date")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Initiated Time";"Clearance Initiated Time")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Semester";"Clearance Semester")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Academic Year";"Clearance Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Applied for Clearance";"Applied for Clearance")
                {
                    ApplicationArea = Basic;
                }
                field("Clearance Reason";"Clearance Reason")
                {
                    ApplicationArea = Basic;
                }
                field("Programme End Date";"Programme End Date")
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

