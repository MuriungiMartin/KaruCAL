#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9990 "Code Coverage Mgt."
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        [WithEvents]
        Timer: dotnet Timer;
        BackupErr: label 'Code Coverage Backup encountered an error: %1.';
        FormatStringTxt: label '<Day,2>_<Month,2>_<Year>_<Hours24,2>_<Minutes,2>.';
        BackupFilePath: Text[1024];
        SummaryFilePath: Text[1024];
        BackupPathFormatTxt: label 'CodeCoverageBackup_%1.txt';
        SummaryPathFormatTxt: label 'CodeCoverageSummary_%1.xml';
        StartCoverageCleanupQst: label 'The Code Coverage Result Set contains lines that correspond to %1 objects, of which %2 are marked as modified. If you continue, code coverage lines that correspond to %3 objects will be deleted.\\This action cannot be undone.\\Are you sure that you want to continue?', Comment='%1 = Total number of objects; %2 = Number of modified objects.';
        AllAreModifiedMsg: label 'All objects that correspond to the code coverage line result set are marked as modified.\There are no lines to remove.';
        NoneAreModifiedMsg: label 'None of the objects that correspond to the lines in the code coverage result set are marked as modified in Object Designer. No lines will be removed. You must mark the objects that correspond to the lines that you want to keep in the code coverage result set.';
        ApplicationBaseline: Integer;
        IsRunning: Boolean;
        CodeCovNotRunningErr: label 'Code coverage is not running.';
        CodeCovAlreadyRunningErr: label 'Code coverage is already running.';
        StartedByApp: Boolean;
        CannotNestAppCovErr: label 'Cannot nest multiple calls to StartApplicationCoverage.';
        MultiSession: Boolean;


    procedure Start(MultiSessionValue: Boolean)
    begin
        MultiSession := MultiSessionValue;
        if IsRunning then
          Error(CodeCovAlreadyRunningErr);
        CodeCoverageLog(true,MultiSession);
        IsRunning := true;
    end;


    procedure Stop()
    begin
        if not IsRunning then
          Error(CodeCovNotRunningErr);
        CodeCoverageLog(false,MultiSession);
        IsRunning := false;
    end;


    procedure Refresh()
    begin
        CodeCoverageRefresh;
    end;


    procedure Clear()
    var
        CodeCoverage: Record "Code Coverage";
    begin
        CodeCoverage.DeleteAll;
    end;


    procedure Import()
    begin
        CodeCoverageLoad;
    end;


    procedure Include(var "Object": Record "Object")
    begin
        CodeCoverageInclude(Object);
    end;


    procedure Running(): Boolean
    begin
        exit(IsRunning);
    end;


    procedure StartApplicationCoverage()
    begin
        if IsRunning and StartedByApp then
          Error(CannotNestAppCovErr);

        if not IsRunning then begin
          StartedByApp := true;
          Start(false);
        end;

        // Establish baseline
        ApplicationBaseline := 0;
        ApplicationBaseline := ApplicationHits;
    end;


    procedure StopApplicationCoverage()
    begin
        if StartedByApp then
          Stop;
        StartedByApp := false;
    end;


    procedure ApplicationHits() NoOFLines: Integer
    var
        CodeCoverage: Record "Code Coverage";
    begin
        Refresh;
        CodeCoverage.SetRange("Line Type",CodeCoverage."line type"::Code);
        CodeCoverage.SetFilter("No. of Hits",'>%1',0);
        // excluding Code Coverage range 9900..9999 from calculation
        CodeCoverage.SetFilter("Object ID",'..9989|10000..129999|150000..');
        if CodeCoverage.FindSet then
          repeat
            NoOFLines += CodeCoverage."No. of Hits";
          until CodeCoverage.Next = 0;

        // Subtract baseline to produce delta
        NoOFLines -= ApplicationBaseline;
    end;


    procedure CoveragePercent(NoCodeLines: Integer;NoCodeLinesHit: Integer): Decimal
    begin
        if NoCodeLines > 0 then
          exit(NoCodeLinesHit / NoCodeLines);

        exit(1.0)
    end;


    procedure ObjectCoverage(var CodeCoverage: Record "Code Coverage";var NoCodeLines: Integer;var NoCodeLinesHit: Integer): Decimal
    var
        CodeCoverage2: Record "Code Coverage";
    begin
        NoCodeLines := 0;
        NoCodeLinesHit := 0;

        CodeCoverage2.SetPosition(CodeCoverage.GetPosition);
        CodeCoverage2.SetRange("Object Type",CodeCoverage."Object Type");
        CodeCoverage2.SetRange("Object ID",CodeCoverage."Object ID");

        repeat
          if CodeCoverage2."Line Type" = CodeCoverage2."line type"::Code then begin
            NoCodeLines += 1;
            if CodeCoverage2."No. of Hits" > 0 then
              NoCodeLinesHit += 1;
          end
        until (CodeCoverage2.Next = 0) or
                (CodeCoverage2."Line Type" = CodeCoverage2."line type"::Object);

        exit(CoveragePercent(NoCodeLines,NoCodeLinesHit))
    end;


    procedure ObjectsCoverage(var CodeCoverage: Record "Code Coverage";var NoCodeLines: Integer;var NoCodeLinesHit: Integer): Decimal
    var
        CodeCoverage2: Record "Code Coverage";
    begin
        NoCodeLines := 0;
        NoCodeLinesHit := 0;

        CodeCoverage2.CopyFilters(CodeCoverage);
        CodeCoverage2.SetFilter("Line Type",'Code');
        repeat
          NoCodeLines += 1;
          if CodeCoverage2."No. of Hits" > 0 then
            NoCodeLinesHit += 1;
        until CodeCoverage2.Next = 0;

        exit(CoveragePercent(NoCodeLines,NoCodeLinesHit))
    end;


    procedure FunctionCoverage(var CodeCoverage: Record "Code Coverage";var NoCodeLines: Integer;var NoCodeLinesHit: Integer): Decimal
    var
        CodeCoverage2: Record "Code Coverage";
    begin
        NoCodeLines := 0;
        NoCodeLinesHit := 0;

        CodeCoverage2.SetPosition(CodeCoverage.GetPosition);
        CodeCoverage2.SetRange("Object Type",CodeCoverage."Object Type");
        CodeCoverage2.SetRange("Object ID",CodeCoverage."Object ID");

        repeat
          if CodeCoverage2."Line Type" = CodeCoverage2."line type"::Code then begin
            NoCodeLines += 1;
            if CodeCoverage2."No. of Hits" > 0 then
              NoCodeLinesHit += 1;
          end
        until (CodeCoverage2.Next = 0) or
                (CodeCoverage2."Line Type" = CodeCoverage2."line type"::Object) or
                (CodeCoverage2."Line Type" = CodeCoverage2."line type"::"Trigger/Function");

        exit(CoveragePercent(NoCodeLines,NoCodeLinesHit))
    end;


    procedure CreateBackupFile(BackupPath: Text)
    var
        BackupStream: OutStream;
        BackupFile: File;
    begin
        Refresh;

        BackupFile.Create(BackupPath);
        BackupFile.CreateOutstream(BackupStream);
        Xmlport.Export(Xmlport::"Code Coverage Detailed",BackupStream);
        BackupFile.Close;
    end;


    procedure CreateSummaryFile(SummaryPath: Text)
    var
        SummaryStream: OutStream;
        SummaryFile: File;
    begin
        Refresh;

        SummaryFile.Create(SummaryPath);
        SummaryFile.CreateOutstream(SummaryStream);
        Xmlport.Export(Xmlport::"Code Coverage Summary",SummaryStream);
        SummaryFile.Close;
    end;


    procedure StartAutomaticBackup(TimeInterval: Integer;BackupPath: Text[1024];SummaryPath: Text[1024])
    var
        "Object": Record "Object";
    begin
        Include(Object); // Load all objects
        Start(false); // Start code coverage

        // Setup Timer and File Paths
        if IsNull(Timer) then
          Timer := Timer.Timer;
        UpdateAutomaticBackupSettings(TimeInterval,BackupPath,SummaryPath);
    end;


    procedure UpdateAutomaticBackupSettings(TimeInterval: Integer;BackupPath: Text[1024];SummaryPath: Text[1024])
    begin
        if not IsNull(Timer) then begin
          Timer.Stop;
          Timer.Interval := TimeInterval * 60000;
          BackupFilePath := BackupPath;
          SummaryFilePath := SummaryPath;
          Timer.Start;
        end;
    end;


    procedure CleanupCodeCoverage()
    var
        TempObject: Record "Object" temporary;
        ModifiedMarkCount: Integer;
    begin
        DetermineModifiedObjects(TempObject,ModifiedMarkCount);
        if not TakeAction(TempObject.Count,ModifiedMarkCount) then
          exit;
        RemoveModifiedObjectLines(TempObject);
    end;

    local procedure DetermineModifiedObjects(var TempObject: Record "Object" temporary;var ModifiedMarkCount: Integer)
    var
        CodeCoverage: Record "Code Coverage";
        Window: Dialog;
        i: Integer;
        N: Integer;
    begin
        TempObject.DeleteAll;
        ModifiedMarkCount := 0;
        if CodeCoverage.FindSet then begin
          Window.Open('Analyzing @1@@@@@@@@@@@@@@@@@@');
          N := CodeCoverage.Count;
          with TempObject do
            repeat
              i += 1;
              if i MOD 100 = 0 then
                Window.Update(1,ROUND(i / N * 10000,1));
              Type := CodeCoverage."Object Type";
              "Company Name" := '';
              ID := CodeCoverage."Object ID";
              if Insert then
                CheckModified(TempObject,ModifiedMarkCount);
            until CodeCoverage.Next = 0;

          Window.Close;
        end;
    end;

    local procedure CheckModified(TempObject: Record "Object" temporary;var ModifiedMarkCount: Integer)
    begin
        if ObjectModified(TempObject) then
          ModifiedMarkCount += 1;
    end;

    local procedure ObjectModified(TempObject: Record "Object"): Boolean
    var
        "Object": Record "Object";
    begin
        if not Object.Get(TempObject.Type,COMPANYNAME,TempObject.ID) then
          Object.Get(TempObject.Type,'',TempObject.ID);
        exit(Object.Modified);
    end;

    local procedure RemoveModifiedObjectLines(var TempObject: Record "Object" temporary)
    var
        CodeCoverage: Record "Code Coverage";
        Window: Dialog;
        i: Integer;
        N: Integer;
    begin
        TempObject.FindSet;
        Window.Open('Deleting @1@@@@@@@@@@@@@@@@@@');
        N := TempObject.Count;
        repeat
          i += 1;
          if i MOD 100 = 0 then
            Window.Update(1,ROUND(i / N * 10000,1));
          if not ObjectModified(TempObject) then begin
            CodeCoverage.SetRange("Object Type",TempObject.Type);
            CodeCoverage.SetRange("Object ID",TempObject.ID);
            CodeCoverage.DeleteAll;
          end;
        until TempObject.Next = 0;
        Window.Close;
    end;

    local procedure TakeAction(ObjCount: Integer;ModifiedMarkCount: Integer): Boolean
    begin
        if ObjCount = 0 then
          exit(false);
        if ModifiedMarkCount = 0 then begin
          Message(NoneAreModifiedMsg);
          exit(false);
        end;
        if ObjCount = ModifiedMarkCount then begin
          Message(AllAreModifiedMsg);
          exit(false);
        end;
        exit(Confirm(StartCoverageCleanupQst,false,ObjCount,ModifiedMarkCount,ObjCount - ModifiedMarkCount));
    end;

    trigger Timer::Elapsed(sender: Variant;e: dotnet EventArgs)
    begin
        CreateBackupFile(BackupFilePath + StrSubstNo(BackupPathFormatTxt,Format(CurrentDatetime,0,FormatStringTxt)));
        CreateSummaryFile(SummaryFilePath + StrSubstNo(SummaryPathFormatTxt,Format(CurrentDatetime,0,FormatStringTxt)));
    end;

    trigger Timer::ExceptionOccurred(sender: Variant;e: dotnet ExceptionOccurredEventArgs)
    begin
        Error(BackupErr,e.Exception.Message);
    end;
}

