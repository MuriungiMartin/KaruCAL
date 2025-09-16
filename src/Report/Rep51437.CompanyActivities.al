#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51437 "Company Activities"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Company Activities.rdlc';

    dataset
    {
        dataitem(UnknownTable61294;UnknownTable61294)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_3464; 3464)
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
            column(Company_Activities_Code;Code)
            {
            }
            column(Company_Activities_Day;Day)
            {
            }
            column(Company_Activities_Description;Description)
            {
            }
            column(Company_Activities_Venue;Venue)
            {
            }
            column(Company_Activities_Responsibility;Responsibility)
            {
            }
            column(Company_Activities_Post;Post)
            {
            }
            column(Company_Activities_Posted;Posted)
            {
            }
            column(Company_Activities_Attachement;Attachement)
            {
            }
            column(Company_ActivitiesCaption;Company_ActivitiesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Company_Activities_CodeCaption;FieldCaption(Code))
            {
            }
            column(Company_Activities_DayCaption;FieldCaption(Day))
            {
            }
            column(Company_Activities_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Company_Activities_VenueCaption;FieldCaption(Venue))
            {
            }
            column(Company_Activities_ResponsibilityCaption;FieldCaption(Responsibility))
            {
            }
            column(Company_Activities_PostCaption;FieldCaption(Post))
            {
            }
            column(Company_Activities_PostedCaption;FieldCaption(Posted))
            {
            }
            column(Company_Activities_AttachementCaption;FieldCaption(Attachement))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo(Code);
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
        Company_ActivitiesCaptionLbl: label 'Company Activities';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

