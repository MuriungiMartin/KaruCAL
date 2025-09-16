#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1638 "Office Jobs Handler"
{
    TableNo = "Office Add-in Context";

    trigger OnRun()
    begin
        RedirectOfficeJobJournal(Rec);
    end;

    var
        JobsRegExTxt: label '([^:]+):([^:]+):([0-9]+)', Locked=true;
        UnableToFindJobErr: label 'Cannot find job number %1, job task number %2, line number %3.', Comment='%1 = Job No; %2 = Job Task No; %3 = Job Planning Line';


    procedure IsJobsHostType(OfficeAddinContext: Record "Office Add-in Context") IsJob: Boolean
    var
        RegEx: dotnet Regex;
        Match: dotnet Match;
    begin
        if OfficeAddinContext.IsAppointment and (OfficeAddinContext.Subject <> '') then begin
          Match := RegEx.Match(OfficeAddinContext.Subject,JobsRegExTxt);
          IsJob := Match.Success;
        end;
    end;


    procedure GetJobProperties(OfficeAddinContext: Record "Office Add-in Context";var JobNo: Text;var JobTaskNo: Text;var JobPlanningLineNo: Integer)
    var
        RegEx: dotnet Regex;
        Match: dotnet Match;
    begin
        Match := RegEx.Match(OfficeAddinContext.Subject,JobsRegExTxt);

        if Match.Success then begin
          JobNo := Match.Groups.Item(1).Value;
          JobTaskNo := Match.Groups.Item(2).Value;
          Evaluate(JobPlanningLineNo,Match.Groups.Item(3).Value);
        end;
    end;


    procedure SubmitJobPlanningLine(JobPlanningLine: Record "Job Planning Line";JobJournalTemplateName: Code[10];JobJournalBatchName: Code[10])
    var
        JobJournalLine: Record "Job Journal Line";
        TempOfficeJobJournal: Record "Office Job Journal" temporary;
        JobTransferLine: Codeunit "Job Transfer Line";
    begin
        SetJobJournalRange(JobJournalLine,JobPlanningLine);

        JobTransferLine.FromPlanningLineToJnlLine(
          JobPlanningLine,JobPlanningLine."Planning Date",JobJournalTemplateName,JobJournalBatchName,JobJournalLine);

        JobPlanningLine.Find;
        TempOfficeJobJournal.Initialize(JobPlanningLine);
        Page.Run(Page::"Office Job Journal",TempOfficeJobJournal);
    end;


    procedure SetJobJournalRange(var JobJournalLine: Record "Job Journal Line";JobPlanningLine: Record "Job Planning Line")
    begin
        JobJournalLine.SetRange("Job No.",JobPlanningLine."Job No.");
        JobJournalLine.SetRange("Job Task No.",JobPlanningLine."Job Task No.");
        JobJournalLine.SetRange("Job Planning Line No.",JobPlanningLine."Line No.");
    end;

    local procedure RedirectOfficeJobJournal(OfficeAddinContext: Record "Office Add-in Context")
    var
        TempOfficeJobJournal: Record "Office Job Journal" temporary;
        JobPlanningLine: Record "Job Planning Line";
        OfficeErrorEngine: Codeunit "Office Error Engine";
        JobNo: Text;
        JobTaskNo: Text;
        JobPlanningLineNo: Integer;
    begin
        GetJobProperties(OfficeAddinContext,JobNo,JobTaskNo,JobPlanningLineNo);

        if JobPlanningLine.Get(JobNo,JobTaskNo,JobPlanningLineNo) then begin
          TempOfficeJobJournal.Initialize(JobPlanningLine);
          Page.Run(Page::"Office Job Journal",TempOfficeJobJournal);
        end else
          OfficeErrorEngine.ShowError(StrSubstNo(UnableToFindJobErr,JobNo,JobTaskNo,JobPlanningLineNo));
    end;
}

