#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51456 "Possible Position Successors"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Possible Position Successors.rdlc';

    dataset
    {
        dataitem(UnknownTable61056;UnknownTable61056)
        {
            DataItemTableView = sorting("Job ID");
            RequestFilterFields = "Job ID";
            column(ReportForNavId_4742; 4742)
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
            column(Company_Jobs__Job_ID_;"Job ID")
            {
            }
            column(Company_Jobs__Job_Description_;"Job Description")
            {
            }
            column(Company_JobsCaption;Company_JobsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Company_Jobs__Job_ID_Caption;FieldCaption("Job ID"))
            {
            }
            column(Company_Jobs__Job_Description_Caption;FieldCaption("Job Description"))
            {
            }
            dataitem(UnknownTable61188;UnknownTable61188)
            {
                DataItemLink = "Position To Succeed"=field("Job ID");
                column(ReportForNavId_3372; 3372)
                {
                }
                column(HR_Employee_C__No__;"No.")
                {
                }
                column(HR_Employee_C__First_Name_;"First Name")
                {
                }
                column(HR_Employee_C__Middle_Name_;"Middle Name")
                {
                }
                column(HR_Employee_C__Last_Name_;"Last Name")
                {
                }
                column(HR_Employee_C_Position;Position)
                {
                }
                column(HR_Employee_C__First_Name_Caption;FieldCaption("First Name"))
                {
                }
                column(HR_Employee_C__No__Caption;FieldCaption("No."))
                {
                }
                column(HR_Employee_C__Middle_Name_Caption;FieldCaption("Middle Name"))
                {
                }
                column(HR_Employee_C__Last_Name_Caption;FieldCaption("Last Name"))
                {
                }
                column(HR_Employee_C_PositionCaption;FieldCaption(Position))
                {
                }
                column(HR_Employee_C_Position_To_Succeed;"Position To Succeed")
                {
                }
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Job ID");
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
        Company_JobsCaptionLbl: label 'Company Jobs';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

