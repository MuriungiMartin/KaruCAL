#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 78060 "ACA-Results Workflow Templates"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = UnknownTable78060;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Academic Year";"Academic Year")
                {
                    ApplicationArea = Basic;
                }
                field("Template Name";"Template Name")
                {
                    ApplicationArea = Basic;
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                }
                field("Department Code";"Department Code")
                {
                    ApplicationArea = Basic;
                }
                field("Workflow Codes";"Workflow Codes")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Department Heads";"Department Heads")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Users)
            {
                ApplicationArea = Basic;
                Caption = 'Users';
                Image = Permission;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "ACA-Results Buffer Users";
            }
        }
    }
}

