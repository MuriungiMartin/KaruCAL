#pragma warning disable AA0005, AA0008, AA0018, AA0021, AA0072, AA0137, AA0201, AA0204, AA0206, AA0218, AA0228, AL0254, AL0424, AS0011, AW0006 // ForNAV settings
Page 9190 "Delete Profile Configuration"
{
    ApplicationArea = Basic;
    Caption = 'Delete Profile Configuration';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Profile Metadata";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1106000000)
            {
                field("Profile ID";"Profile ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Profile ID';
                    ToolTip = 'Specifies the profile for which the customization has been created.';
                }
                field("Page ID";"Page ID")
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Page ID';
                    ToolTip = 'Specifies the number of the page object that has been configured.';
                }
                field(Description;Description)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the customization.';
                }
                field(Date;Date)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Date';
                    ToolTip = 'Specifies the date of the customization.';
                }
                field(Time;Time)
                {
                    ApplicationArea = Basic,Suite;
                    Caption = 'Time';
                    ToolTip = 'Specifies a timestamp for the customization.';
                }
            }
        }
    }

    actions
    {
    }
}

