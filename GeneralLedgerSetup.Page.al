#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 118 "General Ledger Setup"
{
    ApplicationArea = Basic;
    Caption = 'General Ledger Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,General,Posting,Tax,Bank,Journal Templates';
    SourceTable = "General Ledger Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Allow Posting From";"Allow Posting From")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the earliest date on which posting to the company is allowed.';
                }
                field("Allow Posting To";"Allow Posting To")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the last date on which posting to the company is allowed.';
                }
                field("Register Time";"Register Time")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies whether the program will register the user''s time usage. Place a check mark in the field if you want the program to register time for each user.';
                }
                field("Local Address Format";"Local Address Format")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the format in which addresses must appear on printouts.';
                }
                field("Local Cont. Addr. Format";"Local Cont. Addr. Format")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies where you want the contact name to appear in mailing addresses.';
                }
                field("Inv. Rounding Precision (LCY)";"Inv. Rounding Precision (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the size of the interval to be used when rounding amounts in your local currency. You can also specify invoice rounding for each currency in the Currency table.';
                }
                field("Inv. Rounding Type (LCY)";"Inv. Rounding Type (LCY)")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies whether an invoice amount will be rounded up or down. The program uses this information together with the interval for rounding that you have specified in the Inv. Rounding Precision ($) field.';
                }
                field("Allow G/L Acc. Deletion Before";"Allow G/L Acc. Deletion Before")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies if and when general ledger accounts can be deleted. If you enter a date, G/L accounts with entries on or after this date cannot be deleted.';
                }
                field("Meals Booking No.";"Meals Booking No.")
                {
                    ApplicationArea = Basic;
                }
                field("Transport Requisition No.";"Transport Requisition No.")
                {
                    ApplicationArea = Basic;
                }
                field("Work Ticket No.";"Work Ticket No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Series No.";"Vehicle Series No.")
                {
                    ApplicationArea = Basic;
                }
                field("Check G/L Account Usage";"Check G/L Account Usage")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that you want the program to protect G/L accounts that are used in setup tables from being deleted.';
                }
                field("EMU Currency";"EMU Currency")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether $ is an EMU currency.';
                    Visible = false;
                }
                field("LCY Code";"LCY Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the currency code for $.';
                }
                field("Local Currency Symbol";"Local Currency Symbol")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the symbol for this currency that you wish to appear on checks and charts, $ for USD, CAD or MXP for example.';
                }
                field("Pmt. Disc. Excl. VAT";"Pmt. Disc. Excl. VAT")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether the payment discount is calculated based on amounts including or excluding tax.';
                }
                field("Adjust for Payment Disc.";"Adjust for Payment Disc.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to recalculate tax amounts when you post payments that trigger payment discounts.';
                }
                field("Unrealized VAT";"Unrealized VAT")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies whether to handle unrealized tax.';
                }
                field("Prepayment Unrealized VAT";"Prepayment Unrealized VAT")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies how you want to handle unrealized tax on prepayments.';
                }
                field("Max. VAT Difference Allowed";"Max. VAT Difference Allowed")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the maximum tax correction amount allowed for the local currency.';
                }
                field("VAT Rounding Type";"VAT Rounding Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies how the program will round tax when calculated for the local currency.';
                }
                field("Bank Account Nos.";"Bank Account Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code for the number series that will be used to assign numbers to bank accounts.';
                }
                field("Bank Rec. Adj. Doc. Nos.";"Bank Rec. Adj. Doc. Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the bank reconciliation adjustment document number for general ledger setup. You can select the document number from the No. Series table.';
                }
                field("Deposit Nos.";"Deposit Nos.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the deposit number for general ledger setup. You can select the deposit number from the No. Series table.';
                }
                field("Cafeteria Notification E-mail";"Cafeteria Notification E-mail")
                {
                    ApplicationArea = Basic;
                }
                field("Bill-to/Sell-to VAT Calc.";"Bill-to/Sell-to VAT Calc.")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies where the Tax Bus. Posting Group code on an order or invoice is copied from.';
                }
                field("Print VAT specification in LCY";"Print VAT specification in LCY")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that an extra tax specification in local currency will be included on documents in a foreign currency.';
                }
                field("VAT in Use";"VAT in Use")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you are posting US or CA sales tax and do not want to have to set up posting groups on G/L accounts.';
                }
                field("Use Legacy G/L Entry Locking";"Use Legacy G/L Entry Locking")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the G/L Entry table should be locked during sales, purchase and service posting.';
                }
                field("Bank Recon. with Auto. Match";"Bank Recon. with Auto. Match")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you perform bank account reconciliation with functionality that includes import of bank statement files and automatic matching with bank ledger entries.';
                }
                field("Default Customer";"Default Customer")
                {
                    ApplicationArea = Basic;
                }
                field("Default Receipt Nos.";"Default Receipt Nos.")
                {
                    ApplicationArea = Basic;
                }
                field("Visitor No.";"Visitor No.")
                {
                    ApplicationArea = Basic;
                }
                field("Staff Register Nos";"Staff Register Nos")
                {
                    ApplicationArea = Basic;
                }
                field("Venue Booking Nos.";"Venue Booking Nos.")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control1900309501)
            {
                Caption = 'Dimensions';
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a global dimension. Global dimensions are the dimensions that you analyze most frequently.';
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies a global dimension. Global dimensions are the dimensions that you analyze most frequently.';
                }
                field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 1.';
                }
                field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 2.';
                }
                field("Shortcut Dimension 3 Code";"Shortcut Dimension 3 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 3.';
                }
                field("Shortcut Dimension 4 Code";"Shortcut Dimension 4 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 4.';
                }
                field("Shortcut Dimension 5 Code";"Shortcut Dimension 5 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 5.';
                }
                field("Shortcut Dimension 6 Code";"Shortcut Dimension 6 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 6.';
                }
                field("Shortcut Dimension 7 Code";"Shortcut Dimension 7 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 7.';
                }
                field("Shortcut Dimension 8 Code";"Shortcut Dimension 8 Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for Shortcut Dimension 8.';
                }
            }
            group(Reporting)
            {
                Caption = 'Reporting';
                field("Acc. Sched. for Balance Sheet";"Acc. Sched. for Balance Sheet")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which account schedule name is used to generate the Balance Sheet report.';
                }
                field("Acc. Sched. for Income Stmt.";"Acc. Sched. for Income Stmt.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which account schedule name is used to generate the Income Statement report.';
                }
                field("Acc. Sched. for Cash Flow Stmt";"Acc. Sched. for Cash Flow Stmt")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies which account schedule name is used to generate the Cash Flow Statement report.';
                }
                field("Acc. Sched. for Retained Earn.";"Acc. Sched. for Retained Earn.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies which account schedule name is used to generate the Retained Earnings report.';
                }
                field("Additional Reporting Currency";"Additional Reporting Currency")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency that will be used as an additional reporting currency in the general ledger application area.';

                    trigger OnValidate()
                    var
                        Confirmed: Boolean;
                    begin
                        if "Additional Reporting Currency" <> xRec."Additional Reporting Currency" then begin
                          if "Additional Reporting Currency" = '' then
                            Confirmed := Confirm(Text002,false)
                          else
                            Confirmed := Confirm(Text003,false);
                          if not Confirmed then
                            Error('');
                        end;
                    end;
                }
                field("VAT Exchange Rate Adjustment";"VAT Exchange Rate Adjustment")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how the accounts set up for tax posting in the Tax Posting Setup table will be adjusted for exchange rate fluctuations.';
                }
                field("VAT Reg. No. Validation URL";"VAT Reg. No. Validation URL")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the URL of the EU web service that is used by default to verify tax registration numbers.';
                }
            }
            group(Application)
            {
                Caption = 'Application';
                field("Appln. Rounding Precision";"Appln. Rounding Precision")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rounding difference that will be allowed when you apply entries in $ to entries in a different currency.';
                }
                field("Pmt. Disc. Tolerance Warning";"Pmt. Disc. Tolerance Warning")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a warning will appear every time an application occurs between the dates specified in the Payment Discount Date field and the Pmt. Disc. Tolerance Date field in the General Ledger Setup table.';
                }
                field("Pmt. Disc. Tolerance Posting";"Pmt. Disc. Tolerance Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting method, which the program follows when posting a payment tolerance.';
                }
                field("Payment Discount Grace Period";"Payment Discount Grace Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of days that a payment or refund can pass the payment discount due date and still receive payment discount.';

                    trigger OnValidate()
                    var
                        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
                    begin
                        if Confirm(Text001,true) then
                          PaymentToleranceMgt.CalcGracePeriodCVLedgEntry("Payment Discount Grace Period");
                    end;
                }
                field("Payment Tolerance Warning";"Payment Tolerance Warning")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a warning will appear when an application has a balance within the tolerance specified in the Max. Payment Tolerance field in the General Ledger Setup table.';
                }
                field("Payment Tolerance Posting";"Payment Tolerance Posting")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the posting methods when posting a payment tolerance.';
                }
                field("Payment Tolerance %";"Payment Tolerance %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the percentage that the payment or refund is allowed to be less than the amount on the invoice or credit memo.';
                }
                field("Max. Payment Tolerance Amount";"Max. Payment Tolerance Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the maximum allowed amount that the payment or refund can differ from the amount on the invoice or credit memo.';
                }
            }
            group("Electronic Invoice")
            {
                Caption = 'Electronic Invoice';
                field("SAT Certificate Thumbprint";"SAT Certificate Thumbprint")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the thumbprint of the certificate from the tax authorities that you want to use for issuing electronic invoices.';
                }
                field("Send PDF Report";"Send PDF Report")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if you want to include a PDF when you email electronic invoices to customers or vendors. Electronic invoices are always sent as an XML file, this option allows you to include a PDF with the XML file.';
                }
                field("PAC Code";"PAC Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the authorized service provider, PAC, that you want apply digital stamps to your electronic invoices.';
                }
                field("PAC Environment";"PAC Environment")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if your company uses electronic invoices in Mexico, and if you are using the web services of your authorized service provider, PAC, in a test environment or a production environment.';
                }
            }
            group("Payroll Transaction Import")
            {
                Caption = 'Payroll Transaction Import';
                Visible = false;
                field("Payroll Trans. Import Format";"Payroll Trans. Import Format")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the format of the payroll transaction file that can be imported into the General Journal window.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Change Global Dimensions")
                {
                    AccessByPermission = TableData Dimension=M;
                    ApplicationArea = Suite;
                    Caption = 'Change Global Dimensions';
                    Ellipsis = true;
                    Image = ChangeDimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Change either one or both of the global dimensions.';

                    trigger OnAction()
                    begin
                        Report.RunModal(Report::"Change Global Dimensions");
                    end;
                }
                action("Change Payment &Tolerance")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Change Payment &Tolerance';
                    Image = ChangePaymentTolerance;
                    ToolTip = 'Change either or both the maximum payment tolerance and the payment tolerance percentage and filters by currency.';

                    trigger OnAction()
                    var
                        Currency: Record Currency;
                        ChangePmtTol: Report "Change Payment Tolerance";
                    begin
                        Currency.Init;
                        ChangePmtTol.SetCurrency(Currency);
                        ChangePmtTol.RunModal;
                    end;
                }
            }
        }
        area(navigation)
        {
            action("Accounting Periods")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Accounting Periods';
                Image = AccountingPeriods;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Accounting Periods";
                ToolTip = 'Set up the number of accounting periods, such as 12 monthly periods, within the fiscal year and specify which period is the start of the new fiscal year.';
            }
            action(Dimensions)
            {
                ApplicationArea = Suite;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page Dimensions;
                ToolTip = 'Set up dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action("User Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Setup';
                Image = UserSetup;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "User Setup";
                ToolTip = 'Set up users to restrict access to post to the general ledger.';
            }
            action("Cash Flow Setup")
            {
                ApplicationArea = Basic;
                Caption = 'Cash Flow Setup';
                Image = CashFlowSetup;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Cash Flow Setup";
                ToolTip = 'Set up the accounts where cash flow figures for sales, purchase, and fixed-asset transactions are stored.';
            }
            action("Bank Export/Import Setup")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Bank Export/Import Setup';
                Image = ImportExport;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                RunObject = Page "Bank Export/Import Setup";
                ToolTip = 'Set up the formats for exporting vendor payments and for importing bank statements.';
            }
            group("General Ledger Posting")
            {
                Caption = 'General Ledger Posting';
                action("General Posting Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'General Posting Setup';
                    Image = GeneralPostingSetup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "General Posting Setup";
                    ToolTip = 'Set up combinations of general business and general product posting groups by specifying account numbers for posting of sales and purchase transactions.';
                }
                action("Gen. Business Posting Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gen. Business Posting Groups';
                    Image = GeneralPostingSetup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Gen. Business Posting Groups";
                    ToolTip = 'Set up the trade-type posting groups that you assign to customer and vendor cards to link transactions with the appropriate general ledger account.';
                }
                action("Gen. Product Posting Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Gen. Product Posting Groups';
                    Image = GeneralPostingSetup;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Gen. Product Posting Groups";
                    ToolTip = 'Set up the item-type posting groups that you assign to customer and vendor cards to link transactions with the appropriate general ledger account.';
                }
            }
            group("Tax Posting")
            {
                Caption = 'Tax Posting';
                action("Tax Posting Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Posting Setup';
                    Image = VATPostingSetup;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "VAT Posting Setup";
                    ToolTip = 'Set up how tax must be posted to the general ledger.';
                }
                action("Tax Business Posting Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Business Posting Groups';
                    Image = VATPostingSetup;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "VAT Business Posting Groups";
                    ToolTip = 'Set up the trade-type posting groups that you assign to customer and vendor cards to link Tax amounts with the appropriate general ledger account.';
                }
                action("Tax Product Posting Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Product Posting Groups';
                    Image = VATPostingSetup;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "VAT Product Posting Groups";
                    ToolTip = 'Set up the item-type posting groups that you assign to customer and vendor cards to link Tax amounts with the appropriate general ledger account.';
                }
                action("Tax Report Setup")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Tax Report Setup';
                    Image = VATPostingSetup;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    RunObject = Page "VAT Report Setup";
                    ToolTip = 'Set up number series and options for the report that you periodically send to the authorities to declare your tax.';
                }
            }
            group("Bank Posting")
            {
                Caption = 'Bank Posting';
                action("Bank Account Posting Groups")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Bank Account Posting Groups';
                    Image = BankAccount;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    RunObject = Page "Bank Account Posting Groups";
                    ToolTip = 'Set up posting groups, so that payments in and out of each bank account are posted to the specified general ledger account.';
                }
            }
            group("Journal Templates")
            {
                Caption = 'Journal Templates';
                action("General Journal Templates")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'General Journal Templates';
                    Image = JournalSetup;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    RunObject = Page "General Journal Templates";
                    ToolTip = 'Set up templates for the journals that you use for bookkeeping tasks. Templates allow you to work in a journal window that is designed for a specific purpose.';
                }
                action("VAT Statement Templates")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'VAT Statement Templates';
                    Image = VATStatement;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    RunObject = Page "VAT Statement Templates";
                    ToolTip = 'Set up the reports that you use to settle tax and report to the customs and tax authorities.';
                }
                action("Intrastat Templates")
                {
                    ApplicationArea = Basic;
                    Caption = 'Intrastat Templates';
                    Image = Template;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    RunObject = Page "Intrastat Journal Templates";
                    ToolTip = 'Define how you want to set up and keep track of journals to report Intrastat.';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        Reset;
        if not Get then begin
          Init;
          Insert;
        end;
    end;

    var
        Text001: label 'Do you want to change all open entries for every customer and vendor that are not blocked?';
        Text002: label 'If you delete the additional reporting currency, future general ledger entries are posted in $ only. Deleting the additional reporting currency does not affect already posted general ledger entries.\\Are you sure that you want to delete the additional reporting currency?';
        Text003: label 'If you change the additional reporting currency, future general ledger entries are posted in the new reporting currency and in $. To enable the additional reporting currency, a batch job opens, and running the batch job recalculates already posted general ledger entries in the new additional reporting currency.\Entries will be deleted in the Analysis View if it is unblocked, and an update will be necessary.\\Are you sure that you want to change the additional reporting currency?';
}

