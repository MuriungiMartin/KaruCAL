#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10212 "Completed Jobs"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Completed Jobs.rdlc';
    Caption = 'Completed Jobs';

    dataset
    {
        dataitem(Job;Job)
        {
            DataItemTableView = where(Status=const(Completed));
            RequestFilterFields = "No.","Bill-to Customer No.";
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
            column(TLGrouping;TLGrouping)
            {
            }
            column(Job__No__;"No.")
            {
            }
            column(Job_Description;Description)
            {
            }
            column(ScheduledPrice;ScheduledPrice)
            {
            }
            column(InvoicedPrice;InvoicedPrice)
            {
            }
            column(UsageCost;UsageCost)
            {
            }
            column(Profit;Profit)
            {
            }
            column(Profit__;"Profit%")
            {
                DecimalPlaces = 1:1;
            }
            column(Job__Bill_to_Customer_No__;"Bill-to Customer No.")
            {
            }
            column(ContractPrice;ContractPrice)
            {
            }
            column(Job__Bill_to_Customer_No___Control1480005;"Bill-to Customer No.")
            {
            }
            column(ScheduledPrice_Control1480006;ScheduledPrice)
            {
            }
            column(ContractPrice_Control1480007;ContractPrice)
            {
            }
            column(InvoicedPrice_Control1480008;InvoicedPrice)
            {
            }
            column(UsageCost_Control1480009;UsageCost)
            {
            }
            column(Profit_Control1480010;Profit)
            {
            }
            column(Profit___Control1480011;"Profit%")
            {
                DecimalPlaces = 1:1;
            }
            column(ScheduledPrice_Control22;ScheduledPrice)
            {
            }
            column(InvoicedPrice_Control23;InvoicedPrice)
            {
            }
            column(UsageCost_Control24;UsageCost)
            {
            }
            column(Profit_Control25;Profit)
            {
            }
            column(Profit___Control26;"Profit%")
            {
                DecimalPlaces = 1:1;
            }
            column(ContractPrice_Control1480002;ContractPrice)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Completed_JobsCaption;Completed_JobsCaptionLbl)
            {
            }
            column(Job__No__Caption;FieldCaption("No."))
            {
            }
            column(Job_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(ScheduledPriceCaption;ScheduledPriceCaptionLbl)
            {
            }
            column(InvoicedPriceCaption;InvoicedPriceCaptionLbl)
            {
            }
            column(UsageCostCaption;UsageCostCaptionLbl)
            {
            }
            column(ProfitCaption;ProfitCaptionLbl)
            {
            }
            column(Profit__Caption;Profit__CaptionLbl)
            {
            }
            column(Job__Bill_to_Customer_No__Caption;FieldCaption("Bill-to Customer No."))
            {
            }
            column(ContractPriceCaption;ContractPriceCaptionLbl)
            {
            }
            column(Total_for_CustomerCaption;Total_for_CustomerCaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ScheduledPrice := 0;
                ContractPrice := 0;
                InvoicedPrice := 0;
                UsageCost := 0;
                Profit := 0;

                JobPlanningLine.Reset;
                JobPlanningLine.SetCurrentkey("Job No.","Schedule Line",Type,"No.","Planning Date");
                JobPlanningLine.SetRange("Job No.","No.");
                Copyfilter("Planning Date Filter",JobPlanningLine."Planning Date");
                JobPlanningLine.SetFilter(Type,'<>%1',JobPlanningLine.Type::Text);
                if JobPlanningLine.FindSet then
                  repeat
                    case JobPlanningLine."Line Type" of
                      JobPlanningLine."line type"::Budget:
                        ScheduledPrice := ScheduledPrice + JobPlanningLine."Total Price (LCY)";
                      JobPlanningLine."line type"::Billable:
                        ContractPrice := ContractPrice + JobPlanningLine."Total Price (LCY)";
                      JobPlanningLine."line type"::"Both Budget and Billable":
                        begin
                          ScheduledPrice := ScheduledPrice + JobPlanningLine."Total Price (LCY)";
                          ContractPrice := ContractPrice + JobPlanningLine."Total Price (LCY)";
                        end;
                    end;
                  until JobPlanningLine.Next = 0;

                JobLedgerEntry.Reset;
                JobLedgerEntry.SetCurrentkey("Job No.","Posting Date");
                JobLedgerEntry.SetRange("Job No.","No.");
                Copyfilter("Posting Date Filter",JobLedgerEntry."Posting Date");
                if JobLedgerEntry.FindSet then
                  repeat
                    case JobLedgerEntry."Entry Type" of
                      JobLedgerEntry."entry type"::Usage:
                        UsageCost := UsageCost + JobLedgerEntry."Total Cost (LCY)";
                      JobLedgerEntry."entry type"::Sale:
                        InvoicedPrice := InvoicedPrice - JobLedgerEntry."Total Price (LCY)";
                    end;
                  until JobLedgerEntry.Next = 0;

                Profit := InvoicedPrice - UsageCost;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(ScheduledPrice,ContractPrice,InvoicedPrice,UsageCost,Profit);

                if StrPos(CurrentKey,FieldCaption("Bill-to Customer No.")) = 1 then
                  TLGrouping := true
                else
                  TLGrouping := false;
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
        JobPlanningLine: Record "Job Planning Line";
        JobLedgerEntry: Record "Job Ledger Entry";
        JobFilter: Text;
        ScheduledPrice: Decimal;
        ContractPrice: Decimal;
        InvoicedPrice: Decimal;
        UsageCost: Decimal;
        Profit: Decimal;
        "Profit%": Decimal;
        TLGrouping: Boolean;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Completed_JobsCaptionLbl: label 'Completed Jobs';
        ScheduledPriceCaptionLbl: label 'Scheduled Price';
        InvoicedPriceCaptionLbl: label 'Invoiced Price';
        UsageCostCaptionLbl: label 'Usage (Cost)';
        ProfitCaptionLbl: label 'Profit';
        Profit__CaptionLbl: label 'Percent Profit';
        ContractPriceCaptionLbl: label 'Contract Price';
        Total_for_CustomerCaptionLbl: label 'Total for Customer';
        Report_TotalCaptionLbl: label 'Report Total';
}

