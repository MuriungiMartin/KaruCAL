#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10476 "Elec. Sales Credit Memo MX"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Elec. Sales Credit Memo MX.rdlc';
    Caption = 'Electronic Sales Credit Memo Mexico';
    Permissions = TableData "Sales Cr.Memo Line"=rimd;

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
            column(Sales_Cr_Memo_Header_No_;"No.")
            {
            }
            column(DocumentFooter;DocumentFooterLbl)
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
                        with TempSalesCrMemoLine do begin
                          Init;
                          "Document No." := "Sales Cr.Memo Header"."No.";
                          "Line No." := HighestLineNo + 10;
                          HighestLineNo := "Line No.";
                        end;
                        if StrLen(Comment) <= MaxStrLen(TempSalesCrMemoLine.Description) then begin
                          TempSalesCrMemoLine.Description := Comment;
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
                    with TempSalesCrMemoLine do begin
                      Init;
                      "Document No." := "Sales Cr.Memo Header"."No.";
                      "Line No." := HighestLineNo + 1000;
                      HighestLineNo := "Line No.";
                    end;
                    if StrLen(Comment) <= MaxStrLen(TempSalesCrMemoLine.Description) then begin
                      TempSalesCrMemoLine.Description := Comment;
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
                    column(CompanyInformation_Picture;CompanyInformation.Picture)
                    {
                    }
                    column(CompanyInfo1_Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2_Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyAddress_1_;CompanyAddress[1])
                    {
                    }
                    column(CompanyAddress_2_;CompanyAddress[2])
                    {
                    }
                    column(CompanyAddress_3_;CompanyAddress[3])
                    {
                    }
                    column(CompanyAddress_4_;CompanyAddress[4])
                    {
                    }
                    column(CompanyAddress_5_;CompanyAddress[5])
                    {
                    }
                    column(CompanyAddress_6_;CompanyAddress[6])
                    {
                    }
                    column(CopyTxt;CopyTxt)
                    {
                    }
                    column(BillToAddress_1_;BillToAddress[1])
                    {
                    }
                    column(BillToAddress_2_;BillToAddress[2])
                    {
                    }
                    column(BillToAddress_3_;BillToAddress[3])
                    {
                    }
                    column(BillToAddress_4_;BillToAddress[4])
                    {
                    }
                    column(BillToAddress_5_;BillToAddress[5])
                    {
                    }
                    column(BillToAddress_6_;BillToAddress[6])
                    {
                    }
                    column(BillToAddress_7_;BillToAddress[7])
                    {
                    }
                    column(Sales_Cr_Memo_Header___Shipment_Date_;"Sales Cr.Memo Header"."Shipment Date")
                    {
                    }
                    column(Sales_Cr_Memo_Header___Applies_to_Doc__Type_;"Sales Cr.Memo Header"."Applies-to Doc. Type")
                    {
                    }
                    column(Sales_Cr_Memo_Header___Applies_to_Doc__No__;"Sales Cr.Memo Header"."Applies-to Doc. No.")
                    {
                    }
                    column(ShipToAddress_1_;ShipToAddress[1])
                    {
                    }
                    column(ShipToAddress_2_;ShipToAddress[2])
                    {
                    }
                    column(ShipToAddress_3_;ShipToAddress[3])
                    {
                    }
                    column(ShipToAddress_4_;ShipToAddress[4])
                    {
                    }
                    column(ShipToAddress_5_;ShipToAddress[5])
                    {
                    }
                    column(ShipToAddress_6_;ShipToAddress[6])
                    {
                    }
                    column(ShipToAddress_7_;ShipToAddress[7])
                    {
                    }
                    column(Sales_Cr_Memo_Header___Bill_to_Customer_No__;"Sales Cr.Memo Header"."Bill-to Customer No.")
                    {
                    }
                    column(Sales_Cr_Memo_Header___Your_Reference_;"Sales Cr.Memo Header"."Your Reference")
                    {
                    }
                    column(SalesPurchPerson_Name;SalesPurchPerson.Name)
                    {
                    }
                    column(CurrReport_PAGENO;CurrReport.PageNo)
                    {
                    }
                    column(CompanyAddress_7_;CompanyAddress[7])
                    {
                    }
                    column(CompanyAddress_8_;CompanyAddress[8])
                    {
                    }
                    column(BillToAddress_8_;BillToAddress[8])
                    {
                    }
                    column(ShipToAddress_8_;ShipToAddress[8])
                    {
                    }
                    column(CopyNo;CopyNo)
                    {
                    }
                    column(CompanyInformation__RFC_No__;CompanyInformation."RFC No.")
                    {
                    }
                    column(Sales_Cr_Memo_Header___Certificate_Serial_No__;"Sales Cr.Memo Header"."Certificate Serial No.")
                    {
                    }
                    column(FolioText;"Sales Cr.Memo Header"."Fiscal Invoice Number PAC")
                    {
                    }
                    column(NoSeriesLine__Authorization_Code_;"Sales Cr.Memo Header"."Date/Time Stamped")
                    {
                    }
                    column(NoSeriesLine__Authorization_Year_;StrSubstNo(Text011,"Sales Cr.Memo Header"."Bill-to City","Sales Cr.Memo Header"."Document Date"))
                    {
                    }
                    column(Customer__RFC_No__;Customer."RFC No.")
                    {
                    }
                    column(Sales_Cr_Memo_Header___No__;"Sales Cr.Memo Header"."No.")
                    {
                    }
                    column(Customer__Phone_No__;Customer."Phone No.")
                    {
                    }
                    column(PageLoop_Number;Number)
                    {
                    }
                    column(CreditCaption;CreditCaptionLbl)
                    {
                    }
                    column(Ship_DateCaption;Ship_DateCaptionLbl)
                    {
                    }
                    column(Apply_to_TypeCaption;Apply_to_TypeCaptionLbl)
                    {
                    }
                    column(Apply_to_NumberCaption;Apply_to_NumberCaptionLbl)
                    {
                    }
                    column(Customer_IDCaption;Customer_IDCaptionLbl)
                    {
                    }
                    column(P_O__NumberCaption;P_O__NumberCaptionLbl)
                    {
                    }
                    column(SalesPersonCaption;SalesPersonCaptionLbl)
                    {
                    }
                    column(ShipCaption;ShipCaptionLbl)
                    {
                    }
                    column(CREDIT_MEMOCaption;CREDIT_MEMOCaptionLbl)
                    {
                    }
                    column(Page_Caption;Page_CaptionLbl)
                    {
                    }
                    column(CompanyInformation__RFC_No__Caption;CompanyInformation__RFC_No__CaptionLbl)
                    {
                    }
                    column(Sales_Cr_Memo_Header___Certificate_Serial_No__Caption;Sales_Cr_Memo_Header___Certificate_Serial_No__CaptionLbl)
                    {
                    }
                    column(FolioTextCaption;FolioTextCaptionLbl)
                    {
                    }
                    column(NoSeriesLine__Authorization_Code_Caption;NoSeriesLine__Authorization_Code_CaptionLbl)
                    {
                    }
                    column(NoSeriesLine__Authorization_Year_Caption;NoSeriesLine__Authorization_Year_CaptionLbl)
                    {
                    }
                    column(Customer__RFC_No__Caption;Customer__RFC_No__CaptionLbl)
                    {
                    }
                    column(Customer__Phone_No__Caption;Customer__Phone_No__CaptionLbl)
                    {
                    }
                    dataitem(SalesCrMemoLine;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_3082; 3082)
                        {
                        }
                        column(STRSUBSTNO_Text001_CurrReport_PAGENO___1_;StrSubstNo(Text001,CurrReport.PageNo - 1))
                        {
                        }
                        column(AmountExclInvDisc;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine__No__;TempSalesCrMemoLine."No.")
                        {
                        }
                        column(TempSalesCrMemoLine__Unit_of_Measure_;TempSalesCrMemoLine."Unit of Measure")
                        {
                        }
                        column(TempSalesCrMemoLine_Quantity;TempSalesCrMemoLine.Quantity)
                        {
                            DecimalPlaces = 0:5;
                        }
                        column(UnitPriceToPrint;UnitPriceToPrint)
                        {
                            DecimalPlaces = 2:5;
                        }
                        column(AmountExclInvDisc_Control53;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine_Description_________TempSalesCrMemoLine__Description_2_;TempSalesCrMemoLine.Description + ' ' + TempSalesCrMemoLine."Description 2")
                        {
                        }
                        column(STRSUBSTNO_Text002_CurrReport_PAGENO___1_;StrSubstNo(Text002,CurrReport.PageNo + 1))
                        {
                        }
                        column(AmountExclInvDisc_Control40;AmountExclInvDisc)
                        {
                        }
                        column(AmountExclInvDisc_Control79;AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine_Amount___AmountExclInvDisc;TempSalesCrMemoLine.Amount - AmountExclInvDisc)
                        {
                        }
                        column(TempSalesCrMemoLine__Amount_Including_VAT____TempSalesCrMemoLine_Amount;TempSalesCrMemoLine."Amount Including VAT" - TempSalesCrMemoLine.Amount)
                        {
                        }
                        column(TempSalesCrMemoLine__Amount_Including_VAT_;TempSalesCrMemoLine."Amount Including VAT")
                        {
                        }
                        column(AmountInWords_1_;AmountInWords[1])
                        {
                        }
                        column(AmountInWords_2_;AmountInWords[2])
                        {
                        }
                        column(SalesCrMemoLine_Number;Number)
                        {
                        }
                        column(Item_No_Caption;Item_No_CaptionLbl)
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
                        column(Unit_PriceCaption;Unit_PriceCaptionLbl)
                        {
                        }
                        column(Total_PriceCaption;Total_PriceCaptionLbl)
                        {
                        }
                        column(Subtotal_Caption;Subtotal_CaptionLbl)
                        {
                        }
                        column(Invoice_Discount_Caption;Invoice_Discount_CaptionLbl)
                        {
                        }
                        column(Total_Caption;Total_CaptionLbl)
                        {
                        }
                        column(TempSalesCrMemoLine__Amount_Including_VAT____TempSalesCrMemoLine_AmountCaption;TempSalesCrMemoLine__Amount_Including_VAT____TempSalesCrMemoLine_AmountCaptionLbl)
                        {
                        }
                        column(Amount_in_words_Caption;Amount_in_words_CaptionLbl)
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

                              TotalAmountIncludingVAT += "Amount Including VAT";
                            end;

                            if OnLineNumber = NumberOfLines then
                              ConvertAmounttoWords(TotalAmountIncludingVAT);
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(TaxLiable,AmountExclInvDisc,TempSalesCrMemoLine.Amount,TempSalesCrMemoLine."Amount Including VAT");
                            NumberOfLines := TempSalesCrMemoLine.Count;
                            SetRange(Number,1,NumberOfLines);
                            OnLineNumber := 0;
                            TotalAmountIncludingVAT := 0;
                        end;
                    }
                    dataitem(OriginalStringLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_5410; 5410)
                        {
                        }
                        column(OriginalStringText;OriginalStringText)
                        {
                        }
                        column(OriginalStringLoop_Number;Number)
                        {
                        }
                        column(Original_StringCaption;Original_StringCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            ReturnLength: Integer;
                        begin
                            OriginalStringText := '';
                            ReturnLength := OriginalStringBigText.GetSubText(OriginalStringText,Position,MaxStrLen(OriginalStringText));
                            Position := Position + ReturnLength;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,ROUND(OriginalStringBigText.Length / MaxStrLen(OriginalStringText),1,'>'));
                            Position := 1;
                        end;
                    }
                    dataitem(DigitalSignaturePACLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_4802; 4802)
                        {
                        }
                        column(DigitalSignaturePACText;DigitalSignaturePACText)
                        {
                        }
                        column(DigitalSignaturePACLoop_Number;Number)
                        {
                        }
                        column(Digital_StampCaption;Digital_StampCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            ReturnLength: Integer;
                        begin
                            DigitalSignaturePACText := '';
                            ReturnLength := DigitalSignaturePACBigText.GetSubText(DigitalSignaturePACText,Position,MaxStrLen(DigitalSignaturePACText));
                            Position := Position + ReturnLength;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,ROUND(DigitalSignaturePACBigText.Length / MaxStrLen(DigitalSignaturePACText),1,'>'));
                            Position := 1;
                        end;
                    }
                    dataitem(DigitalSignatureLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_8590; 8590)
                        {
                        }
                        column(DigitalSignatureText;DigitalSignatureText)
                        {
                        }
                        column(DigitalSignatureLoop_Number;Number)
                        {
                        }
                        column(Digital_stampCaption_Control1020008;Digital_stampCaption_Control1020008Lbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        var
                            ReturnLength: Integer;
                        begin
                            DigitalSignatureText := '';
                            ReturnLength := DigitalSignatureBigText.GetSubText(DigitalSignatureText,Position,MaxStrLen(DigitalSignatureText));
                            Position := Position + ReturnLength;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number,1,ROUND(DigitalSignatureBigText.Length / MaxStrLen(DigitalSignatureText),1,'>'));
                            Position := 1;
                        end;
                    }
                    dataitem(QRCode;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_4393; 4393)
                        {
                        }
                        column(Sales_Cr_Memo_Header___QR_Code_;"Sales Cr.Memo Header"."QR Code")
                        {
                        }
                        column(QRCode_Number;Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            "Sales Cr.Memo Header".CalcFields("QR Code");
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
            var
                TempBlob: Record TempBlob;
            begin
                if "Source Code" = SourceCodeSetup."Deleted Document" then
                  Error(Text010);

                if PrintCompany then
                  if RespCenter.Get("Responsibility Center") then begin
                    FormatAddress.RespCenter(CompanyAddress,RespCenter);
                    CompanyInformation."Phone No." := RespCenter."Phone No.";
                    CompanyInformation."Fax No." := RespCenter."Fax No.";
                  end;
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if "Salesperson Code" = '' then
                  Clear(SalesPurchPerson)
                else
                  SalesPurchPerson.Get("Salesperson Code");

                if not Customer.Get("Bill-to Customer No.") then begin
                  Clear(Customer);
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
                "Sales Cr.Memo Header".CalcFields("Original String","Digital Stamp SAT","Digital Stamp PAC");
                Clear(OriginalStringBigText);
                TempBlob.Blob := "Sales Cr.Memo Header"."Original String";
                BlobMgt.Read(OriginalStringBigText,TempBlob);
                Clear(DigitalSignatureBigText);
                TempBlob.Blob := "Sales Cr.Memo Header"."Digital Stamp SAT";
                BlobMgt.Read(DigitalSignatureBigText,TempBlob);
                Clear(DigitalSignaturePACBigText);
                TempBlob.Blob := "Sales Cr.Memo Header"."Digital Stamp PAC";
                BlobMgt.Read(DigitalSignaturePACBigText,TempBlob);
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
                        ToolTip = 'Specifies the number of copies to print of the document.';
                    }
                    field(PrintCompany;PrintCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if the printed document includes your company address.';
                    }
                    field(LogInteraction;LogInteraction)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;
                        ToolTip = 'Specifies that interactions with contact persons in connection with the report are logged.';
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
        CompanyInformation.Get;
        SalesSetup.Get;
        SourceCodeSetup.Get;

        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::"No Logo":
            ;
          SalesSetup."logo position on documents"::Left:
            CompanyInformation.CalcFields(Picture);
          SalesSetup."logo position on documents"::Center:
            begin
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          SalesSetup."logo position on documents"::Right:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
        end;

        if PrintCompany then
          FormatAddress.Company(CompanyAddress,CompanyInformation)
        else
          Clear(CompanyAddress);
    end;

    var
        TaxLiable: Decimal;
        UnitPriceToPrint: Decimal;
        AmountExclInvDisc: Decimal;
        TotalAmountIncludingVAT: Decimal;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesCrMemoLine: Record "Sales Cr.Memo Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        Customer: Record Customer;
        SourceCodeSetup: Record "Source Code Setup";
        CompanyAddress: array [8] of Text[50];
        BillToAddress: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        CopyTxt: Text[10];
        PrintCompany: Boolean;
        NoCopies: Integer;
        NoLoops: Integer;
        CopyNo: Integer;
        NumberOfLines: Integer;
        OnLineNumber: Integer;
        HighestLineNo: Integer;
        SpacePointer: Integer;
        SalesCrMemoPrinted: Codeunit "Sales Cr. Memo-Printed";
        FormatAddress: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        LogInteraction: Boolean;
        BlobMgt: Codeunit "Blob Management";
        Text000: label 'COPY';
        Text001: label 'Transferred from page %1';
        Text002: label 'Transferred to page %1';
        Position: Integer;
        Text009: label 'VOID CREDIT MEMO';
        AmountInWords: array [2] of Text[80];
        OriginalStringText: Text[80];
        DigitalSignatureText: Text[80];
        DigitalSignaturePACText: Text[80];
        OriginalStringBigText: BigText;
        DigitalSignatureBigText: BigText;
        Text010: label 'You can not sign or send or print a deleted document.';
        DigitalSignaturePACBigText: BigText;
        Text011: label '%1, %2';
        [InDataSet]
        LogInteractionEnable: Boolean;
        CreditCaptionLbl: label 'Credit-To:';
        Ship_DateCaptionLbl: label 'Ship Date';
        Apply_to_TypeCaptionLbl: label 'Apply to Type';
        Apply_to_NumberCaptionLbl: label 'Apply to Number';
        Customer_IDCaptionLbl: label 'Customer ID';
        P_O__NumberCaptionLbl: label 'P.O. Number';
        SalesPersonCaptionLbl: label 'SalesPerson';
        ShipCaptionLbl: label 'Ship-To:';
        CREDIT_MEMOCaptionLbl: label 'CREDIT MEMO';
        Page_CaptionLbl: label 'Page:';
        CompanyInformation__RFC_No__CaptionLbl: label 'Company RFC';
        Sales_Cr_Memo_Header___Certificate_Serial_No__CaptionLbl: label 'Certificate Serial No.';
        FolioTextCaptionLbl: label 'Folio:';
        NoSeriesLine__Authorization_Code_CaptionLbl: label 'Date and time of certification:';
        NoSeriesLine__Authorization_Year_CaptionLbl: label 'Location and Issue date:';
        Customer__RFC_No__CaptionLbl: label 'Customer RFC';
        Customer__Phone_No__CaptionLbl: label 'Phone number';
        Item_No_CaptionLbl: label 'Item No.';
        UnitCaptionLbl: label 'Unit';
        DescriptionCaptionLbl: label 'Description';
        QuantityCaptionLbl: label 'Quantity';
        Unit_PriceCaptionLbl: label 'Unit Price';
        Total_PriceCaptionLbl: label 'Total Price';
        Subtotal_CaptionLbl: label 'Subtotal:';
        Invoice_Discount_CaptionLbl: label 'Invoice Discount:';
        Total_CaptionLbl: label 'Total:';
        TempSalesCrMemoLine__Amount_Including_VAT____TempSalesCrMemoLine_AmountCaptionLbl: label 'Tax Amount';
        Amount_in_words_CaptionLbl: label 'Amount in words:';
        Original_StringCaptionLbl: label 'Original string of digital certificate complement from SAT';
        Digital_StampCaptionLbl: label 'Digital stamp from SAT';
        Digital_stampCaption_Control1020008Lbl: label 'Digital stamp';
        DocumentFooterLbl: label 'This document is a printed version for electronic credit memo';


    procedure ConvertAmounttoWords(AmountLoc: Decimal)
    var
        TranslationManagement: Report "Check Translation Management";
        LanguageId: Integer;
    begin
        if CurrReport.Language in [1033,3084,2058,4105] then
          LanguageId := CurrReport.Language
        else
          LanguageId := GlobalLanguage;
        TranslationManagement.FormatNoText(AmountInWords,AmountLoc,
          LanguageId,"Sales Cr.Memo Header"."Currency Code");
    end;
}

