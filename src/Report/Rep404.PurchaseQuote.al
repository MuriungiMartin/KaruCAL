#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 404 "Purchase - Quote"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase - Quote.rdlc';
    Caption = 'Purchase - Quote';
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Quote));
            RequestFilterFields = "No.","Buy-from Vendor No.","No. Printed";
            RequestFilterHeading = 'Purchase Quote';
            column(ReportForNavId_4458; 4458)
            {
            }
            column(DocType_PurchaseHeader;"Document Type")
            {
            }
            column(No_PurchaseHeader;"No.")
            {
            }
            column(PurchaseLineNoCaption;PurchaseLineNoCaptionLbl)
            {
            }
            column(PurchaseLineVendorItemNoCaption;PurchaseLineVendorItemNoCaptionLbl)
            {
            }
            column(ShipmentMethodDescriptionCaption;ShipmentMethodDescriptionCaptionLbl)
            {
            }
            column(CompanyInfoHomePageCaption;CompanyInfoHomePageCaptionLbl)
            {
            }
            column(CompanyInfoEmailCaption;CompanyInfoEmailCaptionLbl)
            {
            }
            column(DocumentDateCaption;DocumentDateCaptionLbl)
            {
            }
            column(PurchaseLineDescriptionCaption;PurchaseLineDescriptionCaptionLbl)
            {
            }
            column(PurchaseLineQuantityCaption;PurchaseLineQuantityCaptionLbl)
            {
            }
            column(PurchaseLineUnitOfMeasureCaption;PurchaseLineUnitOfMeasureCaptionLbl)
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
                    column(PurchaseQuoteCopyText;StrSubstNo(Text002,CopyText))
                    {
                    }
                    column(VendAddr1;VendAddr[1])
                    {
                    }
                    column(CompanyAddr1;CompanyAddr[1])
                    {
                    }
                    column(VendAddr2;VendAddr[2])
                    {
                    }
                    column(CompanyAddr2;CompanyAddr[2])
                    {
                    }
                    column(VendAddr3;VendAddr[3])
                    {
                    }
                    column(CompanyAddr3;CompanyAddr[3])
                    {
                    }
                    column(VendAddr4;VendAddr[4])
                    {
                    }
                    column(CompanyAddr4;CompanyAddr[4])
                    {
                    }
                    column(VendAddr5;VendAddr[5])
                    {
                    }
                    column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail;CompanyInfo."E-Mail")
                    {
                    }
                    column(VendAddr6;VendAddr[6])
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
                    column(CompanyInfoBankAccNo;CompanyInfo."Bank Account No.")
                    {
                    }
                    column(PayToVendNo_PurchaseHeader;"Purchase Header"."Pay-to Vendor No.")
                    {
                    }
                    column(ShipmentMethodComment;ShipmentMethod.Description)
                    {
                    }
                    column(BuyFromVendNo_PurchaseHeader;"Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(DocDate_PurchaseHeader;Format("Purchase Header"."Document Date",0,4))
                    {
                    }
                    column(VATNoText;VATNoText)
                    {
                    }
                    column(VATRegNo_PurchaseHeader;"Purchase Header"."VAT Registration No.")
                    {
                    }
                    column(ExpectedRcptDate_PurchaseHeader;Format("Purchase Header"."Expected Receipt Date"))
                    {
                    }
                    column(PurchaserText;PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchaseHeader;"Purchase Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourReference_PurchaseHeader;"Purchase Header"."Your Reference")
                    {
                    }
                    column(VendAddr7;VendAddr[7])
                    {
                    }
                    column(VendAddr8;VendAddr[8])
                    {
                    }
                    column(CompanyAddr5;CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6;CompanyAddr[6])
                    {
                    }
                    column(OutpuNo;OutputNo)
                    {
                    }
                    column(TaxIdentType;Format(Vend."Tax Identification Type"))
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegistrationNoCaption;CompanyInfoVATRegistrationNoCaptionLbl)
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
                    column(ExpectedDateCaption;ExpectedDateCaptionLbl)
                    {
                    }
                    column(QuoteNoCaption;QuoteNoCaptionLbl)
                    {
                    }
                    column(VendTaxIdentificationTypeCaption;VendTaxIdentificationTypeCaptionLbl)
                    {
                    }
                    column(PayToVendNo_PurchaseHeaderCaption;"Purchase Header".FieldCaption("Pay-to Vendor No."))
                    {
                    }
                    column(BuyFromVendNo_PurchaseHeaderCaption;"Purchase Header".FieldCaption("Buy-from Vendor No."))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimLoopNo1;Number)
                        {
                        }
                        column(HeaderDimensionsCaption;HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                              if not DimSetEntry1.Find('-') then
                                CurrReport.Break;
                            end else
                              if not Continue then
                                CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                              OldDimText := DimText;
                              if DimText = '' then
                                DimText := StrSubstNo(
                                    '%1 - %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
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
                            until (DimSetEntry1.Next = 0);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Purchase Line";"Purchase Line")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.");
                        column(ReportForNavId_6547; 6547)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(RoundLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_7551; 7551)
                        {
                        }
                        column(ShowInternalInfo;ShowInternalInfo)
                        {
                        }
                        column(LogInteraction;LogInteraction)
                        {
                        }
                        column(Type_PurchaseLine;Format("Purchase Line".Type,0,2))
                        {
                        }
                        column(Comment_PurchaseLine;"Purchase Line".Description)
                        {
                        }
                        column(Qty_PurchaseLine;"Purchase Line".Quantity)
                        {
                        }
                        column(UOM_PurchaseLine;"Purchase Line"."Unit of Measure")
                        {
                        }
                        column(ExpectedRcptDate_PurchaseLine;Format("Purchase Line"."Expected Receipt Date"))
                        {
                        }
                        column(No_PurchaseLine;"Purchase Line"."No.")
                        {
                        }
                        column(VendItemNo_PurchaseLine;"Purchase Line"."Vendor Item No.")
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimTextLine;DimText)
                            {
                            }
                            column(DimLoopNo2;Number)
                            {
                            }
                            column(LineDimensionsCaption;LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                  if not DimSetEntry2.Find('-') then
                                    CurrReport.Break;
                                end else
                                  if not Continue then
                                    CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                  OldDimText := DimText;
                                  if DimText = '' then
                                    DimText := StrSubstNo(
                                        '%1 - %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
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
                                until (DimSetEntry2.Next = 0);
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                  CurrReport.Break;
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              PurchLine.Find('-')
                            else
                              PurchLine.Next;
                            "Purchase Line" := PurchLine;

                            DimSetEntry2.SetRange("Dimension Set ID","Purchase Line"."Dimension Set ID");
                        end;

                        trigger OnPostDataItem()
                        begin
                            PurchLine.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := PurchLine.Find('+');
                            while MoreLines and (PurchLine.Description = '') and (PurchLine."Description 2" = '') and
                                  (PurchLine."No." = '') and (PurchLine.Quantity = 0) and
                                  (PurchLine.Amount = 0)
                            do
                              MoreLines := PurchLine.Next(-1) <> 0;
                            if not MoreLines then
                              CurrReport.Break;
                            PurchLine.SetRange("Line No.",0,PurchLine."Line No.");
                            SetRange(Number,1,PurchLine.Count);
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

                        trigger OnPreDataItem()
                        begin
                            if "Purchase Header"."Buy-from Vendor No." = "Purchase Header"."Pay-to Vendor No." then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(Total3;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_8272; 8272)
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
                        column(ShiptoAddressCaption;ShiptoAddressCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if ("Purchase Header"."Sell-to Customer No." = '') and (ShipToAddr[1] = '') then
                              CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    Clear(PurchLine);
                    Clear(PurchPost);
                    PurchLine.DeleteAll;
                    PurchPost.GetPurchLines("Purchase Header",PurchLine,0);

                    if Number > 1 then begin
                      CopyText := FormatDocument.GetCOPYText;
                      OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if not CurrReport.Preview then
                      Codeunit.Run(Codeunit::"Purch.Header-Printed","Purchase Header");
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
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Purchase Header");
                FormatDocumentFields("Purchase Header");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if not Vend.Get("Buy-from Vendor No.") then
                  Clear(Vend);

                if not CurrReport.Preview then begin
                  if ArchiveDocument then
                    ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);

                  if LogInteraction then begin
                    CalcFields("No. of Archived Versions");
                    SegManagement.LogDocument(
                      11,"No.","Doc. No. Occurrence","No. of Archived Versions",Database::Vendor,"Pay-to Vendor No.",
                      "Purchaser Code",'',"Posting Description",'');
                  end;
                end;
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
                    field(ArchiveDocument;ArchiveDocument)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archive Document';

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                              LogInteraction := false;
                        end;
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                              ArchiveDocument := ArchiveDocumentEnable;
                        end;
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
            ArchiveDocument := PurchSetup."Archive Quotes and Orders";
            LogInteraction := SegManagement.FindInteractTmplCode(11) <> '';

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        PurchSetup.Get;
    end;

    var
        Text002: label 'Purchase - Quote %1', Comment='%1 = Document No.';
        ShipmentMethod: Record "Shipment Method";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        PurchLine: Record "Purchase Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        PurchSetup: Record "Purchases & Payables Setup";
        Vend: Record Vendor;
        PurchPost: Codeunit "Purch.-Post";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        VendAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        PurchaserText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        OutputNo: Integer;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoVATRegistrationNoCaptionLbl: label 'Tax Registration No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: label 'Account No.';
        ExpectedDateCaptionLbl: label 'Expected Date';
        QuoteNoCaptionLbl: label 'Quote No.';
        VendTaxIdentificationTypeCaptionLbl: label 'Tax Identification Type';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        ShiptoAddressCaptionLbl: label 'Ship-to Address';
        PurchaseLineNoCaptionLbl: label 'Our No.';
        PurchaseLineVendorItemNoCaptionLbl: label 'No.';
        ShipmentMethodDescriptionCaptionLbl: label 'Shipment Method';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyInfoEmailCaptionLbl: label 'Email';
        DocumentDateCaptionLbl: label 'Document Date';
        PurchaseLineDescriptionCaptionLbl: label 'Description';
        PurchaseLineQuantityCaptionLbl: label 'Quantity';
        PurchaseLineUnitOfMeasureCaptionLbl: label 'Unit';


    procedure IntializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewArchiveDocument: Boolean;NewLogInteraction: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        ArchiveDocument := NewArchiveDocument;
        LogInteraction := NewLogInteraction;
    end;

    local procedure FormatAddressFields(PurchaseHeader: Record "Purchase Header")
    begin
        FormatAddr.GetCompanyAddr(PurchaseHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.PurchHeaderPayTo(VendAddr,PurchaseHeader);
        FormatAddr.PurchHeaderShipTo(ShipToAddr,PurchaseHeader);
    end;

    local procedure FormatDocumentFields(PurchaseHeader: Record "Purchase Header")
    begin
        with PurchaseHeader do begin
          FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);
          FormatDocument.SetShipmentMethod(ShipmentMethod,"Shipment Method Code","Language Code");
          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
          VATNoText := FormatDocument.SetText("VAT Registration No." <> '',FieldCaption("VAT Registration No."));
        end;
    end;
}

