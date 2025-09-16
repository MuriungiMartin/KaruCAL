#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51276 "Inventory - Transaction"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Inventory - Transaction.rdlc';
    Caption = 'Inventory - Transaction Detail';

    dataset
    {
        dataitem(Item;Item)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.",Description,"Assembly BOM","Inventory Posting Group","Shelf No.","Statistics Group","Date Filter";
            column(ReportForNavId_8129; 8129)
            {
            }
            column(PeriodItemDateFilter;StrSubstNo(Text000,ItemDateFilter))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(TableCaptionItemFilter;StrSubstNo('%1: %2',TableCaption,ItemFilter))
            {
            }
            column(ItemFilter;ItemFilter)
            {
            }
            column(No_Item;"No.")
            {
            }
            column(InventoryTransDetailCaption;InventoryTransDetailCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption;CurrReportPageNoCaptionLbl)
            {
            }
            column(ItemLedgEntryPostDateCaption;ItemLedgEntryPostDateCaptionLbl)
            {
            }
            column(ItemLedgEntryEntryTypCaption;ItemLedgEntryEntryTypCaptionLbl)
            {
            }
            column(StockInQtyCaption;IncreasesQtyCaptionLbl)
            {
            }
            column(ItemFilters;ItemFilters)
            {
            }
            column(StockOutQtyCaption;DecreasesQtyCaptionLbl)
            {
            }
            column(ItemOnHandCaption;ItemOnHandCaptionLbl)
            {
            }
            column(BranchName;DimText)
            {
            }
            dataitem(PageCounter;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_8098; 8098)
                {
                }
                column(Description_Item;Item.Description)
                {
                }
                column(StartOnHand;StartOnHand)
                {
                    DecimalPlaces = 0:5;
                }
                column(RecordNo;RecordNo)
                {
                }
                dataitem("Item Ledger Entry";"Item Ledger Entry")
                {
                    DataItemLink = "Item No."=field("No."),"Variant Code"=field("Variant Filter"),"Posting Date"=field("Date Filter"),"Location Code"=field("Location Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter");
                    DataItemLinkReference = Item;
                    DataItemTableView = sorting("Item No.","Entry Type","Variant Code","Drop Shipment","Location Code","Posting Date");
                    column(ReportForNavId_7209; 7209)
                    {
                    }
                    column(StartOnHandQuantity;StartOnHand + Quantity)
                    {
                        DecimalPlaces = 0:5;
                    }
                    column(PostingDate_ItemLedgEntry;Format("Posting Date"))
                    {
                    }
                    column(EntryType_ItemLedgEntry;"Entry Type")
                    {
                    }
                    column(DocumentNo_PItemLedgEntry;"Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Description_ItemLedgEntry;Description)
                    {
                        IncludeCaption = true;
                    }
                    column(IncreasesQty;IncreasesQty)
                    {
                        DecimalPlaces = 0:5;
                    }
                    column(DecreasesQty;DecreasesQty)
                    {
                        DecimalPlaces = 0:5;
                    }
                    column(ItemOnHand;ItemOnHand)
                    {
                        DecimalPlaces = 0:5;
                    }
                    column(EntryNo_ItemLedgerEntry;"Entry No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Quantity_ItemLedgerEntry;Quantity)
                    {
                    }
                    column(ItemDescriptionControl32;Item.Description)
                    {
                    }
                    column(ContinuedCaption;ContinuedCaptionLbl)
                    {
                    }
                    column(SerialNum;SerialNum)
                    {
                    }
                    column(TransferOrder;TransferOrder)
                    {
                    }
                    column(Location;"Item Ledger Entry"."Location Code")
                    {
                    }
                    column(Cost;"Item Ledger Entry"."Cost Amount (Actual)")
                    {
                    }
                    column(Branch_name;DimText)
                    {
                    }
                    column(RequestingStore;RequestingStore)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        ItemOnHand := ItemOnHand + Quantity;
                        if Quantity > 0 then
                          IncreasesQty := Quantity
                        else
                          DecreasesQty := Abs(Quantity);
                        SerialNum+=1;

                        TransferOrder:='';
                        if "Document Type" = "document type"::"Transfer Shipment" then begin
                        TransferShip.SetRange(TransferShip."No.","Document No.");
                         if TransferShip.FindFirst then
                           TransferOrder:=TransferShip."Transfer Order No.";
                        end else if "Document Type" = "document type"::"Transfer Receipt" then begin
                         TransferRcp.SetRange(TransferRcp."No.","Document No.");
                         if TransferRcp.FindFirst then
                           TransferOrder:=TransferRcp."Transfer Order No.";

                        end;
                        DimText:='';
                        Dim.Reset;
                        Dim.SetRange(Dim."Global Dimension No.",3);
                        //Dim.SETRANGE(Dim.Code,"Branch Code");
                        //IF  "Branch Code"<>'' THEN BEGIN
                         if Dim.Find('-') then
                            DimText:=Dim.Name
                            else
                            DimText:='';
                          //END;

                        RequestingStore:='';
                        SetCurrentkey("Document No.","Document Type","Document Line No.");
                        SRH.SetRange(SRH."No.","Document No.");
                        if SRH.FindFirst then
;

                    trigger OnPreDataItem()
                    begin
                        CurrReport.CreateTotals(Quantity,IncreasesQty,DecreasesQty);
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                StartOnHand := 0;
                if ItemDateFilter <> '' then
                  if GetRangeMin("Date Filter") > 00000101D then begin
                    SetRange("Date Filter",0D,GetRangeMin("Date Filter") - 1);
                    CalcFields("Net Change");
                    StartOnHand := "Net Change";
                    SetFilter("Date Filter",ItemDateFilter);
                  end;
                ItemOnHand := StartOnHand;

                if PrintOnlyOnePerPage then
                  RecordNo := RecordNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                RecordNo := 1;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Item';
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
        ItemFilter := Item.GetFilters;
        ItemDateFilter := Item.GetFilter("Date Filter");

        ItemFilters:=Item.GetFilters;
    end;

    var
        Text000: label 'Period: %1';
        ItemFilter: Text;
        ItemDateFilter: Text[30];
        ItemOnHand: Decimal;
        StartOnHand: Decimal;
        IncreasesQty: Decimal;
        DecreasesQty: Decimal;
        PrintOnlyOnePerPage: Boolean;
        RecordNo: Integer;
        InventoryTransDetailCaptionLbl: label 'Inventory - Transaction Detail';
        CurrReportPageNoCaptionLbl: label 'Page';
        ItemLedgEntryPostDateCaptionLbl: label 'Posting Date';
        ItemLedgEntryEntryTypCaptionLbl: label 'Entry Type';
        IncreasesQtyCaptionLbl: label 'Increases';
        DecreasesQtyCaptionLbl: label 'Decreases';
        ItemOnHandCaptionLbl: label 'Inventory';
        ContinuedCaptionLbl: label 'Continued';
        SerialNum: Integer;
        ItemLedger: Record "Item Ledger Entry";
        ItemFilters: Text[1024];
        TransferShip: Record "Transfer Shipment Header";
        TransferRcp: Record "Transfer Receipt Header";
        TransferOrder: Code[20];
        Dim: Record "Dimension Value";
        DimText: Text[150];
        SRH: Record UnknownRecord61399;
        RequestingStore: Code[20];


    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
    end;
}

