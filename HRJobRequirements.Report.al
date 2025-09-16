#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51168 "HR Job Requirements"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/HR Job Requirements.rdlc';

    dataset
    {
        dataitem(UnknownTable61193;UnknownTable61193)
        {
            RequestFilterFields = "Job ID";
            column(ReportForNavId_9002; 9002)
            {
            }
            column(PageConst_________FORMAT_CurrReport_PAGENO_;PageConst + ' ' + Format(CurrReport.PageNo))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CI_Picture;CI.Picture)
            {
            }
            column(CI_City;CI.City)
            {
            }
            column(CI__Address_2______CI__Post_Code_;CI."Address 2"+' '+CI."Post Code")
            {
            }
            column(CI_Address;CI.Address)
            {
            }
            column(CI_PhoneNo;CI."Phone No.")
            {
            }
            column(HR_Jobs__Job_ID_;"Job ID")
            {
            }
            column(HR_Jobs__Job_Description_;"Job Description")
            {
            }
            column(HR_Jobs__Main_Objective_;"Main Objective")
            {
            }
            column(HR_JobsCaption;HR_JobsCaptionLbl)
            {
            }
            column(Job_RequirementsCaption;Job_RequirementsCaptionLbl)
            {
            }
            column(P_O__BoxCaption;P_O__BoxCaptionLbl)
            {
            }
            column(HR_Jobs__Job_ID_Caption;FieldCaption("Job ID"))
            {
            }
            column(HR_Jobs__Job_Description_Caption;FieldCaption("Job Description"))
            {
            }
            column(HR_Jobs__Main_Objective_Caption;FieldCaption("Main Objective"))
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            dataitem(UnknownTable61195;UnknownTable61195)
            {
                DataItemLink = "Job Id"=field("Job ID");
                DataItemTableView = sorting("Job Id","Qualification Type","Qualification Code");
                column(ReportForNavId_5968; 5968)
                {
                }
                column(JobId_HRJobRequirements;"HRM-Job Requirements"."Job Id")
                {
                    IncludeCaption = true;
                }
                column(QualificationType_HRJobRequirements;"HRM-Job Requirements"."Qualification Type")
                {
                    IncludeCaption = true;
                }
                column(QualificationCode_HRJobRequirements;"HRM-Job Requirements"."Qualification Code")
                {
                    IncludeCaption = true;
                }
                column(Priority_HRJobRequirements;"HRM-Job Requirements".Priority)
                {
                    IncludeCaption = true;
                }
                column(ScoreID_HRJobRequirements;"HRM-Job Requirements"."Score ID")
                {
                    IncludeCaption = true;
                }
                column(Needcode_HRJobRequirements;"HRM-Job Requirements"."Need code")
                {
                    IncludeCaption = true;
                }
                column(StageCode_HRJobRequirements;"HRM-Job Requirements"."Stage Code")
                {
                    IncludeCaption = true;
                }
                column(Mandatory_HRJobRequirements;"HRM-Job Requirements".Mandatory)
                {
                    IncludeCaption = true;
                }
                column(DesiredScore_HRJobRequirements;"HRM-Job Requirements"."Desired Score")
                {
                    IncludeCaption = true;
                }
                column(TotalStageDesiredScore_HRJobRequirements;"HRM-Job Requirements"."Total (Stage)Desired Score")
                {
                    IncludeCaption = true;
                }
                column(QualificationDescription_HRJobRequirements;"HRM-Job Requirements"."Qualification Description")
                {
                    IncludeCaption = true;
                }
            }
            dataitem(resposibilities;UnknownTable61192)
            {
                DataItemLink = "Job ID"=field("Job ID");
                column(ReportForNavId_1000000011; 1000000011)
                {
                }
                column(JobID_resposibilities;resposibilities."Job ID")
                {
                }
                column(ResponsibilityDescription_resposibilities;resposibilities."Responsibility Description")
                {
                }
                column(Remarks_resposibilities;resposibilities.Remarks)
                {
                }
                column(ResponsibilityCode_resposibilities;resposibilities."Responsibility Code")
                {
                }
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

    trigger OnPreReport()
    begin
                            CI.Get();
                            CI.CalcFields(CI.Picture);
    end;

    var
        CI: Record "Company Information";
        HR_JobsCaptionLbl: label 'HR Jobs';
        Job_RequirementsCaptionLbl: label 'Job Requirements';
        P_O__BoxCaptionLbl: label 'P.O. Box';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        PageConst: label 'Page';
        NameCaptionLbl: label 'Name';
}

