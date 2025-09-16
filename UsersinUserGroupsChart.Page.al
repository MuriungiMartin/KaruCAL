#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 773 "Users in User Groups Chart"
{
    Caption = 'Users in User Groups';
    PageType = CardPart;
    SourceTable = "Business Chart Buffer";

    layout
    {
        area(content)
        {
            field(StatusText;StatusText)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Status Text';
                ShowCaption = false;
                ToolTip = 'Specifies the status of the chart.';
            }
            usercontrol(BusinessChart;"Microsoft.Dynamics.Nav.Client.BusinessChart")
            {
                ApplicationArea = Basic,Suite;

                trigger DataPointClicked(point: dotnet BusinessChartDataPoint)
                var
                    UserGroupMember: Record "User Group Member";
                begin
                    UserGroupMember.SetRange("User Group Code",point.XValueString);
                    if not UserGroupMember.FindFirst then
                      exit;
                    Page.RunModal(Page::"User Group Members",UserGroupMember);
                    CurrPage.Update; // refresh the charts with the eventual changes
                end;

                trigger DataPointDoubleClicked(point: dotnet BusinessChartDataPoint)
                begin
                end;

                trigger AddInReady()
                begin
                    if IsChartDataReady then
                      UpdateChart;
                end;

                trigger Refresh()
                begin
                    if IsChartDataReady then
                      UpdateChart;
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnFindRecord(Which: Text): Boolean
    begin
        UpdateChart;
        IsChartDataReady := true;
    end;

    var
        StatusText: Text[250];
        IsChartDataReady: Boolean;
        UsersTxt: label 'Users';
        UserGroupTxt: label 'User Group';

    local procedure UpdateChart()
    begin
        UpdateData;
        Update(CurrPage.BusinessChart);
    end;

    local procedure UpdateData()
    var
        UsersInUserGroups: Query "Users in User Groups";
        ColumnNumber: Integer;
    begin
        Initialize; // Initialize .NET variables for the chart

        // Define Y-Axis
        AddMeasure(UsersTxt,1,"data type"::Integer,"chart type"::Column);

        // Define X-Axis
        SetXAxis(UserGroupTxt,"data type"::String);

        if not UsersInUserGroups.Open then
          exit;

        while UsersInUserGroups.Read do begin
          // Add data to the chart
          AddColumn(Format(UsersInUserGroups.UserGroupCode)); // X-Axis data
          SetValue(UsersTxt,ColumnNumber,UsersInUserGroups.NumberOfUsers); // Y-Axis data
          ColumnNumber += 1;
        end;
        IsChartDataReady := true;
    end;
}

