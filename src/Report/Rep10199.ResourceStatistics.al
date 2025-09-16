#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10199 "Resource Statistics"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Resource Statistics.rdlc';
    Caption = 'Resource Statistics';

    dataset
    {
        dataitem(Resource;Resource)
        {
            RequestFilterFields = "No.",Type,"Base Unit of Measure","Date Filter";
            column(ReportForNavId_5508; 5508)
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
            column(ResFilter;ResFilter)
            {
            }
            column(Resource_TABLECAPTION__________ResFilter;Resource.TableCaption + ': ' + ResFilter)
            {
            }
            column(Resource__No__;"No.")
            {
            }
            column(Resource_Type;Type)
            {
            }
            column(Resource_Name;Name)
            {
            }
            column(Resource__Base_Unit_of_Measure_;"Base Unit of Measure")
            {
            }
            column(Resource__Usage__Qty___;"Usage (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Resource__Sales__Qty___;"Sales (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Percent_Invoiced_;"Percent Invoiced")
            {
                DecimalPlaces = 1:1;
            }
            column(Resource__Usage__Qty____Control17;"Usage (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Resource__Sales__Qty____Control18;"Sales (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Percent_Invoiced__Control19;"Percent Invoiced")
            {
                DecimalPlaces = 1:1;
            }
            column(Resource_StatisticsCaption;Resource_StatisticsCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Resource__No__Caption;FieldCaption("No."))
            {
            }
            column(Resource_TypeCaption;FieldCaption(Type))
            {
            }
            column(Resource_NameCaption;FieldCaption(Name))
            {
            }
            column(Resource__Base_Unit_of_Measure_Caption;FieldCaption("Base Unit of Measure"))
            {
            }
            column(Resource__Usage__Qty___Caption;FieldCaption("Usage (Qty.)"))
            {
            }
            column(Resource__Sales__Qty___Caption;FieldCaption("Sales (Qty.)"))
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
                SetRange("Unit of Measure Filter","Base Unit of Measure");
                CalcFields("Sales (Qty.)","Usage (Qty.)");
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
        ResFilter := Resource.GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ResFilter: Text;
        Resource_StatisticsCaptionLbl: label 'Resource Statistics';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Percent_Invoiced_CaptionLbl: label 'Percent Invoiced';
        Report_TotalCaptionLbl: label 'Report Total';


    procedure "Percent Invoiced"(): Decimal
    begin
        if Resource."Usage (Qty.)" = 0 then
          exit(0);

        exit(100 * Resource."Sales (Qty.)" / Resource."Usage (Qty.)");
    end;
}

