#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 226 "CustEntry-Apply Posted Entries"
{
    EventSubscriberInstance = Manual;
    Permissions = TableData "Cust. Ledger Entry"=rimd;
    TableNo = "Cust. Ledger Entry";

    trigger OnRun()
    begin
        if PreviewMode then
          case RunOptionPreviewContext of
            Runoptionpreview::Apply:
              Apply(Rec,DocumentNoPreviewContext,ApplicationDatePreviewContext);
            Runoptionpreview::Unapply:
              PostUnApplyCustomer(DetailedCustLedgEntryPreviewContext,DocumentNoPreviewContext,ApplicationDatePreviewContext);
          end
        else
          Apply(Rec,"Document No.",0D);
    end;

    var
        PostingApplicationMsg: label 'Posting application...';
        MustNotBeBeforeErr: label 'The Posting Date entered must not be before the Posting Date on the Cust. Ledger Entry.';
        NoEntriesAppliedErr: label 'Cannot post because you did not specify which entry to apply. You must specify an entry in the %1 field for one or more open entries.', Comment='%1 - Caption of "Applies to ID" field of Gen. Journal Line';
        UnapplyPostedAfterThisEntryErr: label 'Before you can unapply this entry, you must first unapply all application entries that were posted after this entry.';
        NoApplicationEntryErr: label 'Cust. Ledger Entry No. %1 does not have an application entry.';
        UnapplyingMsg: label 'Unapplying and posting...';
        UnapplyAllPostedAfterThisEntryErr: label 'Before you can unapply this entry, you must first unapply all application entries in Cust. Ledger Entry No. %1 that were posted after this entry.';
        NotAllowedPostingDatesErr: label 'Posting date is not within the range of allowed posting dates.';
        LatestEntryMustBeAnApplicationErr: label 'The latest Transaction No. must be an application in Cust. Ledger Entry No. %1.';
        CannotUnapplyExchRateErr: label 'You cannot unapply the entry with the posting date %1, because the exchange rate for the additional reporting currency has been changed.';
        CannotUnapplyInReversalErr: label 'You cannot unapply Cust. Ledger Entry No. %1 because the entry is part of a reversal.';
        CannotApplyClosedEntriesErr: label 'One or more of the entries that you selected is closed. You cannot apply closed entries.';
        DetailedCustLedgEntryPreviewContext: Record "Detailed Cust. Ledg. Entry";
        ApplicationDatePreviewContext: Date;
        DocumentNoPreviewContext: Code[20];
        RunOptionPreview: Option Apply,Unapply;
        RunOptionPreviewContext: Option Apply,Unapply;
        PreviewMode: Boolean;


    procedure Apply(CustLedgEntry: Record "Cust. Ledger Entry";DocumentNo: Code[20];ApplicationDate: Date)
    var
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
    begin
        with CustLedgEntry do begin
          PaymentToleranceMgt.ApplyPostedEntriesMode;
          if not PreviewMode then
            if not PaymentToleranceMgt.PmtTolCust(CustLedgEntry) then
              exit;
          Get("Entry No.");

          if ApplicationDate = 0D then
            ApplicationDate := GetApplicationDate(CustLedgEntry)
          else
            if ApplicationDate < GetApplicationDate(CustLedgEntry) then
              Error(MustNotBeBeforeErr);

          if DocumentNo = '' then
            DocumentNo := "Document No.";

          CustPostApplyCustLedgEntry(CustLedgEntry,DocumentNo,ApplicationDate);
        end;
    end;


    procedure GetApplicationDate(CustLedgEntry: Record "Cust. Ledger Entry") ApplicationDate: Date
    var
        ApplyToCustLedgEntry: Record "Cust. Ledger Entry";
    begin
        with CustLedgEntry do begin
          ApplicationDate := 0D;
          ApplyToCustLedgEntry.SetCurrentkey("Customer No.","Applies-to ID");
          ApplyToCustLedgEntry.SetRange("Customer No.","Customer No.");
          ApplyToCustLedgEntry.SetRange("Applies-to ID","Applies-to ID");
          ApplyToCustLedgEntry.FindSet;
          repeat
            if ApplyToCustLedgEntry."Posting Date" > ApplicationDate then
              ApplicationDate := ApplyToCustLedgEntry."Posting Date";
          until ApplyToCustLedgEntry.Next = 0;
        end;
    end;

    local procedure CustPostApplyCustLedgEntry(CustLedgEntry: Record "Cust. Ledger Entry";DocumentNo: Code[20];ApplicationDate: Date)
    var
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        UpdateAnalysisView: Codeunit "Update Analysis View";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        EntryNoBeforeApplication: Integer;
        EntryNoAfterApplication: Integer;
    begin
        with CustLedgEntry do begin
          Window.Open(PostingApplicationMsg);

          SourceCodeSetup.Get;

          GenJnlLine.Init;
          GenJnlLine."Document No." := DocumentNo;
          GenJnlLine."Posting Date" := ApplicationDate;
          GenJnlLine."Document Date" := GenJnlLine."Posting Date";
          GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
          GenJnlLine."Account No." := "Customer No.";
          CalcFields("Debit Amount","Credit Amount","Debit Amount (LCY)","Credit Amount (LCY)");
          GenJnlLine.Correction :=
            ("Debit Amount" < 0) or ("Credit Amount" < 0) or
            ("Debit Amount (LCY)" < 0) or ("Credit Amount (LCY)" < 0);
          GenJnlLine.CopyCustLedgEntry(CustLedgEntry);
          GenJnlLine."Source Code" := SourceCodeSetup."Sales Entry Application";
          GenJnlLine."System-Created Entry" := true;

          EntryNoBeforeApplication := FindLastApplDtldCustLedgEntry;

          GenJnlPostLine.CustPostApplyCustLedgEntry(GenJnlLine,CustLedgEntry);

          EntryNoAfterApplication := FindLastApplDtldCustLedgEntry;
          if EntryNoAfterApplication = EntryNoBeforeApplication then
            Error(StrSubstNo(NoEntriesAppliedErr,GenJnlLine.FieldCaption("Applies-to ID")));

          if PreviewMode then
            GenJnlPostPreview.ThrowError;

          Commit;
          Window.Close;
          UpdateAnalysisView.UpdateAll(0,true);
        end;
    end;

    local procedure FindLastApplDtldCustLedgEntry(): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry.LockTable;
        if DtldCustLedgEntry.FindLast then
          exit(DtldCustLedgEntry."Entry No.");

        exit(0);
    end;

    local procedure FindLastApplEntry(CustLedgEntryNo: Integer): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ApplicationEntryNo: Integer;
    begin
        with DtldCustLedgEntry do begin
          SetCurrentkey("Cust. Ledger Entry No.","Entry Type");
          SetRange("Cust. Ledger Entry No.",CustLedgEntryNo);
          SetRange("Entry Type","entry type"::Application);
          SetRange(Unapplied,false);
          ApplicationEntryNo := 0;
          if Find('-') then
            repeat
              if "Entry No." > ApplicationEntryNo then
                ApplicationEntryNo := "Entry No.";
            until Next = 0;
        end;
        exit(ApplicationEntryNo);
    end;

    local procedure FindLastTransactionNo(CustLedgEntryNo: Integer): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        with DtldCustLedgEntry do begin
          SetCurrentkey("Cust. Ledger Entry No.","Entry Type");
          SetRange("Cust. Ledger Entry No.",CustLedgEntryNo);
          SetRange(Unapplied,false);
          SetFilter("Entry Type",'<>%1&<>%2',"entry type"::"Unrealized Loss","entry type"::"Unrealized Gain");
          LastTransactionNo := 0;
          if FindSet then
            repeat
              if LastTransactionNo < "Transaction No." then
                LastTransactionNo := "Transaction No.";
            until Next = 0;
        end;
        exit(LastTransactionNo);
    end;


    procedure UnApplyDtldCustLedgEntry(DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        ApplicationEntryNo: Integer;
    begin
        DtldCustLedgEntry.TestField("Entry Type",DtldCustLedgEntry."entry type"::Application);
        DtldCustLedgEntry.TestField(Unapplied,false);
        ApplicationEntryNo := FindLastApplEntry(DtldCustLedgEntry."Cust. Ledger Entry No.");

        if DtldCustLedgEntry."Entry No." <> ApplicationEntryNo then
          Error(UnapplyPostedAfterThisEntryErr);
        CheckReversal(DtldCustLedgEntry."Cust. Ledger Entry No.");
        UnApplyCustomer(DtldCustLedgEntry);
    end;


    procedure UnApplyCustLedgEntry(CustLedgEntryNo: Integer)
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ApplicationEntryNo: Integer;
    begin
        CheckReversal(CustLedgEntryNo);
        ApplicationEntryNo := FindLastApplEntry(CustLedgEntryNo);
        if ApplicationEntryNo = 0 then
          Error(NoApplicationEntryErr,CustLedgEntryNo);
        DtldCustLedgEntry.Get(ApplicationEntryNo);
        UnApplyCustomer(DtldCustLedgEntry);
    end;

    local procedure UnApplyCustomer(DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry")
    var
        UnapplyCustEntries: Page "Unapply Customer Entries";
    begin
        with DtldCustLedgEntry do begin
          TestField("Entry Type","entry type"::Application);
          TestField(Unapplied,false);
          UnapplyCustEntries.SetDtldCustLedgEntry("Entry No.");
          UnapplyCustEntries.LookupMode(true);
          UnapplyCustEntries.RunModal;
        end;
    end;


    procedure PostUnApplyCustomer(DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";DocNo: Code[20];PostingDate: Date)
    begin
        PostUnApplyCustomerCommit(DtldCustLedgEntry2,DocNo,PostingDate,true);
    end;


    procedure PostUnApplyCustomerCommit(DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";DocNo: Code[20];PostingDate: Date;CommitChanges: Boolean)
    var
        GLEntry: Record "G/L Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlLine: Record "Gen. Journal Line";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DateComprReg: Record "Date Compr. Register";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        Window: Dialog;
        LastTransactionNo: Integer;
        AddCurrChecked: Boolean;
        MaxPostingDate: Date;
    begin
        MaxPostingDate := 0D;
        GLEntry.LockTable;
        DtldCustLedgEntry.LockTable;
        CustLedgEntry.LockTable;
        CustLedgEntry.Get(DtldCustLedgEntry2."Cust. Ledger Entry No.");
        CheckPostingDate(PostingDate,MaxPostingDate);
        if PostingDate < DtldCustLedgEntry2."Posting Date" then
          Error(MustNotBeBeforeErr);
        if DtldCustLedgEntry2."Transaction No." = 0 then begin
          DtldCustLedgEntry.SetCurrentkey("Application No.","Customer No.","Entry Type");
          DtldCustLedgEntry.SetRange("Application No.",DtldCustLedgEntry2."Application No.");
        end else begin
          DtldCustLedgEntry.SetCurrentkey("Transaction No.","Customer No.","Entry Type");
          DtldCustLedgEntry.SetRange("Transaction No.",DtldCustLedgEntry2."Transaction No.");
        end;
        DtldCustLedgEntry.SetRange("Customer No.",DtldCustLedgEntry2."Customer No.");
        DtldCustLedgEntry.SetFilter("Entry Type",'<>%1',DtldCustLedgEntry."entry type"::"Initial Entry");
        DtldCustLedgEntry.SetRange(Unapplied,false);
        if DtldCustLedgEntry.Find('-') then
          repeat
            if not AddCurrChecked then begin
              CheckAdditionalCurrency(PostingDate,DtldCustLedgEntry."Posting Date");
              AddCurrChecked := true;
            end;
            CheckReversal(DtldCustLedgEntry."Cust. Ledger Entry No.");
            if DtldCustLedgEntry."Transaction No." <> 0 then begin
              if DtldCustLedgEntry."Entry Type" = DtldCustLedgEntry."entry type"::Application then begin
                LastTransactionNo :=
                  FindLastApplTransactionEntry(DtldCustLedgEntry."Cust. Ledger Entry No.");
                if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") then
                  Error(UnapplyAllPostedAfterThisEntryErr,DtldCustLedgEntry."Cust. Ledger Entry No.");
              end;
              LastTransactionNo := FindLastTransactionNo(DtldCustLedgEntry."Cust. Ledger Entry No.");
              if (LastTransactionNo <> 0) and (LastTransactionNo <> DtldCustLedgEntry."Transaction No.") then
                Error(LatestEntryMustBeAnApplicationErr,DtldCustLedgEntry."Cust. Ledger Entry No.");
            end;
          until DtldCustLedgEntry.Next = 0;

        DateComprReg.CheckMaxDateCompressed(MaxPostingDate,0);

        with DtldCustLedgEntry2 do begin
          SourceCodeSetup.Get;
          CustLedgEntry.Get("Cust. Ledger Entry No.");
          GenJnlLine."Document No." := DocNo;
          GenJnlLine."Posting Date" := PostingDate;
          GenJnlLine."Account Type" := GenJnlLine."account type"::Customer;
          GenJnlLine."Account No." := "Customer No.";
          GenJnlLine.Correction := true;
          GenJnlLine.CopyCustLedgEntry(CustLedgEntry);
          GenJnlLine."Source Code" := SourceCodeSetup."Unapplied Sales Entry Appln.";
          GenJnlLine."Source Currency Code" := "Currency Code";
          GenJnlLine."System-Created Entry" := true;
          Window.Open(UnapplyingMsg);
          GenJnlPostLine.UnapplyCustLedgEntry(GenJnlLine,DtldCustLedgEntry2);

          if PreviewMode then
            GenJnlPostPreview.ThrowError;

          if CommitChanges then
            Commit;
          Window.Close;
        end;
    end;

    local procedure CheckPostingDate(PostingDate: Date;var MaxPostingDate: Date)
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        if GenJnlCheckLine.DateNotAllowed(PostingDate) then
          Error(NotAllowedPostingDatesErr);

        if PostingDate > MaxPostingDate then
          MaxPostingDate := PostingDate;
    end;

    local procedure CheckAdditionalCurrency(OldPostingDate: Date;NewPostingDate: Date)
    var
        GLSetup: Record "General Ledger Setup";
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if OldPostingDate = NewPostingDate then
          exit;
        GLSetup.Get;
        if GLSetup."Additional Reporting Currency" <> '' then
          if CurrExchRate.ExchangeRate(OldPostingDate,GLSetup."Additional Reporting Currency") <>
             CurrExchRate.ExchangeRate(NewPostingDate,GLSetup."Additional Reporting Currency")
          then
            Error(CannotUnapplyExchRateErr,NewPostingDate);
    end;

    local procedure CheckReversal(CustLedgEntryNo: Integer)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.Get(CustLedgEntryNo);
        if CustLedgEntry.Reversed then
          Error(CannotUnapplyInReversalErr,CustLedgEntryNo);
    end;


    procedure ApplyCustEntryFormEntry(var ApplyingCustLedgEntry: Record "Cust. Ledger Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        ApplyCustEntries: Page "Apply Customer Entries";
        CustEntryApplID: Code[50];
    begin
        if not ApplyingCustLedgEntry.Open then
          Error(CannotApplyClosedEntriesErr);

        CustEntryApplID := UserId;
        if CustEntryApplID = '' then
          CustEntryApplID := '***';
        if ApplyingCustLedgEntry."Remaining Amount" = 0 then
          ApplyingCustLedgEntry.CalcFields("Remaining Amount");

        ApplyingCustLedgEntry."Applying Entry" := true;
        ApplyingCustLedgEntry."Applies-to ID" := CustEntryApplID;
        ApplyingCustLedgEntry."Amount to Apply" := ApplyingCustLedgEntry."Remaining Amount";
        Codeunit.Run(Codeunit::"Cust. Entry-Edit",ApplyingCustLedgEntry);
        Commit;

        CustLedgEntry.SetCurrentkey("Customer No.",Open,Positive);
        CustLedgEntry.SetRange("Customer No.",ApplyingCustLedgEntry."Customer No.");
        CustLedgEntry.SetRange(Open,true);
        if CustLedgEntry.FindFirst then begin
          ApplyCustEntries.SetCustLedgEntry(ApplyingCustLedgEntry);
          ApplyCustEntries.SetRecord(CustLedgEntry);
          ApplyCustEntries.SetTableview(CustLedgEntry);
          ApplyCustEntries.RunModal;
          Clear(ApplyCustEntries);
          ApplyingCustLedgEntry."Applying Entry" := false;
          ApplyingCustLedgEntry."Applies-to ID" := '';
          ApplyingCustLedgEntry."Amount to Apply" := 0;
        end;
    end;

    local procedure FindLastApplTransactionEntry(CustLedgEntryNo: Integer): Integer
    var
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        LastTransactionNo: Integer;
    begin
        DtldCustLedgEntry.SetCurrentkey("Cust. Ledger Entry No.","Entry Type");
        DtldCustLedgEntry.SetRange("Cust. Ledger Entry No.",CustLedgEntryNo);
        DtldCustLedgEntry.SetRange("Entry Type",DtldCustLedgEntry."entry type"::Application);
        LastTransactionNo := 0;
        if DtldCustLedgEntry.Find('-') then
          repeat
            if (DtldCustLedgEntry."Transaction No." > LastTransactionNo) and not DtldCustLedgEntry.Unapplied then
              LastTransactionNo := DtldCustLedgEntry."Transaction No.";
          until DtldCustLedgEntry.Next = 0;
        exit(LastTransactionNo);
    end;


    procedure PreviewApply(CustLedgEntry: Record "Cust. Ledger Entry";DocumentNo: Code[20];ApplicationDate: Date)
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
    begin
        BindSubscription(CustEntryApplyPostedEntries);
        CustEntryApplyPostedEntries.SetApplyContext(ApplicationDate,DocumentNo);
        GenJnlPostPreview.Preview(CustEntryApplyPostedEntries,CustLedgEntry);
    end;


    procedure PreviewUnapply(DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";DocumentNo: Code[20];ApplicationDate: Date)
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
    begin
        BindSubscription(CustEntryApplyPostedEntries);
        CustEntryApplyPostedEntries.SetUnapplyContext(DetailedCustLedgEntry,ApplicationDate,DocumentNo);
        GenJnlPostPreview.Preview(CustEntryApplyPostedEntries,CustLedgEntry);
    end;


    procedure SetApplyContext(ApplicationDate: Date;DocumentNo: Code[20])
    begin
        ApplicationDatePreviewContext := ApplicationDate;
        DocumentNoPreviewContext := DocumentNo;
        RunOptionPreviewContext := Runoptionpreview::Apply;
    end;


    procedure SetUnapplyContext(var DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";ApplicationDate: Date;DocumentNo: Code[20])
    begin
        ApplicationDatePreviewContext := ApplicationDate;
        DocumentNoPreviewContext := DocumentNo;
        DetailedCustLedgEntryPreviewContext := DetailedCustLedgEntry;
        RunOptionPreviewContext := Runoptionpreview::Unapply;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Preview", 'OnRunPreview', '', false, false)]
    local procedure OnPreviewRun(var Result: Boolean;Subscriber: Variant;RecVar: Variant)
    var
        CustEntryApplyPostedEntries: Codeunit "CustEntry-Apply Posted Entries";
    begin
        CustEntryApplyPostedEntries := Subscriber;
        PreviewMode := true;
        Result := CustEntryApplyPostedEntries.Run(RecVar);
    end;
}

