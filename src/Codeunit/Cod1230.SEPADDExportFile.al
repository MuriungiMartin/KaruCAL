#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1230 "SEPA DD-Export File"
{
    TableNo = "Direct Debit Collection Entry";

    trigger OnRun()
    var
        DirectDebitCollection: Record "Direct Debit Collection";
        DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";
        BankAccount: Record "Bank Account";
    begin
        DirectDebitCollectionEntry.Copy(Rec);
        TestField("Direct Debit Collection No.");
        DirectDebitCollection.Get("Direct Debit Collection No.");
        DirectDebitCollection.TestField("To Bank Account No.");
        BankAccount.Get(DirectDebitCollection."To Bank Account No.");
        BankAccount.TestField(Iban);
        DirectDebitCollection.LockTable;
        DirectDebitCollection.DeletePaymentFileErrors;
        Commit;
        if not Export(Rec,BankAccount.GetDDExportXMLPortID,DirectDebitCollection.Identifier) then
          Error('');

        DirectDebitCollectionEntry.SetRange("Direct Debit Collection No.",DirectDebitCollection."No.");
        DirectDebitCollectionEntry.ModifyAll(Status,DirectDebitCollectionEntry.Status::"File Created");
        DirectDebitCollection.Status := DirectDebitCollection.Status::"File Created";
        DirectDebitCollection.Modify;
    end;

    local procedure Export(var DirectDebitCollectionEntry: Record "Direct Debit Collection Entry";XMLPortID: Integer;FileName: Text): Boolean
    var
        TempBlob: Record TempBlob;
        FileManagement: Codeunit "File Management";
        OutStr: OutStream;
    begin
        TempBlob.Init;
        TempBlob.Blob.CreateOutstream(OutStr);
        Xmlport.Export(XMLPortID,OutStr,DirectDebitCollectionEntry);
        exit(FileManagement.BLOBExport(TempBlob,StrSubstNo('%1.XML',FileName),true) <> '');
    end;
}

