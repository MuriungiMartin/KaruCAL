#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10011 "Ship-Post (Yes/No)"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        Text1020001: label 'Do you want to ship the %1?';
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";

    local procedure "Code"()
    begin
        with SalesHeader do
          if "Document Type" = "document type"::Order then begin
            if not Confirm(Text1020001,false,"Document Type") then begin
              "Shipping No." := '-1';
              exit;
            end;
            Ship := true;
            Invoice := false;
            SalesPost.Run(SalesHeader);
          end;
    end;
}

