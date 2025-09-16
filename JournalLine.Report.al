#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51563 "Journal Line"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/Journal Line.rdlc';

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {
            column(ReportForNavId_1; 1)
            {
            }
            column(JournalTemplateName_GenJournalLine;"Gen. Journal Line"."Journal Template Name")
            {
            }
            column(LineNo_GenJournalLine;"Gen. Journal Line"."Line No.")
            {
            }
            column(AccountType_GenJournalLine;"Gen. Journal Line"."Account Type")
            {
            }
            column(AccountNo_GenJournalLine;"Gen. Journal Line"."Account No.")
            {
            }
            column(PostingDate_GenJournalLine;"Gen. Journal Line"."Posting Date")
            {
            }
            column(DocumentType_GenJournalLine;"Gen. Journal Line"."Document Type")
            {
            }
            column(DocumentNo_GenJournalLine;"Gen. Journal Line"."Document No.")
            {
            }
            column(Description_GenJournalLine;"Gen. Journal Line".Description)
            {
            }
            column(VAT_GenJournalLine;"Gen. Journal Line"."VAT %")
            {
            }
            column(BalAccountNo_GenJournalLine;"Gen. Journal Line"."Bal. Account No.")
            {
            }
            column(CurrencyCode_GenJournalLine;"Gen. Journal Line"."Currency Code")
            {
            }
            column(Amount_GenJournalLine;"Gen. Journal Line".Amount)
            {
            }
            column(DebitAmount_GenJournalLine;"Gen. Journal Line"."Debit Amount")
            {
            }
            column(CreditAmount_GenJournalLine;"Gen. Journal Line"."Credit Amount")
            {
            }
            column(AmountLCY_GenJournalLine;"Gen. Journal Line"."Amount (LCY)")
            {
            }
            column(BalanceLCY_GenJournalLine;"Gen. Journal Line"."Balance (LCY)")
            {
            }
            column(CurrencyFactor_GenJournalLine;"Gen. Journal Line"."Currency Factor")
            {
            }
            column(SalesPurchLCY_GenJournalLine;"Gen. Journal Line"."Sales/Purch. (LCY)")
            {
            }
            column(ProfitLCY_GenJournalLine;"Gen. Journal Line"."Profit (LCY)")
            {
            }
            column(InvDiscountLCY_GenJournalLine;"Gen. Journal Line"."Inv. Discount (LCY)")
            {
            }
            column(BilltoPaytoNo_GenJournalLine;"Gen. Journal Line"."Bill-to/Pay-to No.")
            {
            }
            column(PostingGroup_GenJournalLine;"Gen. Journal Line"."Posting Group")
            {
            }
            column(ShortcutDimension1Code_GenJournalLine;"Gen. Journal Line"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_GenJournalLine;"Gen. Journal Line"."Shortcut Dimension 2 Code")
            {
            }
            column(SalespersPurchCode_GenJournalLine;"Gen. Journal Line"."Salespers./Purch. Code")
            {
            }
            column(SourceCode_GenJournalLine;"Gen. Journal Line"."Source Code")
            {
            }
            column(SystemCreatedEntry_GenJournalLine;"Gen. Journal Line"."System-Created Entry")
            {
            }
            column(OnHold_GenJournalLine;"Gen. Journal Line"."On Hold")
            {
            }
            column(AppliestoDocType_GenJournalLine;"Gen. Journal Line"."Applies-to Doc. Type")
            {
            }
            column(AppliestoDocNo_GenJournalLine;"Gen. Journal Line"."Applies-to Doc. No.")
            {
            }
            column(DueDate_GenJournalLine;"Gen. Journal Line"."Due Date")
            {
            }
            column(PmtDiscountDate_GenJournalLine;"Gen. Journal Line"."Pmt. Discount Date")
            {
            }
            column(PaymentDiscount_GenJournalLine;"Gen. Journal Line"."Payment Discount %")
            {
            }
            column(JobNo_GenJournalLine;"Gen. Journal Line"."Job No.")
            {
            }
            column(Quantity_GenJournalLine;"Gen. Journal Line".Quantity)
            {
            }
            column(VATAmount_GenJournalLine;"Gen. Journal Line"."VAT Amount")
            {
            }
            column(VATPosting_GenJournalLine;"Gen. Journal Line"."VAT Posting")
            {
            }
            column(PaymentTermsCode_GenJournalLine;"Gen. Journal Line"."Payment Terms Code")
            {
            }
            column(AppliestoID_GenJournalLine;"Gen. Journal Line"."Applies-to ID")
            {
            }
            column(BusinessUnitCode_GenJournalLine;"Gen. Journal Line"."Business Unit Code")
            {
            }
            column(JournalBatchName_GenJournalLine;"Gen. Journal Line"."Journal Batch Name")
            {
            }
            column(ReasonCode_GenJournalLine;"Gen. Journal Line"."Reason Code")
            {
            }
            column(RecurringMethod_GenJournalLine;"Gen. Journal Line"."Recurring Method")
            {
            }
            column(ExpirationDate_GenJournalLine;"Gen. Journal Line"."Expiration Date")
            {
            }
            column(RecurringFrequency_GenJournalLine;"Gen. Journal Line"."Recurring Frequency")
            {
            }
            column(AllocatedAmtLCY_GenJournalLine;"Gen. Journal Line"."Allocated Amt. (LCY)")
            {
            }
            column(GenPostingType_GenJournalLine;"Gen. Journal Line"."Gen. Posting Type")
            {
            }
            column(GenBusPostingGroup_GenJournalLine;"Gen. Journal Line"."Gen. Bus. Posting Group")
            {
            }
            column(GenProdPostingGroup_GenJournalLine;"Gen. Journal Line"."Gen. Prod. Posting Group")
            {
            }
            column(VATCalculationType_GenJournalLine;"Gen. Journal Line"."VAT Calculation Type")
            {
            }
            column(EU3PartyTrade_GenJournalLine;"Gen. Journal Line"."EU 3-Party Trade")
            {
            }
            column(AllowApplication_GenJournalLine;"Gen. Journal Line"."Allow Application")
            {
            }
            column(BalAccountType_GenJournalLine;"Gen. Journal Line"."Bal. Account Type")
            {
            }
            column(BalGenPostingType_GenJournalLine;"Gen. Journal Line"."Bal. Gen. Posting Type")
            {
            }
            column(BalGenBusPostingGroup_GenJournalLine;"Gen. Journal Line"."Bal. Gen. Bus. Posting Group")
            {
            }
            column(BalGenProdPostingGroup_GenJournalLine;"Gen. Journal Line"."Bal. Gen. Prod. Posting Group")
            {
            }
            column(BalVATCalculationType_GenJournalLine;"Gen. Journal Line"."Bal. VAT Calculation Type")
            {
            }
            column(BalVAT_GenJournalLine;"Gen. Journal Line"."Bal. VAT %")
            {
            }
            column(BalVATAmount_GenJournalLine;"Gen. Journal Line"."Bal. VAT Amount")
            {
            }
            column(BankPaymentType_GenJournalLine;"Gen. Journal Line"."Bank Payment Type")
            {
            }
            column(VATBaseAmount_GenJournalLine;"Gen. Journal Line"."VAT Base Amount")
            {
            }
            column(BalVATBaseAmount_GenJournalLine;"Gen. Journal Line"."Bal. VAT Base Amount")
            {
            }
            column(Correction_GenJournalLine;"Gen. Journal Line".Correction)
            {
            }
            column(CheckPrinted_GenJournalLine;"Gen. Journal Line"."Check Printed")
            {
            }
            column(DocumentDate_GenJournalLine;"Gen. Journal Line"."Document Date")
            {
            }
            column(ExternalDocumentNo_GenJournalLine;"Gen. Journal Line"."External Document No.")
            {
            }
            column(SourceType_GenJournalLine;"Gen. Journal Line"."Source Type")
            {
            }
            column(SourceNo_GenJournalLine;"Gen. Journal Line"."Source No.")
            {
            }
            column(PostingNoSeries_GenJournalLine;"Gen. Journal Line"."Posting No. Series")
            {
            }
            column(TaxAreaCode_GenJournalLine;"Gen. Journal Line"."Tax Area Code")
            {
            }
            column(TaxLiable_GenJournalLine;"Gen. Journal Line"."Tax Liable")
            {
            }
            column(TaxGroupCode_GenJournalLine;"Gen. Journal Line"."Tax Group Code")
            {
            }
            column(UseTax_GenJournalLine;"Gen. Journal Line"."Use Tax")
            {
            }
            column(BalTaxAreaCode_GenJournalLine;"Gen. Journal Line"."Bal. Tax Area Code")
            {
            }
            column(BalTaxLiable_GenJournalLine;"Gen. Journal Line"."Bal. Tax Liable")
            {
            }
            column(BalTaxGroupCode_GenJournalLine;"Gen. Journal Line"."Bal. Tax Group Code")
            {
            }
            column(BalUseTax_GenJournalLine;"Gen. Journal Line"."Bal. Use Tax")
            {
            }
            column(VATBusPostingGroup_GenJournalLine;"Gen. Journal Line"."VAT Bus. Posting Group")
            {
            }
            column(VATProdPostingGroup_GenJournalLine;"Gen. Journal Line"."VAT Prod. Posting Group")
            {
            }
            column(BalVATBusPostingGroup_GenJournalLine;"Gen. Journal Line"."Bal. VAT Bus. Posting Group")
            {
            }
            column(BalVATProdPostingGroup_GenJournalLine;"Gen. Journal Line"."Bal. VAT Prod. Posting Group")
            {
            }
            column(AdditionalCurrencyPosting_GenJournalLine;"Gen. Journal Line"."Additional-Currency Posting")
            {
            }
            column(FAAddCurrencyFactor_GenJournalLine;"Gen. Journal Line"."FA Add.-Currency Factor")
            {
            }
            column(SourceCurrencyCode_GenJournalLine;"Gen. Journal Line"."Source Currency Code")
            {
            }
            column(SourceCurrencyAmount_GenJournalLine;"Gen. Journal Line"."Source Currency Amount")
            {
            }
            column(SourceCurrVATBaseAmount_GenJournalLine;"Gen. Journal Line"."Source Curr. VAT Base Amount")
            {
            }
            column(SourceCurrVATAmount_GenJournalLine;"Gen. Journal Line"."Source Curr. VAT Amount")
            {
            }
            column(VATBaseDiscount_GenJournalLine;"Gen. Journal Line"."VAT Base Discount %")
            {
            }
            column(VATAmountLCY_GenJournalLine;"Gen. Journal Line"."VAT Amount (LCY)")
            {
            }
            column(VATBaseAmountLCY_GenJournalLine;"Gen. Journal Line"."VAT Base Amount (LCY)")
            {
            }
            column(BalVATAmountLCY_GenJournalLine;"Gen. Journal Line"."Bal. VAT Amount (LCY)")
            {
            }
            column(BalVATBaseAmountLCY_GenJournalLine;"Gen. Journal Line"."Bal. VAT Base Amount (LCY)")
            {
            }
            column(ReversingEntry_GenJournalLine;"Gen. Journal Line"."Reversing Entry")
            {
            }
            column(AllowZeroAmountPosting_GenJournalLine;"Gen. Journal Line"."Allow Zero-Amount Posting")
            {
            }
            column(ShiptoOrderAddressCode_GenJournalLine;"Gen. Journal Line"."Ship-to/Order Address Code")
            {
            }
            column(VATDifference_GenJournalLine;"Gen. Journal Line"."VAT Difference")
            {
            }
            column(BalVATDifference_GenJournalLine;"Gen. Journal Line"."Bal. VAT Difference")
            {
            }
            column(ICPartnerCode_GenJournalLine;"Gen. Journal Line"."IC Partner Code")
            {
            }
            column(ICDirection_GenJournalLine;"Gen. Journal Line"."IC Direction")
            {
            }
            column(ICPartnerGLAccNo_GenJournalLine;"Gen. Journal Line"."IC Partner G/L Acc. No.")
            {
            }
            column(ICPartnerTransactionNo_GenJournalLine;"Gen. Journal Line"."IC Partner Transaction No.")
            {
            }
            column(SelltoBuyfromNo_GenJournalLine;"Gen. Journal Line"."Sell-to/Buy-from No.")
            {
            }
            column(VATRegistrationNo_GenJournalLine;"Gen. Journal Line"."VAT Registration No.")
            {
            }
            column(CountryRegionCode_GenJournalLine;"Gen. Journal Line"."Country/Region Code")
            {
            }
            column(Prepayment_GenJournalLine;"Gen. Journal Line".Prepayment)
            {
            }
            column(FinancialVoid_GenJournalLine;"Gen. Journal Line"."Financial Void")
            {
            }
            column(IncomingDocumentEntryNo_GenJournalLine;"Gen. Journal Line"."Incoming Document Entry No.")
            {
            }
            column(CreditorNo_GenJournalLine;"Gen. Journal Line"."Creditor No.")
            {
            }
            column(PaymentReference_GenJournalLine;"Gen. Journal Line"."Payment Reference")
            {
            }
            column(PaymentMethodCode_GenJournalLine;"Gen. Journal Line"."Payment Method Code")
            {
            }
            column(AppliestoExtDocNo_GenJournalLine;"Gen. Journal Line"."Applies-to Ext. Doc. No.")
            {
            }
            column(RecipientBankAccount_GenJournalLine;"Gen. Journal Line"."Recipient Bank Account")
            {
            }
            column(MessagetoRecipient_GenJournalLine;"Gen. Journal Line"."Message to Recipient")
            {
            }
            column(ExportedtoPaymentFile_GenJournalLine;"Gen. Journal Line"."Exported to Payment File")
            {
            }
            column(HasPaymentExportError_GenJournalLine;"Gen. Journal Line"."Has Payment Export Error")
            {
            }
            column(DimensionSetID_GenJournalLine;"Gen. Journal Line"."Dimension Set ID")
            {
            }
            column(CreditCardNo_GenJournalLine;"Gen. Journal Line"."Credit Card No.")
            {
            }
            column(JobTaskNo_GenJournalLine;"Gen. Journal Line"."Job Task No.")
            {
            }
            column(JobUnitPriceLCY_GenJournalLine;"Gen. Journal Line"."Job Unit Price (LCY)")
            {
            }
            column(JobTotalPriceLCY_GenJournalLine;"Gen. Journal Line"."Job Total Price (LCY)")
            {
            }
            column(JobQuantity_GenJournalLine;"Gen. Journal Line"."Job Quantity")
            {
            }
            column(JobUnitCostLCY_GenJournalLine;"Gen. Journal Line"."Job Unit Cost (LCY)")
            {
            }
            column(JobLineDiscount_GenJournalLine;"Gen. Journal Line"."Job Line Discount %")
            {
            }
            column(JobLineDiscAmountLCY_GenJournalLine;"Gen. Journal Line"."Job Line Disc. Amount (LCY)")
            {
            }
            column(JobUnitOfMeasureCode_GenJournalLine;"Gen. Journal Line"."Job Unit Of Measure Code")
            {
            }
            column(JobLineType_GenJournalLine;"Gen. Journal Line"."Job Line Type")
            {
            }
            column(JobUnitPrice_GenJournalLine;"Gen. Journal Line"."Job Unit Price")
            {
            }
            column(JobTotalPrice_GenJournalLine;"Gen. Journal Line"."Job Total Price")
            {
            }
            column(JobUnitCost_GenJournalLine;"Gen. Journal Line"."Job Unit Cost")
            {
            }
            column(JobTotalCost_GenJournalLine;"Gen. Journal Line"."Job Total Cost")
            {
            }
            column(JobLineDiscountAmount_GenJournalLine;"Gen. Journal Line"."Job Line Discount Amount")
            {
            }
            column(JobLineAmount_GenJournalLine;"Gen. Journal Line"."Job Line Amount")
            {
            }
            column(JobTotalCostLCY_GenJournalLine;"Gen. Journal Line"."Job Total Cost (LCY)")
            {
            }
            column(JobLineAmountLCY_GenJournalLine;"Gen. Journal Line"."Job Line Amount (LCY)")
            {
            }
            column(JobCurrencyFactor_GenJournalLine;"Gen. Journal Line"."Job Currency Factor")
            {
            }
            column(JobCurrencyCode_GenJournalLine;"Gen. Journal Line"."Job Currency Code")
            {
            }
            column(JobPlanningLineNo_GenJournalLine;"Gen. Journal Line"."Job Planning Line No.")
            {
            }
            column(JobRemainingQty_GenJournalLine;"Gen. Journal Line"."Job Remaining Qty.")
            {
            }
            column(DirectDebitMandateID_GenJournalLine;"Gen. Journal Line"."Direct Debit Mandate ID")
            {
            }
            column(PayerInformation_GenJournalLine;"Gen. Journal Line"."Payer Information")
            {
            }
            column(TransactionInformation_GenJournalLine;"Gen. Journal Line"."Transaction Information")
            {
            }
            column(AppliedAutomatically_GenJournalLine;"Gen. Journal Line"."Applied Automatically")
            {
            }
            column(CampaignNo_GenJournalLine;"Gen. Journal Line"."Campaign No.")
            {
            }
            column(ProdOrderNo_GenJournalLine;"Gen. Journal Line"."Prod. Order No.")
            {
            }
            column(FAPostingDate_GenJournalLine;"Gen. Journal Line"."FA Posting Date")
            {
            }
            column(FAPostingType_GenJournalLine;"Gen. Journal Line"."FA Posting Type")
            {
            }
            column(DepreciationBookCode_GenJournalLine;"Gen. Journal Line"."Depreciation Book Code")
            {
            }
            column(SalvageValue_GenJournalLine;"Gen. Journal Line"."Salvage Value")
            {
            }
            column(NoofDepreciationDays_GenJournalLine;"Gen. Journal Line"."No. of Depreciation Days")
            {
            }
            column(DepruntilFAPostingDate_GenJournalLine;"Gen. Journal Line"."Depr. until FA Posting Date")
            {
            }
            column(DeprAcquisitionCost_GenJournalLine;"Gen. Journal Line"."Depr. Acquisition Cost")
            {
            }
            column(MaintenanceCode_GenJournalLine;"Gen. Journal Line"."Maintenance Code")
            {
            }
            column(InsuranceNo_GenJournalLine;"Gen. Journal Line"."Insurance No.")
            {
            }
            column(BudgetedFANo_GenJournalLine;"Gen. Journal Line"."Budgeted FA No.")
            {
            }
            column(DuplicateinDepreciationBook_GenJournalLine;"Gen. Journal Line"."Duplicate in Depreciation Book")
            {
            }
            column(UseDuplicationList_GenJournalLine;"Gen. Journal Line"."Use Duplication List")
            {
            }
            column(FAReclassificationEntry_GenJournalLine;"Gen. Journal Line"."FA Reclassification Entry")
            {
            }
            column(FAErrorEntryNo_GenJournalLine;"Gen. Journal Line"."FA Error Entry No.")
            {
            }
            column(IndexEntry_GenJournalLine;"Gen. Journal Line"."Index Entry")
            {
            }
            column(SourceLineNo_GenJournalLine;"Gen. Journal Line"."Source Line No.")
            {
            }
            column(Comment_GenJournalLine;"Gen. Journal Line".Comment)
            {
            }
            column(RecoveryPriority_GenJournalLine;"Gen. Journal Line"."Recovery Priority")
            {
            }
            column(Remarks_GenJournalLine;"Gen. Journal Line"."Amount Payable")
            {
            }
            column(PayMode_GenJournalLine;"Gen. Journal Line"."Pay Mode")
            {
            }
            column(Status_GenJournalLine;"Gen. Journal Line".Status)
            {
            }
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
}

