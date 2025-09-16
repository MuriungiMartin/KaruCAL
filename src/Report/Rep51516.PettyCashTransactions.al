#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51516 "Petty Cash Transactions"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Petty Cash Transactions.rdlc';
    Caption = 'Bank Acc. - Detail Trial Bal.';

    dataset
    {
        dataitem("Bank Account";"Bank Account")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Date Filter";
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
            column(StartBalance;StartBalance)
            {
                AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                AutoFormatType = 1;
            }
            column(StartBalance____Bank_Account_Ledger_Entry__Amount;StartBalance + "Bank Account Ledger Entry".Amount)
            {
                AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                AutoFormatType = 1;
            }
            column(Petty_Cash_FloatCaption;Petty_Cash_FloatCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption;CurrReport_PAGENOCaptionLbl)
            {
            }
            column(DateCaption;DateCaptionLbl)
            {
            }
            column(Doc_No_Caption;Doc_No_CaptionLbl)
            {
            }
            column(Bank_Account_Ledger_Entry_DescriptionCaption;"Bank Account Ledger Entry".FieldCaption(Description))
            {
            }
            column(BalCaption;BalCaptionLbl)
            {
            }
            column(DebitCaption;DebitCaptionLbl)
            {
            }
            column(CreditCaption;CreditCaptionLbl)
            {
            }
            column(Cheque_No_Caption;Cheque_No_CaptionLbl)
            {
            }
            column(Opening_BalanceCaption;Opening_BalanceCaptionLbl)
            {
            }
            column(Closing_BalanceCaption;Closing_BalanceCaptionLbl)
            {
            }
            column(Bank_Account_No_;"No.")
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
                column(StartBalance____Bank_Account_Ledger_Entry__Amount_Control34;StartBalance + "Bank Account Ledger Entry".Amount)
                {
                    AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                    AutoFormatType = 1;
                }
                column(Bank_Account_Ledger_Entry__Posting_Date_;"Posting Date")
                {
                }
                column(Bank_Account_Ledger_Entry__Document_No__;"Document No.")
                {
                }
                column(Bank_Account_Ledger_Entry_Description;Description)
                {
                }
                column(Bal;Bal)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(Bank_Account_Ledger_Entry__Debit_Amount_;"Debit Amount")
                {
                }
                column(Bank_Account_Ledger_Entry__Credit_Amount_;"Credit Amount")
                {
                }
                column(Bank_Account_Ledger_Entry__Bank_Account_Ledger_Entry___External_Document_No__;"Bank Account Ledger Entry"."External Document No.")
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
                column(Bank_Account_Ledger_Entry_Entry_No_;"Entry No.")
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
                    /*Transaction.RESET;
                    Transaction.SETRANGE(Transaction.No,"Bank Account Ledger Entry"."Document No.");
                    IF Transaction.FIND('-') THEN BEGIN
                    REPEAT
                    BIH:=Transaction."BIH No";
                    UNTIL Transaction.NEXT=0;
                    END;
                    
                    IF NOT PrintReversedEntries AND Reversed THEN
                      CurrReport.SKIP;
                    BankAccLedgEntryExists := TRUE;
                    BankAccBalance := BankAccBalance + Amount;
                    BankAccBalanceLCY := BankAccBalanceLCY + "Amount (LCY)" */

                end;

                trigger OnPreDataItem()
                begin
                    BankAccLedgEntryExists := false;
                    CurrReport.CreateTotals(Amount,"Amount (LCY)","Credit Amount","Debit Amount");
                end;
            }
            dataitem("Integer";"Integer")
            {
                DataItemTableView = sorting(Number) where(Number=const(1));
                column(ReportForNavId_5444; 5444)
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
                Bal:=StartBalance;
            end;

            trigger OnPreDataItem()
            begin
                "Bank Account".SetRange("Bank Account"."Bank Acc. Posting Group",'PETTY');
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals("Bank Account Ledger Entry"."Amount (LCY)",StartBalanceLCY,"Bank Account Ledger Entry"."Credit Amount");
                CurrReport.CreateTotals("Bank Account Ledger Entry"."Debit Amount");
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
        BIH: Text[30];
        Bal: Decimal;
        Petty_Cash_FloatCaptionLbl: label 'Petty Cash Float';
        CurrReport_PAGENOCaptionLbl: label 'Page';
        DateCaptionLbl: label 'Date';
        Doc_No_CaptionLbl: label 'Doc No.';
        BalCaptionLbl: label 'Balance';
        DebitCaptionLbl: label 'Debit';
        CreditCaptionLbl: label 'Credit';
        Cheque_No_CaptionLbl: label 'Cheque No.';
        Opening_BalanceCaptionLbl: label 'Opening Balance';
        Closing_BalanceCaptionLbl: label 'Closing Balance';
        ContinuedCaptionLbl: label 'Continued';
        ContinuedCaption_Control46Lbl: label 'Continued';
}

