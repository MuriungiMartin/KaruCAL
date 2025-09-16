#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68359 "HRM-Correspondence History"
{
    PageType = ListPart;
    SourceTable = UnknownTable61200;

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                field("Job ID";"Job ID")
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
            }
        }
    }

    actions
    {
    }

    var
        WriteASCIIFile: File;
        TmpFilename: Text[250];
}

