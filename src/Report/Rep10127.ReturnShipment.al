#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10127 "Return Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Return Shipment.rdlc';
    Caption = 'Return Shipment';

    dataset
    {
        dataitem("Return Shipment Header";"Return Shipment Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Buy-from Vendor No.","Pay-to Vendor No.","No. Printed";
            RequestFilterHeading = 'Return Shipment';
            column(ReportForNavId_8295; 8295)
            {
            }
            column(No_ReturnShipmentHeader;"No.")
            {
            }
            column(FromCaption;FromCaptionLbl)
            {
            }
            column(ReceiveByCaption;ReceiveByCaptionLbl)
            {
            }
            column(VendorIDCaption;VendorIDCaptionLbl)
            {
            }
            column(ConfirmToCaption;ConfirmToCaptionLbl)
            {
            }
            column(BuyerCaption;BuyerCaptionLbl)
            {
            }
            column(ShipCaption;ShipCaptionLbl)
            {
            }
            column(ToCaption;ToCaptionLbl)
            {
            }
            column(ReturnShipmentCaption;ReturnShipmentCaptionLbl)
            {
            }
            column(ReturnShpNumberCaption;ReturnShpNumberCaptionLbl)
            {
            }
            column(ReturnShipmentDateCaption;ReturnShipmentDateCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(ShipViaCaption;ShipViaCaptionLbl)
            {
            }
            column(RONumberCaption;RONumberCaptionLbl)
            {
            }
            column(PurchaseCaption;PurchaseCaptionLbl)
            {
            }
            column(ItemNoCaption;ItemNoCaptionLbl)
            {
            }
            column(UnitCaption;UnitCaptionLbl)
            {
            }
            column(DescriptionCaption;DescriptionCaptionLbl)
            {
            }
            column(ShippedCaption;ShippedCaptionLbl)
            {
            }
            column(AuthorizedCaption;AuthorizedCaptionLbl)
            {
            }
            column(ToBeShippedCaption;ToBeShippedCaptionLbl)
            {
            }
            dataitem(CopyLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5701; 5701)
                {
                }
                dataitem(PageLoop;"Integer")
                {
                    DataItemTableView = sorting(Number) where(Number=const(1));
                    column(ReportForNavId_6455; 6455)
                    {
                    }
                    column(CompanyAddress1;CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress2;CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress3;CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress4;CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress5;CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress6;CompanyAddress[6])
                    {
                    }
                    column(CopyTxt;CopyTxt)
                    {
                    }
                    column(BuyFromAddress1;BuyFromAddress[1])
                    {
                    }
                    column(BuyFromAddress2;BuyFromAddress[2])
                    {
                    }
                    column(BuyFromAddress3;BuyFromAddress[3])
                    {
                    }
                    column(BuyFromAddress4;BuyFromAddress[4])
                    {
                    }
                    column(BuyFromAddress5;BuyFromAddress[5])
                    {
                    }
                    column(BuyFromAddress6;BuyFromAddress[6])
                    {
                    }
                    column(BuyFromAddress7;BuyFromAddress[7])
                    {
                    }
                    column(ExpectedRcptDate_ReturnShpHdr;"Return Shipment Header"."Expected Receipt Date")
                    {
                    }
                    column(ShipToAddress1;ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress2;ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress3;ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress4;ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress5;ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress6;ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress7;ShipToAddress[7])
                    {
                    }
                    column(BuyfromVendNo_ReturnShpHdr;"Return Shipment Header"."Buy-from Vendor No.")
                    {
                    }
                    column(YourReference_ReturnShpHdr;"Return Shipment Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(DocDate_ReturnShpHdr;"Return Shipment Header"."Document Date")
                    {
                    }
                    column(CompanyAddress7;CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8;CompanyAddress[8])
                    {
                    }
                    column(BuyFromAddress8;BuyFromAddress[8])
                    {
                    }
                    column(ShipToAddress8;ShipToAddress[8])
                    {
                    }
                    column(ShipmentMethodDescription;ShipmentMethod.Description)
                    {
                    }
                    column(ReturnOrderNo_ReturnShpHdr;"Return Shipment Header"."Return Order No.")
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    dataitem("Return Shipment Line";"Return Shipment Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Return Shipment Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_8757; 8757)
                        {
                        }
                        column(ItemNumberToPrint;ItemNumberToPrint)
                        {
                        }
                        column(UOM_ReturnShipmentLine;"Unit of Measure")
                        {
                        }
                        column(Qty_ReturnShipmentLine;Quantity)
                        {
                        }
                        column(OrderedQuantity;OrderedQuantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(BackOrderedQuantity;BackOrderedQuantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(LineNo_ReturnShpLine;"Line No.")
                        {
                        }
                        column(Description_ReturnShpLine;Description)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            OrderedQuantity := 0;
                            BackOrderedQuantity := 0;
                            if "Return Order No." = '' then
                              OrderedQuantity := Quantity
                            else
                              if OrderLine.Get(5,"Return Order No.","Return Order Line No.") then begin
                                OrderedQuantity := OrderLine.Quantity;
                                BackOrderedQuantity := OrderLine."Outstanding Quantity";
                              end else begin
                                ReturnLine.SetCurrentkey("Return Order No.","Return Order Line No.");
                                ReturnLine.SetRange("Return Order No.","Return Order No.");
                                ReturnLine.SetRange("Return Order Line No.","Return Order Line No.");
                                ReturnLine.Find('-');
                                repeat
                                  OrderedQuantity := OrderedQuantity + ReturnLine.Quantity;
                                until 0 = ReturnLine.Next;
                              end;

                            if Type = 0 then begin
                              ItemNumberToPrint := '';
                              "Unit of Measure" := '';
                              OrderedQuantity := 0;
                              BackOrderedQuantity := 0;
                              Quantity := 0;
                            end else
                              if Type = Type::"G/L Account" then
                                ItemNumberToPrint := "Vendor Item No."
                              else
                                ItemNumberToPrint := "No.";
                        end;

                        trigger OnPreDataItem()
                        begin
                            OnLineNumber := 0;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;

                    if CopyNo = NoLoops then begin
                      if not CurrReport.Preview then
                        PurchaseShptPrinted.Run("Return Shipment Header");
                      CurrReport.Break;
                    end;
                    CopyNo := CopyNo + 1;
                    if CopyNo = 1 then // Original
                      Clear(CopyTxt)
                    else
                      CopyTxt := Text000;
                end;

                trigger OnPreDataItem()
                begin
                    NoLoops := 1 + Abs(NoCopies);
                    if NoLoops <= 0 then
                      NoLoops := 1;
                    CopyNo := 0;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if PrintCompany then
                  if RespCenter.Get("Responsibility Center") then begin
                    FormatAddress.RespCenter(CompanyAddress,RespCenter);
                    CompanyInformation."Phone No." := RespCenter."Phone No.";
                    CompanyInformation."Fax No." := RespCenter."Fax No.";
                  end;
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if "Purchaser Code" = '' then
                  Clear(SalesPurchPerson)
                else
                  SalesPurchPerson.Get("Purchaser Code");

                if "Shipment Method Code" = '' then
                  Clear(ShipmentMethod)
                else
                  ShipmentMethod.Get("Shipment Method Code");

                if "Buy-from Vendor No." = '' then begin
                  "Buy-from Vendor Name" := Text009;
                  "Ship-to Name" := Text009;
                end;

                FormatAddress.PurchShptBuyFrom(BuyFromAddress,"Return Shipment Header");
                FormatAddress.PurchShptShipTo(ShipToAddress,"Return Shipment Header");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      15,"No.",0,0,Database::Vendor,"Buy-from Vendor No.","Purchaser Code",'',"Posting Description",'');
            end;

            trigger OnPreDataItem()
            begin
                if PrintCompany then
                  FormatAddress.Company(CompanyAddress,CompanyInformation)
                else
                  Clear(CompanyAddress);
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
                    field(NumberOfCopies;NoCopies)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Number of Copies';
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress;PrintCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies if you want to record the related interactions with the involved contact person in the Interaction Log Entry table.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            LogInteraction := SegManagement.FindInteractTmplCode(15) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get('');
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        ReturnLine: Record "Return Shipment Line";
        OrderLine: Record "Purchase Line";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CompanyAddress: array [8] of Text[50];
        BuyFromAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        ItemNumberToPrint: Text[20];
        PrintCompany: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        OnLineNumber: Integer;
        PurchaseShptPrinted: Codeunit "Return Shipment - Printed";
        FormatAddress: Codeunit "Format Address";
        OrderedQuantity: Decimal;
        BackOrderedQuantity: Decimal;
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        Text000: label 'COPY';
        Text009: label 'VOID SHIPMENT';
        [InDataSet]
        LogInteractionEnable: Boolean;
        FromCaptionLbl: label 'From:';
        ReceiveByCaptionLbl: label 'Receive By';
        VendorIDCaptionLbl: label 'Vendor ID';
        ConfirmToCaptionLbl: label 'Confirm To';
        BuyerCaptionLbl: label 'Buyer';
        ShipCaptionLbl: label 'Ship';
        ToCaptionLbl: label 'To:';
        ReturnShipmentCaptionLbl: label 'RETURN SHIPMENT';
        ReturnShpNumberCaptionLbl: label 'Return Shipment Number:';
        ReturnShipmentDateCaptionLbl: label 'Return Shipment Date:';
        PageCaptionLbl: label 'Page:';
        ShipViaCaptionLbl: label 'Ship Via';
        RONumberCaptionLbl: label 'R.O. Number';
        PurchaseCaptionLbl: label 'Purchase';
        ItemNoCaptionLbl: label 'Item No.';
        UnitCaptionLbl: label 'Unit';
        DescriptionCaptionLbl: label 'Description';
        ShippedCaptionLbl: label 'Shipped';
        AuthorizedCaptionLbl: label 'Authorized';
        ToBeShippedCaptionLbl: label 'To Be Shipped';
}

