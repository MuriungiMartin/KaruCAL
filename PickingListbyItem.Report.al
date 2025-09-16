#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10152 "Picking List by Item"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Picking List by Item.rdlc';
    Caption = 'Picking List by Item';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            DataItemTableView = sorting("Shelf No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Description","Inventory Posting Group","Shelf No.","Location Filter";
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
            column(Item_TABLECAPTION__________ItemFilter;Item.TableCaption + ': ' + ItemFilter)
            {
            }
            column(Sales_Line__TABLECAPTION__________SalesLineFilter;"Sales Line".TableCaption + ': ' + SalesLineFilter)
            {
            }
            column(FIELDCAPTION__Shelf_No______________Shelf_No__;FieldCaption("Shelf No.") + ': ' + "Shelf No.")
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(SalesLineFilter;SalesLineFilter)
            {
            }
            column(ItemVariant_Code;ItemVariant.Code)
            {
            }
            column(Item__No__;"No.")
            {
            }
            column(Item_Description;Description)
            {
            }
            column(Item_Shelf_No_;"Shelf No.")
            {
            }
            column(Item_Location_Filter;"Location Filter")
            {
            }
            column(Picking_List_by_ItemCaption;Picking_List_by_ItemCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Sales_Line_QuantityCaption;"Sales Line".FieldCaption(Quantity))
            {
            }
            column(Quantity_PickedCaption;Quantity_PickedCaptionLbl)
            {
            }
            column(Customer_NameCaption;Customer_NameCaptionLbl)
            {
            }
            column(Sales_Line__Shipment_Date_Caption;"Sales Line".FieldCaption("Shipment Date"))
            {
            }
            column(Sales_Line__Quantity_Shipped_Caption;"Sales Line".FieldCaption("Quantity Shipped"))
            {
            }
            column(Sales_Line__Qty__to_Ship_Caption;"Sales Line".FieldCaption("Qty. to Ship"))
            {
            }
            column(Sales_Line__Document_No__Caption;Sales_Line__Document_No__CaptionLbl)
            {
            }
            column(Sales_Line__Sell_to_Customer_No__Caption;"Sales Line".FieldCaption("Sell-to Customer No."))
            {
            }
            column(Sales_Line__Unit_of_Measure_Caption;"Sales Line".FieldCaption("Unit of Measure"))
            {
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemLink = "No."=field("No."),"Location Code"=field("Location Filter");
                DataItemTableView = sorting("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date") where(Type=const(Item),"Document Type"=const(Order),"Qty. to Ship"=filter(<>0));
                RequestFilterFields = "Shipment Date","Sell-to Customer No.","Document No.";
                column(ReportForNavId_2844; 2844)
                {
                }
                column(STRSUBSTNO_Text000__Variant_Code__;StrSubstNo(Text000,"Variant Code"))
                {
                }
                column(ItemVariant_Description;ItemVariant.Description)
                {
                }
                column(ItemVariant_GET___No____Variant_Code__;ItemVariant.Get("No.","Variant Code"))
                {
                }
                column(Sales_Line__Document_No__;"Document No.")
                {
                }
                column(Sales_Line__Sell_to_Customer_No__;"Sell-to Customer No.")
                {
                }
                column(Customer_Name;Customer.Name)
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
                column(Sales_Line__Qty__to_Ship_;"Qty. to Ship")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Unit_of_Measure_;"Unit of Measure")
                {
                }
                column(STRSUBSTNO_Text000__Variant_Code___Control7;StrSubstNo(Text000,"Variant Code"))
                {
                }
                column(Sales_Line_Quantity_Control9;Quantity)
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Quantity_Shipped__Control10;"Quantity Shipped")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Qty__to_Ship__Control11;"Qty. to Ship")
                {
                    DecimalPlaces = 2:5;
                }
                column(ItemVariant_Code2;ItemVariant.Code)
                {
                }
                column(Item__No___Control41;Item."No.")
                {
                }
                column(Sales_Line_Quantity_Control42;Quantity)
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Quantity_Shipped__Control43;"Quantity Shipped")
                {
                    DecimalPlaces = 2:5;
                }
                column(Sales_Line__Qty__to_Ship__Control44;"Qty. to Ship")
                {
                    DecimalPlaces = 2:5;
                }
                column(TotalQuantity;TotalQuantity)
                {
                }
                column(TotalQty__to_Ship;TotalQty__to_Ship)
                {
                }
                column(TotalQuantity_Shipped;TotalQuantity_Shipped)
                {
                }
                column(Sales_Line_Document_Type;"Document Type")
                {
                }
                column(Sales_Line_Line_No_;"Line No.")
                {
                }
                column(Sales_Line_Variant_Code;"Variant Code")
                {
                }
                column(Sales_Line_No_;"No.")
                {
                }
                column(Sales_Line_Location_Code;"Location Code")
                {
                }
                column(Variant_TotalCaption;Variant_TotalCaptionLbl)
                {
                }
                column(Item_TotalCaption;Item_TotalCaptionLbl)
                {
                }
                dataitem("Tracking Specification";"Tracking Specification")
                {
                    DataItemLink = "Source ID"=field("Document No."),"Source Ref. No."=field("Line No.");
                    DataItemTableView = sorting("Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.") where("Source Type"=const(37),"Source Subtype"=const("1"));
                    column(ReportForNavId_9539; 9539)
                    {
                    }
                    column(Tracking_Specification__Serial_No__;"Serial No.")
                    {
                    }
                    column(Tracking_Specification_Entry_No_;"Entry No.")
                    {
                    }
                    column(Tracking_Specification_Source_ID;"Source ID")
                    {
                    }
                    column(Tracking_Specification_Source_Ref__No_;"Source Ref. No.")
                    {
                    }
                    column(Tracking_Specification__Serial_No__Caption;Tracking_Specification__Serial_No__CaptionLbl)
                    {
                    }
                    column(Actual_Serial_No__PickedCaption;Actual_Serial_No__PickedCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if "Serial No." = '' then
                          "Serial No." := "Lot No.";
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    Customer.Get("Sell-to Customer No.");
                    TotalQuantity := TotalQuantity + Quantity;
                    TotalQuantity_Shipped := TotalQuantity_Shipped + "Quantity Shipped";
                    TotalQty__to_Ship := TotalQty__to_Ship + "Qty. to Ship";
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(Quantity,"Quantity Shipped","Qty. to Ship");
                    TotalQuantity := 0;
                    TotalQuantity_Shipped := 0;
                    TotalQty__to_Ship := 0;
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
        SalesLineFilter := "Sales Line".GetFilters;
    end;

    var
        Customer: Record Customer;
        CompanyInformation: Record "Company Information";
        ItemVariant: Record "Item Variant";
        ItemFilter: Text;
        SalesLineFilter: Text;
        Text000: label 'Variant: %1';
        TotalQuantity: Decimal;
        TotalQuantity_Shipped: Decimal;
        TotalQty__to_Ship: Decimal;
        Picking_List_by_ItemCaptionLbl: label 'Picking List by Item';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Quantity_PickedCaptionLbl: label 'Quantity Picked';
        Customer_NameCaptionLbl: label 'Customer Name';
        Sales_Line__Document_No__CaptionLbl: label 'Order Number';
        Variant_TotalCaptionLbl: label 'Variant Total';
        Item_TotalCaptionLbl: label 'Item Total';
        Tracking_Specification__Serial_No__CaptionLbl: label 'Requested Serial No.';
        Actual_Serial_No__PickedCaptionLbl: label 'Actual Serial No. Picked';
}

