#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 409 "Purchase Reservation Avail."
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase Reservation Avail..rdlc';
    Caption = 'Purchase Reservation Avail.';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem("Purchase Line";"Purchase Line")
        {
            DataItemTableView = sorting("Document Type","Document No.","Line No.") where(Type=const(Item));
            RequestFilterFields = "Document Type","Document No.","Line No.","No.","Location Code";
            column(ReportForNavId_6547; 6547)
            {
            }
            column(TodayFormatted;Format(Today,0,4))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ShowPurchLines;ShowPurchLines)
            {
            }
            column(ShowReservationEntries2;ShowReservationEntries2)
            {
            }
            column(DocTypeDocNo_PurchLine;StrSubstNo('%1 %2',"Document Type","Document No."))
            {
            }
            column(No_PurchaseLine;"No.")
            {
                IncludeCaption = true;
            }
            column(Desc_PurchLine;Description)
            {
                IncludeCaption = true;
            }
            column(ExpctRecptDate_PurchLine;Format("Expected Receipt Date"))
            {
                IncludeCaption = false;
            }
            column(OutstQtyBase_PurchLine;"Outstanding Qty. (Base)")
            {
                IncludeCaption = true;
            }
            column(ReservQtyBase_PurchLine;"Reserved Qty. (Base)")
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
            column(DocumentReceiptDate;Format(DocumentReceiptDate))
            {
            }
            column(DocumentStatus;DocumentStatus)
            {
                OptionCaption = ' ,Shipped,Full Shipment,Partial Shipment,No Shipment';
            }
            column(PurchHeaderExpctdRecptDt;Format(PurchHeader."Expected Receipt Date"))
            {
            }
            column(DocType_PurchLine;"Document Type")
            {
            }
            column(DocNo_PurchLine;"Document No.")
            {
            }
            column(LineNo_PurchLine;"Line No.")
            {
            }
            column(PurchReservAvailCap;PurchReservAvailCapLbl)
            {
            }
            column(CurrReportPAGENOCap;CurrReportPAGENOCapLbl)
            {
            }
            column(PurchLineExpctdRecptDtCap;PurchLineExpctdRecptDtCapLbl)
            {
            }
            column(LineStatusCap;LineStatusCapLbl)
            {
            }
            column(LineQtyOnHandCap;LineQtyOnHandCapLbl)
            {
            }
            dataitem("Reservation Entry";"Reservation Entry")
            {
                DataItemLink = "Source ID"=field("Document No."),"Source Ref. No."=field("Line No.");
                DataItemTableView = sorting("Source ID","Source Ref. No.","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Reservation Status","Shipment Date","Expected Receipt Date") where("Reservation Status"=const(Reservation),"Source Type"=const(39),"Source Batch Name"=const(''),"Source Prod. Order Line"=const(0));
                column(ReportForNavId_4003; 4003)
                {
                }
                column(ReservText;ReservText)
                {
                }
                column(ShowReservDate;Format(ShowReservDate))
                {
                }
                column(Quantity_ReservEntry;Quantity)
                {
                }
                column(EntryQuantityOnHand;EntryQuantityOnHand)
                {
                    DecimalPlaces = 0:5;
                }

                trigger OnAfterGetRecord()
                begin
                    if "Source Type" = Database::"Item Ledger Entry" then
                      ShowReservDate := 0D
                    else
                      ShowReservDate := "Expected Receipt Date";
                    ReservText := ReservEngineMgt.CreateFromText("Reservation Entry");

                    if "Source Type" <> Database::"Item Ledger Entry" then begin
                      if "Expected Receipt Date" > LineReceiptDate then
                        LineReceiptDate := "Expected Receipt Date";
                      if "Expected Receipt Date" > DocumentReceiptDate then
                        DocumentReceiptDate := "Expected Receipt Date";
                      EntryQuantityOnHand := 0;
                    end else
                      EntryQuantityOnHand := Quantity;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange("Source Subtype","Purchase Line"."Document Type");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if ("Document No." <> DocumentNoOld) or ("Document Type" <> DocumentTypeOld) then
                  ClearDocumentStatus := true
                else
                  ClearDocumentStatus := false;
                DocumentNoOld := "Document No.";
                DocumentTypeOld := "Document Type";
                LineReceiptDate := 0D;
                LineQuantityOnHand := 0;
                if "Outstanding Qty. (Base)" = 0 then
                  LineStatus := Linestatus::Shipped
                else begin
                  if ReservePurchLine.ReservQuantity("Purchase Line") > 0 then begin
                    ReservEntry.Reset;
                    ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry,true);
                    ReservePurchLine.FilterReservFor(ReservEntry,"Purchase Line");
                    ReservEntry.SetFilter("Source Type",'<>%1',Database::"Item Ledger Entry");
                    if ReservEntry.Find('+') then begin
                      LineReceiptDate := ReservEntry."Expected Receipt Date";
                      ReservEntry.SetRange("Source Type",Database::"Item Ledger Entry");
                      if ReservEntry.Find('-') then begin
                        repeat
                          LineQuantityOnHand := LineQuantityOnHand + ReservEntry.Quantity;
                        until ReservEntry.Next = 0;
                        LineStatus := Linestatus::"Partial Shipment";
                      end else
                        LineStatus := Linestatus::"No Shipment";
                    end else begin
                      CalcFields("Reserved Qty. (Base)");
                      LineQuantityOnHand := "Reserved Qty. (Base)";
                      if Abs("Outstanding Qty. (Base)") = Abs("Reserved Qty. (Base)") then
                        LineStatus := Linestatus::"Full Shipment"
                      else
                        if "Reserved Qty. (Base)" = 0 then
                          LineStatus := Linestatus::"No Shipment"
                        else
                          LineStatus := Linestatus::"Partial Shipment";
                    end;
                  end else
                    LineStatus := Linestatus::"Full Shipment";
                end;

                if ModifyQtyToShip and ("Document Type" = "document type"::Order) and
                   ("Qty. to Receive (Base)" <> LineQuantityOnHand)
                then begin
                  if "Qty. per Unit of Measure" = 0 then
                    "Qty. per Unit of Measure" := 1;
                  Validate("Qty. to Receive",
                    ROUND(LineQuantityOnHand / "Qty. per Unit of Measure",0.00001));
                  Modify;
                end;

                if ClearDocumentStatus then begin
                  DocumentReceiptDate := 0D;
                  DocumentStatus := Documentstatus::" ";
                  ClearDocumentStatus := false;
                  PurchHeader.Get("Document Type","Document No.");
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
            end;

            trigger OnPreDataItem()
            begin
                ClearDocumentStatus := true;

                DocumentTypeOld := 1000;
                DocumentNoOld := '';
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
                    field(ShowPurchLine;ShowPurchLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Purchase Lines';

                        trigger OnValidate()
                        begin
                            if not ShowPurchLines then
                              ShowReservationEntries := false;
                        end;
                    }
                    field(ShowReservationEntries;ShowReservationEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Reservation Entries';

                        trigger OnValidate()
                        begin
                            if ShowReservationEntries and not ShowPurchLines then
                              Error(Text000);
                        end;
                    }
                    field(ModifyQtuantityToShip;ModifyQtyToShip)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Modify Qty. to Receive in Order Lines';
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

    trigger OnPreReport()
    begin
        ShowReservationEntries2 := ShowReservationEntries;
    end;

    var
        Text000: label 'Purchase lines must be shown.';
        PurchHeader: Record "Purchase Header";
        ReservEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        ShowPurchLines: Boolean;
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
        ShowReservationEntries2: Boolean;
        DocumentNoOld: Code[20];
        DocumentTypeOld: Integer;
        PurchReservAvailCapLbl: label 'Purchase Reservation Availability';
        CurrReportPAGENOCapLbl: label 'Page';
        PurchLineExpctdRecptDtCapLbl: label 'Expected Receipt Date';
        LineStatusCapLbl: label 'Shipment Status';
        LineQtyOnHandCapLbl: label 'Quantity on Hand (Base)';


    procedure InitializeRequest(NewShowPurchLines: Boolean;NewShowReservationEntries: Boolean;NewModifyQtyToShip: Boolean)
    begin
        ShowPurchLines := NewShowPurchLines;
        ShowReservationEntries := NewShowReservationEntries;
        ModifyQtyToShip := NewModifyQtyToShip;
    end;
}

