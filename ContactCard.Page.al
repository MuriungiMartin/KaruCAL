#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5050 "Contact Card"
{
    Caption = 'Contact Card';
    PageType = ListPlus;
    PromotedActionCategories = 'New,Process,Report,Related Information';
    SourceTable = Contact;

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
                    Importance = Promoted;
                    ToolTip = 'Specifies the contact number.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the contact. If the contact is a person, you can click the field to see the Name Details window.';

                    trigger OnAssistEdit()
                    begin
                        Modify;
                        Commit;
                        Cont.SetRange("No.","No.");
                        if Type = Type::Person then begin
                          Clear(NameDetails);
                          NameDetails.SetTableview(Cont);
                          NameDetails.SetRecord(Cont);
                          NameDetails.RunModal;
                        end else begin
                          Clear(CompanyDetails);
                          CompanyDetails.SetTableview(Cont);
                          CompanyDetails.SetRecord(Cont);
                          CompanyDetails.RunModal;
                        end;
                        Get("No.");
                        CurrPage.Update;
                    end;
                }
                field(Type;Type)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the type of contact, either company or person.';

                    trigger OnValidate()
                    begin
                        TypeOnAfterValidate;
                    end;
                }
                field("Company No.";"Company No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = All;
                    AssistEdit = true;
                    Enabled = CompanyNameEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the name of the company. If the contact is a person, Specifies the name of the company for which this contact works. This field is not editable.';

                    trigger OnAssistEdit()
                    begin
                        LookupCompany;
                    end;
                }
                field(IntegrationCustomerNo;IntegrationCustomerNo)
                {
                    ApplicationArea = All;
                    Caption = 'Integration Customer No.';
                    ToolTip = 'Specifies the number of a customer that is integrated through Dynamics CRM.';
                    Visible = false;

                    trigger OnValidate()
                    var
                        Customer: Record Customer;
                        ContactBusinessRelation: Record "Contact Business Relation";
                    begin
                        if not (IntegrationCustomerNo = '') then begin
                          Customer.Get(IntegrationCustomerNo);
                          ContactBusinessRelation.SetCurrentkey("Link to Table","No.");
                          ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."link to table"::Customer);
                          ContactBusinessRelation.SetRange("No.",Customer."No.");
                          if ContactBusinessRelation.FindFirst then
                            Validate("Company No.",ContactBusinessRelation."Contact No.");
                        end else
                          Validate("Company No.",'');
                    end;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the search name of the contact. You can use this field to search for a contact when you cannot remember the contact number.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the salesperson who normally handles this contact.';
                }
                field("Salutation Code";"Salutation Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the salutation code that will be used when you interact with the contact. The salutation code is only used in Word documents. To see a list of the salutation codes already defined, click the field.';
                }
                field("Organizational Level Code";"Organizational Level Code")
                {
                    ApplicationArea = RelationshipMgmt;
                    Enabled = OrganizationalLevelCodeEnable;
                    Importance = Additional;
                    ToolTip = 'Specifies the organizational code for the contact, for example, top management. This field is valid for persons only.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the contact card was last modified. This field is not editable.';
                }
                field("Date of Last Interaction";"Date of Last Interaction")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the date of the last interaction involving the contact, for example, a received or sent mail, e-mail, or phone call. This field is not editable.';

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record "Interaction Log Entry";
                    begin
                        InteractionLogEntry.SetCurrentkey("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
                        InteractionLogEntry.SetRange("Contact Company No.","Company No.");
                        InteractionLogEntry.SetFilter("Contact No.","Lookup Contact No.");
                        InteractionLogEntry.SetRange("Attempt Failed",false);
                        if InteractionLogEntry.FindLast then
                          Page.Run(0,InteractionLogEntry);
                    end;
                }
                field("Last Date Attempted";"Last Date Attempted")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies the date when the contact was last contacted, for example, when you tried to call the contact, with or without success. This field is not editable.';

                    trigger OnDrillDown()
                    var
                        InteractionLogEntry: Record "Interaction Log Entry";
                    begin
                        InteractionLogEntry.SetCurrentkey("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
                        InteractionLogEntry.SetRange("Contact Company No.","Company No.");
                        InteractionLogEntry.SetFilter("Contact No.","Lookup Contact No.");
                        InteractionLogEntry.SetRange("Initiated By",InteractionLogEntry."initiated by"::Us);
                        if InteractionLogEntry.FindLast then
                          Page.Run(0,InteractionLogEntry);
                    end;
                }
                field("Next To-do Date";"Next To-do Date")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'Specifies the date of the next to-do involving the contact.';
                }
                field("Exclude from Segment";"Exclude from Segment")
                {
                    ApplicationArea = RelationshipMgmt;
                    Importance = Additional;
                    ToolTip = 'Specifies if the contact should be excluded from segments:';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                group(Control37)
                {
                    Caption = 'Address';
                    field(Address;Address)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the contact''s address.';
                    }
                    field("Address 2";"Address 2")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies another line of the contact''s address.';
                    }
                    field("Post Code";"Post Code")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the ZIP code for the contact.';
                    }
                    field(City;City)
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the city where the contact is located.';
                    }
                    field(County;County)
                    {
                        ApplicationArea = Basic,Suite;
                        Caption = 'State';
                        ToolTip = 'Specifies the state as a part of the address.';
                    }
                    field("Country/Region Code";"Country/Region Code")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the country/region code for the contact.';
                    }
                    field(ShowMap;ShowMapLbl)
                    {
                        ApplicationArea = Basic,Suite;
                        Editable = false;
                        ShowCaption = false;
                        Style = StrongAccent;
                        StyleExpr = true;
                        ToolTip = 'Specifies the contact''s address on your preferred map website.';

                        trigger OnDrillDown()
                        begin
                            CurrPage.Update(true);
                            DisplayMap;
                        end;
                    }
                }
                group(ContactDetails)
                {
                    Caption = 'Contact';
                    field("Phone No.";"Phone No.")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the contact''s phone number.';
                    }
                    field("Mobile Phone No.";"Mobile Phone No.")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the contact''s mobile telephone number.';
                    }
                    field("E-Mail";"E-Mail")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Promoted;
                        ToolTip = 'Specifies the email address of the contact.';
                    }
                    field("Fax No.";"Fax No.")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the contact''s fax number.';
                    }
                    field("Home Page";"Home Page")
                    {
                        ApplicationArea = Basic,Suite;
                        ToolTip = 'Specifies the contact''s home page address. You can enter a maximum of 80 characters, both numbers and letters.';
                    }
                    field("Correspondence Type";"Correspondence Type")
                    {
                        ApplicationArea = Basic,Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the type of correspondence that is preferred for this interaction. There are three options:';
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade';
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Suite;
                    Enabled = CurrencyCodeEnable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the currency code for the contact.';
                }
                field("Territory Code";"Territory Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the territory code for the contact.';
                }
                field("VAT Registration No.";"VAT Registration No.")
                {
                    ApplicationArea = Basic,Suite;
                    DrillDown = false;
                    Enabled = VATRegistrationNoEnable;
                    Importance = Additional;
                    ToolTip = 'Specifies the contact''s tax registration number. This field is valid for companies only.';

                    trigger OnDrillDown()
                    var
                        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
                    begin
                    end;
                }
                field("Language Code";"Language Code")
                {
                    ApplicationArea = Basic,Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the language code for the contact.';
                }
            }
            part(Control72;"Contact Card Subform")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Profile Questionnaire';
                SubPageLink = "Contact No."=field("No.");
                Visible = ActionVisible;
            }
        }
        area(factboxes)
        {
            part(Control41;"Contact Picture")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "No."=field("No.");
                Visible = not IsOfficeAddin;
            }
            part(Control31;"Contact Statistics FactBox")
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
                        ToolTip = 'View or edit the contact''s business relations, such as customers, vendors, banks, lawyers, consultants, competitors, and so on.';

                        trigger OnAction()
                        var
                            ContactBusinessRelationRec: Record "Contact Business Relation";
                        begin
                            TestField(Type,Type::Company);
                            ContactBusinessRelationRec.SetRange("Contact No.","Company No.");
                            Page.Run(Page::"Contact Business Relations",ContactBusinessRelationRec);
                        end;
                    }
                    action("Industry Groups")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Industry Groups';
                        Image = IndustryGroups;
                        ToolTip = 'View or edit the industry groups, such as Retail or Automobile, that the contact belongs to.';

                        trigger OnAction()
                        var
                            ContactIndustryGroupRec: Record "Contact Industry Group";
                        begin
                            TestField(Type,Type::Company);
                            ContactIndustryGroupRec.SetRange("Contact No.","Company No.");
                            Page.Run(Page::"Contact Industry Groups",ContactIndustryGroupRec);
                        end;
                    }
                    action("Web Sources")
                    {
                        ApplicationArea = RelationshipMgmt;
                        Caption = 'Web Sources';
                        Image = Web;
                        ToolTip = 'View a list of the web sites with information about the contact.';

                        trigger OnAction()
                        var
                            ContactWebSourceRec: Record "Contact Web Source";
                        begin
                            TestField(Type,Type::Company);
                            ContactWebSourceRec.SetRange("Contact No.","Company No.");
                            Page.Run(Page::"Contact Web Sources",ContactWebSourceRec);
                        end;
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
                Enabled = (Type <> Type::Company) and ("Company No." <> '');
                Visible = CRMIntegrationEnabled;
                action(CRMGotoContact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
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
                action("Online Map")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Online Map';
                    Image = Map;
                    ToolTip = 'View the address on an online map.';

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
                }
                action("Office Customer/Vendor")
                {
                    ApplicationArea = All;
                    Caption = 'Customer/Vendor';
                    Image = ContactReference;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View the related customer, vendor, or bank account.';
                    Visible = IsOfficeAddin;

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
                    RunPageView = sorting("Contact Company No.",Date,"Contact No.",Closed);
                }
                action("Oppo&rtunities")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Oppo&rtunities';
                    Image = OpportunityList;
                    RunObject = Page "Opportunity List";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=filter(<>''),
                                  "Contact No."=field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact Company No.","Contact No.");
                    ToolTip = 'View the sales opportunities that are handled by salespeople for the contact. Opportunities must involve a contact and can be linked to campaigns.';
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
                    RunPageView = sorting("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
                    ToolTip = 'View postponed interactions for the contact.';
                    Visible = ActionVisible;
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
                    Promoted = true;
                    PromotedCategory = Process;
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
                action("Interaction Log E&ntries")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Interaction Log E&ntries';
                    Image = InteractionLog;
                    RunObject = Page "Interaction Log Entries";
                    RunPageLink = "Contact Company No."=field("Company No."),
                                  "Contact No."=filter(<>''),
                                  "Contact No."=field(filter("Lookup Contact No."));
                    RunPageView = sorting("Contact Company No.",Date,"Contact No.",Canceled,"Initiated By","Attempt Failed");
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
                action("Print Cover &Sheet")
                {
                    ApplicationArea = RelationshipMgmt;
                    Caption = 'Print Cover &Sheet';
                    Image = PrintCover;
                    ToolTip = 'View cover sheets to send to your contact.';

                    trigger OnAction()
                    var
                        Cont: Record Contact;
                    begin
                        Cont := Rec;
                        Cont.SetRecfilter;
                        Report.Run(Report::"Contact - Cover Sheet",true,false,Cont);
                    end;
                }
                group("Create as")
                {
                    Caption = 'Create as';
                    Image = CustomerContact;
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
                    Visible = ActionVisible;
                    action(Action110)
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
                    action(Action111)
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
                    action(Action112)
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
                action("Apply Template")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Select a defined template to quickly create a new record.';

                    trigger OnAction()
                    var
                        ConfigTemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        ConfigTemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
                action(CreateAsCustomer)
                {
                    ApplicationArea = All;
                    Caption = 'Create as Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create a new customer based on this contact.';
                    Visible = IsOfficeAddin;

                    trigger OnAction()
                    begin
                        CreateCustomer(ChooseCustomerTemplate);
                    end;
                }
                action(CreateAsVendor)
                {
                    ApplicationArea = All;
                    Caption = 'Create as Vendor';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create a new vendor based on this contact.';
                    Visible = IsOfficeAddin;

                    trigger OnAction()
                    begin
                        CreateVendor;
                    end;
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
            action("Create Opportunity")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Create Opportunity';
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
        }
        area(reporting)
        {
            action("Contact Cover Sheet")
            {
                ApplicationArea = RelationshipMgmt;
                Caption = 'Contact Cover Sheet';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                ToolTip = 'Print or save cover sheets to send to one or more of your contacts.';

                trigger OnAction()
                begin
                    Cont := Rec;
                    Cont.SetRecfilter;
                    Report.Run(Report::"Contact - Cover Sheet",true,false,Cont);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        xRec := Rec;
        EnableFields;

        if Type = Type::Person then
          IntegrationFindCustomerNo
        else
          IntegrationCustomerNo := '';

        if CRMIntegrationEnabled then
          CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
    end;

    trigger OnInit()
    begin
        OrganizationalLevelCodeEnable := true;
        CompanyNameEnable := true;
        VATRegistrationNoEnable := true;
        CurrencyCodeEnable := true;
        ActionVisible := CurrentClientType = Clienttype::Windows;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Contact: Record Contact;
    begin
        if GetFilter("Company No.") <> '' then begin
          "Company No." := GetRangemax("Company No.");
          Type := Type::Person;
          Contact.Get("Company No.");
          InheritCompanyToPersonData(Contact);
        end;
    end;

    trigger OnOpenPage()
    var
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        OfficeManagement: Codeunit "Office Management";
    begin
        IsOfficeAddin := OfficeManagement.IsAvailable;
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
    end;

    var
        Cont: Record Contact;
        CompanyDetails: Page "Company Details";
        NameDetails: Page "Name Details";
        IntegrationCustomerNo: Code[20];
        [InDataSet]
        CurrencyCodeEnable: Boolean;
        [InDataSet]
        VATRegistrationNoEnable: Boolean;
        [InDataSet]
        CompanyNameEnable: Boolean;
        [InDataSet]
        OrganizationalLevelCodeEnable: Boolean;
        CompanyGroupEnabled: Boolean;
        PersonGroupEnabled: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        IsOfficeAddin: Boolean;
        ActionVisible: Boolean;
        ShowMapLbl: label 'Show Map';

    local procedure EnableFields()
    begin
        CompanyGroupEnabled := Type = Type::Company;
        PersonGroupEnabled := Type = Type::Person;
        CurrencyCodeEnable := Type = Type::Company;
        VATRegistrationNoEnable := Type = Type::Company;
        CompanyNameEnable := Type = Type::Person;
        OrganizationalLevelCodeEnable := Type = Type::Person;
    end;

    local procedure IntegrationFindCustomerNo()
    var
        ContactBusinessRelation: Record "Contact Business Relation";
    begin
        ContactBusinessRelation.SetCurrentkey("Link to Table","Contact No.");
        ContactBusinessRelation.SetRange("Link to Table",ContactBusinessRelation."link to table"::Customer);
        ContactBusinessRelation.SetRange("Contact No.","Company No.");
        if ContactBusinessRelation.FindFirst then begin
          IntegrationCustomerNo := ContactBusinessRelation."No.";
        end else
          IntegrationCustomerNo := '';
    end;

    local procedure TypeOnAfterValidate()
    begin
        EnableFields;
    end;
}

