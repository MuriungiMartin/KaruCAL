#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5091 Segment
{
    Caption = 'Segment';
    PageType = ListPlus;
    PopulateAllFields = true;
    SourceTable = "Segment Header";

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
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the segment.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the segment.';

                    trigger OnValidate()
                    begin
                        DescriptionOnAfterValidate;
                    end;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson responsible for this segment and/or interaction.';

                    trigger OnValidate()
                    begin
                        SalespersonCodeOnAfterValidate;
                    end;
                }
                field(Date;Date)
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the date that the segment was created.';

                    trigger OnValidate()
                    begin
                        DateOnAfterValidate;
                    end;
                }
                field("No. of Lines";"No. of Lines")
                {
                    ApplicationArea = RelationshipMgmt;
                    DrillDown = false;
                    ToolTip = 'Specifies the number of lines within the segment.';
                }
                field("No. of Criteria Actions";"No. of Criteria Actions")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the number of actions you have taken when modifying the segmentation criteria, that is, when adding contacts to the segment, refining, or reducing it.';
                }
            }
            part(SegLines;"Segment Subform")
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "Segment No."=field("No.");
            }
            group(Interaction)
            {
                Caption = 'Interaction';
                field("Interaction Template Code";"Interaction Template Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the interaction template code of the interaction involving the segment.';

                    trigger OnValidate()
                    begin
                        InteractionTemplateCodeOnAfter;
                    end;
                }
                field("Language Code (Default)";"Language Code (Default)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = LanguageCodeDefaultEnable;
                    ToolTip = 'Specifies the language code for the segment.';

                    trigger OnValidate()
                    begin
                        LanguageCodeDefaultOnAfterVali;
                    end;
                }
                field("Subject (Default)";"Subject (Default)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = SubjectDefaultEnable;
                    ToolTip = 'Specifies the subject of the segment. The text in the field is used as the subject in e-mails and in Word documents.';

                    trigger OnValidate()
                    begin
                        SubjectDefaultOnAfterValidate;
                    end;
                }
                field(Attachment;"Attachment No." > 0)
                {
                    ApplicationArea = RelationshipMgmt;
                    AssistEdit = true;
                    BlankZero = true;
                    Caption = 'Attachment';
                    Enabled = AttachmentEnable;
                    ToolTip = 'Specifies if the attachment that is linked to the segment line is inherited or unique.';

                    trigger OnAssistEdit()
                    begin
                        MaintainAttachment;
                        UpdateEditable;
                        CurrPage.SegLines.Page.UpdateForm;
                    end;
                }
                field("Ignore Contact Corres. Type";"Ignore Contact Corres. Type")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = IgnoreContactCorresTypeEnable;
                    ToolTip = 'Specifies that the correspondence type that you select in the Correspondence Type (Default) field should be used. If there is no check mark, the program uses the correspondence type selected on the Contact Card.';

                    trigger OnValidate()
                    begin
                        IgnoreContactCorresTypeOnAfter;
                    end;
                }
                field("Correspondence Type (Default)";"Correspondence Type (Default)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = CorrespondenceTypeDefaultEnabl;
                    ToolTip = 'Specifies the type of correspondence that this interaction is. There are three options:';

                    trigger OnValidate()
                    begin
                        CorrespondenceTypeDefaultOnAft;
                    end;
                }
                field("Information Flow";"Information Flow")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = InformationFlowEnable;
                    ToolTip = 'Specifies the direction of the information that is part of the interaction created for the segment. There are two options: Inbound and Outbound.';

                    trigger OnValidate()
                    begin
                        InformationFlowOnAfterValidate;
                    end;
                }
                field("Initiated By";"Initiated By")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = InitiatedByEnable;
                    ToolTip = 'Specifies whether the interaction recorded for this segment was initiated by your company or by one of your contacts. The Us option indicates that your company was the initiator; the Them option indicates that a contact was the initiator.';

                    trigger OnValidate()
                    begin
                        InitiatedByOnAfterValidate;
                    end;
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = UnitCostLCYEnable;
                    ToolTip = 'Specifies the unit cost of a single interaction created for this segment.';

                    trigger OnValidate()
                    begin
                        UnitCostLCYOnAfterValidate;
                    end;
                }
                field("Unit Duration (Min.)";"Unit Duration (Min.)")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = UnitDurationMinEnable;
                    ToolTip = 'Specifies the duration of a single interaction created for this segment.';

                    trigger OnValidate()
                    begin
                        UnitDurationMinOnAfterValidate;
                    end;
                }
                field("Send Word Docs. as Attmt.";"Send Word Docs. as Attmt.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the Microsoft Word document should be sent as an attachment in the e-mail message.';

                    trigger OnValidate()
                    begin
                        SendWordDocsasAttmtOnAfterVali;
                    end;
                }
            }
            group(Campaign)
            {
                Caption = 'Campaign';
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the campaign for which the segment has been created.';

                    trigger OnValidate()
                    begin
                        CampaignNoOnAfterValidate;
                    end;
                }
                field("Campaign Description";"Campaign Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies a description of the campaign to which the segment is related. The description is copied from the campaign card.';
                }
                field("Campaign Target";"Campaign Target")
                {
                    ApplicationArea = Basic;
                    Enabled = CampaignTargetEnable;
                    ToolTip = 'Specifies that the segment is part of the target of the campaign to which it is linked.';

                    trigger OnValidate()
                    begin
                        CampaignTargetOnAfterValidate;
                    end;
                }
                field("Campaign Response";"Campaign Response")
                {
                    ApplicationArea = Basic;
                    Enabled = CampaignResponseEnable;
                    ToolTip = 'Specifies that the interaction created for the segment is the response to a campaign.';

                    trigger OnValidate()
                    begin
                        CampaignResponseOnAfterValidat;
                    end;
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
            group("&Segment")
            {
                Caption = '&Segment';
                Image = Segment;
                action(Criteria)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Criteria';
                    Image = "Filter";
                    RunObject = Page "Segment Criteria";
                    RunPageLink = "Segment No."=field("No.");
                    ToolTip = 'View a list of the actions that you have performed (adding or removing contacts) in order to define the segment criteria.';
                }
                action("Oppo&rtunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Oppo&rtunities';
                    Image = OpportunityList;
                    RunObject = Page "Opportunity List";
                    RunPageLink = "Segment No."=field("No.");
                    RunPageView = sorting("Segment No.");
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the segment. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action("Create opportunity")
                {
                    ApplicationArea = Basic;
                    Image = NewOpportunity;
                    RunObject = Page "Opportunity Card";
                    RunPageLink = "Segment No."=field("No.");
                    RunPageMode = Create;
                }
                action("Create opportunities")
                {
                    ApplicationArea = Basic;
                    Caption = 'Create opportunities';

                    trigger OnAction()
                    begin
                        CreateOpportunitiesForAllContacts;
                    end;
                }
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Segment No."=field("No."),
                                  "System To-do Type"=filter(Organizer|"Salesperson Attendee");
                    RunPageView = sorting("Segment No.");
                }
            }
        }
        area(processing)
        {
            action("&Log")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = '&Log';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Log segments and interactions that are assigned to your segments and delivery attachments that you have sent.';

                trigger OnAction()
                var
                    LogSegment: Report "Log Segment";
                begin
                    LogSegment.SetSegmentNo("No.");
                    LogSegment.RunModal;
                    if not Get("No.") then
                      Message(Text011,"No.");
                end;
            }
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                group(Contacts)
                {
                    Caption = 'Contacts';
                    Image = CustomerContact;
                    action(AddContacts)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Add Contacts';
                        Ellipsis = true;
                        Image = AddContacts;
                        Promoted = true;
                        PromotedCategory = Process;
                        ToolTip = 'Select which contacts to add to the segment.';

                        trigger OnAction()
                        var
                            SegHeader: Record "Segment Header";
                        begin
                            SegHeader := Rec;
                            SegHeader.SetRecfilter;
                            Report.RunModal(Report::"Add Contacts",true,false,SegHeader);
                        end;
                    }
                    action(ReduceContacts)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Reduce Contacts';
                        Ellipsis = true;
                        Image = RemoveContacts;
                        ToolTip = 'Select which contacts to remove from your segment.';

                        trigger OnAction()
                        var
                            SegHeader: Record "Segment Header";
                        begin
                            SegHeader := Rec;
                            SegHeader.SetRecfilter;
                            Report.RunModal(Report::"Remove Contacts - Reduce",true,false,SegHeader);
                        end;
                    }
                    action(RefineContacts)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Re&fine Contacts';
                        Ellipsis = true;
                        Image = ContactFilter;
                        ToolTip = 'Select which contacts to keep in your segment.';

                        trigger OnAction()
                        var
                            SegHeader: Record "Segment Header";
                        begin
                            SegHeader := Rec;
                            SegHeader.SetRecfilter;
                            Report.RunModal(Report::"Remove Contacts - Refine",true,false,SegHeader);
                        end;
                    }
                }
                group("S&egment")
                {
                    Caption = 'S&egment';
                    Image = Segment;
                    action("Go Back")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Go Back';
                        Image = Undo;
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';

                        trigger OnAction()
                        var
                            SegmentHistoryMgt: Codeunit SegHistoryManagement;
                        begin
                            CalcFields("No. of Criteria Actions");
                            if "No. of Criteria Actions" > 0 then
                              if Confirm(Text012,false) then
                                SegmentHistoryMgt.GoBack("No.");
                        end;
                    }
                    separator(Action54)
                    {
                        Caption = '';
                    }
                    action(ReuseCriteria)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Reuse Criteria';
                        Ellipsis = true;
                        Image = Reuse;
                        ToolTip = 'Reuse a saved segment criteria.';

                        trigger OnAction()
                        begin
                            ReuseCriteria;
                        end;
                    }
                    action("Reuse Segment")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Reuse Segment';
                        Ellipsis = true;
                        Image = Reuse;
                        ToolTip = 'Reuse a logged segment.';

                        trigger OnAction()
                        begin
                            ReuseLogged(0);
                        end;
                    }
                    action(SaveCriteria)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Save Criteria';
                        Ellipsis = true;
                        Image = Save;
                        ToolTip = 'Save a segment criteria.';

                        trigger OnAction()
                        begin
                            SaveCriteria;
                        end;
                    }
                }
                separator(Action59)
                {
                    Caption = '';
                }
                group(ActionGroup60)
                {
                    Caption = 'Attachment';
                    Image = Attachments;
                    action(Open)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Open';
                        Image = Edit;
                        ShortCutKey = 'Return';
                        ToolTip = 'Open an attachment.';

                        trigger OnAction()
                        begin
                            TestField("Interaction Template Code");
                            OpenAttachment;
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
                            TestField("Interaction Template Code");
                            CreateAttachment;
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
                            TestField("Interaction Template Code");
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
                            TestField("Interaction Template Code");
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
                            TestField("Interaction Template Code");
                            RemoveAttachment(false);
                        end;
                    }
                }
                action("E&xport File")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'E&xport File';
                    Image = ExportFile;
                    ToolTip = 'Export the segment contact list as a text file.';

                    trigger OnAction()
                    var
                        SegLineLocal: Record "Segment Line";
                    begin
                        SegLineLocal.SetRange("Segment No.","No.");
                        Xmlport.Run(Xmlport::"Export Segment Contact",false,false,SegLineLocal);
                    end;
                }
                action("Apply &Mailing Group")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Apply &Mailing Group';
                    Image = DistributionGroup;
                    ToolTip = 'Assign a mailing group to a segment.';

                    trigger OnAction()
                    var
                        SegHeader: Record "Segment Header";
                    begin
                        SegHeader := Rec;
                        SegHeader.SetRecfilter;
                        Report.Run(Report::"Apply Mailing Group",true,true,SegHeader);
                    end;
                }
            }
            group("&Print")
            {
                Caption = '&Print';
                Image = Print;
                action("Print Cover &Sheets")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Print Cover &Sheets';
                    Image = PrintCover;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'View cover sheets to send to your contact.';

                    trigger OnAction()
                    var
                        SegHeader: Record "Segment Header";
                    begin
                        SegHeader := Rec;
                        SegHeader.SetRecfilter;
                        Report.Run(Report::"Segment - Cover Sheet",true,false,SegHeader);
                    end;
                }
                action("Print &Labels")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Print &Labels';
                    Image = Print;
                    ToolTip = 'View mailing labels with names and addresses.';

                    trigger OnAction()
                    var
                        SegHeader: Record "Segment Header";
                    begin
                        SegHeader := Rec;
                        SegHeader.SetRecfilter;
                        Report.Run(Report::"Segment - Labels",true,false,SegHeader);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        UpdateEditable;
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("Attachment No.");
    end;

    trigger OnInit()
    begin
        UnitDurationMinEnable := true;
        UnitCostLCYEnable := true;
        InitiatedByEnable := true;
        InformationFlowEnable := true;
        IgnoreContactCorresTypeEnable := true;
        AttachmentEnable := true;
        LanguageCodeDefaultEnable := true;
        SubjectDefaultEnable := true;
        CorrespondenceTypeDefaultEnabl := true;
        CampaignResponseEnable := true;
        CampaignTargetEnable := true;
    end;

    var
        Text011: label 'Segment %1 has been logged.';
        Text012: label 'This will undo the last criteria action.\Do you want to continue?';
        [InDataSet]
        CampaignTargetEnable: Boolean;
        [InDataSet]
        CampaignResponseEnable: Boolean;
        [InDataSet]
        CorrespondenceTypeDefaultEnabl: Boolean;
        [InDataSet]
        SubjectDefaultEnable: Boolean;
        [InDataSet]
        LanguageCodeDefaultEnable: Boolean;
        [InDataSet]
        AttachmentEnable: Boolean;
        [InDataSet]
        IgnoreContactCorresTypeEnable: Boolean;
        [InDataSet]
        InformationFlowEnable: Boolean;
        [InDataSet]
        InitiatedByEnable: Boolean;
        [InDataSet]
        UnitCostLCYEnable: Boolean;
        [InDataSet]
        UnitDurationMinEnable: Boolean;
        CreateOppQst: label 'Do you want to create an opportunity for all contacts in segment?';

    local procedure UpdateEditable()
    var
        SegInteractLanguage: Record "Segment Interaction Language";
    begin
        CampaignTargetEnable := "Campaign No." <> '';
        CampaignResponseEnable := "Campaign No." <> '';
        CorrespondenceTypeDefaultEnabl := "Ignore Contact Corres. Type" = true;
        LanguageCodeDefaultEnable := "Interaction Template Code" <> '';
        SubjectDefaultEnable := SegInteractLanguage.Get("No.",0,"Language Code (Default)");
        AttachmentEnable := "Interaction Template Code" <> '';
        IgnoreContactCorresTypeEnable := "Interaction Template Code" <> '';
        InformationFlowEnable := "Interaction Template Code" <> '';
        InitiatedByEnable := "Interaction Template Code" <> '';
        UnitCostLCYEnable := "Interaction Template Code" <> '';
        UnitDurationMinEnable := "Interaction Template Code" <> '';
        LanguageCodeDefaultEnable := "Interaction Template Code" <> '';
    end;

    local procedure DateOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure SalespersonCodeOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure DescriptionOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure InteractionTemplateCodeOnAfter()
    begin
        UpdateEditable;
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure InformationFlowOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure InitiatedByOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure UnitCostLCYOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure UnitDurationMinOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure CorrespondenceTypeDefaultOnAft()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure SendWordDocsasAttmtOnAfterVali()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure LanguageCodeDefaultOnAfterVali()
    begin
        UpdateEditable;
        CurrPage.SegLines.Page.UpdateForm;
        CurrPage.Update;
    end;

    local procedure IgnoreContactCorresTypeOnAfter()
    begin
        UpdateEditable;
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure SubjectDefaultOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure CampaignResponseOnAfterValidat()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure CampaignTargetOnAfterValidate()
    begin
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure CampaignNoOnAfterValidate()
    begin
        if "Campaign No." = '' then begin
          "Campaign Target" := false;
          "Campaign Response" := false;
        end;

        CalcFields("Campaign Description");
        CampaignTargetEnable := "Campaign No." <> '';
        CampaignResponseEnable := "Campaign No." <> '';
        CurrPage.SegLines.Page.UpdateForm;
    end;

    local procedure CreateOpportunitiesForAllContacts()
    begin
        if Confirm(CreateOppQst) then
          CreateOpportunities;
    end;
}

