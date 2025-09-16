#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9191 "Delete User Personalization"
{
    ApplicationArea = Basic;
    Caption = 'Delete User Personalization';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "User Metadata";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1106000000)
            {
                field("User SID";"User SID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'User SID';
                    ToolTip = 'Specifies the security identifier (SID) of the user who performed the personalization.';
                }
                field("User ID";"User ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'User ID';
                    ToolTip = 'Specifies the user ID of the user who performed the personalization.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Page ID';
                    ToolTip = 'Specifies the number of the page object that has been personalized.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the personalization.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Date';
                    ToolTip = 'Specifies the date of the personalization.';
                }
                field(Time;Time)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Time';
                    ToolTip = 'Specifies the timestamp for the personalization.';
                }
            }
        }
    }

    actions
    {
    }
}

