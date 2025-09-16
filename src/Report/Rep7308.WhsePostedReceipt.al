#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7308 "Whse. - Posted Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Whse. - Posted Receipt.rdlc';
    Caption = 'Whse. - Posted Receipt';
    UsageCategory = History;

    dataset
    {
        dataitem("Posted Whse. Receipt Header";"Posted Whse. Receipt Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.";
            column(ReportForNavId_4701; 4701)
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
                column(Assgnd_PostedWhseRcpHeader;"Posted Whse. Receipt Header"."Assigned User ID")
                {
                    IncludeCaption = true;
                }
                column(LocCode_PostedWhseRcpHeader;"Posted Whse. Receipt Header"."Location Code")
                {
                    IncludeCaption = true;
                }
                column(No_PostedWhseRcpHeader;"Posted Whse. Receipt Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(BinMandatoryShow1;not Location."Bin Mandatory")
                {
                }
                column(BinMandatoryShow2;Location."Bin Mandatory")
                {
                }
                column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
                {
                }
                column(WarehousePostedReceiptCaption;WarehousePostedReceiptCaptionLbl)
                {
                }
                dataitem("Posted Whse. Receipt Line";"Posted Whse. Receipt Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemLinkReference = "Posted Whse. Receipt Header";
                    DataItemTableView = sorting("No.","Line No.");
                    column(ReportForNavId_7072; 7072)
                    {
                    }
                    column(ShelfNo_PostedWhseRcpLine;"Shelf No.")
                    {
                        IncludeCaption = true;
                    }
                    column(ItemNo_PostedWhseRcpLine;"Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Desc_PostedWhseRcptLine;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(UOM_PostedWhseRcpLine;"Unit of Measure Code")
                    {
                        IncludeCaption = true;
                    }
                    column(LocCode_PostedWhseRcpLine;"Location Code")
                    {
                        IncludeCaption = true;
                    }
                    column(Qty_PostedWhseRcpLine;Quantity)
                    {
                        IncludeCaption = true;
                    }
                    column(SourceNo_PostedWhseRcpLine;"Source No.")
                    {
                        IncludeCaption = true;
                    }
                    column(SourceDoc_PostedWhseRcpLine;"Source Document")
                    {
                        IncludeCaption = true;
                    }
                    column(ZoneCode_PostedWhseRcpLine;"Zone Code")
                    {
                        IncludeCaption = true;
                    }
                    column(BinCode_PostedWhseRcpLine;"Bin Code")
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
        Caption = 'Whse. - Posted Receipt';

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
        WarehousePostedReceiptCaptionLbl: label 'Warehouse - Posted Receipt';

    local procedure GetLocation(LocationCode: Code[10])
    begin
        if LocationCode = '' then
          Location.Init
        else
          if Location.Code <> LocationCode then
            Location.Get(LocationCode);
    end;
}

