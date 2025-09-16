#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10323 "Sales Tax Detail List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Tax Detail List.rdlc';
    Caption = 'Sales Tax Detail List';
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
            column(Tax_Detail__TABLECAPTION__________DetailFilters;"Tax Detail".TableCaption + ': ' + DetailFilters)
            {
            }
            column(JurisdictionFilters;JurisFilters)
            {
            }
            column(DetailFilters;DetailFilters)
            {
            }
            column(ReportToJurisdictionPlusLabel;FieldCaption("Report-to Jurisdiction") + ': ' + "Report-to Jurisdiction")
            {
            }
            column(ReportTo_Description;ReportTo.Description)
            {
            }
            column(TaxJurisdictionCodePlusLabel;TableCaption + ' ' + FieldCaption(Code) + ': ' + Code)
            {
            }
            column(Tax_Jurisdiction_Description;Description)
            {
            }
            column(Tax_Jurisdiction_Code;Code)
            {
            }
            column(Tax_Jurisdiction_Report_to_Jurisdiction;"Report-to Jurisdiction")
            {
            }
            column(Sales_Tax_Detail_ListCaption;Sales_Tax_Detail_ListCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Tax_Detail__Tax_Group_Code_Caption;"Tax Detail".FieldCaption("Tax Group Code"))
            {
            }
            column(TaxGroup_DescriptionCaption;TaxGroup_DescriptionCaptionLbl)
            {
            }
            column(Tax_Detail__Tax_Type_Caption;"Tax Detail".FieldCaption("Tax Type"))
            {
            }
            column(Tax_Detail__Effective_Date_Caption;"Tax Detail".FieldCaption("Effective Date"))
            {
            }
            column(Tax_Detail__Tax_Below_Maximum_Caption;"Tax Detail".FieldCaption("Tax Below Maximum"))
            {
            }
            column(Tax_Detail__Maximum_Amount_Qty__Caption;"Tax Detail".FieldCaption("Maximum Amount/Qty."))
            {
            }
            column(Tax_Detail__Tax_Above_Maximum_Caption;"Tax Detail".FieldCaption("Tax Above Maximum"))
            {
            }
            column(FORMAT__Calculate_Tax_on_Tax__Caption;FORMAT__Calculate_Tax_on_Tax__CaptionLbl)
            {
            }
            column(FORMAT__Expense_Capitalize__Caption;FORMAT__Expense_Capitalize__CaptionLbl)
            {
            }
            dataitem("Tax Detail";"Tax Detail")
            {
                DataItemLink = "Tax Jurisdiction Code"=field(Code);
                DataItemTableView = sorting("Tax Jurisdiction Code","Tax Group Code","Tax Type","Effective Date");
                RequestFilterFields = "Tax Group Code","Tax Type","Effective Date";
                column(ReportForNavId_4019; 4019)
                {
                }
                column(Tax_Detail__Tax_Group_Code_;"Tax Group Code")
                {
                }
                column(TaxGroup_Description;TaxGroup.Description)
                {
                }
                column(Tax_Detail__Tax_Type_;"Tax Type")
                {
                }
                column(Tax_Detail__Effective_Date_;"Effective Date")
                {
                }
                column(Tax_Detail__Tax_Below_Maximum_;"Tax Below Maximum")
                {
                }
                column(Tax_Detail__Maximum_Amount_Qty__;"Maximum Amount/Qty.")
                {
                }
                column(Tax_Detail__Tax_Above_Maximum_;"Tax Above Maximum")
                {
                }
                column(FORMAT__Calculate_Tax_on_Tax__;Format("Calculate Tax on Tax"))
                {
                }
                column(FORMAT__Expense_Capitalize__;Format("Expense/Capitalize"))
                {
                }
                column(Tax_Detail_Tax_Jurisdiction_Code;"Tax Jurisdiction Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not TaxGroup.Get("Tax Group Code") then
                      TaxGroup.Init;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if ReportTo."Report-to Jurisdiction" <> "Report-to Jurisdiction" then
                  if not ReportTo.Get("Report-to Jurisdiction") then
                    ReportTo.Init;
            end;

            trigger OnPreDataItem()
            begin
                SetCurrentkey("Report-to Jurisdiction");
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
        DetailFilters := "Tax Detail".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ReportTo: Record "Tax Jurisdiction";
        TaxGroup: Record "Tax Group";
        JurisFilters: Text;
        DetailFilters: Text;
        Sales_Tax_Detail_ListCaptionLbl: label 'Sales Tax Detail List';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        TaxGroup_DescriptionCaptionLbl: label 'Tax Group Description';
        FORMAT__Calculate_Tax_on_Tax__CaptionLbl: label 'Calculate Tax on Tax';
        FORMAT__Expense_Capitalize__CaptionLbl: label 'Expense/Capitalize';
}

