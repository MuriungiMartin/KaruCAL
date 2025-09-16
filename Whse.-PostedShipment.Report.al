#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7309 "Whse. - Posted Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Whse. - Posted Shipment.rdlc';
    Caption = 'Whse. - Posted Shipment';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Posted Whse. Shipment Header";"Posted Whse. Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_7959; 7959)
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
                column(AssgndUID_PostedWhseShptHeader;"Posted Whse. Shipment Header"."Assigned User ID")
                {
                }
                column(LocCode_PostedWhseShptHeader;"Posted Whse. Shipment Header"."Location Code")
                {
                }
                column(No_PostedWhseShptHeader;"Posted Whse. Shipment Header"."No.")
                {
                }
                column(BinMandatoryShow1;not Location."Bin Mandatory")
                {
                }
                column(BinMandatoryShow2;Location."Bin Mandatory")
                {
                }
                column(AssgndUID_PostedWhseShptHeaderCaption;"Posted Whse. Shipment Header".FieldCaption("Assigned User ID"))
                {
                }
                column(LocCode_PostedWhseShptHeaderCaption;"Posted Whse. Shipment Header".FieldCaption("Location Code"))
                {
                }
                column(No_PostedWhseShptHeaderCaption;"Posted Whse. Shipment Header".FieldCaption("No."))
                {
                }
                column(ShelfNo_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Shelf No."))
                {
                }
                column(ItemNo_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Item No."))
                {
                }
                column(Desc_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption(Description))
                {
                }
                column(UOM_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Unit of Measure Code"))
                {
                }
                column(Qty_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption(Quantity))
                {
                }
                column(SourceNo_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Source No."))
                {
                }
                column(SourceDoc_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Source Document"))
                {
                }
                column(ZoneCode_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Zone Code"))
                {
                }
                column(BinCode_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Bin Code"))
                {
                }
                column(LocCode_PostedWhseShptLineCaption;"Posted Whse. Shipment Line".FieldCaption("Location Code"))
                {
                }
                column(CurrReportPAGENOCaption;CurrReportPAGENOCaptionLbl)
                {
                }
                column(WarehousePostedShipmentCaption;WarehousePostedShipmentCaptionLbl)
                {
                }
                dataitem("Posted Whse. Shipment Line";"Posted Whse. Shipment Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemLinkReference = "Posted Whse. Shipment Header";
                    DataItemTableView = sorting("No.","Line No.");
                    column(ReportForNavId_7862; 7862)
                    {
                    }
                    column(ShelfNo_PostedWhseShptLine;"Shelf No.")
                    {
                    }
                    column(ItemNo_PostedWhseShptLine;"Item No.")
                    {
                    }
                    column(Desc_PostedWhseShptLine;Description)
                    {
                    }
                    column(UOM_PostedWhseShptLine;"Unit of Measure Code")
                    {
                    }
                    column(LocCode_PostedWhseShptLine;"Location Code")
                    {
                    }
                    column(Qty_PostedWhseShptLine;Quantity)
                    {
                    }
                    column(SourceNo_PostedWhseShptLine;"Source No.")
                    {
                    }
                    column(SourceDoc_PostedWhseShptLine;"Source Document")
                    {
                    }
                    column(ZoneCode_PostedWhseShptLine;"Zone Code")
                    {
                    }
                    column(BinCode_PostedWhseShptLine;"Bin Code")
                    {
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
        CurrReportPAGENOCaptionLbl: label 'Page';
        WarehousePostedShipmentCaptionLbl: label 'Warehouse Posted Shipment';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.Init
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;
}

