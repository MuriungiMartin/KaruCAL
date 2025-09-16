#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5803 "Show Avg. Calc. - Item"
{
    TableNo = Item;

    trigger OnRun()
    var
        ValueEntry: Record "Value Entry";
    begin
        with ValueEntry do begin
          SetCurrentkey("Item No.","Valuation Date","Location Code","Variant Code");
          SetRange("Item No.",Rec."No.");
          SetFilter("Valuation Date",Rec.GetFilter("Date Filter"));
          SetFilter("Location Code",Rec.GetFilter("Location Filter"));
          SetFilter("Variant Code",Rec.GetFilter("Variant Filter"));
        end;
        Page.RunModal(Page::"Value Entries",ValueEntry,ValueEntry."Cost Amount (Actual)");
    end;


    procedure DrillDownAvgCostAdjmtPoint(var Item: Record Item)
    var
        AvgCostCalcOverview: Page "Average Cost Calc. Overview";
    begin
        AvgCostCalcOverview.SetItem(Item);
        AvgCostCalcOverview.RunModal;
    end;
}

