#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 358 Objects
{
    Caption = 'Objects';
    Editable = false;
    PageType = List;
    SourceTable = AllObjWithCaption;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Object Type";"Object Type")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Type';
                    ToolTip = 'Specifies the object type.';
                    Visible = false;
                }
                field("Object ID";"Object ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'ID';
                    ToolTip = 'Specifies the object ID.';
                }
                field("Object Caption";"Object Caption")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Name';
                    DrillDown = false;
                    ToolTip = 'Specifies the name of the object.';
                }
                field("Object Name";"Object Name")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Object Name';
                    ToolTip = 'Specifies the name of the object.';
                    Visible = false;
                }
                field(ExtensionName;ExtensionName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Extension Name';
                    ToolTip = 'Specifies the name of the extension.';
                    Visible = false;
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
    }

    trigger OnAfterGetRecord()
    var
        NAVApp: Record "NAV App";
    begin
        ExtensionName := '';
        if IsNullGuid("App Package ID") then
          exit;
        if NAVApp.Get("App Package ID") then
          ExtensionName := NAVApp.Name;
    end;

    var
        ExtensionName: Text;
}

