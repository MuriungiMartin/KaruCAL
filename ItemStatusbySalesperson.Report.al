#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10052 "Item Status by Salesperson"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Status by Salesperson.rdlc';
    Caption = 'Item Status by Salesperson';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Salesperson/Purchaser";"Salesperson/Purchaser")
        {
            DataItemTableView = sorting(Code);
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code",Name;
            RequestFilterHeading = 'Salesperson';
            column(ReportForNavId_3065; 3065)
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
            column(OnlyOnePerPage;OnlyOnePerPage)
            {
            }
            column(FilterString;FilterString)
            {
            }
            column(FilterString2;FilterString2)
            {
            }
            column(Salesperson_Purchaser_Code;Code)
            {
            }
            column(Salesperson_Purchaser_Name;Name)
            {
            }
            column(Value_Entry___Sales_Amount__Actual__;"Value Entry"."Sales Amount (Actual)")
            {
            }
            column(Profit;Profit)
            {
            }
            column(Value_Entry___Discount_Amount_;"Value Entry"."Discount Amount")
            {
            }
            column(Profit__;"Profit%")
            {
                DecimalPlaces = 1:1;
            }
            column(Item_Statistics_by_SalespersonCaption;Item_Statistics_by_SalespersonCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Salesperson_Purchaser_CodeCaption;Salesperson_Purchaser_CodeCaptionLbl)
            {
            }
            column(Salesperson_Purchaser_NameCaption;Salesperson_Purchaser_NameCaptionLbl)
            {
            }
            column(Value_Entry__Item_No__Caption;Value_Entry__Item_No__CaptionLbl)
            {
            }
            column(Item_DescriptionCaption;Item_DescriptionCaptionLbl)
            {
            }
            column(Invoiced_Quantity_Caption;Invoiced_Quantity_CaptionLbl)
            {
            }
            column(Value_Entry__Sales_Amount__Actual__Caption;Value_Entry__Sales_Amount__Actual__CaptionLbl)
            {
            }
            column(Profit_Control33Caption;Profit_Control33CaptionLbl)
            {
            }
            column(Value_Entry__Discount_Amount_Caption;Value_Entry__Discount_Amount_CaptionLbl)
            {
            }
            column(Profit___Control35Caption;Profit___Control35CaptionLbl)
            {
            }
            column(Item__Base_Unit_of_Measure_Caption;Item__Base_Unit_of_Measure_CaptionLbl)
            {
            }
            column(Report_TotalsCaption;Report_TotalsCaptionLbl)
            {
            }
            dataitem("Value Entry";"Value Entry")
            {
                DataItemLink = "Salespers./Purch. Code"=field(Code);
                DataItemTableView = sorting("Item No.","Posting Date","Item Ledger Entry Type","Entry Type","Variance Type","Item Charge No.","Location Code","Variant Code") where("Source Type"=const(Customer),"Item Ledger Entry Type"=const(Sale),"Expected Cost"=const(false));
                RequestFilterFields = "Item No.","Posting Date";
                column(ReportForNavId_8894; 8894)
                {
                }
                column(Value_Entry__Item_No__;"Item No.")
                {
                }
                column(Item_Description;Item.Description)
                {
                }
                column(Invoiced_Quantity_;-"Invoiced Quantity")
                {
                }
                column(Item__Base_Unit_of_Measure_;Item."Base Unit of Measure")
                {
                }
                column(Value_Entry__Sales_Amount__Actual__;"Sales Amount (Actual)")
                {
                }
                column(Profit_Control33;Profit)
                {
                }
                column(Value_Entry__Discount_Amount_;"Discount Amount")
                {
                }
                column(Profit___Control35;"Profit%")
                {
                    DecimalPlaces = 1:1;
                }
                column(Salesperson_Purchaser__Code;"Salesperson/Purchaser".Code)
                {
                }
                column(Value_Entry__Value_Entry___Sales_Amount__Actual__;"Value Entry"."Sales Amount (Actual)")
                {
                }
                column(Profit_Control38;Profit)
                {
                }
                column(Value_Entry__Value_Entry___Discount_Amount_;"Value Entry"."Discount Amount")
                {
                }
                column(Profit___0;"Profit%" + 0)
                {
                    DecimalPlaces = 1:1;
                }
                column(Value_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Value_Entry_Salespers__Purch__Code;"Salespers./Purch. Code")
                {
                }
                column(Salesperson_TotalsCaption;Salesperson_TotalsCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not ("Invoiced Quantity" <> 0) and not Adjustment then
                      exit;
                    Profit := "Sales Amount (Actual)" + "Cost Amount (Actual)";
                    "Discount Amount" := -"Discount Amount";
                    if not Item.Get("Item No.") then begin
                      Item.Description := 'Others';
                      Item."Base Unit of Measure" := '';
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    /* Programmer's note:  This report's performance will improve if you
                      add the key below to the Value Entry table; no SumIndexFields necessary.         */
                    if not SetCurrentkey("Source Type","Salespers./Purch. Code","Item Ledger Entry Type","Item No.") then
                      SetCurrentkey("Item No.","Posting Date","Item Ledger Entry Type");
                    CurrReport.CreateTotals("Invoiced Quantity","Sales Amount (Actual)",Profit,"Discount Amount");

                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.NewPagePerRecord := OnlyOnePerPage;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Value Entry"."Sales Amount (Actual)",Profit,"Value Entry"."Discount Amount");
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(OnlyOnePerPage;OnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Account';
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

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        FilterString := "Salesperson/Purchaser".GetFilters;
        FilterString2 := "Value Entry".GetFilters;
    end;

    var
        FilterString: Text;
        FilterString2: Text;
        Profit: Decimal;
        "Profit%": Decimal;
        OnlyOnePerPage: Boolean;
        Item: Record Item;
        CompanyInformation: Record "Company Information";
        Item_Statistics_by_SalespersonCaptionLbl: label 'Item Statistics by Salesperson';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Salesperson_Purchaser_CodeCaptionLbl: label 'Salesperson';
        Salesperson_Purchaser_NameCaptionLbl: label 'Salesperson Name';
        Value_Entry__Item_No__CaptionLbl: label 'Item Number';
        Item_DescriptionCaptionLbl: label 'Item Description';
        Invoiced_Quantity_CaptionLbl: label 'Quantity';
        Value_Entry__Sales_Amount__Actual__CaptionLbl: label 'Amount';
        Profit_Control33CaptionLbl: label 'Contribution Margin';
        Value_Entry__Discount_Amount_CaptionLbl: label 'Discount';
        Profit___Control35CaptionLbl: label 'Contrib Ratio';
        Item__Base_Unit_of_Measure_CaptionLbl: label 'Unit';
        Report_TotalsCaptionLbl: label 'Report Totals';
        Salesperson_TotalsCaptionLbl: label 'Salesperson Totals';


    procedure "CalculateProfit%"()
    begin
        if "Value Entry"."Sales Amount (Actual)" <> 0 then
          "Profit%" := ROUND(100 * Profit / "Value Entry"."Sales Amount (Actual)",0.1)
        else
          "Profit%" := 0;
    end;
}

