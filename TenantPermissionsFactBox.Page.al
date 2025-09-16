#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9840 "Tenant Permissions FactBox"
{
    Caption = 'Tenant Permissions FactBox';
    Editable = false;
    PageType = ListPart;
    SourceTable = "Tenant Permission";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Object Type";"Object Type")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the type of the object.';
                }
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the ID of the object.';
                }
                field("Object Name";"Object Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the object.';
                }
            }
        }
    }

    actions
    {
    }
}

