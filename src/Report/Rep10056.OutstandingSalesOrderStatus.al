#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10056 "Outstanding Sales Order Status"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Outstanding Sales Order Status.rdlc';
    Caption = 'Outstanding Sales Order Status';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer;Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name",Priority;
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Outstanding_Sales_Order_Status_;'Outstanding Sales Order Status')
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
            column(PrintAmountsInLocal;PrintAmountsInLocal)
            {
            }
            column(PrintAmountsInLocal_Control1020002;PrintAmountsInLocal)
            {
            }
            column(FilterString;FilterString)
            {
            }
            column(MyGroupNo;MyGroupNo)
            {
            }
            column(OnlyOnePerPage;OnlyOnePerPage)
            {
            }
            column(PeriodText;PeriodText)
            {
            }
            column(Customer_TABLECAPTION__________FilterString;Customer.TableCaption + ': ' + FilterString)
            {
            }
            column(Customer__No__;"No.")
            {
            }
            column(Customer_Name;Name)
            {
            }
            column(Customer__Phone_No__;"Phone No.")
            {
            }
            column(Customer_Contact;Contact)
            {
            }
            column(OutstandingExclTax__;"OutstandingExclTax$")
            {
            }
            column(Customer_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(For_delivery_in_the_periodCaption;For_delivery_in_the_periodCaptionLbl)
            {
            }
            column(Control11Caption;CaptionClassTranslate('101,1,' + Text002))
            {
            }
            column(Customer__No__Caption;Customer__No__CaptionLbl)
            {
            }
            column(SalesHeader__Order_Date_Caption;SalesHeader__Order_Date_CaptionLbl)
            {
            }
            column(QuantityCaption;QuantityCaptionLbl)
            {
            }
            column(SalesHeader__No__Caption;SalesHeader__No__CaptionLbl)
            {
            }
            column(ExpectedCaption;ExpectedCaptionLbl)
            {
            }
            column(Sales_Line_DescriptionCaption;"Sales Line".FieldCaption(Description))
            {
            }
            column(Sales_Line_QuantityCaption;Sales_Line_QuantityCaptionLbl)
            {
            }
            column(Remaining_Back_OrderCaption;Remaining_Back_OrderCaptionLbl)
            {
            }
            column(Sales_Line__Unit_Price_Caption;"Sales Line".FieldCaption("Unit Price"))
            {
            }
            column(OutstandExclInvDisc_Control45Caption;OutstandExclInvDisc_Control45CaptionLbl)
            {
            }
            column(Sales_Line_TypeCaption;"Sales Line".FieldCaption(Type))
            {
            }
            column(Sales_Line__No__Caption;Sales_Line__No__CaptionLbl)
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
            column(Control32Caption;CaptionClassTranslate('101,0,' + Text003))
            {
            }
            dataitem("Sales Line";"Sales Line")
            {
                DataItemLink = "Sell-to Customer No."=field("No."),"Shortcut Dimension 1 Code"=field("Global Dimension 1 Filter"),"Shortcut Dimension 2 Code"=field("Global Dimension 2 Filter");
                DataItemTableView = sorting("Document Type","Document No.","Line No.") where("Document Type"=const(Order),"Outstanding Quantity"=filter(<>0));
                RequestFilterFields = "Shipment Date";
                column(ReportForNavId_2844; 2844)
                {
                }
                column(SalesHeader__No__;SalesHeader."No.")
                {
                }
                column(SalesHeader__Order_Date_;SalesHeader."Order Date")
                {
                }
                column(OutstandExclInvDisc;OutstandExclInvDisc)
                {
                }
                column(Sales_Line__Shipment_Date_;"Shipment Date")
                {
                }
                column(Sales_Line_Type;Type)
                {
                }
                column(Sales_Line__No__;"No.")
                {
                }
                column(Sales_Line_Description;Description)
                {
                }
                column(Sales_Line_Quantity;Quantity)
                {
                }
                column(Sales_Line__Outstanding_Quantity_;"Outstanding Quantity")
                {
                }
                column(BackOrderQuantity;BackOrderQuantity)
                {
                    DecimalPlaces = 0:5;
                }
                column(Sales_Line__Unit_Price_;"Unit Price")
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
                column(Customer__No___Control50;Customer."No.")
                {
                }
                column(OutstandingExclTax_2;OutstandingExclTax)
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
                column(Sales_Line_Sell_to_Customer_No_;"Sell-to Customer No.")
                {
                }
                column(Sales_Line_Shortcut_Dimension_1_Code;"Shortcut Dimension 1 Code")
                {
                }
                column(Sales_Line_Shortcut_Dimension_2_Code;"Shortcut Dimension 2 Code")
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
                    if "Shipment Date" <= WorkDate then
                      BackOrderQuantity := "Outstanding Quantity"
                    else
                      BackOrderQuantity := 0;
                    OutstandingExclTax := ROUND("Outstanding Quantity" * "Line Amount" / Quantity);
                    OutstandExclInvDisc := ROUND("Outstanding Quantity" * "Unit Price");

                    if "Currency Code" = '' then begin
                      "OutstandingExclTax$" := OutstandingExclTax;
                      "OutstandExclInvDisc$" := OutstandExclInvDisc;
                      "UnitPrice($)" := "Unit Price";
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
                      "UnitPrice($)" :=
                        ROUND(
                          CurrExchRate.ExchangeAmtFCYToFCY(
                            WorkDate,
                            "Currency Code",
                            '',
                            "Unit Price"),
                          0.00001);
                    end;

                    if PrintAmountsInLocal then begin
                      if Customer."Currency Code" = '' then begin
                        OutstandingExclTax := "OutstandingExclTax$";
                        OutstandExclInvDisc := "OutstandExclInvDisc$";
                        "Unit Price" := "UnitPrice($)";
                      end else
                        if Customer."Currency Code" <> "Currency Code" then begin
                          OutstandingExclTax :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                WorkDate,
                                "Currency Code",
                                Customer."Currency Code",
                                OutstandingExclTax),
                              Currency."Amount Rounding Precision");
                          OutstandExclInvDisc :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                WorkDate,
                                "Currency Code",
                                Customer."Currency Code",
                                OutstandExclInvDisc),
                              Currency."Amount Rounding Precision");
                          "Unit Price" :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                WorkDate,
                                "Currency Code",
                                Customer."Currency Code",
                                "Unit Price"),
                              Currency."Unit-Amount Rounding Precision");
                        end;
                    end else begin
                      OutstandingExclTax := "OutstandingExclTax$";
                      OutstandExclInvDisc := "OutstandExclInvDisc$";
                      "Unit Price" := "UnitPrice($)";
                    end;

                    SalesHeader.Get("Document Type","Document No.");
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals(OutstandExclInvDisc,OutstandingExclTax,
                      "OutstandExclInvDisc$","OutstandingExclTax$");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GetCurrencyRecord(Currency,"Currency Code");
                CurrReport.NewPagePerRecord(OnlyOnePerPage);
                if OnlyOnePerPage then
                  MyGroupNo := MyGroupNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("OutstandingExclTax$");
                MyGroupNo := 1;
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
                    field(PrintAmountsInCustCurrency;PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Amounts in Customer''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if amounts are printed in the customer''s currency. Clear the check box to print all amounts in US dollars.';
                    }
                    field(OnlyOnePerPage;OnlyOnePerPage)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Page per Customer';
                        ToolTip = 'Specifies if each customer''s information is printed on a new page if you have chosen two or more customers to be included in the report.';
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
        FilterString := Customer.GetFilters;
        PeriodText := "Sales Line".GetFilter("Shipment Date");
    end;

    var
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
        "UnitPrice($)": Decimal;
        PrintAmountsInLocal: Boolean;
        OnlyOnePerPage: Boolean;
        SalesHeader: Record "Sales Header";
        CompanyInformation: Record "Company Information";
        Text001: label 'Currency: %1';
        Text002: label 'Amounts are in the customer''s local currency (report totals are in %1).';
        Text003: label 'Report Total (%1)';
        MyGroupNo: Integer;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        For_delivery_in_the_periodCaptionLbl: label 'For delivery in the period';
        Customer__No__CaptionLbl: label 'Customer';
        SalesHeader__Order_Date_CaptionLbl: label 'Order Date';
        QuantityCaptionLbl: label 'Quantity';
        SalesHeader__No__CaptionLbl: label 'PO Number';
        ExpectedCaptionLbl: label 'Expected';
        Sales_Line_QuantityCaptionLbl: label 'Ordered';
        Remaining_Back_OrderCaptionLbl: label 'Remaining Back Order';
        OutstandExclInvDisc_Control45CaptionLbl: label 'Remaining Amount';
        Sales_Line__No__CaptionLbl: label 'Item';
        BackOrderQuantityCaptionLbl: label 'Back Order';
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

