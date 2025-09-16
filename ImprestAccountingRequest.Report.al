#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51267 "Imprest Accounting Request"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Accounting Request.rdlc';

    dataset
    {
        dataitem(UnknownTable61704;UnknownTable61704)
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(No_ImprestHeader;"FIN-Imprest Header"."No.")
            {
            }
            column(Date_ImprestHeader;"FIN-Imprest Header".Date)
            {
            }
            column(CurrencyFactor_ImprestHeader;"FIN-Imprest Header"."Currency Factor")
            {
            }
            column(CurrencyCode_ImprestHeader;"FIN-Imprest Header"."Currency Code")
            {
            }
            column(Payee_ImprestHeader;"FIN-Imprest Header".Payee)
            {
            }
            column(OnBehalfOf_ImprestHeader;"FIN-Imprest Header"."On Behalf Of")
            {
            }
            column(Cashier_ImprestHeader;"FIN-Imprest Header".Cashier)
            {
            }
            column(Posted_ImprestHeader;"FIN-Imprest Header".Posted)
            {
            }
            column(DatePosted_ImprestHeader;"FIN-Imprest Header"."Date Posted")
            {
            }
            column(TimePosted_ImprestHeader;"FIN-Imprest Header"."Time Posted")
            {
            }
            column(PostedBy_ImprestHeader;"FIN-Imprest Header"."Posted By")
            {
            }
            column(TotalPaymentAmount_ImprestHeader;"FIN-Imprest Header"."Total Payment Amount")
            {
            }
            column(PayingBankAccount_ImprestHeader;"FIN-Imprest Header"."Paying Bank Account")
            {
            }
            column(GlobalDimension1Code_ImprestHeader;"FIN-Imprest Header"."Global Dimension 1 Code")
            {
            }
            column(Status_ImprestHeader;"FIN-Imprest Header".Status)
            {
            }
            column(PaymentType_ImprestHeader;"FIN-Imprest Header"."Payment Type")
            {
            }
            column(ShortcutDimension2Code_ImprestHeader;"FIN-Imprest Header"."Shortcut Dimension 2 Code")
            {
            }
            column(FunctionName_ImprestHeader;"FIN-Imprest Header"."Function Name")
            {
            }
            column(BudgetCenterName_ImprestHeader;"FIN-Imprest Header"."Budget Center Name")
            {
            }
            column(BankName_ImprestHeader;"FIN-Imprest Header"."Bank Name")
            {
            }
            column(NoSeries_ImprestHeader;"FIN-Imprest Header"."No. Series")
            {
            }
            column(Select_ImprestHeader;"FIN-Imprest Header".Select)
            {
            }
            column(TotalVATAmount_ImprestHeader;"FIN-Imprest Header"."Total VAT Amount")
            {
            }
            column(TotalWitholdingTaxAmount_ImprestHeader;"FIN-Imprest Header"."Total Witholding Tax Amount")
            {
            }
            column(TotalNetAmount_ImprestHeader;"FIN-Imprest Header"."Total Net Amount")
            {
            }
            column(CurrentStatus_ImprestHeader;"FIN-Imprest Header"."Current Status")
            {
            }
            column(ChequeNo_ImprestHeader;"FIN-Imprest Header"."Cheque No.")
            {
            }
            column(PayMode_ImprestHeader;"FIN-Imprest Header"."Pay Mode")
            {
            }
            column(PaymentReleaseDate_ImprestHeader;"FIN-Imprest Header"."Payment Release Date")
            {
            }
            column(NoPrinted_ImprestHeader;"FIN-Imprest Header"."No. Printed")
            {
            }
            column(VATBaseAmount_ImprestHeader;"FIN-Imprest Header"."VAT Base Amount")
            {
            }
            column(ExchangeRate_ImprestHeader;"FIN-Imprest Header"."Exchange Rate")
            {
            }
            column(CurrencyReciprical_ImprestHeader;"FIN-Imprest Header"."Currency Reciprical")
            {
            }
            column(CurrentSourceACBal_ImprestHeader;"FIN-Imprest Header"."Current Source A/C Bal.")
            {
            }
            column(CancellationRemarks_ImprestHeader;"FIN-Imprest Header"."Cancellation Remarks")
            {
            }
            column(RegisterNumber_ImprestHeader;"FIN-Imprest Header"."Register Number")
            {
            }
            column(FromEntryNo_ImprestHeader;"FIN-Imprest Header"."From Entry No.")
            {
            }
            column(ToEntryNo_ImprestHeader;"FIN-Imprest Header"."To Entry No.")
            {
            }
            column(InvoiceCurrencyCode_ImprestHeader;"FIN-Imprest Header"."Invoice Currency Code")
            {
            }
            column(TotalNetAmountLCY_ImprestHeader;"FIN-Imprest Header"."Total Net Amount LCY")
            {
            }
            column(DocumentType_ImprestHeader;"FIN-Imprest Header"."Document Type")
            {
            }
            column(ShortcutDimension3Code_ImprestHeader;"FIN-Imprest Header"."Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code_ImprestHeader;"FIN-Imprest Header"."Shortcut Dimension 4 Code")
            {
            }
            column(Dim3_ImprestHeader;"FIN-Imprest Header".Dim3)
            {
            }
            column(Dim4_ImprestHeader;"FIN-Imprest Header".Dim4)
            {
            }
            column(ResponsibilityCenter_ImprestHeader;"FIN-Imprest Header"."Responsibility Center")
            {
            }
            column(AccountType_ImprestHeader;"FIN-Imprest Header"."Account Type")
            {
            }
            column(AccountNo_ImprestHeader;"FIN-Imprest Header"."Account No.")
            {
            }
            column(SurrenderStatus_ImprestHeader;"FIN-Imprest Header"."Surrender Status")
            {
            }
            column(Purpose_ImprestHeader;"FIN-Imprest Header".Purpose)
            {
            }
            column(PaymentVoucherNo_ImprestHeader;"FIN-Imprest Header"."Payment Voucher No")
            {
            }
            column(SerialNo_ImprestHeader;"FIN-Imprest Header"."Serial No.")
            {
            }
            column(BudgetedAmount_ImprestHeader;"FIN-Imprest Header"."Budgeted Amount")
            {
            }
            column(ActualExpenditure_ImprestHeader;"FIN-Imprest Header"."Actual Expenditure")
            {
            }
            column(CommittedAmount_ImprestHeader;"FIN-Imprest Header"."Committed Amount")
            {
            }
            column(BudgetBalance_ImprestHeader;"FIN-Imprest Header"."Budget Balance")
            {
            }
            column(RequestedBy_ImprestHeader;"FIN-Imprest Header"."Requested By")
            {
            }
            column(CompLogo;CompInf.Picture)
            {
            }
            column(CompName;CompInf.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                   CompInf.Get;
                   CompInf.CalcFields(CompInf.Picture);
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

    var
        CompInf: Record "Company Information";
}

