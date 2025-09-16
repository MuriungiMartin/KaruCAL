#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 467 "Tax Groups"
{
    ApplicationArea = Basic;
    Caption = 'Tax Groups';
    PageType = List;
    SourceTable = "Tax Group";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the code you want to assign to this tax group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the description of the tax group. For example, if the tax group code is ALCOHOL, you could enter the description Alcoholic beverages.';
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
                action(Details)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Details';
                    Image = View;
                    RunObject = Page "Tax Details";
                    RunPageLink = "Tax Group Code"=field(Code);
                    ToolTip = 'View tax-detail entries. A tax-detail entry includes all of the information that is used to calculate the amount of tax to be charged.';
                }
            }
        }
    }
}

