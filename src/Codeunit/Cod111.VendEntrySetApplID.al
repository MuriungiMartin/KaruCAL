#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 111 "Vend. Entry-SetAppl.ID"
{
    Permissions = TableData "Vendor Ledger Entry"=imd;

    trigger OnRun()
    begin
    end;

    var
        VendEntryApplID: Code[50];


    procedure SetApplId(var VendLedgEntry: Record "Vendor Ledger Entry";ApplyingVendLedgEntry: Record "Vendor Ledger Entry";AppliesToID: Code[50])
    begin
        VendLedgEntry.LockTable;
        if VendLedgEntry.Find('-') then begin
          // Make Applies-to ID
          if VendLedgEntry."Applies-to ID" <> '' then
            VendEntryApplID := ''
          else begin
            VendEntryApplID := AppliesToID;
            if VendEntryApplID = '' then begin
              VendEntryApplID := UserId;
              if VendEntryApplID = '' then
                VendEntryApplID := '***';
            end;
          end;

          // Set Applies-to ID
          repeat
            VendLedgEntry.TestField(Open,true);
            VendLedgEntry."Applies-to ID" := VendEntryApplID;
            if VendLedgEntry."Applies-to ID" = '' then begin
              VendLedgEntry."Accepted Pmt. Disc. Tolerance" := false;
              VendLedgEntry."Accepted Payment Tolerance" := 0;
            end;
            // Set Amount to Apply

            if ((VendLedgEntry."Amount to Apply" <> 0) and (VendEntryApplID = '')) or
               (VendEntryApplID = '')
            then
              VendLedgEntry."Amount to Apply" := 0
            else
              if VendLedgEntry."Amount to Apply" = 0 then begin
                VendLedgEntry.CalcFields("Remaining Amount");
                VendLedgEntry."Amount to Apply" := VendLedgEntry."Remaining Amount"
              end;

            if VendLedgEntry."Entry No." = ApplyingVendLedgEntry."Entry No." then
              VendLedgEntry."Applying Entry" := ApplyingVendLedgEntry."Applying Entry";
            VendLedgEntry.Modify;
          until VendLedgEntry.Next = 0;
        end;
    end;
}

