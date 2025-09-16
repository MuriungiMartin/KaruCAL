#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 849 "Cash Flow Account - Indent"
{

    trigger OnRun()
    begin
        if not
           Confirm(
             Text1000 +
             Text1003,true)
        then
          exit;

        Indentation;
    end;

    var
        Text1000: label 'This function updates the indentation of all the cash flow accounts in the chart of cash flow accounts. All accounts between a Begin-Total and the matching End-Total are indented one level. The Totaling for each End-total is also updated.\\';
        Text1003: label 'Do you want to indent the chart of accounts?';
        Text1004: label 'Indenting the Chart of Accounts #1##########';
        Text1005: label 'End-Total %1 is missing a matching Begin-Total.';
        CFAccount: Record "Cash Flow Account";
        Window: Dialog;
        AccNo: array [10] of Code[20];
        i: Integer;

    local procedure Indentation()
    begin
        Window.Open(Text1004);

        with CFAccount do
          if Find('-') then
            repeat
              Window.Update(1,"No.");

              if "Account Type" = "account type"::"End-Total" then begin
                if i < 1 then
                  Error(
                    Text1005,
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
}

