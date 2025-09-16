#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10156 "Purchase Order Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Order Status.rdlc';
    Caption = 'Purchase Order Status';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Description","Inventory Posting Group","Statistics Group";
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
            column(PurchLineFilter;PurchLineFilter)
            {
            }
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(Purchase_Line__TABLECAPTION__________PurchLineFilter;"Purchase Line".TableCaption + ': ' + PurchLineFilter)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Purchase_Line___Outstanding_Amount_;"Purchase Line"."Outstanding Amount")
            {
            }
            column(Item_Location_Filter;"Location Filter")
            {
            }
            column(Item_Variant_Filter;"Variant Filter")
            {
            }
            column(Item_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Item_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Purchase_Order_StatusCaption;Purchase_Order_StatusCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Purchase_Line__Document_No__Caption;"Purchase Line".FieldCaption("Document No."))
            {
            }
            column(Purchase_Line__Buy_from_Vendor_No__Caption;"Purchase Line".FieldCaption("Buy-from Vendor No."))
            {
            }
            column(Purchase_Line__Expected_Receipt_Date_Caption;Purchase_Line__Expected_Receipt_Date_CaptionLbl)
            {
            }
            column(Purchase_Line_QuantityCaption;"Purchase Line".FieldCaption(Quantity))
            {
            }
            column(Purchase_Line__Outstanding_Quantity_Caption;"Purchase Line".FieldCaption("Outstanding Quantity"))
            {
            }
            column(Purchase_Line__Quantity_Received_Caption;"Purchase Line".FieldCaption("Quantity Received"))
            {
            }
            column(Purchase_Line__Direct_Unit_Cost_Caption;"Purchase Line".FieldCaption("Direct Unit Cost"))
            {
            }
            column(Purchase_Line__Line_Discount_Amount_Caption;"Purchase Line".FieldCaption("Line Discount Amount"))
            {
            }
            column(Purchase_Line__Inv__Discount_Amount_Caption;Purchase_Line__Inv__Discount_Amount_CaptionLbl)
            {
            }
            column(Purchase_Line__Outstanding_Amount_Caption;"Purchase Line".FieldCaption("Outstanding Amount"))
            {
            }
            column(Report_TotalCaption;Report_TotalCaptionLbl)
            {
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemLink = "No."=field("No."),"Location Code"=field("Location Filter"),"Variant Code"=field("Variant Filter"),"Shortcut Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Expected Receipt Date") where(Type=const(Item),"Document Type"=const(Order),"Outstanding Quantity"=filter(<>0));
                RequestFilterFields = "Expected Receipt Date";
                RequestFilterHeading = 'Purchase Order Line';
                column(ReportForNavId_6547; 6547)
                {
                }
                column(Purchase_Line__Document_No__;"Document No.")
                {
                }
                column(Purchase_Line__Buy_from_Vendor_No__;"Buy-from Vendor No.")
                {
                }
                column(Purchase_Line__Expected_Receipt_Date_;"Expected Receipt Date")
                {
                }
                column(Purchase_Line_Quantity;Quantity)
                {
                    DecimalPlaces = 2:5;
                }
                column(Purchase_Line__Outstanding_Quantity_;"Outstanding Quantity")
                {
                    DecimalPlaces = 2:5;
                }
                column(Purchase_Line__Quantity_Received_;"Quantity Received")
                {
                    DecimalPlaces = 2:5;
                }
                column(Purchase_Line__Direct_Unit_Cost_;"Direct Unit Cost")
                {
                }
                column(Purchase_Line__Line_Discount_Amount_;"Line Discount Amount")
                {
                }
                column(Purchase_Line__Inv__Discount_Amount_;"Inv. Discount Amount")
                {
                }
                column(Purchase_Line__Outstanding_Amount_;"Outstanding Amount")
                {
                }
                column(Item__No___Control33;Item."No.")
                {
                }
                column(Purchase_Line__Outstanding_Quantity__Control34;"Outstanding Quantity")
                {
                    DecimalPlaces = 2:5;
                }
                column(Purchase_Line__Quantity_Received__Control35;"Quantity Received")
                {
                    DecimalPlaces = 2:5;
                }
                column(Purchase_Line__Outstanding_Amount__Control36;"Outstanding Amount")
                {
                }
                column(Purchase_Line_Quantity_Control4;Quantity)
                {
                    DecimalPlaces = 2:5;
                }
                column(Purchase_Line__Line_Discount_Amount__Control5;"Line Discount Amount")
                {
                }
                column(Purchase_Line__Inv__Discount_Amount__Control6;"Inv. Discount Amount")
                {
                }
                column(Purchase_Line_Document_Type;"Document Type")
                {
                }
                column(Purchase_Line_Line_No_;"Line No.")
                {
                }
                column(Purchase_Line_No_;"No.")
                {
                }
                column(Purchase_Line_Location_Code;"Location Code")
                {
                }
                column(Purchase_Line_Variant_Code;"Variant Code")
                {
                }
                column(Purchase_Line_Shortcut_Dimension_1_Code;"Shortcut Dimension 1 Code")
                {
                }
                column(Purchase_Line_Shortcut_Dimension_2_Code;"Shortcut Dimension 2 Code")
                {
                }
                column(Item_TotalCaption;Item_TotalCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    PurchHeader.Get("Document Type","Document No.");
                    if (Quantity <> "Outstanding Quantity") and (Quantity <> 0) then begin
                      "Line Discount Amount" := "Line Discount Amount" * "Outstanding Quantity" / Quantity;
                      "Inv. Discount Amount" := "Inv. Discount Amount" * "Outstanding Quantity" / Quantity;
                    end;
                    if PurchHeader."Currency Factor" <> 0 then begin
                      // "Direct Unit Cost" := ROUND("Direct Unit Cost" * PurchHeader."Currency Factor" / 100);
                      // "Outstanding Amount" := ROUND("Outstanding Amount" * PurchHeader."Currency Factor" / 100);
                      // "Line Discount Amount" := ROUND("Line Discount Amount" * PurchHeader."Currency Factor" / 100);
                      // "Inv. Discount Amount" := ROUND("Inv. Discount Amount" * PurchHeader."Currency Factor" / 100);
                      "Direct Unit Cost" := ROUND("Direct Unit Cost" / PurchHeader."Currency Factor");
                      "Outstanding Amount" := ROUND("Outstanding Amount" / PurchHeader."Currency Factor");
                      "Line Discount Amount" := ROUND("Line Discount Amount" / PurchHeader."Currency Factor");
                      "Inv. Discount Amount" := ROUND("Inv. Discount Amount" / PurchHeader."Currency Factor");
                    end else begin
                      "Line Discount Amount" := ROUND("Line Discount Amount");
                      "Inv. Discount Amount" := ROUND("Inv. Discount Amount");
                    end;
                    if "Expected Receipt Date" < Today then
                      BackOrderQty := "Outstanding Quantity"
                    else
                      BackOrderQty := 0;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Outstanding Amount",BackOrderQty,"Outstanding Quantity",Quantity,
                      "Quantity Received","Inv. Discount Amount","Line Discount Amount");
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Purchase Line"."Outstanding Amount");
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
        ItemFilter := Item.GetFilters;
        PurchLineFilter := "Purchase Line".GetFilters;
    end;

    var
        CompanyInformation: Record "Company Information";
        PurchHeader: Record "Purchase Header";
        ItemFilter: Text;
        PurchLineFilter: Text;
        BackOrderQty: Decimal;
        Purchase_Order_StatusCaptionLbl: label 'Purchase Order Status';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Purchase_Line__Expected_Receipt_Date_CaptionLbl: label 'Expected Date';
        Purchase_Line__Inv__Discount_Amount_CaptionLbl: label 'Inv. Discount Amount';
        Report_TotalCaptionLbl: label 'Report Total';
        Item_TotalCaptionLbl: label 'Item Total';
}

