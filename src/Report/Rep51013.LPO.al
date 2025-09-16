#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Report 51013 LPO
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/LPO.rdlc';

    dataset
    {
        dataitem("Purchase Header";"Purchase Header")
        {
            column(ReportForNavId_1000000000; 1000000000)
            {
            }
            column(DocumentType_PurchaseHeader;"Purchase Header"."Document Type")
            {
            }
            column(BuyfromVendorNo_PurchaseHeader;"Purchase Header"."Buy-from Vendor No.")
            {
            }
            column(No_PurchaseHeader;"Purchase Header"."No.")
            {
            }
            column(PaytoVendorNo_PurchaseHeader;"Purchase Header"."Pay-to Vendor No.")
            {
            }
            column(PaytoName_PurchaseHeader;"Purchase Header"."Pay-to Name")
            {
            }
            column(PaytoName2_PurchaseHeader;"Purchase Header"."Pay-to Name 2")
            {
            }
            column(PaytoAddress_PurchaseHeader;"Purchase Header"."Pay-to Address")
            {
            }
            column(PaytoAddress2_PurchaseHeader;"Purchase Header"."Pay-to Address 2")
            {
            }
            column(PaytoCity_PurchaseHeader;"Purchase Header"."Pay-to City")
            {
            }
            column(PaytoContact_PurchaseHeader;"Purchase Header"."Pay-to Contact")
            {
            }
            column(YourReference_PurchaseHeader;"Purchase Header"."Your Reference")
            {
            }
            column(ShiptoCode_PurchaseHeader;"Purchase Header"."Ship-to Code")
            {
            }
            column(ShiptoName_PurchaseHeader;"Purchase Header"."Ship-to Name")
            {
            }
            column(ShiptoName2_PurchaseHeader;"Purchase Header"."Ship-to Name 2")
            {
            }
            column(ShiptoAddress_PurchaseHeader;"Purchase Header"."Ship-to Address")
            {
            }
            column(ShiptoAddress2_PurchaseHeader;"Purchase Header"."Ship-to Address 2")
            {
            }
            column(ShiptoCity_PurchaseHeader;"Purchase Header"."Ship-to City")
            {
            }
            column(ShiptoContact_PurchaseHeader;"Purchase Header"."Ship-to Contact")
            {
            }
            column(OrderDate_PurchaseHeader;"Purchase Header"."Order Date")
            {
            }
            column(PostingDate_PurchaseHeader;"Purchase Header"."Posting Date")
            {
            }
            column(ExpectedReceiptDate_PurchaseHeader;"Purchase Header"."Expected Receipt Date")
            {
            }
            column(PostingDescription_PurchaseHeader;"Purchase Header"."Posting Description")
            {
            }
            column(PaymentTermsCode_PurchaseHeader;"Purchase Header"."Payment Terms Code")
            {
            }
            column(DueDate_PurchaseHeader;"Purchase Header"."Due Date")
            {
            }
            column(PaymentDiscount_PurchaseHeader;"Purchase Header"."Payment Discount %")
            {
            }
            column(PmtDiscountDate_PurchaseHeader;"Purchase Header"."Pmt. Discount Date")
            {
            }
            column(ShipmentMethodCode_PurchaseHeader;"Purchase Header"."Shipment Method Code")
            {
            }
            column(LocationCode_PurchaseHeader;"Purchase Header"."Location Code")
            {
            }
            column(ShortcutDimension1Code_PurchaseHeader;"Purchase Header"."Shortcut Dimension 1 Code")
            {
            }
            column(ShortcutDimension2Code_PurchaseHeader;"Purchase Header"."Shortcut Dimension 2 Code")
            {
            }
            column(VendorPostingGroup_PurchaseHeader;"Purchase Header"."Vendor Posting Group")
            {
            }
            column(CurrencyCode_PurchaseHeader;"Purchase Header"."Currency Code")
            {
            }
            column(CurrencyFactor_PurchaseHeader;"Purchase Header"."Currency Factor")
            {
            }
            column(PricesIncludingVAT_PurchaseHeader;"Purchase Header"."Prices Including VAT")
            {
            }
            column(InvoiceDiscCode_PurchaseHeader;"Purchase Header"."Invoice Disc. Code")
            {
            }
            column(LanguageCode_PurchaseHeader;"Purchase Header"."Language Code")
            {
            }
            column(PurchaserCode_PurchaseHeader;"Purchase Header"."Purchaser Code")
            {
            }
            column(OrderClass_PurchaseHeader;"Purchase Header"."Order Class")
            {
            }
            column(Comment_PurchaseHeader;"Purchase Header".Comment)
            {
            }
            column(NoPrinted_PurchaseHeader;"Purchase Header"."No. Printed")
            {
            }
            column(OnHold_PurchaseHeader;"Purchase Header"."On Hold")
            {
            }
            column(AppliestoDocType_PurchaseHeader;"Purchase Header"."Applies-to Doc. Type")
            {
            }
            column(AppliestoDocNo_PurchaseHeader;"Purchase Header"."Applies-to Doc. No.")
            {
            }
            column(BalAccountNo_PurchaseHeader;"Purchase Header"."Bal. Account No.")
            {
            }
            column(Receive_PurchaseHeader;"Purchase Header".Receive)
            {
            }
            column(Invoice_PurchaseHeader;"Purchase Header".Invoice)
            {
            }
            column(PrintPostedDocuments_PurchaseHeader;"Purchase Header"."Print Posted Documents")
            {
            }
            column(Amount_PurchaseHeader;"Purchase Header".Amount)
            {
            }
            column(AmountIncludingVAT_PurchaseHeader;"Purchase Header"."Amount Including VAT")
            {
            }
            column(ReceivingNo_PurchaseHeader;"Purchase Header"."Receiving No.")
            {
            }
            column(PostingNo_PurchaseHeader;"Purchase Header"."Posting No.")
            {
            }
            column(LastReceivingNo_PurchaseHeader;"Purchase Header"."Last Receiving No.")
            {
            }
            column(LastPostingNo_PurchaseHeader;"Purchase Header"."Last Posting No.")
            {
            }
            column(VendorOrderNo_PurchaseHeader;"Purchase Header"."Vendor Order No.")
            {
            }
            column(VendorShipmentNo_PurchaseHeader;"Purchase Header"."Vendor Shipment No.")
            {
            }
            column(VendorInvoiceNo_PurchaseHeader;"Purchase Header"."Vendor Invoice No.")
            {
            }
            column(VendorCrMemoNo_PurchaseHeader;"Purchase Header"."Vendor Cr. Memo No.")
            {
            }
            column(VATRegistrationNo_PurchaseHeader;"Purchase Header"."VAT Registration No.")
            {
            }
            column(SelltoCustomerNo_PurchaseHeader;"Purchase Header"."Sell-to Customer No.")
            {
            }
            column(ReasonCode_PurchaseHeader;"Purchase Header"."Reason Code")
            {
            }
            column(GenBusPostingGroup_PurchaseHeader;"Purchase Header"."Gen. Bus. Posting Group")
            {
            }
            column(TransactionType_PurchaseHeader;"Purchase Header"."Transaction Type")
            {
            }
            column(TransportMethod_PurchaseHeader;"Purchase Header"."Transport Method")
            {
            }
            column(VATCountryRegionCode_PurchaseHeader;"Purchase Header"."VAT Country/Region Code")
            {
            }
            column(BuyfromVendorName_PurchaseHeader;"Purchase Header"."Buy-from Vendor Name")
            {
            }
            column(BuyfromVendorName2_PurchaseHeader;"Purchase Header"."Buy-from Vendor Name 2")
            {
            }
            column(BuyfromAddress_PurchaseHeader;"Purchase Header"."Buy-from Address")
            {
            }
            column(BuyfromAddress2_PurchaseHeader;"Purchase Header"."Buy-from Address 2")
            {
            }
            column(BuyfromCity_PurchaseHeader;"Purchase Header"."Buy-from City")
            {
            }
            column(BuyfromContact_PurchaseHeader;"Purchase Header"."Buy-from Contact")
            {
            }
            column(PaytoPostCode_PurchaseHeader;"Purchase Header"."Pay-to Post Code")
            {
            }
            column(PaytoCounty_PurchaseHeader;"Purchase Header"."Pay-to County")
            {
            }
            column(PaytoCountryRegionCode_PurchaseHeader;"Purchase Header"."Pay-to Country/Region Code")
            {
            }
            column(BuyfromPostCode_PurchaseHeader;"Purchase Header"."Buy-from Post Code")
            {
            }
            column(BuyfromCounty_PurchaseHeader;"Purchase Header"."Buy-from County")
            {
            }
            column(BuyfromCountryRegionCode_PurchaseHeader;"Purchase Header"."Buy-from Country/Region Code")
            {
            }
            column(ShiptoPostCode_PurchaseHeader;"Purchase Header"."Ship-to Post Code")
            {
            }
            column(ShiptoCounty_PurchaseHeader;"Purchase Header"."Ship-to County")
            {
            }
            column(ShiptoCountryRegionCode_PurchaseHeader;"Purchase Header"."Ship-to Country/Region Code")
            {
            }
            column(BalAccountType_PurchaseHeader;"Purchase Header"."Bal. Account Type")
            {
            }
            column(OrderAddressCode_PurchaseHeader;"Purchase Header"."Order Address Code")
            {
            }
            column(EntryPoint_PurchaseHeader;"Purchase Header"."Entry Point")
            {
            }
            column(Correction_PurchaseHeader;"Purchase Header".Correction)
            {
            }
            column(DocumentDate_PurchaseHeader;"Purchase Header"."Document Date")
            {
            }
            column(Area_PurchaseHeader;"Purchase Header".Area)
            {
            }
            column(TransactionSpecification_PurchaseHeader;"Purchase Header"."Transaction Specification")
            {
            }
            column(PaymentMethodCode_PurchaseHeader;"Purchase Header"."Payment Method Code")
            {
            }
            column(NoSeries_PurchaseHeader;"Purchase Header"."No. Series")
            {
            }
            column(PostingNoSeries_PurchaseHeader;"Purchase Header"."Posting No. Series")
            {
            }
            column(ReceivingNoSeries_PurchaseHeader;"Purchase Header"."Receiving No. Series")
            {
            }
            column(TaxAreaCode_PurchaseHeader;"Purchase Header"."Tax Area Code")
            {
            }
            column(TaxLiable_PurchaseHeader;"Purchase Header"."Tax Liable")
            {
            }
            column(VATBusPostingGroup_PurchaseHeader;"Purchase Header"."VAT Bus. Posting Group")
            {
            }
            column(AppliestoID_PurchaseHeader;"Purchase Header"."Applies-to ID")
            {
            }
            column(VATBaseDiscount_PurchaseHeader;"Purchase Header"."VAT Base Discount %")
            {
            }
            column(Status_PurchaseHeader;"Purchase Header".Status)
            {
            }
            column(InvoiceDiscountCalculation_PurchaseHeader;"Purchase Header"."Invoice Discount Calculation")
            {
            }
            column(InvoiceDiscountValue_PurchaseHeader;"Purchase Header"."Invoice Discount Value")
            {
            }
            column(SendICDocument_PurchaseHeader;"Purchase Header"."Send IC Document")
            {
            }
            column(ICStatus_PurchaseHeader;"Purchase Header"."IC Status")
            {
            }
            column(BuyfromICPartnerCode_PurchaseHeader;"Purchase Header"."Buy-from IC Partner Code")
            {
            }
            column(PaytoICPartnerCode_PurchaseHeader;"Purchase Header"."Pay-to IC Partner Code")
            {
            }
            column(ICDirection_PurchaseHeader;"Purchase Header"."IC Direction")
            {
            }
            column(PrepaymentNo_PurchaseHeader;"Purchase Header"."Prepayment No.")
            {
            }
            column(LastPrepaymentNo_PurchaseHeader;"Purchase Header"."Last Prepayment No.")
            {
            }
            column(PrepmtCrMemoNo_PurchaseHeader;"Purchase Header"."Prepmt. Cr. Memo No.")
            {
            }
            column(LastPrepmtCrMemoNo_PurchaseHeader;"Purchase Header"."Last Prepmt. Cr. Memo No.")
            {
            }
            column(Prepayment_PurchaseHeader;"Purchase Header"."Prepayment %")
            {
            }
            column(PrepaymentNoSeries_PurchaseHeader;"Purchase Header"."Prepayment No. Series")
            {
            }
            column(CompressPrepayment_PurchaseHeader;"Purchase Header"."Compress Prepayment")
            {
            }
            column(PrepaymentDueDate_PurchaseHeader;"Purchase Header"."Prepayment Due Date")
            {
            }
            column(PrepmtCrMemoNoSeries_PurchaseHeader;"Purchase Header"."Prepmt. Cr. Memo No. Series")
            {
            }
            column(PrepmtPostingDescription_PurchaseHeader;"Purchase Header"."Prepmt. Posting Description")
            {
            }
            column(PrepmtPmtDiscountDate_PurchaseHeader;"Purchase Header"."Prepmt. Pmt. Discount Date")
            {
            }
            column(PrepmtPaymentTermsCode_PurchaseHeader;"Purchase Header"."Prepmt. Payment Terms Code")
            {
            }
            column(PrepmtPaymentDiscount_PurchaseHeader;"Purchase Header"."Prepmt. Payment Discount %")
            {
            }
            column(QuoteNo_PurchaseHeader;"Purchase Header"."Quote No.")
            {
            }
            column(JobQueueStatus_PurchaseHeader;"Purchase Header"."Job Queue Status")
            {
            }
            column(JobQueueEntryID_PurchaseHeader;"Purchase Header"."Job Queue Entry ID")
            {
            }
            column(DimensionSetID_PurchaseHeader;"Purchase Header"."Dimension Set ID")
            {
            }
            column(NoofArchivedVersions_PurchaseHeader;"Purchase Header"."No. of Archived Versions")
            {
            }
            column(DocNoOccurrence_PurchaseHeader;"Purchase Header"."Doc. No. Occurrence")
            {
            }
            column(CampaignNo_PurchaseHeader;"Purchase Header"."Campaign No.")
            {
            }
            column(BuyfromContactNo_PurchaseHeader;"Purchase Header"."Buy-from Contact No.")
            {
            }
            column(PaytoContactNo_PurchaseHeader;"Purchase Header"."Pay-to Contact No.")
            {
            }
            column(ResponsibilityCenter_PurchaseHeader;"Purchase Header"."Responsibility Center")
            {
            }
            column(CompletelyReceived_PurchaseHeader;"Purchase Header"."Completely Received")
            {
            }
            column(PostingfromWhseRef_PurchaseHeader;"Purchase Header"."Posting from Whse. Ref.")
            {
            }
            column(LocationFilter_PurchaseHeader;"Purchase Header"."Location Filter")
            {
            }
            column(RequestedReceiptDate_PurchaseHeader;"Purchase Header"."Requested Receipt Date")
            {
            }
            column(PromisedReceiptDate_PurchaseHeader;"Purchase Header"."Promised Receipt Date")
            {
            }
            column(LeadTimeCalculation_PurchaseHeader;"Purchase Header"."Lead Time Calculation")
            {
            }
            column(InboundWhseHandlingTime_PurchaseHeader;"Purchase Header"."Inbound Whse. Handling Time")
            {
            }
            column(DateFilter_PurchaseHeader;"Purchase Header"."Date Filter")
            {
            }
            column(VendorAuthorizationNo_PurchaseHeader;"Purchase Header"."Vendor Authorization No.")
            {
            }
            column(ReturnShipmentNo_PurchaseHeader;"Purchase Header"."Return Shipment No.")
            {
            }
            column(ReturnShipmentNoSeries_PurchaseHeader;"Purchase Header"."Return Shipment No. Series")
            {
            }
            column(Ship_PurchaseHeader;"Purchase Header".Ship)
            {
            }
            column(LastReturnShipmentNo_PurchaseHeader;"Purchase Header"."Last Return Shipment No.")
            {
            }
            column(AssignedUserID_PurchaseHeader;"Purchase Header"."Assigned User ID")
            {
            }
            column(Copied_PurchaseHeader;"Purchase Header".Copied)
            {
            }
            column(DebitNote_PurchaseHeader;"Purchase Header"."Debit Note")
            {
            }
            column(ProcurementRequestNo_PurchaseHeader;"Purchase Header"."Procurement Request No.")
            {
            }
            column(InvoiceAmount_PurchaseHeader;"Purchase Header"."Invoice Amount")
            {
            }
            column(RequestNo_PurchaseHeader;"Purchase Header"."Request No")
            {
            }
            column(Commited_PurchaseHeader;"Purchase Header".Commited)
            {
            }
            column(Department_PurchaseHeader;"Purchase Header".Department)
            {
            }
            column(DeliveryNo_PurchaseHeader;"Purchase Header"."Delivery No")
            {
            }
            column(LedgerCardNo_PurchaseHeader;"Purchase Header"."Ledger Card No")
            {
            }
            column(PRNNo_PurchaseHeader;"Purchase Header"."PRN No")
            {
            }
            column(ApprovalStatus_PurchaseHeader;"Purchase Header"."Approval Status")
            {
            }
            column(POStatus_PurchaseHeader;"Purchase Header"."PO Status")
            {
            }
            column(FinanceStatus_PurchaseHeader;"Purchase Header"."Finance Status")
            {
            }
            column(AdminStatus_PurchaseHeader;"Purchase Header"."Admin Status")
            {
            }
            column(POName_PurchaseHeader;"Purchase Header"."P.O Name")
            {
            }
            column(POApprovalDate_PurchaseHeader;"Purchase Header"."P.O Approval Date")
            {
            }
            column(FinanceApprovedBy_PurchaseHeader;"Purchase Header"."Finance Approved By")
            {
            }
            column(FinanceApprovalDate_PurchaseHeader;"Purchase Header"."Finance Approval Date")
            {
            }
            column(AdminApprovedBy_PurchaseHeader;"Purchase Header"."Admin Approved By")
            {
            }
            column(AdminApprovedDate_PurchaseHeader;"Purchase Header"."Admin Approved Date")
            {
            }
            column(ContractNo_PurchaseHeader;"Purchase Header"."Contract No.")
            {
            }
            column(QuotationNo_PurchaseHeader;"Purchase Header"."Quotation No.")
            {
            }
            column(RequestforQuoteNo_PurchaseHeader;"Purchase Header"."Request for Quote No.")
            {
            }
            column(DocumentType2_PurchaseHeader;"Purchase Header"."Document Type 2")
            {
            }
            column(TendorNumber_PurchaseHeader;"Purchase Header"."Tendor Number")
            {
            }
            column(Allocation_PurchaseHeader;"Purchase Header".Allocation)
            {
            }
            column(Expenditure_PurchaseHeader;"Purchase Header".Expenditure)
            {
            }
            column(Cancelled_PurchaseHeader;"Purchase Header".Cancelled)
            {
            }
            column(CancelledBy_PurchaseHeader;"Purchase Header"."Cancelled By")
            {
            }
            column(CancelledDate_PurchaseHeader;"Purchase Header"."Cancelled Date")
            {
            }
            column(DocApprovalType_PurchaseHeader;"Purchase Header".DocApprovalType)
            {
            }
            column(ProcurementTypeCode_PurchaseHeader;"Purchase Header"."Procurement Type Code")
            {
            }
            dataitem("Purchase Line";"Purchase Line")
            {
                DataItemLink = "Document Type"=field("Document Type"),"Document No."=field("No.");
                DataItemTableView = sorting("Document Type","Document No.","Line No.") order(ascending) where("Description 2"=filter(<>''));
                column(ReportForNavId_1000000174; 1000000174)
                {
                }
                column(DocumentType_PurchaseLine;"Purchase Line"."Document Type")
                {
                }
                column(BuyfromVendorNo_PurchaseLine;"Purchase Line"."Buy-from Vendor No.")
                {
                }
                column(DocumentNo_PurchaseLine;"Purchase Line"."Document No.")
                {
                }
                column(LineNo_PurchaseLine;"Purchase Line"."Line No.")
                {
                }
                column(Type_PurchaseLine;"Purchase Line".Type)
                {
                }
                column(No_PurchaseLine;"Purchase Line"."No.")
                {
                }
                column(LocationCode_PurchaseLine;"Purchase Line"."Location Code")
                {
                }
                column(PostingGroup_PurchaseLine;"Purchase Line"."Posting Group")
                {
                }
                column(ExpectedReceiptDate_PurchaseLine;"Purchase Line"."Expected Receipt Date")
                {
                }
                column(Description_PurchaseLine;"Purchase Line".Description)
                {
                }
                column(Description2_PurchaseLine;"Purchase Line"."Description 2")
                {
                }
                column(UnitofMeasure_PurchaseLine;"Purchase Line"."Unit of Measure")
                {
                }
                column(Quantity_PurchaseLine;"Purchase Line".Quantity)
                {
                }
                column(OutstandingQuantity_PurchaseLine;"Purchase Line"."Outstanding Quantity")
                {
                }
                column(QtytoInvoice_PurchaseLine;"Purchase Line"."Qty. to Invoice")
                {
                }
                column(QtytoReceive_PurchaseLine;"Purchase Line"."Qty. to Receive")
                {
                }
                column(DirectUnitCost_PurchaseLine;"Purchase Line"."Direct Unit Cost")
                {
                }
                column(UnitCostLCY_PurchaseLine;"Purchase Line"."Unit Cost (LCY)")
                {
                }
                column(VAT_PurchaseLine;"Purchase Line"."VAT %")
                {
                }
                column(LineDiscount_PurchaseLine;"Purchase Line"."Line Discount %")
                {
                }
                column(LineDiscountAmount_PurchaseLine;"Purchase Line"."Line Discount Amount")
                {
                }
                column(Amount_PurchaseLine;"Purchase Line".Amount)
                {
                }
                column(AmountIncludingVAT_PurchaseLine;"Purchase Line"."Amount Including VAT")
                {
                }
                column(UnitPriceLCY_PurchaseLine;"Purchase Line"."Unit Price (LCY)")
                {
                }
                column(AllowInvoiceDisc_PurchaseLine;"Purchase Line"."Allow Invoice Disc.")
                {
                }
                column(GrossWeight_PurchaseLine;"Purchase Line"."Gross Weight")
                {
                }
                column(NetWeight_PurchaseLine;"Purchase Line"."Net Weight")
                {
                }
                column(UnitsperParcel_PurchaseLine;"Purchase Line"."Units per Parcel")
                {
                }
                column(UnitVolume_PurchaseLine;"Purchase Line"."Unit Volume")
                {
                }
                column(AppltoItemEntry_PurchaseLine;"Purchase Line"."Appl.-to Item Entry")
                {
                }
                column(ShortcutDimension1Code_PurchaseLine;"Purchase Line"."Shortcut Dimension 1 Code")
                {
                }
                column(ShortcutDimension2Code_PurchaseLine;"Purchase Line"."Shortcut Dimension 2 Code")
                {
                }
                column(JobNo_PurchaseLine;"Purchase Line"."Job No.")
                {
                }
                column(IndirectCost_PurchaseLine;"Purchase Line"."Indirect Cost %")
                {
                }
                column(OutstandingAmount_PurchaseLine;"Purchase Line"."Outstanding Amount")
                {
                }
                column(QtyRcdNotInvoiced_PurchaseLine;"Purchase Line"."Qty. Rcd. Not Invoiced")
                {
                }
                column(AmtRcdNotInvoiced_PurchaseLine;"Purchase Line"."Amt. Rcd. Not Invoiced")
                {
                }
                column(QuantityInvoiced_PurchaseLine;"Purchase Line"."Quantity Invoiced")
                {
                }
                column(ReceiptNo_PurchaseLine;"Purchase Line"."Receipt No.")
                {
                }
                column(ReceiptLineNo_PurchaseLine;"Purchase Line"."Receipt Line No.")
                {
                }
                column(Profit_PurchaseLine;"Purchase Line"."Profit %")
                {
                }
                column(PaytoVendorNo_PurchaseLine;"Purchase Line"."Pay-to Vendor No.")
                {
                }
                column(InvDiscountAmount_PurchaseLine;"Purchase Line"."Inv. Discount Amount")
                {
                }
                column(VendorItemNo_PurchaseLine;"Purchase Line"."Vendor Item No.")
                {
                }
                column(SalesOrderNo_PurchaseLine;"Purchase Line"."Sales Order No.")
                {
                }
                column(SalesOrderLineNo_PurchaseLine;"Purchase Line"."Sales Order Line No.")
                {
                }
                column(DropShipment_PurchaseLine;"Purchase Line"."Drop Shipment")
                {
                }
                column(GenBusPostingGroup_PurchaseLine;"Purchase Line"."Gen. Bus. Posting Group")
                {
                }
                column(GenProdPostingGroup_PurchaseLine;"Purchase Line"."Gen. Prod. Posting Group")
                {
                }
                column(VATCalculationType_PurchaseLine;"Purchase Line"."VAT Calculation Type")
                {
                }
                column(TransactionType_PurchaseLine;"Purchase Line"."Transaction Type")
                {
                }
                column(TransportMethod_PurchaseLine;"Purchase Line"."Transport Method")
                {
                }
                column(AttachedtoLineNo_PurchaseLine;"Purchase Line"."Attached to Line No.")
                {
                }
                column(EntryPoint_PurchaseLine;"Purchase Line"."Entry Point")
                {
                }
                column(Area_PurchaseLine;"Purchase Line".Area)
                {
                }
                column(TransactionSpecification_PurchaseLine;"Purchase Line"."Transaction Specification")
                {
                }
                column(TaxAreaCode_PurchaseLine;"Purchase Line"."Tax Area Code")
                {
                }
                column(TaxLiable_PurchaseLine;"Purchase Line"."Tax Liable")
                {
                }
                column(TaxGroupCode_PurchaseLine;"Purchase Line"."Tax Group Code")
                {
                }
                column(UseTax_PurchaseLine;"Purchase Line"."Use Tax")
                {
                }
                column(VATBusPostingGroup_PurchaseLine;"Purchase Line"."VAT Bus. Posting Group")
                {
                }
                column(VATProdPostingGroup_PurchaseLine;"Purchase Line"."VAT Prod. Posting Group")
                {
                }
                column(CurrencyCode_PurchaseLine;"Purchase Line"."Currency Code")
                {
                }
                column(OutstandingAmountLCY_PurchaseLine;"Purchase Line"."Outstanding Amount (LCY)")
                {
                }
                column(AmtRcdNotInvoicedLCY_PurchaseLine;"Purchase Line"."Amt. Rcd. Not Invoiced (LCY)")
                {
                }
                column(ReservedQuantity_PurchaseLine;"Purchase Line"."Reserved Quantity")
                {
                }
                column(BlanketOrderNo_PurchaseLine;"Purchase Line"."Blanket Order No.")
                {
                }
                column(BlanketOrderLineNo_PurchaseLine;"Purchase Line"."Blanket Order Line No.")
                {
                }
                column(VATBaseAmount_PurchaseLine;"Purchase Line"."VAT Base Amount")
                {
                }
                column(UnitCost_PurchaseLine;"Purchase Line"."Unit Cost")
                {
                }
                column(SystemCreatedEntry_PurchaseLine;"Purchase Line"."System-Created Entry")
                {
                }
                column(LineAmount_PurchaseLine;"Purchase Line"."Line Amount")
                {
                }
                column(VATDifference_PurchaseLine;"Purchase Line"."VAT Difference")
                {
                }
                column(InvDiscAmounttoInvoice_PurchaseLine;"Purchase Line"."Inv. Disc. Amount to Invoice")
                {
                }
                column(VATIdentifier_PurchaseLine;"Purchase Line"."VAT Identifier")
                {
                }
                column(ICPartnerRefType_PurchaseLine;"Purchase Line"."IC Partner Ref. Type")
                {
                }
                column(ICPartnerReference_PurchaseLine;"Purchase Line"."IC Partner Reference")
                {
                }
                column(Prepayment_PurchaseLine;"Purchase Line"."Prepayment %")
                {
                }
                column(PrepmtLineAmount_PurchaseLine;"Purchase Line"."Prepmt. Line Amount")
                {
                }
                column(PrepmtAmtInv_PurchaseLine;"Purchase Line"."Prepmt. Amt. Inv.")
                {
                }
                column(PrepmtAmtInclVAT_PurchaseLine;"Purchase Line"."Prepmt. Amt. Incl. VAT")
                {
                }
                column(PrepaymentAmount_PurchaseLine;"Purchase Line"."Prepayment Amount")
                {
                }
                column(PrepmtVATBaseAmt_PurchaseLine;"Purchase Line"."Prepmt. VAT Base Amt.")
                {
                }
                column(PrepaymentVAT_PurchaseLine;"Purchase Line"."Prepayment VAT %")
                {
                }
                column(PrepmtVATCalcType_PurchaseLine;"Purchase Line"."Prepmt. VAT Calc. Type")
                {
                }
                column(PrepaymentVATIdentifier_PurchaseLine;"Purchase Line"."Prepayment VAT Identifier")
                {
                }
                column(PrepaymentTaxAreaCode_PurchaseLine;"Purchase Line"."Prepayment Tax Area Code")
                {
                }
                column(PrepaymentTaxLiable_PurchaseLine;"Purchase Line"."Prepayment Tax Liable")
                {
                }
                column(PrepaymentTaxGroupCode_PurchaseLine;"Purchase Line"."Prepayment Tax Group Code")
                {
                }
                column(PrepmtAmttoDeduct_PurchaseLine;"Purchase Line"."Prepmt Amt to Deduct")
                {
                }
                column(PrepmtAmtDeducted_PurchaseLine;"Purchase Line"."Prepmt Amt Deducted")
                {
                }
                column(PrepaymentLine_PurchaseLine;"Purchase Line"."Prepayment Line")
                {
                }
                column(PrepmtAmountInvInclVAT_PurchaseLine;"Purchase Line"."Prepmt. Amount Inv. Incl. VAT")
                {
                }
                column(PrepmtAmountInvLCY_PurchaseLine;"Purchase Line"."Prepmt. Amount Inv. (LCY)")
                {
                }
                column(ICPartnerCode_PurchaseLine;"Purchase Line"."IC Partner Code")
                {
                }
                column(PrepmtVATAmountInvLCY_PurchaseLine;"Purchase Line"."Prepmt. VAT Amount Inv. (LCY)")
                {
                }
                column(PrepaymentVATDifference_PurchaseLine;"Purchase Line"."Prepayment VAT Difference")
                {
                }
                column(PrepmtVATDifftoDeduct_PurchaseLine;"Purchase Line"."Prepmt VAT Diff. to Deduct")
                {
                }
                column(PrepmtVATDiffDeducted_PurchaseLine;"Purchase Line"."Prepmt VAT Diff. Deducted")
                {
                }
                column(OutstandingAmtExVATLCY_PurchaseLine;"Purchase Line"."Outstanding Amt. Ex. VAT (LCY)")
                {
                }
                column(ARcdNotInvExVATLCY_PurchaseLine;"Purchase Line"."A. Rcd. Not Inv. Ex. VAT (LCY)")
                {
                }
                column(DimensionSetID_PurchaseLine;"Purchase Line"."Dimension Set ID")
                {
                }
                column(JobTaskNo_PurchaseLine;"Purchase Line"."Job Task No.")
                {
                }
                column(JobLineType_PurchaseLine;"Purchase Line"."Job Line Type")
                {
                }
                column(JobUnitPrice_PurchaseLine;"Purchase Line"."Job Unit Price")
                {
                }
                column(JobTotalPrice_PurchaseLine;"Purchase Line"."Job Total Price")
                {
                }
                column(JobLineAmount_PurchaseLine;"Purchase Line"."Job Line Amount")
                {
                }
                column(JobLineDiscountAmount_PurchaseLine;"Purchase Line"."Job Line Discount Amount")
                {
                }
                column(JobLineDiscount_PurchaseLine;"Purchase Line"."Job Line Discount %")
                {
                }
                column(JobUnitPriceLCY_PurchaseLine;"Purchase Line"."Job Unit Price (LCY)")
                {
                }
                column(JobTotalPriceLCY_PurchaseLine;"Purchase Line"."Job Total Price (LCY)")
                {
                }
                column(JobLineAmountLCY_PurchaseLine;"Purchase Line"."Job Line Amount (LCY)")
                {
                }
                column(JobLineDiscAmountLCY_PurchaseLine;"Purchase Line"."Job Line Disc. Amount (LCY)")
                {
                }
                column(JobCurrencyFactor_PurchaseLine;"Purchase Line"."Job Currency Factor")
                {
                }
                column(JobCurrencyCode_PurchaseLine;"Purchase Line"."Job Currency Code")
                {
                }
                column(JobPlanningLineNo_PurchaseLine;"Purchase Line"."Job Planning Line No.")
                {
                }
                column(JobRemainingQty_PurchaseLine;"Purchase Line"."Job Remaining Qty.")
                {
                }
                column(JobRemainingQtyBase_PurchaseLine;"Purchase Line"."Job Remaining Qty. (Base)")
                {
                }
                column(ProdOrderNo_PurchaseLine;"Purchase Line"."Prod. Order No.")
                {
                }
                column(VariantCode_PurchaseLine;"Purchase Line"."Variant Code")
                {
                }
                column(BinCode_PurchaseLine;"Purchase Line"."Bin Code")
                {
                }
                column(QtyperUnitofMeasure_PurchaseLine;"Purchase Line"."Qty. per Unit of Measure")
                {
                }
                column(UnitofMeasureCode_PurchaseLine;"Purchase Line"."Unit of Measure Code")
                {
                }
                column(QuantityBase_PurchaseLine;"Purchase Line"."Quantity (Base)")
                {
                }
                column(OutstandingQtyBase_PurchaseLine;"Purchase Line"."Outstanding Qty. (Base)")
                {
                }
                column(QtytoInvoiceBase_PurchaseLine;"Purchase Line"."Qty. to Invoice (Base)")
                {
                }
                column(QtytoReceiveBase_PurchaseLine;"Purchase Line"."Qty. to Receive (Base)")
                {
                }
                column(QtyRcdNotInvoicedBase_PurchaseLine;"Purchase Line"."Qty. Rcd. Not Invoiced (Base)")
                {
                }
                column(QtyReceivedBase_PurchaseLine;"Purchase Line"."Qty. Received (Base)")
                {
                }
                column(QtyInvoicedBase_PurchaseLine;"Purchase Line"."Qty. Invoiced (Base)")
                {
                }
                column(ReservedQtyBase_PurchaseLine;"Purchase Line"."Reserved Qty. (Base)")
                {
                }
                column(FAPostingDate_PurchaseLine;"Purchase Line"."FA Posting Date")
                {
                }
                column(FAPostingType_PurchaseLine;"Purchase Line"."FA Posting Type")
                {
                }
                column(DepreciationBookCode_PurchaseLine;"Purchase Line"."Depreciation Book Code")
                {
                }
                column(SalvageValue_PurchaseLine;"Purchase Line"."Salvage Value")
                {
                }
                column(DepruntilFAPostingDate_PurchaseLine;"Purchase Line"."Depr. until FA Posting Date")
                {
                }
                column(DeprAcquisitionCost_PurchaseLine;"Purchase Line"."Depr. Acquisition Cost")
                {
                }
                column(MaintenanceCode_PurchaseLine;"Purchase Line"."Maintenance Code")
                {
                }
                column(InsuranceNo_PurchaseLine;"Purchase Line"."Insurance No.")
                {
                }
                column(BudgetedFANo_PurchaseLine;"Purchase Line"."Budgeted FA No.")
                {
                }
                column(DuplicateinDepreciationBook_PurchaseLine;"Purchase Line"."Duplicate in Depreciation Book")
                {
                }
                column(UseDuplicationList_PurchaseLine;"Purchase Line"."Use Duplication List")
                {
                }
                column(ResponsibilityCenter_PurchaseLine;"Purchase Line"."Responsibility Center")
                {
                }
                column(CrossReferenceNo_PurchaseLine;"Purchase Line"."Cross-Reference No.")
                {
                }
                column(UnitofMeasureCrossRef_PurchaseLine;"Purchase Line"."Unit of Measure (Cross Ref.)")
                {
                }
                column(CrossReferenceType_PurchaseLine;"Purchase Line"."Cross-Reference Type")
                {
                }
                column(CrossReferenceTypeNo_PurchaseLine;"Purchase Line"."Cross-Reference Type No.")
                {
                }
                column(ItemCategoryCode_PurchaseLine;"Purchase Line"."Item Category Code")
                {
                }
                column(Nonstock_PurchaseLine;"Purchase Line".Nonstock)
                {
                }
                column(PurchasingCode_PurchaseLine;"Purchase Line"."Purchasing Code")
                {
                }
                column(ProductGroupCode_PurchaseLine;"Purchase Line"."Product Group Code")
                {
                }
                column(SpecialOrder_PurchaseLine;"Purchase Line"."Special Order")
                {
                }
                column(SpecialOrderSalesNo_PurchaseLine;"Purchase Line"."Special Order Sales No.")
                {
                }
                column(SpecialOrderSalesLineNo_PurchaseLine;"Purchase Line"."Special Order Sales Line No.")
                {
                }
                column(WhseOutstandingQtyBase_PurchaseLine;"Purchase Line"."Whse. Outstanding Qty. (Base)")
                {
                }
                column(CompletelyReceived_PurchaseLine;"Purchase Line"."Completely Received")
                {
                }
                column(RequestedReceiptDate_PurchaseLine;"Purchase Line"."Requested Receipt Date")
                {
                }
                column(PromisedReceiptDate_PurchaseLine;"Purchase Line"."Promised Receipt Date")
                {
                }
                column(LeadTimeCalculation_PurchaseLine;"Purchase Line"."Lead Time Calculation")
                {
                }
                column(InboundWhseHandlingTime_PurchaseLine;"Purchase Line"."Inbound Whse. Handling Time")
                {
                }
                column(PlannedReceiptDate_PurchaseLine;"Purchase Line"."Planned Receipt Date")
                {
                }
                column(OrderDate_PurchaseLine;"Purchase Line"."Order Date")
                {
                }
                column(AllowItemChargeAssignment_PurchaseLine;"Purchase Line"."Allow Item Charge Assignment")
                {
                }
                column(QtytoAssign_PurchaseLine;"Purchase Line"."Qty. to Assign")
                {
                }
                column(QtyAssigned_PurchaseLine;"Purchase Line"."Qty. Assigned")
                {
                }
                column(ReturnQtytoShip_PurchaseLine;"Purchase Line"."Return Qty. to Ship")
                {
                }
                column(ReturnQtytoShipBase_PurchaseLine;"Purchase Line"."Return Qty. to Ship (Base)")
                {
                }
                column(ReturnQtyShippedNotInvd_PurchaseLine;"Purchase Line"."Return Qty. Shipped Not Invd.")
                {
                }
                column(RetQtyShpdNotInvdBase_PurchaseLine;"Purchase Line"."Ret. Qty. Shpd Not Invd.(Base)")
                {
                }
                column(ReturnShpdNotInvd_PurchaseLine;"Purchase Line"."Return Shpd. Not Invd.")
                {
                }
                column(ReturnShpdNotInvdLCY_PurchaseLine;"Purchase Line"."Return Shpd. Not Invd. (LCY)")
                {
                }
                column(ReturnQtyShipped_PurchaseLine;"Purchase Line"."Return Qty. Shipped")
                {
                }
                column(ReturnQtyShippedBase_PurchaseLine;"Purchase Line"."Return Qty. Shipped (Base)")
                {
                }
                column(ReturnShipmentNo_PurchaseLine;"Purchase Line"."Return Shipment No.")
                {
                }
                column(ReturnShipmentLineNo_PurchaseLine;"Purchase Line"."Return Shipment Line No.")
                {
                }
                column(ReturnReasonCode_PurchaseLine;"Purchase Line"."Return Reason Code")
                {
                }
                column(Committed_PurchaseLine;"Purchase Line".Committed)
                {
                }
                column(VoteBook_PurchaseLine;"Purchase Line"."Vote Book")
                {
                }
                column(ExpenseCode_PurchaseLine;"Purchase Line"."Expense Code")
                {
                }
                column(PostingDate_PurchaseLine;"Purchase Line"."RFQ No.")
                {
                }
                column(HeaderCommited_PurchaseLine;"Purchase Line"."RFQ Line No.")
                {
                }
                column(Select_PurchaseLine;"Purchase Line".Select)
                {
                }
                column(RFQCreated_PurchaseLine;"Purchase Line"."RFQ Created")
                {
                }
                column(RFQNo_PurchaseLine;"Purchase Line"."RFQ No.")
                {
                }
                column(RFQLineNo_PurchaseLine;"Purchase Line"."Project Code")
                {
                }
                column(Status_PurchaseLine;"Purchase Line".Status)
                {
                }
                column(AssetNo_PurchaseLine;"Purchase Line"."Asset No.")
                {
                }
                column(DocumentType2_PurchaseLine;"Purchase Line"."Document Type 2")
                {
                }
                column(ProcurementPlanItemNo_PurchaseLine;"Purchase Line"."Procurement Plan Item No")
                {
                }
                column(RequestforQuoteNo_PurchaseLine;"Purchase Line"."Request for Quote No.")
                {
                }
                column(LineCreated_PurchaseLine;"Purchase Line"."Line Created")
                {
                }
                column(RoutingNo_PurchaseLine;"Purchase Line"."Routing No.")
                {
                }
                column(OperationNo_PurchaseLine;"Purchase Line"."Operation No.")
                {
                }
                column(WorkCenterNo_PurchaseLine;"Purchase Line"."Work Center No.")
                {
                }
                column(Finished_PurchaseLine;"Purchase Line".Finished)
                {
                }
                column(ProdOrderLineNo_PurchaseLine;"Purchase Line"."Prod. Order Line No.")
                {
                }
                column(OverheadRate_PurchaseLine;"Purchase Line"."Overhead Rate")
                {
                }
                column(MPSOrder_PurchaseLine;"Purchase Line"."MPS Order")
                {
                }
                column(PlanningFlexibility_PurchaseLine;"Purchase Line"."Planning Flexibility")
                {
                }
                column(SafetyLeadTime_PurchaseLine;"Purchase Line"."Safety Lead Time")
                {
                }
                column(RoutingReferenceNo_PurchaseLine;"Purchase Line"."Routing Reference No.")
                {
                }
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

