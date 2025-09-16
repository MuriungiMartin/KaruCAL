#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68400 "HRM-J. Specification"
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
                Editable = false;
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
            }
            part(KPA;"HRM-Job Requirement Lines (B)")
            {
                SubPageLink = "Job Id"=field("Job ID");
            }
            label(Control1000000006)
            {
                ApplicationArea = Basic;
                CaptionClass = Text19024070;
                Style = Standard;
                StyleExpr = true;
            }
        }
    }

    actions
    {
    }

    var
        Text19024070: label 'Job Specification';
}

