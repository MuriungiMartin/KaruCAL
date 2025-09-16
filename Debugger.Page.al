#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9500 Debugger
{
    Caption = 'Debugger';
    DataCaptionExpression = DataCaption;
    Editable = false;
    LinksAllowed = false;
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Code Tracking,Running Code,Breakpoints,Show';
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Active Session";

    layout
    {
        area(content)
        {
            part(CodeViewer;"Debugger Code Viewer")
            {
                ApplicationArea = All;
                Caption = 'Code';
                Provider = Callstack;
                SubPageLink = "Object Type"=field("Object Type"),
                              "Object ID"=field("Object ID"),
                              "Line No."=field("Line No."),
                              ID=field(ID);
            }
            field("FinishTime - StartTime";FinishTime - StartTime)
            {
                ApplicationArea = All;
                Caption = 'Duration';
            }
        }
        area(factboxes)
        {
            part(Watches;"Debugger Watch Value FactBox")
            {
                ApplicationArea = All;
                Caption = 'Watches';
                Provider = Callstack;
                SubPageLink = "Call Stack ID"=field(ID);
            }
            part(Callstack;"Debugger Callstack FactBox")
            {
                ApplicationArea = All;
                Caption = 'Call Stack';
            }
        }
    }

    actions
    {
        area(processing)
        {
            separator(Action25)
            {
            }
            group("Code Tracking")
            {
                Caption = 'Code Tracking';
                action("Step Into")
                {
                    ApplicationArea = All;
                    Caption = 'Step Into';
                    Enabled = BreakpointHit;
                    Image = StepInto;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'F11';
                    ToolTip = 'Execute the current statement. If the statement contains a function call, then execute the function and break at the first statement inside the function.';

                    trigger OnAction()
                    begin
                        StartTime := CurrentDatetime;
                        WaitingForBreak;
                        DebuggerManagement.SetCodeTrackingAction;
                        Debugger.StepOnto;
                        FinishTime := CurrentDatetime;
                    end;
                }
                action("Step Over")
                {
                    ApplicationArea = All;
                    Caption = 'Step Over';
                    Enabled = BreakpointHit;
                    Image = StepOver;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'F10';
                    ToolTip = 'Execute the current statement. If the statement contains a function call, then execute the function and break at the first statement outside the function.';

                    trigger OnAction()
                    begin
                        StartTime := CurrentDatetime;
                        WaitingForBreak;
                        DebuggerManagement.SetCodeTrackingAction;
                        Debugger.StepPver;
                        FinishTime := CurrentDatetime;
                    end;
                }
                action("Step Out")
                {
                    ApplicationArea = All;
                    Caption = 'Step Out';
                    Enabled = BreakpointHit;
                    Image = StepOut;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F11';
                    ToolTip = 'Execute the remaining statements in the current function and break at the next statement in the calling function.';

                    trigger OnAction()
                    begin
                        StartTime := CurrentDatetime;
                        WaitingForBreak;
                        DebuggerManagement.SetCodeTrackingAction;
                        Debugger.StepOut;
                        FinishTime := CurrentDatetime;
                    end;
                }
            }
            separator(Action11)
            {
            }
            group("Running Code")
            {
                Caption = 'Running Code';
                action(Continue)
                {
                    ApplicationArea = All;
                    Caption = 'Continue';
                    Enabled = BreakpointHit;
                    Image = Continue;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'F5';
                    ToolTip = 'Continue until the next break.';

                    trigger OnAction()
                    begin
                        StartTime := CurrentDatetime;
                        WaitingForBreak;
                        DebuggerManagement.SetRunningCodeAction;
                        Debugger.Continue;
                        FinishTime := CurrentDatetime;
                    end;
                }
                action("Break")
                {
                    ApplicationArea = All;
                    Caption = 'Break';
                    Enabled = BreakEnabled;
                    Image = Pause;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+B';
                    ToolTip = 'Break at the next statement.';

                    trigger OnAction()
                    begin
                        BreakEnabled := false;
                        DebuggerManagement.SetRunningCodeAction;
                        Debugger."BREAK";
                        FinishTime := CurrentDatetime;
                    end;
                }
                action(Stop)
                {
                    ApplicationArea = All;
                    Caption = 'Stop';
                    Enabled = BreakpointHit;
                    Image = Stop;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F5';
                    ToolTip = 'Stop the current activity in the session being debugged while continuing to debug the session.';

                    trigger OnAction()
                    begin
                        WaitingForBreak;
                        DebuggerManagement.SetRunningCodeAction;
                        Debugger.Stop;
                        FinishTime := CurrentDatetime;
                    end;
                }
            }
            separator(Action21)
            {
            }
            group("Breakpoints Group")
            {
                Caption = 'Breakpoints';
                action(Toggle)
                {
                    ApplicationArea = All;
                    Caption = 'Toggle';
                    Image = ToggleBreakpoint;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';
                    ToolTip = 'Toggle a breakpoint at the current line.';

                    trigger OnAction()
                    begin
                        CurrPage.CodeViewer.Page.ToggleBreakpoint;
                    end;
                }
                action("Set/Clear Condition")
                {
                    ApplicationArea = All;
                    Caption = 'Set/Clear Condition';
                    Image = ConditionalBreakpoint;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';
                    ToolTip = 'Set or clear a breakpoint condition at the current line.';

                    trigger OnAction()
                    begin
                        CurrPage.CodeViewer.Page.SetBreakpointCondition;
                    end;
                }
                action("Disable All")
                {
                    ApplicationArea = All;
                    Caption = 'Disable All';
                    Image = DisableAllBreakpoints;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ToolTip = 'Disable all breakpoints in the breakpoint list. You can edit the list by using the Breakpoints action.';

                    trigger OnAction()
                    var
                        DebuggerBreakpoint: Record "Debugger Breakpoint";
                    begin
                        DebuggerBreakpoint.ModifyAll(Enabled,false,true);
                    end;
                }
                action(Breakpoints)
                {
                    ApplicationArea = All;
                    Caption = 'Breakpoints';
                    Image = BreakpointsList;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "Debugger Breakpoint List";
                    ToolTip = 'Edit the breakpoint list for all objects.';
                }
                action("Break Rules")
                {
                    ApplicationArea = All;
                    Caption = 'Break Rules';
                    Image = BreakRulesList;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ToolTip = 'Change settings for break rules. The debugger breaks code execution for certain configurable rules as well as for breakpoints.';

                    trigger OnAction()
                    var
                        DebuggerBreakRulesPage: Page "Debugger Break Rules";
                    begin
                        DebuggerBreakRulesPage.SetBreakOnError(BreakOnError);
                        DebuggerBreakRulesPage.SetBreakOnRecordChanges(BreakOnRecordChanges);
                        DebuggerBreakRulesPage.SetSkipCodeunit1(SkipCodeunit1);

                        if DebuggerBreakRulesPage.RunModal = Action::OK then begin
                          BreakOnError := DebuggerBreakRulesPage.GetBreakOnError;
                          Debugger.BreakOnError(BreakOnError);
                          BreakOnRecordChanges := DebuggerBreakRulesPage.GetBreakOnRecordChanges;
                          Debugger.BreakOnRecordChanges(BreakOnRecordChanges);
                          SkipCodeunit1 := DebuggerBreakRulesPage.GetSkipCodeunit1;
                          Debugger.SkipSystemTriggers(SkipCodeunit1);

                          SaveConfiguration;
                        end;
                    end;
                }
            }
            separator(Action22)
            {
            }
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                action(Variables)
                {
                    ApplicationArea = All;
                    Caption = 'Variables';
                    Enabled = BreakpointHit;
                    Image = VariableList;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+Ctrl+V';
                    ToolTip = 'View the list of variables in the current scope.';

                    trigger OnAction()
                    var
                        DebuggerCallstack: Record "Debugger Call Stack";
                        DebuggerVariable: Record "Debugger Variable";
                    begin
                        CurrPage.Callstack.Page.GetCurrentCallstack(DebuggerCallstack);

                        DebuggerVariable.FilterGroup(2);
                        DebuggerVariable.SetRange("Call Stack ID",DebuggerCallstack.ID);
                        DebuggerVariable.FilterGroup(0);

                        Page.RunModal(Page::"Debugger Variable List",DebuggerVariable);
                    end;
                }
                action(LastErrorMessage)
                {
                    ApplicationArea = All;
                    Caption = 'Last Error';
                    Enabled = ShowLastErrorEnabled;
                    Image = PrevErrorMessage;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ToolTip = 'View the last error message shown by the session being debugged.';

                    trigger OnAction()
                    var
                        DebuggerManagement: Codeunit "Sequence No. Mgt.";
                        LastErrorMessage: Text;
                        IsLastErrorMessageNew: Boolean;
                    begin
                        LastErrorMessage := DebuggerManagement.GetLastErrorMessage(IsLastErrorMessageNew);

                        if LastErrorMessage = '' then
                          LastErrorMessage := Debugger.GetLastErrorText;

                        Message(StrSubstNo(Text005Msg,LastErrorMessage));
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if BreakpointHit then begin
          CurrPage.Callstack.Page.GetCurrentCallstack(DebuggerCallstack);
          with DebuggerCallstack do begin
            if ID <> 0 then
              DataCaption := StrSubstNo(Text003Cap,"Object Type","Object ID","Object Name")
            else
              DataCaption := Text004Cap;
          end;
          FinishTime := CurrentDatetime;
        end;
    end;

    trigger OnClosePage()
    begin
        if Debugger.Deactivate then;
        SetAttachedSession := false;
    end;

    trigger OnFindRecord(Which: Text): Boolean
    var
        DebuggedSession: Record "Active Session";
        IsBreakOnErrorMessageNew: Boolean;
        BreakOnErrorMessage: Text;
    begin
        if not Debugger.IsActive and (Which = '=') then
          Message(Text007Msg);

        if not Debugger.IsActive then begin
          CurrPage.Close;
          exit(false);
        end;

        BreakpointHit := Debugger.IsBreakpointHit;

        if BreakpointHit then begin
          BreakOnErrorMessage := DebuggerManagement.GetLastErrorMessage(IsBreakOnErrorMessageNew);

          if IsBreakOnErrorMessageNew and (BreakOnErrorMessage <> '') then
            Message(StrSubstNo(Text002Msg,BreakOnErrorMessage));

          ShowLastErrorEnabled := (BreakOnErrorMessage <> '') or (Debugger.GetLastErrorText <> '');

          BreakEnabled := false;
          if not SetAttachedSession then begin
            DebuggedSession."Session ID" := Debugger.DebuggedSessionId;
            DebuggerManagement.SetDebuggedSession(DebuggedSession);
            SetAttachedSession := true;
          end;
        end else begin
          IsBreakOnErrorMessageNew := false;
          ShowLastErrorEnabled := false;
          DataCaption := Text004Cap;
        end;

        exit(true);
    end;

    trigger OnInit()
    begin
        BreakOnError := true;
        BreakpointHit := Debugger.IsBreakpointHit;
        BreakEnabled := not BreakpointHit;
    end;

    trigger OnOpenPage()
    var
        DebuggedSession: Record "Active Session";
    begin
        StartTime := CurrentDatetime;
        FinishTime := StartTime;
        DebuggerManagement.GetDebuggedSession(DebuggedSession);
        if DebuggedSession."Session ID" = 0 then
          Debugger.Activate
        else begin
          Debugger.Attach(DebuggedSession."Session ID");
          SetAttachedSession := true;
        end;

        if UserPersonalization.Get(UserSecurityId) then begin
          BreakOnError := UserPersonalization."Debugger Break On Error";
          BreakOnRecordChanges := UserPersonalization."Debugger Break On Rec Changes";
          SkipCodeunit1 := UserPersonalization."Debugger Skip System Triggers";
        end;

        if BreakOnError then
          Debugger.BreakOnError(true);
        if BreakOnRecordChanges then
          Debugger.BreakOnRecordChanges(true);
        if SkipCodeunit1 then
          Debugger.SkipSystemTriggers(true);

        DebuggerManagement.ResetActionState;
    end;

    var
        DebuggerCallstack: Record "Debugger Call Stack";
        UserPersonalization: Record "User Personalization";
        DebuggerManagement: Codeunit "Sequence No. Mgt.";
        [InDataSet]
        BreakEnabled: Boolean;
        [InDataSet]
        BreakpointHit: Boolean;
        [InDataSet]
        BreakOnError: Boolean;
        Text002Msg: label 'Break On Error Message:\ \%1', Comment='Message shown when Break On Error occurs. Include the original error message.';
        [InDataSet]
        BreakOnRecordChanges: Boolean;
        SkipCodeunit1: Boolean;
        DataCaption: Text[100];
        [InDataSet]
        ShowLastErrorEnabled: Boolean;
        Text003Cap: label '%1 %2 : %3', Comment='DataCaption when debugger is broken in application code. Example: Codeunit 1:  Application Management';
        Text004Cap: label 'Waiting for break...', Comment='DataCaption when waiting for break';
        SetAttachedSession: Boolean;
        Text005Msg: label 'Last Error Message:\ \%1';
        Text007Msg: label 'The session that was being debugged has closed. The Debugger Page will close.';
        StartTime: DateTime;
        FinishTime: DateTime;

    local procedure SaveConfiguration()
    begin
        if UserPersonalization.Get(UserSecurityId) then begin
          UserPersonalization."Debugger Break On Error" := BreakOnError;
          UserPersonalization."Debugger Break On Rec Changes" := BreakOnRecordChanges;
          UserPersonalization."Debugger Skip System Triggers" := SkipCodeunit1;
          UserPersonalization.Modify;
        end;
    end;

    local procedure WaitingForBreak()
    begin
        BreakEnabled := true;
        CurrPage.Callstack.Page.ResetCallstackToTop;
    end;
}

