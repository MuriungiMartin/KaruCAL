#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6636 "Purchase - Return Shipment"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase - Return Shipment.rdlc';
    Caption = 'Purchase - Return Shipment';
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Return Shipment Header";"Return Shipment Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Buy-from Vendor No.","No. Printed";
            RequestFilterHeading = 'Posted Return Shipment';
            column(ReportForNavId_8295; 8295)
            {
            }
            column(No_ReturnShipmentHeader;"No.")
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
                    column(PurchReturnShpCaption;StrSubstNo(Text002,CopyText))
                    {
                    }
                    column(CompanyAddr1;CompanyAddr[1])
                    {
                    }
                    column(CompanyAddr2;CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr3;CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr4;CompanyAddr[4])
                    {
                    }
                    column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEMail;CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
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
                    column(DocDate_ReturnShpHeader;Format("Return Shipment Header"."Document Date",0,4))
                    {
                    }
                    column(PurchaserText;PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourReference_ReturnShpHdr;"Return Shipment Header"."Your Reference")
                    {
                    }
                    column(CompanyAddr5;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6;CompanyAddr[6])
                    {
                    }
                    column(BuyfromVendNo_ReturnShpHdr;"Return Shipment Header"."Buy-from Vendor No.")
                    {
                    }
                    column(BuyfromVendNo_ReturnShpHdrCaption;"Return Shipment Header".FieldCaption("Buy-from Vendor No."))
                    {
                    }
                    column(ShipToAddr1;ShipToAddr[1])
                    {
                    }
                    column(ShipToAddr2;ShipToAddr[2])
                    {
                    }
                    column(ShipToAddr3;ShipToAddr[3])
                    {
                    }
                    column(ShipToAddr4;ShipToAddr[4])
                    {
                    }
                    column(ShipToAddr5;ShipToAddr[5])
                    {
                    }
                    column(ShipToAddr6;ShipToAddr[6])
                    {
                    }
                    column(ShipToAddr7;ShipToAddr[7])
                    {
                    }
                    column(ShipToAddr8;ShipToAddr[8])
                    {
                    }
                    column(PageCaption;StrSubstNo(Text003,''))
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCaption;CompanyInfoVATRegNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption;CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption;CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccountNoCaption;CompanyInfoBankAccountNoCaptionLbl)
                    {
                    }
                    column(ReturnShipmentHeaderNoCaption;ReturnShipmentHeaderNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoHomePageCaption;CompanyInfoHomePageCaptionLbl)
                    {
                    }
                    column(CompanyEmailCaption;CompanyEmailCaptionLbl)
                    {
                    }
                    column(DocumentDataCaption;DocumentDataCaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Return Shipment Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(Number_Integer;Number)
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
                    dataitem("Return Shipment Line";"Return Shipment Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Return Shipment Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_8757; 8757)
                        {
                        }
                        column(TypeInt;TypeInt)
                        {
                        }
                        column(ShowInternalInfo;ShowInternalInfo)
                        {
                        }
                        column(Description_ReturnShpLine;Description)
                        {
                        }
                        column(UOM_ReturnShpLine;"Unit of Measure")
                        {
                        }
                        column(Qty_ReturnShipmentLine;Quantity)
                        {
                        }
                        column(No_ReturnShipmentLine;"No.")
                        {
                        }
                        column(LineNo_ReturnShipmentLine;"Line No.")
                        {
                        }
                        column(UOM_ReturnShpLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Qty_ReturnShipmentLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(Description_ReturnShpLineCaption;FieldCaption(Description))
                        {
                        }
                        column(No_ReturnShipmentLineCaption;FieldCaption("No."))
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_DimensionLoop2;DimText)
                            {
                            }
                            column(Number_DimensionLoop2;Number)
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

                        trigger OnAfterGetRecord()
                        begin
                            if (not ShowCorrectionLines) and Correction then
                              CurrReport.Skip;

                            DimSetEntry2.SetRange("Dimension Set ID","Dimension Set ID");
                            TypeInt := Type;
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

                        trigger OnAfterGetRecord()
                        begin
                            PayToVendorNo := "Return Shipment Header"."Pay-to Vendor No.";
                            BuyFromVendorNo := "Return Shipment Header"."Buy-from Vendor No.";
                            PayToCaption := "Return Shipment Header".FieldCaption("Pay-to Vendor No.");
                        end;

                        trigger OnPreDataItem()
                        begin
                            if "Return Shipment Header"."Buy-from Vendor No." = "Return Shipment Header"."Pay-to Vendor No." then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(VendAddr1;VendAddr[1])
                        {
                        }
                        column(VendAddr2;VendAddr[2])
                        {
                        }
                        column(VendAddr3;VendAddr[3])
                        {
                        }
                        column(VendAddr4;VendAddr[4])
                        {
                        }
                        column(VendAddr5;VendAddr[5])
                        {
                        }
                        column(VendAddr6;VendAddr[6])
                        {
                        }
                        column(VendAddr7;VendAddr[7])
                        {
                        }
                        column(VendAddr8;VendAddr[8])
                        {
                        }
                        column(PayToVendorNo;PayToVendorNo)
                        {
                        }
                        column(BuyFromVendorNo;BuyFromVendorNo)
                        {
                        }
                        column(PayToVendorNo_Total2;PayToCaption)
                        {
                        }
                        column(PaytoAddressCaption;PaytoAddressCaptionLbl)
                        {
                        }
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      Codeunit.Run(Codeunit::"Return Shipment - Printed","Return Shipment Header");
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                Language: Record Language;
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Return Shipment Header");
                FormatDocumentFields("Return Shipment Header");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      21,"No.",0,0,Database::Vendor,"Buy-from Vendor No.","Purchaser Code",'',"Posting Description",'');
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
                    field(ShowCorrectionLines;ShowCorrectionLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Correction Lines';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
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
            LogInteraction := SegManagement.FindInteractTmplCode(21) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
    end;

    var
        Text002: label 'Purchase - Return Shipment %1', Comment='%1 = Document No.';
        Text003: label 'Page %1';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        VendAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        PurchaserText: Text[30];
        ReferenceText: Text[80];
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        MoreLines: Boolean;
        ShowCorrectionLines: Boolean;
        LogInteraction: Boolean;
        OutputNo: Integer;
        TypeInt: Integer;
        PayToVendorNo: Code[20];
        BuyFromVendorNo: Code[20];
        PayToCaption: Text[30];
        [InDataSet]
        LogInteractionEnable: Boolean;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: label 'Tax Reg. No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: label 'Account No.';
        ReturnShipmentHeaderNoCaptionLbl: label 'Shipment No.';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyEmailCaptionLbl: label 'Email';
        DocumentDataCaptionLbl: label 'Document Date';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        PaytoAddressCaptionLbl: label 'Address';


    procedure InitializeRequest(NewNoOfCopies: Decimal;NewShowInternalInfo: Boolean;NewShowCorrectionLines: Boolean;NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ShowCorrectionLines := NewShowCorrectionLines;
        LogInteraction := NewLogInteraction;
    end;

    local procedure FormatAddressFields(var ReturnShipmentHeader: Record "Return Shipment Header")
    begin
        FormatAddr.GetCompanyAddr(ReturnShipmentHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.PurchShptBuyFrom(ShipToAddr,ReturnShipmentHeader);
        FormatAddr.PurchShptPayTo(VendAddr,ReturnShipmentHeader);
    end;

    local procedure FormatDocumentFields(ReturnShipmentHeader: Record "Return Shipment Header")
    begin
        with ReturnShipmentHeader do begin
          FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
        end;
    end;
}

