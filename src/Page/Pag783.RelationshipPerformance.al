#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 783 "Relationship Performance"
{
    Caption = 'Top 5 Opportunities';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            field(StatusText;StatusText)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Status Text';
                Enabled = false;
                ShowCaption = false;
                Style = StrongAccent;
                StyleExpr = true;
                ToolTip = 'Specifies the status of the chart.';
                Visible = false;
            }
            usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = RelationshipMgmt;

                trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                begin
                    BusinessChartBuffer.SetDrillDownIndexes(point);
                    RlshpPerformanceMgt.DrillDown(BusinessChartBuffer,TempOpportunity);
                end;

                trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    IsChartAddInReady := true;
                    UpdateChart;
                end;

                trigger Refresh()
                begin
                    if IsChartAddInReady then
                      UpdateChart;
                end;
            }
        }
    }

    actions
    {
    }

    var
        BusinessChartBuffer: Record "Business Chart Buffer";
        TempOpportunity: Record Opportunity temporary;
        RlshpPerformanceMgt: Codeunit "Relationship Performance Mgt.";
        StatusText: Text;
        IsChartAddInReady: Boolean;

    local procedure UpdateChart()
    begin
        if not IsChartAddInReady then
          exit;

        RlshpPerformanceMgt.UpdateData(BusinessChartBuffer,TempOpportunity);
        BusinessChartBuffer.Update(CurrPage.BusinessChart);
    end;
}

