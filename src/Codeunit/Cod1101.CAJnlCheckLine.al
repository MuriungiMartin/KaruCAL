#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 1101 "CA Jnl.-Check Line"
{
    TableNo = "Cost Journal Line";

    trigger OnRun()
    begin
        SourceCodeSetup.Get;
        RunCheck(Rec);
    end;

    var
        SourceCodeSetup: Record "Source Code Setup";
        Text000: label 'Cost type or balance cost type must be defined.\Line %1, document %2, amount %3.';
        Text001: label 'You cannot define both cost center and cost object.\Line %1, document %2, amount %3.';
        Text002: label 'Balance cost center or balance cost object must be defined.\Line %1, document %2, amount %3.';
        Text003: label 'You cannot define both balance cost center and balance cost object.\Line %1, document %2, amount %3.';
        Text004: label 'Cost center or cost object must be defined. \Line %1, document %2, amount %3.';
        Text005: label 'is not within the permitted range of posting dates', Comment='starts with "Posting Date"';


    procedure RunCheck(var CostJnlLine: Record "Cost Journal Line")
    var
        CostType: Record "Cost Type";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        with CostJnlLine do begin
          TestField("Posting Date");
          TestField("Document No.");

          SourceCodeSetup.Get;
          TestField(Amount);

          if ("Cost Type No." = '') and ("Bal. Cost Type No." = '') then
            Error(Text000,"Line No.","Document No.",Amount);

          if "Cost Type No." <> '' then begin
            CostType.Get("Cost Type No.");
            CostType.TestField(Blocked,false);
            CostType.TestField(Type,CostType.Type::"Cost Type");

            if "Source Code" <> SourceCodeSetup."G/L Entry to CA" then
              if ("Cost Center Code" = '') and ("Cost Object Code" = '') then
                Error(Text004,"Line No.","Document No.",Amount);
            if ("Cost Center Code" <> '') and ("Cost Object Code" <> '') then
              Error(Text001,"Line No.","Document No.",Amount);
          end;

          if "Bal. Cost Type No." <> '' then begin
            CostType.Get("Bal. Cost Type No.");
            CostType.TestField(Blocked,false);
            CostType.TestField(Type,CostType.Type::"Cost Type");

            if ("Bal. Cost Center Code" = '') and ("Bal. Cost Object Code" = '') then
              Error(Text002,"Line No.","Document No.",Amount);
            if ("Bal. Cost Center Code" <> '') and ("Bal. Cost Object Code" <> '') then
              Error(Text003,"Line No.","Document No.",Amount);
          end;

          if GenJnlCheckLine.DateNotAllowed("Posting Date") then
            FieldError("Posting Date",Text005);
        end;
    end;
}

