#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 320 "Vendor Item Catalog"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Vendor Item Catalog.rdlc';
    Caption = 'Vendor Item Catalog';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(ReportForNavId_3182; 3182)
            {
            }
            column(Picture;CompanyInformation.Picture)
            {
            }
            column(Tel;CompanyInformation."Phone No.")
            {
            }
            column(Company_Email;CompanyInformation."E-Mail")
            {
            }
            column(Website;CompanyInformation."Home Page")
            {
            }
            column(floor;CompanyInformation."Ship-to Address 2")
            {
            }
            column(Locations;CompanyInformation.City)
            {
            }
            column(addess2;CompanyInformation."Address 2")
            {
            }
            column(Adress;CompanyInformation.Address)
            {
            }
            column(County;CompanyInformation.County)
            {
            }
            column(Name;CompanyInformation.Name)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(VendTblCapVendFltr;TableCaption + ': ' + VendFilter)
            {
            }
            column(VendFilter;VendFilter)
            {
            }
            column(No_Vendor;"No.")
            {
            }
            column(Name_Vendor;Name)
            {
            }
            column(PhoneNo_Vendor;"Phone No.")
            {
                IncludeCaption = true;
            }
            column(PricesInclVATText;PricesInclVATText)
            {
            }
            column(VendorItemCatalogCaption;VendorItemCatalogCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemDescriptionCaption;ItemDescriptionCaptionLbl)
            {
            }
            column(PurchPriceStartDateCaption;PurchPriceStartDateCaptionLbl)
            {
            }
            column(ItemVendLeadTimeCalcCaptn;ItemVendLeadTimeCalcCaptnLbl)
            {
            }
            column(ItemVendorItemNoCaption;ItemVendorItemNoCaptionLbl)
            {
            }
            dataitem("Purchase Price";"Purchase Price")
            {
                DataItemLink = "Vendor No."=field("No.");
                DataItemTableView = sorting("Vendor No.");
                column(ReportForNavId_3889; 3889)
                {
                }
                column(ItemNo_PurchPrice;"Item No.")
                {
                    IncludeCaption = true;
                }
                column(ItemDescription;Item.Description)
                {
                    IncludeCaption = false;
                }
                column(StartingDt_PurchPrice;Format("Starting Date"))
                {
                }
                column(DrctUnitCost_PurchPrice;"Direct Unit Cost")
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 2;
                    IncludeCaption = true;
                }
                column(CurrCode_PurchPrice;"Currency Code")
                {
                }
                column(ItemVendLeadTimeCal;ItemVend."Lead Time Calculation")
                {
                    IncludeCaption = false;
                }
                column(ItemVendVendorItemNo;ItemVend."Vendor Item No.")
                {
                    IncludeCaption = false;
                }

                trigger OnAfterGetRecord()
                begin
                    if "Item No." <> Item."No." then
                      Item.Get("Item No.");

                    if not ItemVend.Get("Vendor No.","Item No.","Variant Code") then
                      ItemVend.Init;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Prices Including VAT" then
                  PricesInclVATText := Text000
                else
                  PricesInclVATText := Text001;
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
          CompanyInformation.CalcFields(CompanyInformation.Picture);



        VendFilter := Vendor.GetFilters;
    end;

    var
        Text000: label 'Prices Include VAT';
        Text001: label 'Prices Exclude VAT';
        Item: Record Item;
        VendFilter: Text;
        PricesInclVATText: Text[30];
        ItemVend: Record "Item Vendor";
        VendorItemCatalogCaptionLbl: label 'Vendor Item Catalog';
        CurrReportPageNoCaptionLbl: label 'Page';
        ItemDescriptionCaptionLbl: label 'Description';
        PurchPriceStartDateCaptionLbl: label 'Starting Date';
        ItemVendLeadTimeCalcCaptnLbl: label 'Lead Time Calculation';
        ItemVendorItemNoCaptionLbl: label 'Vendor Item No.';
        CompanyInformation: Record "Company Information";
}

