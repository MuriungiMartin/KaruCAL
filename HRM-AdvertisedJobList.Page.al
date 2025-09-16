#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68817 "HRM-Advertised Job List"
{
    CardPageID = "HRM-Advertised Job Card";
    PageType = List;
    SourceTable = UnknownTable61200;
    SourceTableView = where(Advertised=filter(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                }
                field("Reference Code";"Reference Code")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Date";"Requisition Date")
                {
                    ApplicationArea = Basic;
                }
                field(Priority;Priority)
                {
                    ApplicationArea = Basic;
                }
                field(Positions;Positions)
                {
                    ApplicationArea = Basic;
                }
                field(Approved;Approved)
                {
                    ApplicationArea = Basic;
                }
                field("Date Approved";"Date Approved")
                {
                    ApplicationArea = Basic;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field(Stage;Stage)
                {
                    ApplicationArea = Basic;
                }
                field(Score;Score)
                {
                    ApplicationArea = Basic;
                }
                field("Stage Code";"Stage Code")
                {
                    ApplicationArea = Basic;
                }
                field(Qualified;Qualified)
                {
                    ApplicationArea = Basic;
                }
                field("Job Supervisor/Manager";"Job Supervisor/Manager")
                {
                    ApplicationArea = Basic;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field("Turn Around Time";"Turn Around Time")
                {
                    ApplicationArea = Basic;
                }
                field("Grace Period";"Grace Period")
                {
                    ApplicationArea = Basic;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = Basic;
                }
                field("Requisition Type";"Requisition Type")
                {
                    ApplicationArea = Basic;
                }
                field("Closing Date";"Closing Date")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Required Positions";"Required Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Vacant Positions";"Vacant Positions")
                {
                    ApplicationArea = Basic;
                }
                field("Reason for Request(Other)";"Reason for Request(Other)")
                {
                    ApplicationArea = Basic;
                }
                field("Any Additional Information";"Any Additional Information")
                {
                    ApplicationArea = Basic;
                }
                field("Job Grade";"Job Grade")
                {
                    ApplicationArea = Basic;
                }
                field("Type of Contract Required";"Type of Contract Required")
                {
                    ApplicationArea = Basic;
                }
                field("Requisition No.";"Requisition No.")
                {
                    ApplicationArea = Basic;
                }
                field(Gender;Gender)
                {
                    ApplicationArea = Basic;
                }
                field("Job Ref No";"Job Ref No")
                {
                    ApplicationArea = Basic;
                }
                field(Advertised;Advertised)
                {
                    ApplicationArea = Basic;
                }
                field("Opening Date";"Opening Date")
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

