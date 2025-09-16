#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68041 "HRM-Job Requirement Header"
{
    PageType = Document;
    SourceTable = UnknownTable61056;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("No of Posts";"No of Posts")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                part(Control1000000008;"HRM-Job Requirement Lines (B)")
                {
                    SubPageLink = "Qualification Type"=field("Job ID");
                }
            }
        }
    }

    actions
    {
    }
}

