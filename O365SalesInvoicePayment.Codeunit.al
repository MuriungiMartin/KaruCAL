#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 2105 "O365 Sales Invoice Payment"
{

    trigger OnRun()
    begin
    end;

    var
        PaymentRegistrationMgt: Codeunit "Payment Registration Mgt.";
        NoDetailedCustomerLedgerEntryForPaymentErr: label 'No Detailed Customer Ledger Entry could be found for the payment of the invoice.';


    procedure ShowHistory(SalesInvoiceDocumentNo: Code[20])
    var
        O365PaymentHistoryList: Page "O365 Payment History List";
    begin
        O365PaymentHistoryList.ShowHistory(SalesInvoiceDocumentNo);
        O365PaymentHistoryList.Run;
    end;


    procedure MarkAsPaid(SalesInvoiceDocumentNo: Code[20])
    var
        TempPaymentRegistrationBuffer: Record "Payment Registration Buffer" temporary;
        SalesInvoiceHeader: Record "Sales Invoice Header";
        O365MarkAsPaid: Page "O365 Mark As Paid";
    begin
        if not SalesInvoiceHeader.Get(SalesInvoiceDocumentNo) then
          exit;

        CreatePaymentRegistrationSetup;
        TempPaymentRegistrationBuffer.PopulateTable;
        TempPaymentRegistrationBuffer.SetRange("Document Type",TempPaymentRegistrationBuffer."document type"::Invoice);
        TempPaymentRegistrationBuffer.SetRange("Document No.",SalesInvoiceDocumentNo);
        if not TempPaymentRegistrationBuffer.FindFirst then
          exit; // Invoice has already been paid

        TempPaymentRegistrationBuffer.Validate("Payment Made",true);
        TempPaymentRegistrationBuffer.Modify(true);
        TempPaymentRegistrationBuffer.ModifyAll("Limit Amount Received",true);

        O365MarkAsPaid.SetPaymentRegistrationBuffer(TempPaymentRegistrationBuffer);
        if O365MarkAsPaid.RunModal = Action::OK then
          PaymentRegistrationMgt.Post(TempPaymentRegistrationBuffer,false);
    end;


    procedure CancelSalesInvoicePayment(SalesInvoiceDocumentNo: Code[20])
    var
        TempO365PaymentHistoryBuffer: Record "O365 Payment History Buffer" temporary;
    begin
        TempO365PaymentHistoryBuffer.FillPaymentHistory(SalesInvoiceDocumentNo,false);
        if TempO365PaymentHistoryBuffer.IsEmpty then
          exit; // All payments for the invoice has already been cancelled :)
        if TempO365PaymentHistoryBuffer.Count = 1 then
          CancelCustLedgerEntry(TempO365PaymentHistoryBuffer."Ledger Entry No.")
        else
          ShowHistory(SalesInvoiceDocumentNo); // There are multiple payments, so show the history list instead and let the user specify the entries to cancel
    end;


    procedure CancelCustLedgerEntry(CustomerLedgerEntry: Integer)
    var
        PaymentCustLedgerEntry: Record "Cust. Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
    begin
        if not PaymentCustLedgerEntry.Get(CustomerLedgerEntry) then
          exit;

        // Get detailed ledger entry for the payment, making sure it's a payment
        DetailedCustLedgEntry.SetRange("Document Type",DetailedCustLedgEntry."document type"::Payment);
        DetailedCustLedgEntry.SetRange("Document No.",PaymentCustLedgerEntry."Document No.");
        DetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.",CustomerLedgerEntry);
        DetailedCustLedgEntry.SetRange(Unapplied,false);
        if not DetailedCustLedgEntry.FindLast then
          Error(NoDetailedCustomerLedgerEntryForPaymentErr);

        CustEntryApplyPostedEntries.PostUnApplyCustomerCommit(
          DetailedCustLedgEntry,DetailedCustLedgEntry."Document No.",DetailedCustLedgEntry."Posting Date",false);

        ReversalEntry.SetHideWarningDialogs;
        ReversalEntry.ReverseTransaction(PaymentCustLedgerEntry."Transaction No.");
    end;

    local procedure CreatePaymentRegistrationSetup()
    var
        PaymentRegistrationSetup: Record "Payment Registration Setup";
    begin
        with PaymentRegistrationSetup do begin
          if Get(UserId) then
            exit;
          if Get then begin
            "User ID" := UserId;
            Insert(true);
            Commit;
            exit;
          end;
          Codeunit.Run(Codeunit::"O365 Sales Initial Setup");
          Commit;
        end;
    end;


    procedure GetPaymentCustLedgerEntry(var PaymentCustLedgerEntry: Record "Cust. Ledger Entry";SalesInvoiceDocumentNo: Code[20]): Boolean
    var
        InvoiceCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        // Find the customer ledger entry related to the invoice
        InvoiceCustLedgerEntry.SetRange("Document Type",InvoiceCustLedgerEntry."document type"::Invoice);
        InvoiceCustLedgerEntry.SetRange("Document No.",SalesInvoiceDocumentNo);
        if not InvoiceCustLedgerEntry.FindFirst then
          exit(false); // The invoice does not exist

        // find the customer ledger entry related to the payment of the invoice
        if not PaymentCustLedgerEntry.Get(InvoiceCustLedgerEntry."Closed by Entry No.") then
          exit(false); // The invoice has not been closed

        exit(true);
    end;
}

