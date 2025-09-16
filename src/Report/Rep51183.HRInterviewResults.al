#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51183 "HR Interview Results"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Interview Results.rdlc';

    dataset
    {
        dataitem(UnknownTable61255;UnknownTable61255)
        {
            column(ReportForNavId_1102755000; 1102755000)
            {
            }
            column(ApplicantNo_HRJobInterview;"HRM-Job Interview"."Applicant No")
            {
            }
            column(InterviewCode_HRJobInterview;"HRM-Job Interview"."Interview Code")
            {
            }
            column(InterviewDescription_HRJobInterview;"HRM-Job Interview"."Interview Description")
            {
            }
            column(Score_HRJobInterview;"HRM-Job Interview".Score)
            {
            }
            column(TotalScore_HRJobInterview;"HRM-Job Interview"."Total Score")
            {
            }
            column(comments_HRJobInterview;"HRM-Job Interview".comments)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Applicants: Record UnknownRecord61115;
        ApplicantsDet: Text[200];
}

