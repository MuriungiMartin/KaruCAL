#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 9500 "Debugger Management"
{
    SingleInstance = true;

    trigger OnRun()
    var
        Uri: dotnet Uri;
        UriPartial: dotnet UriPartial;
        UrlString: Text;
    begin
        // Generates a URL like dynamicsnav://host:port/instance//debug<?tenant=tenantId>
        UrlString := GetUrl(Clienttype::Windows);
        Uri := Uri.Uri(UrlString);
        UrlString := Uri.GetLeftPart(UriPartial.Path) + DebuggerUrlTok + Uri.Query;

        Hyperlink(UrlString);
    end;

    var
        ClientAddin: Record "Add-in";
        DebuggedSession: Record "Active Session";
        DebuggerTaskPage: Page Debugger;
        Text000Err: label 'Cannot process debugger break. The debugger is not active.';
        LastErrorMesssageIsNew: Boolean;
        LastErrorMessage: Text;
        CodeViewerControlRegistered: Boolean;
        ActionState: Option "None",RunningCodeAction,CodeTrackingAction,BreakAfterRunningCodeAction,BreakAfterCodeTrackingAction;
        DebuggerUrlTok: label 'debug', Locked=true;
        ClientAddinDescriptionTxt: label '%1 Code Viewer control add-in', Comment='%1 - product name';


    procedure OpenDebuggerTaskPage()
    begin
        if not CodeViewerControlRegistered then begin
          ClientAddin.Init;
          ClientAddin."Add-in Name" := 'Microsoft.Dynamics.Nav.Client.CodeViewer';
          ClientAddin."Public Key Token" := '31bf3856ad364e35';
          ClientAddin.Description := StrSubstNo(ClientAddinDescriptionTxt,ProductName.Full);
          if ClientAddin.Insert then;
          CodeViewerControlRegistered := true;
        end;

        if not Debugger.IsActive then
          DebuggerTaskPage.Run
        else
          DebuggerTaskPage.Close;
    end;


    procedure ProcessDebuggerBreak(ErrorMessage: Text)
    begin
        LastErrorMessage := ErrorMessage;
        LastErrorMesssageIsNew := true;

        if Debugger.IsActive then begin
          if ActionState = Actionstate::CodeTrackingAction then
            ActionState := Actionstate::BreakAfterCodeTrackingAction
          else
            if ActionState = Actionstate::RunningCodeAction then
              ActionState := Actionstate::BreakAfterRunningCodeAction;

          RefreshDebuggerTaskPage;
        end else
          Error(Text000Err);
    end;


    procedure GetLastErrorMessage(var IsNew: Boolean) Message: Text
    begin
        Message := LastErrorMessage;
        IsNew := LastErrorMesssageIsNew;
        LastErrorMesssageIsNew := false;
    end;


    procedure RefreshDebuggerTaskPage()
    begin
        DebuggerTaskPage.Activate(true);
    end;


    procedure AddWatch(Path: Text[1024];Refresh: Boolean)
    var
        DebuggerWatch: Record "Debugger Watch";
    begin
        if Path <> '' then begin
          DebuggerWatch.SetRange(Path,Path);
          if DebuggerWatch.IsEmpty then begin
            DebuggerWatch.Init;
            DebuggerWatch.Path := Path;
            DebuggerWatch.Insert(true);

            if Refresh then
              RefreshDebuggerTaskPage;
          end;
        end;
    end;

    local procedure LastIndexOf(Path: Text[1024];Character: Char;Index: Integer): Integer
    var
        CharPos: Integer;
    begin
        if Path = '' then
          exit(0);

        if Index <= 0 then
          exit(0);

        if Index > StrLen(Path) then
          Index := StrLen(Path);

        CharPos := Index;

        if Path[CharPos] = Character then
          exit(CharPos);
        if CharPos = 1 then
          exit(0);

        repeat
          CharPos := CharPos - 1
        until (CharPos = 1) or (Path[CharPos] = Character);

        if Path[CharPos] = Character then
          exit(CharPos);

        exit(0);
    end;


    procedure RemoveQuotes(Variable: Text[1024]) VarWithoutQuotes: Text[1024]
    begin
        if Variable = '' then
          exit(Variable);

        if (StrLen(Variable) >= 2) and (Variable[1] = '"') and (Variable[StrLen(Variable)] = '"') then
          VarWithoutQuotes := CopyStr(Variable,2,StrLen(Variable) - 2)
        else
          VarWithoutQuotes := Variable;
    end;

    local procedure IsInRecordContext(Path: Text[1024];"Record": Text): Boolean
    var
        Index: Integer;
        Position: Integer;
        CurrentContext: Text[250];
    begin
        if Path = '' then
          exit(false);

        if Record = '' then // Empty record name means all paths match
          exit(true);

        Index := StrLen(Path);

        if Path[Index] = '"' then begin
          Position := LastIndexOf(Path,'"',Index - 1);
          if Position <= 1 then
            exit(false);
          if Path[Position - 1] <> '.' then
            exit(false);
          Index := Position - 1; // set index on first '.' from the end
        end else begin
          Position := LastIndexOf(Path,'.',Index);
          if Position <= 1 then
            exit(false);
          Index := Position; // set index on first '.' from the end
        end;

        Index := Index - 1;
        Position := LastIndexOf(Path,'.',Index);

        if Position <= 1 then  // second '.' not found - context not found
          exit(false);

        Index := Position - 1;
        Position := LastIndexOf(Path,'.',Index);

        CurrentContext := CopyStr(Path,Position + 1,Index - Position);
        exit(Lowercase(CurrentContext) = Lowercase(Record));
    end;


    procedure ShouldBeInTooltip(Path: Text[1024];LeftContext: Text): Boolean
    begin
        exit((StrPos(Path,'."<Globals>"') = 0) and (StrPos(Path,'.Keys.') = 0) and
          ((StrPos(Path,'."<Global Text Constants>".') = 0) or (StrPos(Path,'"<Globals>"."<Global Text Constants>".') > 0)) and
          IsInRecordContext(Path,LeftContext));
    end;


    procedure GetDebuggedSession(var DebuggedSessionRec: Record "Active Session")
    begin
        DebuggedSessionRec := DebuggedSession;
    end;


    procedure SetDebuggedSession(DebuggedSessionRec: Record "Active Session")
    begin
        DebuggedSession := DebuggedSessionRec;
    end;


    procedure SetRunningCodeAction()
    begin
        ActionState := Actionstate::RunningCodeAction;
    end;


    procedure SetCodeTrackingAction()
    begin
        ActionState := Actionstate::CodeTrackingAction;
    end;


    procedure IsBreakAfterRunningCodeAction(): Boolean
    begin
        exit(ActionState = Actionstate::BreakAfterRunningCodeAction);
    end;


    procedure IsBreakAfterCodeTrackingAction(): Boolean
    begin
        exit(ActionState = Actionstate::BreakAfterCodeTrackingAction);
    end;


    procedure ResetActionState()
    begin
        ActionState := Actionstate::None;
    end;
}

