#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 50102 "FP Posting Check"
{
    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        blnState: Boolean;
        blnJrnlState: Boolean;


    procedure ResetState()
    begin
        blnState:=false;
    end;


    procedure SetState(Post: Boolean)
    begin
        blnState:=Post;
    end;


    procedure GetState() ActState: Boolean
    begin
        ActState:=blnState;
        exit(ActState);
    end;
}

