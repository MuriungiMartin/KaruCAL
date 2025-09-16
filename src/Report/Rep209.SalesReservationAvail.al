#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 209 "Sales Reservation Avail."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Reservation Avail..rdlc';
    Caption = 'Sales Reservation Avail.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Sales Line";"Sales Line")
        {
            DataItemTableView = sorting("Document Type","Document No.","Line No.") where(Type=const(Item));
            RequestFilterFields = "Document Type","Document No.","No.","Location Code";
            column(ReportForNavId_2844; 2844)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(StrsubstnoDocTypeDocNo;StrSubstNo('%1 %2',"Document Type","Document No."))
            {
            }
            column(ShowSalesLineGrHeader2;ShowSalesLineGrHeader2)
            {
            }
            column(No_SalesLine;"No.")
            {
                IncludeCaption = true;
            }
            column(Description_SalesLine;Description)
            {
                IncludeCaption = true;
            }
            column(ShpmtDt__SalesLine;Format("Shipment Date"))
            {
            }
            column(Reserve__SalesLine;Reserve)
            {
                IncludeCaption = true;
            }
            column(OutstdngQtyBase_SalesLine;"Outstanding Qty. (Base)")
            {
                IncludeCaption = true;
            }
            column(ResrvdQtyBase_SalesLine;"Reserved Qty. (Base)")
            {
                IncludeCaption = true;
            }
            column(LineStatus;LineStatus)
            {
                OptionCaption = ' ,Shipped,Full Shipment,Partial Shipment,No Shipment';
            }
            column(LineReceiptDate;Format(LineReceiptDate))
            {
            }
            column(LineQuantityOnHand;LineQuantityOnHand)
            {
                DecimalPlaces = 0:5;
            }
            column(ShowSalesLineBody;ShowSalesLines)
            {
            }
            column(DocumentReceiptDate;Format(DocumentReceiptDate))
            {
            }
            column(DocumentStatus;DocumentStatus)
            {
                OptionCaption = ' ,Shipped,Full Shipment,Partial Shipment,No Shipment';
            }
            column(ShipmentDt_SalesHeader;Format(SalesHeader."Shipment Date"))
            {
            }
            column(Reserve_SalesHeader;StrSubstNo('%1',SalesHeader.Reserve))
            {
            }
            column(DocType__SalesLine;"Document Type")
            {
            }
            column(DoctNo_SalesLine;"Document No.")
            {
            }
            column(LineNo_SalesLine;"Line No.")
            {
            }
            column(SalesResrvtnAvalbtyCaption;SalesResrvtnAvalbtyCaptionLbl)
            {
            }
            column(CurrRepPageNoCaption;CurrRepPageNoCaptionLbl)
            {
            }
            column(SalesLineShpmtDtCaption;SalesLineShpmtDtCaptionLbl)
            {
            }
            column(LineReceiptDateCaption;LineReceiptDateCaptionLbl)
            {
            }
            column(LineStatusCaption;LineStatusCaptionLbl)
            {
            }
            column(LineQuantityOnHandCaption;LineQuantityOnHandCaptionLbl)
            {
            }
            dataitem("Reservation Entry";"Reservation Entry")
            {
                DataItemLink = "Source ID"=field("Document No."),"Source Ref. No."=field("Line No.");
                DataItemTableView = sorting("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Reservation Status","Shipment Date","Expected Receipt Date") where("Reservation Status"=const(Reservation),"Source Type"=const(37),"Source Batch Name"=const(''),"Source Prod. Order Line"=const(0));
                column(ReportForNavId_4003; 4003)
                {
                }
                column(ReservText;ReservText)
                {
                }
                column(ShowReservDate;Format(ShowReservDate))
                {
                }
                column(Qty_ReservationEntry;Quantity)
                {
                }
                column(EntryQuantityOnHand;EntryQuantityOnHand)
                {
                    DecimalPlaces = 0:5;
                }
                column(ShowResEntryBody;ShowReservationEntries)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Source Type" = Database::"Item Ledger Entry" then
                      ShowReservDate := 0D
                    else
                      ShowReservDate := "Expected Receipt Date";
                    ReservText := ReservEngineMgt.CreateFromText("Reservation Entry");

                    if "Source Type" <> Database::"Item Ledger Entry" then begin
                      if "Expected Receipt Date" > DocumentReceiptDate then
                        DocumentReceiptDate := "Expected Receipt Date";
                      EntryQuantityOnHand := 0;
                    end else
                      EntryQuantityOnHand := Quantity;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Source Subtype","Sales Line"."Document Type");
                end;
            }

            trigger OnAfterGetRecord()
            var
                QtyToReserve: Decimal;
                QtyToReserveBase: Decimal;
            begin
                if Reserve <> Reserve::Never then begin
                  LineReceiptDate := 0D;
                  LineQuantityOnHand := 0;
                  if "Outstanding Qty. (Base)" = 0 then
                    LineStatus := Linestatus::Shipped
                  else begin
                    ReserveSalesLine.ReservQuantity("Sales Line",QtyToReserve,QtyToReserveBase);
                    if QtyToReserveBase > 0 then begin
                      ReservEntry.Reset;
                      ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,true);
                      ReserveSalesLine.FilterReservFor(ReservEntry,"Sales Line");
                      if ReservEntry.FindSet then
                        repeat
                          ReservEntryFrom.Reset;
                          ReservEntryFrom.Get(ReservEntry."Entry No.",not ReservEntry.Positive);
                          if ReservEntryFrom."Source Type" = Database::"Item Ledger Entry" then
                            LineQuantityOnHand := LineQuantityOnHand + ReservEntryFrom.Quantity;
                        until ReservEntry.Next = 0;
                      CalcFields("Reserved Qty. (Base)");
                      if ("Outstanding Qty. (Base)" = LineQuantityOnHand) and ("Outstanding Qty. (Base)" <> 0) then
                        LineStatus := Linestatus::"Full Shipment"
                      else
                        if LineQuantityOnHand = 0 then
                          LineStatus := Linestatus::"No Shipment"
                        else
                          LineStatus := Linestatus::"Partial Shipment"
                    end else
                      LineStatus := Linestatus::"Full Shipment";
                  end;
                end else begin
                  LineReceiptDate := 0D;
                  ReserveSalesLine.ReservQuantity("Sales Line",QtyToReserve,QtyToReserveBase);
                  LineQuantityOnHand := QtyToReserveBase;
                  if "Outstanding Qty. (Base)" = 0 then
                    LineStatus := Linestatus::Shipped
                  else
                    LineStatus := Linestatus::"Full Shipment";
                end;

                if ModifyQtyToShip and ("Document Type" = "document type"::Order) and
                   ("Qty. to Ship (Base)" <> LineQuantityOnHand)
                then begin
                  if "Qty. per Unit of Measure" = 0 then
                    "Qty. per Unit of Measure" := 1;
                  Validate("Qty. to Ship",
                    ROUND(LineQuantityOnHand / "Qty. per Unit of Measure",0.00001));
                  Modify;
                end;

                if ClearDocumentStatus then begin
                  DocumentReceiptDate := 0D;
                  DocumentStatus := Documentstatus::" ";
                  ClearDocumentStatus := false;
                  SalesHeader.Get("Document Type","Document No.");
                end;

                if LineReceiptDate > DocumentReceiptDate then
                  DocumentReceiptDate := LineReceiptDate;

                case DocumentStatus of
                  Documentstatus::" ":
                    DocumentStatus := LineStatus;
                  Documentstatus::Shipped:
                    case LineStatus of
                      Linestatus::Shipped:
                        DocumentStatus := Documentstatus::Shipped;
                      Linestatus::"Full Shipment",
                      Linestatus::"Partial Shipment":
                        DocumentStatus := Documentstatus::"Partial Shipment";
                      Linestatus::"No Shipment":
                        DocumentStatus := Documentstatus::"No Shipment";
                    end;
                  Documentstatus::"Full Shipment":
                    case LineStatus of
                      Linestatus::Shipped,
                      Linestatus::"Full Shipment":
                        DocumentStatus := Documentstatus::"Full Shipment";
                      Linestatus::"Partial Shipment",
                      Linestatus::"No Shipment":
                        DocumentStatus := Documentstatus::"Partial Shipment";
                    end;
                  Documentstatus::"Partial Shipment":
                    DocumentStatus := Documentstatus::"Partial Shipment";
                  Documentstatus::"No Shipment":
                    case LineStatus of
                      Linestatus::Shipped,
                      Linestatus::"No Shipment":
                        DocumentStatus := Documentstatus::"No Shipment";
                      Linestatus::"Full Shipment",
                      Linestatus::"Partial Shipment":
                        DocumentStatus := Documentstatus::"Partial Shipment";
                    end;
                end;

                ShowSalesLineGrHeader2 := false;
                if ((OldDocumentType <> "Document Type") or
                    (OldDocumentNo <> "Document No."))
                then
                  if ShowSalesLines then
                    ShowSalesLineGrHeader2 := true;

                OldDocumentNo := "Document No.";
                OldDocumentType := "Document Type";

                TempSalesLines := "Sales Line";
                ClearDocumentStatus := true;

                if TempSalesLines.Next <> 0 then
                  ClearDocumentStatus := (TempSalesLines."Document No." <> OldDocumentNo) or (TempSalesLines."Document Type" <> OldDocumentType);
            end;

            trigger OnPreDataItem()
            begin
                ClearDocumentStatus := true;
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
                    field(ShowSalesLines;ShowSalesLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Sales Lines';

                        trigger OnValidate()
                        begin
                            if not ShowSalesLines then
                              ShowReservationEntries := false;
                        end;
                    }
                    field(ShowReservationEntries;ShowReservationEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Reservation Entries';

                        trigger OnValidate()
                        begin
                            if ShowReservationEntries and not ShowSalesLines then
                              Error(Text000);
                        end;
                    }
                    field(ModifyQuantityToShip;ModifyQtyToShip)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Modify Qty. to Ship in Order Lines';
                        MultiLine = true;
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

    var
        Text000: label 'Sales lines must be shown.';
        SalesHeader: Record "Sales Header";
        ReservEntry: Record "Reservation Entry";
        ReservEntryFrom: Record "Reservation Entry";
        TempSalesLines: Record "Sales Line";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        OldDocumentNo: Code[20];
        OldDocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        ShowSalesLineGrHeader2: Boolean;
        ShowSalesLines: Boolean;
        ShowReservationEntries: Boolean;
        ModifyQtyToShip: Boolean;
        ClearDocumentStatus: Boolean;
        ReservText: Text[80];
        ShowReservDate: Date;
        LineReceiptDate: Date;
        DocumentReceiptDate: Date;
        LineStatus: Option " ",Shipped,"Full Shipment","Partial Shipment","No Shipment";
        DocumentStatus: Option " ",Shipped,"Full Shipment","Partial Shipment","No Shipment";
        LineQuantityOnHand: Decimal;
        EntryQuantityOnHand: Decimal;
        SalesResrvtnAvalbtyCaptionLbl: label 'Sales Reservation Availability';
        CurrRepPageNoCaptionLbl: label 'Page';
        SalesLineShpmtDtCaptionLbl: label 'Shipment Date';
        LineReceiptDateCaptionLbl: label 'Expected Receipt Date';
        LineStatusCaptionLbl: label 'Shipment Status';
        LineQuantityOnHandCaptionLbl: label 'Quantity on Hand (Base)';


    procedure InitializeRequest(NewShowSalesLines: Boolean;NewShowReservationEntries: Boolean;NewModifyQtyToShip: Boolean)
    begin
        ShowSalesLines := NewShowSalesLines;
        ShowReservationEntries := NewShowReservationEntries;
        ModifyQtyToShip := NewModifyQtyToShip;
    end;
}

