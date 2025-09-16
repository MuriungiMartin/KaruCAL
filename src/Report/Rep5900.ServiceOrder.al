#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 5900 "Service Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Service Order.rdlc';
    Caption = 'Service Order';
    UsageCategory = Documents;

    dataset
    {
        dataitem("Service Header";"Service Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
            RequestFilterFields = "No.","Customer No.";
            column(ReportForNavId_1634; 1634)
            {
            }
            column(Service_Header_Document_Type;"Document Type")
            {
            }
            column(No_ServHeader;"No.")
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
                    column(CompanyInfo_Picture;CompanyInfo.Picture)
                    {
                    }
                    column(CompanyInfo1_Picture;CompanyInfo1.Picture)
                    {
                    }
                    column(CompanyInfo2_Picture;CompanyInfo2.Picture)
                    {
                    }
                    column(Service_Header___Contract_No__;"Service Header"."Contract No.")
                    {
                    }
                    column(Service_Header___Order_Time_;"Service Header"."Order Time")
                    {
                    }
                    column(CustAddr_6_;CustAddr[6])
                    {
                    }
                    column(CustAddr_5_;CustAddr[5])
                    {
                    }
                    column(CustAddr_4_;CustAddr[4])
                    {
                    }
                    column(Service_Header___Order_Date_;Format("Service Header"."Order Date"))
                    {
                    }
                    column(CustAddr_3_;CustAddr[3])
                    {
                    }
                    column(Service_Header__Status;"Service Header".Status)
                    {
                    }
                    column(CustAddr_2_;CustAddr[2])
                    {
                    }
                    column(Service_Header___No__;"Service Header"."No.")
                    {
                    }
                    column(CustAddr_1_;CustAddr[1])
                    {
                    }
                    column(CompanyAddr_6_;CompanyAddr[6])
                    {
                    }
                    column(CompanyAddr_5_;CompanyAddr[5])
                    {
                    }
                    column(Service_Header___Bill_to_Name_;"Service Header"."Bill-to Name")
                    {
                    }
                    column(CompanyAddr_4_;CompanyAddr[4])
                    {
                    }
                    column(CompanyAddr_3_;CompanyAddr[3])
                    {
                    }
                    column(CompanyAddr_2_;CompanyAddr[2])
                    {
                    }
                    column(CompanyAddr_1_;CompanyAddr[1])
                    {
                    }
                    column(STRSUBSTNO_Text001_CopyText_;StrSubstNo(Text001,CopyText))
                    {
                    }
                    column(STRSUBSTNO_Text002_FORMAT_CurrReport_PAGENO__;StrSubstNo(Text002,Format(CurrReport.PageNo)))
                    {
                    }
                    column(CompanyInfo__Phone_No__;CompanyInfo."Phone No.")
                    {
                    }
                    column(CompanyInfo__Fax_No__;CompanyInfo."Fax No.")
                    {
                    }
                    column(Service_Header___Phone_No__;"Service Header"."Phone No.")
                    {
                    }
                    column(Service_Header___E_Mail_;"Service Header"."E-Mail")
                    {
                    }
                    column(Service_Header__Description;"Service Header".Description)
                    {
                    }
                    column(PageCaption;StrSubstNo(Text002,' '))
                    {
                    }
                    column(OutputNo;OutputNo)
                    {
                    }
                    column(PageLoop_Number;Number)
                    {
                    }
                    column(Contract_No_Caption;Contract_No_CaptionLbl)
                    {
                    }
                    column(Service_Header___Order_Time_Caption;"Service Header".FieldCaption("Order Time"))
                    {
                    }
                    column(Service_Header___Order_Date_Caption;Service_Header___Order_Date_CaptionLbl)
                    {
                    }
                    column(Service_Header__StatusCaption;"Service Header".FieldCaption(Status))
                    {
                    }
                    column(Service_Header___No__Caption;"Service Header".FieldCaption("No."))
                    {
                    }
                    column(Invoice_toCaption;Invoice_toCaptionLbl)
                    {
                    }
                    column(CompanyInfo__Phone_No__Caption;CompanyInfo__Phone_No__CaptionLbl)
                    {
                    }
                    column(CompanyInfo__Fax_No__Caption;CompanyInfo__Fax_No__CaptionLbl)
                    {
                    }
                    column(Service_Header___Phone_No__Caption;Service_Header___Phone_No__CaptionLbl)
                    {
                    }
                    column(Service_Header___E_Mail_Caption;Service_Header___E_Mail_CaptionLbl)
                    {
                    }
                    column(Service_Header__DescriptionCaption;"Service Header".FieldCaption(Description))
                    {
                    }
                    dataitem(DimensionLoop1;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=filter(1..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText;DimText)
                        {
                        }
                        column(DimText_Control11;DimText)
                        {
                        }
                        column(DimensionLoop1_Number;Number)
                        {
                        }
                        column(Header_DimensionsCaption;Header_DimensionsCaptionLbl)
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
                                    '%1 %2',DimSetEntry1."Dimension Code",DimSetEntry1."Dimension Value Code")
                              else
                                DimText :=
                                  StrSubstNo(
                                    '%1, %2 %3',DimText,
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
                    dataitem("Service Order Comment";"Service Comment Line")
                    {
                        DataItemLink = "Table Subtype"=field("Document Type"),"No."=field("No.");
                        DataItemLinkReference = "Service Header";
                        DataItemTableView = sorting("Table Name","Table Subtype","No.",Type,"Table Line No.","Line No.") where("Table Name"=const("Service Header"),Type=const(General));
                        column(ReportForNavId_9034; 9034)
                        {
                        }
                        column(Service_Order_Comment_Comment;Comment)
                        {
                        }
                        column(ServiceOrderComment_TabName;"Table Name")
                        {
                        }
                        column(Service_Order_Comment_Table_Subtype;"Table Subtype")
                        {
                        }
                        column(Service_Order_Comment_No_;"No.")
                        {
                        }
                        column(Service_Order_Comment_Type;Type)
                        {
                        }
                        column(Service_Order_Comment_Table_Line_No_;"Table Line No.")
                        {
                        }
                        column(Service_Order_Comment_Line_No_;"Line No.")
                        {
                        }
                    }
                    dataitem("Service Item Line";"Service Item Line")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                        DataItemLinkReference = "Service Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.");
                        column(ReportForNavId_6416; 6416)
                        {
                        }
                        column(Service_Item_Line___Line_No__;"Service Item Line"."Line No.")
                        {
                        }
                        column(SerialNo_ServItemLine;"Serial No.")
                        {
                        }
                        column(Service_Item_Line_Description;Description)
                        {
                        }
                        column(Service_Item_Line__Service_Item_No__;"Service Item No.")
                        {
                        }
                        column(ServItemGroupCode_ServItemLine;"Service Item Group Code")
                        {
                        }
                        column(Service_Item_Line_Warranty;Format(Warranty))
                        {
                        }
                        column(Service_Item_Line__Loaner_No__;"Loaner No.")
                        {
                        }
                        column(Service_Item_Line__Repair_Status_Code_;"Repair Status Code")
                        {
                        }
                        column(Service_Item_Line__Service_Shelf_No__;"Service Shelf No.")
                        {
                        }
                        column(Service_Item_Line__Response_Time_;Format("Response Time"))
                        {
                        }
                        column(Service_Item_Line__Response_Date_;Format("Response Date"))
                        {
                        }
                        column(Service_Item_Line_Document_Type;"Document Type")
                        {
                        }
                        column(Service_Item_Line_Document_No_;"Document No.")
                        {
                        }
                        column(Service_Item_Line__Serial_No__Caption;FieldCaption("Serial No."))
                        {
                        }
                        column(Service_Item_Line_DescriptionCaption;FieldCaption(Description))
                        {
                        }
                        column(Service_Item_Line__Service_Item_No__Caption;FieldCaption("Service Item No."))
                        {
                        }
                        column(Service_Item_Line__Service_Item_Group_Code_Caption;FieldCaption("Service Item Group Code"))
                        {
                        }
                        column(Service_Item_Line_WarrantyCaption;CaptionClassTranslate(FieldCaption(Warranty)))
                        {
                        }
                        column(Service_Item_LinesCaption;Service_Item_LinesCaptionLbl)
                        {
                        }
                        column(Service_Item_Line__Loaner_No__Caption;FieldCaption("Loaner No."))
                        {
                        }
                        column(Service_Item_Line__Repair_Status_Code_Caption;FieldCaption("Repair Status Code"))
                        {
                        }
                        column(Service_Item_Line__Service_Shelf_No__Caption;FieldCaption("Service Shelf No."))
                        {
                        }
                        column(Service_Item_Line__Response_Date_Caption;Service_Item_Line__Response_Date_CaptionLbl)
                        {
                        }
                        column(Service_Item_Line__Response_Time_Caption;Service_Item_Line__Response_Time_CaptionLbl)
                        {
                        }
                        dataitem("Fault Comment";"Service Comment Line")
                        {
                            DataItemLink = "Table Subtype"=field("Document Type"),"No."=field("Document No."),"Table Line No."=field("Line No.");
                            DataItemTableView = sorting("Table Name","Table Subtype","No.",Type,"Table Line No.","Line No.") where("Table Name"=const("Service Header"),Type=const(Fault));
                            column(ReportForNavId_8902; 8902)
                            {
                            }
                            column(Comment_FaultComment;Comment)
                            {
                            }
                            column(Fault_Comment_Table_Name;"Table Name")
                            {
                            }
                            column(Fault_Comment_Table_Subtype;"Table Subtype")
                            {
                            }
                            column(Fault_Comment_No_;"No.")
                            {
                            }
                            column(Fault_Comment_Type;Type)
                            {
                            }
                            column(Fault_Comment_Table_Line_No_;"Table Line No.")
                            {
                            }
                            column(Fault_Comment_Line_No_;"Line No.")
                            {
                            }
                            column(Fault_CommentsCaption;Fault_CommentsCaptionLbl)
                            {
                            }
                        }
                        dataitem("Resolution Comment";"Service Comment Line")
                        {
                            DataItemLink = "Table Subtype"=field("Document Type"),"No."=field("Document No."),"Table Line No."=field("Line No.");
                            DataItemTableView = sorting("Table Name","Table Subtype","No.",Type,"Table Line No.","Line No.") where("Table Name"=const("Service Header"),Type=const(Resolution));
                            column(ReportForNavId_5074; 5074)
                            {
                            }
                            column(Comment_ResolutionComment;Comment)
                            {
                            }
                            column(Resolution_Comment_Table_Name;"Table Name")
                            {
                            }
                            column(Resolution_Comment_Table_Subtype;"Table Subtype")
                            {
                            }
                            column(Resolution_Comment_No_;"No.")
                            {
                            }
                            column(Resolution_Comment_Type;Type)
                            {
                            }
                            column(Resolution_Comment_Table_Line_No_;"Table Line No.")
                            {
                            }
                            column(Resolution_Comment_Line_No_;"Line No.")
                            {
                            }
                            column(Resolution_CommentsCaption;Resolution_CommentsCaptionLbl)
                            {
                            }
                        }
                    }
                    dataitem("Service Line";"Service Line")
                    {
                        DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                        DataItemLinkReference = "Service Header";
                        DataItemTableView = sorting("Document Type","Document No.","Line No.");
                        column(ReportForNavId_6560; 6560)
                        {
                        }
                        column(Service_Line___Line_No__;"Service Line"."Line No.")
                        {
                        }
                        column(TotalAmt;TotalAmt)
                        {
                        }
                        column(TotalGrossAmt;TotalGrossAmt)
                        {
                        }
                        column(Service_Line__Service_Item_Serial_No__;"Service Item Serial No.")
                        {
                        }
                        column(Type_ServLine;Type)
                        {
                        }
                        column(Service_Line__No__;"No.")
                        {
                        }
                        column(Service_Line__Variant_Code_;"Variant Code")
                        {
                        }
                        column(Service_Line_Description;Description)
                        {
                        }
                        column(Qty;Qty)
                        {
                        }
                        column(UnitPrice_ServLine;"Unit Price")
                        {
                        }
                        column(Service_Line__Line_Discount___;"Line Discount %")
                        {
                        }
                        column(Amt;Amt)
                        {
                        }
                        column(GrossAmt;GrossAmt)
                        {
                        }
                        column(Service_Line__Quantity_Consumed_;"Quantity Consumed")
                        {
                        }
                        column(Service_Line__Qty__to_Consume_;"Qty. to Consume")
                        {
                        }
                        column(Amt_Control63;Amt)
                        {
                        }
                        column(GrossAmt_Control65;GrossAmt)
                        {
                        }
                        column(Service_Line_Document_Type;"Document Type")
                        {
                        }
                        column(DocumentNo_ServLine;"Document No.")
                        {
                        }
                        column(Service_Line__Service_Item_Serial_No__Caption;FieldCaption("Service Item Serial No."))
                        {
                        }
                        column(Service_Line__No__Caption;FieldCaption("No."))
                        {
                        }
                        column(Service_Line_TypeCaption;FieldCaption(Type))
                        {
                        }
                        column(Service_Line__Variant_Code_Caption;FieldCaption("Variant Code"))
                        {
                        }
                        column(Service_Line_DescriptionCaption;FieldCaption(Description))
                        {
                        }
                        column(QtyCaption;QtyCaptionLbl)
                        {
                        }
                        column(Service_LinesCaption;Service_LinesCaptionLbl)
                        {
                        }
                        column(Service_Line__Unit_Price_Caption;FieldCaption("Unit Price"))
                        {
                        }
                        column(Service_Line__Line_Discount___Caption;FieldCaption("Line Discount %"))
                        {
                        }
                        column(AmountCaption;AmountCaptionLbl)
                        {
                        }
                        column(Gross_AmountCaption;Gross_AmountCaptionLbl)
                        {
                        }
                        column(Service_Line__Quantity_Consumed_Caption;FieldCaption("Quantity Consumed"))
                        {
                        }
                        column(Service_Line__Qty__to_Consume_Caption;FieldCaption("Qty. to Consume"))
                        {
                        }
                        column(TotalCaption;TotalCaptionLbl)
                        {
                        }
                        dataitem(DimensionLoop2;"Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number=filter(1..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_Control13;DimText)
                            {
                            }
                            column(DimensionLoop2_Number;Number)
                            {
                            }
                            column(Line_DimensionsCaption;Line_DimensionsCaptionLbl)
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
                                        '%1 %2',DimSetEntry2."Dimension Code",DimSetEntry2."Dimension Value Code")
                                  else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3',DimText,
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

                                DimSetEntry2.SetRange("Dimension Set ID","Service Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            ExchangeFactor: Decimal;
                            SalesTaxCalculate: Codeunit "Sales Tax Calculate";
                            TempSalesTaxAmountLine: Record UnknownRecord10011 temporary;
                        begin
                            if ShowQty = Showqty::Quantity then begin
                              Qty := Quantity;
                              Amt := "Line Amount";
                              if "Service Header"."Currency Factor" = 0 then
                                ExchangeFactor := 1
                              else
                                ExchangeFactor := "Service Header"."Currency Factor";
                              SalesTaxCalculate.StartSalesTaxCalculation;
                              SalesTaxCalculate.AddServiceLine("Service Line");
                              SalesTaxCalculate.EndSalesTaxCalculation("Posting Date");
                              SalesTaxCalculate.GetSalesTaxAmountLineTable(TempSalesTaxAmountLine);
                              GrossAmt := Amt + TempSalesTaxAmountLine.GetTotalTaxAmountFCY;
                            end else begin
                              if "Quantity Invoiced" = 0 then
                                CurrReport.Skip;
                              Qty := "Quantity Invoiced";

                              Amt := ROUND((Qty * "Unit Price") * (1 - "Line Discount %" / 100));
                              GrossAmt := (1 + "VAT %" / 100) * Amt;
                            end;
                            TotalAmt += Amt;
                            TotalGrossAmt += GrossAmt;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(Amt,GrossAmt);
                            TotalAmt := 0;
                            TotalGrossAmt := 0;
                        end;
                    }
                    dataitem(Shipto;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_6218; 6218)
                        {
                        }
                        column(ShipToAddr_6_;ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr_5_;ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr_4_;ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr_3_;ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr_2_;ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr_1_;ShipToAddr[1])
                        {
                        }
                        column(Shipto_Number;Number)
                        {
                        }
                        column(Ship_to_AddressCaption;Ship_to_AddressCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
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

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    if NoOfLoops <= 0 then
                      NoOfLoops := 1;
                    CopyText := '';
                    SetRange(Number,1,NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                FormatAddressFields("Service Header");

                DimSetEntry1.SetRange("Dimension Set ID","Dimension Set ID");
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
                    field(ShowQty;ShowQty)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amounts Based on';
                        OptionCaption = 'Quantity,Quantity Invoiced';
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

        case ServiceSetup."Logo Position on Documents" of
          ServiceSetup."logo position on documents"::"No Logo":
            ;
          ServiceSetup."logo position on documents"::Left:
            CompanyInfo.CalcFields(Picture);
          ServiceSetup."logo position on documents"::Center:
            begin
              CompanyInfo1.Get;
              CompanyInfo1.CalcFields(Picture);
            end;
          ServiceSetup."logo position on documents"::Right:
            begin
              CompanyInfo2.Get;
              CompanyInfo2.CalcFields(Picture);
            end;
        end;
    end;

    var
        Text001: label 'Service Order %1';
        Text002: label 'Page %1';
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        ServiceSetup: Record "Service Mgt. Setup";
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        OutputNo: Integer;
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ShowShippingAddr: Boolean;
        CustAddr: array [8] of Text[50];
        ShipToAddr: array [8] of Text[50];
        CompanyAddr: array [8] of Text[50];
        CopyText: Text[30];
        DimText: Text[120];
        OldDimText: Text[120];
        Qty: Decimal;
        Amt: Decimal;
        ShowQty: Option Quantity,"Quantity Invoiced";
        GrossAmt: Decimal;
        TotalAmt: Decimal;
        TotalGrossAmt: Decimal;
        Contract_No_CaptionLbl: label 'Contract No.';
        Service_Header___Order_Date_CaptionLbl: label 'Order Date';
        Invoice_toCaptionLbl: label 'Invoice to';
        CompanyInfo__Phone_No__CaptionLbl: label 'Phone No.';
        CompanyInfo__Fax_No__CaptionLbl: label 'Fax No.';
        Service_Header___Phone_No__CaptionLbl: label 'Phone No.';
        Service_Header___E_Mail_CaptionLbl: label 'Email';
        Header_DimensionsCaptionLbl: label 'Header Dimensions';
        Service_Item_LinesCaptionLbl: label 'Service Item Lines';
        Service_Item_Line__Response_Date_CaptionLbl: label 'Response Date';
        Service_Item_Line__Response_Time_CaptionLbl: label 'Response Time';
        Fault_CommentsCaptionLbl: label 'Fault Comments';
        Resolution_CommentsCaptionLbl: label 'Resolution Comments';
        QtyCaptionLbl: label 'Quantity';
        Service_LinesCaptionLbl: label 'Service Lines';
        AmountCaptionLbl: label 'Amount';
        Gross_AmountCaptionLbl: label 'Gross Amount';
        TotalCaptionLbl: label 'Total';
        Line_DimensionsCaptionLbl: label 'Line Dimensions';
        Ship_to_AddressCaptionLbl: label 'Ship-to Address';


    procedure InitializeRequest(ShowInternalInfoFrom: Boolean;ShowQtyFrom: Option)
    begin
        ShowInternalInfo := ShowInternalInfoFrom;
        ShowQty := ShowQtyFrom;
    end;

    local procedure FormatAddressFields(var ServiceHeader: Record "Service Header")
    begin
        FormatAddr.GetCompanyAddr(ServiceHeader."Responsibility Center",RespCenter,CompanyInfo,CompanyAddr);
        FormatAddr.ServiceOrderSellto(CustAddr,ServiceHeader);
        ShowShippingAddr := ServiceHeader."Ship-to Code" <> '' ;
        if ShowShippingAddr then
          FormatAddr.ServiceOrderShipto(ShipToAddr,ServiceHeader);
    end;
}

