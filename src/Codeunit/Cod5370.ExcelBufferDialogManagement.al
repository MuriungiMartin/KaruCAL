#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5370 "Excel Buffer Dialog Management"
{

    trigger OnRun()
    begin
    end;

    var
        Window: Dialog;
        Progress: Integer;
        WindowOpen: Boolean;


    procedure Open(Text: Text)
    begin
        Window.Open(Text + '@1@@@@@@@@@@@@@@@@@@@@@@@@@\');
        Window.Update(1,0);
        WindowOpen := true;
    end;

    [TryFunction]

    procedure SetProgress(pProgress: Integer)
    begin
        Progress := pProgress;
        if WindowOpen then
          Window.Update(1,Progress);
    end;


    procedure Close()
    begin
        if WindowOpen then begin
          Window.Close;
          WindowOpen := false;
        end;
    end;
}

