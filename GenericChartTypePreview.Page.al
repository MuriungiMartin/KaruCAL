#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9184 "Generic Chart Type Preview"
{
    Caption = 'Generic Chart Type Preview';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = CardPart;

    layout
    {
        area(content)
        {
            usercontrol(Chart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic,Suite;

                trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    ChartAddInInitialized := true
                end;

                trigger Refresh()
                begin
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        ChartAddInInitialized := false
    end;

    var
        Text000: label 'Sample Chart Data', Comment='Sample Chart Data';
        Text003: label 'Cat', Comment='Cat';
        ChartAddInInitialized: Boolean;


    procedure SetChartDefinition(chartBuilder: dotnet BusinessChartBuilder)
    var
        GenericChartYAxis: Record "Generic Chart Y-Axis";
        chartDefinition: dotnet BusinessChartData;
        chartDataTable: dotnet DataTable;
        chartDataRow: dotnet DataRow;
        dataType: dotnet Type;
        i: Integer;
        j: Integer;
        measureName: Text;
    begin
        if not ChartAddInInitialized then
          exit;

        chartDefinition := chartDefinition.BusinessChartData;
        chartDataTable := chartDataTable.DataTable(Text000);
        // chartBuilder -> chartDef
        if chartBuilder.HasXDimension then begin
          chartDataTable.Columns.Add(chartBuilder.XDimensionName,dataType.GetType('System.String'));
          chartDefinition.XDimension := chartBuilder.XDimensionName;
        end;

        if chartBuilder.HasZDimension then begin
          chartDataTable.Columns.Add(chartBuilder.ZDimensionName,dataType.GetType('System.String'));
          chartDefinition.ZDimension := chartBuilder.ZDimensionName;
        end;

        for i := 0 to chartBuilder.MeasureCount - 1 do begin
          measureName := chartBuilder.GetMeasureName(i);
          if measureName = '' then
            measureName := Format(GenericChartYAxis.Aggregation::Count);
          chartDataTable.Columns.Add(measureName,dataType.GetType('System.Decimal'));
          chartDefinition.AddMeasure(measureName,chartBuilder.GetMeasureChartType(i));
        end;

        for i := 0 to 10 do begin
          chartDataRow := chartDataTable.NewRow;
          if chartBuilder.HasXDimension and (chartBuilder.XDimensionName <> '') then
            chartDataRow.Item(chartBuilder.XDimensionName,Text003 + Format(i));
          if chartBuilder.HasZDimension and (chartBuilder.ZDimensionName <> '') then
            chartDataRow.Item(chartBuilder.ZDimensionName,Text003 + Format(i));
          for j := 0 to chartBuilder.MeasureCount - 1 do begin
            measureName := chartBuilder.GetMeasureName(j);
            if measureName = '' then
              measureName := Format(GenericChartYAxis.Aggregation::Count);
            chartDataRow.Item(measureName,Random(100));
          end;
          chartDataTable.Rows.Add(chartDataRow);
        end;

        chartDefinition.DataTable := chartDataTable;
        CurrPage.Chart.Update(chartDefinition)
    end;
}

