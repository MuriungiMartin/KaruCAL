#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9834 "User Group Permission Sets"
{
    Caption = 'User Group Permission Sets';
    PageType = List;
    SourceTable = "User Group Permission Set";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Role ID";"Role ID")
                {
                    ApplicationArea = Basic,Suite;
                    Editable = true;
                    NotBlank = true;
                    ToolTip = 'Specifies a profile.';
                }
                field("Role Name";"Role Name")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the name of the profile.';
                }
                field("App Name";AppName)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Extension Name';
                    Editable = false;
                    TableRelation = "NAV App".Name where (ID=field("App ID"));
                    ToolTip = 'Specifies the name of an extension.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        exit("Role ID" <> '');
    end;

    trigger OnModifyRecord(): Boolean
    begin
        TestField("Role ID");
    end;

    var
        AppName: Text;
}

