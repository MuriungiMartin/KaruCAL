#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5646 FAReclassJnlManagement
{
    Permissions = TableData "FA Reclass. Journal Template"=imd,
                  TableData "FA Reclass. Journal Batch"=imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'RECLASSIFY';
        Text001: label 'FA Reclass. Journal';
        Text002: label 'DEFAULT';
        Text003: label 'Default Journal';
        OldFANo: Code[20];
        OldFANo2: Code[20];
        OpenFromBatch: Boolean;


    procedure TemplateSelection(PageID: Integer;var FAReclassJnlLine: Record "FA Reclass. Journal Line";var JnlSelected: Boolean)
    var
        FAReclassJnlTempl: Record "FA Reclass. Journal Template";
    begin
        JnlSelected := true;

        FAReclassJnlTempl.Reset;
        FAReclassJnlTempl.SetRange("Page ID",PageID);

        case FAReclassJnlTempl.Count of
          0:
            begin
              FAReclassJnlTempl.Init;
              FAReclassJnlTempl.Name := Text000;
              FAReclassJnlTempl.Description := Text001;
              FAReclassJnlTempl.Validate("Page ID");
              FAReclassJnlTempl.Insert;
              Commit;
            end;
          1:
            FAReclassJnlTempl.FindFirst;
          else
            JnlSelected := Page.RunModal(0,FAReclassJnlTempl) = Action::LookupOK;
        end;
        if JnlSelected then begin
          FAReclassJnlLine.FilterGroup := 2;
          FAReclassJnlLine.SetRange("Journal Template Name",FAReclassJnlTempl.Name);
          FAReclassJnlLine.FilterGroup := 0;
          if OpenFromBatch then begin
            FAReclassJnlLine."Journal Template Name" := '';
            Page.Run(FAReclassJnlTempl."Page ID",FAReclassJnlLine);
          end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var FAReclassJnlBatch: Record "FA Reclass. Journal Batch")
    var
        FAReclassJnlLine: Record "FA Reclass. Journal Line";
        FAReclassJnlTempl: Record "FA Reclass. Journal Template";
    begin
        OpenFromBatch := true;
        FAReclassJnlTempl.Get(FAReclassJnlBatch."Journal Template Name");
        FAReclassJnlTempl.TestField("Page ID");
        FAReclassJnlBatch.TestField(Name);

        FAReclassJnlLine.FilterGroup := 2;
        FAReclassJnlLine.SetRange("Journal Template Name",FAReclassJnlTempl.Name);
        FAReclassJnlLine.FilterGroup := 0;

        FAReclassJnlLine."Journal Template Name" := '';
        FAReclassJnlLine."Journal Batch Name" := FAReclassJnlBatch.Name;
        Page.Run(FAReclassJnlTempl."Page ID",FAReclassJnlLine);
    end;


    procedure OpenJournal(var CurrentJnlBatchName: Code[10];var FAReclassJnlLine: Record "FA Reclass. Journal Line")
    begin
        CheckTemplateName(FAReclassJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
        FAReclassJnlLine.FilterGroup := 2;
        FAReclassJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        FAReclassJnlLine.FilterGroup := 0;
    end;


    procedure OpenJnlBatch(var FAReclassJnlBatch: Record "FA Reclass. Journal Batch")
    var
        FAReclassJnlTemplate: Record "FA Reclass. Journal Template";
        FAReclassJnlLine: Record "FA Reclass. Journal Line";
        JnlSelected: Boolean;
    begin
        if FAReclassJnlBatch.GetFilter("Journal Template Name") <> '' then
          exit;
        FAReclassJnlBatch.FilterGroup(2);
        if FAReclassJnlBatch.GetFilter("Journal Template Name") <> '' then begin
          FAReclassJnlBatch.FilterGroup(0);
          exit;
        end;
        FAReclassJnlBatch.FilterGroup(0);

        if not FAReclassJnlBatch.Find('-') then begin
          if not FAReclassJnlTemplate.FindFirst then
            TemplateSelection(0,FAReclassJnlLine,JnlSelected);
          if FAReclassJnlTemplate.FindFirst then
            CheckTemplateName(FAReclassJnlTemplate.Name,FAReclassJnlBatch.Name);
        end;
        FAReclassJnlBatch.Find('-');
        JnlSelected := true;
        if FAReclassJnlBatch.GetFilter("Journal Template Name") <> '' then
          FAReclassJnlTemplate.SetRange(Name,FAReclassJnlBatch.GetFilter("Journal Template Name"));
        case FAReclassJnlTemplate.Count of
          1:
            FAReclassJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,FAReclassJnlTemplate) = Action::LookupOK;
        end;
        if not JnlSelected then
          Error('');

        FAReclassJnlBatch.FilterGroup(2);
        FAReclassJnlBatch.SetRange("Journal Template Name",FAReclassJnlTemplate.Name);
        FAReclassJnlBatch.FilterGroup(0);
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10];var FAReclassJnlLine: Record "FA Reclass. Journal Line")
    var
        FAReclassJnlBatch: Record "FA Reclass. Journal Batch";
    begin
        FAReclassJnlBatch.Get(FAReclassJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10];var CurrentJnlBatchName: Code[10])
    var
        FAReclassJnlBatch: Record "FA Reclass. Journal Batch";
    begin
        FAReclassJnlBatch.SetRange("Journal Template Name",CurrentJnlTemplateName);
        if not FAReclassJnlBatch.Get(CurrentJnlTemplateName,CurrentJnlBatchName) then begin
          if not FAReclassJnlBatch.FindFirst then begin
            FAReclassJnlBatch.Init;
            FAReclassJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
            FAReclassJnlBatch.Name := Text002;
            FAReclassJnlBatch.Insert(true);
            FAReclassJnlBatch.Description := Text003;
            FAReclassJnlBatch.Modify;
            Commit;
          end;
          CurrentJnlBatchName := FAReclassJnlBatch.Name;
        end;
    end;


    procedure SetName(CurrentJnlBatchName: Code[10];var FAReclassJnlLine: Record "FA Reclass. Journal Line")
    begin
        FAReclassJnlLine.FilterGroup := 2;
        FAReclassJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        FAReclassJnlLine.FilterGroup := 0;
        if FAReclassJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10];var FAReclassJnlLine: Record "FA Reclass. Journal Line")
    var
        FAReclassJnlBatch: Record "FA Reclass. Journal Batch";
    begin
        Commit;
        FAReclassJnlBatch."Journal Template Name" := FAReclassJnlLine.GetRangemax("Journal Template Name");
        FAReclassJnlBatch.Name := FAReclassJnlLine.GetRangemax("Journal Batch Name");
        FAReclassJnlBatch.FilterGroup(2);
        FAReclassJnlBatch.SetRange("Journal Template Name",FAReclassJnlBatch."Journal Template Name");
        FAReclassJnlBatch.FilterGroup(0);
        if Page.RunModal(0,FAReclassJnlBatch) = Action::LookupOK then begin
          CurrentJnlBatchName := FAReclassJnlBatch.Name;
          SetName(CurrentJnlBatchName,FAReclassJnlLine);
        end;
    end;


    procedure GetFAS(FAReclassJnlLine: Record "FA Reclass. Journal Line";var FADescription: Text[50];var FADescription2: Text[50])
    var
        FA: Record "Fixed Asset";
    begin
        if FAReclassJnlLine."FA No." <> OldFANo then begin
          FADescription := '';
          if FAReclassJnlLine."FA No." <> '' then
            if FA.Get(FAReclassJnlLine."FA No.") then
              FADescription := FA.Description;
          OldFANo := FAReclassJnlLine."FA No.";
        end;
        if FAReclassJnlLine."New FA No." <> OldFANo2 then begin
          FADescription2 := '';
          if FAReclassJnlLine."New FA No." <> '' then
            if FA.Get(FAReclassJnlLine."New FA No.") then
              FADescription2 := FA.Description;
          OldFANo2 := FAReclassJnlLine."New FA No.";
        end;
    end;
}

