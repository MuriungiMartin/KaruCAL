#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 783 "Relationship Performance Mgt."
{

    trigger OnRun()
    begin
    end;

    local procedure CalcTopFiveOpportunities(var TempOpportunity: Record Opportunity temporary)
    var
        Opportunity: Record Opportunity;
        I: Integer;
    begin
        TempOpportunity.DeleteAll;
        Opportunity.SetAutocalcFields("Estimated Value (LCY)");
        Opportunity.SetRange(Closed,false);
        Opportunity.SetCurrentkey("Estimated Value (LCY)");
        Opportunity.Ascending(false);
        if Opportunity.FindSet then
          repeat
            I += 1;
            TempOpportunity := Opportunity;
            TempOpportunity.Insert;
          until (Opportunity.Next = 0) or (I = 5);
    end;


    procedure DrillDown(var BusinessChartBuffer: Record "Business Chart Buffer";var TempOpportunity: Record Opportunity temporary)
    var
        Opportunity: Record Opportunity;
    begin
        if TempOpportunity.FindSet then begin
          TempOpportunity.Next(BusinessChartBuffer."Drill-Down X Index");
          Opportunity.SetRange("No.",TempOpportunity."No.");
          Page.Run(Page::"Opportunity List",Opportunity);
        end;
    end;


    procedure UpdateData(var BusinessChartBuffer: Record "Business Chart Buffer";var TempOpportunity: Record Opportunity temporary)
    var
        I: Integer;
    begin
        with BusinessChartBuffer do begin
          Initialize;
          AddMeasure(TempOpportunity.FieldCaption("Estimated Value (LCY)"),1,"data type"::Decimal,"chart type"::StackedColumn);
          SetXAxis(TempOpportunity.TableCaption,"data type"::String);
          CalcTopFiveOpportunities(TempOpportunity);
          TempOpportunity.SetAutocalcFields("Estimated Value (LCY)");
          if TempOpportunity.FindSet then
            repeat
              I += 1;
              AddColumn(TempOpportunity.Description);
              SetValueByIndex(0,I - 1,TempOpportunity."Estimated Value (LCY)");
            until TempOpportunity.Next = 0;
        end;
    end;
}

