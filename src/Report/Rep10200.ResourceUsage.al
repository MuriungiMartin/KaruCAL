#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10200 "Resource Usage"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Resource Usage.rdlc';
    Caption = 'Resource Usage';

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
            column(Resource_Capacity;Capacity)
            {
                DecimalPlaces = 2:5;
            }
            column(Resource__Usage__Qty___;"Usage (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Capacity____Usage__Qty___;Capacity - "Usage (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Resource_Capacity_Control17;Capacity)
            {
                DecimalPlaces = 2:5;
            }
            column(Resource__Usage__Qty____Control18;"Usage (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Capacity____Usage__Qty____Control19;Capacity - "Usage (Qty.)")
            {
                DecimalPlaces = 2:5;
            }
            column(Resource_UsageCaption;Resource_UsageCaptionLbl)
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
            column(Resource_CapacityCaption;FieldCaption(Capacity))
            {
            }
            column(Resource__Usage__Qty___Caption;FieldCaption("Usage (Qty.)"))
            {
            }
            column(Capacity____Usage__Qty___Caption;Capacity____Usage__Qty___CaptionLbl)
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                SetRange("Unit of Measure Filter","Base Unit of Measure");
                CalcFields(Capacity,"Usage (Qty.)");
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
        Resource_UsageCaptionLbl: label 'Resource Usage';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Capacity____Usage__Qty___CaptionLbl: label 'Balance';
        Report_TotalCaptionLbl: label 'Report Total';
}

