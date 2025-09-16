#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5139 "Logged Segments"
{
    ApplicationArea = Basic;
    Caption = 'Logged Segments';
    Editable = false;
    PageType = List;
    SourceTable = "Logged Segment";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Canceled;Canceled)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the interaction has been canceled.';
                }
                field("Entry No.";"Entry No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the entry number of the logged segment.';
                }
                field("Creation Date";"Creation Date")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date on which the segment was logged.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the ID of the user who created or logged the interaction and segment. The program automatically fills in this field when the segment is logged.';
                }
                field("Segment No.";"Segment No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the segment to which the logged segment is linked. The program fills in this field by copying the contents of the No. field in the Segment window.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the interaction.';
                }
                field("No. of Interactions";"No. of Interactions")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of interactions recorded for the logged segment. To see a list of the created interactions, click the field.';
                }
                field("No. of Campaign Entries";"No. of Campaign Entries")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of campaign entries that were recorded when you logged the segment. To see a list of the recorded campaign entries, click the field.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207;Links)
            {
                Visible = false;
            }
            systempart(Control1905767507;Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Logged Segment")
            {
                Caption = '&Logged Segment';
                Image = Entry;
                action("Interaction Log E&ntry")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntry';
                    Image = Interaction;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Logged Segment Entry No."=field("Entry No.");
                    RunPageView = sorting("Logged Segment Entry No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
                action("&Campaign Entry")
                {
                    ApplicationArea = Basic;
                    Caption = '&Campaign Entry';
                    Image = CampaignEntries;
                    RunObject = Page "Campaign Entries";
                    RunPageLink = "Register No."=field("Entry No.");
                    RunPageView = sorting("Register No.");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Switch Check&mark in Canceled")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Switch Check&mark in Canceled';
                    Image = ReopenCancelled;
                    ToolTip = 'Change records that have a checkmark in Canceled.';

                    trigger OnAction()
                    begin
                        CurrPage.SetSelectionFilter(LoggedSegment);
                        LoggedSegment.ToggleCanceledCheckmark;
                    end;
                }
                action(Resend)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Resend';
                    Ellipsis = true;
                    Image = Reuse;
                    ToolTip = 'Send attachments that were not sent when you initially logged a segment or interaction.';

                    trigger OnAction()
                    var
                        InteractLogEntry: Record "Interaction Log Entry";
                    begin
                        InteractLogEntry.SetRange("Logged Segment Entry No.","Entry No.");
                        Report.Run(Report::"Resend Attachments",true,false,InteractLogEntry);
                    end;
                }
            }
        }
    }

    var
        LoggedSegment: Record "Logged Segment";
}

