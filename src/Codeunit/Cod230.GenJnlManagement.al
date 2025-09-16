#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 230 GenJnlManagement
{
    Permissions = TableData "Gen. Journal Template"=imd,
                  TableData "Gen. Journal Batch"=imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Fixed Asset G/L Journal';
        Text001: label '%1 journal';
        Text002: label 'RECURRING';
        Text003: label 'Recurring General Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';
        LastGenJnlLine: Record "Gen. Journal Line";
        OpenFromBatch: Boolean;
        USText000: label 'Deposit Document';


    procedure TemplateSelection(PageID: Integer;PageTemplate: Option General,Sales,Purchases,"Cash Receipts",Payments,Assets,Intercompany,Jobs,,Deposits,"Sales Tax";RecurringJnl: Boolean;var GenJnlLine: Record "Gen. Journal Line";var JnlSelected: Boolean)
    var
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        JnlSelected := true;

        GenJnlTemplate.Reset;
        GenJnlTemplate.SetRange("Page ID",PageID);
        GenJnlTemplate.SetRange(Recurring,RecurringJnl);
        if not RecurringJnl then
          GenJnlTemplate.SetRange(Type,PageTemplate);

        case GenJnlTemplate.Count of
          0:
            begin
              GenJnlTemplate.Init;
              GenJnlTemplate.Type := PageTemplate;
              GenJnlTemplate.Recurring := RecurringJnl;
              if not RecurringJnl then begin
                GenJnlTemplate.Name := Format(GenJnlTemplate.Type,MaxStrLen(GenJnlTemplate.Name));
                if PageTemplate = Pagetemplate::Assets then
                  GenJnlTemplate.Description := Text000
                else if PageTemplate = Pagetemplate::Deposits then
                  GenJnlTemplate.Description := USText000
                else
                  GenJnlTemplate.Description := StrSubstNo(Text001,GenJnlTemplate.Type);
              end else begin
                GenJnlTemplate.Name := Text002;
                GenJnlTemplate.Description := Text003;
              end;
              GenJnlTemplate.Validate(Type);
              GenJnlTemplate.Insert;
              Commit;
            end;
          1:
            GenJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,GenJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
          GenJnlLine.FilterGroup := 2;
          GenJnlLine.SetRange("Journal Template Name",GenJnlTemplate.Name);
          GenJnlLine.FilterGroup := 0;
          if OpenFromBatch then begin
            GenJnlLine."Journal Template Name" := '';
            Page.Run(GenJnlTemplate."Page ID",GenJnlLine);
          end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var GenJnlBatch: Record "Gen. Journal Batch")
    var
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlTemplate: Record "Gen. Journal Template";
    begin
        OpenFromBatch := true;
        GenJnlTemplate.Get(GenJnlBatch."Journal Template Name");
        GenJnlTemplate.TestField("Page ID");
        GenJnlBatch.TestField(Name);

        GenJnlLine.FilterGroup := 2;
        GenJnlLine.SetRange("Journal Template Name",GenJnlTemplate.Name);
        GenJnlLine.FilterGroup := 0;

        GenJnlLine."Journal Template Name" := '';
        GenJnlLine."Journal Batch Name" := GenJnlBatch.Name;
        Page.Run(GenJnlTemplate."Page ID",GenJnlLine);
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10];var GenJnlLine: Record "Gen. Journal Line")
    begin
        CheckTemplateName(GenJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
        GenJnlLine.FilterGroup := 2;
        GenJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        GenJnlLine.FilterGroup := 0;
    end;


    procedure OpenJnlBatch(var GenJnlBatch: Record "Gen. Journal Batch")
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlLine: Record "Gen. Journal Line";
        JnlSelected: Boolean;
    begin
        if GenJnlBatch.GetFilter("Journal Template Name") <> '' then
          exit;
        GenJnlBatch.FilterGroup(2);
        if GenJnlBatch.GetFilter("Journal Template Name") <> '' then begin
          GenJnlBatch.FilterGroup(0);
          exit;
        end;
        GenJnlBatch.FilterGroup(0);

        if not GenJnlBatch.Find('-') then
          for GenJnlTemplate.Type := GenJnlTemplate.Type::General to GenJnlTemplate.Type::Jobs do begin
            GenJnlTemplate.SetRange(Type,GenJnlTemplate.Type);
            if not GenJnlTemplate.FindFirst then
              TemplateSelection(0,GenJnlTemplate.Type,false,GenJnlLine,JnlSelected);
            if GenJnlTemplate.FindFirst then
              CheckTemplateName(GenJnlTemplate.Name,GenJnlBatch.Name);
            if GenJnlTemplate.Type = GenJnlTemplate.Type::General then begin
              GenJnlTemplate.SetRange(Recurring,true);
              if not GenJnlTemplate.FindFirst then
                TemplateSelection(0,GenJnlTemplate.Type,true,GenJnlLine,JnlSelected);
              if GenJnlTemplate.FindFirst then
                CheckTemplateName(GenJnlTemplate.Name,GenJnlBatch.Name);
              GenJnlTemplate.SetRange(Recurring);
            end;
          end;

        GenJnlBatch.Find('-');
        JnlSelected := true;
        GenJnlBatch.CalcFields("Template Type",Recurring);
        GenJnlTemplate.SetRange(Recurring,GenJnlBatch.Recurring);
        if not GenJnlBatch.Recurring then
          GenJnlTemplate.SetRange(Type,GenJnlBatch."Template Type");
        if GenJnlBatch.GetFilter("Journal Template Name") <> '' then
          GenJnlTemplate.SetRange(Name,GenJnlBatch.GetFilter("Journal Template Name"));
        case GenJnlTemplate.Count of
          1:
            GenJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,GenJnlTemplate) = Action::LookupOK;
        end;
        if not JnlSelected then
          Error('');

        GenJnlBatch.FilterGroup(0);
        GenJnlBatch.SetRange("Journal Template Name",GenJnlTemplate.Name);
        GenJnlBatch.FilterGroup(2);
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10];var CurrentJnlBatchName: Code[10])
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlBatch.SetRange("Journal Template Name",CurrentJnlTemplateName);
        if not GenJnlBatch.Get(CurrentJnlTemplateName,CurrentJnlBatchName) then begin
          if not GenJnlBatch.FindFirst then begin
            GenJnlBatch.Init;
            GenJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
            GenJnlBatch.SetupNewBatch;
            GenJnlBatch.Name := Text004;
            GenJnlBatch.Description := Text005;
            GenJnlBatch.Insert(true);
            Commit;
          end;
          CurrentJnlBatchName := GenJnlBatch.Name
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10];var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        GenJnlBatch.Get(GenJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10];var GenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine.FilterGroup := 2;
        GenJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        GenJnlLine.FilterGroup := 0;
        if GenJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10];var GenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlBatch: Record "Gen. Journal Batch";
    begin
        Commit;
        GenJnlBatch."Journal Template Name" := GenJnlLine.GetRangemax("Journal Template Name");
        GenJnlBatch.Name := GenJnlLine.GetRangemax("Journal Batch Name");
        GenJnlBatch.FilterGroup(2);
        GenJnlBatch.SetRange("Journal Template Name",GenJnlBatch."Journal Template Name");
        GenJnlBatch.FilterGroup(0);
        if Page.RunModal(0,GenJnlBatch) = Action::LookupOK then begin
          CurrentJnlBatchName := GenJnlBatch.Name;
          SetName(CurrentJnlBatchName,GenJnlLine);
        end;
    end;


    procedure GetAccounts(var GenJnlLine: Record "Gen. Journal Line";var AccName: Text[50];var BalAccName: Text[50])
    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        IC: Record "IC Partner";
    begin
        if (GenJnlLine."Account Type" <> LastGenJnlLine."Account Type") or
           (GenJnlLine."Account No." <> LastGenJnlLine."Account No.")
        then begin
          AccName := '';
          if GenJnlLine."Account No." <> '' then
            case GenJnlLine."Account Type" of
              GenJnlLine."account type"::"G/L Account":
                if GLAcc.Get(GenJnlLine."Account No.") then
                  AccName := GLAcc.Name;
              GenJnlLine."account type"::Customer:
                if Cust.Get(GenJnlLine."Account No.") then
                  AccName := Cust.Name;
              GenJnlLine."account type"::Vendor:
                if Vend.Get(GenJnlLine."Account No.") then
                  AccName := Vend.Name;
              GenJnlLine."account type"::"Bank Account":
                if BankAcc.Get(GenJnlLine."Account No.") then
                  AccName := BankAcc.Name;
              GenJnlLine."account type"::"Fixed Asset":
                if FA.Get(GenJnlLine."Account No.") then
                  AccName := FA.Description;
              GenJnlLine."account type"::"IC Partner":
                if IC.Get(GenJnlLine."Account No.") then
                  AccName := IC.Name;
            end;
        end;

        if (GenJnlLine."Bal. Account Type" <> LastGenJnlLine."Bal. Account Type") or
           (GenJnlLine."Bal. Account No." <> LastGenJnlLine."Bal. Account No.")
        then begin
          BalAccName := '';
          if GenJnlLine."Bal. Account No." <> '' then
            case GenJnlLine."Bal. Account Type" of
              GenJnlLine."bal. account type"::"G/L Account":
                if GLAcc.Get(GenJnlLine."Bal. Account No.") then
                  BalAccName := GLAcc.Name;
              GenJnlLine."bal. account type"::Customer:
                if Cust.Get(GenJnlLine."Bal. Account No.") then
                  BalAccName := Cust.Name;
              GenJnlLine."bal. account type"::Vendor:
                if Vend.Get(GenJnlLine."Bal. Account No.") then
                  BalAccName := Vend.Name;
              GenJnlLine."bal. account type"::"Bank Account":
                if BankAcc.Get(GenJnlLine."Bal. Account No.") then
                  BalAccName := BankAcc.Name;
              GenJnlLine."bal. account type"::"Fixed Asset":
                if FA.Get(GenJnlLine."Bal. Account No.") then
                  BalAccName := FA.Description;
              GenJnlLine."bal. account type"::"IC Partner":
                if IC.Get(GenJnlLine."Bal. Account No.") then
                  BalAccName := IC.Name;
            end;
        end;

        LastGenJnlLine := GenJnlLine;
    end;


    procedure CalcBalance(var GenJnlLine: Record "Gen. Journal Line";LastGenJnlLine: Record "Gen. Journal Line";var Balance: Decimal;var TotalBalance: Decimal;var ShowBalance: Boolean;var ShowTotalBalance: Boolean)
    var
        TempGenJnlLine: Record "Gen. Journal Line";
    begin
        TempGenJnlLine.CopyFilters(GenJnlLine);
        ShowTotalBalance := TempGenJnlLine.CalcSums("Balance (LCY)");
        if ShowTotalBalance then begin
          TotalBalance := TempGenJnlLine."Balance (LCY)";
          if GenJnlLine."Line No." = 0 then
            TotalBalance := TotalBalance + LastGenJnlLine."Balance (LCY)";
        end;

        if GenJnlLine."Line No." <> 0 then begin
          TempGenJnlLine.SetRange("Line No.",0,GenJnlLine."Line No.");
          ShowBalance := TempGenJnlLine.CalcSums("Balance (LCY)");
          if ShowBalance then
            Balance := TempGenJnlLine."Balance (LCY)";
        end else begin
          TempGenJnlLine.SetRange("Line No.",0,LastGenJnlLine."Line No.");
          ShowBalance := TempGenJnlLine.CalcSums("Balance (LCY)");
          if ShowBalance then begin
            Balance := TempGenJnlLine."Balance (LCY)";
            TempGenJnlLine.CopyFilters(GenJnlLine);
            TempGenJnlLine := LastGenJnlLine;
            if TempGenJnlLine.Next = 0 then
              Balance := Balance + LastGenJnlLine."Balance (LCY)";
          end;
        end;
    end;
}

