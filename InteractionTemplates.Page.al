#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5075 "Interaction Templates"
{
    ApplicationArea = Basic;
    Caption = 'Interaction Templates';
    PageType = List;
    SourceTable = "Interaction Template";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the interaction template.';
                }
                field("Interaction Group Code";"Interaction Group Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code for the interaction group to which the interaction template belongs.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the interaction template.';
                }
                field("Wizard Action";"Wizard Action")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the action to perform when you click Next in the first window of the Create Interaction wizard. There are 3 options:';
                }
                field("Language Code (Default)";"Language Code (Default)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the default language code for the interaction. If the contact''s preferred language is not available, then the program uses this language as the default language.';
                }
                field(Attachment;"Attachment No." <> 0)
                {
                    ApplicationArea = RelationshipMgmt;
                    AssistEdit = true;
                    Caption = 'Attachment';
                    ToolTip = 'Specifies if the attachment that is linked to the segment line is inherited or unique.';

                    trigger OnAssistEdit()
                    var
                        InteractTmplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTmplLanguage.Get(Code,"Language Code (Default)") then begin
                          if InteractTmplLanguage."Attachment No." <> 0 then
                            InteractTmplLanguage.OpenAttachment
                          else
                            InteractTmplLanguage.CreateAttachment;
                        end else begin
                          InteractTmplLanguage.Init;
                          InteractTmplLanguage."Interaction Template Code" := Code;
                          InteractTmplLanguage."Language Code" := "Language Code (Default)";
                          InteractTmplLanguage.Description := Description;
                          InteractTmplLanguage.CreateAttachment;
                        end;
                        CurrPage.Update;
                    end;
                }
                field("Ignore Contact Corres. Type";"Ignore Contact Corres. Type")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies that the correspondence type that you select in the Correspondence Type (Default) field should be used.';
                }
                field("Correspondence Type (Default)";"Correspondence Type (Default)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies how the attachment contained in the interaction is usually communicated to contacts. There are three options:';
                }
                field("Unit Cost (LCY)";"Unit Cost (LCY)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the usual cost for interactions created using the interaction template.';
                }
                field("Unit Duration (Min.)";"Unit Duration (Min.)")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the usual duration of interactions created using the interaction template.';
                }
                field("Information Flow";"Information Flow")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the direction of the information flow for the interaction template. There are two options: Outbound and Inbound. Select Outbound if the information is usually sent by your company. Select Inbound if the information is usually received by your company.';
                }
                field("Initiated By";"Initiated By")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies who usually initiates interactions created using the interaction template. There are two options: Us and Them. Select Us if the interaction is usually initiated by your company. Select Them if the information is usually initiated by your contacts.';
                }
                field("Campaign No.";"Campaign No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the campaign for which the interaction template has been created.';
                }
                field("Campaign Target";"Campaign Target")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the contact who is involved in the interaction is the target of a campaign. This is used to measure the response rate of a campaign.';
                }
                field("Campaign Response";"Campaign Response")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that the interaction template is being used to record interactions that are a response to a campaign. For example, coupons that are sent in as a response to a campaign.';
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
            group("&Interaction Template")
            {
                Caption = '&Interaction Template';
                Image = Interaction;
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Interaction Template Code"=field(Code);
                    RunPageView = sorting("Interaction Template Code",Date);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
                }
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Interaction Tmpl. Statistics";
                    RunPageLink = Code=field(Code);
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action(Languages)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Languages';
                    Image = Language;
                    RunObject = Page "Interact. Tmpl. Languages";
                    RunPageLink = "Interaction Template Code"=field(Code);
                    ToolTip = 'Set up and select the preferred languages for the interactions with your contacts.';
                }
            }
            group("&Attachment")
            {
                Caption = '&Attachment';
                Image = Attachments;
                action(Open)
                {
                    ApplicationArea = Basic;
                    Caption = 'Open';
                    Image = Edit;
                    ShortCutKey = 'Return';
                    ToolTip = 'Open an interaction template attachment.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code,"Language Code (Default)") then
                          InteractTemplLanguage.OpenAttachment;
                    end;
                }
                action(Create)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create';
                    Ellipsis = true;
                    Image = New;
                    ToolTip = 'Create a new interaction template.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code,"Language Code (Default)") then begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := Code;
                          InteractTemplLanguage."Language Code" := "Language Code (Default)";
                          InteractTemplLanguage.Description := Description;
                        end;
                        InteractTemplLanguage.CreateAttachment;
                        CurrPage.Update;
                    end;
                }
                action("Copy &from")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy &from';
                    Ellipsis = true;
                    Image = Copy;
                    ToolTip = 'Copy an existing interaction template.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code,"Language Code (Default)") then begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := Code;
                          InteractTemplLanguage."Language Code" := "Language Code (Default)";
                          InteractTemplLanguage.Description := Description;
                          InteractTemplLanguage.Insert;
                          Commit;
                        end;
                        InteractTemplLanguage.CopyFromAttachment;
                        CurrPage.Update;
                    end;
                }
                action(Import)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Import';
                    Ellipsis = true;
                    Image = Import;
                    ToolTip = 'Import an interaction template.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if not InteractTemplLanguage.Get(Code,"Language Code (Default)") then begin
                          InteractTemplLanguage.Init;
                          InteractTemplLanguage."Interaction Template Code" := Code;
                          InteractTemplLanguage."Language Code" := "Language Code (Default)";
                          InteractTemplLanguage.Description := Description;
                          InteractTemplLanguage.Insert;
                        end;
                        InteractTemplLanguage.ImportAttachment;
                        CurrPage.Update;
                    end;
                }
                action("E&xport")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'E&xport';
                    Ellipsis = true;
                    Image = Export;
                    ToolTip = 'Export an interaction template.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code,"Language Code (Default)") then
                          InteractTemplLanguage.ExportAttachment;
                    end;
                }
                action(Remove)
                {
                    ApplicationArea = Basic;
                    Caption = 'Remove';
                    Ellipsis = true;
                    Image = Cancel;
                    ToolTip = 'Remote an interaction template.';

                    trigger OnAction()
                    var
                        InteractTemplLanguage: Record "Interaction Tmpl. Language";
                    begin
                        if InteractTemplLanguage.Get(Code,"Language Code (Default)") then
                          InteractTemplLanguage.RemoveAttachment(true);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        CalcFields("Attachment No.");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if GetFilter("Interaction Group Code") <> '' then
          if GetRangeMin("Interaction Group Code") = GetRangemax("Interaction Group Code") then
            "Interaction Group Code" := GetRangeMin("Interaction Group Code");
    end;
}

