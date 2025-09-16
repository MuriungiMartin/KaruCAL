#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7317 "Whse. - Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Whse. - Shipment.rdlc';
    Caption = 'Whse. - Shipment';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Warehouse Shipment Header";"Warehouse Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_5944; 5944)
            {
            }
            column(HeaderNo_WhseShptHeader;"No.")
            {
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(CompanyName;COMPANYNAME)
                {
                }
                column(TodayFormatted;Format(Today,0,4))
                {
                }
                column(AssUid__WhseShptHeader;"Warehouse Shipment Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(HrdLocCode_WhseShptHeader;"Warehouse Shipment Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(HeaderNo1_WhseShptHeader;"Warehouse Shipment Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(Show1;not Location."Bin Mandatory")
                {
                }
                column(Show2;Location."Bin Mandatory")
                {
                }
                column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehouseShipmentCaption;WarehouseShipmentCaptionLbl)
                {
                }
                dataitem("Warehouse Shipment Line";"Warehouse Shipment Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemLinkReference = "Warehouse Shipment Header";
                    DataItemTableView = sorting("No.","Line No.");
                    column(ReportForNavId_6896; 6896)
                    {
                    }
                    column(ShelfNo_WhseShptLine;"Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_WhseShptLine;"Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_WhseShptLine;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UomCode_WhseShptLine;"Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocCode_WhseShptLine;"Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Qty_WhseShptLine;Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_WhseShptLine;"Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDoc_WhseShptLine;"Source Document")
                    {
                        IncludeCaption = true;
                    }
                    column(ZoneCode_WhseShptLine;"Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_WhseShptLine;"Bin Code")
                    {
                        IncludeCaption = true;
                    }

                    trigger OnAfterGetRecord()
                    begin
                        GetLocation("Location Code");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                GetLocation("Location Code");
            end;
        }
    }

    requestpage
    {
        Caption = 'Whse. - Posted Shipment';

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
        Location: Record Location;
        CurrReportPageNoCaptionLbl: label 'Page';
        WarehouseShipmentCaptionLbl: label 'Warehouse Shipment';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.Init
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;
}

