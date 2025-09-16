#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 782 "Opportunity Chart Mgt."
{

    trigger OnRun()
    begin
    end;


    procedure DrillDown(var BusinessChartBuffer: Record "Business Chart Buffer";Period: Record Date;OpportunityStatus: Option)
    var
        Opportunity: Record Opportunity;
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        SalesPersonName: Variant;
    begin
        BusinessChartBuffer.GetXValue(BusinessChartBuffer."Drill-Down X Index",SalesPersonName);
        SalespersonPurchaser.SetRange(Name,SalesPersonName);
        SalespersonPurchaser.FindFirst;
        Opportunity.SetRange("Salesperson Code",SalespersonPurchaser.Code);
        Opportunity.Status := OpportunityStatus;
        Opportunity.SetRange(Status,Opportunity.Status);
        case Opportunity.Status of
          Opportunity.Status::"Not Started",
          Opportunity.Status::"In Progress":
            Opportunity.SetRange("Creation Date",0D,Period."Period End");
          Opportunity.Status::Won,
          Opportunity.Status::Lost:
            Opportunity.SetRange("Date Closed",Period."Period Start",Period."Period End");
        end;
        Page.Run(Page::"Opportunity List",Opportunity);
    end;

    local procedure GetOppCount(Period: Record Date;SalesPersonCode: Code[10];OpportunityStatus: Option): Integer
    var
        Opportunity: Record Opportunity;
    begin
        Opportunity.SetRange("Salesperson Code",SalesPersonCode);
        Opportunity.Status := OpportunityStatus;
        Opportunity.SetRange(Status,Opportunity.Status);
        case Opportunity.Status of
          Opportunity.Status::"Not Started",
          Opportunity.Status::"In Progress":
            Opportunity.SetRange("Creation Date",0D,Period."Period End");
          Opportunity.Status::Won,
          Opportunity.Status::Lost:
            Opportunity.SetRange("Date Closed",Period."Period Start",Period."Period End");
        end;
        exit(Opportunity.Count);
    end;


    procedure SetDefaultOppStatus(var Opportunity: Record Opportunity)
    begin
        Opportunity.Status := Opportunity.Status::"In Progress";
    end;


    procedure SetDefaultPeriod(var Period: Record Date)
    begin
        Period."Period Type" := Period."period type"::Month;
        Period."Period Start" := CalcDate('<-CM>',WorkDate);
        Period."Period End" := CalcDate('<CM>',WorkDate);
    end;


    procedure SetNextPeriod(var Period: Record Date)
    begin
        case Period."Period Type" of
          Period."period type"::Date:
            Period."Period Start" := CalcDate('<+1D>',Period."Period Start");
          Period."period type"::Week:
            Period."Period Start" := CalcDate('<+1W>',Period."Period Start");
          Period."period type"::Month:
            Period."Period Start" := CalcDate('<+1M>',Period."Period Start");
          Period."period type"::Quarter:
            Period."Period Start" := CalcDate('<+1Q>',Period."Period Start");
          Period."period type"::Year:
            Period."Period Start" := CalcDate('<+1Y>',Period."Period Start");
        end;
        SetPeriodRange(Period);
    end;


    procedure SetPrevPeriod(var Period: Record Date)
    begin
        case Period."Period Type" of
          Period."period type"::Date:
            Period."Period Start" := CalcDate('<-1D>',Period."Period Start");
          Period."period type"::Week:
            Period."Period Start" := CalcDate('<-1W>',Period."Period Start");
          Period."period type"::Month:
            Period."Period Start" := CalcDate('<-1M>',Period."Period Start");
          Period."period type"::Quarter:
            Period."Period Start" := CalcDate('<-1Q>',Period."Period Start");
          Period."period type"::Year:
            Period."Period Start" := CalcDate('<-1Y>',Period."Period Start");
        end;
        SetPeriodRange(Period);
    end;


    procedure SetPeriodRange(var Period: Record Date)
    begin
        case Period."Period Type" of
          Period."period type"::Date:
            begin
              Period."Period Start" := Period."Period Start";
              Period."Period End" := Period."Period Start";
            end;
          Period."period type"::Week:
            begin
              Period."Period Start" := CalcDate('<-CW>',Period."Period Start");
              Period."Period End" := CalcDate('<CW>',Period."Period Start");
            end;
          Period."period type"::Month:
            begin
              Period."Period Start" := CalcDate('<-CM>',Period."Period Start");
              Period."Period End" := CalcDate('<CM>',Period."Period Start");
            end;
          Period."period type"::Quarter:
            begin
              Period."Period Start" := CalcDate('<-CQ>',Period."Period Start");
              Period."Period End" := CalcDate('<CQ>',Period."Period Start");
            end;
          Period."period type"::Year:
            begin
              Period."Period Start" := CalcDate('<-CY>',Period."Period Start");
              Period."Period End" := CalcDate('<CY>',Period."Period Start");
            end;
        end;
    end;


    procedure UpdateData(var BusinessChartBuffer: Record "Business Chart Buffer";Period: Record Date;OpportunityStatus: Option)
    var
        SalespersonPurchaser: Record "Salesperson/Purchaser";
        I: Integer;
        OppCount: Integer;
    begin
        with BusinessChartBuffer do begin
          Initialize;
          AddMeasure(SalespersonPurchaser.FieldCaption("No. of Opportunities"),1,"data type"::Integer,"chart type"::Pie);
          SetXAxis(SalespersonPurchaser.TableCaption,"data type"::String);
          if SalespersonPurchaser.FindSet then
            repeat
              OppCount := GetOppCount(Period,SalespersonPurchaser.Code,OpportunityStatus);
              if OppCount <> 0 then begin
                I += 1;
                AddColumn(SalespersonPurchaser.Name);
                SetValueByIndex(0,I - 1,OppCount);
              end;
            until SalespersonPurchaser.Next = 0;
        end;
    end;
}

