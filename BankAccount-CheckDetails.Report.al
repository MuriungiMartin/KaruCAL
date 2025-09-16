#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 1406 "Bank Account - Check Details"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Bank Account - Check Details.rdlc';
    Caption = 'Bank Account - Check Details';
    UsageCategory = ReportsandAnalysis;

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
            column(BankAccDateFilter;StrSubstNo(Text000,BankAccDateFilter))
            {
            }
            column(CompanyName;COMPANYNAME)
            {
            }
            column(ShowHeader3;CurrReport.PageNo = 1)
            {
            }
            column(BankAccountCaption;StrSubstNo('%1: %2',"Bank Account".TableCaption,BankAccFilter))
            {
            }
            column(BankFilter;BankAccFilter)
            {
            }
            column(No_BankAccount;"No.")
            {
            }
            column(Name_BankAccount;Name)
            {
            }
            column(PhoneNo_BankAccount;"Phone No.")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode_BankAccount;"Currency Code")
            {
                IncludeCaption = true;
            }
            column(ShowCurrencyCode;"Currency Code" <> '')
            {
            }
            column(BankAccCheckDetailsCaption;BankAccCheckDetailsCaptionLbl)
            {
            }
            column(PageNoCaption;PageNoCaptionLbl)
            {
            }
            column(BankAccBalCaption;BankAccBalCaptionLbl)
            {
            }
            column(CheckDateCaption;CheckDateCaptionLbl)
            {
            }
            column(AmtVoidedCaption;AmtVoidedCaptionLbl)
            {
            }
            column(PrintedAmtCaption;PrintedAmtCaptionLbl)
            {
            }
            dataitem("Check Ledger Entry";"Check Ledger Entry")
            {
                DataItemLink = "Bank Account No."=field("No."),"Check Date"=field("Date Filter");
                DataItemTableView = sorting("Bank Account No.","Check Date");
                column(ReportForNavId_5439; 5439)
                {
                }
                column(AmountPrinted;AmountPrinted)
                {
                    AutoFormatExpression = "Check Ledger Entry".GetCurrencyCodeFromBank;
                    AutoFormatType = 1;
                }
                column(Amount_CheckLedgerEntry;Amount)
                {
                    IncludeCaption = true;
                }
                column(AmountVoided;AmountVoided)
                {
                    AutoFormatExpression = "Check Ledger Entry".GetCurrencyCodeFromBank;
                    AutoFormatType = 1;
                }
                column(RecordCounter;RecordCounter)
                {
                }
                column(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                {
                }
                column(CheckDate_CheckLedgEntry;Format("Check Date"))
                {
                }
                column(CheckType_CheckLedgEntry;"Check Type")
                {
                }
                column(CheckNo_CheckLedgEntry;"Check No.")
                {
                    IncludeCaption = true;
                }
                column(Description_CheckLedgEntry;Description)
                {
                    IncludeCaption = true;
                }
                column(EntryStatus_CheckLedgEntry;"Entry Status")
                {
                    IncludeCaption = true;
                }
                column(OriginalEntryStatus_CheckLedgEntry;"Original Entry Status")
                {
                    IncludeCaption = true;
                }
                column(BalAccType_CheckLedgEntry;"Bal. Account Type")
                {
                    IncludeCaption = true;
                }
                column(BalAccNo_CheckLedgEntry;"Bal. Account No.")
                {
                    IncludeCaption = true;
                }
                column(EntryNo_CheckLedgerEntry;"Entry No.")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    CheckLedgEntryExists := true;
                    if ("Entry Status" = "entry status"::Printed) or
                       (("Entry Status" = "entry status"::Posted) and ("Bank Payment Type" = "bank payment type"::"Computer Check"))
                    then
                      AmountPrinted := AmountPrinted + Amount;
                    if ("Entry Status" = "entry status"::Voided) or
                       ("Entry Status" = "entry status"::"Financially Voided")
                    then
                      AmountVoided := AmountVoided + Amount;
                end;

                trigger OnPreDataItem()
                begin
                    RecordCounter := RecordCounter + 1;

                    CheckLedgEntryExists := false;
                    CurrReport.CreateTotals(Amount,AmountPrinted,AmountVoided);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                CurrReport.PrintonlyIfDetail := true;
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.NewPagePerRecord := PrintOnlyOnePerPage;
                CurrReport.CreateTotals(Amount,AmountPrinted,AmountVoided);
                RecordCounter := 0;
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
                    field(PrintOnlyOnePerPage;PrintOnlyOnePerPage)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'New Page per Bank Account';
                        ToolTip = 'Specifies if you want to print each bank account on a separate page.';
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
        BankAccFilter := "Bank Account".GetFilters;
        BankAccDateFilter := "Bank Account".GetFilter("Date Filter");
    end;

    var
        Text000: label 'Period: %1';
        PrintOnlyOnePerPage: Boolean;
        BankAccFilter: Text;
        BankAccDateFilter: Text;
        AmountVoided: Decimal;
        AmountPrinted: Decimal;
        CheckLedgEntryExists: Boolean;
        RecordCounter: Integer;
        BankAccCheckDetailsCaptionLbl: label 'Bank Account - Check Details';
        PageNoCaptionLbl: label 'Page';
        BankAccBalCaptionLbl: label 'This report also includes bank accounts that only have balances.';
        CheckDateCaptionLbl: label 'Check Date';
        AmtVoidedCaptionLbl: label 'Voided Amount';
        PrintedAmtCaptionLbl: label 'Printed Amount';


    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean)
    begin
        PrintOnlyOnePerPage := NewPrintOnlyOnePerPage;
    end;
}

