#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10325 "Sales Tax Jurisdiction List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Tax Jurisdiction List.rdlc';
    Caption = 'Sales Tax Jurisdiction List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Tax Jurisdiction";"Tax Jurisdiction")
        {
            RequestFilterFields = "Code","Report-to Jurisdiction","Tax Account (Sales)","Tax Account (Purchases)";
            column(ReportForNavId_7666; 7666)
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
            column(Tax_Jurisdiction__TABLECAPTION__________JurisFilters;"Tax Jurisdiction".TableCaption + ': ' + JurisFilters)
            {
            }
            column(JurisFilters;JurisFilters)
            {
            }
            column(GroupData;GroupData)
            {
            }
            column(FIELDCAPTION__Report_to_Jurisdiction_____________Report_to_Jurisdiction_;FieldCaption("Report-to Jurisdiction") + ': ' + "Report-to Jurisdiction")
            {
            }
            column(ReportTo_Description;ReportTo.Description)
            {
            }
            column(Tax_Jurisdiction_Code;Code)
            {
            }
            column(Tax_Jurisdiction_Description;Description)
            {
            }
            column(Tax_Jurisdiction__Report_to_Jurisdiction_;"Report-to Jurisdiction")
            {
            }
            column(Tax_Jurisdiction__Tax_Account__Sales__;"Tax Account (Sales)")
            {
            }
            column(Tax_Jurisdiction__Tax_Account__Purchases__;"Tax Account (Purchases)")
            {
            }
            column(Tax_Jurisdiction__Code;"Tax Jurisdiction".Code)
            {
            }
            column(Sales_Tax_Jurisdiction_ListCaption;Sales_Tax_Jurisdiction_ListCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(Tax_Jurisdiction_CodeCaption;FieldCaption(Code))
            {
            }
            column(Tax_Jurisdiction_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Tax_Jurisdiction__Report_to_Jurisdiction_Caption;FieldCaption("Report-to Jurisdiction"))
            {
            }
            column(Tax_Jurisdiction__Tax_Account__Sales__Caption;FieldCaption("Tax Account (Sales)"))
            {
            }
            column(Tax_Jurisdiction__Tax_Account__Purchases__Caption;FieldCaption("Tax Account (Purchases)"))
            {
            }

            trigger OnAfterGetRecord()
            begin
                if "Report-to Jurisdiction" <> ReportTo.Code then
                  if not ReportTo.Get("Report-to Jurisdiction") then
                    ReportTo.Init;
            end;

            trigger OnPreDataItem()
            begin
                if StrPos(CurrentKey,FieldCaption("Report-to Jurisdiction")) = 1 then
                  GroupData := true
                else
                  GroupData := false;
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
        JurisFilters := "Tax Jurisdiction".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ReportTo: Record "Tax Jurisdiction";
        JurisFilters: Text;
        GroupData: Boolean;
        Sales_Tax_Jurisdiction_ListCaptionLbl: label 'Sales Tax Jurisdiction List';
        PageCaptionLbl: label 'Page';
}

