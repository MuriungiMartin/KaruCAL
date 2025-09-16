#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51185 "HR Job Interview Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Job Interview Details.rdlc';

    dataset
    {
        dataitem(UnknownTable61225;UnknownTable61225)
        {
            RequestFilterFields = "Application No";
            column(ReportForNavId_3952; 3952)
            {
            }
            column(USERID;UserId)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(HR_Job_Applications__Application_No_;"Application No")
            {
            }
            column(HR_Job_Applications__First_Name_;"First Name")
            {
            }
            column(HR_Job_Applications__Middle_Name_;"Middle Name")
            {
            }
            column(HR_Job_Applications__Last_Name_;"Last Name")
            {
            }
            column(HR_Job_Applications__Job_Applied_For_;"Job Applied For")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(HR_Job_InterviewCaption;HR_Job_InterviewCaptionLbl)
            {
            }
            column(HR_Job_Applications__Application_No_Caption;FieldCaption("Application No"))
            {
            }
            column(HR_Job_Applications__First_Name_Caption;FieldCaption("First Name"))
            {
            }
            column(HR_Job_Applications__Middle_Name_Caption;FieldCaption("Middle Name"))
            {
            }
            column(HR_Job_Applications__Last_Name_Caption;FieldCaption("Last Name"))
            {
            }
            column(HR_Job_Applications__Job_Applied_For_Caption;FieldCaption("Job Applied For"))
            {
            }
            dataitem(UnknownTable61255;UnknownTable61255)
            {
                DataItemLink = "Applicant No"=field("Application No");
                DataItemTableView = sorting("Applicant No","Line No");
                RequestFilterFields = "Applicant No";
                column(ReportForNavId_5679; 5679)
                {
                }
                column(HR_Job_Interview__Applicant_No_;"Applicant No")
                {
                }
                column(HR_Job_Interview__Interview_Code_;"Interview Code")
                {
                }
                column(HR_Job_Interview__Interview_Description_;"Interview Description")
                {
                }
                column(HR_Job_Interview_Score;Score)
                {
                }
                column(HR_Job_Interview__Total_Score_;"Total Score")
                {
                }
                column(HR_Job_Interview_comments;comments)
                {
                }
                column(HR_Job_Interview__Applicant_No_Caption;FieldCaption("Applicant No"))
                {
                }
                column(HR_Job_Interview__Interview_Code_Caption;FieldCaption("Interview Code"))
                {
                }
                column(HR_Job_Interview__Interview_Description_Caption;FieldCaption("Interview Description"))
                {
                }
                column(HR_Job_Interview_ScoreCaption;FieldCaption(Score))
                {
                }
                column(HR_Job_Interview__Total_Score_Caption;FieldCaption("Total Score"))
                {
                }
                column(HR_Job_Interview_commentsCaption;FieldCaption(comments))
                {
                }
                column(HR_Job_Interview_Line_No;"Line No")
                {
                }

                trigger OnPreDataItem()
                begin
                    LastFieldNo := FieldNo("Applicant No");
                end;
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
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        HR_Job_InterviewCaptionLbl: label 'HR Job Interview';
}

