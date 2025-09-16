#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 15 "Gen. Jnl.-Show Card"
{
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    begin
        case "Account Type" of
          "account type"::"G/L Account":
            begin
              GLAcc."No." := "Account No.";
              Page.Run(Page::"G/L Account Card",GLAcc);
            end;
          "account type"::Customer:
            begin
              Cust."No." := "Account No.";
              Page.Run(Page::"Customer Card",Cust);
            end;
          "account type"::Vendor:
            begin
              Vend."No." := "Account No.";
              Page.Run(Page::"Vendor Card",Vend);
            end;
          "account type"::"Bank Account":
            begin
              BankAcc."No." := "Account No.";
              Page.Run(Page::"Bank Account Card",BankAcc);
            end;
          "account type"::"Fixed Asset":
            begin
              FA."No." := "Account No.";
              Page.Run(Page::"Fixed Asset Card",FA);
            end;
          "account type"::"IC Partner":
            begin
              ICPartner.Code := "Account No.";
              Page.Run(Page::"IC Partner Card",ICPartner);
            end;
        end;
    end;

    var
        GLAcc: Record "G/L Account";
        Cust: Record Customer;
        Vend: Record Vendor;
        BankAcc: Record "Bank Account";
        FA: Record "Fixed Asset";
        ICPartner: Record "IC Partner";
}

