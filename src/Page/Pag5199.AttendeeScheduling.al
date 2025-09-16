#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5199 "Attendee Scheduling"
{
    Caption = 'Attendee Scheduling';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Document;
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
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the number of the to-do.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the description of the to-do.';
                }
                field(Location;Location)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the location where the meeting will take place.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    Editable = false;
                    ToolTip = 'Specifies the code of the salesperson assigned to the to-do.';
                }
                field(Type;Type)
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    ToolTip = 'Specifies the type of the to-do.';
                }
                field(Status;Status)
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    ToolTip = 'Specifies the status of the to-do. There are five options: Not Started, In Progress, Completed, Waiting and Postponed.';
                }
                field(Priority;Priority)
                {
                    ApplicationArea = RelationshipMgmt;
                    Editable = false;
                    ToolTip = 'Specifies the priority of the to-do. There are three options:';
                }
            }
            part(AttendeeSubform;"Attendee Subform")
            {
                SubPageLink = "To-do No."=field("Organizer To-do No.");
                SubPageView = sorting("To-do No.","Line No.");
            }
            group(Interaction)
            {
                Caption = 'Interaction';
                field("Interaction Template Code";"Interaction Template Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the code for the interaction template that you have selected.';

                    trigger OnValidate()
                    begin
                        InteractionTemplateCodeOnAfter;
                    end;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = LanguageCodeEnable;
                    ToolTip = 'Specifies the language code for the interaction template.';
                }
                field(Subject;Subject)
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = SubjectEnable;
                    ToolTip = 'Specifies the subject of the to-do. The subject is used for e-mail messages or Outlook meetings that you create.';
                }
                field(Attachment;"Attachment No." > 0)
                {
                    ApplicationArea = RelationshipMgmt;
                    AssistEdit = true;
                    Caption = 'Attachment';
                    Enabled = AttachmentEnable;
                    ToolTip = 'Specifies if the attachment that is linked to the segment line is inherited or unique.';

                    trigger OnAssistEdit()
                    begin
                        MaintainAttachment;
                    end;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = UnitCostLCYEnable;
                    ToolTip = 'Specifies the cost of the interaction.';
                }
                field("Unit Duration (Min.)";"Unit Duration (Min.)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = UnitDurationMinEnable;
                    ToolTip = 'Specifies the duration of the interaction.';
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
        area(processing)
        {
            group(Functions)
            {
                Caption = 'F&unctions';
                Image = "Action";
                group(ActionGroup33)
                {
                    Caption = 'Attachment';
                    Image = Attachments;
                    action(Open)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Open';
                        Image = Edit;
                        ShortCutKey = 'Return';
                        ToolTip = 'Open the attachment.';

                        trigger OnAction()
                        begin
                            OpenAttachment(not CurrPage.Editable);
                        end;
                    }
                    action(Create)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create';
                        Image = New;
                        ToolTip = 'Create an attachment.';

                        trigger OnAction()
                        begin
                            CreateAttachment(not CurrPage.Editable);
                        end;
                    }
                    action(Import)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Import';
                        Image = Import;
                        ToolTip = 'Import an attachment.';

                        trigger OnAction()
                        begin
                            ImportAttachment;
                        end;
                    }
                    action(Export)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Export';
                        Image = Export;
                        ToolTip = 'Export an attachment.';

                        trigger OnAction()
                        begin
                            ExportAttachment;
                        end;
                    }
                    action(Remove)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Remove';
                        Image = Cancel;
                        ToolTip = 'Remove an attachment.';

                        trigger OnAction()
                        begin
                            RemoveAttachment(true);
                        end;
                    }
                }
                action("Send Invitations")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Send Invitations';
                    Image = DistributionGroup;
                    ToolTip = 'Send invitation to the attendee.';

                    trigger OnAction()
                    begin
                        SendMAPIInvitations(Rec,false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        EnableFields
    end;

    trigger OnAfterGetRecord()
    begin
        if "No." <> "Organizer To-do No." then
          CurrPage.Editable := false;

        if Closed then
          CurrPage.Editable := false;
    end;

    trigger OnInit()
    begin
        UnitDurationMinEnable := true;
        UnitCostLCYEnable := true;
        AttachmentEnable := true;
        SubjectEnable := true;
        LanguageCodeEnable := true;
    end;

    var
        [InDataSet]
        LanguageCodeEnable: Boolean;
        [InDataSet]
        SubjectEnable: Boolean;
        [InDataSet]
        AttachmentEnable: Boolean;
        [InDataSet]
        UnitCostLCYEnable: Boolean;
        [InDataSet]
        UnitDurationMinEnable: Boolean;

    local procedure MaintainAttachment()
    begin
        if "Interaction Template Code" = '' then
          exit;

        if "Attachment No." <> 0 then begin
          if not CurrPage.Editable then begin
            CurrPage.Editable := true;
            OpenAttachment(true);
            CurrPage.Editable := false;
          end else
            OpenAttachment(false);
        end else
          CreateAttachment(not CurrPage.Editable);
    end;

    local procedure EnableFields()
    begin
        LanguageCodeEnable := "Interaction Template Code" <> '';
        SubjectEnable := "Interaction Template Code" <> '';
        AttachmentEnable := "Interaction Template Code" <> '';
        UnitCostLCYEnable := "Interaction Template Code" <> '';
        UnitDurationMinEnable := "Interaction Template Code" <> ''
    end;

    local procedure InteractionTemplateCodeOnAfter()
    begin
        EnableFields
    end;
}

