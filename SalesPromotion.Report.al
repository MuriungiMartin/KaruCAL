#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10159 "Sales Promotion"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Promotion.rdlc';
    Caption = 'Sales Promotion';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.",Description;
            column(ReportForNavId_8129; 8129)
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
            column(ItemFilter;ItemFilter)
            {
            }
            column(SalesPriceFilter;SalesPriceFilter)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(Sales_Price__TABLECAPTION__________SalesPriceFilter;"Sales Price".TableCaption + ': ' + SalesPriceFilter)
            {
            }
            column(Item_No_;"No.")
            {
            }
            column(Item_Variant_Filter;"Variant Filter")
            {
            }
            column(Sales_PromotionCaption;Sales_PromotionCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Item__No__Caption;FieldCaption("No."))
            {
            }
            column(Item_DescriptionCaption;FieldCaption(Description))
            {
            }
            column(Item__Base_Unit_of_Measure_Caption;FieldCaption("Base Unit of Measure"))
            {
            }
            column(Sales_Price__Starting_Date_Caption;"Sales Price".FieldCaption("Starting Date"))
            {
            }
            column(Item__Unit_Price_Caption;Item__Unit_Price_CaptionLbl)
            {
            }
            column(Sales_Price__Unit_Price_Caption;Sales_Price__Unit_Price_CaptionLbl)
            {
            }
            column(Sales_Price__Currency_Code_Caption;"Sales Price".FieldCaption("Currency Code"))
            {
            }
            column(Sales_Price__Sales_Code_Caption;"Sales Price".FieldCaption("Sales Code"))
            {
            }
            dataitem("Sales Price";"Sales Price")
            {
                DataItemLink = "Item No."=field("No."),"Variant Code"=field("Variant Filter");
                DataItemTableView = sorting("Item No.","Sales Type","Sales Code","Starting Date","Currency Code","Variant Code","Unit of Measure Code");
                RequestFilterFields = "Sales Type","Starting Date";
                column(ReportForNavId_7331; 7331)
                {
                }
                column(Item__No__;Item."No.")
                {
                }
                column(Item_Description;Item.Description)
                {
                }
                column(Item__Base_Unit_of_Measure_;Item."Base Unit of Measure")
                {
                }
                column(Sales_Price__Starting_Date_;"Starting Date")
                {
                }
                column(Item__Unit_Price_;Item."Unit Price")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Price__Unit_Price_;"Unit Price")
                {
                }
                column(Sales_Price__Currency_Code_;"Currency Code")
                {
                }
                column(Sales_Price__Sales_Code_;"Sales Code")
                {
                }
                column(Sales_Price_Item_No_;"Item No.")
                {
                }
                column(Sales_Price_Sales_Type;"Sales Type")
                {
                }
                column(Sales_Price_Variant_Code;"Variant Code")
                {
                }
                column(Sales_Price_Unit_of_Measure_Code;"Unit of Measure Code")
                {
                }
                column(Sales_Price_Minimum_Quantity;"Minimum Quantity")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Unit Price" = Item."Unit Price" then
                      CurrReport.Skip;
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

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
        ItemFilter := Item.GetFilters;
        SalesPriceFilter := "Sales Price".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        ItemFilter: Text;
        SalesPriceFilter: Text;
        Sales_PromotionCaptionLbl: label 'Sales Promotion';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Item__Unit_Price_CaptionLbl: label 'List Price';
        Sales_Price__Unit_Price_CaptionLbl: label 'Sale Price';
}

