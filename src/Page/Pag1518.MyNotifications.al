#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1518 "My Notifications"
{
    ApplicationArea = Basic;
    Caption = 'My Notifications';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    Permissions = TableData "My Notifications"=rimd;
    SourceTable = "My Notifications";
    UsageCategory = Documents;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the short name of the notification. To see a description of the notfication, choose the name.';

                    trigger OnDrillDown()
                    begin
                        Message(GetDescription);
                    end;
                }
                field(Enabled;Enabled)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        if Enabled <> xRec.Enabled then begin
                          Filters := GetFiltersAsDisplayText;
                          CurrPage.Update;
                        end;
                    end;
                }
                field(Filters;Filters)
                {
                    ApplicationArea = All;
                    Caption = 'Conditions';
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        if OpenFilterSettings then begin
                          Filters := GetFiltersAsDisplayText;
                          CurrPage.Update;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        Filters := GetFiltersAsDisplayText;
    end;

    trigger OnOpenPage()
    begin
        OnInitializingNotificationWithDefaultState;
    end;

    var
        Filters: Text;


    procedure InitializeNotificationsWithDefaultState()
    begin
        OnInitializingNotificationWithDefaultState;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInitializingNotificationWithDefaultState()
    begin
    end;
}

