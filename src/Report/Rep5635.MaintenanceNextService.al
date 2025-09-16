#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5635 "Maintenance - Next Service"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Maintenance - Next Service.rdlc';
    Caption = 'Maintenance - Next Service';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Fixed Asset";"Fixed Asset")
        {
            PrintOnlyIfDetail = false;
            RequestFilterFields = "No.","FA Class Code","FA Subclass Code";
            column(ReportForNavId_3794; 3794)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(Fixed_Asset__TABLECAPTION__________FAFilter;TableCaption + ': ' + FAFilter)
            {
            }
            column(FAFilter;FAFilter)
            {
            }
            column(Fixed_Asset__No__;"No.")
            {
            }
            column(Fixed_Asset_Description;Description)
            {
            }
            column(Fixed_Asset__Next_Service_Date_;Format("Next Service Date"))
            {
            }
            column(Maintenance___Next_ServiceCaption;Maintenance___Next_ServiceCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Fixed_Asset__No__Caption;FieldCaption("No."))
            {
            }
            column(Fixed_Asset_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Fixed_Asset__Next_Service_Date_Caption;Fixed_Asset__Next_Service_Date_CaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Budgeted Asset" or Inactive or ("Next Service Date" = 0D) then
                  CurrReport.Skip;
                if (StartingDate > 0D) or (EndingDate > 0D) then begin
                  if (StartingDate > 0D) and ("Next Service Date" < StartingDate) then
                    CurrReport.Skip;
                  if (EndingDate > 0D) and ("Next Service Date" > EndingDate) then
                    CurrReport.Skip;
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
                    field(StartingDate;StartingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Starting Date';
                        ToolTip = 'Specifies the date from which the report or batch job processes information.';
                    }
                    field(EndingDate;EndingDate)
                    {
                        ApplicationArea = FixedAssets;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
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
        if (EndingDate > 0D) and (StartingDate > EndingDate) then
          Error(Text000);

        FAGenReport.AppendFAPostingFilter("Fixed Asset",StartingDate,EndingDate);
        FAFilter := "Fixed Asset".GetFilters;
    end;

    var
        Text000: label 'The Starting Date is later than the Ending Date.';
        FAGenReport: Codeunit "FA General Report";
        StartingDate: Date;
        EndingDate: Date;
        FAFilter: Text;
        Maintenance___Next_ServiceCaptionLbl: label 'Maintenance - Next Service';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Fixed_Asset__Next_Service_Date_CaptionLbl: label 'Next Service Date';


    procedure InitializeRequest(StartingDateFrom: Date;EndingDateFrom: Date)
    begin
        StartingDate := StartingDateFrom;
        EndingDate := EndingDateFrom;
    end;
}

