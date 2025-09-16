#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 3 "G/L Account-Indent"
{

    trigger OnRun()
    begin
        if not
           Confirm(
             Text000 +
             Text001 +
             Text002 +
             Text003,true)
        then
          exit;

        Indent;
    end;

    var
        Text000: label 'This function updates the indentation of all the G/L accounts in the chart of accounts. ';
        Text001: label 'All accounts between a Begin-Total and the matching End-Total are indented one level. ';
        Text002: label 'The Totaling for each End-total is also updated.';
        Text003: label '\\Do you want to indent the chart of accounts?';
        Text004: label 'Indenting the Chart of Accounts #1##########';
        Text005: label 'End-Total %1 is missing a matching Begin-Total.';
        GLAcc: Record "G/L Account";
        Window: Dialog;
        AccNo: array [10] of Code[20];
        i: Integer;


    procedure Indent()
    begin
        Window.Open(Text004);

        with GLAcc do
          if Find('-') then
            repeat
              Window.Update(1,"No.");

              if "Account Type" = "account type"::"End-Total" then begin
                if i < 1 then
                  Error(
                    Text005,
                    "No.");
                Totaling := AccNo[i] + '..' + "No.";
                i := i - 1;
              end;

              Indentation := i;
              Modify;

              if "Account Type" = "account type"::"Begin-Total" then begin
                i := i + 1;
                AccNo[i] := "No.";
              end;
            until Next = 0;

        Window.Close;
    end;


    procedure RunICAccountIndent()
    begin
        if not
           Confirm(
             Text000 +
             Text001 +
             Text003,true)
        then
          exit;

        IndentICAccount;
    end;

    local procedure IndentICAccount()
    var
        ICGLAcc: Record "IC G/L Account";
    begin
        Window.Open(Text004);
        with ICGLAcc do
          if Find('-') then
            repeat
              Window.Update(1,"No.");

              if "Account Type" = "account type"::"End-Total" then begin
                if i < 1 then
                  Error(
                    Text005,
                    "No.");
                i := i - 1;
              end;

              Indentation := i;
              Modify;

              if "Account Type" = "account type"::"Begin-Total" then begin
                i := i + 1;
                AccNo[i] := "No.";
              end;
            until Next = 0;
        Window.Close;
    end;
}

