#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1512 "Notification Setup"
{
    ApplicationArea = Basic;
    Caption = 'Notification Setup';
    PageType = List;
    RefreshOnActivate = true;
    ShowFilter = false;
    SourceTable = "Notification Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Notification Type";"Notification Type")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies what type of event the notification is about.';
                }
                field("Notification Method";"Notification Method")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the notification method that is used to create notifications for the user.';
                }
                field(Schedule;Schedule)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    ToolTip = 'Specifies when the user receives notifications. The value is copied from the Recurrence field in the Notification Schedule window.';
                }
                field("Display Target";"Display Target")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the preferred display target of the notification.';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Notification Schedule")
            {
                ApplicationArea = Suite;
                Caption = 'Notification Schedule';
                Image = DateRange;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Notification Schedule";
                RunPageLink = "User ID"=field("User ID"),
                              "Notification Type"=field("Notification Type");
                ToolTip = 'Specify when the user receives notifications. The value is copied from the Recurrence field in the Notification Schedule window.';
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "User ID" := CleanWebFilter(GetFilter("User ID"));
    end;

    trigger OnOpenPage()
    begin
        if not HasFilter then
          SetRange("User ID",'');
    end;

    local procedure CleanWebFilter(FilterString: Text): Text[50]
    begin
        exit(DelChr(FilterString,'=','*|@|'''));
    end;
}

