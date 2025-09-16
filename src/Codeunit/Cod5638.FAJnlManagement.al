#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5638 FAJnlManagement
{
    Permissions = TableData "FA Journal Template"=imd,
                  TableData "FA Journal Batch"=imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'ASSETS';
        Text001: label 'Fixed Asset Journal';
        Text002: label 'Recurring';
        Text003: label 'Recurring Fixed Asset Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';
        OldFANo: Code[20];
        OpenFromBatch: Boolean;


    procedure TemplateSelection(PageID: Integer;RecurringJnl: Boolean;var FAJnlLine: Record "FA Journal Line";var JnlSelected: Boolean)
    var
        FAJnlTemplate: Record "FA Journal Template";
    begin
        JnlSelected := true;

        FAJnlTemplate.Reset;
        if not OpenFromBatch then
          FAJnlTemplate.SetRange("Page ID",PageID);
        FAJnlTemplate.SetRange(Recurring,RecurringJnl);

        case FAJnlTemplate.Count of
          0:
            begin
              FAJnlTemplate.Init;
              FAJnlTemplate.Recurring := RecurringJnl;
              if not RecurringJnl then begin
                FAJnlTemplate.Name := Text000;
                FAJnlTemplate.Description := Text001;
              end else begin
                FAJnlTemplate.Name := Text002;
                FAJnlTemplate.Description := Text003;
              end;
              FAJnlTemplate.Validate("Page ID");
              FAJnlTemplate.Insert;
              Commit;
            end;
          1:
            FAJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,FAJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
          FAJnlLine.FilterGroup := 2;
          FAJnlLine.SetRange("Journal Template Name",FAJnlTemplate.Name);
          FAJnlLine.FilterGroup := 0;
          if OpenFromBatch then begin
            FAJnlLine."Journal Template Name" := '';
            Page.Run(FAJnlTemplate."Page ID",FAJnlLine);
          end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var FAJnlBatch: Record "FA Journal Batch")
    var
        FAJnlLine: Record "FA Journal Line";
        FAJnlTemplate: Record "FA Journal Template";
    begin
        OpenFromBatch := true;
        FAJnlTemplate.Get(FAJnlBatch."Journal Template Name");
        FAJnlTemplate.TestField("Page ID");
        FAJnlBatch.TestField(Name);

        FAJnlLine.FilterGroup := 2;
        FAJnlLine.SetRange("Journal Template Name",FAJnlTemplate.Name);
        FAJnlLine.FilterGroup := 0;

        FAJnlLine."Journal Template Name" := '';
        FAJnlLine."Journal Batch Name" := FAJnlBatch.Name;
        Page.Run(FAJnlTemplate."Page ID",FAJnlLine);
    end;


    procedure OpenJournal(var CurrentJnlBatchName: Code[10];var FAJnlLine: Record "FA Journal Line")
    begin
        CheckTemplateName(FAJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
        FAJnlLine.FilterGroup := 2;
        FAJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        FAJnlLine.FilterGroup := 0;
    end;


    procedure OpenJnlBatch(var FAJnlBatch: Record "FA Journal Batch")
    var
        FAJnlTemplate: Record "FA Journal Template";
        FAJnlLine: Record "FA Journal Line";
        JnlSelected: Boolean;
    begin
        if FAJnlBatch.GetFilter("Journal Template Name") <> '' then
          exit;
        FAJnlBatch.FilterGroup(2);
        if FAJnlBatch.GetFilter("Journal Template Name") <> '' then begin
          FAJnlBatch.FilterGroup(0);
          exit;
        end;
        FAJnlBatch.FilterGroup(0);

        if not FAJnlBatch.Find('-') then begin
          if not FAJnlTemplate.FindFirst then
            TemplateSelection(0,false,FAJnlLine,JnlSelected);
          if FAJnlTemplate.FindFirst then
            CheckTemplateName(FAJnlTemplate.Name,FAJnlBatch.Name);
          FAJnlTemplate.SetRange(Recurring,true);
          if not FAJnlTemplate.FindFirst then
            TemplateSelection(0,true,FAJnlLine,JnlSelected);
          if FAJnlTemplate.FindFirst then
            CheckTemplateName(FAJnlTemplate.Name,FAJnlBatch.Name);
          FAJnlTemplate.SetRange(Recurring);
        end;
        FAJnlBatch.Find('-');
        JnlSelected := true;
        FAJnlBatch.CalcFields(Recurring);
        FAJnlTemplate.SetRange(Recurring,FAJnlBatch.Recurring);
        if FAJnlBatch.GetFilter("Journal Template Name") <> '' then
          FAJnlTemplate.SetRange(Name,FAJnlBatch.GetFilter("Journal Template Name"));
        case FAJnlTemplate.Count of
          1:
            FAJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,FAJnlTemplate) = Action::LookupOK;
        end;
        if not JnlSelected then
          Error('');

        FAJnlBatch.FilterGroup(2);
        FAJnlBatch.SetRange("Journal Template Name",FAJnlTemplate.Name);
        FAJnlBatch.FilterGroup(0);
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10];var FAJnlLine: Record "FA Journal Line")
    var
        FAJnlBatch: Record "FA Journal Batch";
    begin
        FAJnlBatch.Get(FAJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10];var FAJnlLine: Record "FA Journal Line")
    begin
        FAJnlLine.FilterGroup := 2;
        FAJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        FAJnlLine.FilterGroup := 0;
        if FAJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10];var FAJnlLine: Record "FA Journal Line")
    var
        FAJnlBatch: Record "FA Journal Batch";
    begin
        Commit;
        FAJnlBatch."Journal Template Name" := FAJnlLine.GetRangemax("Journal Template Name");
        FAJnlBatch.Name := FAJnlLine.GetRangemax("Journal Batch Name");
        FAJnlBatch.FilterGroup(2);
        FAJnlBatch.SetRange("Journal Template Name",FAJnlBatch."Journal Template Name");
        FAJnlBatch.FilterGroup(0);
        if Page.RunModal(0,FAJnlBatch) = Action::LookupOK then begin
          CurrentJnlBatchName := FAJnlBatch.Name;
          SetName(CurrentJnlBatchName,FAJnlLine);
        end;
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10];var CurrentJnlBatchName: Code[10])
    var
        FAJnlBatch: Record "FA Journal Batch";
    begin
        if not FAJnlBatch.Get(CurrentJnlTemplateName,CurrentJnlBatchName) then begin
          FAJnlBatch.SetRange("Journal Template Name",CurrentJnlTemplateName);
          if not FAJnlBatch.FindFirst then begin
            FAJnlBatch.Init;
            FAJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
            FAJnlBatch.SetupNewBatch;
            FAJnlBatch.Name := Text004;
            FAJnlBatch.Description := Text005;
            FAJnlBatch.Insert(true);
            Commit;
          end;
          CurrentJnlBatchName := FAJnlBatch.Name;
        end;
    end;


    procedure GetFA(FANo: Code[20];var FADescription: Text[50])
    var
        FA: Record "Fixed Asset";
    begin
        if FANo <> OldFANo then begin
          FADescription := '';
          if FANo <> '' then
            if FA.Get(FANo) then
              FADescription := FA.Description;
          OldFANo := FANo;
        end;
    end;
}

