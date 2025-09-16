#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 14 "Salespersons/Purchasers"
{
    ApplicationArea = Basic;
    Caption = 'Salespersons/Purchasers';
    CardPageID = "Salesperson/Purchaser Card";
    PageType = List;
    SourceTable = "Salesperson/Purchaser";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the code of the record.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    ToolTip = 'Specifies the name of the record.';
                }
                field("Commission %";"Commission %")
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    ToolTip = 'Specifies the percentage to use to calculate the salesperson''s commission.';
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    ToolTip = 'Specifies the salesperson''s or purchaser''s telephone number.';
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
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(13),
                                      "No."=field(Code);
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            SalespersonPurchaser: Record "Salesperson/Purchaser";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(SalespersonPurchaser);
                            DefaultDimMultiple.SetMultiSalesperson(SalespersonPurchaser);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
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
                separator(Action22)
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
                    ToolTip = 'View a list of the interactions that you have logged, for example, when you create an interaction, print a cover sheet, a sales order, and so on.';
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
                    ApplicationArea = All;
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
                    ApplicationArea = All;
                    Caption = 'Synchronize Now';
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        SalespersonPurchaser: Record "Salesperson/Purchaser";
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        SalespersonPurchaserRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(SalespersonPurchaser);
                        SalespersonPurchaser.Next;

                        if SalespersonPurchaser.Count = 1 then
                          CRMIntegrationManagement.UpdateOneNow(SalespersonPurchaser.RecordId)
                        else begin
                          SalespersonPurchaserRecordRef.GetTable(SalespersonPurchaser);
                          CRMIntegrationManagement.UpdateMultipleNow(SalespersonPurchaserRecordRef);
                        end
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
                        ApplicationArea = All;
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
                        ApplicationArea = All;
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
            action(CreateInteraction)
            {
                AccessByPermission = TableData Attachment=R;
                ApplicationArea = All;
                Caption = 'Create &Interaction';
                Ellipsis = true;
                Image = CreateInteraction;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Use a batch job to help you create interactions for the involved salespeople or purchasers.';
                Visible = CreateInteractionVisible;

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

    trigger OnInit()
    var
        SegmentLine: Record "Segment Line";
    begin
        CreateInteractionVisible := SegmentLine.ReadPermission;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        [InDataSet]
        CreateInteractionVisible: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
}

