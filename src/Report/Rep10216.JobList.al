#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10216 "Job List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Job List.rdlc';
    Caption = 'Job List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Job;Job)
        {
            RequestFilterFields = "No.","Search Description","Bill-to Customer No.",Status,"Planning Date Filter";
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
            column(Job__No__;"No.")
            {
            }
            column(Job_Description;Description)
            {
            }
            column(Job_Status;Status)
            {
            }
            column(Job__Bill_to_Customer_No__;"Bill-to Customer No.")
            {
            }
            column(Customer_Name;Customer.Name)
            {
            }
            column(JobPlanningLine__Total_Cost__LCY__;JobPlanningLine."Total Cost (LCY)")
            {
            }
            column(JobPlanningLine__Total_Price__LCY__;JobPlanningLine."Total Price (LCY)")
            {
            }
            column(Job__Description_2_;"Description 2")
            {
            }
            column(Job_ListCaption;Job_ListCaptionLbl)
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
            column(Job_StatusCaption;FieldCaption(Status))
            {
            }
            column(Job__Bill_to_Customer_No__Caption;FieldCaption("Bill-to Customer No."))
            {
            }
            column(Customer_NameCaption;Customer_NameCaptionLbl)
            {
            }
            column(JobPlanningLine__Total_Cost__LCY__Caption;JobPlanningLine__Total_Cost__LCY__CaptionLbl)
            {
            }
            column(JobPlanningLine__Total_Price__LCY__Caption;JobPlanningLine__Total_Price__LCY__CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not Customer.Get("Bill-to Customer No.") then
                  Customer.Init;
                JobPlanningLine.SetRange("Job No.","No.");
                JobPlanningLine.CalcSums("Total Cost (LCY)","Total Price (LCY)");
            end;

            trigger OnPreDataItem()
            begin
                with JobPlanningLine do begin
                  case BudgetAmountsPer of
                    Budgetamountsper::Schedule:
                      begin
                        SetCurrentkey("Job No.","Job Task No.","Schedule Line","Planning Date");
                        SetRange("Schedule Line",true);
                      end;
                    Budgetamountsper::Contract:
                      begin
                        SetCurrentkey("Job No.","Job Task No.","Contract Line","Planning Date");
                        SetRange("Contract Line",true);
                      end;
                  end;
                  Job.Copyfilter("Planning Date Filter","Planning Date");
                end;
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
        JobFilter: Text;
        BudgetAmountsPer: Option Schedule,Contract;
        BudgetOptionText: Text[50];
        Text001: label 'Budgeted Amounts are per the Budget';
        Text002: label 'Budgeted Amounts are per the Contract';
        Job_ListCaptionLbl: label 'Job List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Customer_NameCaptionLbl: label 'Customer Name';
        JobPlanningLine__Total_Cost__LCY__CaptionLbl: label 'Budgeted Cost';
        JobPlanningLine__Total_Price__LCY__CaptionLbl: label 'Budgeted Price';
}

