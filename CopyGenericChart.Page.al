#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9187 "Copy Generic Chart"
{
    Caption = 'Copy Generic Chart';
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = StandardDialog;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            field(NewChartID;NewChartID)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'New Chart ID';
                ToolTip = 'Specifies the ID of the new chart that you copy information to.';
            }
            field(NewChartTitle;NewChartTitle)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'New Chart Title';
                ToolTip = 'Specifies the name of the new chart that you copy information to.';
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        GenericChartMgt: Codeunit "Generic Chart Mgt";
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then begin
          ValidateUserInput;
          GenericChartMgt.CopyChart(SourceChart,NewChartID,NewChartTitle);
          Message(Text001);
        end
    end;

    var
        SourceChart: Record Chart;
        NewChartID: Code[20];
        NewChartTitle: Text[50];
        Text001: label 'The chart was successfully copied.';
        Text002: label 'Specify a chart ID.';

    local procedure ValidateUserInput()
    begin
        if NewChartID = '' then
          Error(Text002);
    end;


    procedure SetSourceChart(SourceChartInput: Record Chart)
    begin
        SourceChart := SourceChartInput;
        CurrPage.Caption(CurrPage.Caption + ' ' + SourceChart.ID);
    end;
}

