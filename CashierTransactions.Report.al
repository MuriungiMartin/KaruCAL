#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51633 "Cashier Transactions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Cashier Transactions.rdlc';
    Caption = 'Bank Acc. - Detail Trial Bal.';

    dataset
    {
        dataitem("Bank Account";"Bank Account")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.","Search Name","Bank Acc. Posting Group","Date Filter";
            column(ReportForNavId_4558; 4558)
            {
            }
            column(FORMAT_TODAY_0_4_;Format(Today,0,4))
            {
            }
            column(STRSUBSTNO_Text000_BankAccDateFilter_;StrSubstNo(Text000,BankAccDateFilter))
            {
            }
            column(CurrReport_PAGENO;CurrReport.PageNo)
            {
            }
            column(COMPANYNAME;COMPANYNAME)
            {
            }
            column(USERID;UserId)
            {
            }
            column(STRSUBSTNO___1___2___Bank_Account__TABLECAPTION_BankAccFilter_;StrSubstNo('%1: %2',"Bank Account".TableCaption,BankAccFilter))
            {
            }
            column(Bank_Account__No__;"No.")
            {
            }
            column(Bank_Account_Name;Name)
            {
            }
            column(Bank_Account__Phone_No__;"Phone No.")
            {
            }
            column(Bank_Account__Currency_Code_;"Currency Code")
            {
            }
            column(StartBalance;StartBalance)
            {
                AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                AutoFormatType = 1;
            }
            column(Bank_Acc____Detail_Trial_Bal_Caption;Bank_Acc____Detail_Trial_Bal_CaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(This_report_also_includes_bank_accounts_that_only_have_balances_Caption;This_report_also_includes_bank_accounts_that_only_have_balances_CaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Posting_Date_Caption;"Bank Account Ledger Entry".FieldCaption("Posting Date"))
            {
            }
            column(Bank_Account_Ledger_Entry__Document_Type_Caption;Bank_Account_Ledger_Entry__Document_Type_CaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Document_No__Caption;"Bank Account Ledger Entry".FieldCaption("Document No."))
            {
            }
            column(Bank_Account_Ledger_Entry_DescriptionCaption;"Bank Account Ledger Entry".FieldCaption(Description))
            {
            }
            column(BankAccBalanceCaption;BankAccBalanceCaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry__Entry_No__Caption;"Bank Account Ledger Entry".FieldCaption("Entry No."))
            {
            }
            column(Bank_Account_Ledger_Entry_AmountCaption;"Bank Account Ledger Entry".FieldCaption(Amount))
            {
            }
            column(Bank_Account_Ledger_Entry__User_ID_Caption;"Bank Account Ledger Entry".FieldCaption("User ID"))
            {
            }
            column(Bank_Account_Ledger_Entry_ReversedCaption;"Bank Account Ledger Entry".FieldCaption(Reversed))
            {
            }
            column(Bank_Account__Phone_No__Caption;FieldCaption("Phone No."))
            {
            }
            column(Bank_Account__Currency_Code_Caption;FieldCaption("Currency Code"))
            {
            }
            column(Bank_Account_Date_Filter;"Date Filter")
            {
            }
            column(Bank_Account_Global_Dimension_2_Filter;"Global Dimension 2 Filter")
            {
            }
            column(Bank_Account_Global_Dimension_1_Filter;"Global Dimension 1 Filter")
            {
            }
            dataitem("Bank Account Ledger Entry";"Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No."=field("No."),"Posting Date"=field("Date Filter"),"Global Dimension 2 Code"=field("Global Dimension 2 Filter"),"Global Dimension 1 Code"=field("Global Dimension 1 Filter");
                DataItemTableView = sorting("Bank Account No.","Posting Date");
                column(ReportForNavId_4920; 4920)
                {
                }
                column(StartBalance____Bank_Account_Ledger_Entry__Amount;StartBalance + "Bank Account Ledger Entry".Amount)
                {
                    AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(Bank_Account_Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Bank_Account_Ledger_Entry__Document_Type_;"Document Type")
                {
                }
                column(Bank_Account_Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Description;Description)
                {
                }
                column(BankAccBalance;BankAccBalance)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Bank_Account_Ledger_Entry__Entry_No__;"Entry No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Amount;Amount)
                {
                }
                column(Bank_Account_Ledger_Entry__User_ID_;"User ID")
                {
                }
                column(Bank_Account_Ledger_Entry_Reversed;Reversed)
                {
                }
                column(StartBalance____Bank_Account_Ledger_Entry__Amount_Control47;StartBalance + "Bank Account Ledger Entry".Amount)
                {
                    AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(ContinuedCaption;ContinuedCaptionLbl)
                {
                }
                column(ContinuedCaption_Control46;ContinuedCaption_Control46Lbl)
                {
                }
                column(Bank_Account_Ledger_Entry_Bank_Account_No_;"Bank Account No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Global_Dimension_2_Code;"Global Dimension 2 Code")
                {
                }
                column(Bank_Account_Ledger_Entry_Global_Dimension_1_Code;"Global Dimension 1 Code")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not PrintReversedEntries and Reversed then
                      CurrReport.Skip;
                    BankAccLedgEntryExists := true;
                    BankAccBalance := BankAccBalance + Amount;
                    BankAccBalanceLCY := BankAccBalanceLCY + "Amount (LCY)"
                end;

                trigger OnPreDataItem()
                begin
                    BankAccLedgEntryExists := false;
                    CurrReport.CreateTotals(Amount,"Amount (LCY)");
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
                {
                }
                column(Bank_Account__Name;"Bank Account".Name)
                {
                }
                column(Bank_Account_Ledger_Entry__Amount;"Bank Account Ledger Entry".Amount)
                {
                }
                column(StartBalance____Bank_Account_Ledger_Entry__Amount_Control50;StartBalance + "Bank Account Ledger Entry".Amount)
                {
                    AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(Integer_Number;Number)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not BankAccLedgEntryExists and ((StartBalance = 0) or ExcludeBalanceOnly) then begin
                      StartBalanceLCY := 0;
                      CurrReport.Skip;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StartBalance := 0;
                if BankAccDateFilter <> '' then
                  if GetRangeMin("Date Filter") <> 0D then begin
                    SetRange("Date Filter",0D,GetRangeMin("Date Filter") - 1);
                    CalcFields("Net Change","Net Change (LCY)");
                    StartBalance := "Net Change";
                    StartBalanceLCY := "Net Change (LCY)";
                    SetFilter("Date Filter",BankAccDateFilter);
                  end;
                CurrReport.PrintonlyIfDetail := ExcludeBalanceOnly or (StartBalance = 0);
                BankAccBalance := StartBalance;
                BankAccBalanceLCY := StartBalanceLCY;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Bank Account Ledger Entry"."Amount (LCY)",StartBalanceLCY);
            end;
        }
    }

    requestpage
    {

        layout
        {
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
        BankAccFilter := "Bank Account".GetFilters;
        BankAccDateFilter := "Bank Account".GetFilter("Date Filter");
    end;

    var
        Text000: label 'Period: %1';
        PrintOnlyOnePerPage: Boolean;
        ExcludeBalanceOnly: Boolean;
        BankAccFilter: Text[250];
        BankAccDateFilter: Text[30];
        BankAccBalance: Decimal;
        BankAccBalanceLCY: Decimal;
        StartBalance: Decimal;
        StartBalanceLCY: Decimal;
        BankAccLedgEntryExists: Boolean;
        PrintReversedEntries: Boolean;
        Bank_Acc____Detail_Trial_Bal_CaptionLbl: label 'Bank Acc. - Detail Trial Bal.';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        This_report_also_includes_bank_accounts_that_only_have_balances_CaptionLbl: label 'This report also includes bank accounts that only have balances.';
        Bank_Account_Ledger_Entry__Document_Type_CaptionLbl: label 'Document Type';
        BankAccBalanceCaptionLbl: label 'Balance';
        ContinuedCaptionLbl: label 'Continued';
        ContinuedCaption_Control46Lbl: label 'Continued';
}

