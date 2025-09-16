#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51443 "Shortlisting Criteria"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Shortlisting Criteria.rdlc';

    dataset
    {
        dataitem(UnknownTable61307;UnknownTable61307)
        {
            DataItemTableView = sorting("Need Code","Job ID");
            RequestFilterFields = "Need Code","Job ID";
            column(ReportForNavId_7534; 7534)
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
            column(Recruitment_Needs__Need_Code_;"Need Code")
            {
            }
            column(Recruitment_Needs__Job_ID_;"Job ID")
            {
            }
            column(Recruitment_Needs_Description;Description)
            {
            }
            column(Recruitment_Needs_Positions;Positions)
            {
            }
            column(Recruitment_NeedsCaption;Recruitment_NeedsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Recruitment_Needs__Need_Code_Caption;FieldCaption("Need Code"))
            {
            }
            column(Recruitment_Needs__Job_ID_Caption;FieldCaption("Job ID"))
            {
            }
            column(Recruitment_Needs_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Recruitment_Needs_PositionsCaption;FieldCaption(Positions))
            {
            }
            dataitem(UnknownTable61308;UnknownTable61308)
            {
                DataItemLink = "Need Code"=field("Need Code");
                column(ReportForNavId_6162; 6162)
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

    var
        Recruitment_NeedsCaptionLbl: label 'Recruitment Needs';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

