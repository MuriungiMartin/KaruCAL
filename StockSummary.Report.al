#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51724 "Stock Summary"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Stock Summary.rdlc';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.",Field50102;
            column(ReportForNavId_8129; 8129)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Item__Base_Unit_of_Measure_;"Base Unit of Measure")
            {
            }
            column(Item_Inventory;Inventory)
            {
            }
            column(Item__Unit_Cost_;"Unit Cost")
            {
            }
            column(TAmount;TAmount)
            {
            }
            column(TAmount_Control1102755010;TAmount)
            {
            }
            column(ItemCaption;ItemCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(STOCK_SUMMARY_REPORTCaption;STOCK_SUMMARY_REPORTCaptionLbl)
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
            column(Item_InventoryCaption;FieldCaption(Inventory))
            {
            }
            column(Item__Unit_Cost_Caption;FieldCaption("Unit Cost"))
            {
            }
            column(Total_ValueCaption;Total_ValueCaptionLbl)
            {
            }
            column(TOTAL_VALUECaption_Control1102755013;TOTAL_VALUECaption_Control1102755013Lbl)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TAmount:=Item.Inventory*Item."Unit Cost";
                CurrReport.CreateTotals(TAmount);
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

    var
        TAmount: Decimal;
        ItemCaptionLbl: label 'Item';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        STOCK_SUMMARY_REPORTCaptionLbl: label 'STOCK SUMMARY REPORT';
        Total_ValueCaptionLbl: label 'Total Value';
        TOTAL_VALUECaption_Control1102755013Lbl: label 'TOTAL VALUE';
}

