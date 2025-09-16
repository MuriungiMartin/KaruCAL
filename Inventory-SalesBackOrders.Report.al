#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 718 "Inventory - Sales Back Orders"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory - Sales Back Orders.rdlc';
    Caption = 'Inventory - Sales Back Orders';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Description","Assembly BOM","Inventory Posting Group","Statistics Group","Bin Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ItemTableCaptItemFilter;TableCaption + ': ' + ItemFilter)
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(StrSubStNoSalesLineFltr;StrSubstNo(Text000,SalesLineFilter))
            {
            }
            column(SalesLineFilter;SalesLineFilter)
            {
            }
            column(No_Item;"No.")
            {
            }
            column(Description_Item;Description)
            {
            }
            column(VariantFilter_Item;"Variant Filter")
            {
            }
            column(LocationFilter_Item;"Location Filter")
            {
            }
            column(BinFilter_Item;"Bin Filter")
            {
            }
            column(GlobalDim1Filter_Item;"Global Dimension 1 Filter")
            {
            }
            column(GlobalDim2Filter_Item;"Global Dimension 2 Filter")
            {
            }
            column(InvSalesBackOrdersCaption;InvSalesBackOrdersCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(CustNameCaption;CustNameCaptionLbl)
            {
            }
            column(CustPhoneNoCaption;CustPhoneNoCaptionLbl)
            {
            }
            column(SalesLineShipDateCaption;SalesLineShipDateCaptionLbl)
            {
            }
            column(OtherBackOrdersCaption;OtherBackOrdersCaptionLbl)
            {
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemLink = "No."=field("No."),"Variant Code"=field("Variant Filter"),"Location Code"=field("Location Filter"),"Bin Code"=field("Bin Filter"),"Shortcut Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter"),"Bin Code"=field("Bin Filter");
                DataItemTableView = sorting("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date") where(Type=const(Item),"Document Type"=const(Order),"Outstanding Quantity"=filter(<>0));
                RequestFilterFields = "Shipment Date";
                RequestFilterHeading = 'Sales Order Line';
                column(ReportForNavId_2844; 2844)
                {
                }
                column(DocumentNo_SalesLine;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(CustName;Cust.Name)
                {
                }
                column(CustPhoneNo;Cust."Phone No.")
                {
                }
                column(ShipmentDate_SalesLine;Format("Shipment Date"))
                {
                }
                column(Quantity_SalesLine;Quantity)
                {
                    IncludeCaption = true;
                }
                column(OutstandingQty_SalesLine;"Outstanding Quantity")
                {
                    IncludeCaption = true;
                }
                column(OtherBackOrders;OtherBackOrders)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Shipment Date" >= WorkDate then
                      CurrReport.Skip;
                    Cust.Get("Bill-to Customer No.");

                    SalesOrderLine.SetRange("Bill-to Customer No.",Cust."No.");
                    SalesOrderLine.SetFilter("No.",'<>' + Item."No.");
                    OtherBackOrders := SalesOrderLine.FindFirst;
                end;

                trigger OnPreDataItem()
                begin
                    SalesOrderLine.SetCurrentkey("Document Type","Bill-to Customer No.");
                    SalesOrderLine.SetRange("Document Type",SalesOrderLine."document type"::Order);
                    SalesOrderLine.SetRange(Type,SalesOrderLine.Type::Item);
                    SalesOrderLine.SetRange("Shipment Date",0D,WorkDate - 1);
                    SalesOrderLine.SetFilter("Outstanding Quantity",'<>0');

                    CurrReport.CreateTotals("Outstanding Quantity");
                end;
            }
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
        ItemNoCaptionLbl = 'Item No.';
    }

    trigger OnPreReport()
    begin
        ItemFilter := Item.GetFilters;
        SalesLineFilter := "Sales Line".GetFilters;
    end;

    var
        Text000: label 'Sales Order Line: %1';
        Cust: Record Customer;
        SalesOrderLine: Record "Sales Line";
        OtherBackOrders: Boolean;
        ItemFilter: Text;
        SalesLineFilter: Text;
        InvSalesBackOrdersCaptionLbl: label 'Inventory - Sales Back Orders';
        CurrReportPageNoCaptionLbl: label 'Page';
        CustNameCaptionLbl: label 'Customer';
        CustPhoneNoCaptionLbl: label 'Phone No.';
        SalesLineShipDateCaptionLbl: label 'Shipment Date';
        OtherBackOrdersCaptionLbl: label 'Other Back Orders';
}

