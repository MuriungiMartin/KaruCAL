#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5116 "Salesperson/Purchaser Card"
{
    Caption = 'Salesperson/Purchaser Card';
    PageType = Card;
    SourceTable = "Salesperson/Purchaser";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a code for the salesperson or purchaser.';
                }
                field(Name;Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the salesperson or purchaser.';
                }
                field("Job Title";"Job Title")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the salesperson''s job title.';
                }
                field("Commission %";"Commission %")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the percentage to use to calculate the salesperson''s commission.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the salesperson''s telephone number.';
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = RelationshipMgmt;
                    ToolTip = 'Specifies the salesperson''s email address.';
                }
                field("Next To-do Date";"Next To-do Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date of the next to-do assigned to the salesperson.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code for the global dimension 1 you have assigned to the campaign.';
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the dimension value code for the global dimension 2 you have assigned to the campaign.';
                }
            }
        }
        area(factboxes)
        {
            part(Control3;"Salesperson/Purchaser Picture")
            {
                SubPageLink = Code=field(Code);
            }
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
            group("&Salesperson")
            {
                Caption = '&Salesperson';
                Image = SalesPerson;
                action("Tea&ms")
                {
                    ApplicationArea = Basic;
                    Caption = 'Tea&ms';
                    Image = TeamSales;
                    RunObject = Page "Salesperson Teams";
                    RunPageLink = "Salesperson Code"=field(Code);
                    RunPageView = sorting("Salesperson Code");
                }
                action("Con&tacts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Con&tacts';
                    Image = CustomerContact;
                    RunObject = Page "Contact List";
                    RunPageLink = "Salesperson Code"=field(Code);
                    RunPageView = sorting("Salesperson Code");
                    ToolTip = 'View a list of contacts that are associated with the salesperson/purchaser.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Suite;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(13),
                                  "No."=field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action(Statistics)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Salesperson Statistics";
                    RunPageLink = Code=field(Code);
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("C&ampaigns")
                {
                    ApplicationArea = Basic;
                    Caption = 'C&ampaigns';
                    Image = Campaign;
                    RunObject = Page "Campaign List";
                    RunPageLink = "Salesperson Code"=field(Code);
                    RunPageView = sorting("Salesperson Code");
                }
                action("S&egments")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'S&egments';
                    Image = Segment;
                    RunObject = Page "Segment List";
                    RunPageLink = "Salesperson Code"=field(Code);
                    RunPageView = sorting("Salesperson Code");
                    ToolTip = 'View a list of all segments.';
                }
                separator(Action33)
                {
                    Caption = '';
                }
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Salesperson Code"=field(Code);
                    RunPageView = sorting("Salesperson Code");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View interaction log entries for the salesperson/purchaser.';
                }
                action("Postponed &Interactions")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Postponed &Interactions';
                    Image = PostponedInteractions;
                    RunObject = Page "Postponed Interactions";
                    RunPageLink = "Salesperson Code"=field(Code);
                    RunPageView = sorting("Salesperson Code");
                    ToolTip = 'View postponed interactions for the salesperson/purchaser.';
                }
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Salesperson Code"=field(Code),
                                  "System To-do Type"=filter(Organizer|"Salesperson Attendee");
                    RunPageView = sorting("Salesperson Code");
                }
                group("Oppo&rtunities")
                {
                    Caption = 'Oppo&rtunities';
                    Image = OpportunityList;
                    action(List)
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'List';
                        Image = OpportunitiesList;
                        RunObject = Page "Opportunity List";
                        RunPageLink = "Salesperson Code"=field(Code);
                        RunPageView = sorting("Salesperson Code");
                        ToolTip = 'View a list of all salespeople/purchasers.';
                    }
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoSystemUser)
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    Caption = 'User';
                    Image = CoupledUser;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM system user.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.ShowCRMEntityFromRecordID(RecordId);
                    end;
                }
                action(CRMSynchronizeNow)
                {
                    AccessByPermission = TableData "CRM Integration Record"=IM;
                    ApplicationArea = Basic;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                    begin
                        CRMIntegrationManagement.UpdateOneNow(RecordId);
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment='Coupling is a noun';
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record"=IM;
                        ApplicationArea = Suite,RelationshipMgmt;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM user.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.DefineCoupling(RecordId);
                        end;
                    }
                    action(DeleteCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record"=IM;
                        ApplicationArea = Suite,RelationshipMgmt;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM user.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(RecordId);
                        end;
                    }
                }
            }
        }
        area(processing)
        {
            action("Create &Interact")
            {
                AccessByPermission = TableData Attachment=R;
                ApplicationArea = RelationshipMgmt;
                Caption = 'Create &Interact';
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Create an interaction with a specified contact.';

                trigger OnAction()
                begin
                    CreateInteraction;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        if CRMIntegrationEnabled then
          CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if xRec.Code = '' then
          Reset;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
}

