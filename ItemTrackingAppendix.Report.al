#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6521 "Item Tracking Appendix"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Item Tracking Appendix.rdlc';
    Caption = 'Item Tracking Appendix';
    UsageCategory = Documents;

    dataset
    {
        dataitem(MainRecord;"Integer")
        {
            DataItemTableView = sorting(Number);
            PrintOnlyIfDetail = false;
            column(ReportForNavId_9100; 9100)
            {
            }
            dataitem(PageLoop;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_6455; 6455)
                {
                }
                column(Addr1;Addr[1])
                {
                }
                column(Addr2;Addr[2])
                {
                }
                column(SourceCaption;SourceCaption)
                {
                }
                column(Addr3;Addr[3])
                {
                }
                column(Addr4;Addr[4])
                {
                }
                column(TodayFormatted;Format(Today,0,4))
                {
                }
                column(Addr5;Addr[5])
                {
                }
                column(Addr6;Addr[6])
                {
                }
                column(DocumentDate;Format(DocumentDate))
                {
                }
                column(Addr7;Addr[7])
                {
                }
                column(Addr8;Addr[8])
                {
                }
                column(Addr2Caption;Addr2Caption)
                {
                }
                column(Addr21;Addr2[1])
                {
                }
                column(Addr22;Addr2[2])
                {
                }
                column(Addr23;Addr2[3])
                {
                }
                column(Addr24;Addr2[4])
                {
                }
                column(Addr25;Addr2[5])
                {
                }
                column(Addr26;Addr2[6])
                {
                }
                column(Addr27;Addr2[7])
                {
                }
                column(Addr28;Addr2[8])
                {
                }
                column(ShowAddr2;ShowAddr2)
                {
                }
                column(ItemTrackingAppendixCaption;ItemTrackingAppendixCaptionLbl)
                {
                }
                column(DocumentDateCaption;DocumentDateCaptionLbl)
                {
                }
                column(PageCaption;PageCaptionLbl)
                {
                }
                dataitem(ItemTrackingLine;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    PrintOnlyIfDetail = false;
                    column(ReportForNavId_6034; 6034)
                    {
                    }
                    column(SerialNo_ItemTrackingLine;TrackingSpecBuffer."Serial No.")
                    {
                    }
                    column(No_ItemTrackingLine;TrackingSpecBuffer."Item No.")
                    {
                    }
                    column(Desc_ItemTrackingLine;TrackingSpecBuffer.Description)
                    {
                    }
                    column(Qty_ItemTrackingLine;TrackingSpecBuffer."Quantity (Base)")
                    {
                    }
                    column(LotNo;TrackingSpecBuffer."Lot No.")
                    {
                    }
                    column(ShowGroup;ShowGroup)
                    {
                    }
                    column(NoCaption;NoCaptionLbl)
                    {
                    }
                    column(DescriptionCaption;DescriptionCaptionLbl)
                    {
                    }
                    column(QuantityCaption;QuantityCaptionLbl)
                    {
                    }
                    column(LotNoCaption;LotNoCaptionLbl)
                    {
                    }
                    column(SerialNoCaption;SerialNoCaptionLbl)
                    {
                    }
                    dataitem(Total;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3476; 3476)
                        {
                        }
                        column(TotalQuantity;TotalQty)
                        {
                        }
                        column(ShowTotal;ShowTotal)
                        {
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then
                          TrackingSpecBuffer.FindSet
                        else
                          TrackingSpecBuffer.Next;

                        if TrackingSpecBuffer.Correction then
                          TrackingSpecBuffer."Quantity (Base)" := -TrackingSpecBuffer."Quantity (Base)";

                        ShowTotal := false;
                        if IsStartNewGroup(TrackingSpecBuffer) then
                          ShowTotal := true;

                        ShowGroup := false;
                        if (TrackingSpecBuffer."Source Ref. No." <> OldRefNo) or
                           (TrackingSpecBuffer."Item No." <> OldNo)
                        then begin
                          OldRefNo := TrackingSpecBuffer."Source Ref. No.";
                          OldNo := TrackingSpecBuffer."Item No.";
                          TotalQty := 0;
                        end else
                          ShowGroup := true;
                        TotalQty += TrackingSpecBuffer."Quantity (Base)";
                    end;

                    trigger OnPostDataItem()
                    begin
                        CurrReport.PageNo(0);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if TrackingSpecCount = 0 then
                          CurrReport.Break;
                        SetRange(Number,1,TrackingSpecCount);
                        TrackingSpecBuffer.SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
                          "Source Prod. Order Line","Source Ref. No.");
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    // exclude documents without Item Tracking
                    if TrackingSpecCount = 0 then begin
                      CurrReport.PageNo(0);
                      CurrReport.Break;
                    end;
                    OldRefNo := 0;
                    ShowGroup := false;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                HandleRec(Number);
            end;

            trigger OnPreDataItem()
            begin
                if MainRecCount = 0 then
                  CurrReport.Break;
                SetRange(Number,1,MainRecCount);
            end;
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
                    field(Document;DocType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document';
                        Lookup = false;
                        OptionCaption = 'Sales Quote,Sales Order,Sales Invoice,Sales Credit Memo,Sales Return Order,Sales Post. Shipment,Sales Post. Invoice,Purch. Quote,Purch. Order,Purch. Invoice,Purch. Credit Memo,Purch. Return Order';
                    }
                    field(DocumentNo;DocNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Document No.';
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
        SetRecordFilter;
    end;

    var
        SalesHeader: Record "Sales Header";
        PurchaseHeader: Record "Purchase Header";
        SalesShipmentHdr: Record "Sales Shipment Header";
        SalesInvoiceHdr: Record "Sales Invoice Header";
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        FormatAddr: Codeunit "Format Address";
        DocNo: Code[20];
        DocType: Option "Sales Quote","Sales Order","Sales Invoice","Sales Credit Memo","Sales Return Order","Sales Post. Shipment","Sales Post. Invoice","Purch. Quote","Purch. Order","Purch. Invoice","Purch. Credit Memo","Purch. Return Order";
        Addr: array [8] of Text[50];
        Addr2: array [8] of Text[50];
        SourceCaption: Text;
        Addr2Caption: Text;
        ShowAddr2: Boolean;
        ShowGroup: Boolean;
        ShowTotal: Boolean;
        DocumentDate: Date;
        MainRecCount: Integer;
        Text002: label 'Address';
        Text003: label 'Address';
        TrackingSpecCount: Integer;
        Text004: label 'Sales - Shipment';
        OldRefNo: Integer;
        OldNo: Code[20];
        TotalQty: Decimal;
        Text005: label 'Sales - Invoice';
        Text006: label 'Sales';
        Text007: label 'Purchase';
        ItemTrackingAppendixCaptionLbl: label 'Item Tracking - Appendix';
        DocumentDateCaptionLbl: label 'Document Date';
        PageCaptionLbl: label 'Page';
        NoCaptionLbl: label 'No.';
        DescriptionCaptionLbl: label 'Description';
        QuantityCaptionLbl: label 'Quantity';
        LotNoCaptionLbl: label 'Lot No.';
        SerialNoCaptionLbl: label 'Serial No.';

    local procedure SetRecordFilter()
    begin
        case DocType of
          Doctype::"Sales Quote", Doctype::"Sales Order", Doctype::"Sales Invoice",
          Doctype::"Sales Credit Memo", Doctype::"Sales Return Order":
            FilterSalesHdr;
          Doctype::"Purch. Quote", Doctype::"Purch. Order", Doctype::"Purch. Invoice",
          Doctype::"Purch. Credit Memo", Doctype::"Purch. Return Order":
            FilterPurchHdr;
          Doctype::"Sales Post. Shipment":
            FilterSalesShip;
          Doctype::"Sales Post. Invoice":
            FilterSalesInv;
        end;
    end;

    local procedure HandleRec(Nr: Integer)
    begin
        case DocType of
          Doctype::"Sales Quote", Doctype::"Sales Order", Doctype::"Sales Invoice",
          Doctype::"Sales Credit Memo", Doctype::"Sales Return Order":
            begin
              if Nr = 1 then
                SalesHeader.FindSet
              else
                SalesHeader.Next;
              HandleSales;
            end;
          Doctype::"Purch. Quote", Doctype::"Purch. Order", Doctype::"Purch. Invoice",
          Doctype::"Purch. Credit Memo", Doctype::"Purch. Return Order":
            begin
              if Nr = 1 then
                PurchaseHeader.FindSet
              else
                PurchaseHeader.Next;
              HandlePurchase;
            end;
          Doctype::"Sales Post. Shipment":
            begin
              if Nr = 1 then
                SalesShipmentHdr.FindSet
              else
                SalesShipmentHdr.Next;
              HandleShipment;
            end;
          Doctype::"Sales Post. Invoice":
            begin
              if Nr = 1 then
                SalesInvoiceHdr.FindSet
              else
                SalesInvoiceHdr.Next;
              HandleInvoice;
            end;
        end;
    end;

    local procedure HandleSales()
    begin
        AddressSalesHdr(SalesHeader);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,SalesHeader."No.",
            Database::"Sales Header",SalesHeader."Document Type");
    end;

    local procedure HandlePurchase()
    begin
        AddressPurchaseHdr(PurchaseHeader);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,PurchaseHeader."No.",
            Database::"Purchase Header",PurchaseHeader."Document Type");
    end;

    local procedure HandleShipment()
    begin
        AddressShipmentHdr(SalesShipmentHdr);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,SalesShipmentHdr."No.",
            Database::"Sales Shipment Header",0);
    end;

    local procedure HandleInvoice()
    begin
        AddressInvoiceHdr(SalesInvoiceHdr);
        TrackingSpecCount :=
          ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,SalesInvoiceHdr."No.",
            Database::"Sales Invoice Header",0);
    end;

    local procedure AddressSalesHdr(SalesHdr: Record "Sales Header")
    begin
        ShowAddr2 := false;
        with SalesHdr do begin
          case "Document Type" of
            "document type"::Invoice,"document type"::"Credit Memo":
              begin
                FormatAddr.SalesHeaderSellTo(Addr,SalesHdr);
                if "Bill-to Customer No." <> "Sell-to Customer No." then begin
                  FormatAddr.SalesHeaderBillTo(Addr2,SalesHdr);
                  ShowAddr2 := true;
                end;
              end
            else
              FormatAddr.SalesHeaderBillTo(Addr,SalesHdr);
          end;
          DocumentDate := "Document Date";
          SourceCaption := StrSubstNo('%1 %2 %3',Text006,"Document Type","No.");
          Addr2Caption := Text003;
        end;
    end;

    local procedure AddressPurchaseHdr(PurchaseHdr: Record "Purchase Header")
    begin
        ShowAddr2 := false;
        with PurchaseHdr do begin
          case "Document Type" of
            "document type"::Quote,"document type"::"Blanket Order":
              FormatAddr.PurchHeaderPayTo(Addr,PurchaseHdr);
            "document type"::Order,"document type"::"Return Order":
              begin
                FormatAddr.PurchHeaderBuyFrom(Addr,PurchaseHdr);
                if "Buy-from Vendor No." <> "Pay-to Vendor No." then begin
                  FormatAddr.PurchHeaderPayTo(Addr2,PurchaseHdr);
                  ShowAddr2 := true;
                end;
              end;
            "document type"::Invoice,"document type"::"Credit Memo":
              begin
                FormatAddr.PurchHeaderPayTo(Addr,PurchaseHdr);
                if not ("Pay-to Vendor No." in ['',"Buy-from Vendor No."]) then begin
                  FormatAddr.PurchHeaderBuyFrom(Addr2,PurchaseHdr);
                  ShowAddr2 := true;
                end;
              end;
          end;
          DocumentDate := "Document Date";
          SourceCaption := StrSubstNo('%1 %2 %3',Text007,"Document Type","No.");
          Addr2Caption := Text002;
        end;
    end;

    local procedure AddressShipmentHdr(SalesShipHdr: Record "Sales Shipment Header")
    begin
        ShowAddr2 := false;
        with SalesShipHdr do begin
          FormatAddr.SalesShptShipTo(Addr,SalesShipHdr);
          if "Bill-to Customer No." <> "Sell-to Customer No." then begin
            FormatAddr.SalesShptBillTo(Addr2,Addr2,SalesShipHdr);
            ShowAddr2 := true;
          end;
          DocumentDate := "Document Date";
          SourceCaption := StrSubstNo('%1 %2',Text004,"No.");
          Addr2Caption := Text003;
        end;
    end;

    local procedure AddressInvoiceHdr(SalesInvHdr: Record "Sales Invoice Header")
    begin
        ShowAddr2 := false;
        with SalesInvHdr do begin
          FormatAddr.SalesInvBillTo(Addr,SalesInvHdr);
          DocumentDate := "Document Date";
          SourceCaption := StrSubstNo('%1 %2',Text005,"No.");
          Addr2Caption := Text002;
        end;
    end;


    procedure IsStartNewGroup(var TrackingSpecBuffer: Record "Tracking Specification" temporary): Boolean
    var
        TrackingSpecBuffer2: Record "Tracking Specification" temporary;
        SourceRef: Integer;
    begin
        TrackingSpecBuffer2 := TrackingSpecBuffer;
        SourceRef := TrackingSpecBuffer2."Source Ref. No.";
        if TrackingSpecBuffer.Next = 0 then begin
          TrackingSpecBuffer := TrackingSpecBuffer2;
          exit(true);
        end;
        if SourceRef <> TrackingSpecBuffer."Source Ref. No." then begin
          TrackingSpecBuffer := TrackingSpecBuffer2;
          exit(true);
        end;
        TrackingSpecBuffer := TrackingSpecBuffer2;
        exit(false);
    end;

    local procedure FilterSalesHdr()
    begin
        case DocType of
          Doctype::"Sales Quote":
            SalesHeader.SetRange("Document Type",SalesHeader."document type"::Quote);
          Doctype::"Sales Order":
            SalesHeader.SetRange("Document Type",SalesHeader."document type"::Order);
          Doctype::"Sales Invoice":
            SalesHeader.SetRange("Document Type",SalesHeader."document type"::Invoice);
          Doctype::"Sales Credit Memo":
            SalesHeader.SetRange("Document Type",SalesHeader."document type"::"Credit Memo");
          Doctype::"Sales Return Order":
            SalesHeader.SetRange("Document Type",SalesHeader."document type"::"Return Order");
        end;
        if DocNo <> '' then
          SalesHeader.SetFilter("No.",DocNo);
        MainRecCount := SalesHeader.Count;
    end;

    local procedure FilterSalesShip()
    begin
        if DocNo <> '' then
          SalesShipmentHdr.SetRange("No.",DocNo);
        MainRecCount := SalesShipmentHdr.Count;
    end;

    local procedure FilterSalesInv()
    begin
        if DocNo <> '' then
          SalesInvoiceHdr.SetRange("No.",DocNo);
        MainRecCount := SalesInvoiceHdr.Count;
    end;

    local procedure FilterPurchHdr()
    begin
        case DocType of
          Doctype::"Purch. Quote":
            PurchaseHeader.SetRange("Document Type",PurchaseHeader."document type"::Quote);
          Doctype::"Purch. Order":
            PurchaseHeader.SetRange("Document Type",PurchaseHeader."document type"::Order);
          Doctype::"Purch. Invoice":
            PurchaseHeader.SetRange("Document Type",PurchaseHeader."document type"::Invoice);
          Doctype::"Purch. Credit Memo":
            PurchaseHeader.SetRange("Document Type",PurchaseHeader."document type"::"Credit Memo");
          Doctype::"Purch. Return Order":
            PurchaseHeader.SetRange("Document Type",PurchaseHeader."document type"::"Return Order");
        end;
        if DocNo <> '' then
          PurchaseHeader.SetFilter("No.",DocNo);
        MainRecCount := PurchaseHeader.Count;
    end;
}

