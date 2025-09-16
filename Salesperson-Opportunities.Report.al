#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5058 "Salesperson - Opportunities"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Salesperson - Opportunities.rdlc';
    Caption = 'Salesperson - Opportunities';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Opportunity;Opportunity)
        {
            DataItemTableView = sorting("Salesperson Code",Closed);
            RequestFilterFields = "Salesperson Code","No.","Campaign No.","Contact No.","Creation Date",Closed,"Date Closed";
            column(ReportForNavId_9773; 9773)
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
            column(Opportunity_TABLECAPTION__________OpportunityFilter;TableCaption + ': ' + OpportunityFilter)
            {
            }
            column(OpportunityFilter;OpportunityFilter)
            {
            }
            column(Opportunity__Salesperson_Name_;"Salesperson Name")
            {
            }
            column(Opportunity__Salesperson_Code_;"Salesperson Code")
            {
            }
            column(Opportunity__No__;"No.")
            {
            }
            column(Opportunity__Contact_No__;"Contact No.")
            {
            }
            column(Opportunity__Creation_Date_;Format("Creation Date"))
            {
            }
            column(Opportunity_Status;Status)
            {
            }
            column(Opportunity_Priority;Priority)
            {
            }
            column(Opportunity__Probability___;"Probability %")
            {
            }
            column(Opportunity__Chances_of_Success___;"Chances of Success %")
            {
            }
            column(Opportunity__Completed___;"Completed %")
            {
            }
            column(Opportunity__Campaign_No__;"Campaign No.")
            {
            }
            column(Opportunity__Date_Closed_;Format("Date Closed"))
            {
            }
            column(Opportunity_Description;Description)
            {
            }
            column(FooterPrinted;FooterPrinted)
            {
            }
            column(Salesperson___OpportunityCaption;Salesperson___OpportunityCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Opportunity__No__Caption;FieldCaption("No."))
            {
            }
            column(Opportunity__Contact_No__Caption;FieldCaption("Contact No."))
            {
            }
            column(Opportunity__Creation_Date_Caption;Opportunity__Creation_Date_CaptionLbl)
            {
            }
            column(Opportunity_StatusCaption;FieldCaption(Status))
            {
            }
            column(Opportunity_PriorityCaption;FieldCaption(Priority))
            {
            }
            column(Opportunity__Probability___Caption;FieldCaption("Probability %"))
            {
            }
            column(Opportunity__Chances_of_Success___Caption;FieldCaption("Chances of Success %"))
            {
            }
            column(Opportunity__Completed___Caption;FieldCaption("Completed %"))
            {
            }
            column(Opportunity__Campaign_No__Caption;FieldCaption("Campaign No."))
            {
            }
            column(Opportunity__Date_Closed_Caption;Opportunity__Date_Closed_CaptionLbl)
            {
            }
            column(Opportunity_DescriptionCaption;FieldCaption(Description))
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

    trigger OnPreReport()
    begin
        OpportunityFilter := Opportunity.GetFilters;
    end;

    var
        FooterPrinted: Boolean;
        OpportunityFilter: Text;
        Salesperson___OpportunityCaptionLbl: label 'Salesperson - Opportunity';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Opportunity__Creation_Date_CaptionLbl: label 'Creation Date';
        Opportunity__Date_Closed_CaptionLbl: label 'Date Closed';
}

