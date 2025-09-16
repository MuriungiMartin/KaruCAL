#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 61832 "ACA-Hostel Incidents"
{
    PageType = List;
    SourceTable = "Hostel Incidents Register";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incident No.";"Incident No.")
                {
                    ApplicationArea = Basic;
                    Enabled = false;
                    Visible = false;
                }
                field("Hostel Block No.";"Hostel Block No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
                field("Day/Night";"Day/Night")
                {
                    ApplicationArea = Basic;
                }
                field("Report Summary";"Report Summary")
                {
                    ApplicationArea = Basic;
                }
                field("Report Details";"Report Details")
                {
                    ApplicationArea = Basic;
                }
                field("Incident Date";"Incident Date")
                {
                    ApplicationArea = Basic;
                }
                field("Incident Time";"Incident Time")
                {
                    ApplicationArea = Basic;
                }
                field("Report By";"Report By")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
    }

    actions
    {
    }
}

