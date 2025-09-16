#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10096 "Outstanding Purch.Order Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Outstanding Purch.Order Status.rdlc';
    Caption = 'Outstanding Purch.Order Status';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name",Priority;
            column(ReportForNavId_3182; 3182)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(TIME;Time)
            {
            }
            column(CompanyInformation_Name;CompanyInformation.Name)
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(USERID;UserId)
            {
            }
            column(OnlyOnePerPage;OnlyOnePerPage)
            {
            }
            column(For_delivery_in_the_period_____PeriodText______;'For delivery in the period ' + PeriodText + '.')
            {
            }
            column(PeriodText;PeriodText)
            {
            }
            column(PrintAmountsInLocal;PrintAmountsInLocal)
            {
            }
            column(Vendor_TABLECAPTION__________FilterString;Vendor.TableCaption + ': ' + FilterString)
            {
            }
            column(FilterString;FilterString)
            {
            }
            column(Vendor__No__;"No.")
            {
            }
            column(Vendor_Name;Name)
            {
            }
            column(Vendor__Phone_No__;"Phone No.")
            {
            }
            column(Vendor_Contact;Contact)
            {
            }
            column(OutstandingExclTax__;"OutstandingExclTax$")
            {
            }
            column(Vendor_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Outstanding_Purchase_Order_StatusCaption;Outstanding_Purchase_Order_StatusCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control11Caption;CaptionClassTranslate('101,1,' + Text004))
            {
            }
            column(VendorCaption;VendorCaptionLbl)
            {
            }
            column(PurchaseHeader__Order_Date_Caption;PurchaseHeader__Order_Date_CaptionLbl)
            {
            }
            column(QuantityCaption;QuantityCaptionLbl)
            {
            }
            column(Purchase_Line__Document_No__Caption;Purchase_Line__Document_No__CaptionLbl)
            {
            }
            column(Expected_Type_ItemCaption;Expected_Type_ItemCaptionLbl)
            {
            }
            column(Purchase_Line_DescriptionCaption;"Purchase Line".FieldCaption(Description))
            {
            }
            column(Purchase_Line_QuantityCaption;Purchase_Line_QuantityCaptionLbl)
            {
            }
            column(Purchase_Line__Outstanding_Quantity_Caption;Purchase_Line__Outstanding_Quantity_CaptionLbl)
            {
            }
            column(Purchase_Line__Unit_Cost_Caption;"Purchase Line".FieldCaption("Unit Cost"))
            {
            }
            column(OutstandExclInvDisc_Control45Caption;OutstandExclInvDisc_Control45CaptionLbl)
            {
            }
            column(Purchase_Line_TypeCaption;"Purchase Line".FieldCaption(Type))
            {
            }
            column(Purchase_Line__No__Caption;Purchase_Line__No__CaptionLbl)
            {
            }
            column(BackOrderQuantityCaption;BackOrderQuantityCaptionLbl)
            {
            }
            column(Phone_Caption;Phone_CaptionLbl)
            {
            }
            column(Contact_Caption;Contact_CaptionLbl)
            {
            }
            column(Control1020000Caption;CaptionClassTranslate(GetCurrencyCaptionCode("Currency Code")))
            {
            }
            column(Control32Caption;CaptionClassTranslate('101,0,' + Text005))
            {
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemLink = "Buy-from Vendor No."=field("No."),"Shortcut Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Document Type","Document No.","Line No.") where("Document Type"=const(Order),"Outstanding Quantity"=filter(<>0));
                RequestFilterFields = "Expected Receipt Date";
                column(ReportForNavId_6547; 6547)
                {
                }
                column(Purchase_Line__Document_No__;"Document No.")
                {
                }
                column(PurchaseHeader__Order_Date_;PurchaseHeader."Order Date")
                {
                }
                column(OutstandExclInvDisc;OutstandExclInvDisc)
                {
                }
                column(Purchase_Line__Expected_Receipt_Date_;"Expected Receipt Date")
                {
                }
                column(Purchase_Line_Type;Type)
                {
                }
                column(Purchase_Line__No__;"No.")
                {
                }
                column(Purchase_Line_Description;Description)
                {
                }
                column(Purchase_Line_Quantity;Quantity)
                {
                }
                column(Purchase_Line__Outstanding_Quantity_;"Outstanding Quantity")
                {
                }
                column(BackOrderQuantity;BackOrderQuantity)
                {
                }
                column(Purchase_Line__Unit_Cost_;"Unit Cost")
                {
                }
                column(OutstandExclInvDisc_Control45;OutstandExclInvDisc)
                {
                }
                column(OutstandExclInvDisc_Control46;OutstandExclInvDisc)
                {
                }
                column(OutstandingExclTax___OutstandExclInvDisc;OutstandingExclTax - OutstandExclInvDisc)
                {
                }
                column(OutstandExclInvDisc_Control1020004;OutstandExclInvDisc)
                {
                }
                column(Vendor__No___Control50;Vendor."No.")
                {
                }
                column(OutstandingExclTax;OutstandingExclTax)
                {
                }
                column(Purchase_Line_Document_Type;"Document Type")
                {
                }
                column(Purchase_Line_Line_No_;"Line No.")
                {
                }
                column(Purchase_Line_Buy_from_Vendor_No_;"Buy-from Vendor No.")
                {
                }
                column(Purchase_Line_Shortcut_Dimension_1_Code;"Shortcut Dimension 1 Code")
                {
                }
                column(Purchase_Line_Shortcut_Dimension_2_Code;"Shortcut Dimension 2 Code")
                {
                }
                column(TransferredCaption;TransferredCaptionLbl)
                {
                }
                column(TransferredCaption_Control47;TransferredCaption_Control47Lbl)
                {
                }
                column(Line_and_Invoice_DiscountsCaption;Line_and_Invoice_DiscountsCaptionLbl)
                {
                }
                column(TotalCaption;TotalCaptionLbl)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if "Expected Receipt Date" <= WorkDate then
                      BackOrderQuantity := "Outstanding Quantity"
                    else
                      BackOrderQuantity := 0;
                    OutstandingExclTax := ROUND("Outstanding Quantity" * "Line Amount" / Quantity);
                    OutstandExclInvDisc := ROUND("Outstanding Quantity" * "Unit Cost");

                    if "Currency Code" = '' then begin
                      "OutstandingExclTax$" := OutstandingExclTax;
                      "OutstandExclInvDisc$" := OutstandExclInvDisc;
                      "UnitCost($)" := "Unit Cost";
                    end else begin
                      "OutstandingExclTax$" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            WorkDate,
                            "Currency Code",
                            '',
                            OutstandingExclTax));
                      "OutstandExclInvDisc$" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            WorkDate,
                            "Currency Code",
                            '',
                            OutstandExclInvDisc));
                      "UnitCost($)" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            WorkDate,
                            "Currency Code",
                            '',
                            "Unit Cost"),
                          0.00001);
                    end;

                    if PrintAmountsInLocal then begin
                      if Vendor."Currency Code" = '' then begin
                        OutstandingExclTax := "OutstandingExclTax$";
                        OutstandExclInvDisc := "OutstandExclInvDisc$";
                        "Unit Cost" := "UnitCost($)";
                      end else
                        if Vendor."Currency Code" <> "Currency Code" then begin
                          OutstandingExclTax :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                WorkDate,
                                "Currency Code",
                                Vendor."Currency Code",
                                OutstandingExclTax),
                              Currency."Amount Rounding Precision");
                          OutstandExclInvDisc :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                WorkDate,
                                "Currency Code",
                                Vendor."Currency Code",
                                OutstandExclInvDisc),
                              Currency."Amount Rounding Precision");
                          "Unit Cost" :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                WorkDate,
                                "Currency Code",
                                Vendor."Currency Code",
                                "Unit Cost"),
                              Currency."Unit-Amount Rounding Precision");
                        end;
                    end else begin
                      OutstandingExclTax := "OutstandingExclTax$";
                      OutstandExclInvDisc := "OutstandExclInvDisc$";
                      "Unit Cost" := "UnitCost($)";
                    end;
                    PurchaseHeader.Get("Purchase Line"."Document Type","Purchase Line"."Document No.");
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(OutstandExclInvDisc,OutstandingExclTax,
                      "OutstandExclInvDisc$","OutstandingExclTax$");
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("OutstandingExclTax$");
                CurrReport.NewPagePerRecord := OnlyOnePerPage;
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
                    field(PrintAmountsInLocal;PrintAmountsInLocal)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;
                    }
                    field(OnlyOnePerPage;OnlyOnePerPage)
                    {
                        ApplicationArea = Basic;
                        Caption = 'New Page per Vendor';
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
        CompanyInformation.Get;
        GLSetup.Get;
        FilterString := Vendor.GetFilters;
        PeriodText := "Purchase Line".GetFilter("Expected Receipt Date");
    end;

    var
        PurchaseHeader: Record "Purchase Header";
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        FilterString: Text;
        PeriodText: Text;
        OutstandExclInvDisc: Decimal;
        "OutstandExclInvDisc$": Decimal;
        OutstandingExclTax: Decimal;
        "OutstandingExclTax$": Decimal;
        BackOrderQuantity: Decimal;
        "UnitCost($)": Decimal;
        PrintAmountsInLocal: Boolean;
        OnlyOnePerPage: Boolean;
        CompanyInformation: Record "Company Information";
        Text001: label 'Currency: %1';
        Text004: label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text005: label 'Report Totals (%1)';
        Outstanding_Purchase_Order_StatusCaptionLbl: label 'Outstanding Purchase Order Status';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        VendorCaptionLbl: label 'Vendor';
        PurchaseHeader__Order_Date_CaptionLbl: label 'Order Date';
        QuantityCaptionLbl: label 'Quantity';
        Purchase_Line__Document_No__CaptionLbl: label 'PO Number';
        Expected_Type_ItemCaptionLbl: label 'Expected Type Item';
        Purchase_Line_QuantityCaptionLbl: label 'Ordered';
        Purchase_Line__Outstanding_Quantity_CaptionLbl: label 'Remaining';
        OutstandExclInvDisc_Control45CaptionLbl: label 'Remaining Amount';
        Purchase_Line__No__CaptionLbl: label 'Item';
        BackOrderQuantityCaptionLbl: label 'Back';
        Phone_CaptionLbl: label 'Phone:';
        Contact_CaptionLbl: label 'Contact:';
        TransferredCaptionLbl: label 'Transferred';
        TransferredCaption_Control47Lbl: label 'Transferred';
        Line_and_Invoice_DiscountsCaptionLbl: label 'Line and Invoice Discounts';
        TotalCaptionLbl: label 'Total';

    local procedure GetCurrencyRecord(var Currency: Record Currency;CurrencyCode: Code[10])
    begin
        if CurrencyCode = '' then begin
          Clear(Currency);
          Currency.Description := GLSetup."LCY Code";
          Currency."Amount Rounding Precision" := GLSetup."Amount Rounding Precision";
        end else
          if Currency.Code <> CurrencyCode then
            Currency.Get(CurrencyCode);
    end;

    local procedure GetCurrencyCaptionCode(CurrencyCode: Code[10]): Text[80]
    begin
        if PrintAmountsInLocal then begin
          if CurrencyCode = '' then
            exit('101,1,' + Text001);

          GetCurrencyRecord(Currency,CurrencyCode);
          exit('101,4,' + StrSubstNo(Text001,Currency.Description));
        end;
        exit('');
    end;
}

