#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5909 "Service Item Groups"
{
    ApplicationArea = Basic;
    Caption = 'Service Item Groups';
    PageType = List;
    SourceTable = "Service Item Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the service item group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service item group.';
                }
                field("Default Contract Discount %";"Default Contract Discount %")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the discount percentage used as the default quote discount in a service contract quote.';
                }
                field("Default Serv. Price Group Code";"Default Serv. Price Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the service price group code used as the default service price group in the Service Price Group table.';
                }
                field("Default Response Time (Hours)";"Default Response Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default response time for the service item group.';
                }
                field("Create Service Item";"Create Service Item")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that when you ship an item associated with this group, the item is registered as a service item in the Service Item table.';
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
            group("&Group")
            {
                Caption = '&Group';
                Image = Group;
                action("Resource Skills")
                {
                    ApplicationArea = Basic;
                    Caption = 'Resource Skills';
                    Image = ResourceSkills;
                    RunObject = Page "Resource Skills";
                    RunPageLink = Type=const("Service Item Group"),
                                  "No."=field(Code);
                }
                action("Skilled Resources")
                {
                    ApplicationArea = Basic;
                    Caption = 'Skilled Resources';
                    Image = ResourceSkills;

                    trigger OnAction()
                    var
                        ResourceSkill: Record "Resource Skill";
                    begin
                        Clear(SkilledResourceList);
                        SkilledResourceList.Initialize(ResourceSkill.Type::"Service Item Group",Code,Description);
                        SkilledResourceList.RunModal;
                    end;
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
                        RunPageLink = "Table ID"=const(5904),
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
                            ServiceItemGroup: Record "Service Item Group";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(ServiceItemGroup);
                            DefaultDimMultiple.SetMultiServiceItemGroup(ServiceItemGroup);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                separator(Action15)
                {
                    Caption = '';
                }
                action("Trou&bleshooting Setup")
                {
                    ApplicationArea = Basic;
                    Caption = 'Trou&bleshooting Setup';
                    Image = Troubleshoot;
                    RunObject = Page "Troubleshooting Setup";
                    RunPageLink = Type=const("Service Item Group"),
                                  "No."=field(Code);
                }
                separator(Action22)
                {
                }
                action("S&td. Serv. Item Gr. Codes")
                {
                    ApplicationArea = Basic;
                    Caption = 'S&td. Serv. Item Gr. Codes';
                    Image = ItemGroup;
                    RunObject = Page "Standard Serv. Item Gr. Codes";
                    RunPageLink = "Service Item Group Code"=field(Code);
                }
            }
        }
    }

    var
        SkilledResourceList: Page "Skilled Resource List";
}

