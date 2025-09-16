#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51418 "ELECT Election Candidate List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ELECT Election Candidate List.rdlc';

    dataset
    {
        dataitem(UnknownTable61460;UnknownTable61460)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_5897; 5897)
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
            column(ELECT_Election_Code;Code)
            {
            }
            column(ELECT_Election_Description;Description)
            {
            }
            column(ELECT_Election_Year;Year)
            {
            }
            column(ELECT_Election__Date_From_;"Date From")
            {
            }
            column(ELECT_Election__Time_From_;"Time From")
            {
            }
            column(ELECT_Election__Date_To_;"Date To")
            {
            }
            column(ELECT_Election__Time_To_;"Time To")
            {
            }
            column(ELECT_Election__Open_Election_;"Open Election")
            {
            }
            column(Election_ListCaption;Election_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(ELECT_Election_CodeCaption;FieldCaption(Code))
            {
            }
            column(ELECT_Election_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(ELECT_Election_YearCaption;FieldCaption(Year))
            {
            }
            column(ELECT_Election__Date_From_Caption;FieldCaption("Date From"))
            {
            }
            column(ELECT_Election__Time_From_Caption;FieldCaption("Time From"))
            {
            }
            column(ELECT_Election__Date_To_Caption;FieldCaption("Date To"))
            {
            }
            column(ELECT_Election__Time_To_Caption;FieldCaption("Time To"))
            {
            }
            column(ELECT_Election__Open_Election_Caption;FieldCaption("Open Election"))
            {
            }
            dataitem(UnknownTable61462;UnknownTable61462)
            {
                DataItemLink = Election=field(Code);
                column(ReportForNavId_4306; 4306)
                {
                }
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
        Election_ListCaptionLbl: label 'Election List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

