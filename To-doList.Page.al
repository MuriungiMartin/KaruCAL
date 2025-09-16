#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5096 "To-do List"
{
    Caption = 'To-do List';
    CardPageID = "To-do Card";
    DataCaptionExpression = Caption;
    Editable = false;
    PageType = List;
    SourceTable = "To-do";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                Editable = false;
                field(Closed;Closed)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the to-do is closed.';
                }
                field(Date;Date)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date when the to-do should be started. There are certain rules for how dates should be entered found in How to: Enter Dates and Times.';
                }
                field(Type;Type)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the type of the to-do.';
                }
                field(Description;Description)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the description of the to-do.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the priority of the to-do. There are three options:';
                }
                field(Status;Status)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the status of the to-do. There are five options: Not Started, In Progress, Completed, Waiting and Postponed.';
                }
                field("Organizer To-do No.";"Organizer To-do No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the organizer''s to-do. The field is not editable.';
                }
                field("Date Closed";"Date Closed")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date the to-do was closed.';
                }
                field(Canceled;Canceled)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the to-do has been canceled.';
                }
                field(Comment;Comment)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that a comment has been assigned to the to-do.';
                }
                field("Contact No.";"Contact No.")
                {
                    ApplicationArea = RelationshipMgmt;
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
                          if Page.RunModal(0,Cont) = Action::LookupOK then;
                        end;
                    end;
                }
                field("Contact Company No.";"Contact Company No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the contact number of the company for which the contact involved in the to-do works.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code of the salesperson assigned to the to-do.';
                }
                field("Team Code";"Team Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code of the team to which the to-do is assigned.';
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the campaign to which the to-do is linked.';
                }
                field("Opportunity No.";"Opportunity No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the opportunity to which the to-do is linked.';
                }
                field("No.";"No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of the to-do.';
                }
            }
            group(Control55)
            {
                field("Contact Name";"Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Contact Name';
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the contact to which this to-do has been assigned.';
                }
                field("Contact Company Name";"Contact Company Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the company for which the contact involved in the to-do works.';
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
            group(Todo)
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
                    var
                        Todo: Record "To-do";
                    begin
                        Todo.Get("Organizer To-do No.");
                        Page.RunModal(Page::"Attendee Scheduling",Todo)
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
                        TempToDo.AssignActivityFromToDo(Rec);
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
                        SegLine: Record "Segment Line";
                        ContactNo: Code[10];
                        ContCompanyNo: Code[10];
                    begin
                        if "Contact No." <> '' then
                          ContactNo := "Contact No."
                        else
                          ContactNo := GetFilter("Contact No.");
                        if "Contact Company No." <> '' then
                          ContCompanyNo := "Contact Company No."
                        else
                          ContCompanyNo := GetFilter("Contact Company No.");
                        if ContactNo = '' then begin
                          if (Type = Type::Meeting) and ("Team Code" = '') then
                            Error(Text004);
                          Error(Text005);
                        end;
                        SegLine."To-do No." := "No.";
                        SegLine."Contact No." := ContactNo;
                        SegLine."Contact Company No." := ContCompanyNo;
                        SegLine."Campaign No." := "Campaign No.";

                        SegLine.CreateCall;
                    end;
                }
            }
            action("&Create To-do")
            {
                ApplicationArea = RelationshipMgmt;
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
            action("Edit Organizer To-Do")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Edit Organizer To-Do';
                Image = Edit;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Task Card";
                RunPageLink = "No."=field("Organizer To-do No.");
                ToolTip = 'View general information about the to-dos such as type, description, priority and status of the to-do, as well as the salesperson or team the to-do is assigned to.';
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("Contact Name","Contact Company Name");
    end;

    trigger OnAfterGetRecord()
    begin
        ContactNoOnFormat(Format("Contact No."));
    end;

    trigger OnFindRecord(Which: Text): Boolean
    begin
        RecordsFound := Find(Which);
        exit(RecordsFound);
    end;

    var
        Cont: Record Contact;
        Contact1: Record Contact;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        Campaign: Record Campaign;
        Team: Record Team;
        Opp: Record Opportunity;
        SegHeader: Record "Segment Header";
        RecordsFound: Boolean;
        Text000: label '(Multiple)';
        Text001: label 'untitled';
        Text004: label 'The Make Phone Call function for this to-do is available only on the Attendee Scheduling window.';
        Text005: label 'You must select a to-do with a contact assigned to it before you can use the Make Phone Call function.';

    local procedure Caption(): Text[260]
    var
        CaptionStr: Text[260];
    begin
        if Cont.Get(GetFilter("Contact Company No.")) then begin
          Contact1.Get(GetFilter("Contact Company No."));
          if Contact1."No." <> Cont."No." then
            CaptionStr := CopyStr(Cont."No." + ' ' + Cont.Name,1,MaxStrLen(CaptionStr));
        end;
        if Cont.Get(GetFilter("Contact No.")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + Cont."No." + ' ' + Cont.Name,1,MaxStrLen(CaptionStr));
        if SalesPurchPerson.Get(GetFilter("Salesperson Code")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + SalesPurchPerson.Code + ' ' + SalesPurchPerson.Name,1,MaxStrLen(CaptionStr));
        if Team.Get(GetFilter("Team Code")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + Team.Code + ' ' + Team.Name,1,MaxStrLen(CaptionStr));
        if Campaign.Get(GetFilter("Campaign No.")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + Campaign."No." + ' ' + Campaign.Description,1,MaxStrLen(CaptionStr));
        if Opp.Get(GetFilter("Opportunity No.")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + Opp."No." + ' ' + Opp.Description,1,MaxStrLen(CaptionStr));
        if SegHeader.Get(GetFilter("Segment No.")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + SegHeader."No." + ' ' + SegHeader.Description,1,MaxStrLen(CaptionStr));
        if CaptionStr = '' then
          CaptionStr := Text001;

        exit(CaptionStr);
    end;

    local procedure ContactNoOnFormat(Text: Text[1024])
    begin
        if Type = Type::Meeting then
          Text := Text000;
    end;
}

