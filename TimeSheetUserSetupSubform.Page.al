#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 1825 "Time Sheet User Setup Subform"
{
    Caption = 'Time Sheet User Setup Subform';
    PageType = ListPart;
    SourceTable = "User Setup";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies the user.';
                }
                field("Register Time";"Register Time")
                {
                    ApplicationArea = Basic,Suite;
                    ToolTip = 'Specifies if you want to register time for this user. This is based on the time spent from when the user logs in to when the user logs out.';
                }
                field("Time Sheet Admin.";"Time Sheet Admin.")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Time Sheet Administrator';
                    ToolTip = 'Specifies if the user can edit, change, and delete time sheets.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        HideExternalUsers;
    end;
}

