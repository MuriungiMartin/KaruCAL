#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10153 "Picking List by Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Picking List by Order.rdlc';
    Caption = 'Picking List by Order';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Location;Location)
        {
            DataItemTableView = sorting(Code);
            column(ReportForNavId_6004; 6004)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TempLocation := Location;
                TempLocation.Insert;
            end;

            trigger OnPreDataItem()
            begin
                TempLocation.Code := '';
                TempLocation.Name := Text000;
                TempLocation.Insert;
                if not ReadPermission then
                  CurrReport.Break;
            end;
        }
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = sorting("Document Type","No.") where("Document Type"=const(Order));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Sell-to Customer No.";
            column(ReportForNavId_6640; 6640)
            {
            }
            column(Sales_Header_Document_Type;"Document Type")
            {
            }
            column(Sales_Header_No_;"No.")
            {
            }
            dataitem(LocationLoop;"Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_8027; 8027)
                {
                }
                dataitem(CopyNo;"Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_1693; 1693)
                    {
                    }
                    dataitem(PageLoop;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_6455; 6455)
                        {
                        }
                        column(CompanyInfo2_Picture;CompanyInfo2.Picture)
                        {
                        }
                        column(CompanyInfo1_Picture;CompanyInfo1.Picture)
                        {
                        }
                        column(CompanyInfo_Picture;CompanyInfo.Picture)
                        {
                        }
                        column(CurrReport_PAGENO;CurrReport.PageNo)
                        {
                        }
                        column(Sales_Header___No__;"Sales Header"."No.")
                        {
                        }
                        column(Sales_Header___Order_Date_;"Sales Header"."Order Date")
                        {
                        }
                        column(Sales_Header___Sell_to_Customer_No__;"Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(SalesPurchPerson_Name;SalesPurchPerson.Name)
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
                        column(Sales_Header___Shipment_Date_;"Sales Header"."Shipment Date")
                        {
                        }
                        column(Address_1_;Address[1])
                        {
                        }
                        column(Address_2_;Address[2])
                        {
                        }
                        column(Address_3_;Address[3])
                        {
                        }
                        column(Address_4_;Address[4])
                        {
                        }
                        column(Address_5_;Address[5])
                        {
                        }
                        column(Address_6_;Address[6])
                        {
                        }
                        column(Address_7_;Address[7])
                        {
                        }
                        column(ShipmentMethod_Description;ShipmentMethod.Description)
                        {
                        }
                        column(PaymentTerms_Description;PaymentTerms.Description)
                        {
                        }
                        column(TempLocation_Code;TempLocation.Code)
                        {
                        }
                        column(myCopyNo;CopyNo.Number)
                        {
                        }
                        column(LocationLoop_Number;LocationLoop.Number)
                        {
                        }
                        column(PageLoop_Number;Number)
                        {
                        }
                        column(EmptyStringCaption;EmptyStringCaptionLbl)
                        {
                        }
                        column(Sales_Header___Order_Date_Caption;Sales_Header___Order_Date_CaptionLbl)
                        {
                        }
                        column(Sales_Header___No__Caption;Sales_Header___No__CaptionLbl)
                        {
                        }
                        column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                        {
                        }
                        column(Sales_Line__Outstanding_Quantity_Caption;Sales_Line__Outstanding_Quantity_CaptionLbl)
                        {
                        }
                        column(Sales_Line__Quantity_Shipped_Caption;"Sales Line".FieldCaption("Quantity Shipped"))
                        {
                        }
                        column(Sales_Header___Sell_to_Customer_No__Caption;Sales_Header___Sell_to_Customer_No__CaptionLbl)
                        {
                        }
                        column(Sales_Header___Shipment_Date_Caption;Sales_Header___Shipment_Date_CaptionLbl)
                        {
                        }
                        column(SalesPurchPerson_NameCaption;SalesPurchPerson_NameCaptionLbl)
                        {
                        }
                        column(Sales_Line_QuantityCaption;Sales_Line_QuantityCaptionLbl)
                        {
                        }
                        column(Ship_To_Caption;Ship_To_CaptionLbl)
                        {
                        }
                        column(Sales_Line__Unit_of_Measure_Caption;"Sales Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(Picking_List_by_OrderCaption;Picking_List_by_OrderCaptionLbl)
                        {
                        }
                        column(Sales_Line__No__Caption;Sales_Line__No__CaptionLbl)
                        {
                        }
                        column(ShipmentMethod_DescriptionCaption;ShipmentMethod_DescriptionCaptionLbl)
                        {
                        }
                        column(PaymentTerms_DescriptionCaption;PaymentTerms_DescriptionCaptionLbl)
                        {
                        }
                        column(Item__Shelf_No__Caption;Item__Shelf_No__CaptionLbl)
                        {
                        }
                        column(TempLocation_CodeCaption;TempLocation_CodeCaptionLbl)
                        {
                        }
                        column(Sold_To_Caption;Sold_To_CaptionLbl)
                        {
                        }
                        dataitem("Sales Line";"Sales Line")
                        {
                            DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                            DataItemLinkReference = "Sales Header";
                            DataItemTableView = sorting("Document Type","Document No.","Line No.") where(Type=const(Item),"Outstanding Quantity"=filter(<>0));
                            RequestFilterFields = "Shipment Date";
                            column(ReportForNavId_2844; 2844)
                            {
                            }
                            column(Item__Shelf_No__;Item."Shelf No.")
                            {
                            }
                            column(Sales_Line__No__;"No.")
                            {
                            }
                            column(Sales_Line__Unit_of_Measure_;"Unit of Measure")
                            {
                            }
                            column(Sales_Line_Quantity;Quantity)
                            {
                                DecimalPlaces = 2:5;
                            }
                            column(Sales_Line__Quantity_Shipped_;"Quantity Shipped")
                            {
                                DecimalPlaces = 2:5;
                            }
                            column(Sales_Line__Outstanding_Quantity_;"Outstanding Quantity")
                            {
                                DecimalPlaces = 2:5;
                            }
                            column(Sales_Line_Description;Description)
                            {
                            }
                            column(EmptyString;'')
                            {
                            }
                            column(Sales_Line__Variant_Code_;"Variant Code")
                            {
                            }
                            column(myAnySerialNos;AnySerialNos)
                            {
                            }
                            column(Sales_Line_Document_Type;"Document Type")
                            {
                            }
                            column(Sales_Line_Document_No_;"Document No.")
                            {
                            }
                            column(Sales_Line_Line_No_;"Line No.")
                            {
                            }
                            dataitem("Tracking Specification";"Tracking Specification")
                            {
                                DataItemLink = "Source ID"=field("Document No."),"Source Ref. No."=field("Line No.");
                                DataItemTableView = sorting("Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.") where("Source Type"=const(37),"Source Subtype"=const("1"));
                                column(ReportForNavId_9539; 9539)
                                {
                                }
                                column(Tracking_Specification__Serial_No__;"Serial No.")
                                {
                                }
                                column(Tracking_Specification_Entry_No_;"Entry No.")
                                {
                                }
                                column(Tracking_Specification_Source_ID;"Source ID")
                                {
                                }
                                column(Tracking_Specification_Source_Ref__No_;"Source Ref. No.")
                                {
                                }
                                column(Tracking_Specification__Serial_No__Caption;FieldCaption("Serial No."))
                                {
                                }

                                trigger OnAfterGetRecord()
                                begin
                                    if "Serial No." = '' then
                                      "Serial No." := "Lot No.";
                                end;
                            }

                            trigger OnAfterGetRecord()
                            begin
                                Item.Get("No.");
                                if Item."Item Tracking Code" <> '' then
                                  with TrackSpec2 do begin
                                    SetCurrentkey(
                                      "Source ID","Source Type","Source Subtype","Source Batch Name","Source Prod. Order Line","Source Ref. No.");
                                    SetRange("Source Type",Database::"Sales Line");
                                    SetRange("Source Subtype","Sales Line"."Document Type");
                                    SetRange("Source ID","Sales Line"."Document No.");
                                    SetRange("Source Ref. No.","Sales Line"."Line No.");
                                    AnySerialNos := FindFirst;
                                  end
                                else
                                  AnySerialNos := false;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange("Location Code",TempLocation.Code);
                            end;
                        }
                        dataitem("Sales Comment Line";"Sales Comment Line")
                        {
                            DataItemLink = "No."=field("No.");
                            DataItemLinkReference = "Sales Header";
                            DataItemTableView = sorting("Document Type","No.","Document Line No.","Line No.") where("Document Type"=const(Order),"Print On Pick Ticket"=const(Yes));
                            column(ReportForNavId_8541; 8541)
                            {
                            }
                            column(Sales_Comment_Line_Comment;Comment)
                            {
                            }
                            column(Sales_Comment_Line_Document_Type;"Document Type")
                            {
                            }
                            column(Sales_Comment_Line_No_;"No.")
                            {
                            }
                            column(Sales_Comment_Line_Document_Line_No_;"Document Line No.")
                            {
                            }
                            column(Sales_Comment_Line_Line_No_;"Line No.")
                            {
                            }
                        }
                    }

                    trigger OnAfterGetRecord()
                    begin
                        CurrReport.PageNo := 1;
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number,1,1 + Abs(NoCopies));
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                      TempLocation.Find('-')
                    else
                      TempLocation.Next;

                    if not AnySalesLinesThisLocation(TempLocation.Code) then
                      CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,TempLocation.Count);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Salesperson Code" = '' then
                  Clear(SalesPurchPerson)
                else
                  SalesPurchPerson.Get("Salesperson Code");

                if "Shipment Method Code" = '' then
                  Clear(ShipmentMethod)
                else
                  ShipmentMethod.Get("Shipment Method Code");

                if "Payment Terms Code" = '' then
                  Clear(PaymentTerms)
                else
                  PaymentTerms.Get("Payment Terms Code");

                FormatAddress.SalesHeaderBillTo(Address,"Sales Header");
                FormatAddress.SalesHeaderShipTo(ShipToAddress,ShipToAddress,"Sales Header");
                CurrReport.PageNo := 1;
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
                        ApplicationArea = Basic;
                        Caption = 'Number of Copies';
                        MaxValue = 9;
                        MinValue = 0;
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

    trigger OnPreReport()
    begin
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
          SalesSetup."logo position on documents"::"No Logo":
            ;
          SalesSetup."logo position on documents"::Left:
            begin
              CompanyInfo.Get;
              CompanyInfo.CalcFields(Picture);
            end;
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
    end;

    var
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        Item: Record Item;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        TempLocation: Record Location temporary;
        TrackSpec2: Record "Tracking Specification";
        SalesSetup: Record "Sales & Receivables Setup";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        Address: array [8] of Text[50];
        ShipToAddress: array [8] of Text[50];
        AnySerialNos: Boolean;
        NoCopies: Integer;
        Text000: label 'No Location Code';
        EmptyStringCaptionLbl: label 'Picked';
        Sales_Header___Order_Date_CaptionLbl: label 'Order Date:';
        Sales_Header___No__CaptionLbl: label 'Order Number:';
        CurrReport_PAGENOCaptionLbl: label 'Page:';
        Sales_Line__Outstanding_Quantity_CaptionLbl: label 'Back Ordered';
        Sales_Header___Sell_to_Customer_No__CaptionLbl: label 'Customer No:';
        Sales_Header___Shipment_Date_CaptionLbl: label 'Shipment Date:';
        SalesPurchPerson_NameCaptionLbl: label 'Salesperson:';
        Sales_Line_QuantityCaptionLbl: label 'Quantity Ordered';
        Ship_To_CaptionLbl: label 'Ship To:';
        Picking_List_by_OrderCaptionLbl: label 'Picking List by Order';
        Sales_Line__No__CaptionLbl: label 'Item No.';
        ShipmentMethod_DescriptionCaptionLbl: label 'Ship Via:';
        PaymentTerms_DescriptionCaptionLbl: label 'Terms:';
        Item__Shelf_No__CaptionLbl: label 'Shelf/Bin No.';
        TempLocation_CodeCaptionLbl: label 'Location:';
        Sold_To_CaptionLbl: label 'Sold To:';


    procedure AnySalesLinesThisLocation(LocationCode: Code[10]): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        with SalesLine2 do begin
          SetCurrentkey(Type,"No.","Variant Code","Drop Shipment","Location Code","Document Type");
          SetRange("Document Type","Sales Header"."Document Type");
          SetRange("Document No.","Sales Header"."No.");
          SetRange("Location Code",LocationCode);
          SetRange(Type,Type::Item);
          exit(FindFirst);
        end;
    end;
}

