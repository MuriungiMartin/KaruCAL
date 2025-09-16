#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Codeunit 952 "Time Sheet Chart Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        TimeSheetMgt: Codeunit "Time Sheet Management";
        Text001: label 'Time Sheet Resource';
        MeasureType: Option Open,Submitted,Rejected,Approved,Scheduled,Posted,"Not Posted",Resource,Job,Service,Absence,"Assembly Order";


    procedure OnOpenPage(var TimeSheetChartSetup: Record "Time Sheet Chart Setup")
    begin
        with TimeSheetChartSetup do
          if not Get(UserId) then begin
            "User ID" := UserId;
            "Starting Date" := TimeSheetMgt.FindNearestTimeSheetStartDate(WorkDate);
            Insert;
          end;
    end;


    procedure UpdateData(var BusChartBuf: Record "Business Chart Buffer")
    var
        TimeSheetChartSetup: Record "Time Sheet Chart Setup";
        BusChartMapColumn: Record "Business Chart Map";
        BusChartMapMeasure: Record "Business Chart Map";
    begin
        TimeSheetChartSetup.Get(UserId);

        with BusChartBuf do begin
          Initialize;
          SetXAxis(Text001,"data type"::String);

          AddColumns(BusChartBuf);
          AddMeasures(BusChartBuf,TimeSheetChartSetup);

          if FindFirstMeasure(BusChartMapMeasure) then
            repeat
              if FindFirstColumn(BusChartMapColumn) then
                repeat
                  SetValue(
                    BusChartMapMeasure.Name,
                    BusChartMapColumn.Index,
                    CalcAmount(
                      TimeSheetChartSetup,
                      BusChartMapColumn.Name,
                      TimeSheetChartSetup.MeasureIndex2MeasureType(BusChartMapMeasure.Index)));
                until not NextColumn(BusChartMapColumn);

            until not NextMeasure(BusChartMapMeasure);
        end;
    end;


    procedure DrillDown(var BusChartBuf: Record "Business Chart Buffer")
    var
        TimeSheetChartSetup: Record "Time Sheet Chart Setup";
        ResCapacityEntry: Record "Res. Capacity Entry";
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetPostingEntry: Record "Time Sheet Posting Entry";
        Value: Variant;
        ResourceNo: Code[20];
        CurrMeasureType: Integer;
    begin
        BusChartBuf.GetXValue(BusChartBuf."Drill-Down X Index",Value);
        ResourceNo := Format(Value);
        TimeSheetChartSetup.Get(UserId);

        CurrMeasureType := TimeSheetChartSetup.MeasureIndex2MeasureType(BusChartBuf."Drill-Down Measure Index");
        if CurrMeasureType = Measuretype::Scheduled then begin
          ResCapacityEntry.SetRange("Resource No.",ResourceNo);
          ResCapacityEntry.SetRange(Date,TimeSheetChartSetup."Starting Date",TimeSheetChartSetup.GetEndingDate);
          Page.Run(Page::"Res. Capacity Entries",ResCapacityEntry);
        end else begin
          TimeSheetHeader.SetRange("Starting Date",TimeSheetChartSetup."Starting Date");
          TimeSheetHeader.SetRange("Resource No.",ResourceNo);
          if TimeSheetHeader.FindFirst then
            if CurrMeasureType = Measuretype::Posted then begin
              TimeSheetPostingEntry.FilterGroup(2);
              TimeSheetPostingEntry.SetRange("Time Sheet No.",TimeSheetHeader."No.");
              TimeSheetPostingEntry.FilterGroup(0);
              Page.Run(Page::"Time Sheet Posting Entries",TimeSheetPostingEntry);
            end else begin
              TimeSheetMgt.SetTimeSheetNo(TimeSheetHeader."No.",TimeSheetLine);
              case TimeSheetChartSetup."Show by" of
                TimeSheetChartSetup."show by"::Status:
                  TimeSheetLine.SetRange(Status,CurrMeasureType);
                TimeSheetChartSetup."show by"::Type:
                  TimeSheetLine.SetRange(Type,BusChartBuf."Drill-Down Measure Index" + 1);
              end;
              Page.Run(Page::"Manager Time Sheet",TimeSheetLine);
            end;
        end;
    end;

    local procedure AddColumns(var BusChartBuf: Record "Business Chart Buffer")
    var
        UserSetup: Record "User Setup";
        Resource: Record Resource;
    begin
        if not UserSetup.Get(UserId) then
          exit;

        Resource.SetRange("Use Time Sheet",true);
        if not UserSetup."Time Sheet Admin." then
          Resource.SetRange("Time Sheet Approver User ID",UserId);
        if Resource.FindSet then
          repeat
            BusChartBuf.AddColumn(Resource."No.");
          until Resource.Next = 0;
    end;

    local procedure AddMeasures(var BusChartBuf: Record "Business Chart Buffer";TimeSheetChartSetup: Record "Time Sheet Chart Setup")
    begin
        with BusChartBuf do begin
          case TimeSheetChartSetup."Show by" of
            TimeSheetChartSetup."show by"::Status:
              begin
                AddMeasure(GetMeasureCaption(Measuretype::Open),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::Submitted),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::Rejected),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::Approved),'',"data type"::Decimal,"chart type"::StackedColumn);
              end;
            TimeSheetChartSetup."show by"::Type:
              begin
                AddMeasure(GetMeasureCaption(Measuretype::Resource),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::Job),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::Service),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::Absence),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::"Assembly Order"),'',"data type"::Decimal,"chart type"::StackedColumn);
              end;
            TimeSheetChartSetup."show by"::Posted:
              begin
                AddMeasure(GetMeasureCaption(Measuretype::Posted),'',"data type"::Decimal,"chart type"::StackedColumn);
                AddMeasure(GetMeasureCaption(Measuretype::"Not Posted"),'',"data type"::Decimal,"chart type"::StackedColumn);
              end;
          end;
          AddMeasure(GetMeasureCaption(Measuretype::Scheduled),'',"data type"::Decimal,"chart type"::Point);
        end;
    end;


    procedure CalcAmount(TimeSheetChartSetup: Record "Time Sheet Chart Setup";ResourceNo: Code[249];MType: Integer): Decimal
    var
        Resource: Record Resource;
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetPostingEntry: Record "Time Sheet Posting Entry";
    begin
        if MType = Measuretype::Scheduled then begin
          Resource.Get(ResourceNo);
          Resource.SetRange("Date Filter",TimeSheetChartSetup."Starting Date",TimeSheetChartSetup.GetEndingDate);
          Resource.CalcFields(Capacity);
          exit(Resource.Capacity);
        end;

        TimeSheetHeader.SetRange("Starting Date",TimeSheetChartSetup."Starting Date");
        TimeSheetHeader.SetRange("Resource No.",ResourceNo);
        if not TimeSheetHeader.FindFirst then
          exit(0);

        case TimeSheetChartSetup."Show by" of
          TimeSheetChartSetup."show by"::Status:
            begin
              // status option is the same with MType here
              TimeSheetHeader.SetRange("Status Filter",MType);
              TimeSheetHeader.CalcFields(Quantity);
              exit(TimeSheetHeader.Quantity);
            end;
          TimeSheetChartSetup."show by"::Type:
            begin
              TimeSheetHeader.SetRange("Type Filter",MType - 6);
              TimeSheetHeader.CalcFields(Quantity);
              exit(TimeSheetHeader.Quantity);
            end;
          TimeSheetChartSetup."show by"::Posted:
            begin
              TimeSheetPostingEntry.SetCurrentkey("Time Sheet No.","Time Sheet Line No.");
              TimeSheetPostingEntry.SetRange("Time Sheet No.",TimeSheetHeader."No.");
              TimeSheetPostingEntry.CalcSums(Quantity);
              TimeSheetHeader.CalcFields(Quantity);
              case MType of
                Measuretype::Posted:
                  exit(TimeSheetPostingEntry.Quantity);
                Measuretype::"Not Posted":
                  exit(TimeSheetHeader.Quantity - TimeSheetPostingEntry.Quantity);
              end;
            end;
        end;
    end;


    procedure GetMeasureCaption(Type: Option): Text
    var
        TimeSheetChartSetup: Record "Time Sheet Chart Setup";
    begin
        TimeSheetChartSetup.Init;
        TimeSheetChartSetup."Measure Type" := Type;
        exit(Format(TimeSheetChartSetup."Measure Type"));
    end;
}

