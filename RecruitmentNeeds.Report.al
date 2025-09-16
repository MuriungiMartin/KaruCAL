#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51442 "Recruitment Needs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Recruitment Needs.rdlc';

    dataset
    {
        dataitem(UnknownTable61307;UnknownTable61307)
        {
            DataItemTableView = sorting("Need Code","Job ID");
            RequestFilterFields = "Need Code";
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
            column(Recruitment_Needs_Date;Date)
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
            column(Recruitment_Needs_Approved;Approved)
            {
            }
            column(Recruitment_Needs__Date_Approved_;"Date Approved")
            {
            }
            column(Recruitment_Needs__Start_Date_;"Start Date")
            {
            }
            column(Recruitment_Needs__End_Date_;"End Date")
            {
            }
            column(Recruitment_Needs__Turn_Around_Time_;"Turn Around Time")
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
            column(Recruitment_Needs_DateCaption;FieldCaption(Date))
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
            column(Recruitment_Needs_ApprovedCaption;FieldCaption(Approved))
            {
            }
            column(Recruitment_Needs__Date_Approved_Caption;FieldCaption("Date Approved"))
            {
            }
            column(Recruitment_Needs__Start_Date_Caption;FieldCaption("Start Date"))
            {
            }
            column(Recruitment_Needs__End_Date_Caption;FieldCaption("End Date"))
            {
            }
            column(Recruitment_Needs__Turn_Around_Time_Caption;FieldCaption("Turn Around Time"))
            {
            }

            trigger OnPreDataItem()
            begin
                LastFieldNo := FieldNo("Need Code");
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
        Recruitment_NeedsCaptionLbl: label 'Recruitment Needs';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

