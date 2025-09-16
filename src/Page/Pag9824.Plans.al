#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9824 Plans
{
    Caption = 'Plans';
    Editable = false;
    LinksAllowed = false;
    PageType = List;
    ShowFilter = false;
    SourceTable = Plan;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name;Name)
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the record.';
                }
            }
        }
        area(factboxes)
        {
            part("Users in Plan";"User Plan Members FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Plan ID"=field("Plan ID");
            }
            part("User Groups in Plan";"User Group Plan FactBox")
            {
                ApplicationArea = Basic,Suite;
                SubPageLink = "Plan ID"=field("Plan ID");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(PageUserGroupByPlan)
            {
                ApplicationArea = Basic,Suite;
                Caption = 'User Group by Plan';
                Image = Users;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "User Group by Plan";
                RunPageMode = View;
                ToolTip = 'View a list of user groups filtered by plan.';
            }
        }
    }
}

