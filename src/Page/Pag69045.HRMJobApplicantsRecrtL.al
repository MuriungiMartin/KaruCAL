#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 69045 "HRM-Job Applicants - Recrt L"
{
    CardPageID = "HRM-Job Applicants - Apt.Card";
    PageType = List;
    SourceTable = UnknownTable61666;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No;No)
                {
                    ApplicationArea = Basic;
                }
                field("Stage Code";"Stage Code")
                {
                    ApplicationArea = Basic;
                }
                field("Date of Test";"Date of Test")
                {
                    ApplicationArea = Basic;
                }
                field(Venue;Venue)
                {
                    ApplicationArea = Basic;
                }
                field("Start Time";"Start Time")
                {
                    ApplicationArea = Basic;
                }
                field("End Time";"End Time")
                {
                    ApplicationArea = Basic;
                }
                field("Personnel in charge";"Personnel in charge")
                {
                    ApplicationArea = Basic;
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic;
                }
                field("Test Particulars";"Test Particulars")
                {
                    ApplicationArea = Basic;
                }
                field("Personnel in charge Name";"Personnel in charge Name")
                {
                    ApplicationArea = Basic;
                }
                field("Job No.";"Job No.")
                {
                    ApplicationArea = Basic;
                }
                field("Job Description";"Job Description")
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

