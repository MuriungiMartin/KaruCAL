#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 8615 "Config. Progress Bar"
{

    trigger OnRun()
    begin
    end;

    var
        Window: Dialog;
        Text000: label '#1##################\\';
        Text001: label '#2##################\';
        MaxCount: Integer;
        Text002: label '@3@@@@@@@@@@@@@@@@@@\';
        StepCount: Integer;
        Counter: Integer;
        LastWindowText: Text;
        WindowTextCount: Integer;


    procedure Init(NewMaxCount: Integer;NewStepCount: Integer;WindowTitle: Text)
    begin
        Counter := 0;
        MaxCount := NewMaxCount;
        if NewStepCount = 0 then
          NewStepCount := 1;
        StepCount := NewStepCount;

        Window.Open(Text000 + Text001 + Text002);
        Window.Update(1,Format(WindowTitle));
        Window.Update(3,0);
    end;


    procedure Update(WindowText: Text)
    begin
        if WindowText <> '' then begin
          Counter := Counter + 1;
          if Counter MOD StepCount = 0 then begin
            Window.Update(2,Format(WindowText));
            if MaxCount <> 0 then
              Window.Update(3,ROUND(Counter / MaxCount * 10000,1));
          end;
        end;
    end;

    [TryFunction]

    procedure UpdateCount(WindowText: Text;"Count": Integer)
    begin
        if WindowText <> '' then begin
          if LastWindowText = WindowText then
            WindowTextCount += 1
          else
            WindowTextCount := 0;
          LastWindowText := WindowText;
          Window.Update(2,PadStr(WindowText + ' ',StrLen(WindowText) + WindowTextCount,'.'));
          if MaxCount <> 0 then
            Window.Update(3,ROUND((MaxCount - Count) / MaxCount * 10000,1));
        end;
    end;


    procedure Close()
    begin
        Window.Close;
    end;
}

