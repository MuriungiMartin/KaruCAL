#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5052 "Contact List"
{
    ApplicationArea = Basic;
    Caption = 'Contact List';
    CardPageID = "Contact Card";
    DataCaptionFields = "Company No.";
    Editable = false;
    PageType = List;
    SourceTable = Contact;
    SourceTableView = sorting("Company Name","Company No.",Type,Name);
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the contact number.';
                }
                field(Name;Name)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = StyleIsStrong;
                    ToolTip = 'Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.';
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the company. If the contact is a person, Specifies the name of the company for which this contact works. This field is not editable.';
                    Visible = false;
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ZIP code for the contact.';
                    Visible = false;
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the country/region code for the contact.';
                    Visible = false;
                }
                field("Phone No.";"Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s phone number.';
                }
                field("Mobile Phone No.";"Mobile Phone No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s mobile telephone number.';
                    Visible = false;
                }
                field("E-Mail";"E-Mail")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s email.';
                }
                field("Fax No.";"Fax No.")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the contact''s fax number.';
                    Visible = false;
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the code of the salesperson who normally handles this contact.';
                }
                field("Territory Code";"Territory Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the territory code for the contact.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the currency code for the contact.';
                    Visible = false;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the language code for the contact.';
                    Visible = false;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the search name of the contact. You can use this field to search for a contact when you cannot remember the contact number.';
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control128;"Contact Statistics FactBox")
            {
                ApplicationArea = RelationshipMgmt;
                SubPageLink = "No."=field("No."),
                              "Date Filter"=field("Date Filter");
            }
            systempart(Control1900383207;Links)
            {
            }
            systempart(Control1905767507;Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ontact")
            {
                Caption = 'C&ontact';
                Image = ContactPerson;
                group("Comp&any")
                {
                    Caption = 'Comp&any';
                    Enabled = CompanyGroupEnabled;
                    Image = Company;
                    action("Business Relations")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Business Relations';
                        Image = BusinessRelation;
                        RunObject = Page "Contact Business Relations";
                        RunPageLink = "Contact No."=field("Company No.");
                        ToolTip = 'View or edit the contact''s business relations, such as customers, vendors, banks, lawyers, consultants, competitors, and so on.';
                    }
                    action("Industry Groups")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Industry Groups';
                        Image = IndustryGroups;
                        RunObject = Page "Contact Industry Groups";
                        RunPageLink = "Contact No."=field("Company No.");
                        ToolTip = 'View or edit the industry groups, such as Retail or Automobile, that the contact belongs to.';
                    }
                    action("Web Sources")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Web Sources';
                        Image = Web;
                        RunObject = Page "Contact Web Sources";
                        RunPageLink = "Contact No."=field("Company No.");
                        ToolTip = 'View a list of the web sites with information about the contacts.';
                    }
                }
                group("P&erson")
                {
                    Caption = 'P&erson';
                    Enabled = PersonGroupEnabled;
                    Image = User;
                    action("Job Responsibilities")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Job Responsibilities';
                        Image = Job;
                        ToolTip = 'View or edit the contact''s job responsibilities.';

                        trigger OnAction()
                        var
                            ContJobResp: Record "Contact Job Responsibility";
                        begin
                            TestField(Type,Type::Person);
                            ContJobResp.SetRange("Contact No.","No.");
                            Page.RunModal(Page::"Contact Job Responsibilities",ContJobResp);
                        end;
                    }
                }
                action("Pro&files")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Pro&files';
                    Image = Answers;
                    ToolTip = 'Open the Profile Questionnaires window.';
                    Visible = ActionVisible;

                    trigger OnAction()
                    var
                        ProfileManagement: Codeunit ProfileManagement;
                    begin
                        ProfileManagement.ShowContactQuestionnaireCard(Rec,'',0);
                    end;
                }
                action("&Picture")
                {
                    ApplicationArea = Suite,RelationshipMgmt;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Contact Picture";
                    RunPageLink = "No."=field("No.");
                    ToolTip = 'View or add a picture of the contact person, or for example, the company''s logo.';
                    Visible = ActionVisible;
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name"=const(Contact),
                                  "No."=field("No."),
                                  "Sub No."=const(0);
                    ToolTip = 'View or add comments.';
                }
                group("Alternati&ve Address")
                {
                    Caption = 'Alternati&ve Address';
                    Image = Addresses;
                    action(Card)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Card';
                        Image = EditLines;
                        RunObject = Page "Contact Alt. Address List";
                        RunPageLink = "Contact No."=field("No.");
                        ToolTip = 'View or change detailed information about the contact.';
                    }
                    action("Date Ranges")
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Date Ranges';
                        Image = DateRange;
                        RunObject = Page "Contact Alt. Addr. Date Ranges";
                        RunPageLink = "Contact No."=field("No.");
                        ToolTip = 'Specify date ranges that apply to the contact''s alternate address.';
                    }
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGotoContact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    Enabled = (Type <> Type::Company) and ("Company No." <> '');
                    Image = CoupledContactPerson;
                    ToolTip = 'Open the coupled Dynamics CRM contact.';

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
                    Enabled = (Type <> Type::Company) and ("Company No." <> '');
                    Image = Refresh;
                    ToolTip = 'Send or get updated data to or from Microsoft Dynamics CRM.';

                    trigger OnAction()
                    var
                        Contact: Record Contact;
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        ContactRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(Contact);
                        Contact.Next;

                        if Contact.Count = 1 then
                          CRMIntegrationManagement.UpdateOneNow(Contact.RecordId)
                        else begin
                          ContactRecordRef.GetTable(Contact);
                          CRMIntegrationManagement.UpdateMultipleNow(ContactRecordRef);
                        end
                    end;
                }
                group(Coupling)
                {
                    Caption = 'Coupling', Comment='Coupling is a noun';
                    Enabled = (Type <> Type::Company) and ("Company No." <> '');
                    Image = LinkAccount;
                    ToolTip = 'Create, change, or delete a coupling between the Microsoft Dynamics NAV record and a Microsoft Dynamics CRM record.';
                    action(ManageCRMCoupling)
                    {
                        AccessByPermission = TableData "CRM Integration Record"=IM;
                        ApplicationArea = All;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM contact.';

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
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM contact.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(RecordId);
                        end;
                    }
                }
                group(Create)
                {
                    Caption = 'Create';
                    Image = NewCustomer;
                    action(CreateInCRM)
                    {
                        ApplicationArea = Suite,RelationshipMgmt;
                        Caption = 'Create Contact in Dynamics CRM';
                        Enabled = (Type <> Type::Company) and ("Company No." <> '');
                        Image = NewCustomer;
                        ToolTip = 'Create a contact in Dynamics CRM that is linked to a contact in your company.';

                        trigger OnAction()
                        var
                            Contact: Record Contact;
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                            ContactRecordRef: RecordRef;
                        begin
                            CurrPage.SetSelectionFilter(Contact);
                            Contact.Next;

                            if Contact.Count = 1 then
                              CRMIntegrationManagement.CreateNewRecordInCRM(RecordId,false)
                            else begin
                              ContactRecordRef.GetTable(Contact);
                              CRMIntegrationManagement.CreateNewRecordsInCRM(ContactRecordRef);
                            end
                        end;
                    }
                    action(CreateFromCRM)
                    {
                        ApplicationArea = Suite,RelationshipMgmt;
                        Caption = 'Create Contact in Dynamics NAV';
                        Image = NewCustomer;
                        ToolTip = 'Create a contact here in your company that is linked to the Dynamics CRM contact.';

                        trigger OnAction()
                        var
                            CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        begin
                            CRMIntegrationManagement.ManageCreateNewRecordFromCRM(Database::Contact);
                        end;
                    }
                }
            }
            group("Related Information")
            {
                Caption = 'Related Information';
                Image = Users;
                action("Relate&d Contacts")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Relate&d Contacts';
                    Image = Users;
                    RunObject = Page "Contact List";
                    RunPageLink = "Company No."=field("Company No.");
                    ToolTip = 'View a list of all contacts.';
                }
                action("Segmen&ts")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Segmen&ts';
                    Image = Segment;
                    RunObject = Page "Contact Segment List";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=filter(<>''),
                                  "Contact No."=field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact No.","Segment No.");
                    ToolTip = 'View the segments that are related to the contact.';
                }
                action("Mailing &Groups")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Mailing &Groups';
                    Image = DistributionGroup;
                    RunObject = Page "Contact Mailing Groups";
                    RunPageLink = "Contact No."=field("No.");
                    ToolTip = 'View or edit the mailing groups that the contact is assigned to, for example, for sending price lists or Christmas cards.';
                }
                action("C&ustomer/Vendor/Bank Acc.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'C&ustomer/Vendor/Bank Acc.';
                    Image = ContactReference;
                    ToolTip = 'View the related customer, vendor, or bank account that is associated with the current record.';

                    trigger OnAction()
                    begin
                        ShowCustVendBank;
                    end;
                }
            }
            group(Tasks)
            {
                Caption = 'Tasks';
                Image = Task;
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=field(filter("Lookup Contact No.")),
                                  "System To-do Type"=filter("Contact Attendee");
                    RunPageView = sorting("Contact Company No.","Contact No.");
                    ToolTip = 'View the list of to-dos.';
                }
                action("Open Oppo&rtunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Open Oppo&rtunities';
                    Image = OpportunityList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Opportunity List";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=filter(<>''),
                                  "Contact No."=field(filter("Lookup Contact No.")),
                                  Status=filter("Not Started"|"In Progress");
                    RunPageView = sorting("Contact Company No.","Contact No.");
                    Scope = Repeater;
                    ToolTip = 'View the open sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action("Postponed &Interactions")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Postponed &Interactions';
                    Image = PostponedInteractions;
                    RunObject = Page "Postponed Interactions";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=filter(<>''),
                                  "Contact No."=field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact Company No.","Contact No.");
                    ToolTip = 'View postponed interactions for the contact.';
                }
            }
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
                action("Sales &Quotes")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Sales &Quotes';
                    Image = Quote;
                    RunObject = Page "Sales Quotes";
                    RunPageLink = "Sell-to Contact No."=field("No.");
                    RunPageView = sorting("Document Type","Sell-to Contact No.");
                    ToolTip = 'View sales quotes that exist for the contact.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Closed Oppo&rtunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Closed Oppo&rtunities';
                    Image = OpportunityList;
                    RunObject = Page "Opportunity List";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=filter(<>''),
                                  "Contact No."=field(filter("Lookup Contact No.")),
                                  Status=filter(Won|Lost);
                    RunPageView = sorting("Contact Company No.","Contact No.");
                    ToolTip = 'View the closed sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
                }
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=filter(<>''),
                                  "Contact No."=field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact Company No.","Contact No.");
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
                    RunObject = Page "Contact Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(MakePhoneCall)
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Make &Phone Call';
                    Image = Calls;
                    Promoted = true;
                    PromotedCategory = Process;
                    Scope = Repeater;
                    ToolTip = 'Call the selected contact.';

                    trigger OnAction()
                    var
                        TAPIManagement: Codeunit TAPIManagement;
                    begin
                        TAPIManagement.DialContCustVendBank(Database::Contact,"No.",GetDefaultPhoneNo,'');
                    end;
                }
                action("Launch &Web Source")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Launch &Web Source';
                    Image = LaunchWeb;
                    ToolTip = 'Search for information about the contact online.';
                    Visible = ActionVisible;

                    trigger OnAction()
                    var
                        ContactWebSource: Record "Contact Web Source";
                    begin
                        ContactWebSource.SetRange("Contact No.","Company No.");
                        if Page.RunModal(Page::"Web Source Launch",ContactWebSource) = Action::LookupOK then
                          ContactWebSource.Launch;
                    end;
                }
                group("Create as")
                {
                    Caption = 'Create as';
                    Image = CustomerContact;
                    Visible = ActionVisible;
                    action(Customer)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer';
                        Image = Customer;
                        ToolTip = 'Create the contact as a customer.';

                        trigger OnAction()
                        begin
                            CreateCustomer(ChooseCustomerTemplate);
                        end;
                    }
                    action(Vendor)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Vendor';
                        Image = Vendor;
                        ToolTip = 'Create the contact as a vendor.';

                        trigger OnAction()
                        begin
                            CreateVendor;
                        end;
                    }
                    action(Bank)
                    {
                        AccessByPermission = TableData "Bank Account"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Bank';
                        Image = Bank;
                        ToolTip = 'Create the contact as a bank.';

                        trigger OnAction()
                        begin
                            CreateBankAccount;
                        end;
                    }
                }
                group("Link with existing")
                {
                    Caption = 'Link with existing';
                    Image = Links;
                    action(Action63)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Customer';
                        Image = Customer;
                        ToolTip = 'Link the contact to an existing customer.';

                        trigger OnAction()
                        begin
                            CreateCustomerLink;
                        end;
                    }
                    action(Action64)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'Vendor';
                        Image = Vendor;
                        ToolTip = 'Link the contact to an existing vendor.';

                        trigger OnAction()
                        begin
                            CreateVendorLink;
                        end;
                    }
                    action(Action65)
                    {
                        AccessByPermission = TableData "Bank Account"=R;
                        ApplicationArea = Basic,Suite;
                        Caption = 'Bank';
                        Image = Bank;
                        ToolTip = 'Link the contact to an existing bank.';

                        trigger OnAction()
                        begin
                            CreateBankAccountLink;
                        end;
                    }
                }
            }
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
            action("Create Oportunity")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Create Oportunity';
                Image = NewOpportunity;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Opportunity Card";
                RunPageLink = "Contact No."=field("No."),
                              "Contact Company No."=field("Company No.");
                RunPageMode = Create;
                ToolTip = 'Register a sales opportunity for the contact.';
            }
            action(SyncWithExchange)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Sync with Office 365';
                Image = Refresh;
                ToolTip = 'Synchronize with Office 365 based on last sync date and last modified date. All changes in Office 365 since the last sync date will be synchronized back.';

                trigger OnAction()
                begin
                    SyncExchangeContacts(false);
                end;
            }
            action(FullSyncWithExchange)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'Full Sync with Office 365';
                Image = RefreshLines;
                ToolTip = 'Synchronize, but ignore the last synchronized and last modified dates. All changes will be pushed to Office 365 and take all contacts from your Exchange folder and sync back.';

                trigger OnAction()
                begin
                    SyncExchangeContacts(true);
                end;
            }
        }
        area(creation)
        {
            action("New Sales Quote")
            {
                ApplicationArea = Basic,Suite;
                Caption = 'New Sales Quote';
                Image = NewSalesQuote;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Sales Quote";
                RunPageLink = "Sell-to Contact No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a new sales quote.';
            }
        }
        area(reporting)
        {
            action("Contact Labels")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Contact Labels';
                Image = "Report";
                RunObject = Report "Contact - Labels";
                ToolTip = 'View mailing labels with names and addresses of your contacts. For example, you can use the report to review contact information before you send sales and marketing campaign letters.';
            }
            action("Questionnaire Handout")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Questionnaire Handout';
                Image = "Report";
                RunObject = Report "Questionnaire - Handouts";
                ToolTip = 'View your profile questionnaire for the contact. You can print this report to have a printed copy of the questions that are within the profile questionnaire.';
            }
            action("Sales Cycle Analysis")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Sales Cycle Analysis';
                Image = "Report";
                RunObject = Report "Sales Cycle - Analysis";
                ToolTip = 'View information about your sales cycles. The report includes details about the sales cycle, such as the number of opportunities currently at that stage, the estimated and calculated current values of opportunities created using the sales cycle, and so on.';
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        EnableFields;
        StyleIsStrong := Type = Type::Company;

        if CRMIntegrationEnabled then
          CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
    end;

    trigger OnInit()
    begin
        ActionVisible := CurrentClientType = Clienttype::Windows;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        [InDataSet]
        StyleIsStrong: Boolean;
        CompanyGroupEnabled: Boolean;
        PersonGroupEnabled: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        ActionVisible: Boolean;

    local procedure EnableFields()
    begin
        CompanyGroupEnabled := Type = Type::Company;
        PersonGroupEnabled := Type = Type::Person;
    end;


    procedure SyncExchangeContacts(FullSync: Boolean)
    var
        ExchangeSync: Record "Exchange Sync";
        O365SyncManagement: Codeunit "O365 Sync. Management";
        ExchangeContactSync: Codeunit "Exchange Contact Sync.";
    begin
        if O365SyncManagement.IsO365Setup(true) then
          if ExchangeSync.Get(UserId) then begin
            ExchangeContactSync.GetRequestParameters(ExchangeSync);
            O365SyncManagement.SyncExchangeContacts(ExchangeSync,FullSync);
          end;
    end;
}

