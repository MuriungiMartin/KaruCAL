#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1320 "Lines Instruction Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        LinesMissingQuantityErr: label 'One or more document lines with a value in the Item No. field do not have a quantity specified.';


    procedure SalesCheckAllLinesHaveQuantityAssigned(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document No.",SalesHeader."No.");
        SalesLine.SetRange("Document Type",SalesHeader."Document Type");

        if SalesLine.FindSet then
          repeat
            if (SalesLine."No." <> '') and (SalesLine.Quantity = 0) then
              Error(LinesMissingQuantityErr);
          until SalesLine.Next = 0;
    end;


    procedure PurchaseCheckAllLinesHaveQuantityAssigned(PurchaseHeader: Record "Purchase Header")
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.SetRange("Document No.",PurchaseHeader."No.");
        PurchaseLine.SetRange("Document Type",PurchaseHeader."Document Type");

        if PurchaseLine.FindSet then
          repeat
            if (PurchaseLine."No." <> '') and (PurchaseLine.Quantity = 0) then
              Error(LinesMissingQuantityErr);
          until PurchaseLine.Next = 0;
    end;
}

