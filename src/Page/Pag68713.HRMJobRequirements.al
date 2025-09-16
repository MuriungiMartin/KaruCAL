#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68713 "HRM-Job Requirements"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PromotedActionCategories = 'New,Process,Report,Functions';
    SourceTable = UnknownTable61193;

    layout
    {
        area(content)
        {
            group("Job Specification")
            {
                Caption = 'Job Details';
                field("Job ID";"Job ID")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                }
                field("Job Description";"Job Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    Enabled = false;
                    Importance = Promoted;
                }
            }
            part("Job Requirement Lines";"HRM-Applicant Qualif. lines")
            {
                Caption = 'Job Requirements';
                SubPageLink = "Job ID"=field("Job ID");
            }
        }
        area(factboxes)
        {
            systempart(Control1102755008;Outlook)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Job Requirements")
            {
                ApplicationArea = Basic;
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Employee Pay Element Summary";

                trigger OnAction()
                begin
                    HRJobReq.Reset;
                    HRJobReq.SetRange(HRJobReq."Job Id","Job ID");
                    if HRJobReq.Find('-') then
                    begin
                      Report.Run(39003924,true,true,HRJobReq);
                    end;
                end;
            }
        }
    }

    var
        HRJobReq: Record UnknownRecord61059;
}

