#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5087 "Campaign List"
{
    ApplicationArea = Basic;
    Caption = 'Campaign List';
    CardPageID = "Campaign Card";
    Editable = false;
    PageType = List;
    SourceTable = Campaign;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("No.";"No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the campaign number.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the description of the campaign.';
                }
                field("Salesperson Code";"Salesperson Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the salesperson responsible for the campaign.';
                }
                field("Status Code";"Status Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the status code for the campaign.';
                }
                field("Starting Date";"Starting Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the date on which the campaign is valid. There are certain rules for how dates should be entered.';
                }
                field("Ending Date";"Ending Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the last day on which this campaign is valid.';
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
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("C&ampaign")
            {
                Caption = 'C&ampaign';
                Image = Campaign;
                action("E&ntries")
                {
                    ApplicationArea = Basic;
                    Caption = 'E&ntries';
                    Image = Entries;
                    RunObject = Page "Campaign Entries";
                    RunPageLink = "Campaign No."=field("No.");
                    RunPageView = sorting("Campaign No.");
                    ShortCutKey = 'Ctrl+F7';
                    ToolTip = 'View all the entries linked to the campaign. In this window, you cannot manually create new campaign entries.';
                }
                action("Co&mments")
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Rlshp. Mgt. Comment Sheet";
                    RunPageLink = "Table Name"=const(Campaign),
                                  "No."=field("No."),
                                  "Sub No."=const(0);
                    ToolTip = 'View or add comments.';
                }
                action(Statistics)
                {
                    ApplicationArea = Basic;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Campaign Statistics";
                    RunPageLink = "No."=field("No.");
                    ShortCutKey = 'F7';
                    ToolTip = 'View key figures concerning your campaign.';
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
                        RunPageLink = "Table ID"=const(5071),
                                      "No."=field("No.");
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
                            Campaign: Record Campaign;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Campaign);
                            DefaultDimMultiple.SetMultiCampaign(Campaign);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("T&o-dos")
                {
                    ApplicationArea = Basic;
                    Caption = 'T&o-dos';
                    Image = TaskList;
                    RunObject = Page "Task List";
                    RunPageLink = "Campaign No."=field("No."),
                                  "System To-do Type"=filter(Organizer);
                    RunPageView = sorting("Campaign No.");
                }
                action("S&egments")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&egments';
                    Image = Segment;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Segment List";
                    RunPageLink = "Campaign No."=field("No.");
                    RunPageView = sorting("Campaign No.");
                    ToolTip = 'View a list of all the open segments. Open segments are those for which the interaction has not been logged yet.';
                }
                group("Oppo&rtunities")
                {
                    Caption = 'Oppo&rtunities';
                    Image = OpportunityList;
                    action(List)
                    {
                        ApplicationArea = Basic;
                        Caption = 'List';
                        Image = OpportunitiesList;
                        RunObject = Page "Opportunity List";
                        RunPageLink = "Campaign No."=field("No.");
                        RunPageView = sorting("Campaign No.");
                        ToolTip = 'View sales opportunities handled by salespeople.';
                    }
                }
                action("Sales &Prices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Prices';
                    Image = SalesPrices;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Sales Type"=const(Campaign),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                }
                action("Sales &Line Discounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales &Line Discounts';
                    Image = SalesLineDisc;
                    RunObject = Page "Sales Line Discounts";
                    RunPageLink = "Sales Type"=const(Campaign),
                                  "Sales Code"=field("No.");
                    RunPageView = sorting("Sales Type","Sales Code");
                }
            }
        }
        area(processing)
        {
            group("F&unctions")
            {
                Caption = 'F&unctions';
                Image = "Action";
                action("&Activate Sales Prices/Line Discounts")
                {
                    ApplicationArea = Basic;
                    Caption = '&Activate Sales Prices/Line Discounts';
                    Image = ActivateDiscounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Activate discounts that are associated with the campaign.';

                    trigger OnAction()
                    begin
                        CampaignMgmt.ActivateCampaign(Rec);
                    end;
                }
                action("&Deactivate Sales Prices/Line Discounts")
                {
                    ApplicationArea = Basic;
                    Caption = '&Deactivate Sales Prices/Line Discounts';
                    Image = DeactivateDiscounts;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Deactivate discounts that are associated with the campaign.';

                    trigger OnAction()
                    begin
                        CampaignMgmt.DeactivateCampaign(Rec,true);
                    end;
                }
            }
        }
        area(reporting)
        {
            action("Campaign Details")
            {
                ApplicationArea = Basic;
                Caption = 'Campaign Details';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Campaign - Details";
                ToolTip = 'Show detailed information about the campaign.';
            }
        }
    }

    var
        CampaignMgmt: Codeunit "Campaign Target Group Mgt";


    procedure GetSelectionFilter(): Text
    var
        Campaign: Record Campaign;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SetSelectionFilter(Campaign);
        exit(SelectionFilterManagement.GetSelectionFilterForCampaign(Campaign));
    end;
}

