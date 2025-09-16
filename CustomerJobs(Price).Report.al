#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10214 "Customer Jobs (Price)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer Jobs (Price).rdlc';
    Caption = 'Customer Jobs (Price)';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = sorting("Bill-to Customer No.") where(Status=const(Open),"Bill-to Customer No."=filter(<>''));
            RequestFilterFields = "Bill-to Customer No.","Starting Date","Ending Date";
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
            column(BudgetOptionText;BudgetOptionText)
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
            column(BudgetedPrice;BudgetedPrice)
            {
            }
            column(UsagePrice;UsagePrice)
            {
            }
            column(Percent_Completion_;"Percent Completion")
            {
                DecimalPlaces = 1:1;
            }
            column(InvoicedPrice;InvoicedPrice)
            {
            }
            column(Percent_Invoiced_;"Percent Invoiced")
            {
                DecimalPlaces = 1:1;
            }
            column(Total_for_____Customer_TABLECAPTION_________Customer_FIELDCAPTION__No_____________Bill_to_Customer_No__;'Total for ' + Customer.TableCaption + ' ' + Customer.FieldCaption("No.") + ' ' + "Bill-to Customer No.")
            {
            }
            column(BudgetedPrice_Control20;BudgetedPrice)
            {
            }
            column(UsagePrice_Control21;UsagePrice)
            {
            }
            column(Percent_Completion__Control22;"Percent Completion")
            {
                DecimalPlaces = 1:1;
            }
            column(InvoicedPrice_Control29;InvoicedPrice)
            {
            }
            column(Percent_Invoiced__Control31;"Percent Invoiced")
            {
                DecimalPlaces = 1:1;
            }
            column(BudgetedPrice_Control25;BudgetedPrice)
            {
            }
            column(UsagePrice_Control26;UsagePrice)
            {
            }
            column(InvoicedPrice_Control30;InvoicedPrice)
            {
            }
            column(Job_Bill_to_Customer_No_;"Bill-to Customer No.")
            {
            }
            column(Customer_Jobs___PriceCaption;Customer_Jobs___PriceCaptionLbl)
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
            column(BudgetedPriceCaption;BudgetedPriceCaptionLbl)
            {
            }
            column(UsagePriceCaption;UsagePriceCaptionLbl)
            {
            }
            column(Percent_Completion_Caption;Percent_Completion_CaptionLbl)
            {
            }
            column(InvoicedPriceCaption;InvoicedPriceCaptionLbl)
            {
            }
            column(Percent_Invoiced_Caption;Percent_Invoiced_CaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                BudgetedPrice := 0;
                UsagePrice := 0;
                InvoicedPrice := 0;

                JobPlanningLine.Reset;
                if BudgetAmountsPer = Budgetamountsper::Contract then begin
                  JobPlanningLine.SetCurrentkey("Job No.","Job Task No.","Contract Line","Planning Date");
                  JobPlanningLine.SetRange("Contract Line",true);
                end else begin
                  JobPlanningLine.SetCurrentkey("Job No.","Job Task No.","Schedule Line","Planning Date");
                  JobPlanningLine.SetRange("Schedule Line",true);
                end;
                JobPlanningLine.SetRange("Job No.","No.");
                Copyfilter("Planning Date Filter",JobPlanningLine."Planning Date");
                JobPlanningLine.CalcSums("Total Price (LCY)");
                BudgetedPrice := JobPlanningLine."Total Price (LCY)";

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
                if not Customer.Get("Bill-to Customer No.") then
                  Customer.Init;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(BudgetedPrice,UsagePrice,InvoicedPrice);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(BudgetAmountsPer;BudgetAmountsPer)
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Budget Amounts Per';
                        OptionCaption = 'Budget,Billable';
                        ToolTip = 'Specifies if the budget amounts must be based on budgets or billables.';
                    }
                }
            }
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
        if BudgetAmountsPer = Budgetamountsper::Schedule then
          BudgetOptionText := Text001
        else
          BudgetOptionText := Text002;
    end;

    var
        CompanyInformation: Record "Company Information";
        Customer: Record Customer;
        JobPlanningLine: Record "Job Planning Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        JobFilter: Text;
        BudgetedPrice: Decimal;
        UsagePrice: Decimal;
        InvoicedPrice: Decimal;
        BudgetAmountsPer: Option Schedule,Contract;
        BudgetOptionText: Text[50];
        Text001: label 'Budgeted Amounts are per the Budget';
        Text002: label 'Budgeted Amounts are per the Contract';
        Customer_Jobs___PriceCaptionLbl: label 'Customer Jobs - Price';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        BudgetedPriceCaptionLbl: label 'Budgeted Price';
        UsagePriceCaptionLbl: label 'Usage Price';
        Percent_Completion_CaptionLbl: label 'Percent Completion';
        InvoicedPriceCaptionLbl: label 'Invoiced Price';
        Percent_Invoiced_CaptionLbl: label 'Percent Invoiced';
        Report_TotalCaptionLbl: label 'Report Total';


    procedure "Percent Completion"(): Decimal
    begin
        if BudgetedPrice = 0 then
          exit(0);

        exit(100 * UsagePrice / BudgetedPrice);
    end;


    procedure "Percent Invoiced"(): Decimal
    begin
        if UsagePrice = 0 then
          exit(0);

        exit(100 * InvoicedPrice / UsagePrice);
    end;
}

