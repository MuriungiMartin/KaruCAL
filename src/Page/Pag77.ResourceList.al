#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 77 "Resource List"
{
    ApplicationArea = Basic;
    Caption = 'Resource List';
    CardPageID = "Resource Card";
    Editable = false;
    PageType = List;
    SourceTable = Resource;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a number for the resource.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a description of the resource.';
                }
                field(Type;Type)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies whether the resource is a person or a machine.';
                }
                field("Base Unit of Measure";"Base Unit of Measure")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the base unit used to measure the resource, such as hour, piece, or kilometer.';
                }
                field("Resource Group No.";"Resource Group No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the resource group that this resource is assigned to.';
                    Visible = false;
                }
                field("Direct Unit Cost";"Direct Unit Cost")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the direct cost of the resource per unit of measurement.';
                    Visible = false;
                }
                field("Indirect Cost %";"Indirect Cost %")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an additional percentage to cover benefits or administrative costs.';
                    Visible = false;
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
                field("Gen. Prod. Posting Group";"Gen. Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the resource''s general product posting group. It links business transactions made for this resource with the general ledger to account for the value of trade with the resource.';
                }
                field("VAT Prod. Posting Group";"VAT Prod. Posting Group")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the Tax product posting group to which this resource belongs.';
                    Visible = false;
                }
                field("Search Name";"Search Name")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies an additional name for the resource for searching purposes.';
                }
                field("Default Deferral Template Code";"Default Deferral Template Code")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Default Deferral Template';
                    ToolTip = 'Specifies the default template that governs how to defer revenues and expenses to the periods when they occurred.';
                }
            }
        }
        area(factboxes)
        {
            part(Control1906609707;"Resource Statistics FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("No."),
                              "Chargeable Filter"=field("Chargeable Filter"),
                              "Service Zone Filter"=field("Service Zone Filter"),
                              "Unit of Measure Filter"=field("Unit of Measure Filter");
                Visible = true;
            }
            part(Control1907012907;"Resource Details FactBox")
            {
                ApplicationArea = Jobs;
                SubPageLink = "No."=field("No."),
                              "Chargeable Filter"=field("Chargeable Filter"),
                              "Service Zone Filter"=field("Service Zone Filter"),
                              "Unit of Measure Filter"=field("Unit of Measure Filter");
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
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
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
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action("Dimensions-Single")
                    {
                        ApplicationArea = Jobs;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID"=const(156),
                                      "No."=field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                        ToolTip = 'View or edit the single set of dimensions that are set up for the selected record.';
                    }
                    action("Dimensions-&Multiple")
                    {
                        AccessByPermission = TableData Dimension=R;
                        ApplicationArea = Jobs;
                        Caption = 'Dimensions-&Multiple';
                        Image = DimensionSets;
                        ToolTip = 'View or edit dimensions for a group of records. You can assign dimension codes to transactions to distribute costs and analyze historical information.';

                        trigger OnAction()
                        var
                            Res: Record Resource;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Res);
                            DefaultDimMultiple.SetMultiResource(Res);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
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
                action("Ledger E&ntries")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Ledger E&ntries';
                    Image = ResourceLedger;
                    Promoted = false;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Process;
                    RunObject = Page "Resource Ledger Entries";
                    RunPageLink = "Resource No."=field("No.");
                    RunPageView = sorting("Resource No.")
                                  order(descending);
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View the history of transactions that have been posted for the selected record.';
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
                        Resource: Record Resource;
                        CRMIntegrationManagement: Codeunit "CRM Integration Management";
                        ResourceRecordRef: RecordRef;
                    begin
                        CurrPage.SetSelectionFilter(Resource);
                        Resource.Next;

                        if Resource.Count = 1 then
                          CRMIntegrationManagement.UpdateOneNow(Resource.RecordId)
                        else begin
                          ResourceRecordRef.GetTable(Resource);
                          CRMIntegrationManagement.UpdateMultipleNow(ResourceRecordRef);
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
                                  "Unit of Measure Filter"=field("Unit of Measure Filter"),
                                  "Chargeable Filter"=field("Chargeable Filter");
                    ToolTip = 'View a summary of resource capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource availability.';
                }
            }
        }
        area(creation)
        {
            action("New Resource Group")
            {
                ApplicationArea = Jobs;
                Caption = 'New Resource Group';
                Image = NewResourceGroup;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Resource Groups";
                RunPageMode = Create;
                ToolTip = 'Create a new resource.';
            }
        }
        area(reporting)
        {
            action("Resource - List")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource - List';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Resource List";
                ToolTip = 'View the list of resources.';
            }
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
            action("Resource - Cost Breakdown")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource - Cost Breakdown';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Cost Breakdown";
                ToolTip = 'View the direct unit costs and the total direct costs for each resource. Only usage postings are considered in this report. Resource usage can be posted in the resource journal or the job journal.';
            }
            action("Resource - Price List")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource - Price List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Resource - Price List";
                ToolTip = 'Shows a list of unit prices for the selected resources. By default, a unit price is based on the price in the Resource Prices window. If there is no valid alternative price, then the unit price from the resource card is used. The report can be used by the company''s salespeople or sent to customers.';
            }
            action("Resource Register")
            {
                ApplicationArea = Jobs;
                Caption = 'Resource Register';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Resource Register";
                ToolTip = 'View a list of all the resource registers. Every time a resource entry is posted, a register is created. Every register shows the first and last entry numbers of its entries. You can use the information in a resource register to document when entries were posted.';
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("Create Time Sheets")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Create Time Sheets';
                    Ellipsis = true;
                    Image = NewTimesheet;
                    ToolTip = 'Create new time sheets for the selected resource.';

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
        CRMIsCoupledToRecord :=
          CRMCouplingManagement.IsRecordCoupledToCRM(RecordId) and CRMIntegrationEnabled;
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

