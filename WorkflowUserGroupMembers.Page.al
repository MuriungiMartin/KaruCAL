#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1532 "Workflow User Group Members"
{
    Caption = 'Workflow User Group Members';
    PageType = ListPart;
    SourceTable = "Workflow User Group Member";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name";"User Name")
                {
                    ApplicationArea = Suite;
                    LookupPageID = "Approval User Setup";
                    ToolTip = 'Specifies the name of the workflow user.';
                }
                field("Sequence No.";"Sequence No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the order of approvers when an approval workflow involves more than one approver.';
                }
            }
        }
    }

    actions
    {
    }
}

