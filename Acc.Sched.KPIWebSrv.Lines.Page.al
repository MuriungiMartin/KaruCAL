#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 196 "Acc. Sched. KPI Web Srv. Lines"
{
    Caption = 'Account Schedule KPI Web Service Setup';
    PageType = ListPart;
    SourceTable = "Acc. Sched. KPI Web Srv. Line";

    layout
    {
        area(content)
        {
            repeater(Control13)
            {
                field("Acc. Schedule Name";"Acc. Schedule Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the account schedule that the KPI web service is based on. To view or edit the selected account schedule, choose the Edit Account Schedule button.';
                }
                field("Acc. Schedule Description";"Acc. Schedule Description")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the account schedule that the KPI web service is based on.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(EditAccSchedule)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Edit Account Schedule';
                ToolTip = 'Opens the Account Schedule window so that you can modify the account schedule.';

                trigger OnAction()
                var
                    AccSchedule: Page "Account Schedule";
                begin
                    AccSchedule.SetAccSchedName("Acc. Schedule Name");
                    AccSchedule.Run;
                end;
            }
        }
    }
}

