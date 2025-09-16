#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10073 "Sales Credit Memo"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Credit Memo.rdlc';
    Caption = 'Sales Credit Memo';

    dataset
    {
        dataitem("Sales Cr.Memo Header";"Sales Cr.Memo Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Sell-to Customer No.","Bill-to Customer No.","Ship-to Code","No. Printed";
            RequestFilterHeading = 'Sales Credit Memo';
            column(ReportForNavId_8098; 8098)
            {
            }
            column(No_SalesCrMemoHeader;"No.")
            {
            }
            dataitem("Sales Cr.Memo Line";"Sales Cr.Memo Line")
            {
                DataItemLink = "Document No."=field("No.");
                DataItemTableView = sorting("Document No.","Line No.");
                column(ReportForNavId_3364; 3364)
                {
                }
                dataitem(SalesLineComments;"Sales Comment Line")
                {
                    DataItemLink = "No."=field("Document No."),"Document Line No."=field("Line No.");
                    DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const("Posted Credit Memo"),"Print On Credit Memo"=const(Yes));
                    column(ReportForNavId_7380; 7380)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InsertTempLine(Comment,10);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    TempSalesCrMemoLine := "Sales Cr.Memo Line";
                    TempSalesCrMemoLine.Insert;
                    HighestLineNo := "Line No.";
                end;

                trigger OnPreDataItem()
                begin
                    TempSalesCrMemoLine.Reset;
                    TempSalesCrMemoLine.DeleteAll;
                end;
            }
            dataitem("Sales Comment Line";"Sales Comment Line")
            {
                DataItemLink = "No."=field("No.");
                DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const("Posted Credit Memo"),"Print On Credit Memo"=const(Yes),"Document Line No."=const(0));
                column(ReportForNavId_8541; 8541)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    InsertTempLine(Comment,1000);
                end;

                trigger OnPreDataItem()
                begin
                    with TempSalesCrMemoLine do begin
                      Init;
                      "Document No." := "Sales Cr.Memo Header"."No.";
                      "Line No." := HighestLineNo + 1000;
                      HighestLineNo := "Line No.";
                    end;
                    TempSalesCrMemoLine.Insert;
                end;
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
                    column(CompanyInfo3Picture;CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo2Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo1Picture;CompanyInfo1.Picture)
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
                    column(BillToAddress1;BillToAddress[1])
                    {
                    }
                    column(BillToAddress2;BillToAddress[2])
                    {
                    }
                    column(BillToAddress3;BillToAddress[3])
                    {
                    }
                    column(BillToAddress4;BillToAddress[4])
                    {
                    }
                    column(BillToAddress5;BillToAddress[5])
                    {
                    }
                    column(BillToAddress6;BillToAddress[6])
                    {
                    }
                    column(BillToAddress7;BillToAddress[7])
                    {
                    }
                    column(ShptDate_SalesCrMemoHeader;"Sales Cr.Memo Header"."Shipment Date")
                    {
                    }
                    column(ApplDocType_SalesCrMemoHeader;"Sales Cr.Memo Header"."Applies-to Doc. Type")
                    {
                    }
                    column(ApplDocNo_SalesCrMemoHeader;"Sales Cr.Memo Header"."Applies-to Doc. No.")
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
                    column(BilltoCustNo_SalesCrMemoHeader;"Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(ExtDocNo_SalesCrMemoHeader;"Sales Cr.Memo Header"."External Document No.")
                    {
                    }
                    column(SalesPurchPersonName;SalesPurchPerson.Name)
                    {
                    }
                    column(DocDate_SalesCrMemoHeader;"Sales Cr.Memo Header"."Document Date")
                    {
                    }
                    column(CompanyAddress7;CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress8;CompanyAddress[8])
                    {
                    }
                    column(BillToAddress8;BillToAddress[8])
                    {
                    }
                    column(ShipToAddress8;ShipToAddress[8])
                    {
                    }
                    column(TaxRegLabel;TaxRegLabel)
                    {
                    }
                    column(TaxRegNo;TaxRegNo)
                    {
                    }
                    column(PrintFooter;PrintFooter)
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(TaxIdentType_Cust;Format(Cust."Tax Identification Type"))
                    {
                    }
                    column(CreditCaption;CreditCaptionLbl)
                    {
                    }
                    column(ShipDateCaption;ShipDateCaptionLbl)
                    {
                    }
                    column(ApplytoTypeCaption;ApplytoTypeCaptionLbl)
                    {
                    }
                    column(ApplytoNumberCaption;ApplytoNumberCaptionLbl)
                    {
                    }
                    column(CustomerIDCaption;CustomerIDCaptionLbl)
                    {
                    }
                    column(PONumberCaption;PONumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption;SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption;ShipCaptionLbl)
                    {
                    }
                    column(CreditMemoCaption;CreditMemoCaptionLbl)
                    {
                    }
                    column(CreditMemoNumberCaption;CreditMemoNumberCaptionLbl)
                    {
                    }
                    column(CreditMemoDateCaption;CreditMemoDateCaptionLbl)
                    {
                    }
                    column(PageCaption;PageCaptionLbl)
                    {
                    }
                    column(TaxIdentTypeCaption;TaxIdentTypeCaptionLbl)
                    {
                    }
                    column(ToCaption;ToCaptionLbl)
                    {
                    }
                    dataitem(SalesCrMemoLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_3082; 3082)
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLineNo;TempSalesCrMemoLine."No.")
                        {
                        }
                        column(TempSalesCrMemoLineUOM;TempSalesCrMemoLine."Unit of Measure")
                        {
                        }
                        column(TempSalesCrMemoLineQty;TempSalesCrMemoLine.Quantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(TempSalesCrMemoLineDesc;TempSalesCrMemoLine.Description + ' ' + TempSalesCrMemoLine."Description 2")
                        {
                        }
                        column(TaxLiable;TaxLiable)
                        {
                        }
                        column(TempSalesCrMemoLineAmtTaxLiable;TempSalesCrMemoLine.Amount - TaxLiable)
                        {
                        }
                        column(TempSalesCrMemoLineAmtAmtExclInvDisc;TempSalesCrMemoLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLineAmtInclVATAmt;TempSalesCrMemoLine."Amount Including VAT" - TempSalesCrMemoLine.Amount)
                        {
                        }
                        column(TempSalesCrMemoLineAmtInclVAT;TempSalesCrMemoLine."Amount Including VAT")
                        {
                        }
                        column(BreakdownTitle;BreakdownTitle)
                        {
                        }
                        column(BreakdownLabel1;BreakdownLabel[1])
                        {
                        }
                        column(BreakdownLabel2;BreakdownLabel[2])
                        {
                        }
                        column(BreakdownAmt1;BreakdownAmt[1])
                        {
                        }
                        column(BreakdownAmt2;BreakdownAmt[2])
                        {
                        }
                        column(BreakdownAmt3;BreakdownAmt[3])
                        {
                        }
                        column(BreakdownLabel3;BreakdownLabel[3])
                        {
                        }
                        column(BreakdownAmt4;BreakdownAmt[4])
                        {
                        }
                        column(BreakdownLabel4;BreakdownLabel[4])
                        {
                        }
                        column(TotalTaxLabel;TotalTaxLabel)
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
                        column(UnitPriceCaption;UnitPriceCaptionLbl)
                        {
                        }
                        column(TotalPriceCaption;TotalPriceCaptionLbl)
                        {
                        }
                        column(SubtotalCaption;SubtotalCaptionLbl)
                        {
                        }
                        column(InvoiceDiscountCaption;InvoiceDiscountCaptionLbl)
                        {
                        }
                        column(TotalCaption;TotalCaptionLbl)
                        {
                        }
                        column(AmountSubjecttoSalesTaxCaption;AmountSubjecttoSalesTaxCaptionLbl)
                        {
                        }
                        column(AmountExemptfromSalesTaxCaption;AmountExemptfromSalesTaxCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            OnLineNumber := OnLineNumber + 1;
                            with TempSalesCrMemoLine do begin
                              if OnLineNumber = 1 then
                                Find('-')
                              else
                                Next;

                              if Type = 0 then begin
                                "No." := '';
                                "Unit of Measure" := '';
                                Amount := 0;
                                "Amount Including VAT" := 0;
                                "Inv. Discount Amount" := 0;
                                Quantity := 0;
                              end else
                                if Type = Type::"G/L Account" then
                                  "No." := '';

                              if Amount <> "Amount Including VAT" then
                                TaxLiable := Amount
                              else
                                TaxLiable := 0;

                              AmountExclInvDisc := Amount + "Inv. Discount Amount";

                              if Quantity = 0 then
                                UnitPriceToPrint := 0 // so it won't print
                              else
                                UnitPriceToPrint := ROUND(AmountExclInvDisc / Quantity,0.00001);
                            end;

                            if OnLineNumber = NumberOfLines then
                              PrintFooter := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(TaxLiable,AmountExclInvDisc,TempSalesCrMemoLine.Amount,TempSalesCrMemoLine."Amount Including VAT");
                            NumberOfLines := TempSalesCrMemoLine.Count;
                            SetRange(Number,1,NumberOfLines);
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
                        SalesCrMemoPrinted.Run("Sales Cr.Memo Header");
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
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if PrintCompany then
                  if RespCenter.Get("Responsibility Center") then begin
                    FormatAddress.RespCenter(CompanyAddress,RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                  end;

                if "Salesperson Code" = '' then
                  Clear(SalesPurchPerson)
                else
                  SalesPurchPerson.Get("Salesperson Code");

                if "Bill-to Customer No." = '' then begin
                  "Bill-to Name" := Text009;
                  "Ship-to Name" := Text009;
                end;

                FormatAddress.SalesCrMemoBillTo(BillToAddress,"Sales Cr.Memo Header");
                FormatAddress.SalesCrMemoShipTo(ShipToAddress,ShipToAddress,"Sales Cr.Memo Header");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      6,"No.",0,0,Database::Customer,"Sell-to Customer No.","Salesperson Code",
                      "Campaign No.","Posting Description",'');

                Clear(BreakdownTitle);
                Clear(BreakdownLabel);
                Clear(BreakdownAmt);
                TotalTaxLabel := Text008;
                TaxRegNo := '';
                TaxRegLabel := '';
                if "Tax Area Code" <> '' then begin
                  TaxArea.Get("Tax Area Code");
                  case TaxArea."Country/Region" of
                    TaxArea."country/region"::US:
                      TotalTaxLabel := Text005;
                    TaxArea."country/region"::CA:
                      begin
                        TotalTaxLabel := Text007;
                        TaxRegNo := CompanyInfo."VAT Registration No.";
                        TaxRegLabel := CompanyInfo.FieldCaption("VAT Registration No.");
                      end;
                  end;
                  SalesTaxCalc.StartSalesTaxCalculation;
                  if TaxArea."Use External Tax Engine" then
                    SalesTaxCalc.CallExternalTaxEngineForDoc(Database::"Sales Cr.Memo Header",0,"No.")
                  else begin
                    SalesTaxCalc.AddSalesCrMemoLines("No.");
                    SalesTaxCalc.EndSalesTaxCalculation("Posting Date");
                  end;
                  SalesTaxCalc.GetSummarizedSalesTaxTable(TempSalesTaxAmtLine);
                  BrkIdx := 0;
                  PrevPrintOrder := 0;
                  PrevTaxPercent := 0;
                  with TempSalesTaxAmtLine do begin
                    Reset;
                    SetCurrentkey("Print Order","Tax Area Code for Key","Tax Jurisdiction Code");
                    if Find('-') then
                      repeat
                        if ("Print Order" = 0) or
                           ("Print Order" <> PrevPrintOrder) or
                           ("Tax %" <> PrevTaxPercent)
                        then begin
                          BrkIdx := BrkIdx + 1;
                          if BrkIdx > 1 then begin
                            if TaxArea."Country/Region" = TaxArea."country/region"::CA then
                              BreakdownTitle := Text006
                            else
                              BreakdownTitle := Text003;
                          end;
                          if BrkIdx > ArrayLen(BreakdownAmt) then begin
                            BrkIdx := BrkIdx - 1;
                            BreakdownLabel[BrkIdx] := Text004;
                          end else
                            BreakdownLabel[BrkIdx] := StrSubstNo("Print Description","Tax %");
                        end;
                        BreakdownAmt[BrkIdx] := BreakdownAmt[BrkIdx] + "Tax Amount";
                      until Next = 0;
                  end;
                  if BrkIdx = 1 then begin
                    Clear(BreakdownLabel);
                    Clear(BreakdownAmt);
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
                    field(NoCopies;NoCopies)
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
            LogInteraction := SegManagement.FindInteractTmplCode(6) <> '';
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get;
        SalesSetup.Get;
        FormatDocument.SetLogoPosition(SalesSetup."Logo Position on Documents",CompanyInfo1,CompanyInfo2,CompanyInfo3);

        if PrintCompany then
          FormatAddress.Company(CompanyAddress,CompanyInfo)
        else
          Clear(CompanyAddress);
    end;

    var
        TaxLiable: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TempSalesTaxAmtLine: Record UnknownRecord10011 temporary;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        SalesCrMemoPrinted: Codeunit "Sales Cr. Memo-Printed";
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        SalesTaxCalc: Codeunit "Sales Tax Calculate";
        SegManagement: Codeunit SegManagement;
        CompanyAddress: array [8] of Text[50];
        BillToAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        PrintCompany: Boolean;
        PrintFooter: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        LogInteraction: Boolean;
        Text000: label 'COPY';
        TaxRegNo: Text[30];
        TaxRegLabel: Text[30];
        TotalTaxLabel: Text[30];
        BreakdownTitle: Text[30];
        BreakdownLabel: array [4] of Text[30];
        BreakdownAmt: array [4] of Decimal;
        BrkIdx: Integer;
        PrevPrintOrder: Integer;
        PrevTaxPercent: Decimal;
        Text003: label 'Sales Tax Breakdown:';
        Text004: label 'Other Taxes';
        Text005: label 'Total Sales Tax:';
        Text006: label 'Tax Breakdown:';
        Text007: label 'Total Tax:';
        Text008: label 'Tax:';
        Text009: label 'VOID CREDIT MEMO';
        [InDataSet]
        LogInteractionEnable: Boolean;
        CreditCaptionLbl: label 'Credit';
        ShipDateCaptionLbl: label 'Ship Date';
        ApplytoTypeCaptionLbl: label 'Apply to Type';
        ApplytoNumberCaptionLbl: label 'Apply to Number';
        CustomerIDCaptionLbl: label 'Customer ID';
        PONumberCaptionLbl: label 'P.O. Number';
        SalesPersonCaptionLbl: label 'SalesPerson';
        ShipCaptionLbl: label 'Ship';
        CreditMemoCaptionLbl: label 'CREDIT MEMO';
        CreditMemoNumberCaptionLbl: label 'Credit Memo Number:';
        CreditMemoDateCaptionLbl: label 'Credit Memo Date:';
        PageCaptionLbl: label 'Page:';
        TaxIdentTypeCaptionLbl: label 'Tax Ident. Type';
        ToCaptionLbl: label 'To:';
        ItemNoCaptionLbl: label 'Item No.';
        UnitCaptionLbl: label 'Unit';
        DescriptionCaptionLbl: label 'Description';
        QuantityCaptionLbl: label 'Quantity';
        UnitPriceCaptionLbl: label 'Unit Price';
        TotalPriceCaptionLbl: label 'Total Price';
        SubtotalCaptionLbl: label 'Subtotal:';
        InvoiceDiscountCaptionLbl: label 'Invoice Discount:';
        TotalCaptionLbl: label 'Total:';
        AmountSubjecttoSalesTaxCaptionLbl: label 'Amount Subject to Sales Tax';
        AmountExemptfromSalesTaxCaptionLbl: label 'Amount Exempt from Sales Tax';

    local procedure InsertTempLine(Comment: Text[80];IncrNo: Integer)
    begin
        with TempSalesCrMemoLine do begin
          Init;
          "Document No." := "Sales Cr.Memo Header"."No.";
          "Line No." := HighestLineNo + IncrNo;
          HighestLineNo := "Line No.";
        end;
        if StrLen(Comment) <= MaxStrLen(TempSalesCrMemoLine.Description) then begin
          TempSalesCrMemoLine.Description := CopyStr(Comment,1,MaxStrLen(TempSalesCrMemoLine.Description));
          TempSalesCrMemoLine."Description 2" := '';
        end else begin
          SpacePointer := MaxStrLen(TempSalesCrMemoLine.Description) + 1;
          while (SpacePointer > 1) and (Comment[SpacePointer] <> ' ') do
            SpacePointer := SpacePointer - 1;
          if SpacePointer = 1 then
            SpacePointer := MaxStrLen(TempSalesCrMemoLine.Description) + 1;
          TempSalesCrMemoLine.Description := CopyStr(Comment,1,SpacePointer - 1);
          TempSalesCrMemoLine."Description 2" :=
            CopyStr(CopyStr(Comment,SpacePointer + 1),1,MaxStrLen(TempSalesCrMemoLine."Description 2"));
        end;
        TempSalesCrMemoLine.Insert;
    end;
}

