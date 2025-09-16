#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 7 "GLBudget-Open"
{
    TableNo = "G/L Account";

    trigger OnRun()
    begin
        if GetFilter("Budget Filter") = '' then
          SearchForName := true
        else begin
          GLBudgetName.SetFilter(Name,GetFilter("Budget Filter"));
          SearchForName := not GLBudgetName.FindFirst;
          GLBudgetName.SetRange(Name);
        end;
        if SearchForName then begin
          if not GLBudgetName.FindFirst then begin
            GLBudgetName.Init;
            GLBudgetName.Name := Text000;
            GLBudgetName.Description := Text001;
            GLBudgetName.Insert;
          end;
          SetFilter("Budget Filter",GLBudgetName.Name);
        end;
    end;

    var
        Text000: label 'DEFAULT';
        Text001: label 'Default Budget';
        GLBudgetName: Record "G/L Budget Name";
        SearchForName: Boolean;
}

