#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10093 "Open Vendor Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Open Vendor Entries.rdlc';
    Caption = 'Open Vendor Entries';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(Vendor;Vendor)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name","Vendor Posting Group","Currency Code","Payment Terms Code";
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
            column(Subtitle;Subtitle)
            {
            }
            column(PrintAmountsInLocal;PrintAmountsInLocal)
            {
            }
            column(UseExternalDocNo;UseExternalDocNo)
            {
            }
            column(FilterString;FilterString)
            {
            }
            column(FilterString2;FilterString2)
            {
            }
            column(Document_Number_is______Vendor_Ledger_Entry__FIELDCAPTION__External_Document_No___;'Document Number is ' + "Vendor Ledger Entry".FieldCaption("External Document No."))
            {
            }
            column(Vendor_TABLECAPTION__________FilterString;Vendor.TableCaption + ': ' + FilterString)
            {
            }
            column(Vendor_Ledger_Entry__TABLECAPTION__________FilterString2;"Vendor Ledger Entry".TableCaption + ': ' + FilterString2)
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
            column(VendorBlockedText;VendorBlockedText)
            {
            }
            column(Vendor_Ledger_Entry___Remaining_Amt___LCY__;-"Vendor Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(Vendor_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            column(Vendor_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Vendor_Currency_Filter;"Currency Filter")
            {
            }
            column(Vendor_Date_Filter;"Date Filter")
            {
            }
            column(Open_Vendor_EntriesCaption;Open_Vendor_EntriesCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Control9Caption;CaptionClassTranslate('101,1,' + Text004))
            {
            }
            column(Vendor__No__Caption;Vendor__No__CaptionLbl)
            {
            }
            column(DocumentCaption;DocumentCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Document_Type_Caption;Vendor_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry_DescriptionCaption;"Vendor Ledger Entry".FieldCaption(Description))
            {
            }
            column(Vendor_Ledger_Entry__Due_Date_Caption;"Vendor Ledger Entry".FieldCaption("Due Date"))
            {
            }
            column(RemainAmountToPrintCaption;RemainAmountToPrintCaptionLbl)
            {
            }
            column(DocNoCaption;DocNoCaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__On_Hold_Caption;"Vendor Ledger Entry".FieldCaption("On Hold"))
            {
            }
            column(OverDueDaysCaption;OverDueDaysCaptionLbl)
            {
            }
            column(Remaining_Amount_Caption;Remaining_Amount_CaptionLbl)
            {
            }
            column(Vendor_Ledger_Entry__Currency_Code_Caption;"Vendor Ledger Entry".FieldCaption("Currency Code"))
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
            column(Control31Caption;CaptionClassTranslate('101,0,' + Text005))
            {
            }
            dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
            {
                DataItemLink = "Vendor No."=field("No."),"Global Dimension 1 Code"=field("Global Dimension 1 Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter"),"Currency Code"=field("Currency Filter"),"Posting Date"=field("Date Filter");
                DataItemTableView = sorting("Vendor No.",Open,Positive,"Due Date") where(Open=const(true));
                RequestFilterFields = "Document Type","On Hold";
                column(ReportForNavId_4114; 4114)
                {
                }
                column(Vendor_Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Vendor_Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(DocNo;DocNo)
                {
                }
                column(Vendor_Ledger_Entry_Description;Description)
                {
                }
                column(Vendor_Ledger_Entry__Due_Date_;"Due Date")
                {
                }
                column(RemainAmountToPrint;-RemainAmountToPrint)
                {
                }
                column(Vendor_Ledger_Entry__On_Hold_;"On Hold")
                {
                }
                column(OverDueDays;OverDueDays)
                {
                }
                column(Remaining_Amount_;-"Remaining Amount")
                {
                }
                column(Vendor_Ledger_Entry__Currency_Code_;"Currency Code")
                {
                }
                column(Vendor__No___Control40;Vendor."No.")
                {
                }
                column(RemainAmountToPrint_Control41;-RemainAmountToPrint)
                {
                }
                column(Vendor_Ledger_Entry_Entry_No_;"Entry No.")
                {
                }
                column(Vendor_Ledger_Entry_Vendor_No_;"Vendor No.")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                {
                }
                column(Vendor_Ledger_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                {
                }
                column(Vendor_Total_Amount_DueCaption;Vendor_Total_Amount_DueCaptionLbl)
                {
                }
                column(Control1020001Caption;CaptionClassTranslate(GetCurrencyCaptionCode(Vendor."Currency Code")))
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields("Remaining Amount","Remaining Amt. (LCY)");
                    if (ToDate > "Due Date") and ("Remaining Amount" < 0) then
                      OverDueDays := ToDate - "Due Date"
                    else
                      OverDueDays := 0;

                    if PrintAmountsInLocal then begin
                      if "Currency Code" = Vendor."Currency Code" then
                        RemainAmountToPrint := "Remaining Amount"
                      else
                        if Vendor."Currency Code" = '' then
                          RemainAmountToPrint := "Remaining Amt. (LCY)"
                        else
                          RemainAmountToPrint :=
                            ROUND(
                              CurrExchRate.ExchangeAmtFCYToFCY(
                                DateToConvertCurrency,
                                "Currency Code",
                                Vendor."Currency Code",
                                "Remaining Amount"),
                              Currency."Amount Rounding Precision");
                    end else
                      RemainAmountToPrint := "Remaining Amt. (LCY)";

                    if UseExternalDocNo then
                      DocNo := "External Document No."
                    else
                      DocNo := "Document No.";
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
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GetCurrencyRecord(Currency,"Currency Code");

                if Blocked <> Blocked::" " then
                  VendorBlockedText := StrSubstNo(Text001,Blocked)
                else
                  VendorBlockedText := '';
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals("Vendor Ledger Entry"."Remaining Amt. (LCY)");
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
                    field(EndingDate;ToDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Ending Date';
                        ToolTip = 'Specifies the date to which the report or batch job processes information.';
                    }
                    field(PrintAmountsInVendorsCurrency;PrintAmountsInLocal)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Print Amounts in Vendor''s Currency';
                        MultiLine = true;
                        ToolTip = 'Specifies if amounts are printed in the vendor''s currency. Clear the check box to print all amounts in US dollars.';
                    }
                    field(UseExternalDocNo;UseExternalDocNo)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Use External Doc. No.';
                        ToolTip = 'Specifies if you want to print the vendor''s document numbers, such as the invoice number, on all transactions. Clear this check box to print only internal document numbers.';
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
        FilterString := Vendor.GetFilters;
        FilterString2 := "Vendor Ledger Entry".GetFilters;
    end;

    var
        Currency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
        FilterString: Text;
        FilterString2: Text;
        VendorBlockedText: Text[80];
        Subtitle: Text[126];
        PrintAmountsInLocal: Boolean;
        DateToConvertCurrency: Date;
        ToDate: Date;
        OverDueDays: Integer;
        RemainAmountToPrint: Decimal;
        CompanyInformation: Record "Company Information";
        UseExternalDocNo: Boolean;
        DocNo: Code[50];
        Text000: label '(Open Entries Due as of';
        Text001: label '*** Vendor is Blocked for %1 processing ***';
        Text003: label 'Amount due is in %1';
        Text004: label 'Amounts are in the vendor''s local currency (report totals are in %1).';
        Text005: label 'Report Total Amount Due (%1)';
        Open_Vendor_EntriesCaptionLbl: label 'Open Vendor Entries';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Vendor__No__CaptionLbl: label 'Vendor';
        DocumentCaptionLbl: label 'Document';
        DateCaptionLbl: label 'Date';
        Vendor_Ledger_Entry__Document_Type_CaptionLbl: label 'Type';
        RemainAmountToPrintCaptionLbl: label 'Amount Due';
        DocNoCaptionLbl: label 'Number';
        OverDueDaysCaptionLbl: label 'Days Overdue';
        Remaining_Amount_CaptionLbl: label 'Remaining Amount';
        Phone_CaptionLbl: label 'Phone:';
        Contact_CaptionLbl: label 'Contact:';
        Vendor_Total_Amount_DueCaptionLbl: label 'Vendor Total Amount Due';

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
            exit('101,1,' + Text003);

          GetCurrencyRecord(Currency,CurrencyCode);
          exit('101,4,' + StrSubstNo(Text003,Currency.Description));
        end;
        exit('');
    end;
}

