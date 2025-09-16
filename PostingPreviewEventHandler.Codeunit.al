#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 20 "Posting Preview Event Handler"
{
    EventSubscriberInstance = Manual;

    trigger OnRun()
    begin
    end;

    var
        TempGLEntry: Record "G/L Entry" temporary;
        TempVATEntry: Record "VAT Entry" temporary;
        TempValueEntry: Record "Value Entry" temporary;
        TempItemLedgerEntry: Record "Item Ledger Entry" temporary;
        TempFALedgEntry: Record "FA Ledger Entry" temporary;
        TempCustLedgEntry: Record "Cust. Ledger Entry" temporary;
        TempDtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        TempVendLedgEntry: Record "Vendor Ledger Entry" temporary;
        TempDtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry" temporary;
        TempBankAccLedgerEntry: Record "Bank Account Ledger Entry" temporary;
        TempResLedgerEntry: Record "Res. Ledger Entry" temporary;
        TempServiceLedgerEntry: Record "Service Ledger Entry" temporary;
        TempWarrantyLedgerEntry: Record "Warranty Ledger Entry" temporary;
        TempMaintenanceLedgerEntry: Record "Maintenance Ledger Entry" temporary;
        TempJobLedgerEntry: Record "Job Ledger Entry" temporary;
        CommitPrevented: Boolean;


    procedure ShowEntries(TableNo: Integer)
    var
        CustLedgEntriesPreview: Page "Cust. Ledg. Entries Preview";
        VendLedgEntriesPreview: Page "Vend. Ledg. Entries Preview";
        ItemLedgerEntriesPreview: Page "Item Ledger Entries Preview";
    begin
        case TableNo of
          Database::"G/L Entry":
            Page.Run(Page::"G/L Entries Preview",TempGLEntry);
          Database::"Cust. Ledger Entry":
            begin
              CustLedgEntriesPreview.Set(TempCustLedgEntry,TempDtldCustLedgEntry);
              CustLedgEntriesPreview.Run;
              Clear(CustLedgEntriesPreview);
            end;
          Database::"Detailed Cust. Ledg. Entry":
            Page.Run(Page::"Det. Cust. Ledg. Entr. Preview",TempDtldCustLedgEntry);
          Database::"Vendor Ledger Entry":
            begin
              VendLedgEntriesPreview.Set(TempVendLedgEntry,TempDtldVendLedgEntry);
              VendLedgEntriesPreview.Run;
              Clear(VendLedgEntriesPreview);
            end;
          Database::"Detailed Vendor Ledg. Entry":
            Page.Run(Page::"Detailed Vend. Entries Preview",TempDtldVendLedgEntry);
          Database::"VAT Entry":
            Page.Run(Page::"VAT Entries Preview",TempVATEntry);
          Database::"Value Entry":
            Page.Run(Page::"Value Entries Preview",TempValueEntry);
          Database::"Item Ledger Entry":
            begin
              ItemLedgerEntriesPreview.Set(TempItemLedgerEntry,TempValueEntry);
              ItemLedgerEntriesPreview.Run;
              Clear(ItemLedgerEntriesPreview);
            end;
          Database::"FA Ledger Entry":
            Page.Run(Page::"FA Ledger Entries Preview",TempFALedgEntry);
          Database::"Bank Account Ledger Entry":
            Page.Run(Page::"Bank Acc. Ledg. Entr. Preview",TempBankAccLedgerEntry);
          Database::"Res. Ledger Entry":
            Page.Run(Page::"Resource Ledg. Entries Preview",TempResLedgerEntry);
          Database::"Service Ledger Entry":
            Page.Run(Page::"Service Ledger Entries Preview",TempServiceLedgerEntry);
          Database::"Warranty Ledger Entry":
            Page.Run(Page::"Warranty Ledg. Entries Preview",TempWarrantyLedgerEntry);
          Database::"Maintenance Ledger Entry":
            Page.Run(Page::"Maint. Ledg. Entries Preview",TempMaintenanceLedgerEntry);
          Database::"Job Ledger Entry":
            Page.Run(Page::"Job Ledger Entries Preview",TempJobLedgerEntry);
        end;
    end;


    procedure FillDocumentEntry(var TempDocumentEntry: Record "Document Entry" temporary)
    begin
        TempDocumentEntry.DeleteAll;
        InsertDocumentEntry(TempGLEntry,TempDocumentEntry);
        InsertDocumentEntry(TempVATEntry,TempDocumentEntry);
        InsertDocumentEntry(TempValueEntry,TempDocumentEntry);
        InsertDocumentEntry(TempItemLedgerEntry,TempDocumentEntry);
        InsertDocumentEntry(TempCustLedgEntry,TempDocumentEntry);
        InsertDocumentEntry(TempDtldCustLedgEntry,TempDocumentEntry);
        InsertDocumentEntry(TempVendLedgEntry,TempDocumentEntry);
        InsertDocumentEntry(TempDtldVendLedgEntry,TempDocumentEntry);
        InsertDocumentEntry(TempFALedgEntry,TempDocumentEntry);
        InsertDocumentEntry(TempBankAccLedgerEntry,TempDocumentEntry);
        InsertDocumentEntry(TempResLedgerEntry,TempDocumentEntry);
        InsertDocumentEntry(TempServiceLedgerEntry,TempDocumentEntry);
        InsertDocumentEntry(TempWarrantyLedgerEntry,TempDocumentEntry);
        InsertDocumentEntry(TempMaintenanceLedgerEntry,TempDocumentEntry);
        InsertDocumentEntry(TempJobLedgerEntry,TempDocumentEntry);
    end;

    local procedure InsertDocumentEntry(RecVar: Variant;var TempDocumentEntry: Record "Document Entry" temporary)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecVar);

        if RecRef.IsEmpty then
          exit;

        TempDocumentEntry.Init;
        TempDocumentEntry."Entry No." := RecRef.Number;
        TempDocumentEntry."Table ID" := RecRef.Number;
        TempDocumentEntry."Table Name" := RecRef.Caption;
        TempDocumentEntry."No. of Records" := RecRef.Count;
        TempDocumentEntry.Insert;
    end;

    local procedure PreventCommit()
    var
        GLEntry: Record "G/L Entry";
    begin
        if CommitPrevented then
          exit;

        CommitPrevented := true;
        GLEntry.Init;
        GLEntry.Consistent(false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertGLEntry(var Rec: Record "G/L Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempGLEntry := Rec;
        TempGLEntry."Document No." := '***';
        TempGLEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertVATEntry(var Rec: Record "VAT Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempVATEntry := Rec;
        TempVATEntry."Document No." := '***';
        TempVATEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Value Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertValueEntry(var Rec: Record "Value Entry")
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempValueEntry := Rec;
        TempValueEntry."Document No." := '***';
        TempValueEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertItemLedgerEntry(var Rec: Record "Item Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempItemLedgerEntry := Rec;
        TempItemLedgerEntry."Document No." := '***';
        TempItemLedgerEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"FA Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertFALedgEntry(var Rec: Record "FA Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempFALedgEntry := Rec;
        TempFALedgEntry."Document No." := '***';
        TempFALedgEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertCustLedgerEntry(var Rec: Record "Cust. Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempCustLedgEntry := Rec;
        TempCustLedgEntry."Document No." := '***';
        TempCustLedgEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Cust. Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertDetailedCustLedgEntry(var Rec: Record "Detailed Cust. Ledg. Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempDtldCustLedgEntry := Rec;
        TempDtldCustLedgEntry."Document No." := '***';
        TempDtldCustLedgEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertVendorLedgerEntry(var Rec: Record "Vendor Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempVendLedgEntry := Rec;
        TempVendLedgEntry."Document No." := '***';
        TempVendLedgEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed Vendor Ledg. Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertDetailedVendorLedgEntry(var Rec: Record "Detailed Vendor Ledg. Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempDtldVendLedgEntry := Rec;
        TempDtldVendLedgEntry."Document No." := '***';
        TempDtldVendLedgEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Bank Account Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertBankAccountLedgerEntry(var Rec: Record "Bank Account Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempBankAccLedgerEntry := Rec;
        TempBankAccLedgerEntry."Document No." := '***';
        TempBankAccLedgerEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Res. Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertResourceLedgerEntry(var Rec: Record "Res. Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempResLedgerEntry := Rec;
        TempResLedgerEntry."Document No." := '***';
        TempResLedgerEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertServiceLedgerEntry(var Rec: Record "Service Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempServiceLedgerEntry := Rec;
        TempServiceLedgerEntry."Document No." := '***';
        TempServiceLedgerEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Ledger Entry", 'OnAfterModifyEvent', '', false, false)]
    local procedure OnModifyServiceLedgerEntry(var Rec: Record "Service Ledger Entry";var xRec: Record "Service Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempServiceLedgerEntry := Rec;
        TempServiceLedgerEntry."Document No." := '***';
        if TempServiceLedgerEntry.Insert then;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Warranty Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertWarrantyLedgerEntry(var Rec: Record "Warranty Ledger Entry")
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempWarrantyLedgerEntry := Rec;
        TempWarrantyLedgerEntry."Document No." := '***';
        TempWarrantyLedgerEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Maintenance Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertMaintenanceLedgerEntry(var Rec: Record "Maintenance Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempMaintenanceLedgerEntry := Rec;
        TempMaintenanceLedgerEntry."Document No." := '***';
        TempMaintenanceLedgerEntry.Insert;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Job Ledger Entry", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertJobLedgEntry(var Rec: Record "Job Ledger Entry";RunTrigger: Boolean)
    begin
        if Rec.IsTemporary then
          exit;

        PreventCommit;
        TempJobLedgerEntry := Rec;
        TempJobLedgerEntry."Document No." := '***';
        TempJobLedgerEntry.Insert;
    end;
}

