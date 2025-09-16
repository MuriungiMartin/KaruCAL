#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51078 "Imprest Accounting"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Imprest Accounting.rdlc';

    dataset
    {
        dataitem(UnknownTable61504;UnknownTable61504)
        {
            RequestFilterFields = No,"Surrender Date";
            column(ReportForNavId_1; 1)
            {
            }
            column(No_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".No)
            {
            }
            column(SurrenderDate_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Surrender Date")
            {
            }
            column(Type_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Type)
            {
            }
            column(PayMode_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Pay Mode")
            {
            }
            column(ChequeNo_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Cheque No")
            {
            }
            column(ChequeDate_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Cheque Date")
            {
            }
            column(ChequeType_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Cheque Type")
            {
            }
            column(BankCode_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Bank Code")
            {
            }
            column(ReceivedFrom_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Received From")
            {
            }
            column(OnBehalfOf_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."On Behalf Of")
            {
            }
            column(Cashier_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Cashier)
            {
            }
            column(AccountType_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Account Type")
            {
            }
            column(AccountNo_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Account No.")
            {
            }
            column(NoSeries_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."No. Series")
            {
            }
            column(AccountName_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Account Name")
            {
            }
            column(Posted_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Posted)
            {
            }
            column(DatePosted_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Date Posted")
            {
            }
            column(TimePosted_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Time Posted")
            {
            }
            column(PostedBy_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Posted By")
            {
            }
            column(Amount_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Amount)
            {
            }
            column(Remarks_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Remarks)
            {
            }
            column(TransactionName_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Transaction Name")
            {
            }
            column(NetAmount_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Net Amount")
            {
            }
            column(PayingBankAccount_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Paying Bank Account")
            {
            }
            column(Payee_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Payee)
            {
            }
            column(GlobalDimension1Code_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Global Dimension 1 Code")
            {
            }
            column(GlobalDimension2Code_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Global Dimension 2 Code")
            {
            }
            column(BankAccountNo_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Bank Account No")
            {
            }
            column(CashierBankAccount_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Cashier Bank Account")
            {
            }
            column(Status_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Status)
            {
            }
            column(Grouping_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Grouping)
            {
            }
            column(PaymentType_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Payment Type")
            {
            }
            column(BankType_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Bank Type")
            {
            }
            column(PVType_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."PV Type")
            {
            }
            column(ApplytoID_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Apply to ID")
            {
            }
            column(NoPrinted_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."No. Printed")
            {
            }
            column(ImprestIssueDate_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Imprest Issue Date")
            {
            }
            column(Surrendered_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Surrendered)
            {
            }
            column(ImprestIssueDocNo_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Imprest Issue Doc. No")
            {
            }
            column(VoteBook_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Vote Book")
            {
            }
            column(TotalAllocation_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Total Allocation")
            {
            }
            column(TotalExpenditure_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Total Expenditure")
            {
            }
            column(TotalCommitments_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Total Commitments")
            {
            }
            column(Balance_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Balance)
            {
            }
            column(BalanceLessthisEntry_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Balance Less this Entry")
            {
            }
            column(PettyCash_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Petty Cash")
            {
            }
            column(ShortcutDimension2Code_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Shortcut Dimension 2 Code")
            {
            }
            column(FunctionName_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Function Name")
            {
            }
            column(BudgetCenterName_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Budget Center Name")
            {
            }
            column(UserID_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."User ID")
            {
            }
            column(IssueVoucherType_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Issue Voucher Type")
            {
            }
            column(ShortcutDimension3Code_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Shortcut Dimension 3 Code")
            {
            }
            column(ShortcutDimension4Code_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Shortcut Dimension 4 Code")
            {
            }
            column(Dim3_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Dim3)
            {
            }
            column(Dim4_ImprestSurrenderHeader;"FIN-Imprest Surr. Header".Dim4)
            {
            }
            column(CurrencyFactor_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Currency Factor")
            {
            }
            column(CurrencyCode_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Currency Code")
            {
            }
            column(ResponsibilityCenter_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Responsibility Center")
            {
            }
            column(AmountSurrenderedLCY_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Amount Surrendered LCY")
            {
            }
            column(PVNo_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."PV No")
            {
            }
            column(PrintNo_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Print No.")
            {
            }
            column(CashSurrenderAmt_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Cash Surrender Amt")
            {
            }
            column(FinancialPeriod_ImprestSurrenderHeader;"FIN-Imprest Surr. Header"."Financial Period")
            {
            }
            column(CompanyName;CompInf.Name)
            {
            }
            column(CompanyPicture;CompInf.Picture)
            {
            }
            column(CompanyAddr1;CompInf.Address)
            {
            }
            column(CompanyAddr2;CompInf."Address 2")
            {
            }
            column(CompanyPhone;CompInf."Phone No.")
            {
            }
            column(CompanyName2;CompInf."Name 2")
            {
            }
            dataitem(UnknownTable61733;UnknownTable61733)
            {
                DataItemLink = "Surrender Doc No."=field(No);
                column(ReportForNavId_65; 65)
                {
                }
                column(SurrenderDocNo_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Surrender Doc No.")
                {
                }
                column(AccountNo_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Account No:")
                {
                }
                column(AccountName_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Account Name")
                {
                }
                column(Amount_ImprestSurrenderDetails;"FIN-Imprest Surrender Details".Amount)
                {
                }
                column(DueDate_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Due Date")
                {
                }
                column(ImprestHolder_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Imprest Holder")
                {
                }
                column(ActualSpent_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Actual Spent")
                {
                }
                column(Applyto_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Apply to")
                {
                }
                column(ApplytoID_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Apply to ID")
                {
                }
                column(SurrenderDate_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Surrender Date")
                {
                }
                column(Surrendered_ImprestSurrenderDetails;"FIN-Imprest Surrender Details".Surrendered)
                {
                }
                column(CashReceiptNo_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cash Receipt No")
                {
                }
                column(DateIssued_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Date Issued")
                {
                }
                column(TypeofSurrender_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Type of Surrender")
                {
                }
                column(DeptVchNo_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Dept. Vch. No.")
                {
                }
                column(CashSurrenderAmt_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cash Surrender Amt")
                {
                }
                column(BankPettyCash_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Bank/Petty Cash")
                {
                }
                column(DocNo_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Doc No.")
                {
                }
                column(ShortcutDimension1Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 2 Code")
                {
                }
                column(ShortcutDimension3Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 3 Code")
                {
                }
                column(ShortcutDimension4Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 4 Code")
                {
                }
                column(ShortcutDimension5Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 5 Code")
                {
                }
                column(ShortcutDimension6Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 6 Code")
                {
                }
                column(ShortcutDimension7Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 7 Code")
                {
                }
                column(ShortcutDimension8Code_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Shortcut Dimension 8 Code")
                {
                }
                column(VATProdPostingGroup_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."VAT Prod. Posting Group")
                {
                }
                column(ImprestType_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Imprest Type")
                {
                }
                column(CurrencyFactor_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Currency Factor")
                {
                }
                column(CurrencyCode_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Currency Code")
                {
                }
                column(AmountLCY_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Amount LCY")
                {
                }
                column(CashSurrenderAmtLCY_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cash Surrender Amt LCY")
                {
                }
                column(ImprestReqAmtLCY_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Imprest Req Amt LCY")
                {
                }
                column(CashReceiptAmount_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cash Receipt Amount")
                {
                }
                column(ChequeDepositSlipNo_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip No")
                {
                }
                column(ChequeDepositSlipDate_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip Date")
                {
                }
                column(ChequeDepositSlipType_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip Type")
                {
                }
                column(ChequeDepositSlipBank_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cheque/Deposit Slip Bank")
                {
                }
                column(CashPayMode_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Cash Pay Mode")
                {
                }
                column(OverExpenditure_ImprestSurrenderDetails;"FIN-Imprest Surrender Details"."Over Expenditure")
                {
                }
                column(NumberText;NumberText[1])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CheckReport.InitTextVariable();
                    //"Imprest Surrender Header".CALCFIELDS("Imprest Surrender Header"."Net Amount");
                    CheckReport.FormatNoText(NumberText,"FIN-Imprest Surr. Header"."Net Amount",'');
                end;
            }

            trigger OnPreDataItem()
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
        CheckReport: Report Check;
        NumberText: array [2] of Text[100];
}

