#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5146 "Assign Activity"
{
    Caption = 'Assign Activity';
    DataCaptionExpression = Caption;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = Card;
    SourceTable = "To-do";

    layout
    {
        area(content)
        {
            group("Activity Setup")
            {
                Caption = 'Activity Setup';
                field("Activity Code";"Activity Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Activity Code';
                    TableRelation = Activity.Code;
                    ToolTip = 'Specifies a code for the to-do activity.';

                    trigger OnValidate()
                    begin
                        if not Activity.IncludesMeeting("Activity Code") then begin
                          TeamMeetingOrganizerEditable := false;
                          "Team Meeting Organizer" := ''
                        end else
                          if "Team Code" <> '' then begin
                            TeamMeetingOrganizerEditable := true;
                            "Team Meeting Organizer" := ''
                          end;
                    end;
                }
                field(Date;Date)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Activity Start Date';
                    ToolTip = 'Specifies the date when the to-do should be started. There are certain rules for how dates should be entered found in How to: Enter Dates and Times.';
                }
                field("Wizard Contact Name";"Wizard Contact Name")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Contact No.';
                    Editable = WizardContactNameEditable;
                    Lookup = false;
                    TableRelation = Contact;
                    ToolTip = 'Specifies a contact name from the wizard.';

                    trigger OnAssistEdit()
                    var
                        Cont: Record Contact;
                    begin
                        if ("Wizard Contact Name" = '') and not SegHeader.Get(GetFilter("Segment No.")) then begin
                          if Cont.Get("Contact No.") then ;
                          if Page.RunModal(0,Cont) = Action::LookupOK then begin
                            Validate("Contact No.",Cont."No.");
                            CurrPage.SetSelectionFilter(Rec);
                            "Wizard Contact Name" := Cont.Name;
                          end;
                        end;
                    end;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    Caption = 'Salesperson Code';
                    Editable = SalespersonCodeEditable;
                    ToolTip = 'Specifies the code of the salesperson assigned to the to-do.';

                    trigger OnValidate()
                    begin
                        if SalesPurchPerson.Get("Salesperson Code") then begin
                          TeamMeetingOrganizerEditable := false;
                          "Team Meeting Organizer" := '';
                          "Team Code" := ''
                        end else
                          if Activity.IncludesMeeting("Activity Code") or
                             ("Activity Code" = '') and
                             ("Team Code" <> '')
                          then
                            TeamMeetingOrganizerEditable := true
                    end;
                }
                field("Team Code";"Team Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Team Code';
                    Editable = TeamCodeEditable;
                    ToolTip = 'Specifies the code of the team to which the to-do is assigned.';

                    trigger OnValidate()
                    begin
                        if Team.Get("Team Code") then begin
                          if Activity.IncludesMeeting("Activity Code") then
                            TeamMeetingOrganizerEditable := true;
                          "Salesperson Code" := '';
                        end;
                        if "Team Code" = '' then begin
                          TeamMeetingOrganizerEditable := false;
                          "Team Meeting Organizer" := ''
                        end;
                    end;
                }
                field("Team Meeting Organizer";"Team Meeting Organizer")
                {
                    ApplicationArea = Basic;
                    Caption = 'Meeting Organizer';
                    Editable = TeamMeetingOrganizerEditable;
                    ToolTip = 'Specifies who on the team is the organizer of the to-do. You can modify the value in this field with the appropriate name when the to-do is for a team.';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Salesperson: Record "Salesperson/Purchaser";
                        SalesPurchPerson: Page "Salespersons/Purchasers";
                    begin
                        SalesPurchPerson.LookupMode := true;
                        if SalesPurchPerson.RunModal = Action::LookupOK then begin
                          SalesPurchPerson.GetRecord(Salesperson);
                          if TeamMeetingOrganizerEditable then
                            "Team Meeting Organizer" := Salesperson.Code
                        end;
                    end;

                    trigger OnValidate()
                    var
                        SalesPurchPerson: Record "Salesperson/Purchaser";
                    begin
                        SalesPurchPerson.Get("Team Meeting Organizer");
                    end;
                }
                field("Wizard Campaign Description";"Wizard Campaign Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Campaign';
                    Importance = Additional;
                    Lookup = false;
                    TableRelation = Campaign;
                    ToolTip = 'Specifies a description of the campaign that is related to the to-do. The description is copied from the campaign card.';

                    trigger OnAssistEdit()
                    var
                        Campaign: Record Campaign;
                    begin
                        if not Campaign.Get(GetFilter("Campaign No.")) then begin
                          if Campaign.Get("Campaign No.") then ;
                          if Page.RunModal(0,Campaign) = Action::LookupOK then begin
                            Validate("Campaign No.",Campaign."No.");
                            "Wizard Campaign Description" := Campaign.Description;
                          end;
                        end;
                    end;
                }
                field("Segment Description";"Segment Description")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create To-dos for Segment';
                    Editable = false;
                    Importance = Additional;
                    Lookup = false;
                    TableRelation = "Segment Header";
                    ToolTip = 'Specifies a description of the segment related to the to-do. The description is copied from the segment card.';

                    trigger OnAssistEdit()
                    var
                        Segment: Record "Segment Header";
                    begin
                        if Segment.Get("Segment No.") then ;
                        if Page.RunModal(0,Segment) = Action::LookupOK then begin
                          Validate("Segment No.",Segment."No.");
                          "Segment Description" := Segment.Description;
                        end;
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Finish)
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Finish';
                Image = Approve;
                InFooterBar = true;
                Promoted = true;
                ToolTip = 'Finish assigning the activity.';
                Visible = IsOnMobile;

                trigger OnAction()
                begin
                    CheckAssignActivityStatus;
                    FinishAssignActivity;
                    CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        WizardContactNameOnFormat(Format("Wizard Contact Name"));
    end;

    trigger OnInit()
    begin
        TeamCodeEditable := true;
        SalespersonCodeEditable := true;
        WizardContactNameEditable := true;
        TeamMeetingOrganizerEditable := true;
    end;

    trigger OnOpenPage()
    begin
        WizardContactNameEditable := false;
        IsOnMobile := CurrentClientType = Clienttype::Phone;

        if SalesPurchPerson.Get(GetFilter("Salesperson Code")) or
           Team.Get(GetFilter("Team Code"))
        then begin
          SalespersonCodeEditable := false;
          TeamCodeEditable := false;
        end;

        if SalesPurchPerson.Get(GetFilter("Salesperson Code")) or
           ("Salesperson Code" <> '') or
           ("Activity Code" = '')
        then
          TeamMeetingOrganizerEditable := false;

        if Campaign.Get(GetFilter("Campaign No.")) then
          "Campaign Description" := Campaign.Description;

        if SegHeader.Get(GetFilter("Segment No.")) then
          "Segment Description" := SegHeader.Description;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK,Action::LookupOK] then begin
          CheckAssignActivityStatus;
          FinishAssignActivity;
        end;
    end;

    var
        Text000: label 'untitled';
        Cont: Record Contact;
        SalesPurchPerson: Record "Salesperson/Purchaser";
        Team: Record Team;
        Campaign: Record Campaign;
        SegHeader: Record "Segment Header";
        Activity: Record Activity;
        Text005: label '(Multiple)';
        [InDataSet]
        TeamMeetingOrganizerEditable: Boolean;
        [InDataSet]
        WizardContactNameEditable: Boolean;
        [InDataSet]
        SalespersonCodeEditable: Boolean;
        [InDataSet]
        TeamCodeEditable: Boolean;
        IsOnMobile: Boolean;

    local procedure Caption(): Text[260]
    var
        CaptionStr: Text[260];
    begin
        if Cont.Get(GetFilter("Contact Company No.")) then
          CaptionStr := CopyStr(Cont."No." + ' ' + Cont.Name,1,MaxStrLen(CaptionStr));
        if Cont.Get(GetFilter("Contact No.")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + Cont."No." + ' ' + Cont.Name,1,MaxStrLen(CaptionStr));
        if SalesPurchPerson.Get(GetFilter("Salesperson Code")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + SalesPurchPerson.Code + ' ' + SalesPurchPerson.Name,1,MaxStrLen(CaptionStr));
        if Team.Get(GetFilter("Team Code")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + Team.Code + ' ' + Team.Name,1,MaxStrLen(CaptionStr));
        if Campaign.Get(GetFilter("Campaign No.")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + Campaign."No." + ' ' + Campaign.Description,1,MaxStrLen(CaptionStr));
        if SegHeader.Get(GetFilter("Segment No.")) then
          CaptionStr := CopyStr(CaptionStr + ' ' + SegHeader."No." + ' ' + SegHeader.Description,1,MaxStrLen(CaptionStr));
        if CaptionStr = '' then
          CaptionStr := Text000;

        exit(CaptionStr);
    end;

    local procedure WizardContactNameOnFormat(Text: Text[1024])
    begin
        if SegHeader.Get(GetFilter("Segment No.")) then
          Text := Text005;
    end;
}

