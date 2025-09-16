#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 6646 "Sales - Return Receipt"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales - Return Receipt.rdlc';
    Caption = 'Sales - Return Receipt';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Return Receipt Header";"Return Receipt Header")
        {
            DataItemTableView = sorting("No.");
            RequestFilterFields = "No.","Sell-to Customer No.","No. Printed";
            RequestFilterHeading = 'Posted Return Receipt';
            column(ReportForNavId_9963; 9963)
            {
            }
            column(No_ReturnRcptHeader;"No.")
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
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(SalesReturnRcptCopyText;StrSubstNo(Text002,CopyText))
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
                    column(CompanyInfoVATRegNo;CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoHomePage;CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail;CompanyInfo."E-Mail")
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
                    column(SellCustNo_ReturnRcptHdr;"Return Receipt Header"."Sell-to Customer No.")
                    {
                    }
                    column(SellCustNo_ReturnRcptHdrCaption;"Return Receipt Header".FieldCaption("Sell-to Customer No."))
                    {
                    }
                    column(DocDate_ReturnRcptHeader;Format("Return Receipt Header"."Document Date",0,4))
                    {
                    }
                    column(SalesPersonText;SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(No1_ReturnRcptHeader;"Return Receipt Header"."No.")
                    {
                    }
                    column(ReferenceText;ReferenceText)
                    {
                    }
                    column(YourRef_ReturnRcptHeader;"Return Receipt Header"."Your Reference")
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
                    column(ShptDt_ReturnRcptHeader;Format("Return Receipt Header"."Shipment Date"))
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PageCaption;StrSubstNo(Text003,''))
                    {
                    }
                    column(CompanyInfoPhoneNoCaption;CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCptn;CompanyInfoVATRegNoCptnLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption;CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCptn;CompanyInfoBankNameCptnLbl)
                    {
                    }
                    column(CompanyInfoBankAccNoCptn;CompanyInfoBankAccNoCptnLbl)
                    {
                    }
                    column(ReturnReceiptHeaderNoCptn;ReturnReceiptHeaderNoCptnLbl)
                    {
                    }
                    column(ReturnRcptHdrShptDtCptn;ReturnRcptHdrShptDtCptnLbl)
                    {
                    }
                    column(DocumentDateCaption;DocumentDateCaptionLbl)
                    {
                    }
                    column(HomePageCaption;HomePageCaptionLbl)
                    {
                    }
                    column(EmailCaption;EmailCaptionLbl)
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemLinkReference = "Return Receipt Header";
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimensionLoop1Number;Number)
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
                    dataitem("Return Receipt Line";"Return Receipt Line")
                    {
                        DataItemLink = "Document No."=field("No.");
                        DataItemLinkReference = "Return Receipt Header";
                        DataItemTableView = sorting("Document No.","Line No.");
                        column(ReportForNavId_5391; 5391)
                        {
                        }
                        column(ShowInternalInfo;ShowInternalInfo)
                        {
                        }
                        column(TypeInt;TypeInt)
                        {
                        }
                        column(Desc_ReturnReceiptLine;Description)
                        {
                        }
                        column(UOM_ReturnReceiptLine;"Unit of Measure")
                        {
                        }
                        column(Qty_ReturnReceiptLine;Quantity)
                        {
                        }
                        column(No_ReturnReceiptLine;"No.")
                        {
                        }
                        column(UOM_ReturnReceiptLineCaption;FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Qty_ReturnReceiptLineCaption;FieldCaption(Quantity))
                        {
                        }
                        column(Desc_ReturnReceiptLineCaption;FieldCaption(Description))
                        {
                        }
                        column(No_ReturnReceiptLineCaption;FieldCaption("No."))
                        {
                        }
                        column(LineNo_ReturnReceiptLine;"Line No.")
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
                            column(DimensionLoop2Number;Number)
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
                    }
                    dataitem(Total2;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(BilltoCustNo_ReturnRcptHdr;"Return Receipt Header"."Bill-to Customer No.")
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

                        trigger OnPreDataItem()
                        begin
                            if not ShowCustAddr then
                              CurrReport.Break;
                        end;
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
                      Codeunit.Run(Codeunit::"Return Receipt - Printed","Return Receipt Header");
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
            var
                Language: Record Language;
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Return Receipt Header");
                FormatDocumentFields("Return Receipt Header");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      20,"No.",0,0,Database::Customer,"Bill-to Customer No.","Salesperson Code",
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
    end;

    var
        Text002: label 'Sales - Return Receipt %1', Comment='%1 = Document No.';
        Text003: label 'Page %1';
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        SalesSetup: Record "Sales & Receivables Setup";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SegManagement: Codeunit SegManagement;
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        SalesPersonText: Text[20];
        ReferenceText: Text[80];
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[75];
        MoreLines: Boolean;
        ShowCustAddr: Boolean;
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        ShowCorrectionLines: Boolean;
        LogInteraction: Boolean;
        OutputNo: Integer;
        TypeInt: Integer;
        [InDataSet]
        LogInteractionEnable: Boolean;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoVATRegNoCptnLbl: label 'Tax Reg. No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCptnLbl: label 'Bank';
        CompanyInfoBankAccNoCptnLbl: label 'Account No.';
        ReturnReceiptHeaderNoCptnLbl: label 'Receipt No.';
        ReturnRcptHdrShptDtCptnLbl: label 'Shipment Date';
        DocumentDateCaptionLbl: label 'Document Date';
        HomePageCaptionLbl: label 'Home Page';
        EmailCaptionLbl: label 'Email';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        BilltoAddressCaptionLbl: label 'Address';


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(20) <> '';
    end;

    local procedure FormatAddressFields(ReturnReceiptHeader: Record "Return Receipt Header")
    begin
        FormatAddr.GetCompanyAddr(ReturnReceiptHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.SalesRcptShipTo(ShipToAddr,ReturnReceiptHeader);
        ShowCustAddr := FormatAddr.SalesRcptBillTo(CustAddr,ShipToAddr,ReturnReceiptHeader);
    end;

    local procedure FormatDocumentFields(ReturnReceiptHeader: Record "Return Receipt Header")
    begin
        with ReturnReceiptHeader do begin
          FormatDocument.SetSalesPerson(SalesPurchPerson,"Salesperson Code",SalesPersonText);

          ReferenceText := FormatDocument.SetText("Your Reference" <> '',FieldCaption("Your Reference"));
        end;
    end;
}

