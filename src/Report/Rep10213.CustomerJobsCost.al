#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10213 "Customer Jobs (Cost)"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Customer Jobs (Cost).rdlc';
    Caption = 'Customer Jobs (Cost)';

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
            column(ScheduledCost;ScheduledCost)
            {
            }
            column(UsageCost;UsageCost)
            {
            }
            column(Percent_Completion_;"Percent Completion")
            {
                DecimalPlaces = 1:1;
            }
            column(Total_for_____Customer_TABLECAPTION_________Customer_FIELDCAPTION__No_____________Bill_to_Customer_No__;'Total for ' + Customer.TableCaption + ' ' + Customer.FieldCaption("No.") + ' ' + "Bill-to Customer No.")
            {
            }
            column(ScheduledCost_Control20;ScheduledCost)
            {
            }
            column(UsageCost_Control21;UsageCost)
            {
            }
            column(Percent_Completion__Control22;"Percent Completion")
            {
                DecimalPlaces = 1:1;
            }
            column(ScheduledCost_Control25;ScheduledCost)
            {
            }
            column(UsageCost_Control26;UsageCost)
            {
            }
            column(Job_Bill_to_Customer_No_;"Bill-to Customer No.")
            {
            }
            column(Customer_Jobs___CostCaption;Customer_Jobs___CostCaptionLbl)
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
            column(ScheduledCostCaption;ScheduledCostCaptionLbl)
            {
            }
            column(UsageCostCaption;UsageCostCaptionLbl)
            {
            }
            column(Percent_Completion_Caption;Percent_Completion_CaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ScheduledCost := 0;
                UsageCost := 0;

                JobPlanningLine.Reset;
                JobPlanningLine.SetCurrentkey("Job No.","Job Task No.","Schedule Line","Planning Date");
                JobPlanningLine.SetRange("Job No.","No.");
                Copyfilter("Planning Date Filter",JobPlanningLine."Planning Date");
                JobPlanningLine.SetRange("Schedule Line",true);
                JobPlanningLine.CalcSums("Total Cost (LCY)");
                ScheduledCost := JobPlanningLine."Total Cost (LCY)";

                JobLedgerEntry.Reset;
                JobLedgerEntry.SetCurrentkey("Job No.","Job Task No.","Entry Type","Posting Date");
                JobLedgerEntry.SetRange("Job No.","No.");
                Copyfilter("Posting Date Filter",JobLedgerEntry."Posting Date");
                JobLedgerEntry.SetRange("Entry Type",JobLedgerEntry."entry type"::Usage);
                JobLedgerEntry.CalcSums("Total Cost (LCY)");
                UsageCost := JobLedgerEntry."Total Cost (LCY)";
                if not Customer.Get("Bill-to Customer No.") then
                  Customer.Init;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(ScheduledCost,UsageCost);
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
        ScheduledCost: Decimal;
        UsageCost: Decimal;
        Customer_Jobs___CostCaptionLbl: label 'Customer Jobs - Cost';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        ScheduledCostCaptionLbl: label 'Budget Cost';
        UsageCostCaptionLbl: label 'Actual Cost';
        Percent_Completion_CaptionLbl: label 'Percent Completion';
        Report_TotalCaptionLbl: label 'Report Total';


    procedure "Percent Completion"(): Decimal
    begin
        if ScheduledCost = 0 then
          exit(0);

        exit(100 * UsageCost / ScheduledCost);
    end;
}

