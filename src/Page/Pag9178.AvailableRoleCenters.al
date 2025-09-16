#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9178 "Available Role Centers"
{
    Caption = 'Available Role Centers';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    ShowFilter = true;
    SourceTable = "Profile";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description;Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the Role Center.';
                }
            }
        }
    }

    actions
    {
    }
}

