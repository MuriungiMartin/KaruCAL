#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 6085 "Serv. Ledg Bar Chart DrillDown"
{
    TableNo = "Bar Chart Buffer";

    trigger OnRun()
    begin
        if Tag = '' then
          Error(Text000);
        ServLedgEntry.SetView(Tag);
        ServLedgEntry.SetRange(Open,false);
        case "Series No." of
          1:
            ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Sale);
          2:
            begin
              ServLedgEntry.SetRange("Entry Type",ServLedgEntry."entry type"::Usage);
              ServLedgEntry.SetRange("Moved from Prepaid Acc.",true);
            end;
        end;
        Page.RunModal(0,ServLedgEntry);
    end;

    var
        ServLedgEntry: Record "Service Ledger Entry";
        Text000: label 'The corresponding service ledger entries cannot be displayed because the filter expression is too long.';
}

