#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 5050 "Opp. Bar Chart DrillDown"
{
    TableNo = "Bar Chart Buffer";

    trigger OnRun()
    begin
        if Tag = '' then
          Error(Text000);
        OpportunityEntry.SetView(Tag);
        OpportunityEntry.SetRange(Active,true);
        if OpportunityEntry.Find('-') then
          repeat
            Opportunity.Get(OpportunityEntry."Opportunity No.");
            TempOpportunity := Opportunity;
            TempOpportunity.Insert;
          until OpportunityEntry.Next = 0;

        Page.Run(Page::"Active Opportunity List",TempOpportunity);
    end;

    var
        Text000: label 'The corresponding opportunity entries cannot be displayed because the filter expression is too long.';
        OpportunityEntry: Record "Opportunity Entry";
        Opportunity: Record Opportunity;
        TempOpportunity: Record Opportunity temporary;
}

