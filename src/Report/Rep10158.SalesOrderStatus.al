#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10158 "Sales Order Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Order Status.rdlc';
    Caption = 'Sales Order Status';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Description","Inventory Posting Group","Location Filter";
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
            column(SalesLineFilter;SalesLineFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(Sales_Line__TABLECAPTION__________SalesLineFilter;"Sales Line".TableCaption + ': ' + SalesLineFilter)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Sales_Line___Outstanding_Amount_;"Sales Line"."Outstanding Amount")
            {
            }
            column(Item_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Item_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Item_Location_Filter;"Location Filter")
            {
            }
            column(Item_Variant_Filter;"Variant Filter")
            {
            }
            column(Sales_Order_StatusCaption;Sales_Order_StatusCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line__Shipment_Date_Caption;"Sales Line".FieldCaption("Shipment Date"))
            {
            }
            column(Sales_Line__Quantity_Shipped_Caption;"Sales Line".FieldCaption("Quantity Shipped"))
            {
            }
            column(Sales_Line__Line_Discount_Amount_Caption;"Sales Line".FieldCaption("Line Discount Amount"))
            {
            }
            column(Sales_Line__Outstanding_Amount_Caption;"Sales Line".FieldCaption("Outstanding Amount"))
            {
            }
            column(Sales_Line__Document_No__Caption;"Sales Line".FieldCaption("Document No."))
            {
            }
            column(Sales_Line__Sell_to_Customer_No__Caption;"Sales Line".FieldCaption("Sell-to Customer No."))
            {
            }
            column(Sales_Line_QuantityCaption;"Sales Line".FieldCaption(Quantity))
            {
            }
            column(Sales_Line__Outstanding_Quantity_Caption;"Sales Line".FieldCaption("Outstanding Quantity"))
            {
            }
            column(Sales_Line__Unit_Price_Caption;"Sales Line".FieldCaption("Unit Price"))
            {
            }
            column(Sales_Line__Inv__Discount_Amount_Caption;"Sales Line".FieldCaption("Inv. Discount Amount"))
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemLink = "No."=field("No."),"Shortcut Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter"),"Location Code"=field("Location Filter"),"Variant Code"=field("Variant Filter");
                DataItemTableView = sorting("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date") where("Document Type"=const(Order),Type=const(Item),"Outstanding Quantity"=filter(<>0));
                RequestFilterFields = "Shipment Date","Sell-to Customer No.";
                column(ReportForNavId_2844; 2844)
                {
                }
                column(Sales_Line__Document_No__;"Document No.")
                {
                }
                column(Sales_Line__Sell_to_Customer_No__;"Sell-to Customer No.")
                {
                }
                column(Sales_Line__Shipment_Date_;"Shipment Date")
                {
                }
                column(Sales_Line_Quantity;Quantity)
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Quantity_Shipped_;"Quantity Shipped")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Outstanding_Quantity_;"Outstanding Quantity")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Unit_Price_;"Unit Price")
                {
                }
                column(Sales_Line__Line_Discount_Amount_;"Line Discount Amount")
                {
                }
                column(Sales_Line__Inv__Discount_Amount_;"Inv. Discount Amount")
                {
                }
                column(Sales_Line__Outstanding_Amount_;"Outstanding Amount")
                {
                }
                column(Item__No___Control38;Item."No.")
                {
                }
                column(Sales_Line_Quantity_Control39;Quantity)
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Quantity_Shipped__Control40;"Quantity Shipped")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Outstanding_Quantity__Control41;"Outstanding Quantity")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Line_Discount_Amount__Control42;"Line Discount Amount")
                {
                }
                column(Sales_Line__Inv__Discount_Amount__Control43;"Inv. Discount Amount")
                {
                }
                column(Sales_Line__Outstanding_Amount__Control44;"Outstanding Amount")
                {
                }
                column(Sales_Line_Document_Type;"Document Type")
                {
                }
                column(Sales_Line_Line_No_;"Line No.")
                {
                }
                column(Sales_Line_No_;"No.")
                {
                }
                column(Sales_Line_Shortcut_Dimension_1_Code;"Shortcut Dimension 1 Code")
                {
                }
                column(Sales_Line_Shortcut_Dimension_2_Code;"Shortcut Dimension 2 Code")
                {
                }
                column(Sales_Line_Location_Code;"Location Code")
                {
                }
                column(Sales_Line_Variant_Code;"Variant Code")
                {
                }
                column(Item_TotalCaption;Item_TotalCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                var
                    CurrExchRate: Record "Currency Exchange Rate";
                begin
                    SalesHeader.Get("Document Type","Document No.");
                    if (Quantity <> "Outstanding Quantity") and (Quantity <> 0) then begin
                      "Line Discount Amount" := "Line Discount Amount" * "Outstanding Quantity" / Quantity;
                      "Inv. Discount Amount" := "Inv. Discount Amount" * "Outstanding Quantity" / Quantity;
                    end;
                    if SalesHeader."Currency Factor" <> 1 then begin
                      "Unit Price" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate,SalesHeader."Currency Code",
                            "Unit Price",SalesHeader."Currency Factor"));
                      "Outstanding Amount" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate,SalesHeader."Currency Code",
                            "Outstanding Amount",SalesHeader."Currency Factor"));
                      "Line Discount Amount" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate,SalesHeader."Currency Code",
                            "Line Discount Amount",SalesHeader."Currency Factor"));
                      "Inv. Discount Amount" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate,SalesHeader."Currency Code",
                            "Inv. Discount Amount",SalesHeader."Currency Factor"));
                    end else begin
                      "Line Discount Amount" := ROUND("Line Discount Amount");
                      "Inv. Discount Amount" := ROUND("Inv. Discount Amount");
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Quantity Shipped",Quantity,"Outstanding Quantity",
                      "Outstanding Amount","Line Discount Amount","Inv. Discount Amount");
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Sales Line"."Outstanding Amount");
            end;
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
        SalesLineFilter := "Sales Line".GetFilters;
    end;

    var
        SalesHeader: Record "Sales Header";
        CompanyInformation: Record "Company Information";
        ItemFilter: Text;
        SalesLineFilter: Text;
        Sales_Order_StatusCaptionLbl: label 'Sales Order Status';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Report_TotalCaptionLbl: label 'Report Total';
        Item_TotalCaptionLbl: label 'Item Total';
}

