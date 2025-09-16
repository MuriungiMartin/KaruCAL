#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 72 "Resource Groups"
{
    ApplicationArea = Basic;
    Caption = 'Resource Groups';
    PageType = List;
    SourceTable = "Resource Group";
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
                    ToolTip = 'Specifies a number for the resource group.';
                }
                field(Name;Name)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies a short description of the resource group.';
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
            group("Res. &Group")
            {
                Caption = 'Res. &Group';
                Image = Group;
                action(Statistics)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Res. Gr. Statistics";
                    RunPageLink = "No."=field("No."),
                                  "Date Filter"=field("Date Filter"),
                                  "Unit of Measure Filter"=field("Unit of Measure Filter"),
                                  "Chargeable Filter"=field("Chargeable Filter");
                    ShortCutKey = 'F7';
                    ToolTip = 'View statistical information, such as the value of posted entries, for the record.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name"=const("Resource Group"),
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
                        RunPageLink = "Table ID"=const(152),
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
                            ResGr: Record "Resource Group";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(ResGr);
                            DefaultDimMultiple.SetMultiResGr(ResGr);
                            DefaultDimMultiple.RunModal;
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
                    RunPageLink = Type=const("Group(Resource)"),
                                  Code=field("No.");
                    ToolTip = 'View or change detailed information about costs for the resource.';
                }
                action(Prices)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Resource Prices";
                    RunPageLink = Type=const("Group(Resource)"),
                                  Code=field("No.");
                    ToolTip = 'View or edit prices for the resource.';
                }
            }
            group("Plan&ning")
            {
                Caption = 'Plan&ning';
                Image = Planning;
                action(ResGroupCapacity)
                {
                    ApplicationArea = Jobs;
                    Caption = 'Res. Group &Capacity';
                    Image = Capacity;
                    RunObject = Page "Res. Group Capacity";
                    RunPageOnRec = true;
                    ToolTip = 'View the capacity of the resource group.';
                }
                action("Res. Group All&ocated per Job")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Res. Group All&ocated per Job';
                    Image = ViewJob;
                    RunObject = Page "Res. Gr. Allocated per Job";
                    RunPageLink = "Resource Gr. Filter"=field("No.");
                    ToolTip = 'View the job allocations of the resource group.';
                }
                action("Res. Group Allocated per Service &Order")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Res. Group Allocated per Service &Order';
                    Image = ViewServiceOrder;
                    RunObject = Page "Res. Gr. Alloc. per Serv Order";
                    RunPageLink = "Resource Group Filter"=field("No.");
                    ToolTip = 'View the service order allocations of the resource group.';
                }
                action("Res. Group Availa&bility")
                {
                    ApplicationArea = Jobs;
                    Caption = 'Res. Group Availa&bility';
                    Image = Calendar;
                    RunObject = Page "Res. Group Availability";
                    RunPageLink = "No."=field("No."),
                                  "Unit of Measure Filter"=field("Unit of Measure Filter"),
                                  "Chargeable Filter"=field("Chargeable Filter");
                    ToolTip = 'View a summary of resource group capacities, the quantity of resource hours allocated to jobs on order, the quantity allocated to service orders, the capacity assigned to jobs on quote, and the resource group availability.';
                }
            }
        }
        area(creation)
        {
            action("New Resource")
            {
                ApplicationArea = Jobs;
                Caption = 'New Resource';
                Image = NewResource;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Resource Card";
                RunPageLink = "Resource Group No."=field("No.");
                RunPageMode = Create;
                ToolTip = 'Create a new resource.';
            }
        }
    }
}

