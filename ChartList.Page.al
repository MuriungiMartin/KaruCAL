#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1391 "Chart List"
{
    Caption = 'Key Performance Indicators';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Chart Definition";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Chart Name";"Chart Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Chart Name';
                    Editable = false;
                    ToolTip = 'Specifies the name of the chart.';
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies that the chart is enabled.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if (CloseAction = Action::LookupOK) and not Enabled then
          Dialog.Error(DisabledChartSelectedErr);
    end;

    var
        DisabledChartSelectedErr: label 'The chart that you selected is disabled and cannot be opened on the role center. Enable the selected chart or select another chart.';
}

