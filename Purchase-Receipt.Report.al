#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 408 "Purchase - Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Purchase - Receipt.rdlc';
    Caption = 'Purchase - Receipt';
    PreviewMode = PrintLayout;
    UsageCategory = Documents;

    dataset
    {
        dataitem("Purch. Rcpt. Header";"Purch. Rcpt. Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Buy-from Vendor No.","No. Printed";
            RequestFilterHeading = 'Posted Purchase Receipt';
            column(ReportForNavId_2822; 2822)
            {
            }
            column(No_PurchRcptHeader;"No.")
            {
            }
            column(DocDateCaption;DocDateCaptionLbl)
            {
            }
            column(PageCaption;PageCaptionLbl)
            {
            }
            column(DescCaption;DescCaptionLbl)
            {
            }
            column(QtyCaption;QtyCaptionLbl)
            {
            }
            column(UOMCaption;UOMCaptionLbl)
            {
            }
            column(PaytoVenNoCaption;PaytoVenNoCaptionLbl)
            {
            }
            column(EmailCaption;EmailCaptionLbl)
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
                    column(PurchRcptCopyText;StrSubstNo(Text002,CopyText))
                    {
                    }
                    column(CurrentReportPageNo;StrSubstNo(Text003,Format(CurrReport.PageNo)))
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
                    column(DocDate_PurchRcptHeader;Format("Purch. Rcpt. Header"."Document Date",0,4))
                    {
                    }
                    column(PurchaserText;PurchaserText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No1_PurchRcptHeader;"Purch. Rcpt. Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourRef_PurchRcptHeader;"Purch. Rcpt. Header"."Your Reference")
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
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PhoneNoCaption;PhoneNoCaptionLbl)
                    {
                    }
                    column(HomePageCaption;HomePageCaptionLbl)
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
                    column(AccNoCaption;AccNoCaptionLbl)
                    {
                    }
                    column(ShipmentNoCaption;ShipmentNoCaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(HeaderDimCaption;HeaderDimCaptionLbl)
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
                    dataitem("Purch. Rcpt. Line";"Purch. Rcpt. Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Purch. Rcpt. Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_3042; 3042)
                        {
                        }
                        column(ShowInternalInfo;ShowInternalInfo)
                        {
                        }
                        column(Type_PurchRcptLine;Format(Type,0,2))
                        {
                        }
                        column(Desc_PurchRcptLine;Description)
                        {
                            IncludeCaption = false;
                        }
                        column(Qty_PurchRcptLine;Quantity)
                        {
                            IncludeCaption = false;
                        }
                        column(UOM_PurchRcptLine;"Unit of Measure")
                        {
                            IncludeCaption = false;
                        }
                        column(No_PurchRcptLine;"No.")
                        {
                        }
                        column(DocNo_PurchRcptLine;"Document No.")
                        {
                        }
                        column(LineNo_PurchRcptLine;"Line No.")
                        {
                            IncludeCaption = false;
                        }
                        column(No_PurchRcptLineCaption;FieldCaption("No."))
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
                            column(LineDimCaption;LineDimCaptionLbl)
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
                        column(BuyfromVenNo_PurchRcptHeader;"Purch. Rcpt. Header"."Buy-from Vendor No.")
                        {
                        }
                        column(BuyfromVenNo_PurchRcptHeaderCaption;"Purch. Rcpt. Header".FieldCaption("Buy-from Vendor No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if "Purch. Rcpt. Header"."Buy-from Vendor No." = "Purch. Rcpt. Header"."Pay-to Vendor No." then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(PaytoVenNo_PurchRcptHeader;"Purch. Rcpt. Header"."Pay-to Vendor No.")
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
                        column(PaytoAddrCaption;PaytoAddrCaptionLbl)
                        {
                        }
                        column(PaytoVenNo_PurchRcptHeaderCaption;"Purch. Rcpt. Header".FieldCaption("Pay-to Vendor No."))
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
                      Codeunit.Run(Codeunit::"Purch.Rcpt.-Printed","Purch. Rcpt. Header");
                end;

                trigger OnPreDataItem()
                begin
                    OutputNo := 1;

                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Purch. Rcpt. Header");
                FormatDocumentFields("Purch. Rcpt. Header");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      15,"No.",0,0,Database::Vendor,"Buy-from Vendor No.","Purchaser Code",'',"Posting Description",'');
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
                    field(ShowCorrectionLines;ShowCorrectionLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Correction Lines';
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

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
    end;

    var
        Text002: label 'Purchase - Receipt %1', Comment='%1 = Document No.';
        Text003: label 'Page %1';
        CompanyInfo: Record "Company Information";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        Language: Record Language;
        RespCenter: Record "Responsibility Center";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        VendAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        PurchaserText: Text[30];
        ReferenceText: Text[80];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        LogInteraction: Boolean;
        ShowCorrectionLines: Boolean;
        OutputNo: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        PhoneNoCaptionLbl: label 'Phone No.';
        HomePageCaptionLbl: label 'Home Page';
        VATRegNoCaptionLbl: label 'Tax Registration No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankNameCaptionLbl: label 'Bank';
        AccNoCaptionLbl: label 'Account No.';
        ShipmentNoCaptionLbl: label 'Shipment No.';
        HeaderDimCaptionLbl: label 'Header Dimensions';
        LineDimCaptionLbl: label 'Line Dimensions';
        PaytoAddrCaptionLbl: label 'Address';
        DocDateCaptionLbl: label 'Document Date';
        PageCaptionLbl: label 'Page';
        DescCaptionLbl: label 'Description';
        QtyCaptionLbl: label 'Quantity';
        UOMCaptionLbl: label 'Unit Of Measure';
        PaytoVenNoCaptionLbl: label 'Vendor No.';
        EmailCaptionLbl: label 'Email';


    procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean;NewShowCorrectionLines: Boolean)
    begin
        NoOfCopies := NewNoOfCopies;
        ShowInternalInfo := NewShowInternalInfo;
        LogInteraction := NewLogInteraction;
        ShowCorrectionLines := NewShowCorrectionLines;
    end;

    local procedure FormatAddressFields(var PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        FormatAddr.GetCompanyAddr(PurchRcptHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.PurchRcptShipTo(ShipToAddr,PurchRcptHeader);
        FormatAddr.PurchRcptPayTo(VendAddr,PurchRcptHeader);
    end;

    local procedure FormatDocumentFields(PurchRcptHeader: Record "Purch. Rcpt. Header")
    begin
        with PurchRcptHeader do begin
          FormatDocument.SetPurchaser(SalesPurchPerson,"Purchaser Code",PurchaserText);

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
        end;
    end;
}

