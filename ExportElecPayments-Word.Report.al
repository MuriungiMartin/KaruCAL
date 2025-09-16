#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 11383 "ExportElecPayments - Word"
{
    RDLCLayout = './Layouts/ExportElecPaymentsWord.rdlc';
    WordLayout = './Layouts/ExportElecPayments - Word.docx';
    Caption = 'ExportElecPayments - Word';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name","Journal Batch Name","Line No.") where("Bank Payment Type"=filter("Electronic Payment"|"Electronic Payment-IAT"),"Document Type"=filter(Payment|Refund));
            RequestFilterFields = "Journal Template Name","Journal Batch Name";
            column(ReportForNavId_7024; 7024)
            {
            }
            column(Gen__Journal_Line_Journal_Template_Name;"Journal Template Name")
            {
            }
            column(Gen__Journal_Line_Journal_Batch_Name;"Journal Batch Name")
            {
            }
            column(Gen__Journal_Line_Line_No_;"Line No.")
            {
            }
            column(Gen__Journal_Line_Applies_to_ID;"Applies-to ID")
            {
            }
            dataitem(LetterText;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_1020010; 1020010)
                {
                }
                column(GreetingText;GreetingLbl)
                {
                }
                column(ClosingText;ClosingLbl)
                {
                }
                column(BodyText;BodyLbl)
                {
                }
                column(CompanyAddress_1;CompanyAddress[1])
                {
                }
                column(CompanyAddress_2;CompanyAddress[2])
                {
                }
                column(CompanyAddress_3;CompanyAddress[3])
                {
                }
                column(CompanyAddress_4;CompanyAddress[4])
                {
                }
                column(CompanyAddress_5;CompanyAddress[5])
                {
                }
                column(CompanyAddress_6;CompanyAddress[6])
                {
                }
                column(CompanyAddress_7;CompanyAddress[7])
                {
                }
                column(CompanyAddress_8;CompanyAddress[8])
                {
                }
                column(CompanyLegalOffice;CompanyInfo.GetLegalOffice)
                {
                }
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
                    column(CopyTxt;CopyTxt)
                    {
                    }
                    column(PayeeAddress_1_;PayeeAddress[1])
                    {
                    }
                    column(PayeeAddress_2_;PayeeAddress[2])
                    {
                    }
                    column(PayeeAddress_3_;PayeeAddress[3])
                    {
                    }
                    column(PayeeAddress_4_;PayeeAddress[4])
                    {
                    }
                    column(PayeeAddress_5_;PayeeAddress[5])
                    {
                    }
                    column(PayeeAddress_6_;PayeeAddress[6])
                    {
                    }
                    column(PayeeAddress_7_;PayeeAddress[7])
                    {
                    }
                    column(PayeeAddress_8_;PayeeAddress[8])
                    {
                    }
                    column(PayeeType;Format(PayeeType))
                    {
                    }
                    column(PayeeNo;PayeeNo)
                    {
                    }
                    column(Gen__Journal_Line___Document_No__;"Gen. Journal Line"."Document No.")
                    {
                    }
                    column(SettleDate;Format(SettleDate,0,4))
                    {
                    }
                    column(CurrReport_PAGENO;CurrReport.PageNo)
                    {
                    }
                    column(ExportAmount;-ExportAmount)
                    {
                    }
                    column(PayeeBankTransitNo;PayeeBankTransitNo)
                    {
                    }
                    column(PayeeBankAccountNo;PayeeBankAccountNo)
                    {
                    }
                    column(myNumber;CopyLoop.Number)
                    {
                    }
                    column(myBal;"Gen. Journal Line"."Bal. Account No.")
                    {
                    }
                    column(mypostingdate;"Gen. Journal Line"."Posting Date")
                    {
                    }
                    column(Gen__Journal_Line___Applies_to_Doc__No__;"Gen. Journal Line"."Applies-to Doc. No.")
                    {
                    }
                    column(myType;myType)
                    {
                    }
                    column(AmountPaid;AmountPaid)
                    {
                    }
                    column(DiscountTaken;DiscountTaken)
                    {
                    }
                    column(VendLedgEntry__Remaining_Amt___LCY__;-VendLedgEntry."Remaining Amt. (LCY)")
                    {
                    }
                    column(VendLedgEntry__Document_Date_;Format(VendLedgEntry."Document Date",0,4))
                    {
                    }
                    column(VendLedgEntry__External_Document_No__;VendLedgEntry."External Document No.")
                    {
                    }
                    column(VendLedgEntry__Document_Type_;VendLedgEntry."Document Type")
                    {
                        OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                    }
                    column(AmountPaid_Control57;AmountPaid)
                    {
                    }
                    column(DiscountTaken_Control58;DiscountTaken)
                    {
                    }
                    column(CustLedgEntry__Remaining_Amt___LCY__;-CustLedgEntry."Remaining Amt. (LCY)")
                    {
                    }
                    column(CustLedgEntry__Document_Date_;CustLedgEntry."Document Date")
                    {
                    }
                    column(CustLedgEntry__Document_No__;CustLedgEntry."Document No.")
                    {
                    }
                    column(CustLedgEntry__Document_Type_;CustLedgEntry."Document Type")
                    {
                        OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                    }
                    column(PageLoop_Number;Number)
                    {
                    }
                    column(REMITTANCE_ADVICECaption;REMITTANCE_ADVICECaptionLbl)
                    {
                    }
                    column(To_Caption;To_CaptionLbl)
                    {
                    }
                    column(Remittance_Advice_Number_Caption;Remittance_Advice_Number_CaptionLbl)
                    {
                    }
                    column(Settlement_Date_Caption;Settlement_Date_CaptionLbl)
                    {
                    }
                    column(Page_Caption;Page_CaptionLbl)
                    {
                    }
                    column(ExportAmountCaption;ExportAmountCaptionLbl)
                    {
                    }
                    column(PayeeBankTransitNoCaption;PayeeBankTransitNoCaptionLbl)
                    {
                    }
                    column(Deposited_In_Caption;Deposited_In_CaptionLbl)
                    {
                    }
                    column(PayeeBankAccountNoCaption;PayeeBankAccountNoCaptionLbl)
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_Type_Caption;"Vendor Ledger Entry".FieldCaption("Document Type"))
                    {
                    }
                    column(Cust__Ledger_Entry__Document_No__Caption;"Cust. Ledger Entry".FieldCaption("Document No."))
                    {
                    }
                    column(Vendor_Ledger_Entry__Document_Date_Caption;"Vendor Ledger Entry".FieldCaption("Document Date"))
                    {
                    }
                    column(Remaining_Amt___LCY___Control36Caption;Remaining_Amt___LCY___Control36CaptionLbl)
                    {
                    }
                    column(DiscountTaken_Control38Caption;DiscountTaken_Control38CaptionLbl)
                    {
                    }
                    column(AmountPaid_Control43Caption;AmountPaid_Control43CaptionLbl)
                    {
                    }
                    dataitem(PrintCompanyAddress;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_1020019; 1020019)
                        {
                        }
                        column(CompanyPicture;CompanyInfo.Picture)
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
                        column(CompanyAddress_7_;CompanyAddress[7])
                        {
                        }
                        column(CompanyAddress_8_;CompanyAddress[8])
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CompanyInfo.Get;
                            CompanyInfo.CalcFields(Picture);
                            FormatAddress.Company(CompanyAddress,CompanyInfo);
                            if CompanyAddress[5] <> '' then
                              CompanyAddress[5] := StrSubstNo(', %1',CompanyAddress[5]);
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not PrintCompany then
                              CurrReport.Break;
                        end;
                    }
                    dataitem("Cust. Ledger Entry";"Cust. Ledger Entry")
                    {
                        DataItemLink = "Applies-to ID"=field("Applies-to ID");
                        DataItemLinkReference = "Gen. Journal Line";
                        DataItemTableView = sorting("Customer No.",Open,Positive,"Due Date","Currency Code") order(descending) where(Open=const(true));
                        column(ReportForNavId_8503; 8503)
                        {
                        }
                        column(Cust__Ledger_Entry__Document_Type_;"Document Type")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_No__;"Document No.")
                        {
                        }
                        column(Cust__Ledger_Entry__Document_Date_;Format("Document Date",0,4))
                        {
                        }
                        column(Remaining_Amt___LCY__;-"Remaining Amt. (LCY)")
                        {
                        }
                        column(DiscountTaken_Control49;DiscountTaken)
                        {
                        }
                        column(AmountPaid_Control50;AmountPaid)
                        {
                        }
                        column(Cust__Ledger_Entry_Entry_No_;"Entry No.")
                        {
                        }
                        column(Cust__Ledger_Entry_Applies_to_ID;"Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CalcFields("Remaining Amt. (LCY)");
                            if ("Pmt. Discount Date" >= SettleDate) and
                               ("Remaining Pmt. Disc. Possible" <> 0) and
                               ((-ExportAmount - TotalAmountPaid) - "Remaining Pmt. Disc. Possible" >= -"Amount to Apply")
                            then begin
                              DiscountTaken := -"Remaining Pmt. Disc. Possible";
                              AmountPaid := -("Amount to Apply" - "Remaining Pmt. Disc. Possible");
                            end else begin
                              DiscountTaken := 0;
                              if (-ExportAmount - TotalAmountPaid) > -"Amount to Apply" then
                                AmountPaid := -"Amount to Apply"
                              else
                                AmountPaid := -ExportAmount - TotalAmountPaid;
                            end;

                            TotalAmountPaid := TotalAmountPaid + AmountPaid;

                            IsSummary := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if "Gen. Journal Line"."Applies-to ID" = '' then
                              CurrReport.Break;

                            if BankAccountIs = Bankaccountis::Acnt then begin
                              if "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."bal. account type"::Customer then
                                CurrReport.Break;
                              SetRange("Customer No.","Gen. Journal Line"."Bal. Account No.");
                            end else begin
                              if "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."account type"::Customer then
                                CurrReport.Break;
                              SetRange("Customer No.","Gen. Journal Line"."Account No.");
                            end;
                        end;
                    }
                    dataitem("Vendor Ledger Entry";"Vendor Ledger Entry")
                    {
                        DataItemLink = "Applies-to ID"=field("Applies-to ID");
                        DataItemLinkReference = "Gen. Journal Line";
                        DataItemTableView = sorting("Vendor No.",Open,Positive,"Due Date","Currency Code") order(descending) where(Open=const(true));
                        column(ReportForNavId_4114; 4114)
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_Type_;"Document Type")
                        {
                        }
                        column(Vendor_Ledger_Entry__External_Document_No__;"External Document No.")
                        {
                        }
                        column(Vendor_Ledger_Entry__Document_Date_;Format("Document Date",0,4))
                        {
                        }
                        column(Remaining_Amt___LCY___Control36;-"Remaining Amt. (LCY)")
                        {
                        }
                        column(DiscountTaken_Control38;DiscountTaken)
                        {
                        }
                        column(AmountPaid_Control43;AmountPaid)
                        {
                        }
                        column(Vendor_Ledger_Entry_Entry_No_;"Entry No.")
                        {
                        }
                        column(Vendor_Ledger_Entry_Applies_to_ID;"Applies-to ID")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CalcFields("Remaining Amt. (LCY)");
                            if ("Pmt. Discount Date" >= SettleDate) and
                               ("Remaining Pmt. Disc. Possible" <> 0) and
                               ((-ExportAmount - TotalAmountPaid) - "Remaining Pmt. Disc. Possible" >= -"Amount to Apply")
                            then begin
                              DiscountTaken := -"Remaining Pmt. Disc. Possible";
                              AmountPaid := -("Amount to Apply" - "Remaining Pmt. Disc. Possible");
                            end else begin
                              DiscountTaken := 0;
                              if (-ExportAmount - TotalAmountPaid) > -"Amount to Apply" then
                                AmountPaid := -"Amount to Apply"
                              else
                                AmountPaid := -ExportAmount - TotalAmountPaid;
                            end;

                            TotalAmountPaid := TotalAmountPaid + AmountPaid;
                            IsSummary := true;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if "Gen. Journal Line"."Applies-to ID" = '' then
                              CurrReport.Break;

                            if BankAccountIs = Bankaccountis::Acnt then begin
                              if "Gen. Journal Line"."Bal. Account Type" <> "Gen. Journal Line"."bal. account type"::Vendor then
                                CurrReport.Break;
                              SetRange("Vendor No.","Gen. Journal Line"."Bal. Account No.");
                            end else begin
                              if "Gen. Journal Line"."Account Type" <> "Gen. Journal Line"."account type"::Vendor then
                                CurrReport.Break;
                              SetRange("Vendor No.","Gen. Journal Line"."Account No.");
                            end;
                        end;
                    }
                    dataitem(CustomerInfo;"Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number=const(1));
                        column(ReportForNavId_1020027; 1020027)
                        {
                        }
                        column(AmountPaid_Customer;AmountPaid)
                        {
                        }
                        column(DiscountTaken_Customer;DiscountTaken)
                        {
                        }
                        column(Cust_Remaining_Amt_LCY;-CustLedgEntry."Remaining Amt. (LCY)")
                        {
                        }
                        column(Cust_Document_Date;Format(CustLedgEntry."Document Date",0,4))
                        {
                        }
                        column(Cust_Document_No;CustLedgEntry."Document No.")
                        {
                        }
                        column(Cust_Document_Type;CustLedgEntry."Document Type")
                        {
                            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                        }

                        trigger OnPreDataItem()
                        begin
                            if (PayeeType <> Payeetype::Customer) or IsSummary then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(VendorInfo;"Integer")
                    {
                        DataItemTableView = sorting(Number) order(ascending) where(Number=const(1));
                        column(ReportForNavId_1020028; 1020028)
                        {
                        }
                        column(Vend_Remaining_Amt_LCY;-VendLedgEntry."Remaining Amt. (LCY)")
                        {
                        }
                        column(Vend_Document_Date;Format(VendLedgEntry."Document Date",0,4))
                        {
                        }
                        column(Vend_External_Document_No;VendLedgEntry."External Document No.")
                        {
                        }
                        column(Vend_Document_Type;VendLedgEntry."Document Type")
                        {
                            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                        }
                        column(AmountPaid_Vendor;AmountPaid)
                        {
                        }
                        column(DiscountTaken_Vendor;DiscountTaken)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if (PayeeType <> Payeetype::Vendor) or IsSummary then
                              CurrReport.Break;
                        end;
                    }
                    dataitem(Unapplied;"Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number=const(1));
                        column(ReportForNavId_6150; 6150)
                        {
                        }
                        column(Text004;Text004Lbl)
                        {
                        }
                        column(AmountPaid_Control65;AmountPaid)
                        {
                        }
                        column(Unapplied_Number;Number)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            AmountPaid := -ExportAmount - TotalAmountPaid;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if TotalAmountPaid >= -ExportAmount then
                              CurrReport.Break;
                        end;
                    }

                    trigger OnPreDataItem()
                    begin
                        myType := PayeeType;// an Integer variable refer to  option type
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CurrReport.PageNo := 1;
                    AmountPaid := SaveAmountPaid;

                    if Number = 1 then // Original
                      Clear(CopyTxt)
                    else
                      CopyTxt := CopyLoopLbl;

                    if "Gen. Journal Line"."Applies-to Doc. No." = '' then
                      Clear(TotalAmountPaid);
                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number,1,NoCopies + 1);
                    SaveAmountPaid := AmountPaid;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Account Type" = "account type"::"Bank Account" then begin
                  BankAccountIs := Bankaccountis::Acnt;
                  if "Account No." <> BankAccount."No." then
                    CurrReport.Skip;
                end else
                  if "Bal. Account Type" = "bal. account type"::"Bank Account" then begin
                    BankAccountIs := Bankaccountis::BalAcnt;
                    if "Bal. Account No." <> BankAccount."No." then
                      CurrReport.Skip;
                  end else
                    CurrReport.Skip;
                if BankAccountIs = Bankaccountis::Acnt then begin
                  ExportAmount := "Amount (LCY)";
                  PayeeNo := "Bal. Account No.";
                  if "Bal. Account Type" = "bal. account type"::Vendor then begin
                    PayeeType := Payeetype::Vendor;
                    Vendor.Get("Bal. Account No.");
                  end else
                    if "Bal. Account Type" = "bal. account type"::Customer then begin
                      PayeeType := Payeetype::Customer;
                      Customer.Get("Bal. Account No.");
                    end else
                      Error(AccountTypeErr,
                        FieldCaption("Bal. Account Type"),Customer.TableCaption,Vendor.TableCaption);
                end else begin
                  ExportAmount := -"Amount (LCY)";
                  PayeeNo := "Account No.";
                  if "Account Type" = "account type"::Vendor then begin
                    PayeeType := Payeetype::Vendor;
                    Vendor.Get("Account No.");
                  end else
                    if "Account Type" = "account type"::Customer then begin
                      PayeeType := Payeetype::Customer;
                      Customer.Get("Account No.");
                    end else
                      Error(AccountTypeErr,
                        FieldCaption("Account Type"),Customer.TableCaption,Vendor.TableCaption);
                end;

                DiscountTaken := 0;
                AmountPaid := 0;
                TotalAmountPaid := 0;
                if PayeeType = Payeetype::Vendor then
                  ProcessVendor("Gen. Journal Line")
                else
                  ProcessCustomer("Gen. Journal Line");

                TotalAmountPaid := AmountPaid;

                if PayeeAddress[5] <> '' then
                  PayeeAddress[5] := StrSubstNo(', %1',PayeeAddress[5]);
            end;

            trigger OnPreDataItem()
            begin
                if PostingDateOption = Postingdateoption::"Skip Lines Which Do Not Match" then
                  SetRange("Posting Date",SettleDate);

                // If we're in preview mode, the items haven't been exported yet - filter appropriately
                if CurrReport.Preview then begin
                  SetRange("Check Exported",false);
                  SetRange("Check Printed",false);
                end else begin
                  SetRange("Check Exported",true);
                  SetRange("Check Printed",true);
                  SetRange("Check Transmitted",false);
                end
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
                    field(BankAccountNo;BankAccount."No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Bank Account No.';
                        TableRelation = "Bank Account";
                        ToolTip = 'Specifies the bank account that the payment is transmitted to.';
                    }
                    field(SettleDate;SettleDate)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Settle Date';
                        ToolTip = 'Specifies the settle date that will be transmitted to the bank. This date will become the posting date for the exported payment journal entries. Transmission should occur two or three banking days before the settle date. Ask your bank for the exact number of days.';
                    }
                    field(PostingDateOpt;PostingDateOption)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'If Posting Date does not match Settle Date:';
                        OptionCaption = 'Change Posting Date To Match,Skip Lines Which Do Not Match';
                        ToolTip = 'Specifies what will occur if the posting date does not match the settle date. The options are to change the posting date to match the entered settle date, or to skip any payment journal lines where the entered posting date does not match the settle date.';
                    }
                    field(NumberOfCopies;NoCopies)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Number of Copies';
                        MaxValue = 9;
                        MinValue = 0;
                        ToolTip = 'Specifies the number of copies of each document (in addition to the original) that you want to print.';
                    }
                    field(PrintCompanyAddress;PrintCompany)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Print Company Address';
                        ToolTip = 'Specifies if your company address is printed at the top of the sheet, because you do not use pre-printed paper. Leave this check box blank to omit your company''s address.';
                    }
                    group(OutputOptions)
                    {
                        Caption = 'Output Options';
                        field(OutputMethod;SupportedOutputMethod)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Output Method';
                            OptionCaption = 'Print,Preview,PDF,Email,Word,XML - RDLC layouts only', Comment='Verbs - to print, to preview, to export to PDF, to email, to export to word, to export to XML (with note that it''s for RDLC layouts only)';
                            ToolTip = 'Specifies how the electronic payment is exported.';

                            trigger OnValidate()
                            begin
                                MapOutputMethod;
                            end;
                        }
                        field(ChosenOutputMethod;ChosenOutputMethod)
                        {
                            ApplicationArea = Basic;
                            Visible = false;
                        }
                    }
                    group(EmailOptions)
                    {
                        Caption = 'Email Options';
                        Visible = ShowPrintRemaining;
                        field(PrintMissingAddresses;PrintRemaining)
                        {
                            ApplicationArea = Basic,Suite;
                            Caption = 'Print remaining statements';
                        }
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            MapOutputMethod;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    var
        "Filter": Text;
    begin
        CompanyInformation.Get;
        Filter := "Gen. Journal Line".GetFilter("Journal Template Name");
        if Filter = '' then begin
          "Gen. Journal Line".FilterGroup(0); // head back to the default filter group and check there.
          Filter := "Gen. Journal Line".GetFilter("Journal Template Name")
        end;
        GenJournalTemplate.Get(Filter);

        if SettleDate = 0D then
          Error(SettleDateErr);

        with BankAccount do begin
          Get("No.");
          TestField(Blocked,false);
          TestField("Currency Code",'');  // local currency only
          TestField("Export Format");
          TestField("Last Remittance Advice No.");
        end;

        GenJournalTemplate.Get("Gen. Journal Line".GetFilter("Journal Template Name"));
        if not GenJournalTemplate."Force Doc. Balance" then
          if not Confirm(CannotVoidQst,true) then
            Error(UserCancelledErr);

        FormatAddress.Company(CompanyAddress,CompanyInformation)
    end;

    var
        AccountTypeErr: label 'For Electronic Payments, the %1 must be %2 or %3.', Comment='%1=Balance account type,%2=Customer table caption,%3=Vendor table caption';
        BankAcctElecPaymentErr: label 'You must have exactly one %1 with %2 checked for %3 %4.', Comment='%1=Bank account table caption,%2=Bank account field caption - use for electronic payments,%3=Vendor/Customer table caption,%4=Vendor/Customer number';
        SettleDateErr: label 'You MUST enter a Settle Date.';
        CopyLoopLbl: label '- COPY';
        CannotVoidQst: label 'Warning:  Transactions cannot be financially voided when Force Doc. Balance is set to No in the Journal Template.  Do you want to continue anyway?';
        UserCancelledErr: label 'Process canceled at user request.';
        REMITTANCE_ADVICECaptionLbl: label 'REMITTANCE ADVICE';
        To_CaptionLbl: label 'To:';
        Remittance_Advice_Number_CaptionLbl: label 'Remittance Advice Number:';
        Settlement_Date_CaptionLbl: label 'Settlement Date:';
        Page_CaptionLbl: label 'Page:';
        ExportAmountCaptionLbl: label 'Deposit Amount:';
        PayeeBankTransitNoCaptionLbl: label 'Bank Transit No:';
        Deposited_In_CaptionLbl: label 'Deposited In:';
        PayeeBankAccountNoCaptionLbl: label 'Bank Account No:';
        Remaining_Amt___LCY___Control36CaptionLbl: label 'Amount Due';
        DiscountTaken_Control38CaptionLbl: label 'Discount Taken';
        AmountPaid_Control43CaptionLbl: label 'Amount Paid';
        Text004Lbl: label 'Unapplied Amount';
        CompanyInformation: Record "Company Information";
        GenJournalTemplate: Record "Gen. Journal Template";
        BankAccount: Record "Bank Account";
        Customer: Record Customer;
        CustBankAccount: Record "Customer Bank Account";
        CustLedgEntry: Record "Cust. Ledger Entry";
        VendBankAccount: Record "Vendor Bank Account";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        FormatAddress: Codeunit "Format Address";
        ExportAmount: Decimal;
        BankAccountIs: Option Acnt,BalAcnt;
        SettleDate: Date;
        PostingDateOption: Option "Change Posting Date To Match","Skip Lines Which Do Not Match";
        NoCopies: Integer;
        CopyTxt: Code[10];
        PrintCompany: Boolean;
        CompanyAddress: array [8] of Text[50];
        PayeeAddress: array [8] of Text[50];
        PayeeType: Option Vendor,Customer;
        PayeeNo: Text;
        PayeeBankTransitNo: Text[30];
        PayeeBankAccountNo: Text[30];
        DiscountTaken: Decimal;
        AmountPaid: Decimal;
        TotalAmountPaid: Decimal;
        myType: Integer;
        SaveAmountPaid: Decimal;
        SupportedOutputMethod: Option Print,Preview,Pdf,Email,Word,Xml;
        [InDataSet]
        ChosenOutputMethod: Integer;
        [InDataSet]
        PrintRemaining: Boolean;
        [InDataSet]
        ShowPrintRemaining: Boolean;
        IsSummary: Boolean;
        GreetingLbl: label 'Hello';
        ClosingLbl: label 'Sincerely';
        BodyLbl: label 'Thank you for your business. Your remittance is attached to this message.';

    local procedure MapOutputMethod()
    var
        CustomLayoutReporting: Codeunit "Custom Layout Reporting";
    begin
        ShowPrintRemaining := (SupportedOutputMethod = Supportedoutputmethod::Email);
        // Map the supported option (shown on the page) to the list of supported output methods
        case SupportedOutputMethod of
          Supportedoutputmethod::Print:
            ChosenOutputMethod := CustomLayoutReporting.GetPrintOption;
          Supportedoutputmethod::Preview:
            ChosenOutputMethod := CustomLayoutReporting.GetPreviewOption;
          Supportedoutputmethod::Pdf:
            ChosenOutputMethod := CustomLayoutReporting.GetPDFOption;
          Supportedoutputmethod::Email:
            ChosenOutputMethod := CustomLayoutReporting.GetEmailOption;
          Supportedoutputmethod::Word:
            ChosenOutputMethod := CustomLayoutReporting.GetWordOption;
          Supportedoutputmethod::Xml:
            ChosenOutputMethod := CustomLayoutReporting.GetXMLOption;
        end;
    end;

    local procedure ProcessVendor(var GenJnlLine: Record "Gen. Journal Line")
    begin
        FormatAddress.Vendor(PayeeAddress,Vendor);
        VendBankAccount.SetRange("Vendor No.",Vendor."No.");
        VendBankAccount.SetRange("Use for Electronic Payments",true);
        if VendBankAccount.Count <> 1 then
          Error(BankAcctElecPaymentErr,
            VendBankAccount.TableCaption,VendBankAccount.FieldCaption("Use for Electronic Payments"),
            Vendor.TableCaption,Vendor."No.");
        VendBankAccount.FindFirst;
        PayeeBankTransitNo := VendBankAccount."Transit No.";
        PayeeBankAccountNo := VendBankAccount."Bank Account No.";
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
          VendLedgEntry.Reset;
          VendLedgEntry.SetCurrentkey("Document No.","Document Type","Vendor No.");
          VendLedgEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
          VendLedgEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
          VendLedgEntry.SetRange("Vendor No.",Vendor."No.");
          VendLedgEntry.SetRange(Open,true);
          VendLedgEntry.FindFirst;
          VendLedgEntry.CalcFields("Remaining Amt. (LCY)");
          if (VendLedgEntry."Pmt. Discount Date" >= SettleDate) and
             (VendLedgEntry."Remaining Pmt. Disc. Possible" <> 0) and
             (-(ExportAmount + VendLedgEntry."Remaining Pmt. Disc. Possible") >= -VendLedgEntry."Amount to Apply")
          then begin
            DiscountTaken := -VendLedgEntry."Remaining Pmt. Disc. Possible";
            AmountPaid := -(VendLedgEntry."Amount to Apply" - VendLedgEntry."Remaining Pmt. Disc. Possible");
          end else
            if -ExportAmount > -VendLedgEntry."Amount to Apply" then
              AmountPaid := -VendLedgEntry."Amount to Apply"
            else
              AmountPaid := -ExportAmount;
        end;
    end;

    local procedure ProcessCustomer(var GenJnlLine: Record "Gen. Journal Line")
    begin
        FormatAddress.Customer(PayeeAddress,Customer);
        CustBankAccount.SetRange("Customer No.",Customer."No.");
        CustBankAccount.SetRange("Use for Electronic Payments",true);
        if CustBankAccount.Count <> 1 then
          Error(BankAcctElecPaymentErr,
            CustBankAccount.TableCaption,CustBankAccount.FieldCaption("Use for Electronic Payments"),
            Customer.TableCaption,Customer."No.");
        CustBankAccount.FindFirst;
        PayeeBankTransitNo := CustBankAccount."Transit No.";
        PayeeBankAccountNo := CustBankAccount."Bank Account No.";
        if GenJnlLine."Applies-to Doc. No." <> '' then begin
          CustLedgEntry.Reset;
          CustLedgEntry.SetCurrentkey("Document No.","Document Type","Customer No.");
          CustLedgEntry.SetRange("Document Type",GenJnlLine."Applies-to Doc. Type");
          CustLedgEntry.SetRange("Document No.",GenJnlLine."Applies-to Doc. No.");
          CustLedgEntry.SetRange("Customer No.",Customer."No.");
          CustLedgEntry.SetRange(Open,true);
          CustLedgEntry.FindFirst;
          CustLedgEntry.CalcFields("Remaining Amt. (LCY)");
          if (CustLedgEntry."Pmt. Discount Date" >= SettleDate) and
             (CustLedgEntry."Remaining Pmt. Disc. Possible" <> 0) and
             (-(ExportAmount - CustLedgEntry."Remaining Pmt. Disc. Possible") >= -CustLedgEntry."Amount to Apply")
          then begin
            DiscountTaken := -CustLedgEntry."Remaining Pmt. Disc. Possible";
            AmountPaid := -(CustLedgEntry."Amount to Apply" - CustLedgEntry."Remaining Pmt. Disc. Possible");
          end else
            if -ExportAmount > -CustLedgEntry."Amount to Apply" then
              AmountPaid := -CustLedgEntry."Amount to Apply"
            else
              AmountPaid := -ExportAmount;
        end;
    end;
}

