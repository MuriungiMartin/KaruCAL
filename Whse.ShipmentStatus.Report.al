#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7313 "Whse. Shipment Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Whse. Shipment Status.rdlc';
    Caption = 'Whse. Shipment Status';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Warehouse Shipment Header";"Warehouse Shipment Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Document Status","Location Code";
            column(ReportForNavId_5944; 5944)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(WhseShipmentLineCaption;"Warehouse Shipment Line".TableCaption + ':' + WhseShipmentLine)
            {
            }
            column(WhseShipmentLine;WhseShipmentLine)
            {
            }
            column(No_WhseShipmentHeader;"No.")
            {
            }
            column(WarehouseShipmentStatusCaption;WarehouseShipmentStatusCaptionLbl)
            {
            }
            column(CurrReportPAGENOCaption;CurrReportPAGENOCaptionLbl)
            {
            }
            dataitem("Warehouse Shipment Line";"Warehouse Shipment Line")
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting("No.","Line No.");
                RequestFilterFields = Status;
                column(ReportForNavId_6896; 6896)
                {
                }
                column(LocCode_WhseShipmentLine;"Location Code")
                {
                    IncludeCaption = true;
                }
                column(No_WarehouseShipmentLine;"No.")
                {
                    IncludeCaption = true;
                }
                column(DocStatus_WhseShipmentHdr;"Warehouse Shipment Header"."Document Status")
                {
                    IncludeCaption = true;
                }
                column(LocationBinMandatory;Location."Bin Mandatory")
                {
                }
                column(SourceNo_WhseShipmentLine;"Source No.")
                {
                    IncludeCaption = true;
                }
                column(SourceDoc_WhseShptLine;"Source Document")
                {
                    IncludeCaption = true;
                }
                column(BinCode_WhseShipmentLine;"Bin Code")
                {
                    IncludeCaption = true;
                }
                column(ZoneCode_WhseShipmentLine;"Zone Code")
                {
                    IncludeCaption = true;
                }
                column(ItemNo_WhseShipmentLine;"Item No.")
                {
                    IncludeCaption = true;
                }
                column(Quantity_WhseShipmentLine;Quantity)
                {
                    IncludeCaption = true;
                }
                column(UOMCode_WhseShipmentLine;"Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(QtyperUOM_WhseShptLine;"Qty. per Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(Status_WhseShipmentLine;Status)
                {
                    IncludeCaption = true;
                }
                column(QtytoShip_WhseShipmentLine;"Qty. to Ship")
                {
                    IncludeCaption = true;
                }
                column(QtyShipped_WhseShptLine;"Qty. Shipped")
                {
                    IncludeCaption = true;
                }
                column(QtyOutstdg_WhseShptLine;"Qty. Outstanding")
                {
                    IncludeCaption = true;
                }
                column(ShelfNo_WhseShipmentLine;"Shelf No.")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    GetLocation("Location Code");
                end;
            }
        }
    }

    requestpage
    {
        Caption = 'Whse. Shipment Status';

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
        WhseShipmentLine := "Warehouse Shipment Line".GetFilters;
    end;

    var
        Location: Record Location;
        WhseShipmentLine: Text;
        WarehouseShipmentStatusCaptionLbl: label 'Warehouse Shipment Status';
        CurrReportPAGENOCaptionLbl: label 'Page';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.Init
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;
}

