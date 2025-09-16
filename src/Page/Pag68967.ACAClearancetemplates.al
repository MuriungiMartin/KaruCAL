#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 68967 "ACA-Clearance templates"
{
    Caption = 'Clearance templates';
    PageType = List;
    SourceTable = UnknownTable61755;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Clearance Level Code";"Clearance Level Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Department;Department)
                {
                    ApplicationArea = Basic;
                }
                field(Active;Active)
                {
                    ApplicationArea = Basic;
                }
                field("Approvers Exists";"Approvers Exists")
                {
                    ApplicationArea = Basic;
                }
                field("Priority Level";"Priority Level")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Departmental Clearance Users")
            {
                ApplicationArea = Basic;
                Caption = 'Departmental Clearance Users';
                Image = ApprovalSetup;
                Promoted = true;
                PromotedIsBig = true;
                RunObject = Page "ACA-Clearance Dept. Approvers";
                RunPageLink = "Clearance Level Code"=field("Clearance Level Code"),
                              Department=field(Department);
            }
        }
    }
}

