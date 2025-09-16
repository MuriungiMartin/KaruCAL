#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 395 "FinChrgMemo-Issue"
{
    Permissions = TableData "Cust. Ledger Entry"=rm,
                  TableData "Reminder/Fin. Charge Entry"=rimd,
                  TableData "Issued Fin. Charge Memo Header"=rimd,
                  TableData "Issued Fin. Charge Memo Line"=rimd;

    trigger OnRun()
    begin
        with FinChrgMemoHeader do begin
          UpdateFinanceChargeRounding(FinChrgMemoHeader);
          if (PostingDate <> 0D) and (ReplacePostingDate or ("Posting Date" = 0D)) then
            Validate("Posting Date",PostingDate);
          TestField("Customer No.");
          TestField("Posting Date");
          TestField("Document Date");
          TestField("Due Date");
          TestField("Customer Posting Group");
          if not DimMgt.CheckDimIDComb("Dimension Set ID") then
            Error(
              Text002,
              TableCaption,"No.",DimMgt.GetDimCombErr);

          TableID[1] := Database::Customer;
          No[1] := "Customer No.";
          if not DimMgt.CheckDimValuePosting(TableID,No,"Dimension Set ID") then
            Error(
              Text003,
              TableCaption,"No.",DimMgt.GetDimValuePostingErr);

          CustPostingGr.Get("Customer Posting Group");
          CalcFields("Interest Amount","Additional Fee","Remaining Amount");
          if ("Interest Amount" = 0) and ("Additional Fee" = 0) and ("Remaining Amount" = 0) then
            Error(Text000);
          SourceCodeSetup.Get;
          SourceCodeSetup.TestField("Finance Charge Memo");
          SrcCode := SourceCodeSetup."Finance Charge Memo";

          if ("Issuing No." = '') and ("No. Series" <> "Issuing No. Series") then begin
            TestField("Issuing No. Series");
            "Issuing No." := NoSeriesMgt.GetNextNo("Issuing No. Series","Posting Date",true);
            Modify;
            Commit;
          end;
          if "Issuing No." = '' then
            DocNo := "No."
          else
            DocNo := "Issuing No.";

          FinChrgMemoLine.SetRange("Finance Charge Memo No.","No.");
          if FinChrgMemoLine.Find('-') then
            repeat
              case FinChrgMemoLine.Type of
                FinChrgMemoLine.Type::" ":
                  FinChrgMemoLine.TestField(Amount,0);
                FinChrgMemoLine.Type::"G/L Account":
                  if (FinChrgMemoLine.Amount <> 0) and "Post Additional Fee" then begin
                    FinChrgMemoLine.TestField("No.");
                    InitGenJnlLine(GenJnlLine."account type"::"G/L Account",
                      FinChrgMemoLine."No.",
                      FinChrgMemoLine."Line Type" = FinChrgMemoLine."line type"::Rounding);
                    GenJnlLine."Gen. Prod. Posting Group" := FinChrgMemoLine."Gen. Prod. Posting Group";
                    GenJnlLine."VAT Prod. Posting Group" := FinChrgMemoLine."VAT Prod. Posting Group";
                    GenJnlLine."VAT Calculation Type" := FinChrgMemoLine."VAT Calculation Type";
                    if FinChrgMemoLine."VAT Calculation Type" =
                       FinChrgMemoLine."vat calculation type"::"Sales Tax"
                    then begin
                      GenJnlLine."Tax Area Code" := "Tax Area Code";
                      GenJnlLine."Tax Liable" := "Tax Liable";
                      GenJnlLine."Tax Group Code" := FinChrgMemoLine."Tax Group Code";
                    end;
                    GenJnlLine."VAT %" := FinChrgMemoLine."VAT %";
                    GenJnlLine.Validate(Amount,-FinChrgMemoLine.Amount - FinChrgMemoLine."VAT Amount");
                    GenJnlLine."VAT Amount" := -FinChrgMemoLine."VAT Amount";
                    GenJnlLine.UpdateLineBalance;
                    TotalAmount := TotalAmount - GenJnlLine.Amount;
                    TotalAmountLCY := TotalAmountLCY - GenJnlLine."Balance (LCY)";
                    GenJnlLine."Bill-to/Pay-to No." := "Customer No.";
                    GenJnlLine.Insert;
                  end;
                FinChrgMemoLine.Type::"Customer Ledger Entry":
                  begin
                    FinChrgMemoLine.TestField("Entry No.");
                    CustLedgEntry.Get(FinChrgMemoLine."Entry No.");
                    CustLedgEntry.TestField("Currency Code","Currency Code");
                    if FinChrgMemoLine.Amount < 0 then
                      FinChrgMemoLine.FieldError(Amount,Text001);
                    FinChrgMemoInterestAmount := FinChrgMemoInterestAmount + FinChrgMemoLine.Amount;
                    FinChrgMemoInterestVATAmount := FinChrgMemoInterestVATAmount + FinChrgMemoLine."VAT Amount";
                  end;
              end;
            until FinChrgMemoLine.Next = 0;

          if (FinChrgMemoInterestAmount <> 0) and "Post Interest" then begin
            CustPostingGr.TestField("Interest Account");
            InitGenJnlLine(GenJnlLine."account type"::"G/L Account",CustPostingGr."Interest Account",true);
            GenJnlLine.Validate("VAT Bus. Posting Group","VAT Bus. Posting Group");
            GenJnlLine.Validate(Amount,-FinChrgMemoInterestAmount - FinChrgMemoInterestVATAmount);
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
          if GenJnlLine.Find('-') then
            repeat
              GenJnlLine2 := GenJnlLine;
              GenJnlLine2."Shortcut Dimension 1 Code" := "Shortcut Dimension 1 Code";
              GenJnlLine2."Shortcut Dimension 2 Code" := "Shortcut Dimension 2 Code";
              GenJnlLine2."Dimension Set ID" := "Dimension Set ID";
              GenJnlPostLine.RunWithCheck(GenJnlLine2);
            until GenJnlLine.Next = 0;

          GenJnlLine.DeleteAll;

          if FinChrgMemoInterestAmount <> 0 then begin
            TestField("Fin. Charge Terms Code");
            FinChrgTerms.Get("Fin. Charge Terms Code");
            if FinChrgTerms."Interest Calculation" in
               [FinChrgTerms."interest calculation"::"Closed Entries",
                FinChrgTerms."interest calculation"::"All Entries"]
            then begin
              FinChrgMemoLine.SetRange(Type,FinChrgMemoLine.Type::"Customer Ledger Entry");
              if FinChrgMemoLine.Find('-') then
                repeat
                  CustLedgEntry.Get(FinChrgMemoLine."Entry No.");
                  CustLedgEntry.SetFilter("Date Filter",'..%1',"Document Date");
                  CustLedgEntry.CalcFields("Remaining Amount");
                  if CustLedgEntry."Remaining Amount" = 0 then begin
                    CustLedgEntry."Calculate Interest" := false;
                    CustLedgEntry.Modify;
                  end;
                  CustLedgEntry2.SetCurrentkey("Closed by Entry No.");
                  CustLedgEntry2.SetRange("Closed by Entry No.",CustLedgEntry."Entry No.");
                  CustLedgEntry2.SetRange("Closing Interest Calculated",false);
                  CustLedgEntry2.ModifyAll("Closing Interest Calculated",true);
                until FinChrgMemoLine.Next = 0;
              FinChrgMemoLine.SetRange(Type);
            end;
          end;

          IssuedFinChrgMemoHeader.TransferFields(FinChrgMemoHeader);
          IssuedFinChrgMemoHeader."No." := DocNo;
          IssuedFinChrgMemoHeader."Pre-Assigned No." := "No.";
          IssuedFinChrgMemoHeader."Source Code" := SrcCode;
          IssuedFinChrgMemoHeader."User ID" := UserId;
          IssuedFinChrgMemoHeader.Insert;

          if NextEntryNo = 0 then begin
            ReminderEntry.LockTable;
            if ReminderEntry.FindLast then
              NextEntryNo := ReminderEntry."Entry No." + 1
            else
              NextEntryNo := 1;
          end;

          FinChrgMemoCommentLine.SetRange(Type,FinChrgMemoCommentLine.Type::"Finance Charge Memo");
          FinChrgMemoCommentLine.SetRange("No.","No.");
          if FinChrgMemoCommentLine.Find('-') then
            repeat
              FinChrgMemoCommentLine2.TransferFields(FinChrgMemoCommentLine);
              FinChrgMemoCommentLine2.Type := FinChrgMemoCommentLine2.Type::"Issued Finance Charge Memo";
              FinChrgMemoCommentLine2."No." := IssuedFinChrgMemoHeader."No.";
              FinChrgMemoCommentLine2.Insert;
            until FinChrgMemoCommentLine.Next = 0;
          FinChrgMemoCommentLine.DeleteAll;

          if FinChrgMemoLine.Find('-') then
            repeat
              if FinChrgMemoLine.Type = FinChrgMemoLine.Type::"Customer Ledger Entry" then begin
                ReminderEntry.Init;
                ReminderEntry."Entry No." := NextEntryNo;
                ReminderEntry.Type := ReminderEntry.Type::"Finance Charge Memo";
                ReminderEntry."No." := IssuedFinChrgMemoHeader."No.";
                ReminderEntry."Posting Date" := "Posting Date";
                ReminderEntry."Due Date" := "Due Date";
                ReminderEntry."Document Date" := "Document Date";
                ReminderEntry."Customer No." := "Customer No.";
                ReminderEntry."Customer Entry No." := FinChrgMemoLine."Entry No.";
                ReminderEntry."Document Type" := FinChrgMemoLine."Document Type";
                ReminderEntry."Document No." := FinChrgMemoLine."Document No.";
                ReminderEntry."Remaining Amount" := FinChrgMemoLine."Remaining Amount";
                ReminderEntry."Interest Amount" := FinChrgMemoLine.Amount;
                ReminderEntry."Interest Posted" := (FinChrgMemoInterestAmount <> 0) and "Post Interest";
                ReminderEntry."User ID" := UserId;
                ReminderEntry.Insert;
                NextEntryNo := NextEntryNo + 1;
              end;
              IssuedFinChrgMemoLine.TransferFields(FinChrgMemoLine);
              IssuedFinChrgMemoLine."Finance Charge Memo No." := IssuedFinChrgMemoHeader."No.";
              IssuedFinChrgMemoLine.Insert;
            until FinChrgMemoLine.Next = 0;
          FinChrgMemoLine.DeleteAll;
          Delete;
        end;
    end;

    var
        Text000: label 'There is nothing to issue.';
        Text001: label 'must be positive or 0';
        Text002: label 'The combination of dimensions used in %1 %2 is blocked. %3';
        Text003: label 'A dimension in %1 %2 has caused an error. %3';
        SourceCodeSetup: Record "Source Code Setup";
        CustPostingGr: Record "Customer Posting Group";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CustLedgEntry2: Record "Cust. Ledger Entry";
        FinChrgTerms: Record "Finance Charge Terms";
        FinChrgMemoHeader: Record "Finance Charge Memo Header";
        FinChrgMemoLine: Record "Finance Charge Memo Line";
        IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header";
        IssuedFinChrgMemoLine: Record "Issued Fin. Charge Memo Line";
        FinChrgMemoCommentLine: Record "Fin. Charge Comment Line";
        FinChrgMemoCommentLine2: Record "Fin. Charge Comment Line";
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
        FinChrgMemoInterestAmount: Decimal;
        FinChrgMemoInterestVATAmount: Decimal;
        TotalAmount: Decimal;
        TotalAmountLCY: Decimal;
        TableID: array [10] of Integer;
        No: array [10] of Code[20];


    procedure Set(var NewFinChrgMemoHeader: Record "Finance Charge Memo Header";NewReplacePostingDate: Boolean;NewPostingDate: Date)
    begin
        FinChrgMemoHeader := NewFinChrgMemoHeader;
        ReplacePostingDate := NewReplacePostingDate;
        PostingDate := NewPostingDate;
    end;


    procedure GetIssuedFinChrgMemo(var NewIssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header")
    begin
        NewIssuedFinChrgMemoHeader := IssuedFinChrgMemoHeader;
    end;

    local procedure InitGenJnlLine(AccType: Integer;AccNo: Code[20];SystemCreatedEntry: Boolean)
    begin
        with FinChrgMemoHeader do begin
          GenJnlLine.Init;
          GenJnlLine."Line No." := GenJnlLine."Line No." + 1;
          GenJnlLine."Document Type" := GenJnlLine."document type"::"Finance Charge Memo";
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


    procedure DeleteIssuedFinChrgLines(IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header")
    var
        IssuedFinChrgMemoLine: Record "Issued Fin. Charge Memo Line";
    begin
        IssuedFinChrgMemoLine.SetRange("Finance Charge Memo No.",IssuedFinChrgMemoHeader."No.");
        IssuedFinChrgMemoLine.DeleteAll;
    end;


    procedure IncrNoPrinted(var IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header")
    begin
        with IssuedFinChrgMemoHeader do begin
          Find;
          "No. Printed" := "No. Printed" + 1;
          Modify;
          Commit;
        end;
    end;


    procedure TestDeleteHeader(FinChrgMemoHeader: Record "Finance Charge Memo Header";var IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header")
    begin
        with FinChrgMemoHeader do begin
          Clear(IssuedFinChrgMemoHeader);
          SourceCodeSetup.Get;
          SourceCodeSetup.TestField("Deleted Document");
          SourceCode.Get(SourceCodeSetup."Deleted Document");

          if ("Issuing No. Series" <> '') and
             (("Issuing No." <> '') or ("No. Series" = "Issuing No. Series"))
          then begin
            IssuedFinChrgMemoHeader.TransferFields(FinChrgMemoHeader);
            if "Issuing No." <> '' then
              IssuedFinChrgMemoHeader."No." := "Issuing No.";
            IssuedFinChrgMemoHeader."Pre-Assigned No. Series" := "No. Series";
            IssuedFinChrgMemoHeader."Pre-Assigned No." := "No.";
            IssuedFinChrgMemoHeader."Posting Date" := Today;
            IssuedFinChrgMemoHeader."User ID" := UserId;
            IssuedFinChrgMemoHeader."Source Code" := SourceCode.Code;
          end;
        end;
    end;


    procedure DeleteHeader(FinChrgMemoHeader: Record "Finance Charge Memo Header";var IssuedFinChrgMemoHeader: Record "Issued Fin. Charge Memo Header")
    begin
        with FinChrgMemoHeader do begin
          TestDeleteHeader(FinChrgMemoHeader,IssuedFinChrgMemoHeader);
          if IssuedFinChrgMemoHeader."No." <> '' then begin
            IssuedFinChrgMemoHeader."Shortcut Dimension 1 Code" := '';
            IssuedFinChrgMemoHeader."Shortcut Dimension 2 Code" := '';
            IssuedFinChrgMemoHeader.Insert;
            IssuedFinChrgMemoLine.Init;
            IssuedFinChrgMemoLine."Finance Charge Memo No." := "No.";
            IssuedFinChrgMemoLine."Line No." := 10000;
            IssuedFinChrgMemoLine.Description := SourceCode.Description;
            IssuedFinChrgMemoLine.Insert;
          end;
        end;
    end;
}

