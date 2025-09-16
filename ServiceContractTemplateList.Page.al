#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 6056 "Service Contract Template List"
{
    ApplicationArea = Basic;
    Caption = 'Service Contract Template List';
    CardPageID = "Service Contract Template";
    Editable = false;
    PageType = List;
    SourceTable = "Service Contract Template";
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
                    ToolTip = 'Specifies the number of the service contract template.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service contract.';
                }
                field(Prepaid;Prepaid)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies that this service contract is prepaid.';
                }
                field("Serv. Contract Acc. Gr. Code";"Serv. Contract Acc. Gr. Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code associated with the service contract account group.';
                }
                field("Invoice Period";"Invoice Period")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the invoice period for the service contract.';
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
            group("&Contract")
            {
                Caption = '&Contract';
                Image = Agreement;
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID"=const(5968),
                                  "No."=field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                    ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
                }
                separator(Action19)
                {
                }
                action("Service Dis&counts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Dis&counts';
                    Image = Discount;
                    RunObject = Page "Contract/Service Discounts";
                    RunPageLink = "Contract Type"=const(Template),
                                  "Contract No."=field("No.");
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

