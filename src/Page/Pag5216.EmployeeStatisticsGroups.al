#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 5216 "Employee Statistics Groups"
{
    ApplicationArea = Basic;
    Caption = 'Employee Statistics Groups';
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Employee Statistics Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code";Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a code for the employee statistics group.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the employee statistics group.';
                }
            }
        }
    }

    actions
    {
    }
}

