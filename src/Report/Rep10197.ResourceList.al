#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10197 "Resource List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Resource List.rdlc';
    Caption = 'Resource List';

    dataset
    {
        dataitem(Resource;Resource)
        {
            RequestFilterFields = "No.",Type,"Resource Group No.";
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
            column(Resource_TABLECAPTION__________ResFilter;Resource.TableCaption + ': ' + ResFilter)
            {
            }
            column(ResFilter;ResFilter)
            {
            }
            column(Resource__No__;"No.")
            {
            }
            column(Resource_Name;Name)
            {
            }
            column(Resource__Resource_Group_No__;"Resource Group No.")
            {
            }
            column(Resource__Gen__Prod__Posting_Group_;"Gen. Prod. Posting Group")
            {
            }
            column(Resource__Direct_Unit_Cost_;"Direct Unit Cost")
            {
            }
            column(Resource__Unit_Cost_;"Unit Cost")
            {
            }
            column(Resource__Unit_Price_;"Unit Price")
            {
            }
            column(Resource_Type;Type)
            {
            }
            column(Resource_ListCaption;Resource_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Resource__No__Caption;FieldCaption("No."))
            {
            }
            column(Resource_NameCaption;FieldCaption(Name))
            {
            }
            column(Resource__Resource_Group_No__Caption;FieldCaption("Resource Group No."))
            {
            }
            column(Resource__Gen__Prod__Posting_Group_Caption;FieldCaption("Gen. Prod. Posting Group"))
            {
            }
            column(Resource__Direct_Unit_Cost_Caption;FieldCaption("Direct Unit Cost"))
            {
            }
            column(Resource__Unit_Cost_Caption;FieldCaption("Unit Cost"))
            {
            }
            column(Resource__Unit_Price_Caption;FieldCaption("Unit Price"))
            {
            }
            column(Resource_TypeCaption;FieldCaption(Type))
            {
            }
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
        Resource_ListCaptionLbl: label 'Resource List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
}

