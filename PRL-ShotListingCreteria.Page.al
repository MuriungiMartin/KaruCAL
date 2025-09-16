#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68089 "PRL-Shot Listing Creteria"
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
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                }
                field("Total Score";"Total Score")
                {
                    ApplicationArea = Basic;
                }
                field("Stage filter";"Stage filter")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recruitment Stage filter';
                }
            }
            part(Control1000000008;"PRL-Short Listing Lines")
            {
                SubPageLink = "Job ID"=field("Job ID"),
                              "Requitment Stage"=field("Stage filter");
            }
        }
    }

    actions
    {
    }
}

