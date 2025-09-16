#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 393 "Reminder-Issue"
{
    Permissions = TableData "Cust. Ledger Entry"=rm,
                  TableData "Issued Reminder Header"=rimd,
                  TableData "Issued Reminder Line"=rimd,
                  TableData "Reminder/Fin. Charge Entry"=rimd;

    trigger OnRun()
    var
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        with ReminderHeader do begin
          UpdateReminderRounding(ReminderHeader);
          if (PostingDate <> 0D) and (ReplacePostingDate or ("Posting Date" = 0D)) then
            Validate("Posting Date",PostingDate);
          TestField("Customer No.");
          Cust.Get("Customer No.");
          if Cust.Blocked = Cust.Blocked::All then
            Error(Text004,Cust.FieldCaption(Blocked),Cust.Blocked,Cust.TableCaption,"Customer No.");

          TestField("Posting Date");
          TestField("Document Date");
          TestField("Due Date");
          TestField("Customer Posting Group");
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(
              DimensionCombinationIsBlockedErr,
              TableCaption,"No.",DimMgt.GetDimCombErr);

          TableID[1] := Database::Customer;
          No[1] := "Customer No.";
          if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
            Error(
              Text003,
              TableCaption,"No.",DimMgt.GetDimValuePostingErr);

          CustPostingGr.Get("Customer Posting Group");
          CalcFields("Interest Amount","Additional Fee","Remaining Amount","Add. Fee per Line");
          if ("Interest Amount" = 0) and ("Additional Fee" = 0) and ("Add. Fee per Line" = 0) and ("Remaining Amount" = 0) then
            Error(Text000);
          SourceCodeSetup.Get;
          SourceCodeSetup.TestField(Reminder);
          SrcCode := SourceCodeSetup.Reminder;

          if ("Issuing No." = '') and ("No. Series" <> "Issuing No. Series") then begin
            TestField("Issuing No. Series");
            "Issuing No." := NoSeriesMgt.GetNextNo("Issuing No. Series","Posting Date",true);
            Modify;
            Commit;
          end;
          if "Issuing No." <> '' then
            DocNo := "Issuing No."
          else
            DocNo := "No.";

          ReminderLine.SetRange("Reminder No.","No.");
          if ReminderLine.Find('-') then
            repeat
              case ReminderLine.Type of
                ReminderLine.Type::" ":
                  ReminderLine.TestField(Amount,0);
                ReminderLine.Type::"G/L Account":
                  if "Post Additional Fee" then
                    InsertGenJnlLineForFee(ReminderLine);
                ReminderLine.Type::"Customer Ledger Entry":
                  begin
                    ReminderLine.TestField("Entry No.");
                    ReminderInterestAmount := ReminderInterestAmount + ReminderLine.Amount;
                    ReminderInterestVATAmount := ReminderInterestVATAmount + ReminderLine."VAT Amount";
                  end;
                ReminderLine.Type::"Line Fee":
                  if "Post Add. Fee per Line" then begin
                    CheckLineFee(ReminderLine,ReminderHeader);
                    InsertGenJnlLineForFee(ReminderLine);
                  end;
              end;
            until ReminderLine.Next = 0;

          if (ReminderInterestAmount <> 0) and "Post Interest" then begin
            if ReminderInterestAmount < 0 then
              Error(Text001);
            CustPostingGr.TestField("Interest Account");
            InitGenJnlLine(GenJnlLine."account type"::"G/L Account",CustPostingGr."Interest Account",true);
            GenJnlLine.Validate("VAT Bus. Posting Group","VAT Bus. Posting Group");
            GenJnlLine.Validate(Amount,-ReminderInterestAmount - ReminderInterestVATAmount);
            GenJnlLine.UpdateLineBalance;
            TotalAmount := TotalAmount - GenJnlLine.Amount;
            TotalAmountLCY := TotalAmountLCY - GenJnlLine."Balance (LCY)";
            GenJnlLine."Bill-to/Pay-to No." := "Customer No.";
            GenJnlLine.Insert;
          end;

          if (TotalAmount <> 0) or (TotalAmountLCY <> 0) then begin
            InitGenJnlLine(GenJnlLine."account type"::Customer,"Customer No.",true);
            GenJnlLine.Validate(Amount,TotalAmount);
            GenJnlLine.Validate("Amount (LCY)",TotalAmountLCY);
            GenJnlLine.Insert;
          end;

          Clear(GenJnlPostLine);
          if GenJnlLine.Find('-') then
            repeat
              GenJnlLine2 := GenJnlLine;
              GenJnlLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
              GenJnlLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
              GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
              GenJnlPostLine.Run(GenJnlLine2);
            until GenJnlLine.Next = 0;

          GenJnlLine.DeleteAll;

          if (ReminderInterestAmount <> 0) and "Post Interest" then begin
            TestField("Fin. Charge Terms Code");
            FinChrgTerms.Get("Fin. Charge Terms Code");
            if FinChrgTerms."Interest Calculation" in
               [FinChrgTerms."interest calculation"::"Closed Entries",
                FinChrgTerms."interest calculation"::"All Entries"]
            then begin
              ReminderLine.SetRange(Type,ReminderLine.Type::"Customer Ledger Entry");
              if ReminderLine.Find('-') then
                repeat
                  CustLedgEntry.Get(ReminderLine."Entry No.");
                  CustLedgEntry.TestField("Currency Code","Currency Code");
                  CustLedgEntry.CalcFields("Remaining Amount");
                  if CustLedgEntry."Remaining Amount" = 0 then begin
                    CustLedgEntry."Calculate Interest" := false;
                    CustLedgEntry.Modify;
                  end;
                  CustLedgEntry2.SetCurrentkey("Closed by Entry No.");
                  CustLedgEntry2.SetRange("Closed by Entry No.",CustLedgEntry."Entry No.");
                  CustLedgEntry2.SetRange("Closing Interest Calculated",false);
                  CustLedgEntry2.ModifyAll("Closing Interest Calculated",true);
                until ReminderLine.Next = 0;
              ReminderLine.SetRange(Type);
            end;
          end;

          IssuedReminderHeader.TransferFields(ReminderHeader);
          IssuedReminderHeader."No." := DocNo;
          IssuedReminderHeader."Pre-Assigned No." := "No.";
          IssuedReminderHeader."Source Code" := SrcCode;
          IssuedReminderHeader."User ID" := UserId;
          IssuedReminderHeader.Insert;

          if NextEntryNo = 0 then begin
            ReminderEntry.LockTable;
            if ReminderEntry.FindLast then
              NextEntryNo := ReminderEntry."Entry No." + 1
            else
              NextEntryNo := 1;
          end;

          ReminderCommentLine.SetRange(Type,ReminderCommentLine.Type::Reminder);
          ReminderCommentLine.SetRange("No.","No.");
          if ReminderCommentLine.Find('-') then
            repeat
              ReminderCommentLine2.TransferFields(ReminderCommentLine);
              ReminderCommentLine2.Type := ReminderCommentLine2.Type::"Issued Reminder";
              ReminderCommentLine2."No." := IssuedReminderHeader."No.";
              ReminderCommentLine2.Insert;
            until ReminderCommentLine.Next = 0;
          ReminderCommentLine.DeleteAll;

          if ReminderLine.Find('-') then
            repeat
              if (ReminderLine.Type = ReminderLine.Type::"Customer Ledger Entry") and
                 (ReminderLine."Entry No." <> 0)
              then begin
                ReminderEntry.Init;
                ReminderEntry."Entry No." := NextEntryNo;
                ReminderEntry.Type := ReminderEntry.Type::Reminder;
                ReminderEntry."No." := IssuedReminderHeader."No.";
                ReminderEntry."Posting Date" := "Posting Date";
                ReminderEntry."Document Date" := "Document Date";
                ReminderEntry."Due Date" := IssuedReminderHeader."Due Date";
                ReminderEntry."Customer No." := "Customer No.";
                ReminderEntry."Customer Entry No." := ReminderLine."Entry No.";
                ReminderEntry."Document Type" := ReminderLine."Document Type";
                ReminderEntry."Document No." := ReminderLine."Document No.";
                ReminderEntry."Reminder Level" := ReminderLine."No. of Reminders";
                ReminderEntry."Remaining Amount" := ReminderLine."Remaining Amount";
                ReminderEntry."Interest Amount" := ReminderLine.Amount;
                ReminderEntry."Interest Posted" :=
                  (ReminderInterestAmount <> 0) and "Post Interest";
                ReminderEntry."User ID" := UserId;
                ReminderEntry.Insert;
                NextEntryNo := NextEntryNo + 1;
                if ReminderLine."Line Type" <> ReminderLine."line type"::"Not Due" then
                  UpdateCustLedgEntryLastIssuedReminderLevel(ReminderEntry);
              end;
              IssuedReminderLine.TransferFields(ReminderLine);
              IssuedReminderLine."Reminder No." := IssuedReminderHeader."No.";
              IssuedReminderLine.Insert;
            until ReminderLine.Next = 0;
          ReminderLine.DeleteAll;
          Delete;
        end;
    end;

    var
        Text000: label 'There is nothing to issue.';
        Text001: label 'Interests must be positive or 0';
        DimensionCombinationIsBlockedErr: label 'The combination of dimensions used in %1 %2 is blocked. %3.', Comment='%1: TABLECAPTION(Reminder Header); %2: Field(No.); %3: Text GetDimCombErr';
        Text003: label 'A dimension used in %1 %2 has caused an error. %3';
        SourceCodeSetup: Record "Source Code Setup";
        CustPostingGr: Record "Customer Posting Group";
        FinChrgTerms: Record "Finance Charge Terms";
        ReminderHeader: Record "Reminder Header";
        ReminderLine: Record "Reminder Line";
        IssuedReminderHeader: Record "Issued Reminder Header";
        IssuedReminderLine: Record "Issued Reminder Line";
        ReminderCommentLine: Record "Reminder Comment Line";
        ReminderCommentLine2: Record "Reminder Comment Line";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        ReminderEntry: Record "Reminder/Fin. Charge Entry";
        GenJnlLine: Record "Gen. Journal Line" temporary;
        GenJnlLine2: Record "Gen. Journal Line";
        SourceCode: Record "Source Code";
        DimMgt: Codeunit DimensionManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DocNo: Code[20];
        NextEntryNo: Integer;
        ReplacePostingDate: Boolean;
        PostingDate: Date;
        SrcCode: Code[10];
        ReminderInterestAmount: Decimal;
        ReminderInterestVATAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountLCY: Decimal;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];
        Text004: label '%1 must not be %2 in %3 %4';
        LineFeeAmountErr: label 'Line Fee amount must be positive and non-zero for Line Fee applied to %1 %2.', Comment='%1 = Document Type, %2 = Document No.. E.g. Line Fee amount must be positive and non-zero for Line Fee applied to Invoice 102421';
        AppliesToDocErr: label 'Line Fee has to be applied to an open overdue document.';
        EntryNotOverdueErr: label '%1 %2 in %3 is not overdue.', Comment='%1 = Document Type, %2 = Document No., %3 = Table name. E.g. Invoice 12313 in Cust. Ledger Entry is not overdue.';
        LineFeeAlreadyIssuedErr: label 'The Line Fee for %1 %2 on reminder level %3 has already been issued.', Comment='%1 = Document Type, %2 = Document No. %3 = Reminder Level. E.g. The Line Fee for Invoice 141232 on reminder level 2 has already been issued.';
        MultipleLineFeesSameDocErr: label 'You cannot issue multiple line fees for the same level for the same document. Error with line fees for %1 %2.', Comment='%1 = Document Type, %2 = Document No. E.g. You cannot issue multiple line fees for the same level for the same document. Error with line fees for Invoice 1312312.';


    procedure Set(var NewReminderHeader: Record "Reminder Header";NewReplacePostingDate: Boolean;NewPostingDate: Date)
    begin
        ReminderHeader := NewReminderHeader;
        ReplacePostingDate := NewReplacePostingDate;
        PostingDate := NewPostingDate;
    end;


    procedure GetIssuedReminder(var NewIssuedReminderHeader: Record "Issued Reminder Header")
    begin
        NewIssuedReminderHeader := IssuedReminderHeader;
    end;

    local procedure InitGenJnlLine(AccType: Integer;AccNo: Code[20];SystemCreatedEntry: Boolean)
    begin
        with ReminderHeader do begin
          GenJnlLine.Init;
          GenJnlLine."Line No." := GenJnlLine."Line No." + 1;
          GenJnlLine."Document Type" := GenJnlLine."document type"::Reminder;
          GenJnlLine."Document No." := DocNo;
          GenJnlLine."Posting Date" := "Posting Date";
          GenJnlLine."Document Date" := "Document Date";
          GenJnlLine."Account Type" := AccType;
          GenJnlLine."Account No." := AccNo;
          GenJnlLine.Validate("Account No.");
          if GenJnlLine."Account Type" = GenJnlLine."account type"::"G/L Account" then begin
            GenJnlLine."Gen. Posting Type" := GenJnlLine."gen. posting type"::Sale;
            GenJnlLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
            GenJnlLine."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
          end;
          GenJnlLine.Validate("Currency Code","Currency Code");
          if GenJnlLine."Account Type" = GenJnlLine."account type"::Customer then begin
            GenJnlLine.Validate(Amount,TotalAmount);
            GenJnlLine.Validate("Amount (LCY)",TotalAmountLCY);
            GenJnlLine."Due Date" := "Due Date";
          end;
          GenJnlLine.Description := "Posting Description";
          GenJnlLine."Source Type" := GenJnlLine."source type"::Customer;
          GenJnlLine."Source No." := "Customer No.";
          GenJnlLine."Source Code" := SrcCode;
          GenJnlLine."Reason Code" := "Reason Code";
          GenJnlLine."System-Created Entry" := SystemCreatedEntry;
          GenJnlLine."Posting No. Series" := "Issuing No. Series";
          GenJnlLine."Salespers./Purch. Code" := '';
        end;
    end;


    procedure DeleteIssuedReminderLines(IssuedReminderHeader: Record "Issued Reminder Header")
    var
        IssuedReminderLine: Record "Issued Reminder Line";
    begin
        IssuedReminderLine.SetRange("Reminder No.",IssuedReminderHeader."No.");
        IssuedReminderLine.DeleteAll;
    end;


    procedure IncrNoPrinted(var IssuedReminderHeader: Record "Issued Reminder Header")
    begin
        with IssuedReminderHeader do begin
          Find;
          "No. Printed" := "No. Printed" + 1;
          Modify;
          Commit;
        end;
    end;


    procedure TestDeleteHeader(ReminderHeader: Record "Reminder Header";var IssuedReminderHeader: Record "Issued Reminder Header")
    begin
        with ReminderHeader do begin
          Clear(IssuedReminderHeader);
          SourceCodeSetup.Get;
          SourceCodeSetup.TestField("Deleted Document");
          SourceCode.Get(SourceCodeSetup."Deleted Document");

          if ("Issuing No. Series" <> '') and
             (("Issuing No." <> '') or ("No. Series" = "Issuing No. Series"))
          then begin
            IssuedReminderHeader.TransferFields(ReminderHeader);
            if "Issuing No." <> '' then
              IssuedReminderHeader."No." := "Issuing No.";
            IssuedReminderHeader."Pre-Assigned No. Series" := "No. Series";
            IssuedReminderHeader."Pre-Assigned No." := "No.";
            IssuedReminderHeader."Posting Date" := Today;
            IssuedReminderHeader."User ID" := UserId;
            IssuedReminderHeader."Source Code" := SourceCode.Code;
          end;
        end;
    end;


    procedure DeleteHeader(ReminderHeader: Record "Reminder Header";var IssuedReminderHeader: Record "Issued Reminder Header")
    begin
        with ReminderHeader do begin
          TestDeleteHeader(ReminderHeader,IssuedReminderHeader);
          if IssuedReminderHeader."No." <> '' then begin
            IssuedReminderHeader."Shortcut Dimension 1 Code" := '';
            IssuedReminderHeader."Shortcut Dimension 2 Code" := '';
            IssuedReminderHeader.Insert;
            IssuedReminderLine.Init;
            IssuedReminderLine."Reminder No." := "No.";
            IssuedReminderLine."Line No." := 10000;
            IssuedReminderLine.Description := SourceCode.Description;
            IssuedReminderLine.Insert;
          end;
        end;
    end;


    procedure ChangeDueDate(var ReminderEntry2: Record "Reminder/Fin. Charge Entry";NewDueDate: Date;OldDueDate: Date)
    begin
        ReminderEntry2."Due Date" := ReminderEntry2."Due Date" + (NewDueDate - OldDueDate);
        ReminderEntry2.Modify;
    end;

    local procedure InsertGenJnlLineForFee(var ReminderLine: Record "Reminder Line")
    begin
        with ReminderHeader do
          if ReminderLine.Amount <> 0 then begin
            ReminderLine.TestField("No.");
            InitGenJnlLine(GenJnlLine."account type"::"G/L Account",
              ReminderLine."No.",
              ReminderLine."Line Type" = ReminderLine."line type"::Rounding);
            GenJnlLine."Gen. Prod. Posting Group" := ReminderLine."Gen. Prod. Posting Group";
            GenJnlLine."VAT Prod. Posting Group" := ReminderLine."VAT Prod. Posting Group";
            GenJnlLine."VAT Calculation Type" := ReminderLine."VAT Calculation Type";
            if ReminderLine."VAT Calculation Type" =
               ReminderLine."vat calculation type"::"Sales Tax"
            then begin
              GenJnlLine."Tax Area Code" := "Tax Area Code";
              GenJnlLine."Tax Liable" := "Tax Liable";
              GenJnlLine."Tax Group Code" := ReminderLine."Tax Group Code";
            end;
            GenJnlLine."VAT %" := ReminderLine."VAT %";
            GenJnlLine.Validate(Amount,-ReminderLine.Amount - ReminderLine."VAT Amount");
            GenJnlLine."VAT Amount" := -ReminderLine."VAT Amount";
            GenJnlLine.UpdateLineBalance;
            TotalAmount := TotalAmount - GenJnlLine.Amount;
            TotalAmountLCY := TotalAmountLCY - GenJnlLine."Balance (LCY)";
            GenJnlLine."Bill-to/Pay-to No." := "Customer No.";
            GenJnlLine.Insert;
          end;
    end;

    local procedure CheckLineFee(var ReminderLine: Record "Reminder Line";var ReminderHeader: Record "Reminder Header")
    var
        CustLedgEntry3: Record "Cust. Ledger Entry";
        ReminderLine2: Record "Reminder Line";
    begin
        if ReminderLine.Amount <= 0 then
          Error(LineFeeAmountErr,ReminderLine."Applies-to Document Type",ReminderLine."Applies-to Document No.");
        if ReminderLine."Applies-to Document No." = '' then
          Error(AppliesToDocErr);

        with CustLedgEntry3 do begin
          SetRange("Document Type",ReminderLine."Applies-to Document Type");
          SetRange("Document No.",ReminderLine."Applies-to Document No.");
          SetRange("Customer No.",ReminderHeader."Customer No.");
          FindFirst;
          if "Due Date" >= ReminderHeader."Document Date" then
            Error(
              EntryNotOverdueErr,FieldCaption("Document No."),ReminderLine."Applies-to Document No.",TableName);
        end;

        with IssuedReminderLine do begin
          Reset;
          SetRange("Applies-To Document Type",ReminderLine."Applies-to Document Type");
          SetRange("Applies-To Document No.",ReminderLine."Applies-to Document No.");
          SetRange(Type,Type::"Line Fee");
          SetRange("No. of Reminders",ReminderLine."No. of Reminders");
          if FindFirst then
            Error(
              LineFeeAlreadyIssuedErr,ReminderLine."Applies-to Document Type",ReminderLine."Applies-to Document No.",
              ReminderLine."No. of Reminders");
        end;

        with ReminderLine2 do begin
          Reset;
          SetRange("Applies-to Document Type",ReminderLine."Applies-to Document Type");
          SetRange("Applies-to Document No.",ReminderLine."Applies-to Document No.");
          SetRange(Type,IssuedReminderLine.Type::"Line Fee");
          SetRange("No. of Reminders",ReminderLine."No. of Reminders");
          if Count > 1 then
            Error(MultipleLineFeesSameDocErr,ReminderLine."Applies-to Document Type",ReminderLine."Applies-to Document No.");
        end;
    end;


    procedure UpdateCustLedgEntryLastIssuedReminderLevel(ReminderFinChargeEntry: Record "Reminder/Fin. Charge Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.LockTable;
        CustLedgEntry.Get(ReminderFinChargeEntry."Customer Entry No.");
        CustLedgEntry."Last Issued Reminder Level" := ReminderFinChargeEntry."Reminder Level";
        CustLedgEntry.Modify;
    end;
}

