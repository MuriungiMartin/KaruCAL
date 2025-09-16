#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 76 "Resource Card"
{
    Caption = 'Resource Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies a number for the resource.';

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                          CurrPage.Update;
                    end;
                }
                field(Name;Name)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the resource.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies whether the resource is a person or a machine.';
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the base unit used to measure the resource, such as hour, piece, or kilometer.';
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an additional name for the resource for searching purposes.';
                }
                field("Resource Group No.";"Resource Group No.")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the resource group that this resource is assigned to.';
                }
                field(Blocked;Blocked)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies that the resource is blocked for posting.';
                }
                field("Last Date Modified";"Last Date Modified")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date of the most recent change of information in the Resource Card window.';
                }
                field("Use Time Sheet";"Use Time Sheet")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies if a resource uses a time sheet to record time allocated to various tasks.';
                }
                field("Time Sheet Owner User ID";"Time Sheet Owner User ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the name of the owner of the time sheet.';
                }
                field("Time Sheet Approver User ID";"Time Sheet Approver User ID")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ID of the approver of the time sheet.';
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct cost of the resource per unit of measurement.';
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an additional percentage to cover benefits or administrative costs.';
                }
                field("Unit Cost";"Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the cost of one unit of the resource.';
                }
                field("Price/Profit Calculation";"Price/Profit Calculation")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this resource.';
                }
                field("Profit %";"Profit %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the percentage that is calculated based on the calculation option that you select in the Price/Profit Calculation field.';
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies either an amount or value that is calculated based on the calculation option you select in the Price/Profit Calculation field.';
                }
                field("Tax Group Code";"Tax Group Code")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                }
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the resource''s general product posting group. It links business transactions made for this resource with the general ledger to account for the value of trade with the resource.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    Importance = Promoted;
                    ToolTip = 'Specifies the Tax product posting group to which this resource belongs.';
                }
                field("Default Deferral Template Code";"Default Deferral Template Code")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Default Deferral Template';
                    ToolTip = 'Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.';
                }
                field("Automatic Ext. Texts";"Automatic Ext. Texts")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies that an Extended Text Header will be added on sales or purchase documents for this resource.';
                }
                field("IC Partner Purch. G/L Acc. No.";"IC Partner Purch. G/L Acc. No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the intercompany g/l account number in your partner''s company that the amount for this resource is posted to.';
                }
            }
            group("Personal Data")
            {
                Caption = 'Personal Data';
                field("Job Title";"Job Title")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the person''s job title.';
                }
                field(Address;Address)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the address or location of the resource, if applicable.';
                }
                field("Address 2";"Address 2")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an additional address or location of the resource, if applicable.';
                }
                field(City;City)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the city of the resource''s address.';
                }
                field(County;County)
                {
                    ApplicationArea = Jobs;
                    Caption = 'State / ZIP Code';
                    ToolTip = 'Specifies the state or ZIP code as a part of the address.';
                }
                field("Post Code";"Post Code")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the ZIP code of the resource''s address.';
                }
                field("Social Security No.";"Social Security No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the person''s social security number or the machine''s serial number.';
                }
                field(Education;Education)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the training, education, or certification level of the person.';
                }
                field("Contract Class";"Contract Class")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the contract class for the person.';
                }
                field("Employment Date";"Employment Date")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the date when the person began working for you or the date when the machine was placed in service.';
                }
            }
        }
        area(factboxes)
        {
            part(Control39;"Resource Picture")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("No.");
            }
            part(Control1906609707;"Resource Statistics FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("No."),
                              "Unit of Measure Filter"=field("Unit of Measure Filter"),
                              "Chargeable Filter"=field("Chargeable Filter"),
                              "Service Zone Filter"=field("Service Zone Filter");
                Visible = true;
            }
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
            group("&Resource")
            {
                Caption = '&Resource';
                Image = Resource;
                action(Statistics)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Unit of Measure Filter"=field("Unit of Measure Filter"),
                                  "Chargeable Filter"=field("Chargeable Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action(Dimensions)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(156),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edits dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                action("&Picture")
                {
                    ApplicationArea = Jobs;
                    Caption = '&Picture';
                    Image = Picture;
                    RunObject = Page "Resource Picture";
                    RunPageLink = "No."=field("No.");
                    ToolTip = 'View or add a picture of the resource, or for example, the company''s logo.';
                }
                action("E&xtended Text")
                {
                    ApplicationArea = Suite;
                    Caption = 'E&xtended Text';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name"=const(Resource),
                                  "No."=field("No.");
                    RunPageView = sorting("Table Name","No.","Language Code","All Language Codes","Starting Date","Ending Date");
                    ToolTip = 'View the extended description that is set up.';
                }
                action("Units of Measure")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Resource Units of Measure";
                    RunPageLink = "Resource No."=field("No.");
                    ToolTip = 'View or edit the units of measure that are set up for the resource.';
                }
                action("S&kills")
                {
                    ApplicationArea = Jobs;
                    Caption = 'S&kills';
                    Image = Skills;
                    RunObject = Page "Resource Skills";
                    RunPageLink = Type=const(Resource),
                                  "No."=field("No.");
                    ToolTip = 'View the assignment of skills to the resource. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
                }
                separator(Action34)
                {
                    Caption = '';
                }
                action("Resource L&ocations")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource L&ocations';
                    Image = Resource;
                    RunObject = Page "Resource Locations";
                    RunPageLink = "Resource No."=field("No.");
                    RunPageView = sorting("Resource No.");
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const(Resource),
                                  "No."=field("No.");
                }
                action("Online Map")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Online Map';
                    Image = Map;
                    ToolTip = 'View the address on an online map.';

                    trigger OnAction()
                    begin
                        DisplayMap;
                    end;
                }
                separator(Action69)
                {
                }
            }
            group(ActionGroupCRM)
            {
                Caption = 'Dynamics CRM';
                Visible = CRMIntegrationEnabled;
                action(CRMGoToProduct)
                {
                    ApplicationArea = Basic;
                    Caption = 'Product';
                    Image = CoupledItem;
                    ToolTip = 'Open the coupled Microsoft Dynamics CRM product.';

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
                    ToolTip = 'Send updated data to Microsoft Dynamics CRM.';

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
                        ApplicationArea = Suite;
                        Caption = 'Set Up Coupling';
                        Image = LinkAccount;
                        ToolTip = 'Create or modify the coupling to a Microsoft Dynamics CRM product.';

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
                        ApplicationArea = Suite;
                        Caption = 'Delete Coupling';
                        Enabled = CRMIsCoupledToRecord;
                        Image = UnLinkAccount;
                        ToolTip = 'Delete the coupling to a Microsoft Dynamics CRM product.';

                        trigger OnAction()
                        var
                            CRMCouplingManagement: Codeunit "CRM Coupling Management";
                        begin
                            CRMCouplingManagement.RemoveCoupling(RecordId);
                        end;
                    }
                }
            }
            group("&Prices")
            {
                Caption = '&Prices';
                Image = Price;
                action(Costs)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Costs';
                    Image = ResourceCosts;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Costs";
                    RunPageLink = Type=const(Resource),
                                  Code=field("No.");
                    ToolTip = 'View or change detailed information about costs for the resource.';
                }
                action(Prices)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Prices';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Prices";
                    RunPageLink = Type=const(Resource),
                                  Code=field("No.");
                    ToolTip = 'View or edit prices for the resource.';
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Image = Planning;
                action("Resource &Capacity")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource &Capacity';
                    Image = Capacity;
                    RunObject = Page "Resource Capacity";
                    RunPageOnRec = true;
                    ToolTip = 'View this job''s resource capacity.';
                }
                action("Resource &Allocated per Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource &Allocated per Job';
                    Image = ViewJob;
                    RunObject = Page "Resource Allocated per Job";
                    RunPageLink = "Resource Filter"=field("No.");
                    ToolTip = 'View this job''s resource allocation.';
                }
                action("Resource Allocated per Service &Order")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource Allocated per Service &Order';
                    Image = ViewServiceOrder;
                    RunObject = Page "Res. Alloc. per Service Order";
                    RunPageLink = "Resource Filter"=field("No.");
                    ToolTip = 'View the service order allocations of the resource.';
                }
                action("Resource A&vailability")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Resource A&vailability';
                    Image = Calendar;
                    RunObject = Page "Resource Availability";
                    RunPageLink = "No."=field("No."),
                                  "Base Unit of Measure"=field("Base Unit of Measure"),
                                  "Chargeable Filter"=field("Chargeable Filter");
                    ToolTip = 'View a summary of resource capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource availability.';
                }
            }
            group(Service)
            {
                Caption = 'Service';
                Image = ServiceZone;
                action("Service &Zones")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Service &Zones';
                    Image = ServiceZone;
                    RunObject = Page "Resource Service Zones";
                    RunPageLink = "Resource No."=field("No.");
                    ToolTip = 'View the different service zones that you can assign to customers and resources. When you allocate a resource to a service task that is to be performed at the customer site, you can select a resource that is located in the same service zone as the customer.';
                }
            }
            group(History)
            {
                Caption = 'History';
                Image = History;
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "Resource No."=field("No.");
                    RunPageView = sorting("Resource No.")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
                }
            }
        }
        area(reporting)
        {
            action("Resource Statistics")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource Statistics';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Resource Statistics";
                ToolTip = 'View detailed, historical information for the resource.';
            }
            action("Resource Usage")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource Usage';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Resource Usage";
                ToolTip = 'View the resource utilization that has taken place. The report includes the resource capacity, quantity of usage, and the remaining balance.';
            }
            action("Cost Breakdown")
            {
                ApplicationArea = Jobs;
                Caption = 'Cost Breakdown';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Cost Breakdown";
                ToolTip = 'List the cost breakdown of your resources. The resource name and number prints at the top of the page. The report includes the type of work, quantity, direct unit cost, and the total direct cost.';
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action(CreateTimeSheets)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Create Time Sheets';
                    Ellipsis = true;
                    Image = NewTimesheet;
                    ToolTip = 'Create new time sheets for the resource.';

                    trigger OnAction()
                    begin
                        CreateTimeSheets;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        CRMIsCoupledToRecord := CRMIntegrationEnabled and CRMCouplingManagement.IsRecordCoupledToCRM(RecordId);
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

