#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 99909 "BOM Summary Report - Meal"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/BOM Summary Report - Meal.rdlc';

    dataset
    {
        dataitem(UnknownTable99902;UnknownTable99902)
        {
            DataItemTableView = sorting("Batch Date") order(ascending);
            PrintOnlyIfDetail = false;
            RequestFilterFields = "Batch Date","Production  Area","Parent Item","Production  Area";
            column(ReportForNavId_1000000009; 1000000009)
            {
            }
            column(BatchDate;"Meal-Proc. BOM Prod. Source"."Batch Date")
            {
            }
            column(ParentItem;"Meal-Proc. BOM Prod. Source"."Parent Item")
            {
            }
            column(ItemNo;"Meal-Proc. BOM Prod. Source"."Item No.")
            {
            }
            column(ProdArea;"Meal-Proc. BOM Prod. Source"."Production  Area")
            {
            }
            column(ITMQTY;"Meal-Proc. BOM Prod. Source"."Item Quantity")
            {
            }
            column(UoM;"Meal-Proc. BOM Prod. Source"."Unit of Measure")
            {
            }
            column(ItemDesc;"Meal-Proc. BOM Prod. Source".Description)
            {
            }
            column(ConsumptionQTY;"Meal-Proc. BOM Prod. Source"."Consumption Quantiry")
            {
            }
            column(BOMDesQty;"Meal-Proc. BOM Prod. Source"."BOM Design Quantity")
            {
            }
            column(CompName;CompanyInformation.Name)
            {
            }
            column(CompAddress;CompanyInformation.Address)
            {
            }
            column(CompPhone1;CompanyInformation."Phone No.")
            {
            }
            column(CompPhone2;CompanyInformation."Phone No. 2")
            {
            }
            column(CompEmail;CompanyInformation."E-Mail")
            {
            }
            column(CompPage;CompanyInformation."Home Page")
            {
            }
            column(CompPin;CompanyInformation."Company P.I.N")
            {
            }
            column(Pic;CompanyInformation.Picture)
            {
            }
            column(CompRegNo;CompanyInformation."Registration No.")
            {
            }
            column(ParentDesc;Item.Description)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Item.Get("Meal-Proc. BOM Prod. Source"."Parent Item") then begin
                  end;
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

    trigger OnInitReport()
    begin
        if CompanyInformation.Get() then
          CompanyInformation.CalcFields(CompanyInformation.Picture);
        Clear(Gtoto);
        Clear(seq);
    end;

    var
        CompanyInformation: Record "Company Information";
        Gtoto: Decimal;
        seq: Integer;
        Item: Record Item;
        ItemUnitofMeasure: Record "Item Unit of Measure";
        SUOMQ: Decimal;
        SelUOMQ: Decimal;
        Item_Multiplier: Decimal;
        ProductionCustProdSource: Record UnknownRecord99902;
}

