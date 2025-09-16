#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 10021 "Invoice-Post (Yes/No)"
{
    TableNo = "Sales Header";

    trigger OnRun()
    begin
        SalesHeader.Copy(Rec);
        Code;
        Rec := SalesHeader;
    end;

    var
        SalesHeader: Record "Sales Header";
        SalesPost: Codeunit "Sales-Post";
        Text1020001: label 'Do you want to invoice the %1?';

    local procedure "Code"()
    begin
        with SalesHeader do
          if "Document Type" = "document type"::Order then begin
            if not Confirm(Text1020001,false,"Document Type") then
              exit;
            Ship := false;
            Invoice := true;
            SalesPost.Run(SalesHeader);
          end;
    end;
}

