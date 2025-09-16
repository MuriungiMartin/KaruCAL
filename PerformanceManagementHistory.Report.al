#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51459 "Performance Management History"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Performance Management History.rdlc';

    dataset
    {
        dataitem(UnknownTable61188;UnknownTable61188)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_3372; 3372)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(HR_Employee_C__First_Name_;"First Name")
            {
            }
            column(HR_Employee_C__No__;"No.")
            {
            }
            column(HR_Employee_C__Last_Name_;"Last Name")
            {
            }
            column(Employee_Performance_ReportCaption;Employee_Performance_ReportCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(NamesCaption;NamesCaptionLbl)
            {
            }
            column(HR_Employee_C__No__Caption;FieldCaption("No."))
            {
            }
            column(Appraisal_TypeCaption;Appraisal_TypeCaptionLbl)
            {
            }
            column(Appraisal_PeriodCaption;Appraisal_PeriodCaptionLbl)
            {
            }
            column(Results_Achieved_CommentsCaption;Results_Achieved_CommentsCaptionLbl)
            {
            }
            column(Key_ResponsibilityCaption;Key_ResponsibilityCaptionLbl)
            {
            }
            dataitem(UnknownTable61332;UnknownTable61332)
            {
                DataItemLink = "Employee No"=field("No.");
                column(ReportForNavId_7277; 7277)
                {
                }
                column(Performance_Plan__Appraisal_Type_;"Appraisal Type")
                {
                }
                column(Performance_Plan__Appraisal_Period_;"Appraisal Period")
                {
                }
                column(Performance_Plan__Key_Responsibility_;"Key Responsibility")
                {
                }
                column(Performance_Plan__Results_Achieved_Comments_;"Results Achieved Comments")
                {
                }
                column(Performance_Plan_Employee_No;"Employee No")
                {
                }
                column(Performance_Plan_No_;"No.")
                {
                }
                column(Performance_Plan_Job_ID;"Job ID")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("No.");
            end;
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
        Employee_Performance_ReportCaptionLbl: label 'Employee Performance Report';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        NamesCaptionLbl: label 'Names';
        Appraisal_TypeCaptionLbl: label 'Appraisal Type';
        Appraisal_PeriodCaptionLbl: label 'Appraisal Period';
        Results_Achieved_CommentsCaptionLbl: label 'Results Achieved Comments';
        Key_ResponsibilityCaptionLbl: label 'Key Responsibility';
}

