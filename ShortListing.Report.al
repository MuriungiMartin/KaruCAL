#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51445 "Short Listing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Short Listing.rdlc';

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
            column(Recruitment_Needs__Job_ID_;"Job ID")
            {
            }
            column(Recruitment_Needs_Date;Date)
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
            column(Recruitment_Needs_DateCaption;FieldCaption(Date))
            {
            }
            column(Recruitment_Needs_PositionsCaption;FieldCaption(Positions))
            {
            }
            column(Stage_Shortlist__Stage_Code_Caption;"ACA-Stage Shortlist".FieldCaption("Stage Code"))
            {
            }
            column(Stage_Shortlist_ApplicantCaption;"ACA-Stage Shortlist".FieldCaption(Applicant))
            {
            }
            column(Stage_Shortlist__Stage_Score_Caption;"ACA-Stage Shortlist".FieldCaption("Stage Score"))
            {
            }
            column(Stage_Shortlist__First_Name_Caption;"ACA-Stage Shortlist".FieldCaption("First Name"))
            {
            }
            column(Stage_Shortlist__Middle_Name_Caption;"ACA-Stage Shortlist".FieldCaption("Middle Name"))
            {
            }
            column(Stage_Shortlist__Last_Name_Caption;"ACA-Stage Shortlist".FieldCaption("Last Name"))
            {
            }
            column(Stage_Shortlist__ID_No_Caption;"ACA-Stage Shortlist".FieldCaption("ID No"))
            {
            }
            column(Stage_Shortlist_EmployCaption;"ACA-Stage Shortlist".FieldCaption(Employ))
            {
            }
            dataitem(UnknownTable61315;UnknownTable61315)
            {
                DataItemLink = "Need Code"=field("Need Code");
                DataItemTableView = sorting("Need Code","Stage Code") order(ascending) where(Qualified=const(Yes));
                column(ReportForNavId_6051; 6051)
                {
                }
                column(Stage_Shortlist__Stage_Code_;"Stage Code")
                {
                }
                column(Stage_Shortlist_Applicant;Applicant)
                {
                }
                column(Stage_Shortlist__Stage_Score_;"Stage Score")
                {
                }
                column(Stage_Shortlist__First_Name_;"First Name")
                {
                }
                column(Stage_Shortlist__Middle_Name_;"Middle Name")
                {
                }
                column(Stage_Shortlist__Last_Name_;"Last Name")
                {
                }
                column(Stage_Shortlist__ID_No_;"ID No")
                {
                }
                column(Stage_Shortlist_Employ;Employ)
                {
                }
                column(Stage_Shortlist_Need_Code;"Need Code")
                {
                }
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

