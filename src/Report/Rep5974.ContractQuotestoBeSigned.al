#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5974 "Contract Quotes to Be Signed"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Contract Quotes to Be Signed.rdlc';
    Caption = 'Contract Quotes to Be Signed';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Service Contract Header";"Service Contract Header")
        {
            DataItemTableView = sorting("Responsibility Center","Service Zone Code",Status,"Contract Group Code") where("Contract Type"=const(Quote));
            RequestFilterFields = "Responsibility Center","Contract No.","Salesperson Code";
            column(ReportForNavId_9952; 9952)
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
            column(Service_Contract_Header__TABLECAPTION__________ServContractFilter;TableCaption + ': ' + ServContractFilter)
            {
            }
            column(ServContractFilter;ServContractFilter)
            {
            }
            column(ForecastIncluded;ForecastIncluded)
            {
            }
            column(Service_Contract_Header__Responsibility_Center_;"Responsibility Center")
            {
            }
            column(Service_Contract_Header_Name;Name)
            {
            }
            column(Service_Contract_Header_Address;Address)
            {
            }
            column(Service_Contract_Header__Starting_Date_;Format("Starting Date"))
            {
            }
            column(Service_Contract_Header_Probability;Probability)
            {
            }
            column(Service_Contract_Header__Contract_No__;"Contract No.")
            {
            }
            column(ForecastAmount;ForecastAmount)
            {
                AutoFormatType = 1;
            }
            column(Service_Contract_Header__Salesperson_Code_;"Salesperson Code")
            {
            }
            column(Service_Contract_Header__Annual_Amount_;"Annual Amount")
            {
            }
            column(Service_Contract_Header_Name_Control3;Name)
            {
            }
            column(Service_Contract_Header_Address_Control10;Address)
            {
            }
            column(Service_Contract_Header__Starting_Date__Control14;Format("Starting Date"))
            {
            }
            column(Service_Contract_Header_Probability_Control18;Probability)
            {
            }
            column(Service_Contract_Header__Contract_No___Control20;"Contract No.")
            {
            }
            column(Service_Contract_Header__Salesperson_Code__Control39;"Salesperson Code")
            {
            }
            column(Service_Contract_Header__Annual_Amount__Control23;"Annual Amount")
            {
            }
            column(ForecastAmount_Control34;ForecastAmount)
            {
                AutoFormatType = 1;
            }
            column(Service_Contract_Header__Annual_Amount__Control36;"Annual Amount")
            {
            }
            column(Service_Contract_Header__Annual_Amount__Control43;"Annual Amount")
            {
            }
            column(ForecastAmount_Control24;ForecastAmount)
            {
                AutoFormatType = 1;
            }
            column(Service_Contract_Header__Annual_Amount__Control45;"Annual Amount")
            {
            }
            column(Service_Contract_Header__Annual_Amount__Control49;"Annual Amount")
            {
            }
            column(Contract_Quotes_to_Be_SignedCaption;Contract_Quotes_to_Be_SignedCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Service_Contract_Header_Name_Control3Caption;FieldCaption(Name))
            {
            }
            column(Service_Contract_Header_Address_Control10Caption;FieldCaption(Address))
            {
            }
            column(Service_Contract_Header__Starting_Date__Control14Caption;Service_Contract_Header__Starting_Date__Control14CaptionLbl)
            {
            }
            column(Service_Contract_Header_Probability_Control18Caption;FieldCaption(Probability))
            {
            }
            column(Service_Contract_Header__Contract_No___Control20Caption;FieldCaption("Contract No."))
            {
            }
            column(ForecastCaption;ForecastCaptionLbl)
            {
            }
            column(Quoted_AmountCaption;Quoted_AmountCaptionLbl)
            {
            }
            column(Service_Contract_Header__Salesperson_Code__Control39Caption;FieldCaption("Salesperson Code"))
            {
            }
            column(ProbabilityCaption;ProbabilityCaptionLbl)
            {
            }
            column(Quoted_AmountCaption_Control28;Quoted_AmountCaption_Control28Lbl)
            {
            }
            column(Start_DateCaption;Start_DateCaptionLbl)
            {
            }
            column(AddressCaption;AddressCaptionLbl)
            {
            }
            column(NameCaption;NameCaptionLbl)
            {
            }
            column(Contract_No_Caption;Contract_No_CaptionLbl)
            {
            }
            column(Salesperson_CodeCaption;Salesperson_CodeCaptionLbl)
            {
            }
            column(Service_Contract_Header__Responsibility_Center_Caption;FieldCaption("Responsibility Center"))
            {
            }
            column(Total_for_Responsibility_Center_Caption;Total_for_Responsibility_Center_CaptionLbl)
            {
            }
            column(Total_for_Responsibility_Center_Caption_Control35;Total_for_Responsibility_Center_Caption_Control35Lbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            column(TotalCaption_Control26;TotalCaption_Control26Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Probability > 0 then
                  ForecastAmount := ROUND(("Annual Amount" * Probability) / 100)
                else
                  ForecastAmount := "Annual Amount";
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(ForecastAmount);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ForecastIncluded;ForecastIncluded)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Forecast Included';
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

    trigger OnInitReport()
    begin
        ForecastIncluded := true;
    end;

    trigger OnPreReport()
    begin
        ServContractFilter := "Service Contract Header".GetFilters;
    end;

    var
        ServContractFilter: Text;
        ForecastAmount: Decimal;
        ForecastIncluded: Boolean;
        Contract_Quotes_to_Be_SignedCaptionLbl: label 'Contract Quotes to Be Signed';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Service_Contract_Header__Starting_Date__Control14CaptionLbl: label 'Starting Date';
        ForecastCaptionLbl: label 'Forecast';
        Quoted_AmountCaptionLbl: label 'Quoted Amount';
        ProbabilityCaptionLbl: label 'Probability';
        Quoted_AmountCaption_Control28Lbl: label 'Quoted Amount';
        Start_DateCaptionLbl: label 'Start Date';
        AddressCaptionLbl: label 'Address';
        NameCaptionLbl: label 'Name';
        Contract_No_CaptionLbl: label 'Contract No.';
        Salesperson_CodeCaptionLbl: label 'Salesperson Code';
        Total_for_Responsibility_Center_CaptionLbl: label 'Total for Responsibility Center:';
        Total_for_Responsibility_Center_Caption_Control35Lbl: label 'Total for Responsibility Center:';
        TotalCaptionLbl: label 'Total';
        TotalCaption_Control26Lbl: label 'Total';


    procedure InitializeRequest(ForecastIncludedFrom: Boolean)
    begin
        ForecastIncluded := ForecastIncludedFrom;
    end;
}

