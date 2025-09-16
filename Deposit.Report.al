#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 10403 Deposit
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Deposit.rdlc';
    Caption = 'Deposit';
    UsageCategory = ReportsandAnalysis;

    dataset
    {
        dataitem(UnknownTable10143;UnknownTable10143)
        {
            RequestFilterFields = "No.","Bank Account No.";
            column(ReportForNavId_4738; 4738)
            {
            }
            column(Posted_Deposit_Header_No_;"No.")
            {
            }
            dataitem(PageHeader;"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_8122; 8122)
                {
                }
                column(USERID;UserId)
                {
                }
                column(CurrReport_PAGENO;CurrReport.PageNo)
                {
                }
                column(TIME;Time)
                {
                }
                column(FORMAT_TODAY_0_4_;Format(Today,0,4))
                {
                }
                column(STRSUBSTNO_Text000__Posted_Deposit_Header___No___;StrSubstNo(Text000,"Posted Deposit Header"."No."))
                {
                }
                column(CompanyInformation_Name;CompanyInformation.Name)
                {
                }
                column(Posted_Deposit_Header___Bank_Account_No__;"Posted Deposit Header"."Bank Account No.")
                {
                }
                column(BankAccount_Name;BankAccount.Name)
                {
                }
                column(Posted_Deposit_Header___Document_Date_;"Posted Deposit Header"."Document Date")
                {
                }
                column(Posted_Deposit_Header___Posting_Date_;"Posted Deposit Header"."Posting Date")
                {
                }
                column(Posted_Deposit_Header___Total_Deposit_Amount_;"Posted Deposit Header"."Total Deposit Amount")
                {
                }
                column(Posted_Deposit_Header___Posting_Description_;"Posted Deposit Header"."Posting Description")
                {
                }
                column(PrintApplications;PrintApplications)
                {
                }
                column(PageHeader_Number;Number)
                {
                }
                column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
                {
                }
                column(Deposited_InCaption;Deposited_InCaptionLbl)
                {
                }
                column(Posted_Deposit_Header___Bank_Account_No__Caption;Posted_Deposit_Header___Bank_Account_No__CaptionLbl)
                {
                }
                column(Currency_CodeCaption;Currency_CodeCaptionLbl)
                {
                }
                column(Posted_Deposit_Header___Document_Date_Caption;Posted_Deposit_Header___Document_Date_CaptionLbl)
                {
                }
                column(Posted_Deposit_Header___Posting_Date_Caption;Posted_Deposit_Header___Posting_Date_CaptionLbl)
                {
                }
                column(Posted_Deposit_Header___Total_Deposit_Amount_Caption;Posted_Deposit_Header___Total_Deposit_Amount_CaptionLbl)
                {
                }
                column(Posted_Deposit_Header___Posting_Description_Caption;Posted_Deposit_Header___Posting_Description_CaptionLbl)
                {
                }
                column(Control1020008Caption;CaptionClassTranslate(GetCurrencyCaptionDesc("Posted Deposit Header"."Currency Code")))
                {
                }
                column(Control1020012Caption;CaptionClassTranslate(GetCurrencyCaptionCode("Posted Deposit Header"."Currency Code")))
                {
                }
                column(Posted_Deposit_Line__Account_Type_Caption;"Posted Deposit Line".FieldCaption("Account Type"))
                {
                }
                column(Posted_Deposit_Line__Account_No__Caption;"Posted Deposit Line".FieldCaption("Account No."))
                {
                }
                column(Posted_Deposit_Line__Document_Date_Caption;"Posted Deposit Line".FieldCaption("Document Date"))
                {
                }
                column(Posted_Deposit_Line__Document_Type_Caption;"Posted Deposit Line".FieldCaption("Document Type"))
                {
                }
                column(Posted_Deposit_Line__Document_No__Caption;"Posted Deposit Line".FieldCaption("Document No."))
                {
                }
                column(Posted_Deposit_Line_AmountCaption;"Posted Deposit Line".FieldCaption(Amount))
                {
                }
                column(AccountNameCaption;AccountNameCaptionLbl)
                {
                }
                column(Posted_Deposit_Line_DescriptionCaption;"Posted Deposit Line".FieldCaption(Description))
                {
                }
                dataitem(UnknownTable10144;UnknownTable10144)
                {
                    DataItemLink = "Deposit No."=field("No.");
                    DataItemLinkReference = "Posted Deposit Header";
                    DataItemTableView = sorting("Deposit No.","Line No.");
                    column(ReportForNavId_6556; 6556)
                    {
                    }
                    column(Posted_Deposit_Line__Account_Type_;"Account Type")
                    {
                    }
                    column(Posted_Deposit_Line__Account_No__;"Account No.")
                    {
                    }
                    column(Posted_Deposit_Line__Document_Date_;"Document Date")
                    {
                    }
                    column(Posted_Deposit_Line__Document_Type_;"Document Type")
                    {
                    }
                    column(Posted_Deposit_Line__Document_No__;"Document No.")
                    {
                    }
                    column(Posted_Deposit_Line_Amount;Amount)
                    {
                    }
                    column(AccountName;AccountName)
                    {
                    }
                    column(Posted_Deposit_Line_Description;Description)
                    {
                    }
                    column(Posted_Deposit_Line_Amount_Control1020042;Amount)
                    {
                    }
                    column(DataItem1020044;StrSubstNo(Text003,"Deposit No.","Posted Deposit Header".FieldCaption("Bank Account No."),"Posted Deposit Header"."Bank Account No."))
                    {
                    }
                    column(Posted_Deposit_Line_Deposit_No_;"Deposit No.")
                    {
                    }
                    column(Posted_Deposit_Line_Line_No_;"Line No.")
                    {
                    }
                    dataitem(CustApplication;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_8321; 8321)
                        {
                        }
                        column(AppliedCustLedgEntry__Document_Date_;AppliedCustLedgEntry."Document Date")
                        {
                        }
                        column(AppliedCustLedgEntry__Document_Type_;AppliedCustLedgEntry."Document Type")
                        {
                            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                        }
                        column(AppliedCustLedgEntry__Document_No__;AppliedCustLedgEntry."Document No.")
                        {
                        }
                        column(AppliedCustLedgEntry__Original_Amount_;AppliedCustLedgEntry."Original Amount")
                        {
                        }
                        column(AmountApplied;AmountApplied)
                        {
                        }
                        column(AppliedCustLedgEntry_Open;Format(AppliedCustLedgEntry.Open))
                        {
                        }
                        column(STRSUBSTNO_Text004__Posted_Deposit_Line___Document_Type___Posted_Deposit_Line___Document_No___;StrSubstNo(Text004,"Posted Deposit Line"."Document Type","Posted Deposit Line"."Document No."))
                        {
                        }
                        column(TotalAmountApplied;TotalAmountApplied)
                        {
                        }
                        column(CustApplication_Number;Number)
                        {
                        }
                        column(Applied_ToCaption;Applied_ToCaptionLbl)
                        {
                        }
                        column(AppliedCustLedgEntry__Original_Amount_Caption;AppliedCustLedgEntry__Original_Amount_CaptionLbl)
                        {
                        }
                        column(AmountAppliedCaption;AmountAppliedCaptionLbl)
                        {
                        }
                        column(Currency_CodeCaption_Control1020024;Currency_CodeCaption_Control1020024Lbl)
                        {
                        }
                        column(AppliedCustLedgEntry_OpenCaption;AppliedCustLedgEntry_OpenCaptionLbl)
                        {
                        }
                        column(Control1020023Caption;CaptionClassTranslate(GetCurrencyCaptionCode(AppliedCustLedgEntry."Currency Code")))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              AppliedCustLedgEntry.Find('-')
                            else
                              AppliedCustLedgEntry.Next;
                            AppliedCustLedgEntry.CalcFields("Original Amount");
                            AmountApplied := AppliedCustLedgEntry."Amount to Apply";
                            TotalAmountApplied := TotalAmountApplied + AmountApplied;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not PrintApplications or
                               ("Posted Deposit Line"."Account Type" <> "Posted Deposit Line"."account type"::Customer)
                            then
                              CurrReport.Break;
                            SetRange(Number,1,AppliedCustLedgEntry.Count);
                            AppliedCustLedgEntry.SetCurrentkey("Customer No.","Posting Date");
                            TotalAmountApplied := 0;
                        end;
                    }
                    dataitem(VendApplication;"Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_1782; 1782)
                        {
                        }
                        column(AppliedVendLedgEntry__Document_Date_;AppliedVendLedgEntry."Document Date")
                        {
                        }
                        column(AppliedVendLedgEntry__Document_Type_;AppliedVendLedgEntry."Document Type")
                        {
                            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
                        }
                        column(AppliedVendLedgEntry__Document_No__;AppliedVendLedgEntry."Document No.")
                        {
                        }
                        column(AppliedVendLedgEntry__Original_Amount_;AppliedVendLedgEntry."Original Amount")
                        {
                        }
                        column(AmountApplied_Control1020060;AmountApplied)
                        {
                        }
                        column(AppliedVendLedgEntry_Open;Format(AppliedVendLedgEntry.Open))
                        {
                        }
                        column(STRSUBSTNO_Text004__Posted_Deposit_Line___Document_Type___Posted_Deposit_Line___Document_No____Control1020061;StrSubstNo(Text004,"Posted Deposit Line"."Document Type","Posted Deposit Line"."Document No."))
                        {
                        }
                        column(TotalAmountApplied_Control1020062;TotalAmountApplied)
                        {
                        }
                        column(VendApplication_Number;Number)
                        {
                        }
                        column(Applied_ToCaption_Control1020036;Applied_ToCaption_Control1020036Lbl)
                        {
                        }
                        column(Currency_CodeCaption_Control1020037;Currency_CodeCaption_Control1020037Lbl)
                        {
                        }
                        column(AppliedVendLedgEntry__Original_Amount_Caption;AppliedVendLedgEntry__Original_Amount_CaptionLbl)
                        {
                        }
                        column(AmountApplied_Control1020060Caption;AmountApplied_Control1020060CaptionLbl)
                        {
                        }
                        column(AppliedVendLedgEntry_OpenCaption;AppliedVendLedgEntry_OpenCaptionLbl)
                        {
                        }
                        column(Control1020058Caption;CaptionClassTranslate(GetCurrencyCaptionCode(AppliedVendLedgEntry."Currency Code")))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then
                              AppliedVendLedgEntry.Find('-')
                            else
                              AppliedVendLedgEntry.Next;
                            AppliedVendLedgEntry.CalcFields("Original Amount");
                            AmountApplied := AppliedVendLedgEntry."Amount to Apply";
                            TotalAmountApplied := TotalAmountApplied + AmountApplied;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not PrintApplications or
                               ("Posted Deposit Line"."Account Type" <> "Posted Deposit Line"."account type"::Vendor)
                            then
                              CurrReport.Break;
                            SetRange(Number,1,AppliedVendLedgEntry.Count);
                            AppliedVendLedgEntry.SetCurrentkey("Vendor No.","Posting Date");
                            TotalAmountApplied := 0;
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        TempAppliedCustLedgEntry: Record "Cust. Ledger Entry" temporary;
                        TempAppliedVendLedgEntry: Record "Vendor Ledger Entry" temporary;
                    begin
                        case "Account Type" of
                          "account type"::"G/L Account":
                            begin
                              if GLAccount.Get("Account No.") then
                                AccountName := GLAccount.Name
                              else
                                AccountName := StrSubstNo(Text001,GLAccount.TableCaption);
                              if Description = AccountName then
                                Description := '';
                            end;
                          "account type"::Customer:
                            begin
                              if Customer.Get("Account No.") then
                                AccountName := Customer.Name
                              else
                                AccountName := StrSubstNo(Text001,Customer.TableCaption);
                              if Description = AccountName then
                                Description := '';
                            end;
                          "account type"::Vendor:
                            begin
                              if Vendor.Get("Account No.") then
                                AccountName := Vendor.Name
                              else
                                AccountName := StrSubstNo(Text001,Vendor.TableCaption);
                              if Description = AccountName then
                                Description := '';
                            end;
                          "account type"::"Bank Account":
                            begin
                              if BankAccount2.Get("Account No.") then
                                AccountName := BankAccount2.Name
                              else
                                AccountName := StrSubstNo(Text001,BankAccount2.TableCaption);
                              if Description = AccountName then
                                Description := '';
                            end;
                        end;

                        if PrintApplications then
                          case "Account Type" of
                            "account type"::Customer:
                              begin
                                AppliedCustLedgEntry.DeleteAll;
                                FilterDepositCustLedgerEntry("Posted Deposit Line",CustLedgEntry);
                                if CustLedgEntry.FindSet then
                                  repeat
                                    EntryAppMgt.GetAppliedCustEntries(TempAppliedCustLedgEntry,CustLedgEntry,false);
                                    if TempAppliedCustLedgEntry.FindSet then
                                      repeat
                                        AppliedCustLedgEntry := TempAppliedCustLedgEntry;
                                        AppliedCustLedgEntry.Insert;
                                      until TempAppliedCustLedgEntry.Next = 0;
                                  until CustLedgEntry.Next = 0;
                              end;
                            "account type"::Vendor:
                              begin
                                AppliedVendLedgEntry.DeleteAll;
                                FilterDepositVendLedgerEntry("Posted Deposit Line",VendLedgEntry);
                                if VendLedgEntry.FindSet then
                                  repeat
                                    EntryAppMgt.GetAppliedVendEntries(TempAppliedVendLedgEntry,VendLedgEntry,false);
                                    if TempAppliedVendLedgEntry.FindSet then
                                      repeat
                                        AppliedVendLedgEntry := TempAppliedVendLedgEntry;
                                        AppliedVendLedgEntry.Insert;
                                      until TempAppliedVendLedgEntry.Next = 0;
                                  until VendLedgEntry.Next = 0;
                              end;
                          end;
                    end;

                    trigger OnPostDataItem()
                    begin
                        if not CurrReport.Preview then
                          DepositPrinted.Run("Posted Deposit Header");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.Language := Language.GetLanguageID("Language Code");

                if not BankAccount.Get("Bank Account No.") then
                  BankAccount.Name := StrSubstNo(Text001,BankAccount.TableCaption);

                if "Currency Code" = '' then begin
                  if GLSetup."LCY Code" = '' then
                    Currency.Description := Text002
                  else
                    if not Currency.Get(GLSetup."LCY Code") then
                      Currency.Description := StrSubstNo(Text001,FieldCaption("Currency Code"));
                end else
                  if not Currency.Get("Currency Code") then
                    Currency.Description := StrSubstNo(Text001,FieldCaption("Currency Code"));

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
                    field(ShowApplications;PrintApplications)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Show Applications';
                        ToolTip = 'Specifies if application information is included in the report.';
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
    end;

    var
        CompanyInformation: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        BankAccount: Record "Bank Account";
        Text000: label 'Deposit %1';
        Text001: label '<Invalid %1>';
        Currency: Record Currency;
        Text002: label 'US Dollar';
        Language: Record Language;
        Customer: Record Customer;
        Vendor: Record Vendor;
        GLAccount: Record "G/L Account";
        BankAccount2: Record "Bank Account";
        CustLedgEntry: Record "Cust. Ledger Entry";
        AppliedCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        VendLedgEntry: Record "Vendor Ledger Entry";
        AppliedVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        DepositPrinted: Codeunit "Deposit-Printed";
        EntryAppMgt: Codeunit "Entry Application Management";
        AccountName: Text[50];
        Text003: label 'Total for Deposit %1, into %2 %3';
        PrintApplications: Boolean;
        Text004: label 'Total Application of %1 %2';
        AmountApplied: Decimal;
        TotalAmountApplied: Decimal;
        CurrReport_PAGENOCaptionLbl: label 'Page';
        Deposited_InCaptionLbl: label 'Deposited In';
        Posted_Deposit_Header___Bank_Account_No__CaptionLbl: label 'Bank Account No.';
        Currency_CodeCaptionLbl: label 'Currency Code';
        Posted_Deposit_Header___Document_Date_CaptionLbl: label 'Document Date';
        Posted_Deposit_Header___Posting_Date_CaptionLbl: label 'Posting Date';
        Posted_Deposit_Header___Total_Deposit_Amount_CaptionLbl: label 'Total Deposit Amount';
        Posted_Deposit_Header___Posting_Description_CaptionLbl: label 'Posting Description';
        AccountNameCaptionLbl: label 'Account Name';
        Applied_ToCaptionLbl: label 'Applied To';
        AppliedCustLedgEntry__Original_Amount_CaptionLbl: label 'Original Amount';
        AmountAppliedCaptionLbl: label 'Amount Applied';
        Currency_CodeCaption_Control1020024Lbl: label 'Currency Code';
        AppliedCustLedgEntry_OpenCaptionLbl: label 'Remains Open';
        Applied_ToCaption_Control1020036Lbl: label 'Applied To';
        Currency_CodeCaption_Control1020037Lbl: label 'Currency Code';
        AppliedVendLedgEntry__Original_Amount_CaptionLbl: label 'Original Amount';
        AmountApplied_Control1020060CaptionLbl: label 'Amount Applied';
        AppliedVendLedgEntry_OpenCaptionLbl: label 'Remains Open';

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
        if CurrencyCode = '' then
          exit('101,0,%1');

        GetCurrencyRecord(Currency,CurrencyCode);
        exit('101,4,' + Currency.Code);
    end;

    local procedure GetCurrencyCaptionDesc(CurrencyCode: Code[10]): Text[80]
    begin
        if CurrencyCode = '' then
          exit('101,1,%1');

        GetCurrencyRecord(Currency,CurrencyCode);
        exit('101,4,' + Currency.Description);
    end;


    procedure FilterDepositCustLedgerEntry(PostedDepositLine: Record UnknownRecord10144;var DepositCustLedgerEntry: Record "Cust. Ledger Entry")
    var
        FromEntryNo: Integer;
        ToEntryNo: Integer;
    begin
        PostedDepositLine.Reset;
        PostedDepositLine.SetCurrentkey("Deposit No.","Line No.");
        PostedDepositLine.SetRange("Deposit No.",PostedDepositLine."Deposit No.");
        PostedDepositLine.SetRange("Line No.",PostedDepositLine."Line No.");
        if PostedDepositLine.FindFirst then
          FromEntryNo := PostedDepositLine."Entry No.";

        DepositCustLedgerEntry.Get(PostedDepositLine."Entry No.");
        PostedDepositLine.Reset;
        PostedDepositLine.SetCurrentkey("Deposit No.","Line No.");
        PostedDepositLine.SetRange("Deposit No.",PostedDepositLine."Deposit No.");
        PostedDepositLine.SetFilter("Line No.",'>%1',PostedDepositLine."Line No.");
        if PostedDepositLine.FindFirst then begin
          DepositCustLedgerEntry.Reset;
          ToEntryNo := PostedDepositLine."Entry No.";
          DepositCustLedgerEntry.SetRange("Transaction No.",DepositCustLedgerEntry."Transaction No.");
          DepositCustLedgerEntry.SetFilter("Entry No.",'%1..%2',FromEntryNo,ToEntryNo - 1);
        end else begin
          DepositCustLedgerEntry.Reset;
          DepositCustLedgerEntry.SetFilter("Entry No.",'>=%1',FromEntryNo);
          DepositCustLedgerEntry.SetRange("Transaction No.",DepositCustLedgerEntry."Transaction No.");
          DepositCustLedgerEntry.SetRange("External Document No.",PostedDepositLine."Deposit No.");
        end;
    end;


    procedure FilterDepositVendLedgerEntry(PostedDepositLine: Record UnknownRecord10144;var DepositVendLedgerEntry: Record "Vendor Ledger Entry")
    var
        FromEntryNo: Integer;
        ToEntryNo: Integer;
    begin
        PostedDepositLine.Reset;
        PostedDepositLine.SetCurrentkey("Deposit No.","Line No.");
        PostedDepositLine.SetRange("Deposit No.",PostedDepositLine."Deposit No.");
        PostedDepositLine.SetRange("Line No.",PostedDepositLine."Line No.");
        if PostedDepositLine.FindFirst then
          FromEntryNo := PostedDepositLine."Entry No.";

        DepositVendLedgerEntry.Get(PostedDepositLine."Entry No.");
        PostedDepositLine.Reset;
        PostedDepositLine.SetCurrentkey("Deposit No.","Line No.");
        PostedDepositLine.SetRange("Deposit No.",PostedDepositLine."Deposit No.");
        PostedDepositLine.SetFilter("Line No.",'>%1',PostedDepositLine."Line No.");
        if PostedDepositLine.FindFirst then begin
          DepositVendLedgerEntry.Reset;
          ToEntryNo := PostedDepositLine."Entry No.";
          DepositVendLedgerEntry.SetRange("Transaction No.",DepositVendLedgerEntry."Transaction No.");
          DepositVendLedgerEntry.SetFilter("Entry No.",'%1..%2',FromEntryNo,ToEntryNo - 1);
        end else begin
          DepositVendLedgerEntry.Reset;
          DepositVendLedgerEntry.SetFilter("Entry No.",'>=%1',FromEntryNo);
          DepositVendLedgerEntry.SetRange("Transaction No.",DepositVendLedgerEntry."Transaction No.");
          DepositVendLedgerEntry.SetRange("External Document No.",PostedDepositLine."Deposit No.");
        end;
    end;
}

