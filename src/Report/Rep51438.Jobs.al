#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51438 Jobs
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Jobs.rdlc';

    dataset
    {
        dataitem(UnknownTable61056;UnknownTable61056)
        {
            DataItemTableView = sorting("Job ID");
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
            column(Company_Jobs__No_of_Posts_;"No of Posts")
            {
            }
            column(Company_Jobs__Occupied_Position_;"Occupied Position")
            {
            }
            column(Company_Jobs__Vacant_Posistions_;"Vacant Posistions")
            {
            }
            column(Company_Jobs__Key_Position_;"Key Position")
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
            column(Company_Jobs__No_of_Posts_Caption;FieldCaption("No of Posts"))
            {
            }
            column(Company_Jobs__Occupied_Position_Caption;FieldCaption("Occupied Position"))
            {
            }
            column(Company_Jobs__Vacant_Posistions_Caption;FieldCaption("Vacant Posistions"))
            {
            }
            column(Company_Jobs__Key_Position_Caption;FieldCaption("Key Position"))
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
        Company_JobsCaptionLbl: label 'Company Jobs';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

