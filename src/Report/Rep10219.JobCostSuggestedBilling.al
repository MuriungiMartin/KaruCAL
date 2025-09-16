#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10219 "Job Cost Suggested Billing"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Job Cost Suggested Billing.rdlc';
    Caption = 'Job Cost Suggested Billing';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = sorting("Bill-to Customer No.") where(Status=const(Open),"Bill-to Customer No."=filter(<>''));
            RequestFilterFields = "Bill-to Customer No.","Posting Date Filter","Planning Date Filter";
            column(ReportForNavId_8019; 8019)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Job_TABLECAPTION__________JobFilter;Job.TableCaption + ': ' + JobFilter)
            {
            }
            column(JobFilter;JobFilter)
            {
            }
            column(Customer_TABLECAPTION_________Customer_FIELDCAPTION__No_____________Bill_to_Customer_No__;Customer.TableCaption + ' ' + Customer.FieldCaption("No.") + ' ' + "Bill-to Customer No.")
            {
            }
            column(Customer_Name;Customer.Name)
            {
            }
            column(Job__Bill_to_Customer_No__;Job."Bill-to Customer No.")
            {
            }
            column(Job__No__;"No.")
            {
            }
            column(Job_Description;Description)
            {
            }
            column(Job__Starting_Date_;"Starting Date")
            {
            }
            column(Job__Ending_Date_;"Ending Date")
            {
            }
            column(ContractPrice;ContractPrice)
            {
            }
            column(UsagePrice;UsagePrice)
            {
            }
            column(InvoicedPrice;InvoicedPrice)
            {
            }
            column(SuggestedBilling;SuggestedBilling)
            {
            }
            column(STRSUBSTNO_Text000_Customer_TABLECAPTION_Customer_FIELDCAPTION__No_____Bill_to_Customer_No___;StrSubstNo(Text000,Customer.TableCaption,Customer.FieldCaption("No."),"Bill-to Customer No."))
            {
            }
            column(ContractPrice_Control20;ContractPrice)
            {
            }
            column(UsagePrice_Control21;UsagePrice)
            {
            }
            column(InvoicedPrice_Control29;InvoicedPrice)
            {
            }
            column(SuggestedBilling_Control31;SuggestedBilling)
            {
            }
            column(ContractPrice_Control25;ContractPrice)
            {
            }
            column(UsagePrice_Control26;UsagePrice)
            {
            }
            column(InvoicedPrice_Control30;InvoicedPrice)
            {
            }
            column(SuggestedBilling_Control14;SuggestedBilling)
            {
            }
            column(Job_Cost_Suggested_BillingCaption;Job_Cost_Suggested_BillingCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Job__No__Caption;FieldCaption("No."))
            {
            }
            column(Job_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Job__Starting_Date_Caption;FieldCaption("Starting Date"))
            {
            }
            column(Job__Ending_Date_Caption;FieldCaption("Ending Date"))
            {
            }
            column(ContractPriceCaption;ContractPriceCaptionLbl)
            {
            }
            column(UsagePriceCaption;UsagePriceCaptionLbl)
            {
            }
            column(InvoicedPriceCaption;InvoicedPriceCaptionLbl)
            {
            }
            column(SuggestedBillingCaption;SuggestedBillingCaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ContractPrice := 0;
                UsagePrice := 0;
                InvoicedPrice := 0;
                SuggestedBilling := 0;

                JobPlanningLine.Reset;
                JobPlanningLine.SetCurrentkey("Job No.","Job Task No.","Contract Line","Planning Date");
                JobPlanningLine.SetRange("Contract Line",true);
                JobPlanningLine.SetRange("Job No.","No.");
                Copyfilter("Planning Date Filter",JobPlanningLine."Planning Date");
                JobPlanningLine.CalcSums("Total Price (LCY)");
                ContractPrice := JobPlanningLine."Total Price (LCY)";

                JobLedgerEntry.Reset;
                JobLedgerEntry.SetCurrentkey("Job No.","Job Task No.","Entry Type","Posting Date");
                JobLedgerEntry.SetRange("Job No.","No.");
                Copyfilter("Posting Date Filter",JobLedgerEntry."Posting Date");
                if JobLedgerEntry.FindSet then
                  repeat
                    if JobLedgerEntry."Entry Type" = JobLedgerEntry."entry type"::Sale then
                      InvoicedPrice := InvoicedPrice - JobLedgerEntry."Total Price (LCY)"
                    else
                      UsagePrice := UsagePrice + JobLedgerEntry."Total Price (LCY)";
                  until JobLedgerEntry.Next = 0;

                if UsagePrice > InvoicedPrice then
                  SuggestedBilling := UsagePrice - InvoicedPrice;

                if not Customer.Get("Bill-to Customer No.") then
                  Customer.Init;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(ContractPrice,UsagePrice,InvoicedPrice,SuggestedBilling);
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

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        JobFilter := Job.GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        JobPlanningLine: Record "Job Planning Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        JobFilter: Text;
        SuggestedBilling: Decimal;
        Text000: label 'Total for %1 %2 %3';
        ContractPrice: Decimal;
        UsagePrice: Decimal;
        InvoicedPrice: Decimal;
        Job_Cost_Suggested_BillingCaptionLbl: label 'Job Cost Suggested Billing';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ContractPriceCaptionLbl: label 'Billable Price';
        UsagePriceCaptionLbl: label 'Usage Amount';
        InvoicedPriceCaptionLbl: label 'Invoiced Amount';
        SuggestedBillingCaptionLbl: label 'Suggested Billing';
        Report_TotalCaptionLbl: label 'Report Total';
}

