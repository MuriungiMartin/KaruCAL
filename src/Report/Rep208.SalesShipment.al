#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 208 "Sales - Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales - Shipment.rdlc';
    Caption = 'Sales - Shipment';
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Sales Shipment Header";"Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Sales Shipment';
            column(ReportForNavId_3595; 3595)
            {
            }
            column(No_SalesShptHeader;"No.")
            {
            }
            column(PageCaption;PageCaptionCap)
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
                    column(SalesShptCopyText;StrSubstNo(Text002,CopyText))
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
                    column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                    {
                    }
                    column(ShipToAddr6;ShipToAddr[6])
                    {
                    }
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail;CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoFaxNo;CompanyInfo."Fax No.")
                    {
                    }
                    column(CompanyInfoVATRegtnNo;CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo;CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName;CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoBankAccountNo;CompanyInfo."Bank Account No.")
                    {
                    }
                    column(SelltoCustNo_SalesShptHeader;"Sales Shipment Header"."Sell-to Customer No.")
                    {
                    }
                    column(DocDate_SalesShptHeader;Format("Sales Shipment Header"."Document Date",0,4))
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourRef_SalesShptHeader;"Sales Shipment Header"."Your Reference")
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
                    column(ShptDate_SalesShptHeader;Format("Sales Shipment Header"."Shipment Date"))
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
                    column(ShipmentNoCaption;ShipmentNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption;ShipmentDateCaptionLbl)
                    {
                    }
                    column(HomePageCaption;HomePageCaptionLbl)
                    {
                    }
                    column(EmailCaption;EmailCaptionLbl)
                    {
                    }
                    column(DocumentDateCaption;DocumentDateCaptionLbl)
                    {
                    }
                    column(SelltoCustNo_SalesShptHeaderCaption;"Sales Shipment Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(HeaderDimensionsCaption;HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                              if not DimSetEntry1.FindSet then
                                CurrReport.Break;
                            end else
                              if not Continue then
                                CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                              OldDimText := DimText;
                              if DimText = '' then
                                DimText := StrSubstNo('%1 - %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
                              else
                                DimText :=
                                  StrSubstNo(
                                    '%1; %2 - %3',DimText,
                                    DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code");
                              if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                DimText := OldDimText;
                                Continue := true;
                                exit;
                              end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Sales Shipment Line";"Sales Shipment Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Sales Shipment Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_2502; 2502)
                        {
                        }
                        column(Description_SalesShptLine;Description)
                        {
                        }
                        column(ShowInternalInfo;ShowInternalInfo)
                        {
                        }
                        column(ShowCorrectionLines;ShowCorrectionLines)
                        {
                        }
                        column(Type_SalesShptLine;Format(Type,0,2))
                        {
                        }
                        column(AsmHeaderExists;AsmHeaderExists)
                        {
                        }
                        column(DocumentNo_SalesShptLine;"Document No.")
                        {
                        }
                        column(LinNo;LinNo)
                        {
                        }
                        column(Qty_SalesShptLine;Quantity)
                        {
                        }
                        column(UOM_SalesShptLine;"Unit of Measure")
                        {
                        }
                        column(No_SalesShptLine;"No.")
                        {
                        }
                        column(LineNo_SalesShptLine;"Line No.")
                        {
                        }
                        column(Description_SalesShptLineCaption;FieldCaption(Description))
                        {
                        }
                        column(Qty_SalesShptLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(UOM_SalesShptLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(No_SalesShptLineCaption;FieldCaption("No."))
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText1;DimText)
                            {
                            }
                            column(LineDimensionsCaption;LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                  if not DimSetEntry2.FindSet then
                                    CurrReport.Break;
                                end else
                                  if not Continue then
                                    CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                  OldDimText := DimText;
                                  if DimText = '' then
                                    DimText := StrSubstNo('%1 - %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
                                  else
                                    DimText :=
                                      StrSubstNo(
                                        '%1; %2 - %3',DimText,
                                        DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code");
                                  if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                  end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                  CurrReport.Break;
                            end;
                        }
                        dataitem(DisplayAsmInfo;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_7359; 7359)
                            {
                            }
                            column(PostedAsmLineItemNo;BlanksForIndent + PostedAsmLine."No.")
                            {
                            }
                            column(PostedAsmLineDescription;BlanksForIndent + PostedAsmLine.Description)
                            {
                            }
                            column(PostedAsmLineQuantity;PostedAsmLine.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(PostedAsmLineUOMCode;GetUnitOfMeasureDescr(PostedAsmLine."Unit of Measure Code"))
                            {
                                DecimalPlaces = 0:5;
                            }

                            trigger OnAfterGetRecord()
                            var
                                ItemTranslation: Record "Item Translation";
                            begin
                                if Number = 1 then
                                  PostedAsmLine.FindSet
                                else
                                  PostedAsmLine.Next;

                                if ItemTranslation.Get(PostedAsmLine."No.",
                                     PostedAsmLine."Variant Code",
                                     "Sales Shipment Header"."Language Code")
                                then
                                  PostedAsmLine.Description := ItemTranslation.Description;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not DisplayAssemblyInformation then
                                  CurrReport.Break;
                                if not AsmHeaderExists then
                                  CurrReport.Break;

                                PostedAsmLine.SetRange("Document No.",PostedAsmHeader."No.");
                                SetRange(Number,1,PostedAsmLine.Count);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            LinNo := "Line No.";
                            if not ShowCorrectionLines and Correction then
                              CurrReport.Skip;

                            DimSetEntry2.SetRange("Dimension Set ID","Dimension Set ID");
                            if DisplayAssemblyInformation then
                              AsmHeaderExists := AsmToShipmentExists(PostedAsmHeader);
                        end;

                        trigger OnPostDataItem()
                        begin
                            if ShowLotSN then begin
                              ItemTrackingDocMgt.SetRetrieveAsmItemTracking(true);
                              TrackingSpecCount :=
                                ItemTrackingDocMgt.RetrieveDocumentItemTracking(TrackingSpecBuffer,
                                  "Sales Shipment Header"."No.",Database::"Sales Shipment Header",0);
                              ItemTrackingDocMgt.SetRetrieveAsmItemTracking(false);
                            end;
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
                        column(BilltoCustNo_SalesShptHeader;"Sales Shipment Header"."Bill-to Customer No.")
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
                        column(BilltoAddressCaption;BilltoAddressCaptionLbl)
                        {
                        }
                        column(BilltoCustNo_SalesShptHeaderCaption;"Sales Shipment Header".FieldCaption("Bill-to Customer No."))
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
                        column(TrackingSpecBufferNo;TrackingSpecBuffer."Item No.")
                        {
                        }
                        column(TrackingSpecBufferDesc;TrackingSpecBuffer.Description)
                        {
                        }
                        column(TrackingSpecBufferLotNo;TrackingSpecBuffer."Lot No.")
                        {
                        }
                        column(TrackingSpecBufferSerNo;TrackingSpecBuffer."Serial No.")
                        {
                        }
                        column(TrackingSpecBufferQty;TrackingSpecBuffer."Quantity (Base)")
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
                        column(NoCaption;NoCaptionLbl)
                        {
                        }
                        dataitem(TotalItemTracking;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=const(1));
                            column(ReportForNavId_3353; 3353)
                            {
                            }
                            column(Quantity1;TotalQty)
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
                      Codeunit.Run(Codeunit::"Sales Shpt.-Printed","Sales Shipment Header");
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

                FormatAddressFields("Sales Shipment Header");
                FormatDocumentFields("Sales Shipment Header");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      5,"No.",0,0,Database::Customer,"Sell-to Customer No.","Salesperson Code",
                      "Campaign No.","Posting Description",'');
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
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                    }
                    field("Show Correction Lines";ShowCorrectionLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Correction Lines';
                    }
                    field(ShowLotSN;ShowLotSN)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Serial/Lot Number Appendix';
                    }
                    field(DisplayAsmInfo;DisplayAssemblyInformation)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Assembly Components';
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
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        SalesSetup.Get;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);
    end;

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
          InitLogInteraction;
        AsmHeaderExists := false;
    end;

    var
        Text002: label 'Sales - Shipment %1', Comment='%1 = Document No.';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        Language: Record Language;
        TrackingSpecBuffer: Record "Tracking Specification" temporary;
        PostedAsmHeader: Record "Posted Assembly Header";
        PostedAsmLine: Record "Posted Assembly Line";
        RespCenter: Record "Responsibility Center";
        ItemTrackingAppendix: Report "Item Tracking Appendix";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        OutputNo: Integer;
        NoOfLoops: Integer;
        TrackingSpecCount: Integer;
        OldRefNo: Integer;
        OldNo: Code[20];
        CopyText: Text[30];
        ShowCustAddr: Boolean;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        ShowLotSN: Boolean;
        ShowTotal: Boolean;
        ShowGroup: Boolean;
        TotalQty: Decimal;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmHeaderExists: Boolean;
        LinNo: Integer;
        ItemTrackingAppendixCaptionLbl: label 'Item Tracking - Appendix';
        PhoneNoCaptionLbl: label 'Phone No.';
        VATRegNoCaptionLbl: label 'Tax Reg. No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankNameCaptionLbl: label 'Bank';
        BankAccNoCaptionLbl: label 'Account No.';
        ShipmentNoCaptionLbl: label 'Shipment No.';
        ShipmentDateCaptionLbl: label 'Shipment Date';
        HomePageCaptionLbl: label 'Home Page';
        EmailCaptionLbl: label 'Email';
        DocumentDateCaptionLbl: label 'Document Date';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        BilltoAddressCaptionLbl: label 'Address';
        QuantityCaptionLbl: label 'Quantity';
        SerialNoCaptionLbl: label 'Serial No.';
        LotNoCaptionLbl: label 'Lot No.';
        DescriptionCaptionLbl: label 'Description';
        NoCaptionLbl: label 'No.';
        PageCaptionCap: label 'Page %1 of %2';


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
    end;


    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean;NewShowCorrectionLines: Boolean;NewShowLotSN: Boolean;DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
        ShowLotSN := NewShowLotSN;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;

    local procedure FormatAddressFields(SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        FormatAddr.GetCompanyAddr(SalesShipmentHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.SalesShptShipTo(ShipToAddr,SalesShipmentHeader);
        ShowCustAddr := FormatAddr.SalesShptBillTo(CustAddr,ShipToAddr,SalesShipmentHeader);
    end;

    local procedure FormatDocumentFields(SalesShipmentHeader: Record "Sales Shipment Header")
    begin
        with SalesShipmentHeader do begin
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);
          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
        end;
    end;

    local procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
          exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;


    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('',2,' '));
    end;
}

