#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 708 "Inventory Order Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory Order Details.rdlc';
    Caption = 'Inventory Order Details';
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
            column(StrSbStNoSalOdrLnSalLnFlt;StrSubstNo(Text000,SalesLineFilter))
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
            column(OutstandingAmt_SalesLine;"Sales Line"."Outstanding Amount")
            {
            }
            column(VariantFilter_Item;"Variant Filter")
            {
            }
            column(LocationFilter_Item;"Location Filter")
            {
            }
            column(GlobalDim1Filter_Item;"Global Dimension 1 Filter")
            {
            }
            column(GlobalDim2Filter_Item;"Global Dimension 2 Filter")
            {
            }
            column(BinFilter_Item;"Bin Filter")
            {
            }
            column(InvntryOrderDetailCapt;InvntryOrderDetailCaptLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(SalesHeaderBilltoNameCapt;SalesHeaderBilltoNameCaptLbl)
            {
            }
            column(SalesLineShipDateCaption;SalesLineShipDateCaptionLbl)
            {
            }
            column(BackOrderQtyCaption;BackOrderQtyCaptionLbl)
            {
            }
            column(SalesLineLineDiscCaption;SalesLineLineDiscCaptionLbl)
            {
            }
            column(SalesLineInvDiscAmtCapt;SalesLineInvDiscAmtCaptLbl)
            {
            }
            column(SalesLineOutstngAmtCapt;SalesLineOutstngAmtCaptLbl)
            {
            }
            column(TotalCaption;TotalCaptionLbl)
            {
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemLink = "No."=field("No."),"Variant Code"=field("Variant Filter"),"Location Code"=field("Location Filter"),"Shortcut Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter"),"Bin Code"=field("Bin Filter");
                DataItemTableView = sorting("Document Type",Type,"No.","Variant Code","Drop Shipment","Location Code","Shipment Date") where("Document Type"=const(Order),Type=const(Item),"Outstanding Quantity"=filter(<>0));
                RequestFilterFields = "Shipment Date";
                RequestFilterHeading = 'Sales Order Line';
                column(ReportForNavId_2844; 2844)
                {
                }
                column(SalesLineDocumentNo;"Document No.")
                {
                    IncludeCaption = true;
                }
                column(SalesHeaderBilltoName;SalesHeader."Bill-to Name")
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
                column(BackOrderQty;BackOrderQty)
                {
                    DecimalPlaces = 0:5;
                }
                column(SalesLineUnitPrice;"Unit Price")
                {
                    IncludeCaption = true;
                }
                column(SalesLineLineDiscount;"Line Discount %")
                {
                }
                column(InvDiscountAmt_SalesLine;"Inv. Discount Amount")
                {
                }
                column(OutstandingAmt1_SalesLine;"Outstanding Amount")
                {
                }
                column(SalesLineDescription;Description)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    SalesHeader.Get("Document Type","Document No.");
                    if SalesHeader."Currency Factor" <> 0 then
                      "Outstanding Amount" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate,SalesHeader."Currency Code","Outstanding Amount",
                            SalesHeader."Currency Factor"));
                    if "Shipment Date" < WorkDate then
                      BackOrderQty := "Outstanding Quantity"
                    else
                      BackOrderQty := 0;
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Outstanding Amount",BackOrderQty,"Outstanding Quantity");
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
        ItemFilter := Item.GetFilters;
        SalesLineFilter := "Sales Line".GetFilters;
    end;

    var
        Text000: label 'Sales Order Line: %1';
        CurrExchRate: Record "Currency Exchange Rate";
        SalesHeader: Record "Sales Header";
        BackOrderQty: Decimal;
        ItemFilter: Text;
        SalesLineFilter: Text;
        InvntryOrderDetailCaptLbl: label 'Inventory Order Details';
        CurrReportPageNoCaptionLbl: label 'Page';
        SalesHeaderBilltoNameCaptLbl: label 'Customer';
        SalesLineShipDateCaptionLbl: label 'Shipment Date';
        BackOrderQtyCaptionLbl: label 'Quantity on Back Order';
        SalesLineLineDiscCaptionLbl: label 'Line Discount %';
        SalesLineInvDiscAmtCaptLbl: label 'Invoice Discount Amount';
        SalesLineOutstngAmtCaptLbl: label 'Amount on Order Inclusive Tax';
        TotalCaptionLbl: label 'Total';
}

