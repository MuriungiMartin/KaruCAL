#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9174 "All Objects with Caption"
{
    Caption = 'All Objects with Caption';
    Editable = false;
    PageType = List;
    SourceTable = AllObjWithCaption;

    layout
    {
        area(content)
        {
            repeater(Control1102601000)
            {
                field("Object Type";"Object Type")
                {
                    ApplicationArea = All;
                    Caption = 'Object Type';
                }
                field("Object ID";"Object ID")
                {
                    ApplicationArea = All;
                    Caption = 'Object ID';
                }
                field("Object Name";"Object Name")
                {
                    ApplicationArea = All;
                    Caption = 'Object Name';
                }
                field("Object Caption";"Object Caption")
                {
                    ApplicationArea = All;
                    Caption = 'Object Caption';
                    Visible = false;
                }
                field("Object Subtype";"Object Subtype")
                {
                    ApplicationArea = All;
                    Caption = 'Object Subtype';
                }
            }
        }
    }

    actions
    {
    }
}

