#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5061 "Opportunity - List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Opportunity - List.rdlc';
    Caption = 'Opportunity - List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Opportunity;Opportunity)
        {
            RequestFilterFields = "No.","Salesperson Code","Campaign No.","Contact No.","Sales Cycle Code","Creation Date",Closed;
            column(ReportForNavId_9773; 9773)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
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
            column(Opportunity__No__;"No.")
            {
            }
            column(Opportunity_Description;Description)
            {
            }
            column(Opportunity__Sales_Cycle_Code_;"Sales Cycle Code")
            {
            }
            column(Opportunity__Current_Sales_Cycle_Stage_;"Current Sales Cycle Stage")
            {
            }
            column(Opportunity__Salesperson_Code_;"Salesperson Code")
            {
            }
            column(Opportunity__Campaign_No__;"Campaign No.")
            {
            }
            column(Opportunity__Contact_No__;"Contact No.")
            {
            }
            column(Opportunity__Probability___;"Probability %")
            {
            }
            column(Opportunity__Completed___;"Completed %")
            {
            }
            column(Opportunity_Status;Status)
            {
            }
            column(Opportunity___ListCaption;Opportunity___ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Opportunity__No__Caption;FieldCaption("No."))
            {
            }
            column(Opportunity_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Opportunity__Sales_Cycle_Code_Caption;FieldCaption("Sales Cycle Code"))
            {
            }
            column(Opportunity__Current_Sales_Cycle_Stage_Caption;FieldCaption("Current Sales Cycle Stage"))
            {
            }
            column(Opportunity__Salesperson_Code_Caption;FieldCaption("Salesperson Code"))
            {
            }
            column(Opportunity__Campaign_No__Caption;FieldCaption("Campaign No."))
            {
            }
            column(Opportunity__Contact_No__Caption;FieldCaption("Contact No."))
            {
            }
            column(Opportunity__Probability___Caption;FieldCaption("Probability %"))
            {
            }
            column(Opportunity__Completed___Caption;FieldCaption("Completed %"))
            {
            }
            column(Opportunity_StatusCaption;FieldCaption(Status))
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
        OpportunityFilter: Text;
        Opportunity___ListCaptionLbl: label 'Opportunity - List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

