#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5156 "Customer Template List"
{
    ApplicationArea = Basic;
    Caption = 'Customer Template List';
    CardPageID = "Customer Template Card";
    Editable = false;
    PageType = List;
    SourceTable = "Customer Template";
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
                    ToolTip = 'Specifies the code for the customer template. You can set up as many codes as you want. The code must be unique. You cannot have the same code twice in one table.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the description of the customer template.';
                }
                field("Country/Region Code";"Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the country/region code for the customer template.';
                }
                field("Territory Code";"Territory Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the territory code for the customer template.';
                }
                field("Currency Code";"Currency Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the currency code for the customer template.';
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
            group("&Customer Template")
            {
                Caption = '&Customer Template';
                Image = Template;
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
                        RunPageLink = "Table ID"=const(5105),
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
                            CustTemplate: Record "Customer Template";
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(CustTemplate);
                            DefaultDimMultiple.SetMultiCustTemplate(CustTemplate);
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
            }
        }
    }
}

