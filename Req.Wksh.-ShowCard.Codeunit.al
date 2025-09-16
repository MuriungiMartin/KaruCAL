#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 335 "Req. Wksh.-Show Card"
{
    TableNo = "Requisition Line";

    trigger OnRun()
    begin
        case Type of
          Type::"G/L Account":
            begin
              GLAcc."No." := "No.";
              Page.Run(Page::"G/L Account Card",GLAcc);
            end;
          Type::Item:
            begin
              Item."No." := "No.";
              Page.Run(Page::"Item Card",Item);
            end;
        end;
    end;

    var
        GLAcc: Record "G/L Account";
        Item: Record Item;
}

