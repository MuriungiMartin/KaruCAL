#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5620 "Insurance - Analysis"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Insurance - Analysis.rdlc';
    Caption = 'Insurance - Analysis';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Insurance;Insurance)
        {
            RequestFilterFields = "No.","FA Class Code","FA Subclass Code";
            column(ReportForNavId_3288; 3288)
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
            column(Insurance_TABLECAPTION___________InsuranceFilter;TableCaption + ': ' + InsuranceFilter)
            {
            }
            column(InsuranceFilter;InsuranceFilter)
            {
            }
            column(Insurance__No__;"No.")
            {
            }
            column(Insurance_Description;Description)
            {
            }
            column(Insurance__Annual_Premium_;"Annual Premium")
            {
            }
            column(Insurance__Policy_Coverage_;"Policy Coverage")
            {
            }
            column(Insurance__Total_Value_Insured_;"Total Value Insured")
            {
            }
            column(OverUnderInsured;OverUnderInsured)
            {
                AutoFormatType = 1;
            }
            column(UnderInsured;UnderInsured)
            {
            }
            column(PrintDetails;PrintDetails)
            {
            }
            column(TotalAmounts_1_;TotalAmounts[1])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts_2_;TotalAmounts[2])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts_3_;TotalAmounts[3])
            {
                AutoFormatType = 1;
            }
            column(TotalAmounts_4_;TotalAmounts[4])
            {
                AutoFormatType = 1;
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Insurance___AnalysisCaption;Insurance___AnalysisCaptionLbl)
            {
            }
            column(Insurance__No__Caption;FieldCaption("No."))
            {
            }
            column(Insurance_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Insurance__Annual_Premium_Caption;FieldCaption("Annual Premium"))
            {
            }
            column(Insurance__Policy_Coverage_Caption;FieldCaption("Policy Coverage"))
            {
            }
            column(Insurance__Total_Value_Insured_Caption;FieldCaption("Total Value Insured"))
            {
            }
            column(OverUnderInsuredCaption;OverUnderInsuredCaptionLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                OverUnderInsured := "Policy Coverage" - "Total Value Insured";
                if OverUnderInsured < 0
                then
                  UnderInsured := Text000
                else
                  UnderInsured := '';
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
                    field(PrintDetails;PrintDetails)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Print per Insurance No.';
                        ToolTip = 'Specifies if you want the report to print information separately for each insurance number.';
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
        InsuranceFilter := Insurance.GetFilters;
    end;

    var
        Text000: label 'U';
        InsuranceFilter: Text;
        OverUnderInsured: Decimal;
        TotalAmounts: array [4] of Decimal;
        PrintDetails: Boolean;
        UnderInsured: Text[5];
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Insurance___AnalysisCaptionLbl: label 'Insurance - Analysis';
        OverUnderInsuredCaptionLbl: label 'Over-/Underinsured';
        TotalCaptionLbl: label 'Total';


    procedure InitializeRequest(PrintDetailsFrom: Boolean)
    begin
        PrintDetails := PrintDetailsFrom;
    end;
}

