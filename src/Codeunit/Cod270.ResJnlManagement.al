#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 270 ResJnlManagement
{
    Permissions = TableData "Res. Journal Template"=imd,
                  TableData "Res. Journal Batch"=imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'RESOURCES';
        Text001: label 'Resource Journals';
        Text002: label 'RECURRING';
        Text003: label 'Recurring Resource Journal';
        Text004: label 'DEFAULT';
        Text005: label 'Default Journal';
        OldResNo: Code[20];
        OpenFromBatch: Boolean;


    procedure TemplateSelection(PageID: Integer;RecurringJnl: Boolean;var ResJnlLine: Record "Res. Journal Line";var JnlSelected: Boolean)
    var
        ResJnlTemplate: Record "Res. Journal Template";
    begin
        JnlSelected := true;

        ResJnlTemplate.Reset;
        ResJnlTemplate.SetRange("Page ID",PageID);
        ResJnlTemplate.SetRange(Recurring,RecurringJnl);

        case ResJnlTemplate.Count of
          0:
            begin
              ResJnlTemplate.Init;
              ResJnlTemplate.Recurring := RecurringJnl;
              if not RecurringJnl then begin
                ResJnlTemplate.Name := Text000;
                ResJnlTemplate.Description := Text001;
              end else begin
                ResJnlTemplate.Name := Text002;
                ResJnlTemplate.Description := Text003;
              end;
              ResJnlTemplate.Validate("Page ID");
              ResJnlTemplate.Insert;
              Commit;
            end;
          1:
            ResJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,ResJnlTemplate) = Action::LookupOK;
        end;
        if JnlSelected then begin
          ResJnlLine.FilterGroup := 2;
          ResJnlLine.SetRange("Journal Template Name",ResJnlTemplate.Name);
          ResJnlLine.FilterGroup := 0;
          if OpenFromBatch then begin
            ResJnlLine."Journal Template Name" := '';
            Page.Run(ResJnlTemplate."Page ID",ResJnlLine);
          end;
        end;
    end;


    procedure TemplateSelectionFromBatch(var ResJnlBatch: Record "Res. Journal Batch")
    var
        ResJnlLine: Record "Res. Journal Line";
        ResJnlTemplate: Record "Res. Journal Template";
    begin
        OpenFromBatch := true;
        ResJnlTemplate.Get(ResJnlBatch."Journal Template Name");
        ResJnlTemplate.TestField("Page ID");
        ResJnlBatch.TestField(Name);

        ResJnlLine.FilterGroup := 2;
        ResJnlLine.SetRange("Journal Template Name",ResJnlTemplate.Name);
        ResJnlLine.FilterGroup := 0;

        ResJnlLine."Journal Template Name" := '';
        ResJnlLine."Journal Batch Name" := ResJnlBatch.Name;
        Page.Run(ResJnlTemplate."Page ID",ResJnlLine);
    end;


    procedure OpenJnl(var CurrentJnlBatchName: Code[10];var ResJnlLine: Record "Res. Journal Line")
    begin
        CheckTemplateName(ResJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
        ResJnlLine.FilterGroup := 2;
        ResJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        ResJnlLine.FilterGroup := 0;
    end;


    procedure OpenJnlBatch(var ResJnlBatch: Record "Res. Journal Batch")
    var
        ResJnlTemplate: Record "Res. Journal Template";
        ResJnlLine: Record "Res. Journal Line";
        JnlSelected: Boolean;
    begin
        if ResJnlBatch.GetFilter("Journal Template Name") <> '' then
          exit;
        ResJnlBatch.FilterGroup(2);
        if ResJnlBatch.GetFilter("Journal Template Name") <> '' then begin
          ResJnlBatch.FilterGroup(0);
          exit;
        end;
        ResJnlBatch.FilterGroup(0);

        if not ResJnlBatch.Find('-') then begin
          if not ResJnlTemplate.FindFirst then
            TemplateSelection(0,false,ResJnlLine,JnlSelected);
          if ResJnlTemplate.FindFirst then
            CheckTemplateName(ResJnlTemplate.Name,ResJnlBatch.Name);
          ResJnlTemplate.SetRange(Recurring,true);
          if not ResJnlTemplate.FindFirst then
            TemplateSelection(0,true,ResJnlLine,JnlSelected);
          if ResJnlTemplate.FindFirst then
            CheckTemplateName(ResJnlTemplate.Name,ResJnlBatch.Name);
          ResJnlTemplate.SetRange(Recurring);
        end;
        ResJnlBatch.Find('-');
        JnlSelected := true;
        ResJnlBatch.CalcFields(Recurring);
        ResJnlTemplate.SetRange(Recurring,ResJnlBatch.Recurring);
        if ResJnlBatch.GetFilter("Journal Template Name") <> '' then
          ResJnlTemplate.SetRange(Name,ResJnlBatch.GetFilter("Journal Template Name"));
        case ResJnlTemplate.Count of
          1:
            ResJnlTemplate.FindFirst;
          else
            JnlSelected := Page.RunModal(0,ResJnlTemplate) = Action::LookupOK;
        end;
        if not JnlSelected then
          Error('');

        ResJnlBatch.FilterGroup(2);
        ResJnlBatch.SetRange("Journal Template Name",ResJnlTemplate.Name);
        ResJnlBatch.FilterGroup(0);
    end;

    local procedure CheckTemplateName(CurrentJnlTemplateName: Code[10];var CurrentJnlBatchName: Code[10])
    var
        ResJnlBatch: Record "Res. Journal Batch";
    begin
        ResJnlBatch.SetRange("Journal Template Name",CurrentJnlTemplateName);
        if not ResJnlBatch.Get(CurrentJnlTemplateName,CurrentJnlBatchName) then begin
          if not ResJnlBatch.FindFirst then begin
            ResJnlBatch.Init;
            ResJnlBatch."Journal Template Name" := CurrentJnlTemplateName;
            ResJnlBatch.SetupNewBatch;
            ResJnlBatch.Name := Text004;
            ResJnlBatch.Description := Text005;
            ResJnlBatch.Insert(true);
            Commit;
          end;
          CurrentJnlBatchName := ResJnlBatch.Name;
        end;
    end;


    procedure CheckName(CurrentJnlBatchName: Code[10];var ResJnlLine: Record "Res. Journal Line")
    var
        ResJnlBatch: Record "Res. Journal Batch";
    begin
        ResJnlBatch.Get(ResJnlLine.GetRangemax("Journal Template Name"),CurrentJnlBatchName);
    end;


    procedure SetName(CurrentJnlBatchName: Code[10];var ResJnlLine: Record "Res. Journal Line")
    begin
        ResJnlLine.FilterGroup := 2;
        ResJnlLine.SetRange("Journal Batch Name",CurrentJnlBatchName);
        ResJnlLine.FilterGroup := 0;
        if ResJnlLine.Find('-') then;
    end;


    procedure LookupName(var CurrentJnlBatchName: Code[10];var ResJnlLine: Record "Res. Journal Line")
    var
        ResJnlBatch: Record "Res. Journal Batch";
    begin
        Commit;
        ResJnlBatch."Journal Template Name" := ResJnlLine.GetRangemax("Journal Template Name");
        ResJnlBatch.Name := ResJnlLine.GetRangemax("Journal Batch Name");
        ResJnlBatch.FilterGroup(2);
        ResJnlBatch.SetRange("Journal Template Name",ResJnlBatch."Journal Template Name");
        ResJnlBatch.FilterGroup(0);
        if Page.RunModal(0,ResJnlBatch) = Action::LookupOK then begin
          CurrentJnlBatchName := ResJnlBatch.Name;
          SetName(CurrentJnlBatchName,ResJnlLine);
        end;
    end;


    procedure GetRes(ResNo: Code[20];var ResName: Text[50])
    var
        Res: Record Resource;
    begin
        if ResNo <> OldResNo then begin
          ResName := '';
          if ResNo <> '' then
            if Res.Get(ResNo) then
              ResName := Res.Name;
          OldResNo := ResNo;
        end;
    end;
}

