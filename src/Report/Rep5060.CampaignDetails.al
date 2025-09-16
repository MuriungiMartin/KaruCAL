#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5060 "Campaign - Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Campaign - Details.rdlc';
    Caption = 'Campaign - Details';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Campaign;Campaign)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Salesperson Code","Starting Date","Ending Date";
            column(ReportForNavId_4372; 4372)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(CampaignFilterCaption;TableCaption + ': ' + CampaignFilter)
            {
            }
            column(CampaignFilter;CampaignFilter)
            {
            }
            column(SegmentHeaderFilterCaption;"Segment Header".TableCaption + ': ' + SegmentHeaderFilter)
            {
            }
            column(SegmentHeaderFilter;SegmentHeaderFilter)
            {
            }
            column(CampaignEntryFilterCaption;"Campaign Entry".TableCaption + ': ' + CampaignEntryFilter)
            {
            }
            column(CampaignEntryFilter;CampaignEntryFilter)
            {
            }
            column(NoofOpportunities_Campaign;"No. of Opportunities")
            {
                IncludeCaption = true;
            }
            column(DurationMin_Campaign;"Duration (Min.)")
            {
                IncludeCaption = true;
            }
            column(CostLCY_Campaign;"Cost (LCY)")
            {
                IncludeCaption = true;
            }
            column(StatusCode_Campaign;"Status Code")
            {
                IncludeCaption = true;
            }
            column(SalespersonCode_Campaign;"Salesperson Code")
            {
                IncludeCaption = true;
            }
            column(EndingDate_Campaign;Format("Ending Date"))
            {
            }
            column(StartDate_Campaign;Format("Starting Date"))
            {
            }
            column(Description_Campaign;Description)
            {
            }
            column(No_Campaign;"No.")
            {
            }
            column(CalcCurrValueLCY_Campaign;"Calcd. Current Value (LCY)")
            {
                IncludeCaption = true;
            }
            column(EstimatedValue_Campaign;"Estimated Value (LCY)")
            {
                IncludeCaption = true;
            }
            column(CampaignDetailsCaption;CampaignDetailsCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(SegmentHdrDateCaption;SegmentHdrDateCaptionLbl)
            {
            }
            column(TypeCaption;TypeCaptionLbl)
            {
            }
            column(CampaignEndingDateCaption;CampaignEndingDateCaptionLbl)
            {
            }
            column(CampaignStartDateCaption;CampaignStartDateCaptionLbl)
            {
            }
            dataitem("Segment Header";"Segment Header")
            {
                DataItemLink = "Campaign No."=field("No.");
                DataItemTableView = sorting("Campaign No.");
                column(ReportForNavId_7133; 7133)
                {
                }
                column(Date_SegmentHdr;Format(Date))
                {
                }
                column(Desc_SegmentHdr;Description)
                {
                    IncludeCaption = true;
                }
                column(NoofLines_SegmentHdr;"No. of Lines")
                {
                    IncludeCaption = true;
                }
                column(CostLCY_SegmentHdr;"Cost (LCY)")
                {
                    IncludeCaption = true;
                }
                column(DurInMin_SegmentHdr;"Duration (Min.)")
                {
                    IncludeCaption = true;
                }
                column(SalespersonCode_SegmentHdr;"Salesperson Code")
                {
                    IncludeCaption = true;
                }
                column(No_SegmentHdr;"No.")
                {
                    IncludeCaption = true;
                }
                column(CampaignNo_SegmentHdr;"Campaign No.")
                {
                }
                column(SegCaption;SegCaptionLbl)
                {
                }
            }
            dataitem("Campaign Entry";"Campaign Entry")
            {
                DataItemLink = "Campaign No."=field("No.");
                DataItemTableView = sorting("Campaign No.",Date);
                column(ReportForNavId_1760; 1760)
                {
                }
                column(EntryNo_CampaignEntry;"Entry No.")
                {
                }
                column(Canceled_CampaignEntry;Canceled)
                {
                    IncludeCaption = false;
                }
                column(Date_Campaign;Format(Date))
                {
                }
                column(Desc_Campaign;Description)
                {
                }
                column(SalespersonCode_CampaignEntry;"Salesperson Code")
                {
                    IncludeCaption = false;
                }
                column(NoofInteractions_CampaignEntry;"No. of Interactions")
                {
                }
                column(CostLCY_CampaignEntry;"Cost (LCY)")
                {
                }
                column(DurationMin_CampaignEntry;"Duration (Min.)")
                {
                }
                column(FormatCanceled;Format(Canceled))
                {
                }
                column(CampaignNo_CampaignEntry;"Campaign No.")
                {
                }
                column(EntryCaption;EntryCaptionLbl)
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
        CanceledCaption = 'Canceled';
    }

    trigger OnPreReport()
    begin
        CampaignFilter := Campaign.GetFilters;
        SegmentHeaderFilter := "Segment Header".GetFilters;
        CampaignEntryFilter := "Campaign Entry".GetFilters;
    end;

    var
        CampaignFilter: Text;
        SegmentHeaderFilter: Text;
        CampaignEntryFilter: Text;
        CampaignDetailsCaptionLbl: label 'Campaign - Details';
        PageCaptionLbl: label 'Page';
        SegmentHdrDateCaptionLbl: label 'Date';
        TypeCaptionLbl: label 'Type';
        CampaignEndingDateCaptionLbl: label 'Ending Date';
        CampaignStartDateCaptionLbl: label 'Starting Date';
        SegCaptionLbl: label 'Seg.';
        EntryCaptionLbl: label 'Entry';
}

