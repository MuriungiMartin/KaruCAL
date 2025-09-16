#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 710 "Activity Log"
{
    Caption = 'Activity Log';
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Activity Log";
    SourceTableView = sorting("Activity Date")
                      order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Activity Date";"Activity Date")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the data of the activity.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user who performs the activity.';
                }
                field(Context;Context)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the context in which the activity occurred.';
                }
                field(Status;Status)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status of the activity.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the activity.';
                }
                field("Activity Message";"Activity Message")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the status or error message for the activity.';
                }
                field(HasDetailedInfo;HasDetailedInfo)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Detailed Info Available';
                    ToolTip = 'Specifies if detailed activity log details exist. If so, choose the View Details action.';

                    trigger OnDrillDown()
                    begin
                        Export('',true);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenRelatedRecord)
            {
                ApplicationArea = Suite;
                Caption = 'Open Related Record';
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Open the record that is associated with this activity.';

                trigger OnAction()
                var
                    PageManagement: Codeunit "Page Management";
                begin
                    if not PageManagement.PageRun("Record ID") then
                      Message(NoRelatedRecordMsg);
                end;
            }
            action(ViewDetails)
            {
                ApplicationArea = Suite;
                Caption = 'View Details';
                Ellipsis = true;
                Image = GetSourceDoc;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Show more information about this activity.';

                trigger OnAction()
                begin
                    Export('',true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        HasDetailedInfo := "Detailed Info".Hasvalue;
    end;

    trigger OnAfterGetRecord()
    begin
        HasDetailedInfo := "Detailed Info".Hasvalue;
    end;

    trigger OnOpenPage()
    begin
        SetAutocalcFields("Detailed Info");
    end;

    var
        HasDetailedInfo: Boolean;
        NoRelatedRecordMsg: label 'There are no related records to display.';
}

