#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5098 "To-do Card"
{
    Caption = 'To-do Card';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "To-do";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the to-do.';
                }
                field(Description;Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the description of the to-do.';
                }
                field(Location;Location)
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = LocationEnable;
                    ToolTip = 'Specifies the location where the meeting will take place.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code of the salesperson assigned to the to-do.';

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field("No. of Attendees";"No. of Attendees")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = NoOfAttendeesEnable;
                    ToolTip = 'Specifies the number of attendees for the meeting. click the field to view the Attendee Scheduling card.';

                    trigger OnDrillDown()
                    begin
                        Modify;
                        Commit;
                        Page.RunModal(Page::"Attendee Scheduling",Rec);
                        Get("No.");
                        CurrPage.Update;
                    end;
                }
                field("Attendees Accepted No.";"Attendees Accepted No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = AttendeesAcceptedNoEnable;
                    ToolTip = 'Specifies the number of attendees that have confirmed their participation in the meeting.';

                    trigger OnDrillDown()
                    begin
                        Modify;
                        Commit;
                        Page.RunModal(Page::"Attendee Scheduling",Rec);
                        Get("No.");
                        CurrPage.Update;
                    end;
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = ContactNoEditable;
                    ToolTip = 'Specifies the number of the contact linked to the to-do.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Todo: Record "To-do";
                        Cont: Record Contact;
                    begin
                        if Type = Type::Meeting then begin
                          Todo.SetRange("No.","No.");
                          Page.RunModal(Page::"Attendee Scheduling",Todo);
                        end else begin
                          if Cont.Get("Contact No.") then;
                          if Page.RunModal(0,Cont) = Action::LookupOK then begin
                            Validate("Contact No.",Cont."No.");
                            CurrPage.Update;
                          end;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        ContactNoOnAfterValidate;
                    end;
                }
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    HideValue = ContactNameHideValue;
                    ToolTip = 'Specifies the name of the contact to which this to-do has been assigned.';
                }
                field("Contact Company Name";"Contact Company Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    HideValue = ContactCompanyNameHideValue;
                    ToolTip = 'Specifies the name of the company for which the contact involved in the to-do works.';
                }
                field("Team Code";"Team Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code of the team to which the to-do is assigned.';

                    trigger OnValidate()
                    begin
                        TeamCodeOnAfterValidate;
                    end;
                }
                field("Completed By";"Completed By")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = CompletedByEditable;
                    Enabled = CompletedByEnable;
                    ToolTip = 'Specifies the salesperson who completed this team to-do.';

                    trigger OnValidate()
                    begin
                        SwitchCardControls
                    end;
                }
                field(Status;Status)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the status of the to-do. There are five options: Not Started, In Progress, Completed, Waiting and Postponed.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the priority of the to-do. There are three options:';
                }
                field(Type;Type)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the type of the to-do.';

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
                }
                field(AllDayEvent;"All Day Event")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'All Day Event';
                    Enabled = AllDayEventEnable;
                    ToolTip = 'Specifies that the to-do of the Meeting type is an all-day event, which is an activity that lasts 24 hours or longer.';

                    trigger OnValidate()
                    begin
                        AllDayEventOnAfterValidate;
                    end;
                }
                field(Date;Date)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date when the to-do should be started. There are certain rules for how dates should be entered found in How to: Enter Dates and Times.';
                }
                field(StartTime;"Start Time")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = StartTimeEnable;
                    ToolTip = 'Specifies the time when the to-do of the Meeting type should be started.';
                }
                field(Duration;Duration)
                {
                    ApplicationArea = RelationshipMgmt;
                    BlankZero = true;
                    Enabled = DurationEnable;
                    ToolTip = 'Specifies the duration of the to-do of the Meeting type.';
                }
                field(EndingDate;"Ending Date")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Ending Date';
                    ToolTip = 'Specifies the date of when the to-do should end. There are certain rules for how dates should be entered. For more information, see How to: Enter Dates and Times.';
                }
                field(EndingTime;"Ending Time")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Ending Time';
                    Enabled = EndingTimeEnable;
                    ToolTip = 'Specifies the time of when the to-do of the Meeting type should end.';
                }
                field(Canceled;Canceled)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the to-do has been canceled.';

                    trigger OnValidate()
                    begin
                        SwitchCardControls
                    end;
                }
                field(Closed;Closed)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the to-do is closed.';

                    trigger OnValidate()
                    begin
                        SwitchCardControls
                    end;
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date the to-do was closed.';
                }
            }
            group("Related Activities")
            {
                Caption = 'Related Activities';
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the campaign to which the to-do is linked.';

                    trigger OnValidate()
                    begin
                        CampaignNoOnAfterValidate;
                    end;
                }
                field("Campaign Description";"Campaign Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the description of the campaign to which the to-do is linked.';
                }
                field("Opportunity No.";"Opportunity No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the opportunity to which the to-do is linked.';

                    trigger OnValidate()
                    begin
                        OpportunityNoOnAfterValidate;
                    end;
                }
                field("Opportunity Description";"Opportunity Description")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    ToolTip = 'Specifies a description of the opportunity related to the to-do. The description is copied from the opportunity card.';
                }
            }
            group(Recurring)
            {
                Caption = 'Recurring';
                field(Control39;Recurring)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the to-do occurs periodically.';

                    trigger OnValidate()
                    begin
                        RecurringOnPush;
                    end;
                }
                field("Recurring Date Interval";"Recurring Date Interval")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = RecurringDateIntervalEditable;
                    Enabled = RecurringDateIntervalEnable;
                    ToolTip = 'Specifies the date formula to assign automatically a recurring to-do to a salesperson or team.';
                }
                field("Calc. Due Date From";"Calc. Due Date From")
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = CalcDueDateFromEditable;
                    Enabled = CalcDueDateFromEnable;
                    ToolTip = 'Specifies the date to use to calculate the date on which the next to-do should be completed.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("To-&do")
            {
                Caption = 'To-&do';
                Image = Task;
                action("Co&mment")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mment';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name"=const("To-do"),
                                  "No."=field("Organizer To-do No."),
                                  "Sub No."=const(0);
                    ToolTip = 'View or add comments.';
                }
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "To-do No."=field("Organizer To-do No.");
                    RunPageView = sorting("To-do No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View interaction log entries for the to-do.';
                }
                action("Postponed &Interactions")
                {
                    ApplicationArea = Basic;
                    Caption = 'Postponed &Interactions';
                    Image = PostponedInteractions;
                    RunObject = Page "Postponed Interactions";
                    RunPageLink = "To-do No."=field("Organizer To-do No.");
                    RunPageView = sorting("To-do No.");
                    ToolTip = 'View postponed interactions for the to-do.';
                }
                action("A&ttendee Scheduling")
                {
                    ApplicationArea = Basic;
                    Caption = 'A&ttendee Scheduling';
                    Image = ProfileCalender;
                    ToolTip = 'View the status of a scheduled meeting.';

                    trigger OnAction()
                    begin
                        if Type <> Type::Meeting then
                          Error(Text003,Format(Type));

                        Page.RunModal(Page::"Attendee Scheduling",Rec);
                    end;
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Assign Activities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Assign Activities';
                    Image = Allocate;
                    ToolTip = 'View all the to-dos that have been assigned to salespeople and teams. A to-do can be organizing meetings, making phone calls, and so on.';

                    trigger OnAction()
                    var
                        TempToDo: Record "To-do" temporary;
                    begin
                        TempToDo.AssignActivityFromToDo(Rec)
                    end;
                }
                action("Make &Phone Call")
                {
                    ApplicationArea = Basic;
                    Caption = 'Make &Phone Call';
                    Image = Calls;
                    ToolTip = 'Call the selected contact.';

                    trigger OnAction()
                    var
                        SegmentLine: Record "Segment Line" temporary;
                    begin
                        if "Contact No." = '' then begin
                          if (Type = Type::Meeting) and ("Team Code" = '') then
                            Error(Text005);
                          Error(Text006);
                        end;
                        SegmentLine."To-do No." := "No.";
                        SegmentLine."Contact No." := "Contact No.";
                        SegmentLine."Contact Company No." := "Contact Company No.";
                        SegmentLine."Campaign No." := "Campaign No.";
                        SegmentLine.CreateCall;
                    end;
                }
            }
            action("&Create To-do")
            {
                ApplicationArea = Basic;
                Caption = '&Create To-do';
                Image = NewToDo;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create a new to-do.';

                trigger OnAction()
                var
                    TempToDo: Record "To-do" temporary;
                begin
                    TempToDo.CreateToDoFromToDo(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        ContactCompanyNameHideValue := false;
        ContactNameHideValue := false;
        SwitchCardControls;
        if "No." <> "Organizer To-do No." then
          CurrPage.Editable := false
        else
          CurrPage.Editable := true;
        SetRecurringEditable;
        EnableFields;
        ContactNoOnFormat(Format("Contact No."));
        ContactNameOnFormat;
        ContactCompanyNameOnFormat;
    end;

    trigger OnInit()
    begin
        CalcDueDateFromEnable := true;
        RecurringDateIntervalEnable := true;
        CompletedByEnable := true;
        AttendeesAcceptedNoEnable := true;
        NoOfAttendeesEnable := true;
        AllDayEventEnable := true;
        LocationEnable := true;
        DurationEnable := true;
        EndingTimeEnable := true;
        StartTimeEnable := true;
        CompletedByEditable := true;
        CalcDueDateFromEditable := true;
        RecurringDateIntervalEditable := true;
        ContactNoEditable := true;
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if ("Team Code" = '') and ("Salesperson Code" = '') then
          Error(
            Text000,TableCaption,FieldCaption("Salesperson Code"),FieldCaption("Team Code"));

        if (Type = Type::Meeting) and (not "All Day Event") then begin
          if "Start Time" = 0T then
            Error(Text002,TableCaption,Type,FieldCaption("Start Time"));
          if Duration = 0 then
            Error(Text002,TableCaption,Type,FieldCaption(Duration));
        end;
    end;

    trigger OnOpenPage()
    begin
        if GetFilter("No.") = '' then
          CurrPage.Editable := false;
    end;

    var
        Text000: label 'The %1 will always have either the %2 or %3 assigned.';
        Text002: label 'The %1 of the %2 type must always have the %3 assigned.';
        Text003: label 'You cannot select attendees for a to-do of the ''%1'' type.';
        Text005: label 'The Make Phone Call function for this to-do is available only in the Attendee Scheduling window.';
        Text006: label 'You must assign a contact to this to-do before you can use the Make Phone Call function.';
        Text007: label '(Multiple)';
        [InDataSet]
        ContactNameHideValue: Boolean;
        [InDataSet]
        ContactCompanyNameHideValue: Boolean;
        [InDataSet]
        ContactNoEditable: Boolean;
        [InDataSet]
        RecurringDateIntervalEditable: Boolean;
        [InDataSet]
        CalcDueDateFromEditable: Boolean;
        [InDataSet]
        CompletedByEditable: Boolean;
        [InDataSet]
        StartTimeEnable: Boolean;
        [InDataSet]
        EndingTimeEnable: Boolean;
        [InDataSet]
        DurationEnable: Boolean;
        [InDataSet]
        LocationEnable: Boolean;
        [InDataSet]
        AllDayEventEnable: Boolean;
        [InDataSet]
        NoOfAttendeesEnable: Boolean;
        [InDataSet]
        AttendeesAcceptedNoEnable: Boolean;
        [InDataSet]
        CompletedByEnable: Boolean;
        [InDataSet]
        RecurringDateIntervalEnable: Boolean;
        [InDataSet]
        CalcDueDateFromEnable: Boolean;


    procedure SetRecurringEditable()
    begin
        RecurringDateIntervalEditable := Recurring;
        CalcDueDateFromEditable := Recurring;
    end;

    local procedure EnableFields()
    begin
        RecurringDateIntervalEnable := Recurring;
        CalcDueDateFromEnable := Recurring;

        if not Recurring then begin
          Evaluate("Recurring Date Interval",'');
          Clear("Calc. Due Date From");
        end;

        if Type = Type::Meeting then begin
          StartTimeEnable := not "All Day Event";
          EndingTimeEnable := not "All Day Event";
          DurationEnable := not "All Day Event";
          LocationEnable := true;
          AllDayEventEnable := true;
        end else begin
          StartTimeEnable := false;
          EndingTimeEnable := false;
          LocationEnable := false;
          DurationEnable := false;
          AllDayEventEnable := false;
        end;

        GetEndDateTime;
    end;

    local procedure SwitchCardControls()
    begin
        if Type = Type::Meeting then begin
          ContactNoEditable := false;

          NoOfAttendeesEnable := true;
          AttendeesAcceptedNoEnable := true;
        end else begin
          ContactNoEditable := true;

          NoOfAttendeesEnable := false;
          AttendeesAcceptedNoEnable := false;
        end;
        if "Team Code" = '' then
          CompletedByEnable := false
        else begin
          CompletedByEnable := true;
          CompletedByEditable := not Closed
        end
    end;

    local procedure TeamCodeOnAfterValidate()
    begin
        SwitchCardControls;
        CalcFields(
          "No. of Attendees",
          "Attendees Accepted No.",
          "Contact Name",
          "Contact Company Name",
          "Campaign Description",
          "Opportunity Description")
    end;

    local procedure ContactNoOnAfterValidate()
    begin
        CalcFields("Contact Name","Contact Company Name");
    end;

    local procedure TypeOnAfterValidate()
    begin
        EnableFields;
    end;

    local procedure AllDayEventOnAfterValidate()
    begin
        EnableFields;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        SwitchCardControls;
        CalcFields(
          "No. of Attendees",
          "Attendees Accepted No.",
          "Contact Name",
          "Contact Company Name",
          "Campaign Description",
          "Opportunity Description");
    end;

    local procedure CampaignNoOnAfterValidate()
    begin
        CalcFields("Campaign Description");
    end;

    local procedure OpportunityNoOnAfterValidate()
    begin
        CalcFields("Opportunity Description");
    end;

    local procedure RecurringOnPush()
    begin
        SetRecurringEditable;
    end;

    local procedure ContactNoOnFormat(Text: Text[1024])
    begin
        if Type = Type::Meeting then
          Text := Text007;
    end;

    local procedure ContactNameOnFormat()
    begin
        if Type = Type::Meeting then
          ContactNameHideValue := true;
    end;

    local procedure ContactCompanyNameOnFormat()
    begin
        if Type = Type::Meeting then
          ContactCompanyNameHideValue := true;
    end;
}

