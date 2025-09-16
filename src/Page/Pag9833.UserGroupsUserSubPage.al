#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9833 "User Groups User SubPage"
{
    Caption = 'User Groups';
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "User Group Member";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Group Code";"User Group Code")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Code';
                    ToolTip = 'Specifies a user group.';
                }
                field("User Group Name";"User Group Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    ToolTip = 'Specifies the name of the user.';
                }
                field("Company Name";"Company Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the company.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Company Name" := COMPANYNAME;
    end;
}

