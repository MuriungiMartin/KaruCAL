#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 7307 "Whse. Phys. Inventory List"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Whse. Phys. Inventory List.rdlc';
    Caption = 'Whse. Phys. Inventory List';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(PageLoop;"Integer")
        {
            DataItemTableView = sorting(Number) where(Number=const(1));
            column(ReportForNavId_6455; 6455)
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(CaptionWhseJnlBatFilter;"Warehouse Journal Batch".TableCaption + ': ' + WhseJnlBatchFilter)
            {
            }
            column(WhseJnlBatchFilter;WhseJnlBatchFilter)
            {
            }
            column(CaptionWhseJnlLineFilter;"Warehouse Journal Line".TableCaption + ': ' + WhseJnlLineFilter)
            {
            }
            column(WhseJnlLineFilter;WhseJnlLineFilter)
            {
            }
            column(WhsePhysInvListCaption;WhsePhysInvListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(WarehuseJnlLinRegDtCapt;WarehuseJnlLinRegDtCaptLbl)
            {
            }
            column(QtyPhysInventoryCaption;QtyPhysInventoryCaptionLbl)
            {
            }
            column(WhseDocNo_WhseJnlLineCaption;"Warehouse Journal Line".FieldCaption("Whse. Document No."))
            {
            }
            column(ItemNo_WarehouseJournlLinCaption;"Warehouse Journal Line".FieldCaption("Item No."))
            {
            }
            column(Desc_WarehouseJnlLineCaption;"Warehouse Journal Line".FieldCaption(Description))
            {
            }
            column(LocCode_WarehouseJnlLineCaption;"Warehouse Journal Line".FieldCaption("Location Code"))
            {
            }
            column(QtyCalculated_WhseJnlLineCaption;"Warehouse Journal Line".FieldCaption("Qty. (Calculated)"))
            {
            }
            column(ZoneCode_WarehouseJnlLineCaption;"Warehouse Journal Line".FieldCaption("Zone Code"))
            {
            }
            column(BinCode_WarehouseJnlLineCaption;"Warehouse Journal Line".FieldCaption("Bin Code"))
            {
            }
            dataitem("Warehouse Journal Batch";"Warehouse Journal Batch")
            {
                PrintOnlyIfDetail = true;
                RequestFilterFields = "Journal Template Name",Name,"Location Code";
                column(ReportForNavId_9945; 9945)
                {
                }
                dataitem("Warehouse Journal Line";"Warehouse Journal Line")
                {
                    DataItemLink = "Journal Template Name"=field("Journal Template Name"),"Journal Batch Name"=field(Name),"Location Code"=field("Location Code");
                    RequestFilterFields = "Zone Code","Bin Code";
                    column(ReportForNavId_9893; 9893)
                    {
                    }
                    column(RegDt_WarehouseJnlLine;Format("Registering Date"))
                    {
                    }
                    column(WhseDocNo_WhseJnlLine;"Whse. Document No.")
                    {
                    }
                    column(ItemNo_WarehouseJournlLin;"Item No.")
                    {
                    }
                    column(Desc_WarehouseJnlLine;Description)
                    {
                    }
                    column(LocCode_WarehouseJnlLine;"Location Code")
                    {
                    }
                    column(EmptyString;'')
                    {
                    }
                    column(QtyCalculated_WhseJnlLine;"Qty. (Calculated)")
                    {
                    }
                    column(ZoneCode_WarehouseJnlLine;"Zone Code")
                    {
                    }
                    column(BinCode_WarehouseJnlLine;"Bin Code")
                    {
                    }
                    column(LotNo_WarehuseJournalLine;"Lot No.")
                    {
                    }
                    column(SerialNo_WarehouseJnlLine;"Serial No.")
                    {
                    }
                    column(ShowLotSN;ShowLotSN)
                    {
                    }
                    column(ShowQtyCalculated;ShowQtyCalculated)
                    {
                    }
                    column(LotNo_WarehuseJournalLineCaption;FieldCaption("Lot No."))
                    {
                    }
                    column(SerialNo_WarehouseJnlLineCaption;FieldCaption("Serial No."))
                    {
                    }
                }
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(ShowCalculatedQty;ShowQtyCalculated)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Qty. (Calculated)';
                    }
                    field(ShowSerialLotNumber;ShowLotSN)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Serial/Lot Number';
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
        WhseJnlLineFilter := "Warehouse Journal Line".GetFilters;
        WhseJnlBatchFilter := "Warehouse Journal Batch".GetFilters;
    end;

    var
        WhseJnlLineFilter: Text;
        WhseJnlBatchFilter: Text;
        ShowQtyCalculated: Boolean;
        ShowLotSN: Boolean;
        WhsePhysInvListCaptionLbl: label 'Warehouse Physical Inventory List';
        CurrReportPageNoCaptionLbl: label 'Page';
        WarehuseJnlLinRegDtCaptLbl: label 'Registering Date';
        QtyPhysInventoryCaptionLbl: label 'Quantity (Physical Inventory)';


    procedure Initialize(ShowQtyCalculated2: Boolean)
    begin
        ShowQtyCalculated := ShowQtyCalculated2;
    end;
}

