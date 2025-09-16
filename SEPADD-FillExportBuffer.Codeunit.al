#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1231 "SEPA DD-Fill Export Buffer"
{
    Permissions = TableData "Payment Export Data"=rimd;
    TableNo = "Payment Export Data";

    trigger OnRun()
    begin
    end;

    var
        HasErrorsErr: label 'The file export has one or more errors.\\For each line to be exported, resolve the errors displayed to the right and then try to export again.';


    procedure FillExportBuffer(var DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";var PaymentExportData: Record "Payment Export Data")
    var
        BankAccount: Record "Bank Account";
        BankExportImportSetup: Record "Bank Export/Import Setup";
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
        DirectDebitCollection: Record "Direct Debit Collection";
        GLSetup: Record "General Ledger Setup";
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
        TempDirectDebitCollectionEntry: Record "Direct Debit Collection Entry" temporary;
    begin
        TempDirectDebitCollectionEntry.CopyFilters(DirectDebitCollectionEntry);
        Codeunit.Run(Codeunit::"SEPA DD-Prepare Source",TempDirectDebitCollectionEntry);

        TempDirectDebitCollectionEntry.SetAutocalcFields("Applies-to Entry Document No.","Applies-to Entry Description");

        if not TempDirectDebitCollectionEntry.FindSet then
          exit;

        DirectDebitCollection.Get(TempDirectDebitCollectionEntry."Direct Debit Collection No.");
        BankAccount.Get(DirectDebitCollection."To Bank Account No.");
        BankAccount.GetDDExportImportSetup(BankExportImportSetup);
        BankExportImportSetup.TestField("Check Export Codeunit");
        repeat
          Codeunit.Run(BankExportImportSetup."Check Export Codeunit",TempDirectDebitCollectionEntry);
        until TempDirectDebitCollectionEntry.Next = 0;

        if DirectDebitCollection.HasPaymentFileErrors then begin
          Commit;
          Error(HasErrorsErr);
        end;

        GLSetup.Get;
        GLSetup.TestField("LCY Code");

        TempDirectDebitCollectionEntry.FindSet;
        with PaymentExportData do begin
          Reset;
          if FindLast then;
          repeat
            Init;
            "Entry No." += 1;
            SetPreserveNonLatinCharacters(BankExportImportSetup."Preserve Non-Latin Characters");
            SetBankAsSenderBank(BankAccount);
            SetCreditorIdentifier(BankAccount);
            "SEPA Direct Debit Mandate ID" := TempDirectDebitCollectionEntry."Mandate ID";
            SEPADirectDebitMandate.Get(TempDirectDebitCollectionEntry."Mandate ID");
            "SEPA DD Mandate Signed Date" := SEPADirectDebitMandate."Date of Signature";

            TempDirectDebitCollectionEntry."Sequence Type" :=
              UpdateSourceEntrySequenceType(TempDirectDebitCollectionEntry);

            Validate("SEPA Direct Debit Seq. Type",TempDirectDebitCollectionEntry."Sequence Type");
            "Transfer Date" := TempDirectDebitCollectionEntry."Transfer Date";
            "Document No." := TempDirectDebitCollectionEntry."Applies-to Entry Document No.";
            Amount := TempDirectDebitCollectionEntry."Transfer Amount";
            "Currency Code" := GLSetup.GetCurrencyCode(TempDirectDebitCollectionEntry."Currency Code");

            Customer.Get(TempDirectDebitCollectionEntry."Customer No.");
            CustomerBankAccount.Get(Customer."No.",SEPADirectDebitMandate."Customer Bank Account Code");
            SetCustomerAsRecipient(Customer,CustomerBankAccount);

            Validate("SEPA Partner Type",Customer."Partner Type");
            Validate("SEPA Instruction Priority","sepa instruction priority"::NORMAL);
            Validate("SEPA Payment Method","sepa payment method"::TRF);
            Validate("SEPA Charge Bearer","sepa charge bearer"::SLEV);

            "SEPA Batch Booking" := false;
            "Message ID" := DirectDebitCollection."Message ID";
            "Payment Information ID" := TempDirectDebitCollectionEntry."Transaction ID";
            "End-to-End ID" := TempDirectDebitCollectionEntry."Transaction ID";
            "Message to Recipient 1" := TempDirectDebitCollectionEntry."Applies-to Entry Description";
            Insert(true);
          until TempDirectDebitCollectionEntry.Next = 0;
        end;
    end;

    local procedure UpdateSourceEntrySequenceType(TempDirectDebitCollectionEntry: Record "Direct Debit Collection Entry" temporary) SequenceType: Integer
    var
        DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";
        SEPADirectDebitMandate: Record "SEPA Direct Debit Mandate";
    begin
        if TempDirectDebitCollectionEntry.Status <> TempDirectDebitCollectionEntry.Status::New then
          exit(TempDirectDebitCollectionEntry."Sequence Type");

        with SEPADirectDebitMandate do begin
          Get(TempDirectDebitCollectionEntry."Mandate ID");
          SequenceType := GetSequenceType;
          UpdateCounter;
        end;

        DirectDebitCollectionEntry := TempDirectDebitCollectionEntry;
        with DirectDebitCollectionEntry do
          if Find then begin
            "Sequence Type" := SequenceType;
            Modify;
          end;
    end;
}

