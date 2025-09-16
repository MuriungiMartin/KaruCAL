#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10080 "Sales Shipment per Package"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Sales Shipment per Package.rdlc';
    Caption = 'Sales Shipment per Package';

    dataset
    {
        dataitem("Sales Shipment Header";"Sales Shipment Header")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Sell-to Customer No.","Bill-to Customer No.","Ship-to Code","No. Printed";
            column(ReportForNavId_3595; 3595)
            {
            }
            column(Sales_Shipment_Header_No_;"No.")
            {
            }
            dataitem(PackageNoLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_4129; 4129)
                {
                }
                dataitem("Sales Shipment Line";"Sales Shipment Line")
                {
                    DataItemLink = "Document No."=field("No.");
                    DataItemLinkReference = "Sales Shipment Header";
                    DataItemTableView = sorting("Document No.","Package Tracking No.");
                    column(ReportForNavId_2502; 2502)
                    {
                    }
                    dataitem(SalesLineComments;"Sales Comment Line")
                    {
                        DataItemLink = "No."=field("Document No."),"Document Line No."=field("Line No.");
                        DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const(Shipment),"Print On Shipment"=const(Yes));
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
                        TempSalesShipmentLine := "Sales Shipment Line";
                        TempSalesShipmentLine.Insert;
                        HighestLineNo := "Line No.";
                    end;

                    trigger OnPreDataItem()
                    begin
                        TempSalesShipmentLine.Reset;
                        TempSalesShipmentLine.DeleteAll;
                        SetRange("Package Tracking No.",TempPackageNo."Package Tracking No.");
                    end;
                }
                dataitem("Sales Comment Line";"Sales Comment Line")
                {
                    DataItemLink = "No."=field("No.");
                    DataItemLinkReference = "Sales Shipment Header";
                    DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const(Shipment),"Print On Shipment"=const(Yes),"Document Line No."=const(0));
                    column(ReportForNavId_8541; 8541)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        InsertTempLine(Comment,1000);
                    end;

                    trigger OnPreDataItem()
                    begin
                        with TempSalesShipmentLine do begin
                          Init;
                          "Document No." := "Sales Shipment Header"."No.";
                          "Line No." := HighestLineNo + 1000;
                          HighestLineNo := "Line No.";
                        end;
                        TempSalesShipmentLine.Insert;
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
                        column(Sales_Shipment_Header___Bill_to_Customer_No__;"Sales Shipment Header"."Bill-to Customer No.")
                        {
                        }
                        column(Sales_Shipment_Header___Your_Reference_;"Sales Shipment Header"."Your Reference")
                        {
                        }
                        column(SalesPurchPerson_Name;SalesPurchPerson.Name)
                        {
                        }
                        column(Sales_Shipment_Header___No__;"Sales Shipment Header"."No.")
                        {
                        }
                        column(Sales_Shipment_Header___Shipment_Date_;"Sales Shipment Header"."Shipment Date")
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
                        column(ShipmentMethod_Description;ShipmentMethod.Description)
                        {
                        }
                        column(Sales_Shipment_Header___Order_Date_;"Sales Shipment Header"."Order Date")
                        {
                        }
                        column(Sales_Shipment_Header___Order_No__;"Sales Shipment Header"."Order No.")
                        {
                        }
                        column(Sales_Shipment_Header___Package_Tracking_No__;"Sales Shipment Header"."Package Tracking No.")
                        {
                        }
                        column(Sales_Shipment_Header___Shipping_Agent_Code_;"Sales Shipment Header"."Shipping Agent Code")
                        {
                        }
                        column(TaxRegNo;TaxRegNo)
                        {
                        }
                        column(TaxRegLabel;TaxRegLabel)
                        {
                        }
                        column(CopyNo;CopyNo)
                        {
                        }
                        column(GroupNo;GroupNo)
                        {
                        }
                        column(PageLoop_Number;Number)
                        {
                        }
                        column(BillCaption;BillCaptionLbl)
                        {
                        }
                        column(To_Caption;To_CaptionLbl)
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
                        column(To_Caption_Control89;To_Caption_Control89Lbl)
                        {
                        }
                        column(SHIPMENTCaption;SHIPMENTCaptionLbl)
                        {
                        }
                        column(Shipment_Number_Caption;Shipment_Number_CaptionLbl)
                        {
                        }
                        column(Shipment_Date_Caption;Shipment_Date_CaptionLbl)
                        {
                        }
                        column(Page_Caption;Page_CaptionLbl)
                        {
                        }
                        column(Ship_ViaCaption;Ship_ViaCaptionLbl)
                        {
                        }
                        column(P_O__DateCaption;P_O__DateCaptionLbl)
                        {
                        }
                        column(Our_Order_No_Caption;Our_Order_No_CaptionLbl)
                        {
                        }
                        column(Tracking_No_Caption;Tracking_No_CaptionLbl)
                        {
                        }
                        column(Shipping_Agent_CodeCaption;Shipping_Agent_CodeCaptionLbl)
                        {
                        }
                        dataitem(SalesShipmentLine;"Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_5956; 5956)
                            {
                            }
                            column(SalesShipmentLine_SalesShipmentLine_Number;Number)
                            {
                            }
                            column(TempSalesShipmentLine__No__;TempSalesShipmentLine."No.")
                            {
                            }
                            column(TempSalesShipmentLine__Unit_of_Measure_;TempSalesShipmentLine."Unit of Measure")
                            {
                            }
                            column(TempSalesShipmentLine_Quantity;TempSalesShipmentLine.Quantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(OrderedQuantity;OrderedQuantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(BackOrderedQuantity;BackOrderedQuantity)
                            {
                                DecimalPlaces = 0:5;
                            }
                            column(TempSalesShipmentLine_Description_________TempSalesShipmentLine__Description_2_;TempSalesShipmentLine.Description + ' ' + TempSalesShipmentLine."Description 2")
                            {
                            }
                            column(PrintFooter;PrintFooter)
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
                            column(ShippedCaption;ShippedCaptionLbl)
                            {
                            }
                            column(OrderedCaption;OrderedCaptionLbl)
                            {
                            }
                            column(Back_OrderedCaption;Back_OrderedCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                OnLineNumber := OnLineNumber + 1;

                                with TempSalesShipmentLine do begin
                                  if OnLineNumber = 1 then
                                    Find('-')
                                  else
                                    Next;

                                  OrderedQuantity := 0;
                                  BackOrderedQuantity := 0;
                                  if "Order No." = '' then
                                    OrderedQuantity := Quantity
                                  else
                                    if OrderLine.Get(1,"Order No.","Line No.") then begin
                                      OrderedQuantity := OrderLine.Quantity;
                                      BackOrderedQuantity := OrderLine."Outstanding Quantity";
                                    end else begin
                                      ReceiptLine.SetCurrentkey("Order No.","Order Line No.");
                                      ReceiptLine.SetRange("Order No.","Order No.");
                                      ReceiptLine.SetRange("Order Line No.","Line No.");
                                      ReceiptLine.Find('-');
                                      repeat
                                        OrderedQuantity := OrderedQuantity + ReceiptLine.Quantity;
                                      until 0 = ReceiptLine.Next;
                                    end;

                                  if Type = 0 then begin
                                    OrderedQuantity := 0;
                                    BackOrderedQuantity := 0;
                                    "No." := '';
                                    "Unit of Measure" := '';
                                    Quantity := 0;
                                  end else
                                    if Type = Type::"G/L Account" then
                                      "No." := '';
                                end;
                                if OnLineNumber = NumberOfLines then
                                  PrintFooter := true;
                            end;

                            trigger OnPreDataItem()
                            begin
                                NumberOfLines := TempSalesShipmentLine.Count;
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
                            SalesShipmentPrinted.Run("Sales Shipment Header");
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
                    if Number <> 1 then
                      TempPackageNo.Next;
                    "Sales Shipment Header"."Package Tracking No." := TempPackageNo."Package Tracking No.";
                    if TempPackageNo."Package Tracking No." <> LastPackageTrNo then begin
                      GroupNo := GroupNo + 1;
                      LastPackageTrNo := TempPackageNo."Package Tracking No.";
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    // Clear it
                    TempPackageNo.Reset;
                    TempPackageNo.DeleteAll;
                    TempPackageNo.SetCurrentkey("Document No.","Package Tracking No.");
                    // Fill it
                    NextLineNo := 0;
                    if "Sales Shipment Header"."Package Tracking No." <> '' then begin
                      TempPackageNo."Document No." := "Sales Shipment Header"."No.";
                      TempPackageNo."Package Tracking No." := "Sales Shipment Header"."Package Tracking No.";
                      TempPackageNo."Line No." := NextLineNo;
                      TempPackageNo.Insert;
                    end;
                    TempPackageNo.SetRange("Document No.","Sales Shipment Header"."No.");
                    with SalesShipmentLine2 do begin
                      SetCurrentkey("Document No.","Package Tracking No.");
                      SetRange("Document No.","Sales Shipment Header"."No.");
                      SetFilter("Package Tracking No.",'<>%1','');
                      if Find('-') then
                        repeat
                          TempPackageNo.SetRange("Package Tracking No.","Package Tracking No.");
                          if not TempPackageNo.Find('-') then begin
                            NextLineNo := NextLineNo + 1;
                            TempPackageNo."Document No." := "Document No.";
                            TempPackageNo."Package Tracking No." := "Package Tracking No.";
                            TempPackageNo."Line No." := NextLineNo;
                            TempPackageNo.Insert;
                          end;
                        until Next = 0;
                    end;
                    TempPackageNo.Reset;
                    SetRange(Number,1,TempPackageNo.Count);
                    if not TempPackageNo.Find('-') then
                      CurrReport.Break;
                    GroupNo := 0;
                    LastPackageTrNo := '';
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

                if "Salesperson Code" = '' then
                  Clear(SalesPurchPerson)
                else
                  SalesPurchPerson.Get("Salesperson Code");

                if "Shipment Method Code" = '' then
                  Clear(ShipmentMethod)
                else
                  ShipmentMethod.Get("Shipment Method Code");

                if "Sell-to Customer No." = '' then begin
                  "Bill-to Name" := Text009;
                  "Ship-to Name" := Text009;
                end;
                if not Cust.Get("Sell-to Customer No.") then
                  Clear(Cust);

                FormatAddress.SalesShptBillTo(BillToAddress,BillToAddress,"Sales Shipment Header");
                FormatAddress.SalesShptShipTo(ShipToAddress,"Sales Shipment Header");

                if LogInteraction then
                  if not CurrReport.Preview then
                    SegManagement.LogDocument(
                      5,"No.",0,0,Database::Customer,"Sell-to Customer No.","Salesperson Code",
                      "Campaign No.","Posting Description",'');

                TaxRegNo := '';
                TaxRegLabel := '';
                if "Tax Area Code" <> '' then begin
                  TaxArea.Get("Tax Area Code");
                  case TaxArea."Country/Region" of
                    TaxArea."country/region"::US:
                      ;
                    TaxArea."country/region"::CA:
                      begin
                        TaxRegNo := CompanyInformation."VAT Registration No.";
                        TaxRegLabel := CompanyInformation.FieldCaption("VAT Registration No.");
                      end;
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
                    field(PrintCompany;PrintCompany)
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
            InitLogInteraction;
            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if not CurrReport.UseRequestPage then
          InitLogInteraction;

        CompanyInformation.Get;
        SalesSetup.Get;

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
        ShipmentMethod: Record "Shipment Method";
        ReceiptLine: Record "Sales Shipment Line";
        OrderLine: Record "Sales Line";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInformation: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        TempSalesShipmentLine: Record "Sales Shipment Line" temporary;
        RespCenter: Record "Responsibility Center";
        Language: Record Language;
        TaxArea: Record "Tax Area";
        Cust: Record Customer;
        SalesShipmentLine2: Record "Sales Shipment Line";
        TempPackageNo: Record "Sales Shipment Line" temporary;
        SalesShipmentPrinted: Codeunit "Sales Shpt.-Printed";
        FormatAddress: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
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
        NextLineNo: Integer;
        Text000: label 'COPY';
        LogInteraction: Boolean;
        TaxRegNo: Text[30];
        GroupNo: Integer;
        LastPackageTrNo: Text[30];
        TaxRegLabel: Text[30];
        Text009: label 'VOID SHIPMENT';
        [InDataSet]
        LogInteractionEnable: Boolean;
        BillCaptionLbl: label 'Bill';
        To_CaptionLbl: label 'To:';
        Customer_IDCaptionLbl: label 'Customer ID';
        P_O__NumberCaptionLbl: label 'P.O. Number';
        SalesPersonCaptionLbl: label 'SalesPerson';
        ShipCaptionLbl: label 'Ship';
        To_Caption_Control89Lbl: label 'To:';
        SHIPMENTCaptionLbl: label 'SHIPMENT';
        Shipment_Number_CaptionLbl: label 'Shipment Number:';
        Shipment_Date_CaptionLbl: label 'Shipment Date:';
        Page_CaptionLbl: label 'Page:';
        Ship_ViaCaptionLbl: label 'Ship Via';
        P_O__DateCaptionLbl: label 'P.O. Date';
        Our_Order_No_CaptionLbl: label 'Our Order No.';
        Tracking_No_CaptionLbl: label 'Tracking No.';
        Shipping_Agent_CodeCaptionLbl: label 'Shipping Agent Code';
        Item_No_CaptionLbl: label 'Item No.';
        UnitCaptionLbl: label 'Unit';
        DescriptionCaptionLbl: label 'Description';
        ShippedCaptionLbl: label 'Shipped';
        OrderedCaptionLbl: label 'Ordered';
        Back_OrderedCaptionLbl: label 'Back Ordered';
        OrderedQuantity: Decimal;
        BackOrderedQuantity: Decimal;


    procedure InitLogInteraction()
    begin
        LogInteraction := SegManagement.FindInteractTmplCode(5) <> '';
    end;

    local procedure InsertTempLine(Comment: Text[80];IncrNo: Integer)
    begin
        with TempSalesShipmentLine do begin
          Init;
          "Document No." := "Sales Shipment Header"."No.";
          "Line No." := HighestLineNo + IncrNo;
          HighestLineNo := "Line No.";
        end;
        FormatDocument.ParseComment(Comment,TempSalesShipmentLine.Description,TempSalesShipmentLine."Description 2");
        TempSalesShipmentLine.Insert;
    end;
}

