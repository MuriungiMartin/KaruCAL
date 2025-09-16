#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10126 "Return Order Confirm"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Return Order Confirm.rdlc';
    Caption = 'Return Order Confirm';

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const("Return Order"));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Buy-from Vendor No.","Pay-to Vendor No.","No. Printed";
            RequestFilterHeading = 'Return Order';
            column(ReportForNavId_4458; 4458)
            {
            }
            column(No_PurchHeader;"No.")
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
                    column(ExpRectDate_PurchHeader;"Purchase Header"."Expected Receipt Date")
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
                    column(BuyfromVendNo_PurchHeader;"Purchase Header"."Buy-from Vendor No.")
                    {
                    }
                    column(YourRef_PurchHeader;"Purchase Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(OrderDate_PurchHeader;"Purchase Header"."Order Date")
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
                    column(ShipmentMethodDesc;ShipmentMethod.Description)
                    {
                    }
                    column(PaymentTermsDesc;PaymentTerms.Description)
                    {
                    }
                    column(CompanyInfoPhoneNo;CompanyInformation."Phone No.")
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(ToCaption;ToCaptionLbl)
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
                    column(ReturnOrderConfirmationCaption;ReturnOrderConfirmationCaptionLbl)
                    {
                    }
                    column(ReturnOrderNumberCaption;ReturnOrderNumberCaptionLbl)
                    {
                    }
                    column(ReturnOrderDateCaption;ReturnOrderDateCaptionLbl)
                    {
                    }
                    column(PageCaption;PageCaptionLbl)
                    {
                    }
                    column(ShipViaCaption;ShipViaCaptionLbl)
                    {
                    }
                    column(TermsCaption;TermsCaptionLbl)
                    {
                    }
                    column(PhoneNoCaption;PhoneNoCaptionLbl)
                    {
                    }
                    column(FOBCaption;FOBCaptionLbl)
                    {
                    }
                    dataitem("Purchase Line";"Purchase Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Purchase Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.") where("Document Type"=const("Return Order"));
                        column(ReportForNavId_6547; 6547)
                        {
                        }
                        column(ItemNoTo_PrintPurchLine;ItemNumberToPrint)
                        {
                        }
                        column(umo_PrintPurchLine;"Unit of Measure")
                        {
                        }
                        column(Qty_PrintPurchLine;Quantity)
                        {
                        }
                        column(Desc_PrintPurchLine;Description)
                        {
                        }
                        column(PrintFooter_PrintPurchLine;PrintFooter)
                        {
                        }
                        column(DocNo_PrintPurchLine;"Document No.")
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
                        column(QuantityCaption;QuantityCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;

                            if "Vendor Item No." <> '' then
                              ItemNumberToPrint := "Vendor Item No."
                            else
                              ItemNumberToPrint := "No.";

                            if Type = 0 then begin
                              ItemNumberToPrint := '';
                              "Unit of Measure" := '';
                              "Line Amount" := 0;
                              "Inv. Discount Amount" := 0;
                              Quantity := 0;
                            end;

                            if OnLineNumber = NumberOfLines then
                              PrintFooter := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            NumberOfLines := Count;
                            OnLineNumber := 0;
                            PrintFooter := false;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;
                    if CopyNo = NoLoops then begin
                      if not CurrReport.Preview then
                        PurchasePrinted.Run("Purchase Header");
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

                if "Payment Terms Code" = '' then
                  Clear(PaymentTerms)
                else
                  PaymentTerms.Get("Payment Terms Code");

                if "Shipment Method Code" = '' then
                  Clear(ShipmentMethod)
                else
                  ShipmentMethod.Get("Shipment Method Code");

                FormatAddress.PurchHeaderBuyFrom(BuyFromAddress,"Purchase Header");
                FormatAddress.PurchHeaderShipTo(ShipToAddress,"Purchase Header");

                if not CurrReport.Preview then begin
                  if ArchiveDocument then
                    ArchiveManagement.StorePurchDocument("Purchase Header",LogInteraction);

                  if LogInteraction then begin
                    CalcFields("No. of Archived Versions");
                    SegManagement.LogDocument(
                      22,"No.","Doc. No. Occurrence","No. of Archived Versions",Database::Vendor,"Buy-from Vendor No.",
                      "Purchaser Code","Campaign No.","Posting Description",'');
                  end;
                end;
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
                        ApplicationArea = Basic;
                        Caption = 'Number of Copies';
                    }
                    field(PrintCompanyAddress;PrintCompany)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Company Address';
                    }
                    field(ArchiveDocument;ArchiveDocument)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archive Document';
                        Enabled = ArchiveDocumentEnable;

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
            ArchiveDocumentEnable := true;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := ArchiveManagement.PurchaseDocArchiveGranule;
            LogInteraction := SegManagement.FindInteractTmplCode(13) <> '';

            ArchiveDocumentEnable := ArchiveDocument;
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
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        CompanyAddress: array [8] of Text[50];
        BuyFromAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        ItemNumberToPrint: Text[20];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        PurchasePrinted: Codeunit "Purch.Header-Printed";
        FormatAddress: Codeunit "Format Address";
        ArchiveManagement: Codeunit ArchiveManagement;
        SegManagement: Codeunit SegManagement;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        Text000: label 'COPY';
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        ToCaptionLbl: label 'To:';
        ReceiveByCaptionLbl: label 'Receive By';
        VendorIDCaptionLbl: label 'Vendor ID';
        ConfirmToCaptionLbl: label 'Confirm To';
        BuyerCaptionLbl: label 'Buyer';
        ShipCaptionLbl: label 'Ship';
        ReturnOrderConfirmationCaptionLbl: label 'Return Order Confirmation';
        ReturnOrderNumberCaptionLbl: label 'Return Order Number:';
        ReturnOrderDateCaptionLbl: label 'Return Order Date:';
        PageCaptionLbl: label 'Page:';
        ShipViaCaptionLbl: label 'Ship Via';
        TermsCaptionLbl: label 'Terms';
        PhoneNoCaptionLbl: label 'Phone No.';
        FOBCaptionLbl: label 'FOB';
        ItemNoCaptionLbl: label 'Item No.';
        UnitCaptionLbl: label 'Unit';
        DescriptionCaptionLbl: label 'Description';
        QuantityCaptionLbl: label 'Quantity';
}

