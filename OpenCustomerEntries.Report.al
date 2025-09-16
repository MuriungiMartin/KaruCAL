#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10053 "Open Customer Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Open Customer Entries.rdlc';
    Caption = 'Open Customer Entries';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Customer;Customer)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name","Customer Posting Group","Currency Code","Payment Terms Code";
            column(ReportForNavId_6836; 6836)
            {
            }
            column(Open_Customer_Entries_;'Open Customer Entries')
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
            column(Subtitle;Subtitle)
            {
            }
            column(PrintAmountsInLocal;PrintAmountsInLocal)
            {
            }
            column(filterstring;FilterString)
            {
            }
            column(filterstring2;FilterString2)
            {
            }
            column(Customer_TABLECAPTION__________FilterString;Customer.TableCaption + ': ' + FilterString)
            {
            }
            column(Cust__Ledger_Entry__TABLECAPTION__________FilterString2;"Cust. Ledger Entry".TableCaption + ': ' + FilterString2)
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
            column(CustomerBlockedText;CustomerBlockedText)
            {
            }
            column(Cust__Ledger_Entry___Remaining_Amt___LCY__;"Cust. Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(Customer_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Customer_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Customer_Currency_Filter;"Currency Filter")
            {
            }
            column(Customer_Date_Filter;"Date Filter")
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control9Caption;CaptionClassTranslate('101,1,' + Text003))
            {
            }
            column(Customer__No__Caption;Customer__No__CaptionLbl)
            {
            }
            column(DocumentCaption;DocumentCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__On_Hold_Caption;"Cust. Ledger Entry".FieldCaption("On Hold"))
            {
            }
            column(Cust__Ledger_Entry__Posting_Date_Caption;"Cust. Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(Cust__Ledger_Entry__Document_Type_Caption;Cust__Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Cust__Ledger_Entry_DescriptionCaption;"Cust. Ledger Entry".FieldCaption(Description))
            {
            }
            column(Cust__Ledger_Entry__Due_Date_Caption;"Cust. Ledger Entry".FieldCaption("Due Date"))
            {
            }
            column(RemainAmountToPrintCaption;RemainAmountToPrintCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Document_No__Caption;Cust__Ledger_Entry__Document_No__CaptionLbl)
            {
            }
            column(OverDueDaysCaption;OverDueDaysCaptionLbl)
            {
            }
            column(Cust__Ledger_Entry__Currency_Code_Caption;"Cust. Ledger Entry".FieldCaption("Currency Code"))
            {
            }
            column(Cust__Ledger_Entry__Remaining_Amount_Caption;"Cust. Ledger Entry".FieldCaption("Remaining Amount"))
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
            column(Report_Total_Amount_Due___Caption;CaptionClassTranslate('101,0,' + Text004))
            {
            }
            dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
            {
                DataItemLink = "Customer No."=field("No."),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter"),"Currency Code"=field("Currency Filter"),"Posting Date"=field("Date Filter");
                DataItemTableView = sorting("Customer No.",Open,Positive,"Due Date") where(Open=const(true));
                RequestFilterFields = "Document Type","On Hold";
                column(ReportForNavId_8503; 8503)
                {
                }
                column(Cust__Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Cust__Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(Cust__Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Cust__Ledger_Entry_Description;Description)
                {
                }
                column(Cust__Ledger_Entry__Due_Date_;"Due Date")
                {
                }
                column(RemainAmountToPrint;RemainAmountToPrint)
                {
                }
                column(Cust__Ledger_Entry__On_Hold_;"On Hold")
                {
                }
                column(OverDueDays;OverDueDays)
                {
                }
                column(Cust__Ledger_Entry__Currency_Code_;"Currency Code")
                {
                }
                column(Cust__Ledger_Entry__Remaining_Amount_;"Remaining Amount")
                {
                }
                column(Cust__Ledger_Entry__Cust__Ledger_Entry___Customer_No__;"Cust. Ledger Entry"."Customer No.")
                {
                }
                column(Customer__No___Control40;Customer."No.")
                {
                }
                column(RemainAmountToPrint_Control41;RemainAmountToPrint)
                {
                }
                column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                {
                }
                column(Cust__Ledger_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                {
                }
                column(Customer_Total_Amount_DueCaption;Customer_Total_Amount_DueCaptionLbl)
                {
                }
                column(Control1020001Caption;CaptionClassTranslate(GetCurrencyCaptionCode(Customer."Currency Code")))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Remaining Amount","Remaining Amt. (LCY)");
                    if (ToDate > "Due Date") and ("Remaining Amount" > 0) then
                      OverDueDays := ToDate - "Due Date"
                    else
                      OverDueDays := 0;

                    if PrintAmountsInLocal then begin
                      if "Currency Code" = Customer."Currency Code" then
                        RemainAmountToPrint := "Remaining Amount"
                      else
                        if Customer."Currency Code" = '' then
                          RemainAmountToPrint := "Remaining Amt. (LCY)"
                        else
                          RemainAmountToPrint :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                DateToConvertCurrency,
                                "Currency Code",
                                Customer."Currency Code",
                                "Remaining Amount"),
                              Currency."Amount Rounding Precision");
                    end else
                      RemainAmountToPrint := "Remaining Amt. (LCY)"
                end;

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Remaining Amt. (LCY)",RemainAmountToPrint);
                    if ToDate = 0D then
                      DateToConvertCurrency := WorkDate
                    else begin
                      SetRange("Due Date",0D,ToDate);
                      DateToConvertCurrency := ToDate;
                    end;

                    if GetFilter("Posting Date") <> '' then
                      Copyfilter("Posting Date","Date Filter");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GetCurrencyRecord(Currency,"Currency Code");

                if Blocked <> Blocked::" " then
                  CustomerBlockedText := StrSubstNo(Text1020000,Blocked)
                else
                  CustomerBlockedText := '';
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Cust. Ledger Entry"."Remaining Amt. (LCY)");
                if ToDate <> 0D then
                  Subtitle := Text000 + ' ' + Format(ToDate,0,4) + ')';
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
                    field(ToDate;ToDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(PrintAmountsInLocal;PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Amounts in Customer''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if amounts are printed in the customer''s currency. Clear the check box to print all amounts in US dollars.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            if ToDate = 0D then
              ToDate := WorkDate;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
        GLSetup.Get;
        FilterString := Customer.GetFilters;
        FilterString2 := "Cust. Ledger Entry".GetFilters;
    end;

    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        FilterString: Text;
        FilterString2: Text;
        CustomerBlockedText: Text[80];
        Subtitle: Text[126];
        PrintAmountsInLocal: Boolean;
        DateToConvertCurrency: Date;
        ToDate: Date;
        OverDueDays: Integer;
        RemainAmountToPrint: Decimal;
        CompanyInformation: Record "Company Information";
        Text000: label '(Open Entries Due as of';
        Text1020000: label ' *** Customer is Blocked for %1 processing ***';
        Text002: label 'Amount due is in %1';
        Text003: label 'Amounts are in the customer''s local currency (report totals are in %1).';
        Text004: label 'Report Total Amount Due (%1)';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Customer__No__CaptionLbl: label 'Customer';
        DocumentCaptionLbl: label 'Document';
        Cust__Ledger_Entry__Document_Type_CaptionLbl: label 'Type';
        RemainAmountToPrintCaptionLbl: label 'Amount Due';
        Cust__Ledger_Entry__Document_No__CaptionLbl: label 'Number';
        OverDueDaysCaptionLbl: label 'Days Overdue';
        Phone_CaptionLbl: label 'Phone:';
        Contact_CaptionLbl: label 'Contact:';
        Customer_Total_Amount_DueCaptionLbl: label 'Customer Total Amount Due';

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
            exit('101,1,' + Text002);

          GetCurrencyRecord(Currency,CurrencyCode);
          exit('101,4,' + StrSubstNo(Text002,Currency.Description));
        end;
        exit('');
    end;
}

