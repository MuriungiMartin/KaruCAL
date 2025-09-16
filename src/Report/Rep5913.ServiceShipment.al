#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5913 "Service - Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service - Shipment.rdlc';
    Caption = 'Service - Shipment';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Service Shipment Header";"Service Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Service Shipment';
            column(ReportForNavId_2735; 2735)
            {
            }
            column(No_ServiceShptHrd;"No.")
            {
            }
            column(DocumentDate;DocumentDateLbl)
            {
            }
            column(EmailIdCaption;EmailIdCaptionLbl)
            {
            }
            column(HomePageCaption;HomePageCaptionLbl)
            {
            }
            column(SrvcShipHeaderCustNoCaption;SrvcShipHeaderCustNoCaptionLbl)
            {
            }
            column(WarrantyCaption;WarrantyCaptionLbl)
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
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(ServiceShptCopyText;StrSubstNo(Text002,CopyText))
                    {
                    }
                    column(CurrReportPageNo;StrSubstNo(Text003,Format(CurrReport.PageNo)))
                    {
                    }
                    column(ShipToAddr1;ShipToAddr[1])
                    {
                    }
                    column(CompanyAddr1;CompanyAddr[1])
                    {
                    }
                    column(ShipToAddr2;ShipToAddr[2])
                    {
                    }
                    column(CompanyAddr2;CompanyAddr[2])
                    {
                    }
                    column(ShipToAddr3;ShipToAddr[3])
                    {
                    }
                    column(CompanyAddr3;CompanyAddr[3])
                    {
                    }
                    column(ShipToAddr4;ShipToAddr[4])
                    {
                    }
                    column(CompanyAddr4;CompanyAddr[4])
                    {
                    }
                    column(ShipToAddr5;ShipToAddr[5])
                    {
                    }
                    column(PhoneNo_CompanyInfo;CompanyInfo."Phone No.")
                    {
                    }
                    column(ShipToAddr6;ShipToAddr[6])
                    {
                    }
                    column(HomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(EMailId;CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegnNo;CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo;CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName;CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccNo;CompanyInfo."Bank Account No.")
                    {
                    }
                    column(CustNo_ServShptHrd;"Service Shipment Header"."Customer No.")
                    {
                    }
                    column(ServShptHrdDocDt;Format("Service Shipment Header"."Document Date"))
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No1_ServiceShptHrd;"Service Shipment Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourRef_ServShptHrd;"Service Shipment Header"."Your Reference")
                    {
                    }
                    column(ShipToAddr7;ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8;ShipToAddr[8])
                    {
                    }
                    column(CompanyAddr5;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6;CompanyAddr[6])
                    {
                    }
                    column(PostingDate_ServShptHrd;Format("Service Shipment Header"."Posting Date"))
                    {
                    }
                    column(PageCaption;StrSubstNo(Text003,''))
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(ItemTrackingAppendixCaption;ItemTrackingAppendixCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption;PhoneNoCaptionLbl)
                    {
                    }
                    column(VATRegNoCaption;VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption;GiroNoCaptionLbl)
                    {
                    }
                    column(BankNameCaption;BankNameCaptionLbl)
                    {
                    }
                    column(BankAccNoCaption;BankAccNoCaptionLbl)
                    {
                    }
                    column(ServiceShpHdrNoCaption;ServiceShpHdrNoCaptionLbl)
                    {
                    }
                    column(ServiceShpHdrPostingDateCaption;ServiceShpHdrPostingDateCaptionLbl)
                    {
                    }
                    column(CustNo_ServShptHrdCaption;"Service Shipment Header".FieldCaption("Customer No."))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Service Shipment Header";
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimensionLoop1Number;Number)
                        {
                        }
                        column(HdrDimsCaption;HdrDimsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            DimText := DimTxtArr[Number];
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                              CurrReport.Break;
                            FindDimTxt("Service Shipment Header"."Dimension Set ID");
                            SetRange(Number,1,DimTxtArrLength);
                        end;
                    }
                    dataitem("Service Shipment Item Line";"Service Shipment Item Line")
                    {
                        DataItemLink = "No."=field("No.");
                        DataItemLinkReference = "Service Shipment Header";
                        DataItemTableView = sorting("No.","Line No.");
                        column(ReportForNavId_2078; 2078)
                        {
                        }
                        column(ContractNo_ServShptItemLn;"Contract No.")
                        {
                        }
                        column(Des_ServShptItemLn;Description)
                        {
                        }
                        column(SerialNo_ServShptItemLn;"Serial No.")
                        {
                        }
                        column(ItemNo_ServShptItemLn;"Item No.")
                        {
                        }
                        column(ItemGrpCode_ServShptLn;"Service Item Group Code")
                        {
                        }
                        column(ServItemNo_ServShptItemLn;"Service Item No.")
                        {
                        }
                        column(Warranty;Format(Warranty))
                        {
                        }
                        column(LnNo_ServShptItemLn;"Line No.")
                        {
                        }
                        column(SrvcShpItemLineCaption;SrvcShpItemLineCaptionLbl)
                        {
                        }
                        column(ContractNo_ServShptItemLnCaption;FieldCaption("Contract No."))
                        {
                        }
                        column(Des_ServShptItemLnCaption;FieldCaption(Description))
                        {
                        }
                        column(SerialNo_ServShptItemLnCaption;FieldCaption("Serial No."))
                        {
                        }
                        column(ItemNo_ServShptItemLnCaption;FieldCaption("Item No."))
                        {
                        }
                        column(ItemGrpCode_ServShptLnCaption;FieldCaption("Service Item Group Code"))
                        {
                        }
                        column(ServItemNo_ServShptItemLnCaption;FieldCaption("Service Item No."))
                        {
                        }
                    }
                    dataitem("Service Shipment Line";"Service Shipment Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Service Shipment Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_6162; 6162)
                        {
                        }
                        column(ServShptLnDescription;Description)
                        {
                        }
                        column(ShowInternalInfo;ShowInternalInfo)
                        {
                        }
                        column(ShowCorrectionLines;ShowCorrectionLines)
                        {
                        }
                        column(ShowLotSN;ShowLotSN)
                        {
                        }
                        column(Type_ServiceShptItemLn;Type)
                        {
                        }
                        column(Qty_ServiceShptItemLn;Quantity)
                        {
                        }
                        column(UnitofMeasure_ServShptLn;"Unit of Measure")
                        {
                        }
                        column(No_ServiceShptItemLn;"No.")
                        {
                        }
                        column(QtyInvoiced_ServShptLine;"Quantity Invoiced")
                        {
                        }
                        column(QtyConsumed_ServShptLine;"Quantity Consumed")
                        {
                        }
                        column(LnNo_ServiceShptItemLn;"Line No.")
                        {
                        }
                        column(ServiceShpLineCaption;ServiceShpLineCaptionLbl)
                        {
                        }
                        column(QtyInvoicedCaption;QtyInvoicedCaptionLbl)
                        {
                        }
                        column(QtyConsumedCaption;QtyConsumedCaptionLbl)
                        {
                        }
                        column(ServShptLnDescriptionCaption;FieldCaption(Description))
                        {
                        }
                        column(Qty_ServiceShptItemLnCaption;FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_ServShptLnCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(No_ServiceShptItemLnCaption;FieldCaption("No."))
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_DimLoop2;DimText)
                            {
                            }
                            column(DimensionLoop2Number;Number)
                            {
                            }
                            column(LineDimsCaption;LineDimsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                DimText := DimTxtArr[Number];
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                  CurrReport.Break;
                                FindDimTxt("Service Shipment Line"."Dimension Set ID");
                                SetRange(Number,1,DimTxtArrLength);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if not ShowCorrectionLines and Correction then
                              CurrReport.Skip;
                        end;

                        trigger OnPostDataItem()
                        begin
                            if ShowLotSN then
                              TrackingSpecCount :=
                                ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                                  "Service Shipment Header"."No.",Database::"Service Shipment Header",0);
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := Find('+');
                            while MoreLines and (Description = '') and ("No." = '') and (Quantity = 0) do
                              MoreLines := Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            SetRange("Line No.",0,"Line No.");
                        end;
                    }
                    dataitem(Total;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3476; 3476)
                        {
                        }
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(BilltoCustNo_ServShptHrd;"Service Shipment Header"."Bill-to Customer No.")
                        {
                        }
                        column(CustAddr1;CustAddr[1])
                        {
                        }
                        column(CustAddr2;CustAddr[2])
                        {
                        }
                        column(CustAddr3;CustAddr[3])
                        {
                        }
                        column(CustAddr4;CustAddr[4])
                        {
                        }
                        column(CustAddr5;CustAddr[5])
                        {
                        }
                        column(CustAddr6;CustAddr[6])
                        {
                        }
                        column(CustAddr7;CustAddr[7])
                        {
                        }
                        column(CustAddr8;CustAddr[8])
                        {
                        }
                        column(BilltoAddrCaption;BilltoAddrCaptionLbl)
                        {
                        }
                        column(BilltoCustNo_ServShptHrdCaption;"Service Shipment Header".FieldCaption("Bill-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowCustAddr then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(ItemTrackingLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6034; 6034)
                        {
                        }
                        column(TrackingSpecBufItemNo;TrackingSpecBuffer."Item No.")
                        {
                        }
                        column(TrackingSpecBufDesc;TrackingSpecBuffer.Description)
                        {
                        }
                        column(TrackingSpecBufLotNo;TrackingSpecBuffer."Lot No.")
                        {
                        }
                        column(TrackingSpecBufSerialNo;TrackingSpecBuffer."Serial No.")
                        {
                        }
                        column(TrackingSpecBufQty;TrackingSpecBuffer."Quantity (Base)")
                        {
                        }
                        column(ShowTotal;ShowTotal)
                        {
                        }
                        column(ShowGroup;ShowGroup)
                        {
                        }
                        column(QuantityCaption;QuantityCaptionLbl)
                        {
                        }
                        column(SerialNoCaption;SerialNoCaptionLbl)
                        {
                        }
                        column(LotNoCaption;LotNoCaptionLbl)
                        {
                        }
                        column(DescriptionCaption;DescriptionCaptionLbl)
                        {
                        }
                        dataitem(TotalItemTracking;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=const(1));
                            column(ReportForNavId_3353; 3353)
                            {
                            }
                            column(TotalQty;TotalQty)
                            {
                            }
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              TrackingSpecBuffer.FindSet
                            else
                              TrackingSpecBuffer.Next;

                            if not ShowCorrectionLines and TrackingSpecBuffer.Correction then
                              CurrReport.Skip;
                            if TrackingSpecBuffer.Correction then
                              TrackingSpecBuffer."Quantity (Base)" := -TrackingSpecBuffer."Quantity (Base)";

                            ShowTotal := false;
                            if ItemTrackingAppendix.IsStartNewGroup(TrackingSpecBuffer) then
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

                        trigger OnPreDataItem()
                        begin
                            if TrackingSpecCount = 0 then
                              CurrReport.Break;
                            CurrReport.Newpage;
                            SetRange(Number,1,TrackingSpecCount);
                            TrackingSpecBuffer.SetCurrentkey("Source ID","Source Type","Source Subtype","Source Batch Name",
                              "Source Prod. Order Line","Source Ref. No.");
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        // Item Tracking:
                        if ShowLotSN then begin
                          TrackingSpecCount := 0;
                          OldRefNo := 0;
                          ShowGroup := false;
                        end;
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                    TotalQty := 0;           // Item Tracking
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      Codeunit.Run(Codeunit::"Service Shpt.-Printed","Service Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := 1 + Abs(NoOfCopies);
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Service Shipment Header");
                FormatDocumentFields("Service Shipment Header");
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
                    field(NoOfCopies;NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                    field(ShowInternalInfo;ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information';
                    }
                    field("Show Correction Lines";ShowCorrectionLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Correction Lines';
                    }
                    field(ShowLotSN;ShowLotSN)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Lot/Serial No. Appendix';
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

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        ServiceSetup.Get;
        FormatDocument.SetLogoPosition(ServiceSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
    end;

    var
        Text002: label 'Service - Shipment %1';
        Text003: label 'Page %1';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        ServiceSetup: Record "Service Mgt. Setup";
        DimSetEntry: Record "Dimension Set Entry";
        Language: Record Language;
        RespCenter: Record "Responsibility Center";
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        TotalQty: Decimal;
        OldNo: Code[20];
        CopyText: Text[30];
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        DimText: Text[120];
        ShowCustAddr: Boolean;
        MoreLines: Boolean;
        ShowInternalInfo: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        OutputNo: Integer;
        DimTxtArrLength: Integer;
        DimTxtArr: array [500] of Text[50];
        ItemTrackingAppendixCaptionLbl: label 'Item Tracking - Appendix';
        PhoneNoCaptionLbl: label 'Phone No.';
        VATRegNoCaptionLbl: label 'Tax Registration No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankNameCaptionLbl: label 'Bank';
        BankAccNoCaptionLbl: label 'Account No.';
        ServiceShpHdrNoCaptionLbl: label 'Shipment No.';
        ServiceShpHdrPostingDateCaptionLbl: label 'Posting Date';
        HdrDimsCaptionLbl: label 'Header Dimensions';
        SrvcShpItemLineCaptionLbl: label 'Service Shipment Item Line';
        ServiceShpLineCaptionLbl: label 'Service Shipment Line';
        QtyInvoicedCaptionLbl: label 'Quantity Invoiced';
        QtyConsumedCaptionLbl: label 'Quantity Consumed';
        LineDimsCaptionLbl: label 'Line Dimensions';
        BilltoAddrCaptionLbl: label 'Address';
        QuantityCaptionLbl: label 'Quantity';
        SerialNoCaptionLbl: label 'Serial No.';
        LotNoCaptionLbl: label 'Lot No.';
        DescriptionCaptionLbl: label 'Description';
        DocumentDateLbl: label 'Document Date';
        EmailIdCaptionLbl: label 'Email';
        HomePageCaptionLbl: label 'HomePage';
        SrvcShipHeaderCustNoCaptionLbl: label 'Customer No';
        WarrantyCaptionLbl: label 'Warranty';

    local procedure FindDimTxt(DimSetID: Integer)
    var
        Separation: Text[5];
        i: Integer;
        TxtToAdd: Text[120];
        StartNewLine: Boolean;
    begin
        DimSetEntry.SetRange("Dimension Set ID",DimSetID);
        DimTxtArrLength := 0;
        for i := 1 to ArrayLen(DimTxtArr) do
          DimTxtArr[i] := '';
        if not DimSetEntry.FindSet then
          exit;
        Separation := '; ';
        repeat
          TxtToAdd := DimSetEntry."Dimension Code" + ' - ' + DimSetEntry."Dimension Value Code";
          if DimTxtArrLength = 0 then
            StartNewLine := true
          else
            StartNewLine := StrLen(DimTxtArr[DimTxtArrLength]) + StrLen(Separation) + StrLen(TxtToAdd) > MaxStrLen(DimTxtArr[1]);
          if StartNewLine then begin
            DimTxtArrLength += 1;
            DimTxtArr[DimTxtArrLength] := TxtToAdd
          end else
            DimTxtArr[DimTxtArrLength] := DimTxtArr[DimTxtArrLength] + Separation + TxtToAdd;
        until DimSetEntry.Next = 0;
    end;


    procedure InitializeRequest(NewShowInternalInfo: Boolean;NewShowCorrectionLines: Boolean;NewShowLotSN: Boolean)
    begin
        ShowInternalInfo := NewShowInternalInfo;
        ShowCorrectionLines := NewShowCorrectionLines;
        ShowLotSN := NewShowLotSN;
    end;

    local procedure FormatAddressFields(var ServiceShipmentHeader: Record "Service Shipment Header")
    begin
        FormatAddr.GetCompanyAddr(ServiceShipmentHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.ServiceShptShipTo(ShipToAddr,ServiceShipmentHeader);
        ShowCustAddr := FormatAddr.ServiceShptBillTo(CustAddr,ShipToAddr,ServiceShipmentHeader);
    end;

    local procedure FormatDocumentFields(ServiceShipmentHeader: Record "Service Shipment Header")
    begin
        with ServiceShipmentHeader do begin
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
        end;
    end;
}

